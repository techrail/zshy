#!/usr/bin/env zsh

# This script contains string utilities


function string_oneliner() {
	echo "string: Utilities to work with strings in zsh"
}

function string_help() {
	string help
}

function string() {
	case $1 in 
		joinby|j)
			if [ -z $2 ]; then
				echo "separator not supplied. Run 'string joinby:help' to learn the usage"
				return 10
			fi

			if [ -z $3 ]; then
				echo "string1 not supplied. Run 'string joinby:help' to learn the usage"
				return 12
			fi

			local tmpStr
			tmpStr="" # We will store our joined string here

			shift  # remove $1 (the 'joinby' word from argument list)
			sep=$1 # Set the separator value
			shift  # and remove the separator string from the list of arguments as well

			for i in "${*[@]}"; do
        tmpStr="${tmpStr}${i}${sep}" # Concatenate the strings with separator repeatedly
			done

			printf ${tmpStr:0:-$(string length $sep)} # Remove the last separator added by the loop above and print
			;;
		joinby:help|j:help)
			string:joinby:help "defence against accidental call"
			;;
		length|l)
			if [ -z $2 ]; then
				echo "String to check the length of not supplied." 
				echo "Run 'string length:help' to learn the usage"
				return 15
			fi

			if [ $# -gt 2 ]; then
				echo "Too many arguments. Run 'string length:help' to learn the usage"
				return 16
			fi

			str_to_check=$2

			printf "${#${str_to_check}}"
			;;
		length:help|l:help)
			string:length:help "defence against accidental call"
			;;
		lower)
			if [ -z $2 ]; then 
				echo "String to convert to lowercase was not supplied." 
				echo "Run 'string lower:help' to learn the usage"
				return 20
			fi

			local str
			str=$2

			print -r "${2:l}"
			;;
		lower:help)
			string:lower:help "defence against accidental call"
			;;
		upper)
			if [ -z $2 ]; then 
				echo "String to convert to uppercase was not supplied." 
				echo "Run 'string upper:help' to learn the usage"
				return 22
			fi

			print -r "${2:u}"
			;;
		upper:help)
			string:upper:help "defence against accidental call"
			;;
		reverse|r)
			if [ -z $2 ]; then 
				echo "String to reverse was not supplied." 
				echo "Run 'string reverse:help' to learn the usage"
				return 22
			fi

			shift
			local var="$*"
			local copy=${var}
			local rev

			rev=""

			local len=${#copy}
			for (( i=(($len-1)); i>=0; i-- )); do 
				rev="$rev${copy:$i:1}"; 
			done

			echo "$rev"
			;;
		reverse:help|r:help)
			string:reverse:help "defence against accidental call"
			;;
		trim)
			if [ -z $2 ]; then 
				echo "String to trim was not supplied." 
				echo "Run 'string trim:help' to learn the usage"
				return 22
			fi

			printf "$(__stringTrim $2)"
			;;
		trim:help)
			string:trim:help "defence against accidental call"
			;;
		random:help)
			string:random:help "defence against accidental call"
			;;
		random) # Random string
			# TODO: Write the help function
			# TODO: Factor out the generation to a new function.
			#
			# example: 
			#
			# For 50 lower alphabets
			# string random alphalower 20 
			#
			# For 30 upper alphabets
			# string random alphaupper 30
			#
			# For 10 (default) alphanumerics
			# string random alphanumeric

			# Set default length to 10
			local req_len
			req_len=10

			if [ -z $2 ]; then 
				echo "Randomization option not supplied" 
				echo "Run 'string random:help' to learn the usage"
				return 22
			fi

			case $2 in
				alphalower) # Alphabetic numbers
					local source_string="abcdefghijklmnopqrstuvwxyz"
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 26 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				alphaupper)
					local source_string="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 26 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				alpha)
					local source_string="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 52 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				numeric) # Numerical string
					local source_string="1234567890"
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 10 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				special) # Special characters
					local source_string='`~!@#$%^&*()_-+={}|[]\:";,./<>?';
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 31 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				allchars)
					local source_string='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890`~!@#$%^&*()_-+={}|[]\:";,./<>?';
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 93 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				alphanumeric)
					local source_string="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
					local rand_num
					local dest_str
					dest_str=""

					if [ -z $3 ]; then
						req_len=10
					else
						req_len=$3
					fi

					for (( i = 1; i <= req_len; i++ )); do
						RANDOM=$(date +%N) # Reseed the RANDOM NUMBER GENERATOR
						rand_num=$(( ( RANDOM % 62 ) + 1 ))
						dest_str+=$(echo $source_string | cut -c $rand_num )
					done
					echo $dest_str
					;;
				help|*)
					echo "Type is required"
				  ;;
			esac
			;;
		beginsWith)
			# Make sure that there are at least 2 more arguments
			if [[ $# -ne 3 ]]; then
				echo "Strings to check were not supplied."
				echo "Run 'string beginsWith:help' to learn the usage"
			fi

			if [[ $2 == $3* ]]; then
					return 0
			else
					return 23
			fi
			;;
		beginsWith:help)
			string:beginsWith:help "defence against accidental call"
			;;
		help)
			clpr blue "The following commands are available:"
			clpr default "${funcstack[1]} joinby|j   Uses 1st character of 1st arg as separator to join rest of the args"
			clpr default "${funcstack[1]} length|l   Calculates the length of the string supplied and PRINTS it"
			clpr default "${funcstack[1]} lower      Converts the argument to loweracse letters"
			clpr default "${funcstack[1]} upper      Converts the argument to UPPERCASE letters"
			clpr default "${funcstack[1]} reverse|r  Reverses the string supplied to it"
			clpr default "${funcstack[1]} beginsWith Checks if a string begins with another string"
			clpr default "${funcstack[1]} random     Returns a random string according to given arguments"
			;;
		*)
			clpr red "Unrecognized command. Run '${funcstack[1]} help' to get help"
			return 100
			;;
	esac
}

