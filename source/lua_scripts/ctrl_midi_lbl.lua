---@diagnostic disable: undefined-global, lowercase-global
local siblings = self.parent.children
function onValueChanged(k)
  if k == 'text' and tonumber(self.values.text) ~= nil then
    siblings.lcdDigits:notify('update', self.values.text)
  end
end