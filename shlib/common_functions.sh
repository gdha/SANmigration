####################
# COMMON FUNCTIONS #
####################
function _whoami
{
if [ "$(whoami)" != "root" ]; then
	_error "$(whoami) - You must be root to run this script $PRGNAME"
fi
}

function _osrevision
{
	case $platform in
		HP-UX) : ;;
		*) _error "Script $PRGNAME does not support platform $platform" ;;
	esac
	_note "Running on $platform $os"
}

function _create_temp_dir
{
	TMPDIR=$(mktemp -p san)
	mkdir -m 700 $TMPDIR
	_note "Created temporary directory $TMPDIR"
}

function _remove_temp_dir
{
	if (( $KEEPTMPDIR )); then
		_note "Do not forget to execute \"rm -rf $TMPDIR\" afterwards."
	else
		rm -rf $TMPDIR
		_note "Removed temporary directory $TMPDIR"
	fi
}

function _remove_noname_dir
{
	# we created /tmp/noname1234 directories when lvol was found but no mntpt was found
	# we should remove these from the system again
	for dir in $(grep "/tmp/noname" $SANCONF | cut -d";" -f1 | cut -d= -f2)
	do
		[[ -d $dir ]] && rmdir $dir 2>/dev/null	# only delete empty dir
	done
}

function _is_var_empty
{
	if [ -z "$1" ]; then
		_show_help_${PRGNAME%%_*}
		EXITCODE=$((EXITCODE + 1))	# count the amount of errors
		echo $EXITCODE > $ERRFILE
		exit 1
	fi
}

