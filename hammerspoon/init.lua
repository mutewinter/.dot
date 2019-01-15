-- Bug-fixed Spoon that handles modal key bindings
hs.loadSpoon('ModalMgr')
-- Modified Spoon that manages modal state and UI.
hs.loadSpoon('MiroWindowsManager')

local utils = require 'utils'
local modalWrapper = require 'modal-wrapper'
local AppBinding = require 'app-binding'

-- --------
-- Settings
-- --------
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.consoleOnTop(true)
hs.dockIcon(false)
hs.menuIcon(true)
hs.uploadCrashData(false)

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0

-- ---------------
-- Global Bindings
-- ---------------
hs.hotkey.bind({ 'ctrl' }, '\\', 'Lock', hs.caffeinate.lockScreen)

-- --------------
-- Modal Bindings
-- --------------

local LAUNCHER_ID = 'LAUNCHER'
local HYPER = { 'ctrl', 'alt', 'cmd', 'shift' }

local MODES = {
  {
    id = LAUNCHER_ID,
    color = '#00ff00',
    key = 'space',
    modifiers = {'cmd'},
    bindings = {
      -- ------------
      -- Meta Hotkeys
      -- ------------
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
        onEnter = utils.launchOrFocusApp('Alfred 3'),
      },
      {
        description = 'Alacritty',
        -- Pneumonic, "[f]ast terminal"
        key = 'f',
        onEnter = utils.launchOrFocusApp('Alacritty'),
      },
      {
        description = 'Safari',
        key = 's',
        onEnter = utils.launchOrFocusApp('Safari'),
      },
      {
        description = 'Safari - New Window',
        key = 's',
        modifiers = 'shift',
        onEnter = function()
          local app = hs.application.find('Safari')
          if app then
            app:activate()
            app:selectMenuItem('New Window')
          else
            hs.application.launchOrFocus('Safari')
          end
        end,
      },
      {
        description = 'Dash',
        key = 'd',
        -- Dash doesn't do well with app-based activation, so use a hotkey.
        onEnter = utils.keyStroke(HYPER, 'd'),
      },
      {
        description = 'Google Chrome',
        -- Pneumonic [G]o to Chrome. "g" because it's on the home row.
        key = 'g',
        onEnter = utils.launchOrFocusApp('Google Chrome'),
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
      {
        description = '1Password',
        key = '1',
        onEnter = utils.launchOrHideApp('1Password 7'),
      },
      {
        description = '2Do',
        key = '2',
        onEnter = utils.launchOrFocusApp('2Do'),
      },
      {
        description = 'New 2Do',
        key = '2',
        modifiers = { 'shift' },
        onEnter = utils.keyStroke(HYPER, '2'),
      },
      {
        description = 'Tower',
        key = 't',
        onEnter = utils.launchOrFocusApp('Tower'),
      },
      {
        description = 'Slack',
        -- a is first letter unused in a binding from "Slack"
        key = 'a',
        onEnter = utils.launchOrFocusApp('Slack'),
      },

      -- --------------
      -- Screen Capture
      -- --------------
      {
        description = 'Screenshot',
        key = '3',
        onEnter = utils.screenCapture(),
      },
      {
        description = 'Screenshot Selection',
        key = '4',
        onEnter = utils.screenCapture(true),
      },
      {
        description = 'GIF Selection',
        key = '5',
        onEnter = utils.keyStroke(HYPER, '5'),
      },
      {
        description = 'GIF Window',
        key = '6',
        onEnter = utils.keyStroke(HYPER, '6'),
      },
      {
        description = 'Color Dropper',
        key = 'c',
        onEnter = utils.keyStroke(HYPER, 'c'),
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
        description = 'Window: Center',
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

modalWrapper.bindModes(MODES, spoon.ModalMgr.supervisor)
spoon.ModalMgr.supervisor:enter()

-- ---------------------
-- App-Specific Bindings
-- ---------------------

AppBinding:new('Dash', {
  {
    key = 'j',
    modifiers = 'command',
    onEnter = utils.keyStroke(nil, 'down'),
  },
  {
    key = 'k',
    modifiers = 'command',
    onEnter = utils.keyStroke(nil, 'up'),
  },
})

-- So we can easily tell when Hammerspoon loads successfully
hs.alert.show('Hammerspoon loaded')
