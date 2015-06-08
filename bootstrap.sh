#!/bin/bash

set -e

base=$(dirname ${BASH_SOURCE})
cd $base
git pull origin master

find home -type f -execdir ln -sf $(pwd)/home/{} ~/{} \;

mkdir -p $HOME/.emacs.d
emacs=$HOME/.emacs
dotemacs=$(pwd)/.emacs
settings=$HOME/.emacs.d/settings
dotsettings=$(pwd)/.emacs.d/settings

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

OSTYPE=$(uname -s |sed -e 's/GNU\///')
exec ./bootstrap-$OSTYPE.sh
