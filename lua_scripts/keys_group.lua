---@diagnostic disable: lowercase-global, undefined-global
local w = self.children.white.children
local b = self.children.black.children
local octave = 4
local transpose = 0
local afterTouchPitchBendSensitivity = 1
local afterTouchPitchBendMaxValue = 8192*0.75

local keys = 
{
  w[1],  b[1], w[2],  b[2], w[3], 
  w[4],  b[3], w[5],  b[4], w[6],  b[5],  w[7], 
  w[8],  b[6], w[9],  b[7], w[10], 
  w[11], b[8], w[12], b[9], w[13], b[10], w[14],
  w[15],  b[11], w[16],  b[12], w[17], 
  w[18],  b[13], w[19],  b[14], w[20],  b[15],  w[21], w[22], 
}

function init()
  print('init')
  setOctave(octave)
  setTranspose(transpose)
  for i=1,#w do
    w[i]:notify('pbSensitivity', afterTouchPitchBendSensitivity)
    w[i]:notify('pbMaxValue', afterTouchPitchBendMaxValue)
  end
  for i=1,#b do
    b[i]:notify('pbSensitivity', afterTouchPitchBendSensitivity)
    b[i]:notify('pbMaxValue', afterTouchPitchBendMaxValue)
  end
end

function applyToKeys()
  local index = octave * 12
  for i=1,#keys do
    local note = index + (i-1) + transpose
    keys[i].name = note
    keys[i].visible = (note <= 127)
  end
  self.children.C0.values.text = 'C' .. (octave -1)
  self.children.C1.values.text = 'C' .. (octave)
  self.children.C2.values.text = 'C' .. (octave +1)
  self.children.C3.values.text = 'C' .. (octave +2)
end

function setOctave(value)
  octave = value
  applyToKeys()
end

function setTranspose(value)
  transpose = value
  applyToKeys()
end

function setChannel(value)
  local channel = value - 1
  for i=1,#keys do keys[i].tag = channel end
end

function onReceiveNotify(key, value)
  if(key == 'sustain') then
    for i=1,#w do
      w[i]:notify('cc66', value)
    end
    for i=1,#b do
      w[i]:notify('cc66', value)
    end
  elseif(key == 'octave') then
    setOctave(value)
  elseif(key == 'transpose') then
    setTranspose(value)
  elseif(key == 'channel') then
    setChannel(value-1)
  end
end