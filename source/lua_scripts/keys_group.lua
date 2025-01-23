---@diagnostic disable: lowercase-global, undefined-global, undefined-field
local siblings = self.parent.children
local pageKbdSettings = siblings.kbdSettings:findByName('pageKbdSettings', true).children
local buttons = siblings.buttons

local w = self:findByName('white', true).children
local b = self:findByName('black', true).children
local octave = 4
local transpose = 0
local afterTouchPitchBendSensitivity = 2
local afterTouchPitchBendMaxValue = 16384*0.75

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
local KEYS_MIDI_PITCHBEND = 1
local KEYS_MIDI_AFTERTOUCH = 2
local KEYS_MIDI_NOTE_ON = 3
local KEYS_MIDI_NOTE_OFF = 4

local MIDI_RECV_SUSTAIN = 1
local MIDI_PRESSURE = 2
local MIDI_MODULATION = 3

local held_notes = {}

local pressed = 0
local modulation = 0
local pressure = 63
local midiCCHorzBase = nil
local midiCCVertBase = nil
local midiCCVertBase2 = nil
local midiCCVertBase3 = nil
local midiCCVertBase4 = nil
local midiCCHorz = 0

local midiCCVert = {0, 0, 0, 0}

local keysModulationHorz = false
local keysModulationVert = false
local keysPitchbendHorz = false
local keysPitchbendVert = false
local keysChannelPressureHorz = false
local keysChannelPressureVert = false
local keysPolyphonicHorz = false
local keysPolyphonicVert = false
local keysMidiCCHorz = false
local keysMidiCCVert = false
local keysMidiCCVert2 = false
local keysMidiCCVert3 = false
local keysMidiCCVert4 = false
local modulationSlider = false

function init()
  setOctave(octave)
  setTranspose(transpose)
  keysModulationHorz = pageKbdSettings.btnModulationHorz.values.x == 1
  keysModulationVert = pageKbdSettings.btnModulationVert.values.x == 1
  --
  keysPitchbendHorz = pageKbdSettings.btnPitchbendHorz.values.x == 1
  keysPitchbendVert = pageKbdSettings.btnPitchbendVert.values.x == 1
  --
  keysChannelPressureHorz = pageKbdSettings.btnChannelPressureHorz.values.x == 1
  keysChannelPressureVert = pageKbdSettings.btnChannelPressureVert.values.x == 1
  --
  keysPolyphonicHorz = pageKbdSettings.btnPolyphonicHorz.values.x == 1
  keysPolyphonicVert = pageKbdSettings.btnPolyphonicVert.values.x == 1
  --
  keysMidiCCHorz = tonumber(pageKbdSettings.midiCCHorz.tag) ~= 0
  midiCCHorzBase = nil
  keysMidiCCVert = (
    tonumber(pageKbdSettings.midiCCVert.tag) +
    tonumber(pageKbdSettings.midiCCVert2.tag) +
    tonumber(pageKbdSettings.midiCCVert3.tag) +
    tonumber(pageKbdSettings.midiCCVert4.tag)
  ) > 0
  midiCCVertBase = nil
  midiCCVertBase2 = nil
  midiCCVertBase3 = nil
  midiCCVertBase4 = nil
  --
  modulationSlider = pageKbdSettings.btnModulationSlider.values.x == 1
  siblings.modulationSlider.children.slider:notify('modulationSlider', modulationSlider)
  for i=1,#w do
    w[i]:notify('modEnabledHorz', keysModulationHorz)
    w[i]:notify('modEnabledVert', keysModulationVert)
    w[i]:notify('pbEnabledHorz', keysPitchbendHorz)
    w[i]:notify('pbEnabledVert', keysPitchbendVert)
    w[i]:notify('cAtEnabledHorz', keysChannelPressureHorz)
    w[i]:notify('cAtEnabledVert', keysChannelPressureVert)
    w[i]:notify('atEnabledHorz', keysPolyphonicHorz)
    w[i]:notify('atEnabledVert', keysPolyphonicVert)
    w[i]:notify('midiCCHorzEnabled', keysMidiCCHorz)
    w[i]:notify('midiCCVertEnabled', keysMidiCCVert)
    w[i]:notify('pbSensitivity', afterTouchPitchBendSensitivity)
    w[i]:notify('pbMaxValue', afterTouchPitchBendMaxValue)
  end
  for i=1,#b do
    b[i]:notify('modEnabledHorz', keysModulationHorz)
    b[i]:notify('modEnabledVert', keysModulationVert)
    b[i]:notify('pbEnabledHorz', keysPitchbendHorz)
    b[i]:notify('pbEnabledVert', keysPitchbendVert)
    b[i]:notify('cAtEnabledHorz', keysChannelPressureHorz)
    b[i]:notify('cAtEnabledVert', keysChannelPressureVert)
    b[i]:notify('atEnabledHorz', keysPolyphonicHorz)
    b[i]:notify('atEnabledVert', keysPolyphonicVert)
    b[i]:notify('midiCCHorzEnabled', keysMidiCCHorz)
    b[i]:notify('midiCCVertEnabled', keysMidiCCVert)
    b[i]:notify('pbSensitivity', afterTouchPitchBendSensitivity)
    b[i]:notify('pbMaxValue', afterTouchPitchBendMaxValue)
  end
end

