#!/usr/bin/env zsh

alias re_source="source $HOME/.zshrc"

export ZSHY_HOME=${0:a:h}
export ZSHY_INSTALLED="yes"

function resh () {
	# echo "Running init script"
	source $ZSHY_HOME/scripts/init.zsh
}

resh

