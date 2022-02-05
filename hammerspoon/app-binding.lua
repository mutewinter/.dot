-- Bind keys only when a specific app is focused

local obj = {}
obj.__index = obj

local ACTIVATED = hs.application.watcher.activated

function obj:new(appName, bindings)
  local newObj = {}
  setmetatable(newObj, obj)

  self._appName = appName
  self._bindings = bindings
  self:setupWatcher()

  return newObj
end

function obj:setupWatcher()
  self._appWatcher = hs.application.watcher.new(function(appName, eventType, _)
    if appName == self._appName then
      if eventType == ACTIVATED then
        self._modal:enter()
      else
        self._modal:exit()
      end
    end
  end)

  self._modal = hs.hotkey.modal.new()

  for _, binding in ipairs(self._bindings) do
    self._modal:bind(
      binding.modifiers,
      binding.key,
      binding.description,
      binding.onEnter,
      binding.onRelease
    )
  end

  self._appWatcher:start()
end

return obj
