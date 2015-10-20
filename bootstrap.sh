#!/bin/bash

base=$(dirname ${BASH_SOURCE})
cd $base
git pull origin master

find home -type f -execdir ln -sf $(pwd)/home/{} ~/{} \;

emacs=$HOME/.emacs
dotemacs=$(pwd)/home/.emacs

settings=$HOME/.emacs.d/settings
dotsettings=$(pwd)/emacs.d/settings
mkdir -p $HOME/.emacs.d

if [ ! -e $emacs ]; then
    ln -sf $dotemacs $emacs
elif [ ! -L $emacs ]; then
    mv $emacs $emacs.orig
    ln -sf $dotemacs $emacs
fi

if [ ! -e $settings ]; then
    ln -sf $dotsettings $settings
elif [ ! -L $settings ]; then
    mv $settings $settings.orig
    ln -sf $dotsettings $settings
fi

if [ -e $macs ] && [ ! -L $emacs ]; then
    mv $emacs $emacs.orig
fi

if [ -e $settings ] && [ ! -L $settings ]; then
    mv $settings $settings.orig
fi

# zsh-git-prompt
OLDPWD=$(pwd)
mkdir -p $HOME/dev
DESTDIR="$HOME/dev/zsh-git-prompt"
if [ ! -d $DESTDIR ]; then
    git clone git@github.com:olivierverdier/zsh-git-prompt.git $DESTDIR
fi
cd $DESTDIR
git pull
cd $OLDPWD

# zpresto
OLDPWD=$(pwd)
DESTDIR="${ZDOTDIR:-$HOME}/.zprezto"
if [ ! -d $DESTDIR ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git $DESTDIR
fi
cd $DESTDIR
git pull && git submodule update --init --recursive
cd $OLDPWD

OSTYPE=$(uname -s |sed -e 's/GNU\///')
exec ./ostype-$OSTYPE.sh
