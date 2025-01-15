---@diagnostic disable: lowercase-global, undefined-global, undefined-field
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

-- my midi messages
local NOTE_ON = 1
local PITCHBEND = 2
local AFTERTOUCH = 3

local held_notes = {}

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
    if held_notes[tostring(note)] ~= true then
      keys[i].messages.MIDI[NOTE_ON].send = true
    else
      keys[i].messages.MIDI[NOTE_ON].send = false
    end
  end
  self.children.C0.values.text = 'C' .. (octave -1)
  self.children.C1.values.text = 'C' .. (octave)
  self.children.C2.values.text = 'C' .. (octave +1)
  self.children.C3.values.text = 'C' .. (octave +2)
end

function applySustain(val)
  for i=1,127 do
    note = w[i]
    if note == nil then note = b[i] end
    if val == 127 then
      if note ~= nil and note.values.touch then
        note.messages.MIDI[NOTE_ON].send = false
        held_notes[note.name] = true
      end
    elseif val == 0 then
      if note == nil then
        if held_notes[tostring(i)] then
          local d = w[1].messages.MIDI[NOTE_ON]:data()
          d[2] = i
          d[3] = 0
          sendMIDI(d)
          held_notes[tostring(i)] = nil
        end
      else
        if held_notes[note.name] ~= nil then
          note.messages.MIDI[NOTE_ON].send = true
          if not note.values.touch then
            note.messages.MIDI[NOTE_ON]:trigger()
          end
          held_notes[tostring(i)] = nil
        end
      end
    end
  end
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
    applySustain(value)
  elseif(key == 'octave') then
    setOctave(value)
  elseif(key == 'transpose') then
    setTranspose(value)
  elseif(key == 'channel') then
    setChannel(value-1)
  end
end