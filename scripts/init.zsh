#!/usr/bin/env zsh

# Run Pre-init script
source ${0:a:h}/pre_init.zsh

# Initialize builtin utilities
source ${0:a:h}/builtin/init.zsh

ZSHY_EXT_HOME=""
if [[ -d "$HOME/bin/zshy/extensions" ]]; then
  # Set the ZSHY_EXT_HOME
  ZSHY_EXT_HOME="$HOME/bin/zshy/extensions"
fi

ZSHY_EXT_DATA=""
if [[ -d "$HOME/bin/zshy/extensions_data" ]]; then
  # Set the ZSHY_EXT_HOME
  ZSHY_EXT_DATA="$HOME/bin/zshy/extensions_data"
fi

export ZSHY_EXT_HOME
export ZSHY_EXT_DATA

# Check if the $HOME/bin/zshy/init.zsh file exists or not
# and if it does, then we have to source it
if [[ -f "$HOME/bin/zshy/init.zsh" ]]; then
  source "$HOME/bin/zshy/init.zsh"
fi

# Initialize the installed utilities
source ${0:a:h}/installed/init.zsh

# Run Post-init script
source ${0:a:h}/post_init.zsh
