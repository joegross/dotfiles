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

#brew install pdftex
brew install emacs --cocoa --srgb # --with-gnutls
brew install direnv
brew install mercurial
brew install python
brew install pyenv
brew install pyenv-virtualenv
brew install pyenv-virtualenvwrapper
brew install zsh-completions
brew install zsh-history-substring-search
brew install zsh-syntax-highlighting
brew install graphviz
brew install rbenv
brew install git-subrepo
brew cask install haskell-platform

#pip install --upgrade virtualenv pyflakes

pip install --upgrade pip-tools

#pip-sync requirements.txt

./docker-machine-on-boot.sh

cd $HOME/dev/zsh-git-prompt
stack setup
stack build
stack install


