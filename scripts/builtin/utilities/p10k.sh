#!/usr/bin/env zsh

# function to show the current session on a POWERLEVEL10K ZSH prompt
# Add 'curr_session' to the prompt
function prompt_curr_session() {
	if [[ -v ZSH_SESSION_NAME ]]; then
		p10k segment -b 184 -f 0 -i '⊚' -t "$ZSH_SESSION_NAME"
	else
		p10k segment -b white -f black -i '⊚ ' -t ""
	fi
}

