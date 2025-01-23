---@diagnostic disable: undefined-global, lowercase-global

function getAllControls(c, recursive)
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
end

-- ##########
-- == COLORS ==
--
colors = {
  knob = 'AB957DFF',
  knobMeterDial = '1996BAFF',
  lamp = '1B70FFFF',
}

MIDI = 0
LINEAR = 1
LOG = 2
EXP2 = 3
EXP3 = 4
dB = 5

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
    unit = 'oct',
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
    sens = 2,
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
  ctrlGroupGlobal_grpGlobalVoices_ctrl = {
    sens = 2,
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
  ctrlGroupControl_vibratoRate_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 3,
    high = 10,
    min = nil,
    max = nil,
    unit = '',
    decimals = 2,
    type = EXP2,
    doubleTap = true,
    tapDelay = 300,
  },
  -- ####################
  -- Mixer
  ctrlGroupMixer_osc1_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 2,
    type = dB,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupMixer_osc2_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 2,
    type = dB,
    doubleTap = true,
    tapDelay = 300,
  },
  ctrlGroupMixer_noise_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 0,
    high = 127,
    min = nil,
    max = nil,
    unit = '',
    decimals = 2,
    type = dB,
    doubleTap = true,
    tapDelay = 300,
  },
-- ####################
  -- Filter Envelope
  ctrlGroupFilterEnvelope_attack_ctrl = {
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
  ctrlGroupFilterEnvelope_decay_ctrl = {
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
  ctrlGroupFilterEnvelope_sustain_ctrl = {
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
  ctrlGroupFilterEnvelope_release_ctrl = {
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
  ctrlGroupFilterEnvelope_logLin_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 1.05,
    high = 10,
    min = nil,
    max = nil,
    unit = '',
    decimals = 2,
    type = EXP3,
    doubleTap = true,
    tapDelay = 300,
  },
  -- ####################
  -- Amplifier Envelope
  ctrlGroupAmplifierEnvelope_attack_ctrl = {
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
  ctrlGroupAmplifierEnvelope_decay_ctrl = {
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
  ctrlGroupAmplifierEnvelope_sustain_ctrl = {
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
  ctrlGroupAmplifierEnvelope_release_ctrl = {
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
  ctrlGroupAmplifierEnvelope_logLin_ctrl = {
    sens = 1.5,
    lblControlName = 'midi',
    low = 1.05,
    high = 10,
    min = nil,
    max = nil,
    unit = '',
    decimals = 2,
    type = EXP3,
    doubleTap = true,
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
