#!/usr/bin/env zsh

function define() {
	local term
	if [ $# -lt 1 ]; then
		#echo "Term not supplied."
		#return 1
		read -r term
	else
		term=$*
	fi

	open "https://duckduckgo.com/?ia=web&q=!d+${term}"
}

function define_oneliner() {
	echo "define: Opens the definition of a word in browser using duckduckgo"
}

function define_help() {
	echo "define"
	echo "Opens the definition of a word in browser using duckduckgo"
	echo ""
	echo "Usage:"
	echo "  define word_or_phrase"
	echo ""
	echo "word_or_phrase is mandatory."
}