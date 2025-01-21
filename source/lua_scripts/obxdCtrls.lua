---@diagnostic disable: undefined-global, lowercase-global

--[[function getAllControls(c, recursive)
  if c == nil then
    print('ERROR')
    return
  end
  if recursive then
    for i = 1, #c.children do
      getAllControls(c.children[i])
    end
  end
  if c.type == ControlType.GROUP then
    print(c.parent.name .. '.' .. c.name)
  end
end
for i = 1, #self.children do
  getAllControls(self.children[i], true)
end--]]

MIDI = 0
LINEAR = 1
LOG = 2
CMD_CONFIG = 'cmdConfig'

local ctrlConfigs = {
  -- ####################
  -- Master
  ctrlGroupMaster_ctrlMasterVolume_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupMaster_ctrlMasterFine_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = -100,
    high = 100,
    min = nil,
    max = nil,
    unit = 'c',
    decimals = 1,
    type = LINEAR,
    doubleTap = true,
    tapDelay = 300,
    centered = true,
    default = 0.5,
  },
  ctrlGroupMaster_ctrlMasterCoarse_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = -2,
    high = 2,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = LINEAR,
    doubleTap = true,
    tapDelay = 300,
    centered = true,
    default = 0.5,
  },
  -- ####################
  -- Global
  ctrlGroupGlobal_ctrlGlobalSpread_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupGlobal_ctrlGlobalVoicesUnison_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 1,
    high = 16,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = LINEAR,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupGlobal_ctrlGlobalGlide_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  -- ctrlGroupGlobal_ctrlGlobalVam = {
  --   sens = 1.5,
  --   lblControlName = 'midi',
  --   low = 0,
  --   high = 127,
  --   min = nil,
  --   max = nil,
  --   unit = '',
  --   type = LINEAR,
  --   doubleTap = true,
  --   tapDelay = 300,
  -- },
  -- ctrlGroupGlobal_ctrlGlobalSampling_ctrl = {
  --   sens = 1.5,
  --   lblControlName = 'midi',
  --   low = 0,
  --   high = 127,
  --   min = nil,
  --   max = nil,
  --   unit = '',
  --   type = LINEAR,
  --   doubleTap = true,
  --   tapDelay = 300,
  -- },
  -- ctrlGroupGlobal_grpGlobalLegato_ctrl = {
  --   sens = 1.5,
  --   lblControlName = 'midi',
  --   low = 0,
  --   high = 127,
  --   min = nil,
  --   max = nil,
  --   unit = '',
  --   type = LINEAR,
  --   doubleTap = true,
  --   tapDelay = 300,
  -- },
  ctrlGroupGlobal_grpGlobalVoices_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 1,
    high = 32,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = LINEAR,
    doubleTap = true,
    tapDelay = 300,
  },
  -- ####################
  -- Oscillators
  ctrlGroupOscillators_osc1_ctrl = {
    sens = 3,
    lblControlName = 'midi',
    low = -24,
    high = 24,
    min = nil,
    max = nil,
    unit = '',
    decimals = 1,
    type = LINEAR,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_pw_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_osc2_ctrl = {
    sens = 3,
    lblControlName = 'midi',
    low = -24,
    high = 24,
    min = nil,
    max = nil,
    unit = '',
    decimals = 1,
    type = LINEAR,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_detune_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_pitchEnvAmt_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_crossMod_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_pwEnvAmt_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_brightAmt_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupOscillators_osc2PwOffset_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 0,
    type = MIDI,
    doubleTap = true,
    tapDelay = 300,
  },
  -- ####################
  -- Control
}

function init()
  for n,c in pairs(ctrlConfigs) do
    local ctrl = self
    local name = self.name
    for t in string.gmatch(n,'[^_]+') do
      ctrl = ctrl:findByName(t)
      name = name .. '.' .. ctrl.name
    end
    --print('Sending to ' .. name)
    ctrl:notify(CMD_CONFIG, json.fromTable(c))
  end
end
