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
  direnv
  git-subrepo
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
for package in ${BREW_PACKAGES[@]}; do
  brew install $package
done

brew install emacs --cocoa --srgb # --with-gnutls
brew cask install haskell-platform

PIP_PACKAGES=(
  pip
  boto
  pip-tools
  python-magic
)

for package in ${PIP_PACKAGES[@]}; do
  pip install --upgrade $package
done

./docker-machine-on-boot.sh

# zsh-git-prompt (haskell)
cd $HOME/dev/zsh-git-prompt
stack setup
stack build
stack install


