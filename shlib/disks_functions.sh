###################
# DISKS FUNCTIONS #
###################
function _define_xpinfo_bin
{
	typeset XPINFO=$(which xpinfo)
	echo $XPINFO
}

function _capture_xpinfo_output
{
	if [[ ! -x $XPINFO ]]; then
		_error "$XPINFO not found or not executable - cannot continue!"
	fi
	_note "Saving xpinfo output as $TMPDIR/xpinfo.out"
	_wait "$XPINFO -ld"  $TMPDIR/xpinfo.out
}

function _capture_ioscan_output
{
	ioscanopts='-kfnCdisk'
	[[ "$os" = "11.31" ]] && ioscanopts='-kfnNCdisk'
	_note "Saving ioscan output of disks as $TMPDIR/ioscan.out"
	_wait "ioscan $ioscanopts" $TMPDIR/ioscan.out
}

function _diskinfo
{
	# input var (raw disk)
	typeset rdisk=$1
	diskinfo -v $rdisk |\
	grep -e 'size:' -e 'bytes per sector:' -e 'blocks per disk:' |\
	cut -d":" -f2 |\
	awk '{print $1}' |\
	tr '\nl' ';'
}

function _collect_diskinfo
{
	cat - >> $SANCONF <<-EOD
	# Syntax:
	# dev=/dev/rdisk/disk1;CU-ldev;type;sizeMB;SerialNr;RaidLevel;RaidGrp;VolMgr;sizeKB;bytes-per-sector;blocks-per-disk,santype
	EOD
	while read LINE
	do
		rdisk=$(echo $LINE | cut -d"," -f1)
		_note "Analyzing disk $rdisk"
		part2=$(echo $LINE | cut -d"," -f5-8 | sed -e 's/,/;/g')
		raidtype=$(echo $LINE | cut -d"," -f17-18 | sed -e 's/,/;/g')
		volmgr=$(echo $LINE | cut -d"," -f30)
		diskinfo=$(_diskinfo $rdisk)
		echo "dev=${rdisk};${part2};${raidtype};${volmgr};${diskinfo}xp" >> $SANCONF
	done < $TMPDIR/xpinfo.out
	# FIXME: add lines for eva and more
}

function _load_bal_policy 
{
	# input is $rdisk (/dev/rdisk/disk10); output is "load_balancy_policy" [string]
	typeset rdisk=$1
	typeset lb=""

	if [[ "$os" = "11.31" ]]; then
		lb=$(scsimgr -p get_attr all_lun -a device_file -a load_bal_policy | grep "${rdisk}:" | cut -d: -f2)
		[[ -z "$lb" ]] && lb="least_cmd_load"
	else
		# 11.23 or 11.11 then
		# FIXME: add a check to see Securepath is installed
		ps -ef | grep autopath | grep -v grep  >/dev/null
		if [[ $? -eq 0 ]]; then
			lb="SST"	# by default we set ldpolicy on SST
		else
			lb="N/A"
		fi
	fi
	echo $lb
}

function _get_queue_depth
{
	typeset rdisk=$1
	# input is $rdisk; output queue_depth number
	scsictl -akq $rdisk | awk '{print $2}'
}

function _force_ioscan_for_disks
{
	_note "Force an ioscan and search for new disks"
	ioscanopts='-fnCdisk'
	[[ "$os" = "11.31" ]] && ioscanopts='-fnNCdisk'
	_wait "ioscan $ioscanopts" "/dev/null"
}

function _force_insf_for_disks
{
	_note "Reinstalling special files for disks only"
	insf -C disk -e >/dev/null
}

function _check_sanconf
{
	[[ -f $SANCONF ]] && return 0 || return 1
}

function _building_freedisks_on_xp
{
	_note "Building the free disks list (made from xpinfo.out file)"
        while read LINE
	do
		rdisk=$(echo $LINE | cut -d"," -f1)
		_note "Analyzing disk $rdisk"
		culdev=$(echo $LINE | cut -d"," -f5)
		size=$(_diskinfo $rdisk)	# 14227200;512;28454400;
		size=${size%%;*}		# 14227200
		echo "${rdisk} ${culdev} ${size}" >> $TMPDIR/freedisks
	done < $TMPDIR/xpinfo.out
}


