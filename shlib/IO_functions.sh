#################
# I/O FUNCTIONS #
#################
function _echo
{
	case $platform in
		Linux|Darwin) arg="-e " ;;
	esac
	echo $arg "$*"
} # echo is not the same between UNIX and Linux

function _note
{
	_echo " ** $*"
} 

function _error
{
	printf " *** ERROR: $* \n"
	EXITCODE=$((EXITCODE + 1))	# count the amount of errors
	echo $EXITCODE > $ERRFILE
	exit 1
}

function _debug
{
	test "$DEBUG" && _note "$@"
}

function _record_answer
{
	# this is mainly used to record an answer from a prompt to the logfile
	printf  "$* \n" | tee -a $instlog
}

function _warn
{
	printf " *** WARN: $* \n"
}

function _highlight
{
	printf "$(tput smso) $* $(tput rmso) \n"
}

function _askYN
{
	# input arg1: string Y or N; arg2: string to display
	# output returns 0 if NO or 1 if YES so you can use a unary test for comparison
	typeset answer

	case "$1" in
		Y|y)	order="Y/n" ;;
		*)	order="y/N" ;;
	esac

	_echo "$2 $order ? \c"
	read answer

	case "$1" in
		Y|y)
			if [[ "${answer}" = "n" ]] || [[ "${answer}" = "N" ]]; then
				return 0
			else
				return 1
			fi
			;;
		*)
			if [[ "${answer}" = "y" ]] || [[ "${answer}" = "Y" ]]; then
				return 1
			else
				return 0
			fi
			;;
	esac

}

function _line
{
	typeset -i i
	while (( i < 95 )); do
		(( i+=1 ))
		echo "${1}\c"
	done
	echo
}

function _banner
{
	# arg1 "string to print next to Purpose"
	cat - <<-EOD
	$(_line "#")
	$(_print 22 "Installation Script:" "$PRGNAME")
	$(_print 22 "Script Arguments:" "$ARGS")
	$(_print 22 "Purpose:" "$1")
	$(_print 22 "OS Release:" "$os")
	$(_print 22 "Model:" "$model")
	$(_print 22 "Installation Host:" "$HOSTNAME")
	$(_print 22 "Installation User:" "$(whoami)")
	$(_print 22 "Installation Date:" "$(date +'%Y-%m-%d @ %H:%M:%S')")
	$(_print 22 "Installation Log:" "$instlog")
	$(_line "#")
	EOD
}

function _print
{
	# arg1: counter (integer), arg2: "left string", arg3: "right string"
	typeset -i i
	i=$(_isnum $1)
	[[ $i -eq 0 ]] && i=22	# if i was 0, then make it 22 (our default value)
	printf "%${i}s %-80s " "$2" "$3"
}

function _show_help_save
{
	cat - <<-end-of-text
	Usage: $PRGNAME [-f SAN_layout_configuration_file] [-k] [-h]

	-f file: The SAN_layout_configuration_file to store in SAN layout in
	-k:	 Keep the temporary directory after we are finished executing $PRGNAME
	-d:	 Enable debug mode (by default off)
	-h:	 Show usage [this page]

	end-of-text
	exit 0
}

function _show_help_make
{
	cat - <<-end-of-text
	Usage: $PRGNAME [-f SAN_layout_configuration_file] [-k] [-h]

	-f file: The SAN_layout_configuration_file to store in SAN layout in
	-k:      Keep the temporary directory after we are finished executing $PRGNAME
	-h:      Show usage [this page]

	end-of-text
	exit 0
}

function _show_help_create
{
	cat - <<-end-of-text
	Usage: $PRGNAME [-f SAN_layout_configuration_file] [-s create_SAN_layout.sh] [-p percentage] [-k] [-h] [-d]

	-f file:   The SAN_layout_configuration_file containing the SAN layout of $(hostname)
	-s script: The name of the SAN creation script
	-p nr:     A percentage (integer) value which is allowed in deviation of the target disk sizes
	-k:        Keep the temporary directory after we are finished executing $PRGNAME
	-h:        Show usage [this page]
	-d:	   Enable debug mode (by default off)

	end-of-text
	exit 0
}
