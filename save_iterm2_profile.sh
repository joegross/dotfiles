#!/bin/bash

launchctl stop com.apple.cfprefsd.xpc.agent
cp $HOME/Library/Preferences/com.googlecode.iterm2.plist osx/home/Library/Preferences/com.googlecode.iterm2.plist
launchctl start com.apple.cfprefsd.xpc.agent
