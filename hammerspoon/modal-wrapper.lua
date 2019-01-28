local function activateModal(id, color)
  return function()
    spoon.ModalMgr:deactivateAll()
    spoon.ModalMgr:activate({ id }, color, false)
  end
end

local modalWrapper = {}

function modalWrapper.toggleCheatsheet()
  spoon.ModalMgr:toggleCheatsheet()
end

function modalWrapper.deactivateModal(id)
  return function()
    spoon.ModalMgr:deactivate({ id })
  end
end

function modalWrapper.bindModes(modes, modalManager)
  for _, mode in ipairs(modes) do
    -- Create the mode and register it with the supervisor
    spoon.ModalMgr:new(mode.id)
    local newModalManager = spoon.ModalMgr.modal_list[mode.id]

    local exitCallbacks = {}

    newModalManager.exited = function()
      for _, onExit in ipairs(exitCallbacks) do
        onExit()
      end
    end

    modalManager:bind(
      mode.modifiers,
      mode.key,
      mode.description,
      activateModal(mode.id, mode.color)
    )

    for _, binding in ipairs(mode.bindings) do
      if binding.onExit then
        table.insert(exitCallbacks, binding.onExit)
      end

      if binding.id then
        -- Allow sub-modes
        modalWrapper.bindModes({ binding }, newModalManager)
      else
        newModalManager:bind(
          binding.modifiers,
          binding.key,
          binding.description,
          function()
            local delayed = hs.timer.delayed.new(0.001, function()
              binding.onEnter()
            end)
            delayed:start()
            if not binding.keepModalActive then
              spoon.ModalMgr:deactivate({ mode.id })
            end
          end,
          binding.onRelease
        )
      end
    end
  end
end

return modalWrapper
