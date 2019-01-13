-- Spoon (https://git.io/fhn6H) that handles modal key bindings
hs.loadSpoon('ModalMgr')
hs.loadSpoon('MiroWindowsManager')

local utils = require 'utils'
local modalWrapper = require 'modal-wrapper'

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0

-- -----------------
-- Modal Keybindings
-- -----------------

local LAUNCHER_ID = 'LAUNCHER'
local WINDOW_MANAGEMENT_ID = 'WINDOW_MANAGEMENT'
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
        onEnter = modalWrapper.deactivateModal(LAUNCHER_ID),
      },
      {
        description = 'Toggle cheatsheet',
        key = '/',
        modifiers = 'shift',
        keepModalActive = true,
        onEnter = modalWrapper.toggleCheatsheet,
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
        onEnter = utils.showApp('Alfred 3'),
      },
      {
        description = 'Alacritty',
        -- Pneumonic, "[f]ast terminal"
        key = 'f',
        onEnter = utils.showApp('Alacritty'),
      },
      {
        description = 'Safari',
        key = 's',
        onEnter = utils.showApp('Safari'),
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
        onEnter = utils.showApp('Chrome'),
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
        id = WINDOW_MANAGEMENT_ID,
        color = '#0000FF',
        key = ';',
        description = 'Window Management',
        bindings = {
          {
            description = 'Exit',
            key = ';',
            onEnter = modalWrapper.deactivateModal(WINDOW_MANAGEMENT_ID),
          },
          {
            description = 'Exit',
            key = 'space',
            modifiers = 'command',
            onEnter = modalWrapper.deactivateModal(WINDOW_MANAGEMENT_ID),
          },
          {
            description = 'Window: Left',
            key = 'h',
            keepModalActive = true,
            onEnter = function() spoon.MiroWindowsManager:left() end,
            onRelease = function() spoon.MiroWindowsManager:leftRelease() end,
            onExit = function() spoon.MiroWindowsManager:releaseAll() end,
          },
          {
            description = 'Window: Down',
            key = 'j',
            keepModalActive = true,
            onEnter = function() spoon.MiroWindowsManager:down() end,
            onRelease = function() spoon.MiroWindowsManager:downRelease() end,
            onExit = function() spoon.MiroWindowsManager:releaseAll() end,
          },
          {
            description = 'Window: Up',
            key = 'k',
            keepModalActive = true,
            onEnter = function() spoon.MiroWindowsManager:up() end,
            onRelease = function() spoon.MiroWindowsManager:upRelease() end,
            onExit = function() spoon.MiroWindowsManager:releaseAll() end,
          },
          {
            description = 'Window: Right',
            key = 'l',
            keepModalActive = true,
            onEnter = function() spoon.MiroWindowsManager:right() end,
            onRelease = function() spoon.MiroWindowsManager:rightRelease() end,
            onExit = function() spoon.MiroWindowsManager:releaseAll() end,
          },
          {
            description = 'Window: Full Screen',
            key = 'o',
            keepModalActive = true,
            onEnter = function() spoon.MiroWindowsManager:fullscreen() end,
            onExit = function() spoon.MiroWindowsManager:releaseAll() end,
          },
          {
            description = 'Window: Next Screen',
            key = 'p',
            keepModalActive = true,
            onEnter = utils.moveActiveWindowToNextScreen,
          },
        },
      },
    }
  }
}

modalWrapper.bindModes(MODES, spoon.ModalMgr.supervisor)
spoon.ModalMgr.supervisor:enter()

-- So we can easily tell when Hammerspoon loads successfully
hs.alert.show('Hammerspoon loaded')
