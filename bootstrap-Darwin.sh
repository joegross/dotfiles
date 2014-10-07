#!/bin/bash

set -e

launchctl stop com.apple.cfprefsd.xpc.agent
cp osx/home/Library/Preferences/com.googlecode.iterm2.plist $HOME/Library/Preferences/com.googlecode.iterm2.plist
launchctl start com.apple.cfprefsd.xpc.agent
