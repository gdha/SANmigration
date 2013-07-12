#################
# LVM FUNCTIONS #
#################
function _convert_lvmtab_to_ascii
{
	if [[ -f /etc/lvmtab ]]; then
		# LVM 1
		_note "Saved /etc/lvmtab as $TMPDIR/lvmtab.out"
		strings /etc/lvmtab > $TMPDIR/lvmtab.out
	fi
	if [[ -f /etc/lvmtab_p ]]; then
		# LVM 2
		_note "Saved /etc/lvmtab_p as $TMPDIR/lvmtab.out"
		strings /etc/lvmtab_p >> $TMPDIR/lvmtab.out
	fi
	[[ ! -f /etc/lvmtab ]] && [[ ! -f /etc/lvmtab_p ]] && \
		_error "File /etc/lvmtab[_p] not present. Nothing to do."
}

function _save_lvmpvg
{
	if [[ -f /etc/lvmpvg ]]; then
		_note "Saved /etc/lvmpvg as $TMPDIR/lvmpvg.out"
		cp /etc/lvmpvg $TMPDIR/lvmpvg.out
	else
		_note "No Physical Volume Groups (PVGs) active on system $(hostname)"
	fi
}

function _collect_pvinfo
{
	cat - >> $SANCONF <<-EOD
	# Syntax:
	# pv=/dev/disk/disk10;vg_name;io_timeout;autoswitch;load_bal_policy;queue_depth
	EOD
	for rdisk in $(grep -e '^dev=' $SANCONF | cut -d";" -f1 | cut -d= -f2)
	do
		disk=$(_disk_name $rdisk)
		_note "Analyzing physical volume $disk"
		## -F doesn't exist on 11.23
		##pvdisplay -F $disk > $TMPDIR/pv.out 2>/dev/null || continue	# we skip this disk
		pvdisplay $disk > $TMPDIR/pv.out 2>/dev/null || continue	# we skip this disk
		vg_name=$(grep "^VG Name" $TMPDIR/pv.out | awk '{print $3}')
		# check if the vg_name is in use, if not we skip the disk
		grep -q "$vg_name"  $TMPDIR/lvmtab.out || continue
		io_timeout=$(grep -i "^IO Timeout" $TMPDIR/pv.out | cut -c29- | awk '{print $1}')
		autoswitch=$(grep -i "^Autoswitch" $TMPDIR/pv.out | awk '{print $2}')
		load_bal_policy=$(_load_bal_policy $rdisk)
		queue_depth=$(_get_queue_depth $rdisk)
		echo "pv=$disk;$vg_name;$io_timeout;$autoswitch;$load_bal_policy;$queue_depth" >> $SANCONF
	done
}

function _collect_vginfo
{
	cat - >> $SANCONF <<-EOD
	# Syntax:
	# vg=/dev/vg_name;VGmajornr;VGminornr;max_lv;pe_size;max_pv;max_pe;PVG:[name];/dev/disk/disk1;PVG:[name];/dev/disk/disk2
	EOD
	for vgname in $(vgdisplay 2>/dev/null |grep "^VG Name"|grep -v vg00|awk '{print $3}')
	do
		# only go over active VGs and exclude vg00
		_note "Analyzing Volume group $vgname"
		TMPfile=$TMPDIR/$(_short_devname $vgname).out	# will contain all info about vgname
		# FIXME '-F' option doesn't exist on 11.11 nor 11.23
		##vgdisplay -vF $vgname > $TMPfile 2>/dev/null
		vgdisplay -v $vgname > $TMPfile 2>/dev/null
		VGmajornr=$(ls -l ${vgname}/group  | awk '{print $5}')
		VGminornr=$(ls -l ${vgname}/group  | awk '{print $6}')
		max_lv=$(grep "^Max LV" $TMPfile   | cut -c20- | awk '{print $1}')
		pe_size=$(grep "^PE Size" $TMPfile | cut -c20- | awk '{print $1}')
		max_pv=$(grep "^Max PV" $TMPfile   | cut -c20- | awk '{print $1}')
		max_pe=$(grep "^Max PE" $TMPfile   | cut -c20- | awk '{print $1}')
		# now we need to build the disk list including PVG names (if any)
		disklist=""
		# write the PVG part to a file (exec once per VGname)
		awk '/Physical volume groups/,EOF {print}' $TMPfile > $TMPDIR/PVGinfo.out
		for disk in $(grep "PV Name" $TMPfile | cut -c20- | awk '{print $1}' | sort -u)
		do
			# we need to check if $disk belongs to a PVG group
			pvg_name=$(_get_pvgname $TMPDIR/PVGinfo.out $disk)
			disklist="${disklist};PVG:${pvg_name};$disk"
		done

		echo "vg=${vgname};${VGmajornr};${VGminornr};${max_lv};${pe_size};${max_pv};${max_pe}${disklist}" >> $SANCONF
	done
}

