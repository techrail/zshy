#!/usr/bin/env zsh

# Detects the OS and returns it to caller. 
function detectos() {
	case $1 in
		help)
			echo "This tool can print the OS it detects using OSTYPE environment variable"
			echo "Usage: "
			echo "${funcstack[1]}"
			echo "The tool does not accept any argument"
			return 1
			;;
		*)
	esac
	
	local osname="unknown"
	if [[ "$OSTYPE" == "darwin"* ]]; then
		osname="macos"
	elif [[ "$OSTYPE" == "linux-gnu" ]]; then
		osname="linux"
	fi

	printf $osname
}

function detectos_oneliner() {
	echo "detectos: Tells the creation time for a supplied file"
}

function detectos_help() {
	echo "detectos"
	detectos help 
}