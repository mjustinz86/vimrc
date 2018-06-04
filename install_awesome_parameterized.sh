#!/bin/bash
set -e

usr=''
pdir=''

if [ -z "$1" ]
then
	usrd=$(echo ~)
else
	# convert non-directory usrs to directories
	if [ ! -d "$1" ]; then
		usrd=$(echo "~$1")
	else
		usrd="$1"
	fi
fi

if [ -z "$2" ]
then
    pdir="$(pwd)"
else
	pdir="$2"
fi

echo 'Installing Awesome Vim from '$pdir
cd $pdir

VIMRC="set runtimepath+=$pdir

source $pdir/vimrcs/basic.vim
source $pdir/vimrcs/filetypes.vim
source $pdir/vimrcs/plugins_config.vim
source $pdir/vimrcs/extended.vim

try
source $pdir/my_configs.vim
catch
endtry"

if [ $usrd == "--all" ]; then
    USERS=($(ls -l /home | awk '{if(NR>1)print $9}'))
    for user in ${USERS[*]}; do
        homepath=$(echo "~$user")
        IFS=''
        echo $VIMRC > ${homepath}/.vimrc
        unset IFS
        echo "Installed the Ultimate Vim configuration for user $user"
    done
    echo "Ultimate Vim installed"
    exit 0
else
	if [ ! -d "$usrd" ]; then
		mkdir $usrd
	fi
	IFS=''
	echo $VIMRC > ${usrd}/.vimrc
	unset IFS
	echo "Installed the Ultimate Vim configuration at $usrd"
    exit 0
fi

