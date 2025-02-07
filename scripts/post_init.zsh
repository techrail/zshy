#!/usr/bin/env zsh

# Put your post-initialization commands here
# Clean the PATH to have only unique entries
path=($(utils:array_unique $path))