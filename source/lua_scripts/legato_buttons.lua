---@diagnostic disable: lowercase-global, undefined-global
local buttons = self.parent.parent:findAllByType(ControlType.BUTTON, true)
local shadow = self.parent.children.layoutButton.children.shadow
local highlight = self.parent.children.layoutButton.children.highlight
local shadowColor = Color.toHexString(shadow.properties.color)
local highlightColor = Color.toHexString(highlight.properties.color)

function init()
  if shadowColor > highlightColor then
    shadowColor, highlightColor = highlightColor, shadowColor
  end
end

function onValueChanged(key)
  if self.values.x == 1 then
    shadow.properties.color = Color.fromHexString(highlightColor)
    highlight.properties.color = Color.fromHexString(shadowColor)
    for k in pairs(buttons) do
      button = buttons[k]
      if button.name ~= self.name and string.match(button.name, '^legato.*') then
        button.values.x = 0
      end
    end
  else
    shadow.properties.color = Color.fromHexString(shadowColor)
    highlight.properties.color = Color.fromHexString(highlightColor)
  end
  self.parent.children.lampReflection.children.reflection.values.x = self.values.x
end