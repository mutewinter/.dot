#!/usr/bin/env bash
# Shottr preferences, written key by key because the same domain also holds the
# license, account token, and telemetry, which stay out of this public repo.
set -e

d=cc.ffitch.shottr

# A running Shottr can write its in-memory settings back over these, so it is
# stopped first and reopened afterwards.
running=0
if pgrep -xq Shottr; then running=1; pkill -x Shottr; sleep 1; fi

mkdir -p "$HOME/Documents/Screenshots"
defaults write $d defaultFolder -string "$HOME/Documents/Screenshots"
defaults write $d 'KeyboardShortcuts_area' -string '{"carbonModifiers":6400,"carbonKeyCode":21}'
defaults write $d 'KeyboardShortcuts_fullscreen' -string '{"carbonModifiers":6400,"carbonKeyCode":20}'
defaults write $d 'KeyboardShortcuts_ocr' -bool false
defaults write $d 'Shottr.ObjImage: size' -string '0'
defaults write $d 'Shottr.ObjSpotlight: shape' -string 'rect'
defaults write $d 'Shottr.ObjSpotlight: size' -string '3'
defaults write $d 'Shottr.ObjText: pointerPresent' -string 'true'
defaults write $d 'Shottr.ObjText: size' -string '1'
defaults write $d 'Shottr.ObjText: style' -string '1'
defaults write $d 'afterGrabCopy' -bool false
defaults write $d 'afterGrabSave' -bool true
defaults write $d 'afterGrabShow' -bool true
defaults write $d 'allowTelemetry' -bool true
defaults write $d 'altZoomDirection' -bool false
defaults write $d 'alwaysOnTop' -bool false
defaults write $d 'areaCaptureMode' -string 'preview'
defaults write $d 'areaCustomGrabber' -bool false
defaults write $d 'bdrConfig' -string '{"blur":0,"colors":"091022,0D2162,144CA0,2B91E2,56C3FF,9AEBFF","filepath":"","gradEnd":"-0.33,-0.15","gradStart":"0.5,1.1","gradType":"radial","innerRadius":0,"inset":-1,"isOn":1,"minWidth":0,"mode":"mesh","name":"default","noise":0.03,"outerRadius":0,"padding":68,"ratio":0,"seed":25318513,"shadowIntensity":0.5,"stops":"0.15,0.3,0.6,0.8"}'
defaults write $d 'captureCursor' -string 'auto'
defaults write $d 'colorFormat' -string 'HEX'
defaults write $d 'contrastType' -string 'wcag2'
defaults write $d 'copyOnEsc' -bool true
defaults write $d 'customBackdropColor' -string '#6080A0'
defaults write $d 'customDrawingColor' -string '#000000'
defaults write $d 'customGradFrom' -string '#221448'
defaults write $d 'customGradTo' -string '#919BD2'
defaults write $d 'defaultColor' -string '#FF0C01'
defaults write $d 'downscaleOnSave' -bool false
defaults write $d 'enableMagicMouseZoom' -bool false
defaults write $d 'expandableCanvas' -bool true
defaults write $d 'headlessTextRendering' -bool true
defaults write $d 'notificationType' -string 'custom'
defaults write $d 'ocrRemoveBreaks' -bool false
defaults write $d 'preferLargeWindow' -bool true
defaults write $d 'primaryOCRLang' -string 'en-US'
defaults write $d 'realPixels' -bool false
defaults write $d 'saveFormat' -string 'Auto'
defaults write $d 'saveOnEsc' -bool false
defaults write $d 'scrollingCustomGrabber' -bool false
defaults write $d 'scrollingManualEnabled' -bool false
defaults write $d 'scrollingMax' -int 20000
defaults write $d 'scrollingReverseAutoscroll' -bool false
defaults write $d 'scrollingSpeed' -int 2
defaults write $d 'showMenubarIcon' -int 1
defaults write $d 'snappingMode' -int 2
defaults write $d 'thumbnailClosing' -string 'manual'
defaults write $d 'uploadMode' -string 'cloud'
defaults write $d 'windowShadow' -string 'trimmed'
defaults write $d 'windowSolidColor' -string '#404448'

if [ "$running" = 1 ]; then open -a Shottr; fi
