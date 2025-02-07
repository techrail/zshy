#!/usr/bin/env zsh

function ws() {
	local input
	if [ $# -lt 1 ]; then
		clpr --no-newline blue "What do you want to search the web for? Input: "
		#return 1
		read -r input
	else
		input="$*"
	fi

	local term 
	term=$(echo "$input" | tr ' ' '+')

	open "https://duckduckgo.com/?ia=web&q=${term}"
}

function ws_oneliner() {
	echo "ws: Performs a web search for a given term using duckduckgo"
}

function ws_help() {
	echo "ws"
	echo "Performs a web search for a given term using duckduckgo"
	echo ""
	echo "Usage:"
	echo "  ws term"
	echo ""
	echo "term is mandatory."
	echo ""
}