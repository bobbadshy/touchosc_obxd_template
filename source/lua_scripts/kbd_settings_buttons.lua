---@diagnostic disable: lowercase-global, undefined-global
local keys = root.children.app:findByName('keys', true)
function onValueChanged(k)
  if k == 'x' and self.values.x == 0 or self.values.x == 1 then
    keys:notify('settings')
  end
end