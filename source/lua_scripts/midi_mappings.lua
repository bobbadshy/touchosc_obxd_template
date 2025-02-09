---@diagnostic disable: lowercase-global

local midiCCs = {
  cc0 = { name = "Bank Select (MSB)", no = 0 },
  cc1 = { name = "Modulation Wheel", no = 1 },
  cc2 = { name = "Breath controller", no = 2 },
  cc3 = { name = "Undefined", no = 3 },
  cc4 = { name = "Foot Pedal (MSB)", no = 4 },
  cc5 = { name = "Portamento Time (MSB) - 'Glide'", no = 5 },
  cc6 = { name = "Data Entry (MSB)", no = 6 },
  cc7 = { name = "Volume (MSB)", no = 7 },
  cc8 = { name = "Balance (MSB", no = 8 },
  cc9 = { name = "Undefined", no = 9 },
  cc10 = { name = "Pan position (MSB)", no = 10 },
  cc11 = { name = "Expression (MSB) (Expression is a percentage of volume CC7)", no = 11 },
  cc12 = { name = "Effect Control 1 (MSB)", no = 12 },
  cc13 = { name = "Effect Control 2 (MSB)", no = 13 },
  cc14 = { name = "Undefined", no = 14 },
  cc15 = { name = "Undefined", no = 15 },
  cc16 = { name = "Ribbon Controller or General Purpose Slider 1", no = 16 },
  cc17 = { name = "Knob 1 or General Purpose Slider 2", no = 17 },
  cc18 = { name = "General Purpose Slider 3", no = 18 },
  cc19 = { name = "Knob 2 General Purpose Slider 4", no = 19 },
  cc20 = { name = "Knob 3 or Undefined", no = 20 },
  cc21 = { name = "Knob 4 or Undefined", no = 21 },
  cc22 = { name = "Undefined", no = 22 },
  cc23 = { name = "Undefined", no = 23 },
  cc24 = { name = "Undefined", no = 24 },
  cc25 = { name = "Undefined", no = 25 },
  cc26 = { name = "Undefined", no = 26 },
  cc27 = { name = "Undefined", no = 27 },
  cc28 = { name = "Undefined", no = 28 },
  cc29 = { name = "Undefined", no = 29 },
  cc30 = { name = "Undefined", no = 30 },
  cc31 = { name = "Undefined", no = 31 },
  cc32 = { name = "Bank Select (LSB) (see CC0)", no = 32 },
  cc33 = { name = "Modulation Wheel (LSB)", no = 33 },
  cc34 = { name = "Breath controller (LSB)", no = 34 },
  cc35 = { name = "undefined (LSB)", no = 35 },
  cc36 = { name = "Foot Pedal (LSB)", no = 36 },
  cc37 = { name = "Portamento Time (LSB)", no = 37 },
  cc38 = { name = "Data Entry (LSB)", no = 38 },
  cc39 = { name = "Volume (LSB)", no = 39 },
  cc40 = { name = "Balance (LSB)", no = 40 },
  cc41 = { name = "Undefined (LSB)", no = 41 },
  cc42 = { name = "Pan position (LSB)", no = 42 },
  cc43 = { name = "Expression (LSB)", no = 43 },
  cc44 = { name = "Effect Control 1 (LSB) Roland Portamento on and rate", no = 44 },
  cc45 = { name = "Effect Control 2 (LSB)", no = 45 },
  cc46 = { name = "may be in use as the LSB for controller 14 in some devices", no = 46 },
  cc47 = { name = "may be in use as the LSB for controller 15 in some devices", no = 47 },
  cc48 = { name = "may be in use as the LSB for controller 16 in some devices", no = 48 },
  cc49 = { name = "may be in use as the LSB for controller 17 in some devices", no = 49 },
  cc50 = { name = "may be in use as the LSB for controller 18 in some devices", no = 50 },
  cc51 = { name = "may be in use as the LSB for controller 19 in some devices", no = 51 },
  cc52 = { name = "may be in use as the LSB for controller 20 in some devices", no = 52 },
  cc53 = { name = "may be in use as the LSB for controller 21 in some devices", no = 53 },
  cc54 = { name = "may be in use as the LSB for controller 22 in some devices", no = 54 },
  cc55 = { name = "may be in use as the LSB for controller 23 in some devices", no = 55 },
  cc56 = { name = "may be in use as the LSB for controller 24 in some devices", no = 56 },
  cc57 = { name = "may be in use as the LSB for controller 25 in some devices", no = 57 },
  cc58 = { name = "may be in use as the LSB for controller 26 in some devices", no = 58 },
  cc59 = { name = "may be in use as the LSB for controller 27 in some devices", no = 59 },
  cc60 = { name = "may be in use as the LSB for controller 28 in some devices", no = 60 },
  cc61 = { name = "may be in use as the LSB for controller 29 in some devices", no = 61 },
  cc62 = { name = "may be in use as the LSB for controller 30 in some devices", no = 62 },
  cc63 = { name = "may be in use as the LSB for controller 31 in some devices", no = 63 },
  cc64 = { name = "Hold Pedal (on/off)", no = 64 },
  cc65 = { name = "Portamento (on/off)", no = 65 },
  cc66 = { name = "Sostenuto Pedal (on/off)", no = 66 },
  cc67 = { name = "Soft Pedal (on/off)", no = 67 },
  cc68 = { name = "Legato Pedal (on/off)", no = 68 },
  cc69 = { name = "Hold 2 Pedal (on/off)", no = 69 },
  cc70 = { name = "Sound Variation", no = 70 },
  cc71 = { name = "Resonance (Timbre)", no = 71 },
  cc72 = { name = "Sound Release Time", no = 72 },
  cc73 = { name = "Sound Attack Time", no = 73 },
  cc74 = { name = "Frequency Cutoff (Brightness)", no = 74 },
  cc75 = { name = "Sound Control 6", no = 75 },
  cc76 = { name = "Sound Control 7", no = 76 },
  cc77 = { name = "Sound Control 8", no = 77 },
  cc78 = { name = "Sound Control 9", no = 78 },
  cc79 = { name = "Sound Control 10", no = 79 },
  cc80 = { name = "Decay or General Purpose Button 1 (on/off) Roland Tone level 1", no = 80 },
  cc81 = { name = "Hi Pass Filter Frequency or General Purpose Button 2 (on/off) Roland Tone level 2", no = 81 },
  cc82 = { name = "General Purpose Button 3 (on/off) Roland Tone level 3", no = 82 },
  cc83 = { name = "General Purpose Button 4 (on/off) Roland Tone level 4", no = 83 },
  cc84 = { name = "Portamento Amount", no = 84 },
  cc85 = { name = "Undefined", no = 85 },
  cc86 = { name = "Undefined", no = 86 },
  cc87 = { name = "Undefined", no = 87 },
  cc88 = { name = "Undefined", no = 88 },
  cc89 = { name = "Undefined", no = 89 },
  cc90 = { name = "Undefined", no = 90 },
  cc91 = { name = "Reverb Level", no = 91 },
  cc92 = { name = "Tremolo Level", no = 92 },
  cc93 = { name = "Chorus Level", no = 93 },
  cc94 = { name = "Detune Level", no = 94 },
  cc95 = { name = "Phaser Level", no = 95 },
  cc96 = { name = "Data Button increment", no = 96 },
  cc97 = { name = "Data Button decrement", no = 97 },
  cc98 = { name = "Non-registered Parameter (NRPN) (LSB) (For controllers 6, 38, 96, and 97, it selects the NRPN parameter)", no = 98 },
  cc99 = { name = "Non-registered Parameter (NRPN) (MSB) (For controllers 6, 38, 96, and 97, it selects the NRPN parameter)", no = 99 },
  cc100 = { name = "Registered Parameter (RPN) (LSB) (For controllers 6, 38, 96, and 97, it selects the RPN parameter)", no = 100 },
  cc101 = { name = "Registered Parameter (RPN) (MSB) (For controllers 6, 38, 96, and 97, it selects the RPN parameter)", no = 101 },
  cc102 = { name = "Undefined", no = 102 },
  cc103 = { name = "Undefined", no = 103 },
  cc104 = { name = "Undefined", no = 104 },
  cc105 = { name = "Undefined", no = 105 },
  cc106 = { name = "Undefined", no = 106 },
  cc107 = { name = "Undefined", no = 107 },
  cc108 = { name = "Undefined", no = 108 },
  cc109 = { name = "Undefined", no = 109 },
  cc110 = { name = "Undefined", no = 110 },
  cc111 = { name = "Undefined", no = 111 },
  cc112 = { name = "Undefined", no = 112 },
  cc113 = { name = "Undefined", no = 113 },
  cc114 = { name = "Undefined", no = 114 },
  cc115 = { name = "Undefined", no = 115 },
  cc116 = { name = "Undefined", no = 116 },
  cc117 = { name = "Undefined", no = 117 },
  cc118 = { name = "Undefined", no = 118 },
  cc119 = { name = "Undefined", no = 119 },
  cc120 = { name = "All Sound Off (It does so regardless of release time or sustain. (See MIDI CC 123))", no = 120 },
  cc121 = { name = "All Controllers Off", no = 121 },
  cc122 = { name = "Local Keyboard (on/off)", no = 122 },
  cc123 = { name = "All Notes Off (Release time will still be maintained, and notes held by sustain will not turn off until sustain pedal is depressed.)", no = 123 },
  cc124 = { name = "Omni Mode Off", no = 124 },
  cc125 = { name = "Omni Mode On", no = 125 },
  cc126 = { name = "Mono Operation", no = 126 },
  cc127 = { name = "Poly Mode", no = 127 },
}

