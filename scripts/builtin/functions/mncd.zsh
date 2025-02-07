#!/usr/bin/env zsh

function mncd() {
	if [ -z "$1" ]; then
		echo "Supply directory name please."
	else
		mkdir -p $1
		cd $1
	fi	
}

function mncd_oneliner() {
	echo "mncd: make a directory and cd to it"
}