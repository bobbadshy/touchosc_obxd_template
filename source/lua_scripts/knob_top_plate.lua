---@diagnostic disable: lowercase-global
local delay = 300
local last = 0

function onValueChanged(k)
  if k == 'touch' then
    if self.values.touch then
      if _checkForDoubleTap() then return end
    end
    self.parent.children.midi.properties.visible = self.values.touch
  end
end

function _checkForDoubleTap()
  local now = getMillis()
  if(now - last < delay) then
    self.parent.children.ctrl:notify('reset')
    last = 0
    return true
  end
  last = now
  return false
end
