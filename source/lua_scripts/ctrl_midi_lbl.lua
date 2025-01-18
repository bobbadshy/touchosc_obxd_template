---@diagnostic disable: undefined-global, lowercase-global
function onValueChanged(k)
  if k == 'text' and tonumber(self.values.text) ~= nil then
    self.parent.children.lcdDigits:notify('update', self.values.text)
  end
end