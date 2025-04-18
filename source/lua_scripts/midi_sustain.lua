---@diagnostic disable: lowercase-global, undefined-global
local keys = root.children.app:findByName('keyboard', true).children.keys
local last = 0
local delay = 600

function onReceiveMIDI(m,c)
  if m[2] == 66 then
    if m[3] == 127 then
      self.values.x = 1
    else
      self.values.x = 0
    end
  end
end

function onValueChanged(k)
  -- Activate sustain, re-trigger if pressed again,
  -- disable when double-tap (identified by default pull towards 0.4)
  if k == 'touch' then
    if self.values.touch then
      last = getMillis()
      return
    end
    if (getMillis() - last) > delay then
      keys:notify('sustain', 0)
      self:setValueField('x', ValueField.DEFAULT, 0)
      self.values.x = 0
    end
    return
  end
  if self.values.x == 1 then
    keys:notify('sustain', 127)
    self:setValueField('x', ValueField.DEFAULT, 0.5)
    return
  end
  if self.values.x == 0 then
    if self:getValueField('x', ValueField.LAST) == 0.5 then
      keys:notify('sustain', 127)
      self.values.x = 1
      return
    end
    keys:notify('sustain', 0)
    self:setValueField('x', ValueField.DEFAULT, 0)
  end
end
