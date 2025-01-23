---@diagnostic disable: lowercase-global, undefined-global
local siblings = self.parent.children
local delay = 300 -- the maximum elapsed time between taps
local last = 0
local blinkDelay = 800
local blinkLast = 0
local sensing = false
local enabled = false

function update()
  if sensing then
    local now = getMillis()
    if(now - blinkLast > blinkDelay) then
      blinkLast = now
      self.values.x = 1
    end
  end
end

function enableSensing()
  sensing = true
  self.properties.outline = true
  siblings.midi.messages.MIDI[1].enabled = false
  root:notify('keySense', siblings.midi)
end

function disableSensing()
  sensing = false
  self.properties.outline = false
  siblings.midi.messages.MIDI[1].enabled = true
  root:notify('keyStop')
end

function enable()
  siblings.midi.messages.MIDI[1].enabled = true
  self.parent.parent.parent.parent.children.keys:notify('settings')
end

function disable()
  siblings.midi.messages.MIDI[1].enabled = false
  siblings.label.values.text = ''
  self.parent.tag = 0
  siblings.midi.values.x = 0
end

function onValueChanged(k)
  if k == 'touch' then
    if not self.values.touch then
      local now = getMillis()
      if(now - last < delay) then
        last = 0
        disableSensing()
        disable()
      else
        last = now
        if enabled then disable() else enable() end
        if not sensing then enableSensing() else disableSensing() end
      end
    end
  end
end