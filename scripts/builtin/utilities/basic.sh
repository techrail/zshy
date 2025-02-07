#!/usr/bin/env zsh

function utilities_help() {
  debugmsg:usage
  utils:string_starts_with:usage
  utils:array_search:usage
  utils:array_elem_pos:usage
  utils:command_exists:usage
  utils:argument_exists_or_not:usage
  utils:get_argument_value:usage_basic
  utils:args_do_conflict:usage
  utils:searchopt:usage
}

##############################################

function utils:searchopt() {
  if [[ -z "$1" ]]; then 
    echo "Option required"
    utils:readopt:usage
    return 1
  else 
    setopt | grep $1 > /dev/null
    if [ $? -ne 0 ]; then
      # Did not find
      return 1
    else
      return 0
    fi
  fi
}

function utils:searchopt:usage() {
  pr default "utils:searchopt: searches if a ZSH option has been enabled"
  pr default "    Usage: util:searchopt option"
  pr default "    option can be any valid string"
  pr default ""
}

# --------------------------------------------
function debugmsg() {
  if [[ "$DEBUG" == "true" ]]; then
    echo "zshy: $*"
  fi
}

function debugmsg:usage() {
  pr default "debugmsg: Prints all its arguments if \$DEBUG is set to 'true'"
  pr default "    Usage: debugmsg message"
  pr default "    message can be any valid string or multiple strings"
  pr default "    This tool can be used in development of scripts"
  pr default ""
}

# --------------------------------------------
function utils:string_starts_with () {
	# $1 is the string to check
	# $2 is the string with which $1 should start for this function to return true
	
	if [[ $1 == "$2"* ]]; then 
		# $1 starts with $2
    return 0
  else 
    # $1 does not start with $2
    return 1
	fi
}

function utils:string_starts_with:usage() {
  pr default "utils:string_starts_with: checks if one string starts with another string"
  pr default "    Usage: util:string_starts_with str_long str_short"
  pr default "    Checks if str_long starts with str_short"
  pr default ""
}

# --------------------------------------------
function utils:string_ends_with () {
  # $1 is the string to check
  # $2 is the string with which $1 should start for this function to return true
  
  if [[ $1 == *"$2" ]]; then 
    # $1 ends with $2
    return 0
  else 
    # $1 does not end with $2
    return 1
  fi
}

function utils:string_ends_with:usage() {
  pr default "utils:string_ends_with: checks if one string ends in another string"
  pr default "    Usage: util:string_ends_with str_long str_short"
  pr default "    Checks if str_long ends in str_short"
  pr default ""
}

