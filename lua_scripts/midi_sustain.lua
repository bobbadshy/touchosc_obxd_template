---@diagnostic disable: lowercase-global, undefined-global
local kbd = self.parent.parent.children.keys
local last = 0
local delay = 600

function onValueChanged(k)
  -- Activate sustain, re-trigger if pressed again,
  -- disable when double-tap (identified by default pull towards 0.4)
  if k == 'touch' then
    if self.values.touch then
      last = getMillis()
      return
    end
    if (getMillis() - last) > delay then
      kbd:notify('sustain', 0)
      self:setValueField('x', ValueField.DEFAULT, 0)
      self.values.x = 0
    end
    return
  end
  if self.values.x == 1 then
    kbd:notify('sustain', 127)
    self:setValueField('x', ValueField.DEFAULT, 0.5)
    return
  end
  if self.values.x == 0 then
    if self:getValueField('x', ValueField.LAST) == 0.5 then
      kbd:notify('sustain', 127)
      self.values.x = 1
      return
    end
    kbd:notify('sustain', 0)
    self:setValueField('x', ValueField.DEFAULT, 0)
  end
end
