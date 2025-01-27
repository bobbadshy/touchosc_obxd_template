
local MIDI = 0
local LINEAR = 1
local LOG = 2
local EXP2 = 3
local EXP3 = 4
local dB = 5

local CMD_CONFIG = 'cmdConfig'

local ctrlConfigs = {
  midiLoopChannel_ctrl = {
    sens = 0.8,
    lblControlName = 'label',
    lblShow = false,
    low = 1,
    high = 16,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = LINEAR,
    doubleTap = false,
    tapDelay = 300,
  },
}

function init()
  for n, c in pairs(ctrlConfigs) do
    local ctrl = self
    local name = self.name
    for t in string.gmatch(n, '[^_]+') do
      ctrl = ctrl:findByName(t)
      name = name .. '.' .. ctrl.name
    end
    --print('Sending to ' .. name)
    ctrl:notify(CMD_CONFIG, json.fromTable(c))
  end
end