# --------------------------------------------
function utils:array_search() {
	needle=$1
	shift

	local array=($*)

	local i
	i=0

	for (( i = 1; i <= ${#array}; i++ )); do
		if [[ "$needle" == "${array[$i]}" ]]; then
			return 0
		fi
	done

	return 1
}

function utils:array_search:usage() {
  pr default "utils:array_search: Search for element in arrays."
  pr default "    Usage: utils:array_search needle haystack"
  pr default "    haystack elements should be space separated strings"
  pr default "    returns 0 or 1 for success and failure (respectfully)"
  pr default ""
}

# --------------------------------------------
function utils:array_elem_pos() {
  needle=$1
  shift

  local array=($*)

  local i
  i=0

  for (( i = 1; i <= ${#array}; i++ )); do
    if [[ "$needle" == "${array[$i]}" ]]; then
      return $i
    fi
  done

  return 0
}

function utils:array_elem_pos:usage() {
  pr default "utils:array_elem_pos: Search for element in array and returns position"
  pr default "    Usage: utils:array_elem_pos needle haystack"
  pr default "    haystack elements should be space separated strings"
  pr default "    ----- PAY ATTENTION TO RETURN VALUES -----"
  pr default "    returns the position of element (1 or above) when found"
  pr default "    returns 0 when element is not found"
  pr default ""
}

# -----------------------------------------------
function utils:argument_exists_or_not() {
  utils:array_search $*
  return $?
}

function utils:argument_exists_or_not:usage() {
  pr default "utils:argument_exists_or_not: looks for argument in supplied arguments"
  pr default "    Usage: utils:argument_exists_or_not arg_name all_args"
  pr default "    arg_name is the argument whose existence you want to check"
  pr default "    all_args is the list of all arguments supplied to the script or function"
  pr default "    returns 0 if arg_name is found in all_args; returns 1 otherwise"
  pr default ""
}

# -----------------------------------------------
function utils:array_unique() {
  # DEBUG=true
  if [[ -z "$1" ]]; then
    echo 'No element supplied. Run utils:array_unique:usage to learn the usage'
    return 1
  fi

  local array=($*)

  debugmsg "Input array: $array"
  debugmsg "Input array contains ${#array} element(s)"

  if [[ ${#array} -eq 1 ]]; then
    # Just one element in the array - it's bound to be unique
    debugmsg "Just one element in the array: $*"
    echo $*
    return 0
  fi

  debugmsg "More than one elements in input. Will filter duplicates"

  # We need to copy unique items to a second array which we shall return
  local -a array_duplicate
  # Copy the first element
  # NOTE: If we don't do this here, then the array_elem_pos function will fail to produce a correct result
  array_duplicate+=${array[1]}

  for (( i = 2; i <= ${#array}; i++ )); do
    if ! utils:array_search "${array[$i]}" ${array_duplicate[*]}; then
      # Element does not already exist in the duplicate array, add it there
      array_duplicate+=${array[$i]}
    fi
  done

  debugmsg "Unique array has ${#array_duplicate} element(s)"

  echo ${array_duplicate[*]}
  return 0
}

function utils:array_unique:usage() {
  pr default "utils:array_unique: Removes duplicates from a supplied array (as space-separated elements)"
  pr default "    Usage: utils:array_unique element1 [...element2]"
  pr default "    There has to be at least 1 parameter to the function"
  pr default "    Parameters are separated by blank space. Quote any strings with spaces in them."
  pr default ""
}

# -----------------------------------------------
function utils:get_argument_value() {
  local arg_pos
  local val_pos

  # must have at least 2 arguments
  if [[ $# -lt 2 ]]; then
    return 2
  fi

  # argument
  local needle
  needle=$1
  shift

  local array=($*)

  if utils:array_search $needle $array; then
    utils:array_elem_pos $needle $array
    arg_pos=$?
    ((val_pos = arg_pos + 1))
    print $array[val_pos]
    return 0
  fi

  print ""
  return 1
}

function utils:get_argument_value:usage_basic() {
  pr default "utils:get_argument_value: looks for argument in supplied arguments and gets its value"
  pr default "    Usage: utils:get_argument_value arg_name all_args"
  pr default "    arg_name is the argument whose value you are looking for"
  pr default "    all_args is the list of all arguments supplied to the script or function"
  pr default "    To learn more, run: utils:get_argument_value:usage"
  pr default "    "
}

function utils:get_argument_value:usage() {
  pr default "utils:get_argument_value: looks for argument in supplied arguments and gets its value"
  pr default "    Usage: utils:get_argument_value arg_name all_args"
  pr default "    arg_name is the argument whose value you are looking for"
  pr default "    all_args is the list of all arguments supplied to the script or function"
  pr default ""
  pr default "    NOTE: It cannot be used to detect if an argument is present in the argument list"
  pr default "          To detect if an argument is present or not, use utils:argument_exists_or_not"
  pr default "          Check Example 3 below to undertand"
  pr default ""
  pr default "    To capture the value of the argument, use an expression like: "
  pr default "    arg_value=\$(utils:get_argument_value '--dir' \$@)"
  pr default ""
  pr default "    If the argument value was found, arg_value would have that value."
  pr default "    If the argument value was NOT found, arg_value would have a blank string."
  pr default ""
  pr default "    You should be able to use the value of \$arg_value with a test. For example:"
  pr default "    if [ -z "\$arg_value" ]; then"
  pr default "      echo \"no argument value found\""
  pr default "    else"
  pr default "      echo \"argument value is \$arg_value\""
  pr default "    fi"
  pr default ""
  pr default "    The utility (function) returns 0 when argument is found; 1 otherwise"
  pr default "    However you should not rely on the return value."
  pr default "    Rely on the value captured in 'arg_value' instead"
  pr default ""
  pr default "    ====== Examples ======"
  pr default "    Example 1: "
  pr default "    arg_val=\$(utils:get_argument_value '--dir' '-v --dir /home/vaibhav/tmp --longform yes')"
  pr default "    would set \$arg_val to '/home/vaibhav/tmp' because it comes right after '--dir'"
  pr default ""
  pr default "    Example 2: "
  pr default "    arg_val=\$(utils:get_argument_value '--longform' '-v --dir /home/vaibhav/tmp --longform yes')"
  pr default "    would set \$arg_val to 'yes' because 'yes' comes right after '--longform'"
  pr default ""
  pr default "    Example 3: "
  pr default "    arg_val=\$(utils:get_argument_value '-v' '-v --dir /home/vaibhav/tmp --longform yes')"
  pr default "    would set \$arg_val to '--dir' because '--dir' comes right after '-v'"
  pr default ""
}

# -----------------------------------------------
function utils:args_do_conflict() {
  if [ $# -lt 3 ]; then
    # Only 2 arguments are acceptable
    # One should not be calling this method manually anyway
    return 1
  fi

  local first_arg
  local second_arg

  # argument
  first_arg=$1
  second_arg=$2
  shift 2

  local array=($*)

  local first_arg_exists
  first_arg_exists=0

  if utils:array_search $first_arg $array; then
    first_arg_exists=1
  fi

  if utils:array_search $second_arg $array; then
    # Second argument exists. 
    # If first also existed, then there is a conflict
    if [ $first_arg_exists -eq 1 ]; then
      # First arg also exists. Conflict exists. Return true
      return 0
    fi
  fi

  # no conflict
  return 1
}

function utils:args_do_conflict:usage() {
  pr default "utils:args_do_conflict: looks for argument confict in supplied arguments"
  pr default "    This utility can check if both arguments exist in a supplied list"
  pr default "    of arguments. It is useful in checking if both short-form and long-form"
  pr default "    formats of an option have been supplied to a script."
  pr default "    "
  pr default "    Returns true when there is a conflict."
  pr default "    "
  pr default "    Usage: utils:detect_args_conflict first_arg second_arg all_args"
  pr default "    first_arg is the first argument whose existence is being checked"
  pr default "    second_arg is the second argument whose existence is being checked"
  pr default ""
}

# -----------------------------------------------
function utils:get_unique_shortcodes() {
  local -a words
  words=($*)

  # Sort the words alphabetically
  # convert words to multi-line, sort them, convert lines into spaces and convert it into array
  words=($(echo $words | sed 's/ /\n/g' | sort | tr '\n' ' '))

  local shortcode_words
  shortcode_words=""

  local -a shortcodes
  # The number of characters we are scanning in the word
  local scan_depth
  scan_depth=1

  # one less than scan depth (useful for scanning characters)
  local scan_depth_minus_one
  scan_depth_minus_one=0

  # The current shortcode being considered
  local curr_shortcode

  # The word with only alphanum characters
  local curr_word

  # The current character which is going to be added to the curr_shortcode
  local curr_shortcode_char

  # Does the current shortcode qualify for being added
  local curr_shortcode_qualifies
  curr_shortcode_qualifies=0

  # Loop variable
  local i
  i=0

  # Result of array search in shortcode list
  local search_val

  for (( i = 1; i <= ${#words}; i++ )); do
    # Strip away non-alphanumerics
    curr_word=${${words[$i]}//[^a-zA-Z0-9]/}
    # we can also use this:
    # curr_word=$(echo ${words[$i]} | sed 's/[^a-zA-Z0-9]//g')
    # echo "current word: $curr_word"

    curr_shortcode_qualifies=0
    scan_depth=1
    scan_depth_minus_one=0
    curr_shortcode=${${curr_word}:0:$scan_depth}

    while [ $curr_shortcode_qualifies -eq 0 ]; do
      curr_shortcode=${${curr_word}:0:${scan_depth}}

      utils:array_search $curr_shortcode ${shortcodes[*]}
      search_val=$?

      if [[ "$search_val" -eq 1 ]]; then
        shortcodes+=("$curr_shortcode")
        shortcode_words+="${words[$i]}=${curr_shortcode} "
        curr_shortcode_qualifies=1
      else
        ((scan_depth++))
        ((scan_depth_minus_one++))
      fi
#      read -k1
    done
	done

	print "${shortcode_words}"
}

# check if the given command exists in $PATH or not
function utils:command_exists() {
  if [[ -z "$1" ]]; then 
    echo "Error: Command name required."
    echo ""
    echo "This utility checks if a given command exists in \$PATH"
    echo ""
    echo "Usage: ${funcstack[1]} command_name"
    return 1
  fi

  if ! type "$1" > /dev/null; then
    # command does not exist
    return 1
  else
    # command exists
    return 0
  fi
}

function utils:command_exists:usage() {
  pr default "utils:command_exists: checks if a given command exists in \$PATH"
  pr default "    Usage: utils:command_exists command_name"
  pr default "    returns 0 or 1 for success (command exists) and failure (does not exist)"
  pr default ""
}


################################################
# HELPER FUNCTION WHICH SHOULD NOT BE DOCUMENTED
################################################

function step() {
	return 0
}

function note() {
	return 0
}
