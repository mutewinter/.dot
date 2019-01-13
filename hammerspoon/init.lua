-- Spoon (https://git.io/fhn6H) that handles modal key bindings
hs.loadSpoon('ModalMgr')
hs.loadSpoon('MiroWindowsManager')

local utils = require 'utils'

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0

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
        onEnter = utils.deactivateModal(LAUNCHER_ID),
      },
      {
        description = 'Toggle cheatsheet',
        key = '/',
        modifiers = 'shift',
        keepModalActive = true,
        onEnter = utils.toggleCheatsheet,
      },
      {
        description = 'Reload hammerspoon',
        key = 'r',
        modifiers = 'shift',
        onEnter = function() hs.reload() end,
      },

      -- -----------
      -- App Hotkeys
      -- -----------
      {
        description = 'Alfred',
        key = 'space',
        onEnter = utils.launchApp('Alfred 3'),
      },
      {
        description = 'Alacritty',
        -- Pneumonic, "[f]ast terminal"
        key = 'f',
        onEnter = utils.launchApp('Alacritty'),
      },
      {
        description = 'Safari',
        key = 's',
        onEnter = utils.launchApp('Safari'),
      },
      {
        description = 'Dash',
        key = 'd',
        -- Dash doesn't do well with app-based activation, so use a hotkey.
        onEnter = utils.keyStroke(HYPER, 'd'),
      },
      {
        description = 'Chrome',
        key = 'c',
        onEnter = utils.launchApp('Chrome'),
      },
      {
        description = 'Finder',
        key = 'i',
        onEnter = utils.launchOrHideApp('Finder'),
      },
      {
        description = 'nvAlt',
        key = 'n',
        onEnter = utils.launchOrHideApp('nvAlt'),
      },

      -- -----------------
      -- Window Management
      -- -----------------
      {
        description = 'Window: Left',
        key = 'h',
        onEnter = function() spoon.MiroWindowsManager:left() end,
        onRelease = function() spoon.MiroWindowsManager:leftRelease() end,
        onExit = function() spoon.MiroWindowsManager:releaseAll() end,
      },
      {
        description = 'Window: Down',
        key = 'j',
        onEnter = function() spoon.MiroWindowsManager:down() end,
        onRelease = function() spoon.MiroWindowsManager:downRelease() end,
        onExit = function() spoon.MiroWindowsManager:releaseAll() end,
      },
      {
        description = 'Window: Up',
        key = 'k',
        onEnter = function() spoon.MiroWindowsManager:up() end,
        onRelease = function() spoon.MiroWindowsManager:upRelease() end,
        onExit = function() spoon.MiroWindowsManager:releaseAll() end,
      },
      {
        description = 'Window: Right',
        key = 'l',
        onEnter = function() spoon.MiroWindowsManager:right() end,
        onRelease = function() spoon.MiroWindowsManager:rightRelease() end,
        onExit = function() spoon.MiroWindowsManager:releaseAll() end,
      },
      {
        description = 'Window: Full Screen',
        key = 'o',
        onEnter = function() spoon.MiroWindowsManager:fullscreen() end,
        onExit = function() spoon.MiroWindowsManager:releaseAll() end,
      },
      {
        description = 'Window: Next Screen',
        key = 'p',
        onEnter = utils.moveActiveWindowToNextScreen,
      },
    }
  }
}

utils.bindModes(MODES, spoon.ModalMgr.supervisor)
spoon.ModalMgr.supervisor:enter()

-- So we can easily tell when Hammerspoon loads successfully
hs.alert.show('Hammerspoon loaded')
