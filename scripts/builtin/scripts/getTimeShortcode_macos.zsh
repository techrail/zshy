#!/usr/bin/env zsh

# pbcopy is always there on mac
printf "$(([##36]$(date -u +%s) - 1600000000))" | pbcopy 
