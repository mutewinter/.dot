#!/usr/bin/env bash
# Prints this machine's keyboard profile, which picks the app hotkey set:
# "desktop" (Model 100) or "laptop" (built-in keyboard). A Mac with a battery
# is a laptop unless ~/.config/dot/profile names the profile explicitly.
if [ -f "$HOME/.config/dot/profile" ]; then
  tr -d '[:space:]' < "$HOME/.config/dot/profile"
elif pmset -g batt | grep -q InternalBattery; then
  echo laptop
else
  echo desktop
fi
