-- Spoon (https://git.io/fhn6H) that handles modal key bindings
hs.loadSpoon('ModalMgr')

local utils = require 'utils'

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0.1

-- -----------------
-- Modal Keybindings
-- -----------------

local LAUNCHER_ID = 'LAUNCHER'
local HYPER = { 'ctrl', 'alt', 'cmd', 'shift' }

local MODES = {
  {
    id = LAUNCHER_ID,
    color = '#FF0000',
    key = 'space',
    modifiers = {'cmd'},
    bindings = {
      {
        description = 'Exit',
        key = 'space',
        modifiers = 'command',
        callback = utils.deactivateModal(LAUNCHER_ID),
      },
      {
        description = 'Toggle cheatsheet',
        key = '/',
        modifiers = 'shift',
        callback = utils.toggleCheatsheet,
      },
      {
        description = 'Reload hammerspoon',
        key = 'r',
        modifiers = 'shift',
        callback = function() hs.reload() end,
      },
      {
        description = 'Alfred',
        key = 'space',
        callback = utils.launchApp('Alfred 3'),
      },
      {
        description = 'Alacritty',
        -- Pneumonic, "[f]ast terminal"
        key = 'f',
        callback = utils.launchApp('Alacritty'),
      },
      {
        description = 'Safari',
        key = 's',
        callback = utils.launchApp('Safari'),
      },
      {
        description = 'Dash',
        key = 'd',
        -- Dash doesn't do well with app-based activation, so use a hotkey.
        callback = utils.keyStroke(HYPER, 'd'),
      },
      {
        description = 'Chrome',
        key = 'c',
        callback = utils.launchApp('Chrome'),
      },
      {
        description = 'Finder',
        key = 'i',
        callback = utils.launchOrHideApp('Finder'),
      },
      {
        description = 'nvAlt',
        key = 'n',
        callback = utils.launchOrHideApp('nvAlt'),
      },
    }
  }
}

utils.bindModes(MODES)
spoon.ModalMgr.supervisor:enter()

-- So we can easily tell when Hammerspoon loads successfully
hs.alert.show('Hammerspoon loaded')
