-- ------
-- Config
-- ------

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0

-- allows us to place on quarters, thirds and halves
hs.grid.setGrid('12x12')
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

-- Global boolean to track triggered state of Hyper.
local hyperTriggered = false

-- --------
-- Bindings
-- --------

-- A hotkey modal to emulate the hyper key.
local hyperMode = hs.hotkey.modal.new({}, 'F17')

-- A custom keyStroke for ensuring that hyper's state is triggered and that
-- there is no delay.
-- https://github.com/Hammerspoon/hammerspoon/issues/1082
local keyStroke = function(modifiers, key)
  hyperTriggered = true

  -- The 0 removes the delay between key up and down
  hs.eventtap.keyStroke(modifiers, key, 0)
end

-- Create passthroughs to hyper (all modifiers) + the keys below.
local hyperBindings = {'n', 'return', 'space', 'd', 'f', '5', 'p'}

for _,key in ipairs(hyperBindings) do
  hyperMode:bind({}, key, nil, function()
    hyperTriggered = true
    keyStroke({'cmd', 'alt', 'shift', 'ctrl'}, key)
  end)
end

-- Create passthroughs to control + the keys below.
local controlBindings = {'l', 'v', 'j', 'k', 'g', 'c', 'y'}

for _,key in ipairs(controlBindings) do
  hyperMode:bind({}, key, nil, function()
    keyStroke({'ctrl'}, key)
  end)
end

-- Hyper+\: Lock screen.
hyperMode:bind({}, '\\', nil, function()
  hs.caffeinate.lockScreen()
end)

-- Hyper+4: Screenshot.
hyperMode:bind({}, '4', nil, function()
  keyStroke({'cmd', 'shift'}, '4')
end)

-- Hyper+=: Reload config
hyperMode:bind({}, '=', nil, function()
  hs.reload()
end)


-- ----------------------------
-- Window Resizing and Movement
-- ----------------------------

-- From Wincent's config: https://git.io/v1jJD
-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
local lastSeenChain = nil
local lastSeenWindow = nil

local chain = (function(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1
  local lastSeenAt = 0

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end)

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  fullScreen = '0,0 12x12',
  centeredBig = '2,0 8x12',
  centeredSmall = '2,2 8x8',
}

hyperMode:bind({}, ';', chain({
  grid.leftHalf,
  grid.leftThird,
  grid.leftTwoThirds,
}))

hyperMode:bind({}, '\'', chain({
  grid.rightHalf,
  grid.rightThird,
  grid.rightTwoThirds,
}))

hyperMode:bind({}, 'up', chain({
  grid.topHalf,
  grid.topThird,
  grid.topTwoThirds,
}))

hyperMode:bind({}, 'down', chain({
  grid.bottomHalf,
  grid.bottomThird,
  grid.bottomTwoThirds,
}))

hyperMode:bind({}, 'i', chain({
  grid.topLeft,
  grid.topRight,
  grid.bottomRight,
  grid.bottomLeft,
}))

hyperMode:bind({}, 'o', chain({
  grid.fullScreen,
  grid.centeredBig,
  grid.centeredSmall,
}))

-- -----------
-- Hyper Setup
-- -----------

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
local pressedF18 = function()
  hyperTriggered = false
  hyperMode:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed within the delay.
local releasedF18 = function()
  hyperMode:exit()
  if not hyperTriggered then
    keyStroke({}, 'escape')
  end
end

-- Bind the Hyper key
hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