function reset(k)
  -- reset all modulation when no keys pressed
  pressure = 63
  if midiCCHorzBase == nil then
    midiCCHorzBase = pageKbdSettings.midiCCHorz.children.midi.values.x
  end
  midiCCHorz = midiCCHorzBase
  if midiCCVertBase == nil then
    midiCCVertBase = pageKbdSettings.midiCCVert.children.midi.values.x
  end
  midiCCVert[1] = midiCCVertBase
  if midiCCVertBase2 == nil then
    midiCCVertBase2 = pageKbdSettings.midiCCVert2.children.midi.values.x
  end
  midiCCVert[2] = midiCCVertBase2
  if midiCCVertBase3 == nil then
    midiCCVertBase3 = pageKbdSettings.midiCCVert3.children.midi.values.x
  else
    pageKbdSettings.midiCCVert3.children.midi.values.x = midiCCVertBase3
  end
  midiCCVert[3] = midiCCVertBase3
  if midiCCVertBase4 == nil then
    midiCCVertBase4 = pageKbdSettings.midiCCVert4.children.midi.values.x
  else
    pageKbdSettings.midiCCVert4.children.midi.values.x = midiCCVertBase4
  end
  midiCCVert[4] = midiCCVertBase4

  modulation = 0
  calcChannelPressure(63)
  calcModulation(0)
end

function release()
  if pressed == 0 then
    pageKbdSettings.midiCCHorz.children.midi.values.x = midiCCHorzBase
    pageKbdSettings.midiCCVert.children.midi.values.x = midiCCVertBase
    pageKbdSettings.midiCCVert2.children.midi.values.x = midiCCVertBase2
  end
end

function applyToKeys()
  local index = octave * 12
  for i=1,#keys do
    local note = index + (i-1) + transpose
    keys[i].name = note
    keys[i].visible = (note <= 127)
    if held_notes[tostring(note)] == true then
      keys[i].messages.MIDI[KEYS_MIDI_NOTE_ON].send = false
      keys[i].messages.MIDI[KEYS_MIDI_NOTE_OFF].send = false
    else
      keys[i].messages.MIDI[KEYS_MIDI_NOTE_ON].send = true
      keys[i].messages.MIDI[KEYS_MIDI_NOTE_OFF].send = true
    end
  end
  self.children.C0.values.text = 'C' .. (octave -1)
  self.children.C1.values.text = 'C' .. (octave)
  self.children.C2.values.text = 'C' .. (octave +1)
  self.children.C3.values.text = 'C' .. (octave +2)
end

function applySustain(val)
  local key
  local note = ''
  for i=0,127 do
    note = tostring(i)
    key = w[note]
    if key == nil then key = b[note] end
    if val == 127 then
      if key ~= nil and key.values.touch then
        key.messages.MIDI[KEYS_MIDI_NOTE_ON].send = false
        key.messages.MIDI[KEYS_MIDI_NOTE_OFF].send = false
        held_notes[note] = true
      end
    else
      if key ~= nil then
        key.messages.MIDI[KEYS_MIDI_NOTE_ON].send = true
        key.messages.MIDI[KEYS_MIDI_NOTE_OFF].send = true
        if not key.values.touch then
          key.messages.MIDI[KEYS_MIDI_NOTE_OFF]:trigger()
        end
      end
      if held_notes[note] ~= nil then
        held_notes[note] = nil
        if key == nil then
          local d = w[1].messages.MIDI[KEYS_MIDI_NOTE_OFF]:data()
          d[2] = i
          d[3] = 0
          sendMIDI(d)
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

function calcMidiCCHorz(value, c)
  local t = pageKbdSettings.midiCCHorzScale.values.x^2
  t = (t-0.5)*2
  t = t<0 and -1.8*(t^2)-0.2 or 1.8*t^2+0.2
  c.values.x = math.min(1,
    math.max(0,
    midiCCHorz + t*value
  ))
end

function calcMidiCCVert(value, k, c, s)
  local t = s.values.x
  t = (t-0.5)*2
  t = t<0 and -1.8*(t^2)-0.2 or 1.8*t^2+0.2
  c.values.x = math.min(1,
    math.max(0,
      midiCCVert[k] + t*value
  ))
end

function onReceiveNotify(key, value)
  if(key == 'pressure') then
    calcChannelPressure(value)
  elseif(key == 'press') then
    pressed = pressed + 1
    if pressed == 1 then reset() end
  elseif(key == 'release') then
    pressed = pressed - 1
    if pressed == 0 then release() end
  elseif(key == 'modulation') then
    calcModulation(value)
  elseif(key == 'midiCCHorz') then
    calcMidiCCHorz(value, pageKbdSettings.midiCCHorz.children.midi)
  elseif(key == 'midiCCVert') then
    if tonumber(pageKbdSettings.midiCCVert.tag) > 0 then
      calcMidiCCVert(
        value, 1,
        pageKbdSettings.midiCCVert.children.midi,
        pageKbdSettings.midiCCVertScale)
      end
    if tonumber(pageKbdSettings.midiCCVert2.tag) > 0 then
      calcMidiCCVert(
        value, 2,
        pageKbdSettings.midiCCVert2.children.midi,
        pageKbdSettings.midiCCVertScale2)
      end
    if tonumber(pageKbdSettings.midiCCVert3.tag) > 0 then
      calcMidiCCVert(
        value, 3,
        pageKbdSettings.midiCCVert3.children.midi,
        pageKbdSettings.midiCCVertScale3)
      end
    if tonumber(pageKbdSettings.midiCCVert4.tag) > 0 then
      calcMidiCCVert(
        value, 4,
        pageKbdSettings.midiCCVert4.children.midi,
        pageKbdSettings.midiCCVertScale4)
    end
  elseif(key == 'sustain') then
    applySustain(value)
  elseif(key == 'octave') then
    setOctave(value)
  elseif(key == 'transpose') then
    setTranspose(value)
  elseif(key == 'channel') then
    setChannel(value-1)
  elseif(key == 'modEnabled') then
    for i=1,#w do
      w[i]:notify('modEnabled', value)
    end
    for i=1,#b do
      w[i]:notify('modEnabled', value)
    end
  elseif(key == 'settings') then
    init()
  end
end
