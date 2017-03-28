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

mkdir -p $HOME/screenshots
defaults write com.apple.screencapture location $HOME/screenshots
killall SystemUIServer

# I never want apple photos
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# Install homebrew
if ! which brew > /dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

(cd "ansible" && ./ansible.sh)

# iterm shell integration
OUT="$HOME/.iterm2_shell_integration.zsh"
curl -sL https://iterm2.com/misc/zsh_startup.in -z "$OUT" -o "$OUT"

pip install --upgrade -r requirements.txt

# zsh-git-prompt
# compile gitstatus (haskell)
cd "$HOME/dev/zsh-git-prompt" || exit
stack setup
stack build
stack install
