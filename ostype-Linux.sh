#!/bin/bash

PACKAGES=(
  direnv
  haskell-platform
  haskell-stack
  make
  mercurial
  pychecker
  texinfo
)

sudo apt-get install -y ${PACKAGES[@]}
