---@diagnostic disable: lowercase-global, undefined-global
local buttons = self.parent.parent:findAllByType(ControlType.BUTTON, true)

function onValueChanged(key)
  if self.values.x == 1 then
    for k in pairs(buttons) do
      button = buttons[k]
      if button.name ~= self.name and string.match(button.name, '^legato.*') then
        button.values.x = 0
      end
    end
  end
  self.parent.children.lampReflection.children.reflection.values.x = self.values.x
end