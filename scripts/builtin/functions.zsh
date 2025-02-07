#!/usr/bin/env zsh

# Load builtin utilities
for filename in ${0:a:h}/utilities/*.sh; do
	source $filename
done

# Load builtin functions

# If you have functions you would like to add, add them in custom_functions directory
# ====================
# IMPORTANT NOTE: 
# ====================
# 
# 1. Do not use special file names. 
#    The file names (without the .sh extension) need to be valid function and variable names.
#    So, keep it simple: alphanumeric functions with underscores.
#    Do not start the file name with numbers.
#    
# 2. If you want to ignore processing of some files, rename them to func_file.sh to func_file.zsh
#
for filename in ${0:a:h}/functions/*.zsh; do
	source $filename
done

# Already being called in init.sh
#source ${0:a:h}/hooks.sh

# Prints help about the available functions
function helpme() {
	
	clpr default "\nRun 'utilities_help' to learn about available utilities."

	# Detect custom functions help
	local type_func_location=$(type ${funcstack[1]})

	# The following line depends on the functionality where when you run the 'type' command 
	# against a loaded function name, the file where the function resides is reported as follows
	#
	# helpme is a shell function from /home/vaibhav/bin/zsh_scripts/functions.sh
	#
	echo $type_func_location | grep "shell function from" > /dev/null

	if [[ $? -eq 0 ]]; then
		# extract the actual path! :-) 
		local func_location=$(string reverse $(string reverse $type_func_location | cut -d' ' -f1 ))

		echo "\nCustom functions were found"

		for filename in ${func_location:a:h}/functions/*.zsh; do
			# echo "file: $filename"
			echo "$(type ${${filename##*/}:0:-4}_oneliner)" | grep "shell function from" > /dev/null
			if [[ $? -eq 0 ]]; then
				echo "---- ${${filename##*/}:0:-4} ----"
				eval "${${filename##*/}:0:-4}_oneliner"

				echo "$(type ${${filename##*/}:0:-4}_help)" | grep "shell function from" > /dev/null
				if [[ $? -eq 0 ]]; then
					clpr blue white "]>==>) Run ${${filename##*/}:0:-4}_help to get more help"
					echo ""
				fi
			else
				echo "* Define a function named ${${filename##*/}:0:-4}_oneliner in ${filename##*/} to show corresponding help here.\n"
			fi
		done

		echo ""
	else
		echo "No Custom functions were found.\n"
	fi
}