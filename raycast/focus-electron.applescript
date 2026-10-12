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

# The dev build is a renamed Electron.app: its process is still "Electron", so match the displayed name.
tell application "System Events"
    set devApps to every process whose displayed name is "Instrument (Dev)"
    if devApps is not {} then set frontmost of item 1 of devApps to true
end tell
