local function activateModal(id, color, exitAfter)
  spoon.ModalMgr:deactivateAll()
  spoon.ModalMgr:activate({ id }, color, false)

  if exitAfter ~= nil then
    local delayed = hs.timer.delayed.new(exitAfter, function()
      spoon.ModalMgr:deactivate({ id })
    end)
    delayed:start()
    return delayed
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
    local delayedExits = {}

    newModalManager.exited = function()
      for _, onExit in ipairs(exitCallbacks) do
        onExit()
      end
      for _, delayedExit in ipairs(delayedExits) do
        delayedExit:stop()
      end
    end

    modalManager:bind(
      mode.modifiers,
      mode.key,
      mode.description,
      function()
        local delayedExit = activateModal(mode.id, mode.color, mode.exitAfter)
        if delayedExit then
          table.insert(delayedExits, delayedExit)
        end
      end
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
