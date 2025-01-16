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
local KEYS_MIDI_NOTE_ON = 1
local KEYS_MIDI_PITCHBEND = 2
local KEYS_MIDI_AFTERTOUCH = 3

local MIDI_RECV_SUSTAIN = 1
local MIDI_PRESSURE = 2
local MIDI_MODULATION = 3

local held_notes = {}

local pressed = 0
local modulation = 0
local pressure = 63

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

function reset(k)
  -- reset all modulation when no keys pressed
  pressure = 63
  modulation = 0
  calcChannelPressure(63)
  calcModulation(0)
end

function applyToKeys()
  local index = octave * 12
  for i=1,#keys do
    local note = index + (i-1) + transpose
    keys[i].name = note
    keys[i].visible = (note <= 127)
    if held_notes[tostring(note)] ~= true then
      keys[i].messages.MIDI[KEYS_MIDI_NOTE_ON].send = true
    else
      keys[i].messages.MIDI[KEYS_MIDI_NOTE_ON].send = false
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
        note.messages.MIDI[KEYS_MIDI_NOTE_ON].send = false
        held_notes[note.name] = true
      end
    elseif val == 0 then
      if note == nil then
        if held_notes[tostring(i)] then
          local d = w[1].messages.MIDI[KEYS_MIDI_NOTE_ON]:data()
          d[2] = i
          d[3] = 0
          sendMIDI(d)
          held_notes[i] = nil
        end
      else
        if held_notes[note.name] ~= nil then
          note.messages.MIDI[KEYS_MIDI_NOTE_ON].send = true
          if not note.values.touch then
            note.messages.MIDI[KEYS_MIDI_NOTE_ON]:trigger()
          end
          held_notes[i] = nil
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

function calcChannelPressure(value)
  pressure = 0.5*(pressure+value)
  local d = self.messages.MIDI[MIDI_PRESSURE]:data()
  d[2] = pressure
  sendMIDI(d)
end

function calcModulation(value)
  modulation = 0.5*(modulation+value)
  local d = self.messages.MIDI[MIDI_MODULATION]:data()
  d[3] = modulation
  sendMIDI(d)
end

function onReceiveNotify(key, value)
  if(key == 'pressure') then
    calcChannelPressure(value)
  elseif(key == 'press') then
    pressed = pressed + 1
    print('#########')
    print(pressed)
    if pressed == 1 then
      reset()
    end
  elseif(key == 'release') then
    print('down')
    pressed = pressed - 1
  elseif(key == 'modulation') then
    calcModulation(value)
  elseif(key == 'sustain') then
    applySustain(value)
  elseif(key == 'octave') then
    setOctave(value)
  elseif(key == 'transpose') then
    setTranspose(value)
  elseif(key == 'channel') then
    setChannel(value-1)
  end
end
