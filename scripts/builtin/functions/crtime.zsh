#!/usr/bin/env zsh

# This function would give you the creation time of a file.
# It is supposed to work only on ext4 file systems (it uses debugfs from ext4's toolset)
function crtime() {
	if [ -z $1 ]; then
		echo "No file name supplied"
		return 2
	fi

	if [[ ! -a $1 ]]; then
		echo "Supplied file path does not exist"
		return 3
	fi

	if [ $EUID -ne 0 ]; then
		local cmd
		echo "Run the following command:"
		cmd="sudo debugfs -R stat <$(stat -c %i $1)> $(df $1 | awk 'NR>1 {print $1}')"
		echo $cmd

		read -k 1 "choice?Run it now? [y/n] "

		if [[ $choice = "y" || $choice = "Y" ]]; then
			local dt
			dt="/tmp/$(date +%s)"

			echo ""
			echo ""
			echo "-----------------------------------"
			echo "Notice the 'crtime' field in output"
			echo "-----------------------------------"
			echo ""

			sudo debugfs -R "stat <$(stat -c %i $1)>" $(df $1 | awk 'NR>1 {print $1}') > $dt
			cat $dt
			rm $dt
		else
			echo ""
			echo "You chose to cancel the run."
		fi
	else
		debugfs -R "stat <$(stat -c %i $1)>" $(df $1 | awk 'NR>1 {print $1}')
	fi	
}

function crtime_oneliner() {
	echo "crtime: Tells the creation time for a supplied file"
}

function crtime_help() {
	echo "crtime"
	echo "Tells the 'creation' time of a file."
	echo ""
	echo "Usage:"
	echo "  crtime path_to_file"
	echo ""
	echo "path_to_file is mandatory."
	echo "NOTE: this tool runs a command via 'sudo'"
}
