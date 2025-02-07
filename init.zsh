#!/usr/bin/env zsh

export ZSHY_HOME=${0:a:h}

function resh () {
	# echo "Running init script"
	source $ZSHY_HOME/scripts/init.zsh
}

resh
