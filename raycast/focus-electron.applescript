#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Focus Electron
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Focuses the Electron app during dev
# @raycast.author Jeremy Mack
# @raycast.authorURL https://x.com/mutewinter

if application "Electron" is running then
    tell application "Electron" to activate
end if
