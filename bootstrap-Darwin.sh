#!/bin/bash

rm -rf ~/Library/Application\ Support/Google/Android\ File\ Transfer/Android\ File\ Transfer\ Agent.app
rm -rf /Applications/Android\ File\ Transfer.app/Contents/Resources/Android\ File\ Transfer\ Agent.app
pkill -f 'Android File Transfer Agent'

# kill dock bounces
defaults write com.apple.dock no-bouncing -bool TRUE
killall Dock

#launchctl stop com.apple.cfprefsd.xpc.agent
#cp osx/home/Library/Preferences/com.googlecode.iterm2.plist $HOME/Library/Preferences/com.googlecode.iterm2.plist
#launchctl start com.apple.cfprefsd.xpc.agent

#brew install pdftex
brew install zsh-completions
brew install zsh-history-substring-search
brew install zsh-syntax-highlighting
brew install direnv
