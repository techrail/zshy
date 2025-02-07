#!/usr/bin/env zsh

function depCheck() {
	if [[ $# -lt 1 ]]; then
		echo "Please supply the path to deplist.txt"
		return 2
	fi

	input="$1/deplist.txt"
	foundCommand="true"

	while read -r line
	do
		type $line &> /dev/null
		if [ $? -ne 0 ]; then
			foundCommand="false"
			echo "Command $line not found"
		fi
	done < "$input"

	if [[ $foundCommand == "false" ]]; then
		return 1
	fi
}

function depCheck:help() {
	echo "depCheck Usage:"
	echo "depCheck deplistFolder"
	echo "depCheck checks if the dependencies listed in the 'deplist.txt' file" 
	echo "	located inside deplistFolder (one dependency per file)"
}
