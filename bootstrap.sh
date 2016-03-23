#!/bin/bash

base=$(dirname ${BASH_SOURCE})
cd $base
git pull origin master

function fetch_github {
  REPO=$1
  REPODIR=$(echo $REPO | sed 's/.*\/\(.*\)\.git$/\1/')
  OLDPWD=$(pwd)
  mkdir -p $HOME/dev
  DESTDIR="$HOME/dev/$REPODIR"
  if [ ! -d $DESTDIR ]; then
      git clone $REPO $DESTDIR
  fi
  cd $DESTDIR
  git pull
  cd $OLDPWD
}

fetch_github git@github.com:olivierverdier/zsh-git-prompt.git

# zpresto
#OLDPWD=$(pwd)
#DESTDIR="${ZDOTDIR:-$HOME}/.zprezto"
#if [ ! -d $DESTDIR ]; then
#    git clone --recursive https://github.com/sorin-ionescu/prezto.git $DESTDIR
#fi
#cd $DESTDIR
#git pull && git submodule update --init --recursive
#cd $OLDPWD

OSTYPE=$(uname -s |sed -e 's/GNU\///')
exec ./ostype-$OSTYPE.sh
