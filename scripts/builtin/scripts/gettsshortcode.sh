#!/usr/bin/env zsh
printf $(([##36]($(date +%s) - 1600000000))) | pbcopy