function _collect_lvinfo
{
	cat - >> $SANCONF <<-EOD
	# Syntax:
	# lv=/dev/vg_name/lvol1;mirror_cp;lv_size;le_size;stripes;stripe_size;bad_block;allocation;[pvg_name]
	EOD
	for vgname in $(vgdisplay 2>/dev/null |grep "^VG Name"|grep -v vg00|awk '{print $3}')
	do
		# only going deeper into lvols on active VGs and exclude vg00
		TMPvg=$TMPDIR/$(_short_devname $vgname).out	# which already exists (made by _collect_vginfo)
		# write the PVG and disks to temporary file $TMPDIR/PVGinfo.out
		awk '/Physical volume groups/,EOF {print}' $TMPvg > $TMPDIR/PVGinfo.out
		for lvname in $(grep "LV Name" $TMPvg | cut -c20- | awk '{print $1}')
		do
			_note "Analyzing logical Volume $lvname"
			TMPlvol=$TMPDIR/$(_short_devname $lvname).out
			##lvdisplay -vF $lvname > $TMPlvol 2>/dev/null
			lvdisplay -v $lvname > $TMPlvol 2>/dev/null
			mirror_cp=$(grep "^Mirror copies" $TMPlvol | cut -c25- | awk '{print $1}')
			lv_size=$(grep "^LV Size" $TMPlvol | cut -c25- | awk '{print $1}')
			le_size=$(grep "^Current LE" $TMPlvol | cut -c25- | awk '{print $1}')
			stripes=$(grep "^Stripes " $TMPlvol | cut -c25- | awk '{print $1}')
			stripe_size=$(grep "^Stripe Size" $TMPlvol | cut -c25- | awk '{print $1}')
			bad_block=$(grep "^Bad block" $TMPlvol | cut -c25- | awk '{print $1}')
			allocation=$(grep "^Allocation" $TMPlvol | cut -c25- | awk '{print $1}')
			# now we need to build the disk list excluding PVG names (if any)
			disklist=""
			for disk in $( awk '/'"Distribution of logical volume"'/,/'"Logical extents"'/ \
			    {if ($0 !~ "Distribution of logical volume" && $0 !~ "Logical extents") print}' \
			    $TMPlvol | grep -v "PV Name" | awk '{print $1}')
			do
				# we assume that all disk in 1 lvol belong to the same PVG (if any)
				pvg_name=$(_get_pvgname $TMPDIR/PVGinfo.out "$disk")
				_debug "lv=${lvname};disk=${disk};allocation=${allocation};pvg_name=${pvg_name}"
				# FIXME: if allocation="strict" - no pvg_name should be defined!!
				if [[ "${allocation}" = "strict" ]] && [[ ! -z "${pvg_name}" ]]; then
					# Ouch! We found a serious misconfigured VG/LV setup
					# strict allocation do not go together with physical volume groups!
					_warn "Disk $disk is part of PVG ${pvg_name}, but allocation is ${allocation}"
					# we will remove the pvg_name due to strict allocation policy
					pvg_name=""
				fi
			done
			echo "lv=${lvname};${mirror_cp};${lv_size};${le_size};${stripes};${stripe_size};${bad_block};${allocation};${pvg_name}" >> $SANCONF
		done
	done
}

