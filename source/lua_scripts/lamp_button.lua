---@diagnostic disable: undefined-global
local btn = self.children.lamp
local midi = self.children.midi

-- toggle our button on touch (do it here for bigger touch area)
function onValueChanged(k)
  if k == 'touch' and self.values.touch then
    if btn.values.x < 0.5 then
      midi.values.x = 1
      btn:setValueField('x', ValueField.DEFAULT, 1)
    else 
      midi.values.x = 0
      btn:setValueField('x', ValueField.DEFAULT, 0)
    end
  end
end
