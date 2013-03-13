function _populate_script_header
{
	cat - > $SCRIPT <<-EOD
	#!/bin/ksh
	# Script ${SCRIPT##*/} was created by $PRGNAME
	# on $(_date) $(_time)
	#
	##############
	# Parameters #
	##############

	typeset -x PRGNAME=\${0##*/}
	typeset -x ARGS="\$@"                                    # the script arguments
	[[ -z "\$ARGS" ]] && ARGS="default values"               # is used in the header

	typeset -x PRGDIR=\${0%/*} 
	[[ \$PRGDIR = /* ]] || PRGDIR=\$(pwd)
	
	typeset -x PATH=/usr/local/CPR/bin:/sbin:/usr/sbin:/usr/bin:/usr/xpg4/bin:$PATH:/usr/ucb:.
	typeset -r platform=\$(uname -s)
	typeset -r model=\$(uname -m)                            # Model
	typeset -r HOSTNAME=\$(uname -n)                         # hostname
	typeset os=\$(uname -r); os=\${os#B.} 
	typeset -r dlog=/var/adm/install-logs
	typeset instlog=\$dlog/\${PRGNAME%???}-\$(date '+%Y-%b-%d')-\$(date '+%Hh%Mm').scriptlog
	typeset -x SANCONF="/tmp/SAN_layout_of_\$(hostname).conf"
	typeset XPINFO="xpinfo"
	typeset -x KEEPTMPDIR=0
	typeset -r ERRFILE=/tmp/ERRFILE-\${PRGNAME%???}-\$$       # temporary file to keep track of erros (in functions)
	typeset -x EXITCODE=0                                     # the exitcode variable to keep track of the #errors

	#############
	# FUNCTIONS #
	#############

	# Read the shell functions
	if [ ! -d \$PRGDIR/shlib ]; then
		echo "ERROR: Cannot find \$PRGDIR/shlib directory - where are my functions?"
		exit 1
	fi
	for func in \$(ls \$PRGDIR/shlib)
	do
		. \$PRGDIR/shlib/\$func
	done

	################
	### M A I N  ###
	################

	while [ \$# -gt 0 ]; do
	case "\$1" in
		-f)	SANCONF=\$2
			_is_var_empty "\$SANCONF"
			shift 2
			;;
		-k)	KEEPTMPDIR=1
			shift 1
			;;
		*)	_show_help_\${PRGNAME%%_*}
			;;
	esac
	done

	{	# brace needed as we log everything in "instlog"
	touch \$ERRFILE                  # touch the (empty) error file
	_banner "Exec the SAN creation script (\$(basename \$0))"
	_whoami
	_check_sanconf || _show_help_\${PRGNAME%%_*}
	_osrevision
	_create_temp_dir

	EOD
}

function _add_tailer_to_script
{
	cat - >> $SCRIPT <<-EOD
	echo \$EXITCODE > \$ERRFILE
	} 2>&1 | tee \$instlog # tee is used in case of interactive run.

	################# done with main script ###################

	[ -f \$ERRFILE ] && EXITCODE=\$(cat \$ERRFILE)
	# cleanup errfile
	rm -f \$ERRFILE

	# Final notification
	case \$EXITCODE in
		0)      msg="No errors were encountered by \$PRGNAME on \$HOSTNAME"
			_note \$msg
			;;
		*)      msg="Oops - \$EXITCODE error(s) were encounterd by \$PRGNAME on \$HOSTNAME"
			_error \$msg
			;;
	esac

	# exit with exitcode from errfile
	exit \$EXITCODE

	EOD
}

function _check_if_vgexport_is_required
{
	typeset -i i=0
	# check if vgexport was already performed
	i=$(vgdisplay 2>/dev/null |grep "^VG Name"|grep -v vg00|awk '{print $3}' | wc -l)
	[[ $i -eq 0 ]] && {
		_note "All non-vg00 Volume Groups are correctly exported"
		return
		}

	# so there are still SAN VGs presented
	_warn "There are still non-vg00 Volume Groups active:"
	vgdisplay 2>/dev/null |grep "^VG Name"|grep -v vg00|awk '{print $3}'
	_askYN N "Shall we add vgexport command(s) to $(basename $SCRIPT)"
	if [[ $? -eq 0 ]]; then
		_record_answer "N"
		_error "Please vgexport manually, then rerun $PRGNAME"
	else
		_record_answer "Y"
	fi

	for vgname in $(vgdisplay 2>/dev/null |grep "^VG Name"|grep -v vg00|awk '{print $3}')
	do
		# check if something is mounted
		for lvol in $(grep "^fs=" $SANCONF | grep "$vgname" | cut -d";" -f2)
		do
			# check if fs was exported or not
			fs=$(grep ";${lvol};" $SANCONF | cut -d";" -f1 | cut -d= -f2)
			_is_filesystem_exported "$fs" && _add_exportfs_line "${fs}"
			mount -p | grep -q "$lvol" && _add_umount_line "${lvol}"
		done
		
		# now add deactivate vgchange lines
		_add_deactivate_vg_line $vgname
		# now add vgexport lines
		_add_vgexport_line $vgname
	done
}

function _add_exportfs_line
{
	# arg1: fs
	cat - >> $SCRIPT <<-EOD
	_note "Exec: exportfs -uv $1"
	exportfs -uv $1
	_check_rc \$? "exportfs -uv $1 failed. Do you want to continue"

	EOD
}

function _add_umount_line
{
	# arg1 lvol
	cat - >> $SCRIPT <<-EOD
	_note "Exec: umount $1"
	umount $1
	if [[ \$? -gt 0 ]]; then
		_fuser_lvol $1
		if [[ \$? -eq 0 ]]; then
			_note "Exec: retry umount $1"
			umount $1
			_check_rc \$? "umount $1 failed. Do you want to continue"
		else
			_check_rc \$? "fuser $1 failed. Do you want to continue"
		fi
	fi

	EOD
}

function _add_vgexport_line
{
	# arg1 vgname ($1)
	cat - >> $SCRIPT <<-EOD
	_note "vgexport -m \$TMPDIR/${1##*/}.mapfile -f \$TMPDIR/${1##*/}.outfile  $1"
	vgexport -m \$TMPDIR/${1##*/}.mapfile -f \$TMPDIR/${1##*/}.outfile  $1
	_check_rc \$? "vgexport of $1 failed. Do you want to continue"

	EOD
}

function _add_deactivate_vg_line
{
	# arg1 vgname
	cat - >> $SCRIPT <<-EOD
	_note "Exec: vgchange -a n $1"
	vgchange -a n $1
	_check_rc \$? "vgchange -a n $1 failed. Do you want to continue"

	EOD
}

function _check_rc
{
	# arg1 Return Code from command; arg2 "the string to display"
	if [[ $1 -gt 0 ]]; then
		_askYN N "$2"
		if [[ $? -eq 0 ]]; then
			_record_answer "N"
			_note "Fix the error and retry..."
			EXITCODE=$((EXITCODE + 1))	# count the amount of errors
			echo $EXITCODE > $ERRFILE
			exit 1
		else
			_record_answer "Y"
		fi
	fi
}

function _add_save_lvmtab_to_script
{
	# no arguments required
	cat - >> $SCRIPT <<-EOD
	_convert_lvmtab_to_ascii

	EOD
}

function _find_corresponding_new_disk
{
	# input arg1: old_disk; output new_disk (both raw devices)
	# uses the diskmap for it
	typeset DSKMAP=$TMPDIR/diskmap
	[[ ! -f $DSKMAP ]] && _error "Need the $DSKMAP file to find corresponding disk"
	typeset old_disk=$1
	new_disk=$(grep "^$old_disk " $DSKMAP | awk '{print $2}')
	[[ -z "$new_disk" ]] && _error "Did not found a corresponding disk for $old_disk"
	echo $new_disk
}

function _add_pvcreate_disks_to_script
{
	# will add lines to SCRIPT to pvcreate the disks found in SANCONF
	# we will first check if the disk is not in use
	for old_disk in $(grep "^dev=" $SANCONF | cut -d";" -f1 | cut -d= -f2)
	do
		new_disk=$(_find_corresponding_new_disk $old_disk)
		# before adding the code - verify if new_disk is a character device
		[[ ! -c $new_disk ]] && _error "Device $new_disk was not found on system $HOSTNAME"
		cat - >> $SCRIPT <<-EOD
		# safety check on disk - still in use or not
		_disk_in_use $new_disk || _check_rc \$? "Do you really want to pvcreate disk $new_disk"
		_note "Exec: pvcreate -f $new_disk"
		pvcreate -f $new_disk
		_check_rc \$? "pvcreate -f $new_disk failed. Do you want to continue"

		EOD
	done
}

function _add_vgcreate_vgs_to_script
{
	typeset -i i j count
	typeset wd old_rdisk new_rdisk

	# will add lines to SCRIPT to vgcreate our VGs found in SANCONF
	for vgline in $(grep "^vg=" $SANCONF)
	do
		set -A VGarray			# define an empty array
		i=0	# used to fill array (re-use VGarray for each vg found in SANCONF)
		# grab all the items from SANCONF for this vgname and stuff it into VGarray
		for wd in $(echo $vgline | tr ';' '\n') # wd contains word without ;
		do
			VGarray[$i]="$wd"
			i=$((i+1))
		done
		count=${#VGarray[@]}		# amount of values in array
		count=$((count-1))		# as we 0 too
		# VGarray[0]="vg=vgname"	VGarray[1]="majnr"	VGarray[2]="minnr"
		# VGarray[3]="max_lv"		VGarray[4]="pe_size"	VGarray[5]="max_pv"
		# VGarray[6]="max_pe"		VGarray[7]="pvg_name"	VGarray[8]="disk"
		# VGarray[9]="pvg_name"		VGarray[10]="disk"	...
		vgname=${VGarray[0]##*=}	# remove vg=
		_note "######## $vgname #########"
		_add_mkdir_line $vgname
		_add_mknod_line $vgname ${VGarray[1]} ${VGarray[2]}
		_add_check_unique_vg_minornr ${VGarray[2]}
		old_rdisk="/dev/r"${VGarray[8]#/dev/*} # convert block to raw device
		new_rdisk=$(_find_corresponding_new_disk $old_rdisk)	# via diskmap file
		[[ ! -c $new_rdisk ]] && _error "Device $new_rdisk not found on system $HOSTNAME"
		_add_vgcreate_line $vgname ${VGarray[3]} ${VGarray[4]} ${VGarray[5]} ${VGarray[6]} ${VGarray[7]} $(_disk_name ${new_rdisk})
		j=9
		while [ $j -le $count ];
		do
			pvg_name=${VGarray[j]}	# odd nr
			j=$((j+1))
			old_rdisk="/dev/r"${VGarray[j]#/dev/*}	# even nr (convert block to raw dev)
			new_rdisk=$(_find_corresponding_new_disk $old_rdisk)
			[[ ! -c $new_rdisk ]] && _error "Device $new_rdisk not found on system $HOSTNAME"
			j=$((j+1))
			_add_vgextend_line $vgname $pvg_name $(_disk_name ${new_rdisk})
		done
		unset VGarray	# get rid of array
	done
}

function _add_mkdir_line
{
	# input arg1: $vgname
	# dir /dev/vgname should  not  exist (if we choose to vgexport it). However,maybe you skipped it
	cat - >> $SCRIPT <<-EOD
	####### $1 ######
	# check dir
	if [[ -d $1 ]]; then
		_note "Directory $1 already exist"
	else
		_note "Exec: mkdir -p -m 755 $1"
		mkdir -p -m 755 $1
		_check_rc \$? "mkdir failed of ${1}. Do you want to continue"
	fi
	chown root:sys $1

	EOD
}

function _add_mknod_line
{
	# input arg1:vgname, arg2:majnr, arg3:minnr
	typeset vgname=$1
	typeset majnr=$2
	typeset minnr=$3
	cat - >> $SCRIPT <<-EOD
	# check the group file
	if [[ -f ${vgname}/group ]]; then
		# read the nrs of existing group file
		VGmajornr=\$(ls -l ${vgname}/group | awk '{print \$5}')
		VGminornr=\$(ls -l ${vgname}/group | awk '{print \$6}')
		[[ "\$VGmajornr" != "${majnr}" ]] && _error "The requested major number (${majnr}) does not match found \$VGmajornr"
		[[ "\$VGminornr" != "${minnr}" ]] && _error "The requested minor nr (${minnr}) does not match found \$VGminornr"
		_note "The $vgname/group already existed with major nr (\$VGmajornr) and minor nr (\$VGminornr)"
	else
		_note "Exec: mknod ${vgname}/group c ${majnr} ${minnr}"
		mknod ${vgname}/group c ${majnr} ${minnr}
		_check_rc \$? "mknod ${vgname}/group failed. Do you want to continue"
		_note "Created $vgname/group with major nr ($majnr) and minor nr ($minnr)"
	fi

	EOD
}

function _add_check_unique_vg_minornr
{
	# input arg1: minornr
	cat - >> $SCRIPT <<-EOD
	# check if minornr is unique
	[[ \$(ls -l /dev/*/group | grep "$1" | wc -l) -ne 1 ]] && _error "Sorry, the VG minor nr ($1) is not unique"

	EOD
}

function _add_vgcreate_line
{
	# input arg1:vgname, arg2:"max_lv", arg3:"pe_size", arg4:"max_pv", arg5:"max_pe"
	# input arg6:"pvg_name" arg7:"disk"
	# note arg6 contains "PVG:" when no PVG is needed, or "PVG:pvg_name"
	typeset pvg_name
	pvg_name=${6##*:}
	[[ ! -z "$pvg_name" ]] && opts="-g $pvg_name" || opts=""
	_note "Adding vgcreate line (vgcreate -l $2 -s $3 -p $4 -e $5 $opts $1 $7)"
	cat - >> $SCRIPT <<-EOD
	_note "vgcreate -l $2 -s $3 -p $4 -e $5 $opts $1 $7"
	vgcreate -l $2 -s $3 -p $4 -e $5 $opts $1 $7
	_check_rc \$? "vgcreate of $1 failed. Do you want to continue"

	EOD
}

function _add_vgextend_line
{
	# input arg1:$vgname arg2:$pvg_name arg3:$disk
	typeset pvg_name
	pvg_name=${2##*:}
	[[ -z "$3" ]] && return		# no disk, no vgextend
	[[ ! -z "$pvg_name" ]] && opts="-g $pvg_name" || opts=""
	_note "Adding vgextend line (vgextend $opts $1 ${3})"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: vgextend $opts $1 ${3}"
	vgextend $opts $1 ${3}
	_check_rc \$? "vgextend $opts $1 ${3} failed. Do you want to continue"

	EOD
}

function _add_lvcreate_lv_to_script
{
	typeset lvol wd
	typeset -i count i
	# we will add lines to our SCRIPT to create all necessary lvols
	#lv=/dev/vg_RJ7/lv_oracleRJ7_sapdata1;0;101376;3168;0;0;on;PVG-strict,distributed;PVG001
	for lvline in $(grep "^lv=" $SANCONF)
	do
		set -A LVarray
		i=0
		for wd in $(echo $lvline | tr ';' '\n') # wd contains word without ;
		do

			LVarray[$i]="$wd"
			i=$((i+1))

		done
		count=${#LVarray[@]}			# amount of values in array
		count=$((count-1)) 
		# LVarray[0]=lv=lvol	LVarray[1]=mirror_copy	LVarray[2]=lv_size
		# LVarray[3]=le_size	LVarray[4]=stripes	LVarray[5]=stripe_size
		# LVarray[6]=bad_block	LVarray[7]=allocation	LVarray[8]=pvg_name

		lvol=${LVarray[0]##*=}			# remove lv=
		lvname=${lvol##*/}			# remove /dev/vgname/
		vgname=${lvol%/*}			# /dev/vgname
		opts=""
		[[ "${LVarray[6]}" = "NONE" ]] && opts="$opts -r N"
		echo ${LVarray[7]} | grep -q "distributed" && opts="$opts -D y"
		echo ${LVarray[7]} | grep -q "PVG-strict" && opts="$opts -s g"

		_add_lvcreate_line $lvname $vgname "$opts"
		_add_lvextend_line $lvol ${LVarray[3]} ${LVarray[8]}

		unset LVarray
	done
}

function _add_lvcreate_line
{
	# arg1: lvname; arg2: vgname; arg3: opts
	_note "Adding lvcreate line (lvcreate $3 -n $1 $2)"
	cat - >> $SCRIPT <<-EOD
	# Lvol $2/$1
	_note "Exec: lvcreate $3 -n $1 $2"
	lvcreate $3 -n $1 $2
	_check_rc \$? "lvcreate failed of ${2}/${1}. Do you want to continue"

	EOD
}

function _add_lvextend_line
{
	# arg1: /dev/vgname/lvol ; arg2: le_size; arg3: pvg_name (can be empty)
	_note "Adding lvextend line (lvextend -l $2 $1 $3)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: lvextend -l $2 $1 $3"
	lvextend -l $2 $1 $3 2>\$TMPDIR/lvextend.err
	rc=\$?
	grep -q "Not enough free physical extents available" \$TMPDIR/lvextend.err && TrySmallerLE=1 || TrySmallerLE=0
	if [[ \$TrySmallerLE = 1 ]]; then
		_lvextend_with_reduced_le_number $1 $2 $3
	else
		_check_rc \$rc "lvextend failed of ${1}. Do you want to continue"
	fi

	EOD
}

function _lvextend_with_reduced_le_number
{
	# arg1: /dev/vgname/lvol ; arg2: le_size; arg3: pvg_name (can be empty)
	# le_size was too big; retry with 8 less, and so on
	typeset le_size=$2
	typeset lvol=$1
	typeset pvgname=$3
	if [[ $le_size -le 8 ]]; then
		_check_rc 1 "lvextend failed of ${lvol} - le_size ($le_size) cannot be lower than 8. Do you want to continue"
		return
	fi
	old_le_size=$le_size
	while true
	do
		# a bit tricky this loop - hope we can escape
		le_size=$((le_size - 8))
		if [[ $le_size -lt 6 ]]; then
			_check_rc 1 "lvextend failed of ${lvol} - le_size ($le_size) cannot be lower than 6. Do you want to continue"
			break
		fi
		lvextend -l $le_size $lvol  $pvgname 2>$TMPDIR/lvextend.err
		rc=$?
		grep -q "Not enough free physical extents available" $TMPDIR/lvextend.err || {
			# lvextend succeeded?
			if [[ $rc -eq 0 ]]; then
				_warn "Lvol $lvol successfully extended with le_size $le_size (smaller then the requested $old_le_size)"
				break	# successfull lvextend
			else
				_check_rc $rc "lvextend failed of ${lvol} with reduced le_size ($le_size). Do you want to continue"
				break
			fi
			}
	done
}

function _add_mkfs_fs_to_script
{
	# Add mkfs lines to our SCRIPT
	# fs=/test;/dev/vg_test/lvol1;vxfs;ioerror=mwdisable,largefiles,mincache=direct,delaylog,nodatainlog,convosync=direct;1024;gdhaese1;root;755;fstab
	# 
	for fsline in $(grep "^fs=" $SANCONF)
	do
		set -A FSarray
		i=0
		for wd in $(echo $fsline | tr ';' '\n') # wd contains word without ;
		do
			FSarray[$i]="$wd"
			i=$((i+1))
		done
                count=${#FSarray[@]}			# amount of values in array
		count=$((count-1))
		# FSarray[0]=fs=/fs	FSarray[1]=/dev/vgname/lvol	FSarray[2]=FStype
		# FSarray[3]=options	FSarray[4]=bsize		FSarray[5]=owner
		# FSarray[6]=group	FSarray[7]=perm-mode		FSarray[8]=[fstab|sg]

		fs=${FSarray[0]##*=}			# remove fs=
		lvname=${FSarray[1]##*/}		# remove /dev/vgname/
		vgname=${FSarray[1]%/*}			# /dev/vgname
		rlvol="${vgname}/r${lvname}"		# /dev/vgname/rlvol
		opts=""
		echo ${FSarray[3]} | grep -q "largefiles" && opts="-o largefiles"
		# FIXME: options logsize and version are not checked

		_add_mkfs_line ${FSarray[2]} ${FSarray[4]} "${opts}" ${rlvol}
		_add_mkdir_line $fs
		_add_chmod_line $fs ${FSarray[7]}
		_add_chown_line $fs ${FSarray[5]}
		_add_chgrp_line $fs ${FSarray[6]}
		# FIXME: adding line to $TMPDIR/fstab file (${FSarray[8]}) if "fstab"
		# FIXME: or print warn if "sg" to add in package configuration file
		unset FSarray
	done
}

function _add_mkfs_line
{
	# arg1: FStype; arg2: bsize; arg3: options; arg4: rlvol
	_note "Adding mkfs line (mkfs -F $1 -o bsize=$2 $3 $4)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: mkfs -F $1 -o bsize=$2 $3 $4"
	mkfs -F $1 -o bsize=$2 $3 $4
	_check_rc \$? "mkfs failed of ${4}. Do you want to continue"

	EOD
}

function _add_chmod_line
{
	# arg1: fs; arg2: permission-mode (in nrs)
	_note "Adding chmod line (chmod $2 $1)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: chmod $2 $1"
	chmod $2 $1
	_check_rc \$? "chmod failed of ${1}. Do you want to continue"

	EOD
}

function _add_chown_line
{
	# arg1: fs; arg2: owner
	_note "Adding chown line (chown $2 $1)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: chown $2 $1"
	chown $2 $1
	_check_rc \$? "chown failed of ${1}. Do you want to continue"

	EOD
}

function _add_chgrp_line
{
	# arg1: fs; arg2: group
	_note "Adding chgrp line (chgrp $2 $1)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: chgrp $2 $1"
	chgrp $2 $1
	_check_rc \$? "chgrp failed of ${1}. Do you want to continue"

	EOD
}

function _add_post_config_of_devs_to_script
{
	# add pvchange, scsimgr, scsictl lines to our SCRIPT
	for pvline in $(grep "^pv=" $SANCONF)
	do

		set -A PVarray
		i=0
		for wd in $(echo $pvline | tr ';' '\n') # wd contains word without ;
		do

			PVarray[$i]="$wd"
			i=$((i+1))

		done
		count=${#PVarray[@]}			# amount of values in array
		count=$((count-1))
		# PVarray[0]=pv=/dev/disk/disk1		PVarray[1]=vgname	PVarray[2]=io_timeout
		# PVarray[3]=autoswitch			PVarray[4]=load_bal_pol	PVarray[5]=queue_depth
		pv=${PVarray[0]##*=}			# remove pv= (old disk from SANCONF)
		rpv=$(_rdisk_name $pv)			# old raw disk name
		# Remember $rpv is old raw disk from SANCONF - find corresponding disk
		new_rpv=$(_find_corresponding_new_disk $rpv)    # via diskmap file
		[[ ! -c $new_rpv ]] && _error "Device $new_rpv disk not found on system $HOSTNAME"
		new_pv=$(_disk_name $new_rpv)
		pvchange_opts=""
		[[ "${PVarray[3]}" = "Off" ]] && pvchange_opts="$pvchange_opts -S n"	# default is On
		[[ "${PVarray[2]}" != "default" ]] && pvchange_opts="$pvchange_opts -t ${PVarray[2]}" # default is default
		[[ ! -z "$pvchange_opts" ]] && _add_pvchange_line $new_pv "$pvchange_opts"
		lbpol=${PVarray[4]}
		case "$os" in
			"11.31")
				# add load_bal_policy line
				_add_scsimgr_line $new_rpv $lbpol
				_add_queue_depth_line $new_rpv ${PVarray[5]}
				;;
			*)	:
				;;
		esac
		unset PVarray
	done
}

function _add_scsimgr_line
{
	# arg1: raw-dev; arg2: load_balancy_policy
	_note "Adding scsimgr line (scsimgr save_attr -D $1 -a load_bal_policy=$2)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: scsimgr save_attr -D $1 -a load_bal_policy=$2"
	scsimgr save_attr -D $1 -a load_bal_policy=$2
	_check_rc \$? "scsimgr failed for ${1}. Do you want to continue"

	EOD
}

function _add_queue_depth_line
{
	# arg1: raw-dev; arg2: queue_depth
	_note "Addinf scsictl line (scsictl -m queue_depth=$2 $1)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: scsictl -m queue_depth=$2 $1"
	scsictl -m queue_depth=$2 $1
	_check_rc \$? "scsictl failed for ${1}. Do you want to continue"

	EOD
}

function _add_pvchange_line
{
	# arg1: pv; arg2: options
	_note "Adding pvchange line (pvchange $2 $1)"
	cat - >> $SCRIPT <<-EOD
	_note "Exec: pvchange $2 $1"
	pvchange $2 $1
	_check_rc \$? "pvchange failed for ${1}. Do you want to continue"

	EOD
}

