local utils = {}

function utils.activateModal(id, color)
  return function()
    spoon.ModalMgr:deactivateAll()
    spoon.ModalMgr:activate({ id }, color, true)
  end
end

function utils.deactivateModal(id)
  return function()
    spoon.ModalMgr:deactivate({ id })
  end
end

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

function utils.launchApp(name)
  return function()
    hs.application.launchOrFocus(name)
  end
end

function utils.keyStroke(modifiers, key)
  return function()
    hs.eventtap.keyStroke(modifiers, key, 0)
  end
end

function utils.toggleCheatsheet()
  spoon.ModalMgr:toggleCheatsheet()
end

function utils.bindModes(modes)
  for _, mode in ipairs(modes) do
    -- Create the mode and register it with the supervisor
    spoon.ModalMgr:new(mode.id)
    local modalManager = spoon.ModalMgr.modal_list[mode.id]
    spoon.ModalMgr.supervisor:bind(
      mode.modifiers,
      mode.key,
      mode.description,
      utils.activateModal(mode.id, mode.color)
    )

    for _, binding in ipairs(mode.bindings) do
      modalManager:bind(
        binding.modifiers,
        binding.key,
        binding.description,
        function()
          binding.callback()
          spoon.ModalMgr:deactivate({ mode.id })
        end
      )
    end
  end
end

return utils
