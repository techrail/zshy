#!/usr/bin/env zsh

# Things to run before anything and everything
source ${0:a:h}/bootup.zsh
# Create the aliases
source ${0:a:h}/aliases.zsh
# Export the needed variables
source ${0:a:h}/exports.zsh
# Initialize functions
source ${0:a:h}/functions.zsh
# Setup ZSH hooks
source ${0:a:h}/hooks.zsh
# Clean artifacts of the ZexT bootup process
source ${0:a:h}/cleanup.zsh
# certain things that require to be run post initialization
source ${0:a:h}/post_init.zsh
