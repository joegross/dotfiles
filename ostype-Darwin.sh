#!/bin/bash

# kill hangy android file transfer agent
rm -rf "$HOME/Library/Application Support/Google/Android File Transfer/Android File Transfer Agent.app"
rm -rf "/Applications/Android File Transfer.app/Contents/Resources/Android File Transfer Agent.app"
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

brew analytics off
brew install ghc
brew link --overwrite ghc
grep -v '^ *#' < brew-packages.txt | while IFS= read -r line
do
  brew install "$line"
done
brew install emacs --cocoa --srgb # --with-gnutls
# brew link --overwrite ghc cabal-install

# iterm shell integration
curl -sL https://iterm2.com/misc/zsh_startup.in -o "$HOME/.iterm2_shell_integration.zsh"

grep -v '^ *#' < brew-cask-packages.txt | while IFS= read -r line
do
  brew cask install "$line"
done

pip install --upgrade -r requirements.txt

# zsh-git-prompt
# compile gitstatus (haskell)
cd "$HOME/dev/zsh-git-prompt" || exit
stack setup
stack build
stack install
