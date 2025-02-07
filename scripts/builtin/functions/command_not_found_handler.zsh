#!/usr/bin/env zsh

function command_not_found_handler() {
  if zshy check $1; then
    debugmsg "$1 is installed as a zshy extension"
    zshy run $*
  else
    echo "command not found: $1"
    return 127
  fi
}
