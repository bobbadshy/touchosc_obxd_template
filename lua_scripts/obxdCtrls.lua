---@diagnostic disable: undefined-global, lowercase-global

function getAllControls(c)
  if c == nil then
    print('ERROR')
    return
  end
  for i = 1, #c.children do
    getAllControls(c.children[i])
  end
  --print(c.parent.name .. '.' .. c.name)
end

--getAllControls(self.children.ctrlGroupGlobal)

MIDI = 0
LINEAR = 1
LOG = 2
CMD_CONFIG = 'cmdConfig'

local ctrlConfigs = {
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
  },
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
  ctrlGroupGlobal_groupUnison_ctrlGlobalVoicesUnison_ctrl = {
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
