---@diagnostic disable: undefined-global, lowercase-global
-- ##########
-- # start keys.lua
-- #
-- CONSTANTS
local PB_MSG = 2
local AT_MSG = 3
-- #
-- local state
local range_pb = self.frame.w / 2
local range_at = self.frame.h
local start_x = range_pb
-- #
-- pitchbend on touch wiggle
local pbEnabled = false
local pbSensitivity = 2
local pbMaxValue = 8192 * 0.75
-- #
-- aftertouch on touch slide up/down
local atEnabled = false
-- channel aftertouch on touch slide up/down
local cAtEnabled = false
-- modulation on touch slide up/down
local modEnabled = true
-- #
-- ##########

local at = 0
local cAt = 0
local modulation = 0
local pb = 8192

function onReceiveNotify(c, v)
  if c == 'pbEnabled' then
    if v == 1 then pbEnabled = true else pbEnabled = false end
  elseif c == 'atEnabled' then
    if v == 1 then atEnabled = true else atEnabled = false end
  elseif c == 'pbSensitivity' then
    pbSensitivity = v
  elseif c == 'pbMaxValue' then
    pbMaxValue = v
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
    if pbEnabled then self.messages.MIDI[2]:trigger() end
  elseif p_state == PointerState.MOVE then
    if pbEnabled then applyPitchBend(p.x) end
    if atEnabled then applyAftertouch(p.y) end
    if cAtEnabled then applyChannelAftertouch(p.y) end
    if modEnabled then applyModulation(p.y) end
  end
end

function applyPitchBend(p_x)
  local d = (p_x - start_x) / range_pb
  local i = math.min(1, math.abs(d) ^ pbSensitivity) * pbMaxValue
  if i == pb then return end
  if d <= 0 then i = pbMaxValue - i else i = pbMaxValue + i end
  pb = i
  local data = self.messages.MIDI[PB_MSG]:data()
  data[2] = math.floor(math.fmod(i, 128)) --lsb
  data[3] = math.floor(i / 128)           --msb
  sendMIDI(data)
end

function applyAftertouch(p_y)
  local d = p_y / range_at
  local i = math.min(1, math.max(0, d))
  if i == at then return end
  at = i
  local data = self.messages.MIDI[AT_MSG]:data()
  data[3] = math.floor(i*127)
  sendMIDI(data)
end

function applyChannelAftertouch(p_y)
  local d = p_y / range_at
  local i = math.min(1, math.max(0, d))
  i = math.floor(i*127)
  if i == cAt then return end
  cAt = i
  self.parent.parent:notify('pressure', cAt)
end

function applyModulation(p_y)
  local d = math.abs(2 * ((p_y - start_y) / range_at)^2)
  local i = math.min(1, math.max(0, d))
  i = math.floor(i*127)
  if i == modulation then return end
  modulation = i
  self.parent.parent:notify('modulation', modulation)
end
-- #
-- # end keys.lua
-- ##########