#!/bin/bash

base=$(dirname "${BASH_SOURCE[0]}")
cd "$base" || exit
git pull origin master

function fetch_git {
  REPO=$1
  REPODIR=$(echo "$REPO" | sed 's/.*\/\(.*\)\.git$/\1/')
  OLDPWD=$(pwd)
  mkdir -p "$HOME"/dev
  DESTDIR="$HOME/dev/$REPODIR"
  if [ ! -d "$DESTDIR" ]; then
      git clone --recursive "$REPO" "$DESTDIR"
  fi
  cd "$DESTDIR" || exit
  git pull && git submodule update --init --recursive
  cd "$OLDPWD" || exit
}

# fetch_git git@github.com:olivierverdier/zsh-git-prompt.git

# fetch_github git@github.com:sorin-ionescu/prezto.git
# test ! -L $HOME/.zprezto && ln -sf $HOME/dev/prezto $HOME/.zprezto

./linktree.py

OS=$(uname -s)
./ostype-"$OS".sh