function _wait
{
	typeset prg="$1"
	typeset log="$2"
	typeset -i i=0
	typeset p pid

	$prg > $log &
	pid=$!
	p=${pid%%${pid#?}} # Extract first character from the pid
	echo "Progress: \c"

	while ps -ef | grep -q "[${p}]${pid#?}";
	do
		echo "*\c"
		sleep 3
		(( i+=1 ))
		(( i % 80 == 0 )) && echo
	done

	echo
	echo "Total wait time: $(($i * 3)) second(s)"
	echo "--------------\n"
}

function _date
{
	echo $(date '+%Y-%b-%d')	# format: 2012-Aug-06
}

function _time
{
	echo $(date '+%Hh%Mm')		# format: 08h39m
}

function _check_storage_box
{
	# no input var, but we need the output of an ioscan;
	# output is either "none", "xp", "eva", "emc", ....
	# FIXME: only "xp" is defined for now
	typeset string=""

	grep -q 'OPEN-' $TMPDIR/ioscan.out 2>/dev/null && string="xp"
	grep -q 'HSV' $TMPDIR/ioscan.out 2>/dev/null && string="$string eva"
	[[ -z "$string" ]] && string="none"
	echo "$string"
}

function _init_SANCONF_file
{
	# var1: file
	typeset fn="$1"
	rm -f $fn
	cat - > $fn <<-EOD
	# SAN layout configuration file of system $(hostname)
	# created on $(_date) $(_time)
	#
	EOD
}

function _save_san_types
{
	# input variable STORAGEBOXTYPE (a string containing one or more storage box types)
	cat - >> $SANCONF <<-EOD
	# Syntax:
	# san=[single|multiple] [xp|eva|...]
	EOD
	if [[ $(echo $STORAGEBOXTYPE | wc -w) -gt 1 ]]; then
		_note "More then one storage box type in place: $STORAGEBOXTYPE"
		part1="san=multiple"
	else
		_note "Storage box in use is of type $STORAGEBOXTYPE"
		part1="san=single"
	fi
	echo "${part1} ${STORAGEBOXTYPE}" >> $SANCONF
}

function _verify_san_type_in_sanconf
{
	# input arg1: "xp", "eva", ...
	# we check if san= line contains arg1; if not _error and quit
	grep "^san=" $SANCONF | grep -q "$1" || \
		_error "The $SANCONF file doesn't contain a \"san=$1\" line"
}

function _my_grep
{
	# input arg1: "string to find" arg2: "string to be searched"
	echo "$2" | grep -q "$1"  && echo 1 || echo 0
}

function _disk_name
{
	# input is /dev/rdisk/disk1; output is /dev/disk/disk1
	typeset rdisk=$1
	typeset a b
	a=${rdisk#/dev/*}	# input /dev/rdisk/disk1; output rdisk/disk1
	b=${a%/*}		# input rdisk/disk1; output rdisk
	case $b in
		rdsk)	echo "/dev/dsk/"${rdisk##*/} ;;
		rdisk)	echo "/dev/disk/"${rdisk##*/} ;;
		rcdisk)	echo "/dev/cdisk/"${rdisk##*/} ;;
		*)	echo ${rdisk} ;;		# assume disk was not rdisk name
	esac
}

function _rdisk_name
{
	# input is /dev/disk/disk1; output is /dev/rdisk/disk1
	typeset disk=$1
	typeset a b
	a=${disk#/dev/*}	# input /dev/disk/disk1; output disk/disk1
	b=${a%/*}		# # input disk/disk1; output disk
	case $b in
		dsk)	echo "/dev/rdsk/"${disk##*/} ;;
		disk)	echo "/dev/rdisk/"${disk##*/} ;;
		cdisk)	echo "/dev/rcdisk/"${disk##*/} ;;
		*)	echo ${disk} ;;		# no idea what kind of disk it was
	esac
}

function _short_devname
{
	# input is /dev/vg_name; output is vg_name
	# input is /dev/vg_name/lvol1; output is lvol1
	# input is /dev/disk/disk1; outpit is disk1
	echo "${1##*/}"
}

function _extract_mode
{
        # input: Directory or File name
        # output: mode in 4 numbers
        # Usage: _extract_mode ${Directory}|${File}
        # $mode contains real mode number
        typeset String
        String=$(ls -ld $1 2>/dev/null | awk '{print $1}')
        [ -z "${String}" ] && _error "File system $1 does not exist."
        _decode_mode "${String}"
        echo $mode
}

function _decode_mode
{
        # Purpose is to return the mode in decimal number
        # input: drwxrwxr-x (as an example)
        # return: 0775
        # error: 9999
        typeset StrMode
        StrMode=$1

        Partu="$(echo $StrMode | cut -c2-4)"
        Partg="$(echo $StrMode | cut -c5-7)"
        Parto="$(echo $StrMode | cut -c8-10)"
        #echo "$Partu $Partg $Parto"
        # Num and Sticky are used by function _decode_sub_mode too
        Num=0
        Sticky=0
        # first decode the user part
        _decode_sub_mode $Partu
        NumU=$Num
        Sticky_u=$Sticky
        # then decode the group part
        _decode_sub_mode $Partg
        NumG=$Num
        Sticky_g=$Sticky
        # and finally, decode the other part
        _decode_sub_mode $Parto
        NumO=$Num
        Sticky_o=$Sticky
        #echo "$NumU $Sticky_u $NumG $Sticky_g $NumO $Sticky_o"

        # put all bits together and calculate the mode in numbers
        sticky_prefix=$((Sticky_u * 4 + Sticky_g * 2 + Sticky_o))
        sticky_prefix=$((sticky_prefix * 1000))
        mode=$((NumU * 100 + NumG * 10 + NumO))
        mode=$((sticky_prefix + mode))
        return $mode
}

function _decode_sub_mode
{
        # input: String of 3 character (representing user/group/other mode)
        # output: integer number Num 0-7 and Sticky=0|1
        Sticky=0
        case $1 in
           "---") Num=0 ;;
           "--x") Num=1 ;;
           "-w-") Num=2 ;;
           "r--") Num=4 ;;
           "rw-") Num=6 ;;
           "r-x") Num=5 ;;
           "rwx") Num=7 ;;
           "--T") Num=0 ; Sticky=1 ;;
           "r-T") Num=4 ; Sticky=1 ;;
           "-wT") Num=2 ; Sticky=1 ;;
           "rwT") Num=6 ; Sticky=1 ;;
           "--t") Num=1 ; Sticky=1 ;;
           "r-t") Num=5 ; Sticky=1 ;;
           "-wt") Num=3 ; Sticky=1 ;;
           "rwt") Num=7 ; Sticky=1 ;;
           "--S") Num=0 ; Sticky=1 ;;
           "r-S") Num=4 ; Sticky=1 ;;
           "rwS") Num=6 ; Sticky=1 ;;
           "-wS") Num=2 ; Sticky=1 ;;
           "--s") Num=1 ; Sticky=1 ;;
           "r-s") Num=5 ; Sticky=1 ;;
           "rws") Num=7 ; Sticky=1 ;;
           "-ws") Num=3 ; Sticky=1 ;;
        esac
}

function _isnum
{
	#echo $(($1+0))		# returns 0 for non-numeric input, otherwise input=output
	if expr $1 + 0 >/dev/null 2>&1 ; then
		echo $1
	else
		echo 0
	fi
}
