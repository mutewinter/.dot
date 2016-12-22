-- ------
-- Config
-- ------

-- Disable animation for window resizing so it's instant.
hs.window.animationDuration = 0

-- Global boolean to track triggered state of Hyper.
local hyperTriggered = false

-- --------
-- Bindings
-- --------

-- A global variable for the Hyper Mode
local k = hs.hotkey.modal.new({}, 'F17')

-- Create passthroughs to hyper (all modifers) + the keys below.
local hyperBindings = {'n', 'return', 'space', 'd', 'f'}
local hyperModifiers = {'cmd', 'alt', 'shift', 'ctrl'}

for _,key in ipairs(hyperBindings) do
  k:bind({}, key, nil, function()
    hs.eventtap.keyStroke(hyperModifiers, key)
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

-- HYPER+;: for left one half window
k:bind({}, ';', function()
  if hs.window.focusedWindow() then
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  else
    hs.alert.show('No active window')
  end
  hyperTriggered = true
end)

-- HYPER+': for right one half window
k:bind({}, '\'', function()
  if hs.window.focusedWindow() then
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  else
    hs.alert.show('No active window')
  end
  hyperTriggered = true
end)

-- HYPER+o: Full screen.
k:bind({}, 'o', function()
  if hs.window.focusedWindow() then
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
  else
    hs.alert.show('No active window')
  end
  hyperTriggered = true
end)

-- HYPER+i: Center on screen.
k:bind({}, 'i', function()
  if hs.window.focusedWindow() then
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = (max.w / 3) / 2
    f.y = max.y
    f.w = max.w - (max.w / 3)
    f.h = max.h
    win:setFrame(f)
  else
    hs.alert.show('No active window')
  end
end)

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
