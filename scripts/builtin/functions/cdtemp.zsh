#!/usr/bin/env zsh

function cdtemp() {
	if [ -z "$1" ]; then
		local dirpath
		dirpath=$(mktemp -d)
		cd $dirpath
	else
		unset tmpdir
		local dirname
		local tmpdir
		tmpdir=$(string random alphanumeric)
		dirname="tmp.${tmpdir}"
		mkdir -p "$1/$dirname"
		cd $dirname
	fi
}

function cdtemp_oneliner() {
	echo "cdtemp: create a temporary and cd to it"
}