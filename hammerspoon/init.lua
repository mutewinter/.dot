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
local k = hs.hotkey.modal.new({}, 'F17')

-- Create passthroughs to hyper (all modifers) + the keys below.
local hyperBindings = {'n', 'return', 'space', 'd', 'f'}

for _,key in ipairs(hyperBindings) do
  k:bind({}, key, nil, function()
    hs.eventtap.keyStroke({'cmd', 'alt', 'shift', 'ctrl'}, key)
    hyperTriggered = true
  end)
end

-- Create passthroughs to control + the keys below.
local controlBindings = {'l', 'j', 'k', 'c'}

for _,key in ipairs(controlBindings) do
  k:bind({}, key, nil, function()
    hs.eventtap.keyStroke({'ctrl'}, key)
    hyperTriggered = true
  end)
end

-- Hyper+=: Reload config
k:bind({}, '=', nil, function()
  hs.reload()
  hyperTriggered = true
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

k:bind({}, ';', chain({
  grid.leftHalf,
  grid.leftThird,
  grid.leftTwoThirds,
}))

k:bind({}, '\'', chain({
  grid.rightHalf,
  grid.rightThird,
  grid.rightTwoThirds,
}))

k:bind({}, 'up', chain({
  grid.topHalf,
  grid.topThird,
  grid.topTwoThirds,
}))

k:bind({}, 'down', chain({
  grid.bottomHalf,
  grid.bottomThird,
  grid.bottomTwoThirds,
}))

k:bind({}, 'i', chain({
  grid.topLeft,
  grid.topRight,
  grid.bottomRight,
  grid.bottomLeft,
}))

k:bind({}, 'o', chain({
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
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
local releasedF18 = function()
  k:exit()
  if not hyperTriggered then
    hs.eventtap.keyStroke({}, 'escape')
  end
end

-- Bind the Hyper key
hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