function _diskmapping
{
	# input file is $SANCONF; input arg1: PERCENTDEVIATION; output file is $TMPDIR/diskmap
	typeset -i pct=$1
	typeset DSKMAP=$TMPDIR/diskmap	#format: old_disk new_disk
	_note "Creating disk mapping file $DSKMAP"
	cat - > $DSKMAP <<-EOD
	# old_disk new_disk
	EOD


	# map disk from SANCONF file with exact size from the free disks file
	for old_disk in $(grep "^dev=" $SANCONF | sort -u | cut -d";" -f1 | cut -d= -f2)
	do
		# $old_disk is source disk (from previous SAN)
		old_culdev=$(grep "^dev=${old_disk};" $SANCONF | sort -u | cut -d";" -f2)
		old_size=$(grep "^dev=${old_disk};" $SANCONF | sort -u | cut -d";" -f9)
		##_find_equal_sized_disk "${old_disk}" "${old_size}"
		_find_similar_sized_disk "${old_disk}" "${old_size}" $pct
	done
	_note "Successfully created the disk mapping file $DSKMAP"
}

function _find_similar_sized_disk
{
	# find a disk of similar size (percentage x deviation allowed) in the freedisks file
	# input arg1: old_disk; arg2: old_disk_size (in Kb); arg3: percentage (of deviation allowed up/down)
	# output: $DSKMAP file
	typeset DSKMAP=$TMPDIR/diskmap
	typeset odisk="$1"
	typeset odisk_size="$2"
	typeset -i pct="$3"		# percentage var (integer value)
	typeset -i i=0
	typeset -i bup bdown		# boundaries of deviation allowed of new_size

	set -A ndisk ndisk_size
	while read ndisk[$i] junk ndisk_size[$i] 
	do
		_debug ${ndisk[i]} ${ndisk_size[i]}
		i=$((i+1))
	done < $TMPDIR/freedisks

	count=${#ndisk[@]}
	count=$((count-1))
	_debug "Amount of disks in freedisks: $count"
	i=0
	deviation=$(echo "scale=0; $odisk_size * $pct / 100" | bc)
	_debug "deviation is $deviation"
	bup=$((odisk_size + deviation))
	bdown=$((odisk_size - deviation))
	new_disk="none"
	while [ $i -lt  $count ]
	do
		_debug "i=$i odisk=$odisk odisk_size=$odisk_size bdown=$bdown ndisk[$i]=${ndisk[i]} ndisk_size[$i]=${ndisk_size[i]} bup=$bup"
		if [[ ${ndisk_size[i]} -ge $bup ]]; then
			new_disk=${ndisk[i]}
			break # escape from while loop
		elif [ ${ndisk_size[i]} -ge $bdown ] && [ ${ndisk_size[i]} -le $bup ]; then
			# $bdown <= $ndisk_size <= $bup
			new_disk=${ndisk[i]}
			break # escape from while loop
		fi
		i=$((i+1))
	done
	[[ "${new_disk}" = "none" ]] && {
		_warn "Try reducing the deviation $pct, e.g. $PRGNAME -p $((pct-1))"
		_error "No free disk left anymore with size $odisk_size kB $TMPDIR/freedisks"
		}
	_debug "diskmap pair: ${odisk} ${new_disk}"
	echo "${odisk} ${new_disk}" >> $DSKMAP
	_remove_rdisk_from_freedisks "$new_disk" || _error "Disk $new_disk not found in $TMPDIR/freedisks"
	unset ndisk ndisk_size
}

function _find_equal_sized_disk
{
	# find a disk of equal size in the freedisks file
	# input arg1: old_disk arg2: old_size
	# output: $DSKMAP file
	typeset DSKMAP=$TMPDIR/diskmap
	typeset old_disk="$1"
	typeset old_disk_size="$2"
	new_disk=$(grep "${old_disk_size}" $TMPDIR/freedisks | head -1 | awk '{print $1}') # take first free disk in list
	if [[ -z "${new_disk}" ]]; then
		new_disk="none"
		_error "No free disk left anymore with size ${old_disk_size} kB in $TMPDIR/freedisks"
	fi
	echo "${old_disk} ${new_disk}" >> $DSKMAP
	_remove_rdisk_from_freedisks "$new_disk" || _error "Disk $new_disk not found in $TMPDIR/freedisks"
}

function _remove_rdisk_from_freedisks
{
	# input arg: rdisk; output 0 for done or 1 for "not found"
	[[ -f $TMPDIR/freedisks ]] || return 1
	typeset dsk="$1"
	grep -q "^${dsk} " $TMPDIR/freedisks || return 1
	grep -v "^${dsk} " $TMPDIR/freedisks > $TMPDIR/freedisks.new
	mv -f $TMPDIR/freedisks.new $TMPDIR/freedisks
	return 0
}

function _disk_in_use
{
	# input arg1: disk-name; output: 1 if disk is still in use; otherwise 0
	typeset disk=$(_disk_name $1)	# input is raw dev, we need block dev
	grep -q "^${disk}$" $TMPDIR/lvmtab.out && return 1 || return 0
}