local midiMappings = {
  obxd = {
    -- #####
    -- == Master
    ctrlGroupMaster = {
      ctrlMasterVolume = {midiCCs.cc71.no, 'VOLUME'},
      ctrlMasterFine = {midiCCs.cc33.no, 'FINE'},
      ctrlMasterCoarse = {midiCCs.cc17.no, 'COARSE'},
    },
    -- #####
    -- == Global
    ctrlGroupGlobal = {
      ctrlGlobalSpread = {midiCCs.cc24.no, 'SPREAD'},
      ctrlGlobalBtnUnison = {midiCCs.cc16.no, 'UNI'},
      ctrlGlobalVoicesUnison = {midiCCs.cc123.no, 'VOICES'},
      ctrlGlobalGlide = {midiCCs.cc23.no, 'GLIDE'},
      ctrlGlobalVam = {midiCCs.cc21.no, 'VAM'},
      ctrlGlobalSampling = {midiCCs.cc111.no, 'SAMPLING'},
      grpGlobalLegato = {midiCCs.cc35.no, 'LEGATO MODE'},
      grpGlobalVoices = {midiCCs.cc15.no, 'VOICES'},
    },
    -- #####
    -- == Oscillators
    ctrlGroupOscillators = {
      osc1 = {midiCCs.cc54.no, 'OSCC1'},
      pw = {midiCCs.cc61.no, 'PULSE\\nWIDTH'},
      osc2 = {midiCCs.cc55.no, 'OSCC2'},
      waveSawOsc1 = {midiCCs.cc57.no, ''},
      waveSquOsc1 = {midiCCs.cc58.no, ''},
      wavePlusOsc1 = {midiCCs.cc115.no, '1+2'},
      detune = {midiCCs.cc43.no, 'DETUNE'},
      waveSawOsc2 = {midiCCs.cc59.no, ''},
      waveSquOsc2 = {midiCCs.cc60.no, ''},
      wavePlusOsc2 = {midiCCs.cc114.no, '1+2'},
      pitchEnvAmt = {midiCCs.cc63.no, 'PITCH\\nENV AMT'},
      crossMod = {midiCCs.cc53.no, 'CROSS\\nMOD'},
      pwEnvAmt = {midiCCs.cc113.no, 'PW ENV\\nAMT'},
      brightAmt = {midiCCs.cc62.no, 'BRIGHT\\nAMT'},
      butttonSync = {midiCCs.cc52.no, 'SYNC'},
      buttonStep = {midiCCs.cc56.no, 'STEP'},
      osc2PwOffset = {midiCCs.cc117.no, 'OSC2 PW\\nOFFSET'},
    },
    -- #####
    -- == Control
    ctrlGroupControl = {
      bendOctave = {midiCCs.cc118.no, 'BEND\\nOCTAVE'},
      bendOsc2 = {midiCCs.cc31.no, 'BEND\\nOSC2'},
      vibratoRate = {midiCCs.cc75.no, 'VIBRATO\\nRATE'},
      fltEnvVelocity = {midiCCs.cc76.no, 'FLT ENV\\nVELOCITY'},
      ampEnvVelocity = {midiCCs.cc20.no, 'AMP ENV\\nVELOCITY'},
    },
    -- #####
    -- == Mixer
    ctrlGroupMixer = {
      osc1 = {midiCCs.cc77.no, 'OSC1'},
      osc2 = {midiCCs.cc78.no, 'OSC2'},
      noise = {midiCCs.cc102.no, 'NOISE'},
    },
    -- #####
    -- == Filter
    ctrlGroupFilter = {
      cutoff = {midiCCs.cc74.no, 'CUTOFF'},
      resonance = {midiCCs.cc42.no, 'RESONANCE'},
      envAmt = {midiCCs.cc107.no, 'ENV AMT'},
      keytrack = {midiCCs.cc103.no, 'KEYTRACK'},
      mixBrBp = {midiCCs.cc104.no, 'MIX'},
      bp = {midiCCs.cc105.no, 'BP'},
      push = {midiCCs.cc119.no, 'PUSH'},
      lp24 = {midiCCs.cc106.no, 'LP24'},
    },
    -- #####
    -- == ModLfo
    ctrlGroupModLfo = {
      sync = {midiCCs.cc112.no, 'SYNC'},
      lfoRate = {midiCCs.cc19.no, 'LFO RATE'},
      freqAmt = {midiCCs.cc22.no, 'FREQ AMT'},
      pwAmt = {midiCCs.cc25.no, 'PW AMT'},
      lfoSine = {midiCCs.cc44.no, 'SIN'},
      freqAmtOsc1 = {midiCCs.cc47.no, 'OSC1'},
      pwAmtOsc1 = {midiCCs.cc50.no, 'OSC1'},
      lfoSquare = {midiCCs.cc45.no, 'SQU'},
      freqAmtOsc2 = {midiCCs.cc48.no, 'OSC2'},
      pwAmtOsc2 = {midiCCs.cc51.no, 'OSC2'},
      lfoRandom = {midiCCs.cc46.no, 'RND'},
      filter = {midiCCs.cc49.no, 'FILTER'},
    },
    -- #####
    -- == FilterEnvelope
    ctrlGroupFilterEnvelope = {
      invr = {midiCCs.cc116.no, 'INVR'},
      attack = {midiCCs.cc38.no, 'ATTACK'},
      decay = {midiCCs.cc39.no, 'DECAY'},
      sustain = {midiCCs.cc40.no, 'SUSTAIN'},
      release = {midiCCs.cc41.no, 'RELEASE'},
      logLin = {midiCCs.cc120.no, 'LOG-LIN'},
    },
    -- #####
    -- == AmplifierEnvelope
    ctrlGroupAmplifierEnvelope = {
      attack = {midiCCs.cc73.no, 'ATTACK'},
      decay = {midiCCs.cc36.no, 'DECAY'},
      sustain = {midiCCs.cc37.no, 'SUSTAIN'},
      release = {midiCCs.cc72.no, 'RELEASE'},
      logLin = {midiCCs.cc121.no, 'LOG-LIN'},
    },
    -- #####
    -- == VoiceVariation
    ctrlGroupVoiceVariation = {
      fltComp = {midiCCs.cc122.no, 'FLT COMP'},
      fltSlop = {midiCCs.cc109.no, 'FLT SLOP'},
      gldSlop = {midiCCs.cc110.no, 'GLD SLOP'},
      envSlop = {midiCCs.cc108.no, 'ENV SLOP'},
      voicePan1 = {midiCCs.cc81.no, 'V1 PAN'},
      voicePan2 = {midiCCs.cc82.no, 'V2 PAN'},
      voicePan3 = {midiCCs.cc83.no, 'V3 PAN'},
      voicePan4 = {midiCCs.cc84.no, 'V4 PAN'},
      voicePan5 = {midiCCs.cc85.no, 'V5 PAN'},
      voicePan6 = {midiCCs.cc86.no, 'V6 PAN'},
      voicePan7 = {midiCCs.cc87.no, 'V7 PAN'},
      voicePan8 = {midiCCs.cc88.no, 'V8 PAN'},
    },
  },
  discovery = {
    -- #####
    -- == Master
    ctrlGroupMaster = {
      ctrlMasterVolume = {midiCCs.cc7.no, 'VOLUME',},
      ctrlMasterFine = {midiCCs.cc33.no,},
      ctrlMasterCoarse = {midiCCs.cc17.no, 'OCTAVE',},
    },
    -- #####
    -- == Global
    ctrlGroupGlobal = {
      ctrlGlobalSpread = {midiCCs.cc24.no,},
      ctrlGlobalBtnUnison = {midiCCs.cc16.no,},
      ctrlGlobalVoicesUnison = {midiCCs.cc123.no,},
      ctrlGlobalGlide = {midiCCs.cc5.no, 'GLIDEE',},
      ctrlGlobalVam = {midiCCs.cc21.no,},
      ctrlGlobalSampling = {midiCCs.cc111.no,},
      grpGlobalLegato = {midiCCs.cc35.no,},
      grpGlobalVoices = {midiCCs.cc15.no,},
    },
    -- #####
    -- == Oscillators
    ctrlGroupOscillators = {
      osc1 = {midiCCs.cc54.no,},
      pw = {midiCCs.cc61.no,},
      osc2 = {midiCCs.cc55.no,},
      waveSawOsc1 = {midiCCs.cc57.no,},
      waveSquOsc1 = {midiCCs.cc58.no,},
      wavePlusOsc1 = {midiCCs.cc115.no,},
      detune = {midiCCs.cc43.no,},
      waveSawOsc2 = {midiCCs.cc59.no,},
      waveSquOsc2 = {midiCCs.cc60.no,},
      wavePlusOsc2 = {midiCCs.cc114.no,},
      pitchEnvAmt = {midiCCs.cc63.no,},
      crossMod = {midiCCs.cc53.no,},
      pwEnvAmt = {midiCCs.cc113.no,},
      brightAmt = {midiCCs.cc62.no,},
      butttonSync = {midiCCs.cc52.no,},
      buttonStep = {midiCCs.cc56.no,},
      osc2PwOffset = {midiCCs.cc117.no,},
    },
    -- #####
    -- == Control
    ctrlGroupControl = {
      bendOctave = {midiCCs.cc18.no, 'WHEEL MODE',},
      bendOsc2 = {midiCCs.cc28.no, 'MOD DEST',},
      vibratoRate = {midiCCs.cc26.no, 'MOD ATTACK',},
      fltEnvVelocity = {midiCCs.cc27.no, 'MOD DDECAY',},
      ampEnvVelocity = {midiCCs.cc29.no, 'MOD AMOUNT',},
    },
    -- #####
    -- == Mixer
    ctrlGroupMixer = {
      osc1 = {midiCCs.cc8.no, 'OSC MIX',},
      osc2 = {midiCCs.cc15.no, 'PLAYMODE',},
      noise = {midiCCs.cc102.no,},
    },
    -- #####
    -- == Filter
    ctrlGroupFilter = {
      cutoff = {midiCCs.cc74.no,},
      resonance = {midiCCs.cc42.no,},
      envAmt = {midiCCs.cc107.no,},
      keytrack = {midiCCs.cc103.no,},
      mixBrBp = {midiCCs.cc104.no,},
      bp = {midiCCs.cc105.no,},
      push = {midiCCs.cc119.no,},
      lp24 = {midiCCs.cc106.no,},
    },
    -- #####
    -- == Mod LFO
    ctrlGroupModLfo = {
      sync = {midiCCs.cc112.no,},
      lfoRate = {midiCCs.cc19.no, 'LFO1 RATE',},
      freqAmt = {midiCCs.cc22.no,},
      pwAmt = {midiCCs.cc25.no,},
      lfoSine = {midiCCs.cc20.no, 'LFO1 WAVE',},
      lfoSquare = {midiCCs.cc20.no, 'LFO1 WAVE',},
      lfoRandom = {midiCCs.cc21.no, 'LFO1 DEST',},
      freqAmtOsc1 = {midiCCs.cc2.no, 'LFO AMOUNT',},
      freqAmtOsc2 = {midiCCs.cc48.no,},
      filter = {midiCCs.cc49.no,},
      pwAmtOsc1 = {midiCCs.cc50.no,},
      pwAmtOsc2 = {midiCCs.cc51.no,},
    },
    -- #####
    -- == FilterEnvelope
    ctrlGroupFilterEnvelope = {
      invr = {midiCCs.cc116.no,},
      attack = {midiCCs.cc38.no,},
      decay = {midiCCs.cc39.no,},
      sustain = {midiCCs.cc40.no,},
      release = {midiCCs.cc41.no,},
      logLin = {midiCCs.cc120.no,},
    },
    -- #####
    -- == AmplifierEnvelope
    ctrlGroupAmplifierEnvelope = {
      attack = {midiCCs.cc73.no,},
      decay = {midiCCs.cc36.no,},
      sustain = {midiCCs.cc37.no,},
      release = {midiCCs.cc72.no,},
      logLin = {midiCCs.cc121.no,},
    },
    -- #####
    -- == VoiceVariation
    ctrlGroupVoiceVariation = {
      fltComp = {midiCCs.cc122.no,},
      fltSlop = {midiCCs.cc109.no,},
      gldSlop = {midiCCs.cc110.no,},
      envSlop = {midiCCs.cc108.no,},
      voicePan1 = {midiCCs.cc81.no,},
      voicePan2 = {midiCCs.cc82.no,},
      voicePan3 = {midiCCs.cc83.no,},
      voicePan4 = {midiCCs.cc84.no,},
      voicePan5 = {midiCCs.cc85.no,},
      voicePan6 = {midiCCs.cc86.no,},
      voicePan7 = {midiCCs.cc87.no,},
      voicePan8 = {midiCCs.cc88.no,},
    },
  }
}

local ctrlGroups = self.parent.children
local activeMapping = nil

function init()
  activeMapping = midiMappings[self.tag]
  for g, controls in pairs(activeMapping) do
      for c, values in pairs(controls) do
        -- assign cc to control's tag
        ctrlGroups[g].children[c].tag = values[1]
        if values[2] ~= nil then
          -- print("Assigning " .. values[1] .. " and text " .. values[2] .. " to " .. g .. "." .. c)
          local lbl = ctrlGroups[g].children[c].children.label
          if lbl ~= nil then
            lbl.values.text = values[2]
          end
        end
      end
  end
end