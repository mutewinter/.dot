-- Bug-fixed Spoon that handles modal key bindings
hs.loadSpoon('ModalMgr')
-- Modified Spoon that manages modal state and UI.
hs.loadSpoon('MiroWindowsManager')

local utils = require 'utils'
local K = require 'keys'
local ModalWrapper = require 'modal-wrapper'
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
hs.alert.defaultStyle.textSize = 14
hs.alert.defaultStyle.radius = 14
hs.alert.defaultStyle.atScreenEdge = 1
hs.alert.defaultStyle.fadeInDuration = 0
hs.alert.defaultStyle.fadeOutDuration = 0
hs.alert.defaultStyle.fillColor = { white = 0, alpha = 1 }

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0

-- via https://github.com/Hammerspoon/hammerspoon/issues/2605#issuecomment-735042645
hs.osascript = "DO NOT USE. MEMORY LEAK."
hs.itunes = "DO NOT USE. MEMORY LEAK." -- it uses osascript

-- ---------------
-- Global Bindings
-- ---------------
hs.hotkey.bind({ K.ctrl }, '\\', 'Lock', hs.caffeinate.lockScreen)

-- --------------
-- Modal Bindings
-- --------------

local modalWrapper = ModalWrapper:new({
  id = 'LAUNCHER',
  description = 'Launcher',
  color = '#00ff00',
  key = 'space',
  modifiers = { K.cmd },
  exitAfter = 3,
})
local HYPER = { K.ctrl, K.alt, K.cmd, K.shift }

local BINDINGS = {
  -- ------------
  -- Meta Hotkeys
  -- ------------
  {
    description = 'Exit',
    key = 'space',
    modifiers = { K.cmd },
    noAdditionalCommandBinding = true,
    onEnter = function() end,
  },
  {
    description = 'Exit',
    key = 'escape',
    onEnter = function() end,
  },
  {
    description = 'Toggle cheatsheet',
    key = '/',
    modifiers = { K.shift },
    keepModalActive = true,
    onEnter = function() modalWrapper:toggleCheatsheet() end,
  },
  {
    description = 'Reload hammerspoon',
    key = 'h',
    modifiers = { K.alt },
    onEnter = function() hs.reload() end,
  },

  -- -----------
  -- App Hotkeys
  -- -----------
  {
    description = 'Alfred',
    key = 'space',
    noAdditionalCommandBinding = true,
    onEnter = utils.launchOrFocusApp('Alfred 4'),
  },
  {
    description = 'Alfred',
    key = 'space',
    modifiers = { K.alt },
    noAdditionalCommandBinding = true,
    onEnter = utils.launchOrFocusApp('Alfred 4'),
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
    modifiers = { K.shift },
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
    -- [G]oogle Chrome
    key = 'g',
    onEnter = utils.launchOrFocusApp('Google Chrome'),
  },
  {
    description = 'Finder',
    key = 'i',
    onEnter = utils.launchOrHideApp('Finder'),
  },
  {
    description = 'Obsidian',
    -- Obsidia[n]
    key = 'n',
    onEnter = utils.launchOrFocusApp('Obsidian'),
  },
  {
    description = '1Password',
    key = '1',
    onEnter = utils.launchOrFocusApp('1Password 7'),
  },
  {
    description = '2Do',
    key = '2',
    onEnter = utils.launchOrFocusApp('2Do'),
  },
  {
    description = 'New 2Do',
    key = '2',
    modifiers = { K.shift },
    onEnter = utils.keyStroke(HYPER, '2'),
  },
  {
    description = 'Gi[t]Hub Desktop',
    key = 't',
    onEnter = utils.launchOrFocusApp('GitHub Desktop'),
  },
  -- D[r]afts
  {
    description = 'Drafts',
    key = 'r',
    onEnter = utils.launchOrFocusApp('Drafts'),
  },
  {
    description = 'New Trello Card',
    key = 'r',
    modifiers = { K.shift },
    onEnter = utils.keyStroke({ K.ctrl, K.alt, K.cmd }, 'space'),
  },
  {
    description = 'Slack',
    -- a is first letter unused in a binding from "Slack"
    key = 'a',
    onEnter = utils.launchOrFocusApp('Slack'),
  },
  -- Fig[m]a
  {
    description = 'Figma',
    key = 'm',
    onEnter = utils.launchOrFocusApp('Figma'),
  },
  -- Sizz[y]
  {
    description = 'Sizzy',
    key = 'y',
    onEnter = utils.launchOrFocusApp('Sizzy'),
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
    description = 'Configure Record Movie',
    key = '8',
    onEnter = utils.keyStroke(HYPER, '8'),
  },
  {
    description = 'Color Dropper',
    -- x marks the spot
    key = 'x',
    onEnter = utils.keyStroke(HYPER, 'x'),
  },

  -- -----------------
  -- Window Management
  -- -----------------
  {
    description = '⬅️',
    key = 'h',
    keepModalActiveWithCommand = true,
    onEnter = function() spoon.MiroWindowsManager:left() end,
    onRelease = function() spoon.MiroWindowsManager:leftRelease() end,
    onExit = function() spoon.MiroWindowsManager:releaseAll() end,
  },
  {
    description = '⬇️',
    key = 'j',
    keepModalActiveWithCommand = true,
    onEnter = function() spoon.MiroWindowsManager:down() end,
    onRelease = function() spoon.MiroWindowsManager:downRelease() end,
    onExit = function() spoon.MiroWindowsManager:releaseAll() end,
  },
  {
    description = '⬆️',
    key = 'k',
    keepModalActiveWithCommand = true,
    onEnter = function() spoon.MiroWindowsManager:up() end,
    onRelease = function() spoon.MiroWindowsManager:upRelease() end,
    onExit = function() spoon.MiroWindowsManager:releaseAll() end,
  },
  {
    description = '➡️',
    key = 'l',
    keepModalActiveWithCommand = true,
    onEnter = function() spoon.MiroWindowsManager:right() end,
    onRelease = function() spoon.MiroWindowsManager:rightRelease() end,
    onExit = function() spoon.MiroWindowsManager:releaseAll() end,
  },
  {
    description = '↔️',
    key = 'o',
    keepModalActiveWithCommand = true,
    onEnter = function() spoon.MiroWindowsManager:fullscreen() end,
    onExit = function() spoon.MiroWindowsManager:releaseAll() end,
  },
  {
    description = '⏩',
    key = 'p',
    keepModalActiveWithCommand = true,
    onEnter = utils.moveActiveWindowToNextScreen,
  },
}

modalWrapper:bindKeys(BINDINGS)
modalWrapper:start()

-- ---------------------
-- App-Specific Bindings
-- ---------------------

AppBinding:new('Dash', {
  {
    key = 'j',
    modifiers = { K.cmd },
    onEnter = utils.keyStroke(nil, 'down'),
  },
  {
    key = 'k',
    modifiers = { K.cmd },
    onEnter = utils.keyStroke(nil, 'up'),
  },
})

-- So we can easily tell when Hammerspoon loads successfully
hs.alert.show('Hammerspoon loaded')