function _collect_fsinfo
{
	cat - >> $SANCONF <<-EOD
	# Syntax:
	# fs=mount_point;lvname;fstype;mount_options;bsize;owner;group;perm_mode;mounted_by
	EOD
	for lvname in  $(grep -e '^lv=' $SANCONF | cut -d";" -f1 | cut -d= -f2)
	do
		mount_point=$(_get_mount_point $lvname)
		_note "Analyzing mount point $mount_point (lvol $lvname)"
		fstype=$(_fstyp $lvname)
		bsize=$(_get_block_size $lvname)
		owner=$(ls -ld $mount_point 2>/dev/null | awk '{print $3}')
		[[ -z "${owner}" ]] && owner=root
		group=$(ls -ld $mount_point 2>/dev/null | awk '{print $4}')
		[[ -z "${group}" ]] && group=root
		perm_mode=$(_extract_mode $mount_point)
		mount_options=$(_get_mount_options $lvname)
		mounted_by=$(_get_mounted_by $lvname)	# fstab, sg or none
		echo "fs=${mount_point};${lvname};${fstype};${mount_options};${bsize};${owner};${group};${perm_mode};${mounted_by}" >> $SANCONF
	done
}

function _fstyp
{
	# input is /dev/vg_name/lvol; output is either 'vxfs', 'hfs', 'cachefs' or 'unknown'
	typeset FStyp=$(fstyp $1 2>/dev/null)
	[[ -z "${FStyp}" ]] && FStyp="unknown"
	echo ${FStyp}
}

function _get_block_size
{
	# input is lvol; output is an integer (in bytes; block size for mkfs command)
	typeset bsize
	bsize=$(fstyp -v $1 2>/dev/null | grep "f_frsize" | awk '{print $2}')
	bsize=$(_isnum $bsize)	# if 0 then bsize was not numeric
	[[ $bsize -eq 0 ]] && bsize=1024	# make it default value (1024)
	echo $bsize
}

function _get_mount_point
{
	# input is lvol; output is its corresponding mount point (if any)
	# check if lvol is mounted
	typeset lvol=$1
	mountpt=$(mount -p | grep "^${lvol}" | head -1 | awk '{print $2}')
	if [[ ! -d ${mountpt} ]]; then
		# lvol was not mounted; check fstab file as last resort
		mountpt=$(grep "${lvol}" /etc/fstab | awk '{print $2}')
		if [[ ${mountpt} = "." ]]; then
			# could be a swap device
			swapinfo | grep -q  "${lvol}$" && mountpt="swap"
		elif [[ ! -d ${mountpt} ]]; then
			mountpt=$(mktemp -p noname)
			mkdir -m 755 $mountpt
		fi
	fi
	echo $mountpt
}

function _get_mount_options
{
	# input is lvol; output are mount options
	typeset lvol=$1
	mntopt=$(mount -p | grep "^${lvol}" | head -1 | awk '{print $4}')
	mntopt=${mntopt%,*}	# remove ",dev=40060002" alike stuff
	mntopt=${mntopt#*,}	# remove "ioerror=mwdisable," stuff
	[[ -z "${mntopt}" ]] && mntopt="nolargefiles"	# default value anyway
	echo ${mntopt}
}

function _get_mounted_by
{
	# input is lvol; output is "fstab", "sg" or "none"
	typeset mntby="none"
	typeset lvol=$1
	grep -q "^${lvol}" /etc/fstab 2>/dev/null && mntby="fstab"
	grep -q "${lvol}" /etc/cmcluster/*/*.conf 2>/dev/null && mntby="sg"
	echo "$mntby"
}

function _is_filesystem_exported
{
	# input is "file system mount point name"
	# output is 0 if exported; 1 otherwise
	typeset OUTfile=$TMPDIR/outputfile
	typeset ERRfile=$TMPDIR/errorfile
	[[ ! -f $OUTfile ]] && showmount -e 1>$OUTfile 2>$ERRfile
	# if we get "RPC: Program not registered" nothing is NFS exported anyway
	grep -q "RPC: Program not registered" $ERRfile && return 1
	grep -q "^${1}" $OUTfile && return 0
	return 1
}

function _fuser_lvol
{
	# to be executed after an error occured while trying to umount a file system
	# arg1 lvol
	_warn "Could NOT umount $1"
	_note "Exec: fuser -ku $1"
	fuser -ku $1 && return 0 || return 1
}

function _get_pvgname
{
	# find the proper PVG Name of the disk, if any, of course
	# input: arg1: file; arg2: disk
	# output: pvgname
	typeset pvgname=""
	grep -q "${2}$" $1
	if [[ $? -eq 0 ]]; then
		# disk belongs to a PVG; now select the correct one
		cat $1 | while read Line
		do
			echo $Line | grep -q "PVG Name" && pvgname=$(echo $Line | awk '{print $3}')
			echo $Line | grep -q "$2"	&& break
		done
	fi
	echo $pvgname
}
