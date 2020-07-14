-- Wrapper around ModalMgr to enable more functionality
local K = require('keys')
local fnutils = hs.fnutils

local obj = {}
obj.__index = obj

-- Create a new ModalWrapper
function obj:new(options)
  local newObj = {}
  setmetatable(newObj, obj)

  self._id = options.id
  self._color = options.color
  self._key = options.key
  self._modifiers = options.modifiers
  self._exitAfter = options.exitAfter

  return newObj
end

function obj:start()
  spoon.ModalMgr.supervisor:enter()
  self:setupModifierWatcher()
end

-- LIBTODO if we make this a library, support more than just cmd
function obj:setupModifierWatcher()
  self._modifierWatcher = hs.eventtap.new(
    { hs.eventtap.event.types.flagsChanged },
    function(event)
      local keyCode = event:getKeyCode()

      local keyString = hs.keycodes.map[keyCode]
      if not(keyString == K.cmd or keyString == 'rightcmd') then
        return
      end

      local flags = event:getFlags()
      if not flags.cmd and self._exitOnReleaseCommand then
        self._exitOnReleaseCommand = false
        self:deactivate()
      end
    end)

  self._modifierWatcher:start()
end

function obj:stopDelayedExit()
  if self._delayedExit then
    self._delayedExit:stop()
  end
end


function obj:startDelayedExit()
  self:stopDelayedExit()
  self._delayedExit = hs.timer.delayed.new(self._exitAfter, function()
    self:deactivate()
  end)
  self._delayedExit:start()
end

function obj:activateModal()
  spoon.ModalMgr:deactivateAll()
  spoon.ModalMgr:activate({ self._id }, self._color, false)
end

function obj:toggleCheatsheet()
  spoon.ModalMgr:toggleCheatsheet()
end

function obj:deactivate()
  spoon.ModalMgr:deactivate({ self._id })
end

function obj:bindKeys(bindings)
  spoon.ModalMgr:new(self._id)
  self._modalMgr = spoon.ModalMgr.modal_list[self._id]

  local exitCallbacks = {}

  self._modalMgr.exited = function()
    for _, onExit in ipairs(exitCallbacks) do
      onExit()
    end
  end

  -- TOODLIB Modify this if we want to support nested modes
  spoon.ModalMgr.supervisor:bind(
    self._modifiers,
    self._key,
    self._description,
    function()
      if self._exitAfter ~= nil then
        self:startDelayedExit()
      end

      self:activateModal()
    end)

  for _, binding in ipairs(bindings) do
    if binding.onExit then
      table.insert(exitCallbacks, binding.onExit)
    end

    self:bindKey(binding)

    -- Create an extra binding with the command key since we may accidentally
    -- still be holding it. Also, allow for repeating certain commands while
    -- held
    if not binding.noAdditionalCommandBinding then
      local commandBinding = fnutils.copy(binding)
      if binding.modifiers and
        not fnutils.contains(binding.modifiers, K.cmd) then
        commandBinding.modifiers = fnutils.concat(
          fnutils.copy(binding.modifiers),
          { K.cmd }
          )
      else
        commandBinding.modifiers = { K.cmd }
      end

      commandBinding.description = '⌘ ' .. binding.description

      if commandBinding.keepModalActiveWithCommand then
        commandBinding.description = '∞' .. binding.description
      end

      self:bindKey(commandBinding, commandBinding.keepModalActiveWithCommand)
    end
  end
end

function obj:bindKey(binding, keepModalActiveWithCommand)
  self._modalMgr:bind(
    binding.modifiers,
    binding.key,
    binding.description,
    function()
      local delayed = hs.timer.delayed.new(0.001, function()
        if binding.onEnter == 'string' then
          self[binding.onEnter]()
        else
          binding.onEnter()
        end
      end)

      delayed:start()

      if binding.keepModalActive then
        self:stopDelayedExit()
      elseif keepModalActiveWithCommand then
        self:stopDelayedExit()
        self._exitOnReleaseCommand = true
      else
        self:deactivate()
      end
    end,
    binding.onRelease
  )
end

return obj
