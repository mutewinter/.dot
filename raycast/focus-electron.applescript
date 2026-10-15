#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Focus Electron
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Focuses a running Instrument dev build, asking which one when several are up
# @raycast.author Jeremy Mack
# @raycast.authorURL https://x.com/mutewinter

# Each dev build is a copy of Electron.app under node_modules, named "Instrument (Dev)" or "Instrument <purpose>"
# when studio-drive booted it, and studio-drive passes its Dock dot color as STUDIO_DRIVE_COLOR.
# One line per build: "<dot> <name>  ·  <checkout>", a tab, then the bundle path.
set listing to do shell script "
/bin/ps -axww -o pid=,command= | /usr/bin/grep -E '/node_modules/.*/[^/]+[.]app/Contents/MacOS/Electron( |$)' | /usr/bin/grep -v -e '--type=' | while read -r pid cmd; do
  app=$(printf '%s' \"$cmd\" | /usr/bin/sed -E 's#[.]app/Contents/MacOS/Electron.*#.app#')
  name=$(/usr/bin/basename \"$app\" .app)
  checkout=$(/usr/bin/basename \"${app%%/node_modules/*}\")
  [ \"$checkout\" = studio ] && checkout=$(/usr/bin/basename \"${app%%/apps/studio/node_modules/*}\")
  case \"$(/bin/ps -ww -E -o command= -p \"$pid\" | /usr/bin/tr ' ' '\\n' | /usr/bin/sed -n 's/^STUDIO_DRIVE_COLOR=//p')\" in
    red) dot='🔴' ;; orange) dot='🟠' ;; green) dot='🟢' ;; teal) dot='🩵' ;; blue) dot='🔵' ;; pink) dot='🩷' ;; *) dot='⚪️' ;;
  esac
  printf '%s %s  ·  %s\\t%s\\n' \"$dot\" \"${name#Instrument }\" \"$checkout\" \"$app\"
done | /usr/bin/sort"

if listing is "" then return "No Instrument dev build is running"

set labels to {}
set bundles to {}
set AppleScript's text item delimiters to tab
repeat with entry in paragraphs of listing
	set end of labels to text item 1 of entry
	set end of bundles to text item 2 of entry
end repeat
set AppleScript's text item delimiters to ""

if (count of labels) is 1 then
	set picked to item 1 of labels
else
	tell application "System Events"
		activate
		set choice to choose from list labels with title "Focus Electron" with prompt "Which build?" default items {item 1 of labels}
	end tell
	if choice is false then return
	set picked to item 1 of choice
end if

repeat with i from 1 to count of labels
	if item i of labels is picked then
		# Opening the running bundle sends it a reopen, which also brings up windows a driven build keeps off screen.
		do shell script "/usr/bin/open -a " & quoted form of item i of bundles
		return picked
	end if
end repeat
