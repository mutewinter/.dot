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

function utils.showApp(name)
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

return utils
