local utils = {}

function utils.launchOrHideApp(name)
  return function()
    local app = hs.application.find(name)
    if not app or app:isHidden() then
      hs.application.launchOrFocus(name)
    elseif hs.application.frontmostApplication() ~= app then
      app:activate()
    else
      app:hide()
    end
  end
end

function utils.launchOrFocusApp(name)
  return function()
    hs.application.launchOrFocus(name)
  end
end

function utils.keyStroke(modifiers, key)
  return function()
    hs.eventtap.keyStroke(modifiers, key, 0)
  end
end

function utils.moveActiveWindowToNextScreen()
  local win = hs.window.frontmostWindow()
  local screen = win:screen()
  win:moveToScreen(screen:next())
end

-- Adapted from https://git.io/fhcJq
function utils.screenCapture(interactive)
  return function()
    local filename = hs.fs.pathToAbsolute('~') ..
      '/Desktop/Screen Capture at ' ..
      os.date('!%Y-%m-%d-%T')..'.png'

    local args = ''

    if interactive then
      args = 'i'
    end

    args = '-' .. args .. 'u'

    hs.task.new('/usr/sbin/screencapture', nil, {args, filename}):start()
  end
end

return utils
