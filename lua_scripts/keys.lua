---@diagnostic disable: undefined-global, lowercase-global
-- ##########
-- # start keys.lua
-- #
-- CONSTANTS
local PB_MSG = 2
local AT_MSG = 3
-- #
-- local state
local range_x = self.frame.w
local range_y = self.frame.h
local start_x = range_x / 2
-- #
local modEnabledHorz = true
local modEnabledVert = true
local pbEnabledHorz = false
local pbEnabledVert = false
local cAtEnabledHorz = false
local cAtEnabledVert = false
local atEnabledHorz = false
local atEnabledVert = false
local midiCCHorzEnabled = false

local midiCCVertEnabled = false

local pbSensitivity = 2
local pbMaxValue = 8192 * 0.75
-- #
-- ##########

local at = 0
local cAt = 0
local modulation = 0
local pb = 8192
local midiCCHorz = 0.0

local midiCCVert = 0.0

function onReceiveNotify(c, v)
  if c == 'pbEnabledHorz' then pbEnabledHorz = v
  elseif c == 'pbEnabledVert' then pbEnabledVert = v
  elseif c == 'atEnabledHorz' then atEnabledHorz = v
  elseif c == 'atEnabledVert' then atEnabledVert = v
  elseif c == 'cAtEnabledHorz' then cAtEnabledHorz = v
  elseif c == 'cAtEnabledVert' then cAtEnabledVert = v
  elseif c == 'modEnabledHorz' then modEnabledHorz = v
  elseif c == 'modEnabledVert' then modEnabledVert = v
  elseif c == 'midiCCHorzEnabled' then midiCCHorzEnabled = v
  elseif c == 'midiCCVertEnabled' then midiCCVertEnabled = v
  elseif c == 'pbSensitivity' then pbSensitivity = v
  elseif c == 'pbMaxValue' then pbMaxValue = v
  end
end

function onValueChanged(k)
  if k == 'touch' then
    if self.values.touch then
      -- reset start values
      at = 0
      cAt = 0
      modulation = 0
      pb = 8192
      midiCCHorz = 0.0
      midiCCVert = 0.0
      self.parent.parent:notify('press')
      else
      self.parent.parent:notify('release')
    end
  end
end

function onPointer(pointers)
  local p = pointers[1]
  local p_state = p.state
  if p_state == PointerState.BEGIN then
    start_x = p.x
    start_y = p.y
  elseif p_state == PointerState.END then
    -- send pitchbend reset msg on release
    if pbEnabledHorz then self.messages.MIDI[2]:trigger() end
  elseif p_state == PointerState.MOVE then
    if pbEnabledHorz then applyPitchBend(p.x-start_x, range_x) end
    if pbEnabledVert then applyPitchBend(start_y-p.y, range_y) end
    if modEnabledHorz then applyModulation(p.x, start_x, range_x) end
    if modEnabledVert then applyModulation(p.y, start_y, range_y) end
    if cAtEnabledHorz then applyChannelAftertouch(p.x, start_x) end
    if cAtEnabledVert then applyChannelAftertouch(p.y, start_y) end
    if atEnabledHorz then applyAftertouch(p.x, start_x) end
    if atEnabledVert then applyAftertouch(p.y, start_y) end
    if midiCCHorzEnabled then applyMidiCCHorz(p.x) end
    if midiCCVertEnabled then applyMidiCCVert(p.y) end
  end
end

function applyPitchBend(delta, range)
  local d = delta / (range/2)
  local i = math.min(1, math.abs(d) ^ pbSensitivity) * pbMaxValue
  if math.abs(pb-i) < pb*0.01 then return end
  if d <= 0 then i = 8192 - i else i = 8192 + i end
  i = math.max(0, math.min(16383, i))
  pb = 0.5*(pb+i)
  local data = self.messages.MIDI[PB_MSG]:data()
  data[2] = math.floor(math.fmod(i, 128)) --lsb
  data[3] = math.floor(i / 128)           --msb
  sendMIDI(data)
end

function applyAftertouch(pos, range)
  local d = pos / range
  local i = math.min(1, math.max(0, d))
  if i == at then return end
  at = i
  local data = self.messages.MIDI[AT_MSG]:data()
  data[3] = math.floor(i*127)
  sendMIDI(data)
end

function applyChannelAftertouch(pos,range)
  local d = pos / range
  local i = math.min(1, math.max(0, d))
  i = math.floor(i*127)
  if i == cAt then return end
  cAt = i
  self.parent.parent:notify('pressure', cAt)
end

function applyModulation(pos, start, range)
  local d = math.abs(2 * ((pos - start) / range)^2)
  local i = math.min(1, math.max(0, d))
  i = math.floor(i*127)
  if i == modulation then return end
  modulation = i
  self.parent.parent:notify('modulation', modulation)
end

function applyMidiCCHorz(pos)
  midiCCHorz = applyMidiCC(pos - start_x, range_x, midiCCHorz)
  self.parent.parent:notify('midiCCHorz', midiCCHorz/2)
end

function applyMidiCCVert(pos)
  midiCCVert = applyMidiCC(start_y - pos, range_y, midiCCVert)
  self.parent.parent:notify('midiCCVert', midiCCVert/2)
end

function applyMidiCC(delta, range, base)
  local i = 2*delta/range
  if i < 0 then i = -1*i^2 else i = i^2 end
  if math.abs(math.floor(64*(base - i))) > 12 then
    return 0.5*(base + i)
  end
  return i
end
-- #
-- # end keys.lua
-- ##########