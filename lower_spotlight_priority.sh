#!/bin/bash

plist="/System/Library/LaunchDaemons/com.apple.metadata.mds.plist"
sudo launchctl unload $plist
sudo /usr/libexec/PlistBuddy -c 'set :LowPriorityBackgroundIO true' $plist
if ! sudo /usr/libexec/PlistBuddy -c 'Print Nice:' $plist > /dev/null 2>&1; then
    sudo /usr/libexec/PlistBuddy -c 'Add Nice integer 20' $plist
fi
sudo launchctl load $plist
