#!/bin/bash

tmutil addexclusion \
       "/Applications" \
       "/Library" \
       "/opt" \
       "/usr" \
       "/bin" \
       "/private" \
       "/System" \
       "/cores" \
       "/sbin" \
       
sudo tmutil removeexclusion "/Users"

#sudo tmutil removeexclusion "${HOME}"
#sudo tmutil addexclusion \
#     "$HOME/Applications" \
#     "$HOME/Desktop" \
#     "$HOME/Downloads" \
#     "$HOME/Library" \
#     "$HOME/Public" \
#     "$HOME/tmp" \

#対象外の確認: mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
#対象外の確認: ls -l@
