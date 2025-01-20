---@diagnostic disable: lowercase-global, undefined-global
local delay = 300 -- the maximum elapsed time between taps
local last = 0

function onValueChanged(k)
  if k == 'touch' then
    if not self.values.touch then
      local now = getMillis()
      if(now - last < delay) then
        last = 0
        self.values.x = 0
        self.properties.outline = false
        self.parent.children.label.values.text = ''
        self.parent.tag = 0
        self.parent.children.midi.values.x = 0
      else
        last = now
      end
    end
  elseif k == 'x' then
    if self.values.x == 1 then
      self.parent.children.midi.messages.MIDI[1].enabled = false
      self.properties.outline = true
      root:notify('keySense', self.parent.children.midi)
      self.values.x = 0.1
    elseif self.values.x == 0 then
      self.properties.outline = false
      self.parent.children.midi.messages.MIDI[1].enabled = true
      root:notify('keyStop')
      self.parent.parent.parent.parent.children.keys:notify('settings')
    end
  end
end