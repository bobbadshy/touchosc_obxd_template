---@diagnostic disable: lowercase-global, undefined-global
function onValueChanged(k)
  if k == 'x' and self.values.x == 0 or self.values.x == 1 then
    self.parent.parent.parent.children.keys:notify('settings')
  end
end