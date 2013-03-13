#!/bin/ksh
# Script: create_san_layout_script.sh
# Author: Gratien D'haese
# Purpose: Recreate all VGs, LVs, FSs according the SAN_layout_configuration file created
# -------  by save_SAN_layout.sh script. However, diskmapping must be executed and when there
#	   are anomolies found (in disk sizes) we report (and exit)
#	   The final result will be a script containing all commands to recreated everything
#	   of SAN based disks (XP based only for the moment)
#

##############
# Parameters #
##############
# general parameter settings
PS4='$LINENO:=> ' # This prompt will be used when script tracing is turned on
typeset -x PRGNAME=${0##*/}				# This script short name
typeset -x ARGS="$@"					# the script arguments
[[ -z "$ARGS" ]] && ARGS="default values"		# is used in the header
typeset -x PRGDIR=${0%/*}				# This script directory name
[[ $PRGDIR = /* ]] || PRGDIR=$(pwd)			# Acquire absolute path to the script
typeset -x PATH=/usr/local/CPR/bin:/sbin:/usr/sbin:/usr/bin:/usr/xpg4/bin:$PATH:/usr/ucb:.
typeset -r platform=$(uname -s)				# Platform
typeset -r model=$(uname -m)				# Model
typeset -r HOSTNAME=$(uname -n)				# hostname
typeset os=$(uname -r); os=${os#B.}			# e.g. 11.31
typeset -r dlog=/var/adm/install-logs
typeset instlog=$dlog/${PRGNAME%???}-$(date '+%Y-%b-%d')-$(date '+%Hh%Mm').scriptlog		# log file
typeset -r ERRFILE=/tmp/ERRFILE-${PRGNAME%???}-$$	# temporary file to keep track of erros (in functions)
typeset -x EXITCODE=0					# the exitcode variable to keep track of the #errors
# specific parameters setting for this script
typeset XPINFO="xpinfo"					# default value
typeset -x SANCONF="/tmp/SAN_layout_of_${HOSTNAME}.conf"	# default name of SAN layout configuration
typeset -x SCRIPT="$PRGDIR/make_SAN_layout_of_${HOSTNAME}.sh"	# default name of the SAN creation script
typeset -x KEEPTMPDIR=0					# by default we remove TMPDIR
typeset -x STORAGEBOXTYPE=none				# by default we assume 'none'
typeset -x PERCENTDEVIATION=5				# by default we allow 5% disk size deviation
typeset -x DEBUG=					# by default no debugging enabled (use -d to do so)


#############
# FUNCTIONS #
#############
#
# Read the shell functions from shlib/*
if [ ! -d $PRGDIR/shlib ]; then
	echo "ERROR: Cannot find $PRGDIR/shlib directory - where are my functions?"
	exit 1
fi
for func in $(ls $PRGDIR/shlib)
do
	. $PRGDIR/shlib/$func
done

################
### M A I N  ###
################

while [ $# -gt 0 ]; do
	case "$1" in
		-f) SANCONF=$2
		    _is_var_empty "$SANCONF"
		    shift 2
		    ;;
		-s) SCRIPT=$2
		    _is_var_empty "$SCRIPT"
		    shift 2
		    ;;
		-k) KEEPTMPDIR=1
		    shift 1
		    ;;
		-d)  DEBUG=1
		    shift 1
		    ;;
		-p) PERCENTDEVIATION=$2
		    _is_var_empty "$PERCENTDEVIATION"
		    PERCENTDEVIATION=$(_isnum $PERCENTDEVIATION) # when arg is non-numeric the result is 0
		    shift 2
		    ;;
		*)  _show_help_${PRGNAME%%_*}
		    # _show_help_create
		    ;;
	esac
done

{
touch $ERRFILE			# touch the (empty) error file
##_banner_${PRGNAME%%_*}	# _banner_create
_banner	"Create the SAN creation script ($(basename $SCRIPT))"
_whoami
_check_sanconf || _show_help_${PRGNAME%%_*}
_osrevision
_create_temp_dir

_force_ioscan_for_disks
_force_insf_for_disks
_capture_ioscan_output

STORAGEBOXTYPE="$(_check_storage_box)"		# of current connected SAN box
[[ "$STORAGEBOXTYPE" = "none" ]] && _error "No SAN storage found, or not yet supported by $PRGNAME"

# FIXME: use an array STORAGEBOXTYPE instead of a string in the future
if [[ $(_my_grep xp "$STORAGEBOXTYPE") -eq 1 ]]; then
	_verify_san_type_in_sanconf xp		# if in $SANCONF no xp disks were used then exit
	XPINFO=$(_define_xpinfo_bin)
	_capture_xpinfo_output
	_building_freedisks_on_xp
else
	_error "Only XP storage is supported at this moment"
fi

_diskmapping $PERCENTDEVIATION # try to match new disks with same size according SANCONF (dev= list)

_note "The $TMPDIR/diskmap file prepared looks like:"
cat $TMPDIR/diskmap
_askYN Y "Do you want to edit $TMPDIR/diskmap"
if (( $? )); then
	_record_answer "Y"
	_note "You can now edit $TMPDIR/diskmap file. When done type \"exit\""
	/usr/bin/sh
else
	_record_answer "N"
fi

# from here on we are creating a new script on the fly $SCRIPT
_populate_script_header
_check_if_vgexport_is_required
# before starting with the pvcreate part save the current lvmtab file
_add_save_lvmtab_to_script
_add_pvcreate_disks_to_script
_add_vgcreate_vgs_to_script
_add_lvcreate_lv_to_script
_add_mkfs_fs_to_script
_add_post_config_of_devs_to_script	# pvchange, scsimgr, scsictl stuff

_add_tailer_to_script
chmod +x $SCRIPT
# End of adding stuff to our SCRIPT

# at the end - cleanup, except if option '-k' was given
_remove_temp_dir

_highlight "Inspect script $SCRIPT before executing it!"

echo $EXITCODE > $ERRFILE
} 2>&1 | tee $instlog # tee is used in case of interactive run.

################# done with main script ###################

[ -f $ERRFILE ] && EXITCODE=$(cat $ERRFILE)
# cleanup errfile
rm -f $ERRFILE

# Final notification
case $EXITCODE in
	0)	msg="No errors were encountered by $PRGNAME on $HOSTNAME"
		_note $msg | tee -a $instlog
		;;
	*)	msg="Oops - $EXITCODE error(s) were encounterd by $PRGNAME on $HOSTNAME"
		_error $msg | tee -a $instlog
		;;
esac

# exit with exitcode from errfile
exit $EXITCODE
