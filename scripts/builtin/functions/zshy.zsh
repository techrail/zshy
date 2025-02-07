#!/usr/bin/env zsh

function zshy() {
	case $1 in
	run)
    if [[ $ZSHY_EXT_HOME == "" ]]; then
      echo "Cannot run any extension."
      __zshy_usage $1 show_extensions_dir_creation_help
      return 1
    fi

		shift
		local funcdirpath
		local funcfilepath
		if [[ $# -eq 0 ]]; then
			debugmsg "zshy run got no args"
			__zshy_usage "$0" "$1"
			return
		fi

		funcdirpath="$ZSHY_EXT_HOME/$1"
		funcfilepath="$ZSHY_EXT_HOME/$1/$1.zsh"

		# Check that the directory exists
		if [ -e "$funcdirpath" ]; then
			# Path exists, check if it is a file.
			if [ -f "$funcdirpath" ]; then
				# It is a file.
				echo "$0 is a file. It should have been a directory."
				return 2
			fi

			# Should be a directory
			if [ -d "$funcdirpath" ]; then
				# Check that it is not a symbolic link
				if [ -L "$funcdirpath" ]; then
					echo "'$0' is a symlink to a directory. Symlinks are not supported."
					return 2
				fi
			else
				echo "'$0' does not seem to be installed!"
				return 4
			fi
		else
			echo "Function does not seem to be installed: $funcdirpath"
			return 5
		fi

		# Looks like it is installed.
		# Check that the script exists
		if [ -e "$funcdirpath" ]; then
			# Path exists, check if it is a file.
			if [ -f "$funcfilepath" ]; then
				# It is a file. Execute it
				shift
				source $funcfilepath
			else
				echo "$funcfilepath needs to be a file. It is not!"
			fi
		else
			echo "Function $1 does not seem to be installed properly. File $funcfilepath does not exist"
			return 5
		fi
		;;
	install)
    if [[ $ZSHY_EXT_HOME == "" ]]; then
      echo "Cannot install any extension."
      __zshy_usage $1 show_extensions_dir_creation_help
      return 1
    fi

		shift
		local curr_dir
		if [ -z "$1" ]; then
			echo "Supply git repo address please"
		else
			echo "Install directory is: $ZSHY_EXT_HOME"
			echo "going to run 'git clone $1' in $ZSHY_EXT_HOME"

			curr_dir=$(pwd)
			cd $ZSHY_EXT_HOME
			git clone $1
			if [[ $? -ne 0 ]]; then
				echo "looks like that failed"
				cd $curr_dir
				return 1
			fi

			clpr magenta "You should remove the .git folder from the newly created folder."
			clpr blue --no-newline "Do you want to remove the .git folder from the target directory? [y/n] "
			read -k 1 choice
			echo ""

			if [[ $choice == "y" || $choice == "Y" ]]; then
				cd $ZSHY_EXT_HOME
				clpr green "You should now 'cd' to the newly created directory and run 'rm -rf .git' there."
				return 0
			else
				echo "You chose not to delete the .git directory from the newly created directory."
				echo "If you do want to do that, remember the function are located here: $ZSHY_EXT_HOME"
				cd $curr_dir
			fi
		fi
		;; 
  check)
    if [[ $ZSHY_EXT_HOME == "" ]]; then
      echo "Cannot check for extension's existence!!"
      __zshy_usage $1 show_extensions_dir_creation_help
      return 1
    fi

		shift
		local funcdirpath
		local funcfilepath
		if [[ $# -eq 0 ]]; then
			debugmsg "zshy c got no args"
			__zshy_usage "$0" "$1"
			return
		fi

		funcdirpath="$ZSHY_EXT_HOME/$1"
		funcfilepath="$ZSHY_EXT_HOME/$1/$1.zsh"
		# Check that the directory exists
		if [ -e "$funcdirpath" ]; then
		  # Must not be a symbolic link
			if [ -L "$funcdirpath" ]; then
				return 1
			fi

			# Must be a directory
			if [ -d "$funcdirpath" ]; then
				# file must be present
				if [ -f "$funcfilepath" ]; then
					return 0
				else
					return 2
				fi
			else
				return 3
			fi
		else
			return 4
		fi
		;;
	help | *)
		echo "$0 helps you work with the Zshy extensions."
		;;
	esac

}

function __zshy_usage() {
	if [[ $# -ne 2 ]]; then
		echo "You are not supposed to run this function manually"
		return
	fi

	case $2 in
	run)
		echo "$1 $2 allows you run an extension installed by the user"
		echo "Usage: $1 $2 program program_args"
		echo "  The program is the name of the installed function"
		;;
	install)
		echo "$1 $2 allows you to install an extension in the extensions directory"
		echo "Usage: $1 $2 repo_address"
		echo "  The repo_address is a git repository address that is accessible from the current env"
		echo "  Please ensure that you are able to access that repository."
		;;
	check)
	  echo "$1 $2 will test if the extension is installed or not (returns 0 if it is installed)"
		echo "Usage $1 $2 ext_name "
		echo "  The ext_name is the name of the extension which you want to check if it is installed"
		;;
  show_extensions_dir_creation_help)
    echo "The zshy extensions directory was not found."
    echo "To create the directory and enable related functionality, run the following commands:"
    echo "mkdir -p $HOME/bin/zshy/extensions"
    echo "source $HOME/.zshrc"
    echo ""
    ;;
	*)
		echo "You are not supposed to call this function manually"
		;;
	esac
}
