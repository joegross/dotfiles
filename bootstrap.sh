#!/bin/bash

base=$(dirname ${BASH_SOURCE})
cd $base
git pull origin master

function fetch_git {
  REPO=$1
  REPODIR=$(echo $REPO | sed 's/.*\/\(.*\)\.git$/\1/')
  OLDPWD=$(pwd)
  mkdir -p $HOME/dev
  DESTDIR="$HOME/dev/$REPODIR"
  if [ ! -d $DESTDIR ]; then
      git clone --recursive $REPO $DESTDIR
  fi
  cd $DESTDIR
  git pull && git submodule update --init --recursive
  cd $OLDPWD
}

fetch_git git@github.com:olivierverdier/zsh-git-prompt.git

# fetch_github git@github.com:sorin-ionescu/prezto.git
# test ! -L $HOME/.zprezto && ln -sf $HOME/dev/prezto $HOME/.zprezto

./linktree.py

OS=$(uname -s)
exec ./ostype-$OS.sh

