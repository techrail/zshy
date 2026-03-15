#!/usr/bin/env zsh

function lmid() {
	ostype=$(detectos)
	# echo $ostype
	case $ostype in
		macos)
      # pbcopy is always there on mac
      printf "$(([##36]$(date -u +%s) - 1600000000))" | pbcopy 
			;;
		linux)
      # copyq needs to be installed on Linux!
      local tsShortcode
      tsShortcode=$(printf "$(([##36]$(date -u +%s) - 1600000000))")
      copyq copy $tsShortcode
      if [ $? -ne 0 ]; then 
        # copyq was not installed. Print the value with the error
        echo "It apears copyq is not installed. Here is the code to copy:"
      fi
      echo $tsShortcode
			;;
		*)
			echo "Detected OS Type to be ${ostype}. Do not know what to do"
			echo "Quitting"
			;;
	esac
}

function lmid_oneliner() {
	echo "lmid: Copies the LMID using the standard values and method defined"
}

function lmid_help() {
	echo "lmid"
	echo "Copies the LMID using the standard values and method defined"
	echo ""
	echo "Usage:"
	echo "  lmid"
	echo ""
	echo "The command accepts no arguments and in case of Linux, it will print"
  echo "  the code to the terminal. If the copyq utility is not found, it"
  echo "  will print an error before. Since copyq always prints 'true' on"
  echo "  success, output on Linux is 2 lines long. On macOS however, the"
  echo "  pbcopy command is always available, so no output is printed."
}
