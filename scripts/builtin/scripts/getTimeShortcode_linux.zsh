#!/usr/bin/env zsh

# copyq needs to be installed on Linux!
local tsShortcode
tsShortcode=$(printf "$(([##36]$(date -u +%s) - 1600000000))")
copyq copy $tsShortcode
