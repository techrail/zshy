#!/usr/bin/env zsh

function bg() {
	if [[ $# -eq 0 ]]; then
		clpr red "No argument supplied. ${funcstack[1]} needs a command to run"
		return 0
	fi

	eval "nohup $* 1>/dev/null 2>/dev/null &"
}

function bg_oneliner() {
	echo "bg: run something in background"
}

function bg_help() {
	clpr blue "usage:"
	clpr default "bg <command>"
	clpr default ""
	clpr default "Runs the given command in background using '1>/dev/null 2>/dev/null &'"
}