#!/usr/bin/env zsh

function clclpr () {
	if [ $# -lt 1 ]; then
		echo "$0 needs at least 1 argument."
		return 0
	fi

	local bold='0;'
	local bgcolorcode='48;'
	local colorcode='39'

	local bold_or_not=""
	local bgcolor="default"
	local fgcolor="default"

	local str_to_print

	local print_newline
	print_newline=1

	if utils:argument_exists_or_not "--no-newline" $*
	then
		# Don't print newline
		print_newline=0
		shift 1
	fi

	case $# in
	1)
		echo "$1";
		if [ "$1" = "--help" ]; then
			echo "This tool prints a line of message in a given color\n"
			echo "Usage: "
			echo "${funcstack[1]} color_name message\n"
			echo "List of color_name available:"
			echo " - black"
			echo " - red"
			echo " - green"
			echo " - yellow"
			echo " - blue"
			echo " - magenta"
			echo " - cyan"
			echo " - lightgray"
			echo " - darkgray"
			echo " - lightred"
			echo " - lightgreen"
			echo " - lightyellow"
			echo " - lightblue"
			echo " - lightmagenta"
			echo " - lightcyan"
			echo " - white"
			echo ""
			echo "NOTE 1: You cannot use 'help' as a color."
			echo "        That will print this help but will NOT print the message."
			echo "NOTE 2: Any other color_name will set the color to the default terminal color."
			return 1
		else
			echo "$1";
		fi
		;;
	2)
		# first argument is fgcolor
		fgcolor=$1
		str_to_print=$2
		;;
	3)
		# first argument is bgcolor, second argument is fgcolor
		bgcolor=$1
		fgcolor=$2
		str_to_print=$3
		;;
	4)
		bgcolor=$1
		fgcolor=$2
		# First argument is bgcolor, second argument is fgcolor and third argument is bold_or_not
		bold_or_not=$3
		if [ "$bold_or_not" = "bold" ]; then
			bold="1;"
		fi
		str_to_print=$4
		;;
	*)
		bgcolor=$1
		fgcolor=$2
		bold_or_not=$3
		if [ "$bold_or_not" = "bold" ]; then
			bold="1;"
		fi
		shift 3
		str_to_print="$*"
		;;
  esac

  case $bgcolor in
		black)
			bgcolorcode='40;'
			;;
		red)
			bgcolorcode='41;'
			;;
		green)
			bgcolorcode='42;'
			;;
		yellow)
			bgcolorcode='43;'
			;;
		blue)
			bgcolorcode='44;'
			;;
		magenta)
			bgcolorcode='45;'
			;;
		cyan)
			bgcolorcode='46;'
			;;
		lightgray)
			bgcolorcode='47;'
			;;
		darkgray)
			bgcolorcode='100;'
			;;
		lightred)
			bgcolorcode='101;'
			;;
		lightgreen)
			bgcolorcode='102;'
			;;
		lightyellow)
			bgcolorcode='103;'
			;;
		lightblue)
			bgcolorcode='104;'
			;;
		lightmagenta)
			bgcolorcode='105;'
			;;
		lightcyan)
			bgcolorcode='106;'
			;;
		white)
			bgcolorcode='107;'
			;;
		*)
			bgcolorcode=''
			;;
	esac

	case $fgcolor in
		black)
			colorcode='30'
			;;
		red)
			colorcode='31'
			;;
		green)
			colorcode='32'
			;;
		yellow)
			colorcode='33'
			;;
		blue)
			colorcode='34'
			;;
		magenta)
			colorcode='35'
			;;
		cyan)
			colorcode='36'
			;;
		lightgray)
			colorcode='37'
			;;
		darkgray)
			colorcode='90'
			;;
		lightred)
			colorcode='91'
			;;
		lightgreen)
			colorcode='92'
			;;
		lightyellow)
			colorcode='93'
			;;
		lightblue)
			colorcode='94'
			;;
		lightmagenta)
			colorcode='95'
			;;
		lightcyan)
			colorcode='96'
			;;
		white)
			colorcode='97'
			;;
		*)
			colorcode='39'
			;;
	esac

	# get the color argument out of the way so that the message could be printed if they are multiple messages.
	shift

	ostype=$(detectos)
	# echo $ostype
	case $ostype in
		macos)
			# macos needs some special treatment
			# We can try using the linux command when testing on macOS
			mac_colorcode="\033[0;${colorcode}m"
			mac_nocolorcode="\033[0m"
			if [[ $print_newline -eq 0 ]]
			then
				# Don't print newline
				printf "\033[${bold}${bgcolorcode}${colorcode}m${str_to_print}\e[49;39m"
			else
				# Print newline
				print "\033[${bold}${bgcolorcode}${colorcode}m${str_to_print}\e[49;39m"
			fi
			;;
		linux)
#		  echo "bold:${bold} bg:${bgcolorcode} color:${colorcode}"
#			echo -e "\e[${bold}${bgcolorcode}${colorcode}m$*\e[39m"
			if [[ $print_newline -eq 0 ]]
			then
				# Don't print newline
				printf "\033[${bold}${bgcolorcode}${colorcode}m${str_to_print}\033[49;39m"
			else
				# Print newline
				print "\033[${bold}${bgcolorcode}${colorcode}m${str_to_print}\033[49;39m"
			fi
			;;
		*)
			echo "Detected OS Type to be ${ostype}. Do not know what to do"
			echo "Quitting"
			;;
	esac
}

function clpr_oneliner () {
	echo "clpr: Color Print utility for ZSH!!"
}

function clpr_help() {
	echo "This tool prints a line of message in a given color\n"
	echo "Usage: "
	echo ""
	echo "clpr [--no-newline] [bgcolor [fgcolor [bold]]] msg1 [...msg]"
	echo ""
	echo "The '--no-newline' option suppresses the newline at the end of the printed message"
	echo "   By default (without this option) clpr will print the message with a newline"
	echo "   at the end of the message"
	echo ""
	echo "The options bgcolor, fgcolor and bold change the style of printed message"
	echo "Option 'bgcolor' represents background color of text"
	echo "Option 'fgcolor' represents foreground color (or text color) of text"
	echo "Option 'bold' is written as is and when set will print message in bold text"
	echo ""
	echo "List of color names available:"
	echo " - black"
	echo " - red"
	echo " - green"
	echo " - yellow"
	echo " - blue"
	echo " - magenta"
	echo " - cyan"
	echo " - lightgray"
	echo " - darkgray"
	echo " - lightred"
	echo " - lightgreen"
	echo " - lightyellow"
	echo " - lightblue"
	echo " - lightmagenta"
	echo " - lightcyan"
	echo " - white"
	echo ""
	echo "NOTE: Any other color name will set the color to the default terminal color."
	echo "Examples:"
	echo ""
	echo "% clpr Vaibhav # No color specified"
	clpr Vaibhav
	echo "% clpr blue Vaibhav"
	clpr blue Vaibhav
	echo "% clpr blue yellow Vaibhav"
	clpr blue yellow Vaibhav
	echo "% clpr blue yellow bold Vaibhav"
	blue yellow bold Vaibhav
	echo "% clpr blue yellow bold vaibhav kaushal"
	clpr blue yellow bold vaibhav kaushal
}
