#!/bin/bash

set -e

base=$(dirname ${BASH_SOURCE})
cd $base
git pull origin master

find home -type f -execdir ln -sf $(pwd)/home/{} ~/{} \;

emacs=$HOME/.emacs
dotemacs=$(pwd)/home/.emacs

settings=$HOME/.emacs.d/settings
dotsettings=$(pwd)/home/.emacs.d/settings

if [ ! -e $emacs ]; then
    ln -s $dotemacs $emacs
elif [ ! -L $emacs ]; then
    mv $emacs $emacs.orig
    ln -s $dotemacs $emacs
fi

if [ ! -e $settings ]; then
    ln -s $dotsettings $settings
elif [ ! -L $settings ]; then
    mv $settings $settings.orig
    ln -s $dotsettings $settings
fi

if [ -e $macs ] && [ ! -L $emacs ]; then
    mv $emacs $emacs.orig
fi

if [ -e $settings ] && [ ! -L $settings ]; then
    mv $settings $settings.orig
fi

mkdir -p $HOME/dev
DESTDIR=$HOME/dev/zsh-git-prompt
if [ ! -d $DESTDIR ]; then
    git clone git@github.com:olivierverdier/zsh-git-prompt.git $DESTDIR
fi
cd $DESTDIR
git pull
popd

OSTYPE=$(uname -s |sed -e 's/GNU\///')
exec ./ostype-$OSTYPE.sh
