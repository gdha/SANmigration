#!/bin/ksh
# Script: save_san_layout.sh
# Author: Gratien D'haese
# Purpose: save the SAN layout, including LVM info, FS info in a configuration file
# -------  so we are able to recreate everything again on a new system (kind of cloning)
#

##############
# Parameters #
##############
# general parameter
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
typeset instlog=$dlog/${PRGNAME%???}.scriptlog		# log file
# specific parameter for this script
typeset XPINFO="xpinfo"					# default value
typeset -x SANCONF="/tmp/SAN_layout_of_$HOSTNAME.conf"	# default name of SAN layout configuration
typeset -x KEEPTMPDIR=0					# by default we remove TMPDIR
typeset -x STORAGEBOXTYPE=none				# by default we assume 'none'
typeset -x EXITCODE=0					# the exitcode variable to keep track of the #errors
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
		-k) KEEPTMPDIR=1
		    shift 1
		    ;;
		-d) DEBUG=1
		    shift 1
		    ;;
		*)  _show_help_${PRGNAME%%_*}
		    exit 1
		    ;;
	esac
done

{
_banner "Save the current SAN configuration file ($(basename $SANCONF))"
_whoami
_osrevision
_create_temp_dir

_capture_ioscan_output

STORAGEBOXTYPE="$(_check_storage_box)"
[[ "$STORAGEBOXTYPE" = "none" ]] && _error "No SAN storage found, or not yet supported by $PRGNAME"

_init_SANCONF_file "$SANCONF"

_save_san_types			# san=

if [[ $(_my_grep xp "$STORAGEBOXTYPE") -eq 1 ]]; then
	XPINFO=$(_define_xpinfo_bin)
	_capture_xpinfo_output
else
	_error "Only XP storage is supported at this moment"
fi

_convert_lvmtab_to_ascii
_save_lvmpvg

_collect_diskinfo		# dev=
_collect_pvinfo			# pv=
_collect_vginfo			# vg=
_collect_lvinfo			# lv=
_collect_fsinfo			# fs=

# at the end - cleanup, except if option '-k' was given
_remove_temp_dir
_remove_noname_dir	# remove intermediate dirs, if any

echo "Save the SANCONF=$SANCONF file at a safe place."
echo "Done."
} 2>&1 | tee $instlog # tee is used in case of interactive run.
