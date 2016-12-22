-- ------
-- Config
-- ------

hs.window.animationDuration = 0

-- --------
-- Bindings
-- --------

-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Hyper N: Passthrough
nfun = function()
  k.triggered = true
  hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, 'n')
end
k:bind({}, 'n', nil, nfun)

-- Hyper+Return: Passthrough
returnfun = function()
  k.triggered = true
  hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, 'return')
end
k:bind({}, 'RETURN', nil, returnfun)

-- Hyper+Space: Passthrough
spacefun = function()
  k.triggered = true
  hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, 'space')
end
k:bind({}, 'space', nil, spacefun)

-- HYPER+L: Act like ⌃l.
lfun = function()
  hs.eventtap.keyStroke({'⌃'}, 'l')
  k.triggered = true
end
k:bind({}, 'l', nil, lfun)

-- HYPER+J: Act like ⌃j.
jfun = function()
  hs.eventtap.keyStroke({'⌃'}, 'j')
  k.triggered = true
end
k:bind({}, 'j', nil, jfun)

-- HYPER+K: Act like ⌃k.
kfun = function()
  hs.eventtap.keyStroke({'⌃'}, 'k')
  k.triggered = true
end
k:bind({}, 'k', nil, kfun)

-- HYPER+C: Act like ⌃c and move to beginning of line.
cfun = function()
  hs.eventtap.keyStroke({'⌃'}, 'c')
  k.triggered = true
end
k:bind({}, 'c', nil, cfun)

-- Hyper+=: Reload config
ofun = function()
  hs.reload()
  hs.alert.show("Config loaded")
  k.triggered = true
end
k:bind({}, '=', nil, ofun)


-- ----------------------------
-- Window Resizing and Movement
-- ----------------------------

-- HYPER+;: for left one half window
k:bind(hyper, ';', function()
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
    hs.alert.show("No active window")
  end
end)

-- HYPER+': for right one half window
k:bind(hyper, '\'', function()
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
    hs.alert.show("No active window")
  end
end)

-- HYPER+o: Full screen.
k:bind(hyper, 'o', function()
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
    hs.alert.show("No active window")
  end
end)

-- HYPER+i: Center on screen.
k:bind(hyper, 'i', function()
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
    hs.alert.show("No active window")
  end
end)

-- -----------
-- Hyper Setup
-- -----------

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'escape')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
