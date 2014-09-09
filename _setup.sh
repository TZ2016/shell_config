#!/bin/bash

#
# 1.  Configuration Variables and Preamble
#

# Set Colors

e_header() {
  printf "\n$(tput setaf 141)%s$(tput sgr0)\n" "$@"
}
e_success() {
  printf "$(tput setaf 64)✔ %s$(tput sgr0)\n" "$@"
}
e_error() {
  printf "$(tput setaf 1)✖ %s$(tput sgr0)\n" "$@"
}
e_warning() {
  printf "$(tput setaf 136)➜ %s$(tput sgr0)\n" "$@"
}

# Is Dropbox Installed?

if [ ! -d ""$HOME"/Dropbox" ]; then
  e_error "DROPBOX NOT FOUND"
  e_error "EXITING"
  exit 1
fi

# Set Directory Locations
# dropbox_assets_dir: This is the location of your 'assets' directory
# backup_dir: Desired path to a backup folder goes here here.

dropbox_assets_dir="$HOME"/Dropbox/_sharedConf/assets
backup_dir="$HOME"/Dropbox/_sharedConf/_bak/$(date "+%Y-%m-%d-%H_%M")

sudo -v # ask for password only at the beginning

e_header "---------- BEGINNING CONFIG SCRIPT ----------"
e_header "Hang tight.......here we go....."

# 2.    Symlinks to ~/dotfiles
#
#       Takes all files found in "$dropbox_assets_dir"/dotFiles/
#       and symlinks them to ~/

ASSETS="$dropbox_assets_dir"/dotfiles/*
SOURCE="$dropbox_assets_dir"/dotfiles/
DEST="$HOME"/

e_header "---------- Symlinking Dotfiles ----------"

shopt -s dotglob    #show dot files
if [ ! -d "$SOURCE" ]; then
  e_error "Can't find source directory: $SOURCE"
else
  for f in $ASSETS
  do
    if [ -L "$DEST"`basename "$f"` ]; then
      e_success "Already Linked: "$DEST"`basename "$f"`"
    else
      e_warning "Linking : `basename "$f"`"
      if [ -f "$DEST"`basename "$f"` ]; then
        if [ ! -d "$backup_dir"/dotfiles ]; then
          mkdir -p "$backup_dir"/dotfiles
        fi
        mv "$DEST"`basename "$f"` "$backup_dir"/dotfiles/`basename "$f"`
        ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
      else
        ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
      fi
    fi
  done
fi
source $HOME/.bash_profile
shopt -u dotglob    #reset dotglob
unset ASSETS
unset SOURCE
unset DEST

# 3.    Symlinks to /usr/custom/*
#
#       Takes all dirs found in "$dropbox_assets_dir"/custom/
#       and symlinks them to /usr/custom/

e_header "---------- Symlinking into /usr/custom ----------"

ASSETS="$dropbox_assets_dir"/custom/*
SOURCE="$dropbox_assets_dir"/custom/
DEST="/usr/custom/"

# set IFS to allow spaces in names
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
if [ ! -d "$SOURCE" ]; then
  e_error "Can't find source directory: $SOURCE"
else
  if [ ! -d "$DEST" ]; then
    sudo mkdir -p "$DEST"
  fi
  for f in $ASSETS
  do
    if [ -L "$DEST"`basename "$f"` ]; then
      e_success "Already Linked: "$DEST"`basename "$f"`"
    else
      e_warning "Linking : "$DEST"`basename "$f"`"
      if [ -e "$DEST"`basename "$f"` ]; then
        if [ ! -d "$backup_dir" ]; then
          mkdir -p "$backup_dir"
        fi
        sudo mv "$DEST"`basename "$f"` "$backup_dir"/`basename "$f"`
        sudo ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
      else
        sudo ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
        sudo chmod a+x "$DEST"`basename "$f"`
      fi
    fi
  done
fi
# restore $IFS
IFS=$SAVEIFS
unset ASSETS
unset SOURCE
unset DEST

# 4.    Symlinks to various application config
#
#     List:
#       Symlink files in "$dropbox_assets_dir"/conf/sublime/ to
#       ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/

e_header "---------- Symlinking config files ----------"

ASSETS="$dropbox_assets_dir"/conf/sublime/*
SOURCE="$dropbox_assets_dir"/conf/sublime/
printf "Input your username ->"
read USERNAME
DEST="/Users/$USERNAME/Library/Application Support/Sublime Text 3/Packages/User/"

# set IFS to allow spaces in names
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
if [ ! -d "$SOURCE" ]; then
  e_error "Can't find source directory: $SOURCE"
else
  if [ ! -d "$DEST" ]; then
    sudo mkdir -p "$DEST"
  fi
  for f in $ASSETS
  do
    if [ -L "$DEST"`basename "$f"` ]; then
      e_success "Already Linked: "$DEST"`basename "$f"`"
    else
      e_warning "Linking : "$DEST"`basename "$f"`"
      if [ -e "$DEST"`basename "$f"` ]; then
        if [ ! -d "$backup_dir" ]; then
          mkdir -p "$backup_dir"
        fi
        sudo mv "$DEST"`basename "$f"` "$backup_dir"/`basename "$f"`
        sudo ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
      else
        sudo ln -s "$SOURCE"`basename "$f"` "$DEST"`basename "$f"`
        sudo chmod a+x "$DEST"`basename "$f"`
      fi
    fi
  done
fi
# restore $IFS
IFS=$SAVEIFS
unset ASSETS
unset SOURCE
unset DEST

#
# Notify if Backups were created of any files above
#
e_header "---------- Processing Backups  ----------"
if [ -e $backup_dir ]; then
  e_warning "Backups moved to "$backup_dir""
else
  e_success "No Backups Created"
fi

e_header "---------- YAY! ALL DONE  ----------"