function __stringTrim() {
    if [[ $# -eq 0 ]]; then
        echo ""
        return 0
    fi
    
    local x
    x="$1"
    
    local bl=true
    local backTrimmed="false"
    local frontTrimmed="false"
    local firstChar
    local lastChar

    while $bl; do
		if [[ $x == " " || $x == "" ]]; then
			echo ""
			return 0
		fi
		firstChar=${x:0:-$((${#x}-1))}
		lastChar=${x:$((${#x}-1))}
		
		if [[ $firstChar == " " || $firstChar == "	" ]]; then
				x="${x:1}"
		else
				frontTrimmed="true"
		fi

		if [[ $lastChar == " " || $lastChar == "	" ]]; then
				x="${x:0:-1}"
		else
				backTrimmed="true"
		fi

		if [[ $frontTrimmed == "true" && $backTrimmed == "true" ]]; then
				bl=false
		fi
    done
    printf "$x"
}

function string:upper:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string upper:"
	echo ""
	echo "Usage:"
	echo ""
	echo 'string upper string_to_uppercase'
	echo ""
	echo "string_to_uppercase is mandatory to be supplied."
	echo "Extra arguments are ignored"
	echo "IMPORTANT:"
	echo "Make sure that string_to_uppercase does not contain expressions which ZSH will try to evaluate."
	echo "If it does, it won't work"
	echo ""
	echo "Examples:"
	echo ""
	echo "%string upper VaiBhav Kaushal"
	echo "VAIBHAV"
	echo ""
	echo '%string upper "VaiBhav KAUSHal"'
	echo "VAIBHAV KAUSHAL"
}

function string:lower:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string lower:"
	echo ""
	echo "Usage:"
	echo ""
	echo 'string lower string_to_lowercase'
	echo ""
	echo "string_to_lowercase is mandatory to be supplied."
	echo "Extra arguments are ignored"
	echo ""
	echo "Examples:"
	echo ""
	echo "%string lower VaiBhav Kaushal"
	echo "vaibhav"
	echo ""
	echo '%string lower "VaiBhav KAUSHal"'
	echo "vaibhav kaushal"
}

function string:length:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string length: "
	echo "shortcut: l ('string l' will also work)"
	echo ""
	echo "Usage:"
	echo ""
	echo "string length string_to_check"
	echo ""
	echo "string_to_check is mandatory to be supplied."
	echo "Passing more arguments will cause an error."
	echo ""
	echo "Examples:"
	echo '% string length vaibhav'
	echo '7'
	echo ''
	echo '% string length "vaibhav kaushal"'
	echo '15'
	echo ''
	echo '% x="test data";string length $x'
	echo '9'
}

function string:joinby:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string joinby: "
	echo "shortcut: j ('string j' will also work)"
	echo ""
	echo "Usage:"
	echo "string joinby sep string1 [more_strings]"
	echo ""
	echo "Takes multiple strings (at least 2) as arguments."
	echo "The first character of sep is used as a separator"
	echo "to join the rest of the arguments (string1 and more_strings)"
	echo ""
	echo "Examples: "
	echo "% string joinby , a b c d"
	echo "a,b,c,d"
	echo ""
	echo "% string joinby - a b c d"
	echo "a-b-c-d"
	echo ""
	echo "% string joinby -- a b c d"
	echo "a-b-c-d"
	echo ""
	echo '% string joinby ++ "ab" "cd" e'
	echo 'ab+cd+e'
}

function string:reverse:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string reverse: "
	echo "shortcut: r ('string r' will also work)"
	echo ""
	echo "Usage:"
	echo "string reverse string_to_reverse"
	echo ""
	echo "Takes a string and reverses it"
	echo "string_to_reverse is any valid string"
	echo "NOTE: this tool will not club together any extra arguments"
	echo ""
	echo "Examples: "
	echo "% string reverse vaibhav"
	string reverse vaibhav
	echo ""
	echo "% string reverse vaibhav kaushal"
	string reverse vaibhav kaushal
	echo ""
	echo '% string reverse "vaibhav kaushal"'
	string reverse "vaibhav kaushal"
}

function string:trim:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string trim: "
	echo ""
	echo "Usage:"
	echo "string trim string_to_trim"
	echo ""
	echo "Takes a string and trims it"
	echo "string_to_trime is any valid string"
	echo "NOTE: this tool will NOT TRIM NEWLINE"
	echo ""
	echo "Examples: "
	echo "The following example is to show how trim works"
	echo "both at the beginning and at the end of a string"
	echo ""
	echo '% echo /$(string trim "  vaibhav kaushal  ")/'
	echo /$(string trim "  vaibhav kaushal  ")/
}

function string:random:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string random: "
	echo ""
	echo "Usage:"
	echo "string random charset [count]"
	echo ""
	echo "Returns a random string of length count (default is 10)"
	echo "The returned string is made up of characters from the given charset."
	echo "Valid charsets are:"
	echo ""
	echo "alphalower - lower case alphabets only"
	echo "alphaupper - upper case alphabets only"
	echo "alpha      - both lower and upper case alphabets"
	echo "numeric    - numerical digits only"
	echo "special    - special characters on a standard qwerty keyboard"
	echo "allchars   - alphanumeric + special character sets"
	echo ""
	echo "Example:"
	clpr blue '% string random alphanumeric 15'
	echo $(string random alphanumeric 15)
}

function string:beginsWith:help() {
	if [ $# -lt 1 ]; then
		echo "You are not supposed to call this command manually"
		return 100
	fi

	echo "string beginsWith:"
	echo ""
	echo "Usage:"
	echo "string beginsWith larger_string prefix"
	echo ""
	echo "Check if a string begins with another"
}