local range = self.frame.w/2
local startx = range
local pbSensitivity = 2
local pbMaxValue = 8192*0.75
local pbEnabled = false

function onReceiveNotify(c, v)
  if c == 'pbEnabled' then
    if v == 1 then pbEnabled = true else pbEnabled = false end
  elseif c == 'pbSensitivity' then pbSensitivity = v
  elseif c == 'pbMaxValue' then pbMaxValue = v end
end

function onPointer(pointers)
  local p = pointers[1]
  if not pbEnabled then return end
  if p.state == PointerState.BEGIN then
    startx = p.x
  elseif p.state == PointerState.END then
    self.messages.MIDI[2]:trigger()
  elseif p.state == PointerState.MOVE then
    local delta = (p.x-startx)/range
    local pb = math.min(1,math.abs(delta)^pbSensitivity) * pbMaxValue
    if delta <= 0 then
      pb = pbMaxValue - pb
    else
      pb = pbMaxValue + pb
    end
    local data = self.messages.MIDI[2]:data()
    data[2] = math.floor(math.fmod(pb,128)) --lsb
    data[3] = math.floor(pb/128) --msb
    sendMIDI(data)
  end
end