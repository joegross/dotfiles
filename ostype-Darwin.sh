#!/bin/bash

# kill hangy android file transfer agent
rm -rf ~/Library/Application\ Support/Google/Android\ File\ Transfer/Android\ File\ Transfer\ Agent.app
rm -rf /Applications/Android\ File\ Transfer.app/Contents/Resources/Android\ File\ Transfer\ Agent.app
pkill -f 'Android File Transfer Agent'

# kill dock bounces
if [ "$(defaults read com.apple.dock no-bouncing)" != "1" ]; then
    defaults write com.apple.dock no-bouncing -bool TRUE
    killall Dock
fi

#launchctl stop com.apple.cfprefsd.xpc.agent
#cp osx/home/Library/Preferences/com.googlecode.iterm2.plist $HOME/Library/Preferences/com.googlecode.iterm2.plist
#launchctl start com.apple.cfprefsd.xpc.agent

# shut up safari
defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99

BREW_PACKAGES=(
  coreutils
  direnv
  docker
  docker-compose
  docker-machine
  git-subrepo
  gpg-agent
  graphviz
  mercurial
  pass
  pyenv
  pyenv-virtualenv
  pyenv-virtualenvwrapper
  python
  rbenv
  zsh-completions
  zsh-history-substring-search
  zsh-syntax-highlighting
)
brew install ${BREW_PACKAGES[@]}

# iterm shell integration
curl -sL https://iterm2.com/misc/zsh_startup.in -o $HOME/.iterm2_shell_integration.zsh

brew install emacs --cocoa --srgb # --with-gnutls
brew cask install haskell-platform

PIP_PACKAGES=(
  autopep8
  pip
  boto
  pip-tools
  python-magic
)
pip install --upgrade ${PIP_PACKAGES[@]}

./docker-machine-on-boot.sh

# zsh-git-prompt
# compile gitstatus (haskell)
cd $HOME/dev/zsh-git-prompt
stack setup
stack build
stack install


