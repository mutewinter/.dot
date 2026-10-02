#!/usr/bin/env bash
# macOS settings that are set by hand once and otherwise drift between machines.
# Dock and Finder restart to pick theirs up; trackpad changes need a log out.
set -e

DOT="$(cd "$(dirname "$0")/.." && pwd)"
profile="${DOT_PROFILE:-$("$DOT/macos/profile.sh")}"

# Typing: no autocorrect, auto-capitalization, double-space period, or completion.
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticTextCompletionEnabled -bool false

# General UI
defaults write -g AppleShowAllExtensions -bool true
defaults write -g AppleActionOnDoubleClick -string Maximize
defaults write -g AppleEnableSwipeNavigateWithScrolls -bool false
defaults write -g com.apple.sound.uiaudio.enabled -int 0
defaults write -g com.apple.sound.beep.sound -string /System/Library/Sounds/Tink.aiff
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
# The Model 100 sends real F-keys; laptops keep media keys on the top row.
if [ "$profile" = desktop ]; then
  defaults write -g com.apple.keyboard.fnState -bool true
fi

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 57
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

# Finder
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

# Trackpad, for both the built-in and Magic Trackpad domains
for d in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  defaults write "$d" ActuateDetents -int 0
  defaults write "$d" Clicking -int 0
  defaults write "$d" DragLock -int 0
  defaults write "$d" Dragging -int 0
  defaults write "$d" FirstClickThreshold -int 1
  defaults write "$d" ForceSuppressed -bool true
  defaults write "$d" SecondClickThreshold -int 1
  defaults write "$d" TrackpadCornerSecondaryClick -int 0
  defaults write "$d" TrackpadFiveFingerPinchGesture -int 2
  defaults write "$d" TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write "$d" TrackpadFourFingerPinchGesture -int 2
  defaults write "$d" TrackpadFourFingerVertSwipeGesture -int 2
  defaults write "$d" TrackpadHandResting -bool true
  defaults write "$d" TrackpadHorizScroll -int 1
  defaults write "$d" TrackpadMomentumScroll -bool true
  defaults write "$d" TrackpadPinch -int 1
  defaults write "$d" TrackpadRightClick -bool true
  defaults write "$d" TrackpadRotate -int 1
  defaults write "$d" TrackpadScroll -bool true
  defaults write "$d" TrackpadThreeFingerDrag -bool false
  defaults write "$d" TrackpadThreeFingerHorizSwipeGesture -int 1
  defaults write "$d" TrackpadThreeFingerTapGesture -int 0
  defaults write "$d" TrackpadThreeFingerVertSwipeGesture -int 2
  defaults write "$d" TrackpadTwoFingerDoubleTapGesture -int 1
  defaults write "$d" TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
  defaults write "$d" USBMouseStopsTrackpad -int 0
done

killall Dock Finder 2>/dev/null || true
