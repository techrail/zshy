#!/usr/bin/env zsh

# Make sure that git is installed
if ! type "git" > /dev/null; then
  # command does not exist
  echo "git is not available in PATH"
  echo "This script depends on git being available. Please install git and try running the installer again"
  return 1
fi

# Set the installation folder to ~/.zshy
if [[ -v ZSHY_HOME && ! -d ZSHY_HOME ]]; then
  # ZSHY is installed already
  echo "It looks like ZSHY scripts are already installed."
  echo "You might want to upgrade it, maybe (currently upgrading automatically is not supported)"
  echo "However we can try to pull from git."
  read -k 1 "choice?Should we try? [y/n] "
  echo "" 
  if [[ $choice == "Y" || $choice == "y" ]]; then 
    echo "trying to pull from remote..."
    git pull
    if [ $? -ne 0 ]; then
      echo "Bummer. Looks like something did not go well."
      return 1
    else
      echo "Update succeeded it seemns. You can run 'resh' to reload the framework."
      echo "Or you can try to run 'source ~/.zshrc'"
      return 0
    fi
  else
    echo "you chose not to pull from remote"
  fi
  return 1
fi

ZSHY_HOME=$HOME/.zshy

# We will store the current path in a variable so that we return to it after installation is done.
__currdir=$(pwd)

# Change to the directory where the installer script is present
cd ${0:a:h}

# Make the directory for installing .zshy
echo "Making directory for storing scripts ($ZSHY_HOME)"
mkdir -p $ZSHY_HOME
if [ $? -ne 0 ]; then
  echo "Creating the scripts home directory ($ZSHY_HOME) failed. Cannot continue!"
  return 1
fi

# copy files in the zsh/scripts to the newly created directory
echo "Copying scripts to scripts home..."
cp -rv ./ $ZSHY_HOME

echo "The installer, to make life a bit easy for you, can create a 'bin' directory"
echo "in your home directory and add it to your PATH. It would also create the"
echo "'zshy' directory and the 'init.zsh' file inside it, if it does not exist."
echo "This step will also create the extensions folder to install zshy extension scripts."
echo ""
read -k 1 "choice?Do you want to continue? [y/n] "
echo ""
  
home_bin_zshy_dir="$HOME/bin/zshy"             # home_bin_zshy_dir = zshy directory inside the bin directory of user's HOME
zshy_ext_dir="$home_bin_zshy_dir/extensions"   # zshy_ext_dir = bin extensions folder
zshy_ext_data_dir="$home_bin_zshy_dir/extensions-data"   # zshy_ext_dir = bin extensions data folder
bininit="$home_bin_zshy_dir/init.zsh"

if [[ $choice == "Y" || $choice == "y" ]]; then
  # We have to create the 'bin' directory and the 'zshy' directory in it
  create_bininit="no"
  create_extdir="no"

  echo "You opted to create the $bininit file."

  if [[ -d "$home_bin_zshy_dir" ]]; then
    echo "The directory $home_bin_zshy_dir already exists."
    echo -n "Checking for the 'init.zsh' file... "
    if [[ -f "$bininit" ]]; then
      echo "already exists"
    else
      echo "does not exist"
      # We need to create the init file
      create_bininit="yes"
    fi
    
    echo -n "Checking for the extensions directory... "
    if [[ -d "$zshy_ext_dir" ]]; then
      echo "already exists"
    else
      echo "does not exist"
      # We need to create the init file
      create_extdir="yes"
    fi
  elif [[ -f "$home_bin_zshy_dir" ]]; then
    echo "The path $home_bin_zshy_dir already exists but is a file."
  else
    echo "The path $home_bin_zshy_dir does not exist. Creating the directory..."
    mkdir -p "$home_bin_zshy_dir"
    if [[ $? -eq 0 ]]; then
      echo "Directory created successfully."
      create_bininit="yes"
      create_extdir="yes"
    else
      echo "Failed to create directory."
    fi
  fi

  if [[ $create_bininit == "yes" ]]; then
    echo "Creating the file: $bininit"
  
    echo "#!/usr/bin/env zsh\n\n" > "$bininit"
  
    if [ $? -ne 0 ]; then
      echo "Creating the $bininit file failed!"
    else
      echo "# Place your shell initialization instructions such as updates to your \$PATH, aliases," >> "$bininit"
      echo "# custom functions etc. in this file. This file is source'd on each shell initialization\n\n" >> "$bininit"
      echo "...success"
    fi
  fi

  if [[ $create_extdir == "yes" ]]; then
    mkdir -p $zshy_ext_dir
    if [ $? -ne 0 ]; then
      echo "E#29W1BO: Creating the extensions directory failed!"
    fi 
    
    mkdir -p $zshy_ext_data_dir
    if [ $? -ne 0 ]; then
      echo "E#29W1C0: Creating the extensions data directory failed!"
    fi 
  fi
else
  echo "You opted to not create the $bininit file."
fi  

# Since this will work only on the next startup, for now, let's initialize the functions right now
echo "Trying to enable the scripts right now."
if [[ -v ZSHY_HOME ]]; then 
  source $HOME/.zshrc
else
  echo "source $ZSHY_HOME/init.zsh" >> $HOME/.zshrc
  source $ZSHY_HOME/init.zsh
fi

echo "For complete effect, please close this shell and start a new one"


