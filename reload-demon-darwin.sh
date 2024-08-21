#!/bin/bash

PLIST="com.andrewlevin.ytb2audiobot.plist"

RES=$(plutil -lint "$PLIST")

if ! echo "$RES" | grep -q "OK"; then
  echo "The plist file is not valid. Please check the following details:"
  echo "$RES"
  exit 1
fi

# shellcheck disable=SC2088
TARGET="$HOME/Library/LaunchAgents/$PLIST"

cp "$PLIST" "$TARGET"

launchctl unload "$TARGET"

launchctl load "$TARGET"
