

local colors = {
  simpleBackground = '090B0CFF',
  sectionOutline = '1C2E36FF',
  sectionBackground = '081014FF',
  backdropLowLines = '87919602',
  backdropHighLines = 'C9D4DD06',
}

local config = {
  -- ####
  section = {
    properties = {
      color = colors.sectionOutline,
      outline = true,
      outlineStyle = OutlineStyle.FULL,
      background = false,
    },
    background = {
      simple = {
        properties = {
          background = true,
          color = colors.sectionBackground,
        },
      },
      backdrop = {
        low = {
          properties = {
            outline = true,
            outlineStyle = OutlineStyle.EDGES,
            color = colors.backdropLowLines,
          },
        },
        high = {
          properties = {
            outline = true,
            outlineStyle = OutlineStyle.EDGES,
            color = colors.backdropHighLines,
          }
        }
      }
    }
  }
}

local settings = {
  background = {
    simple = {
      properties = {
        background = true,
        color = colors.simpleBackground,
      }
    },
    backdrop = {
      gradient = {
        properties = {
          color = '3AB1FF23',
        }
      }
    }
  },
  presetManager = config.section,
  obxd = {
    ctrlGroupMaster = config.section,
    ctrlGroupGlobal = config.section,
    ctrlGroupOscillators = config.section,
    ctrlGroupControl = config.section,
    ctrlGroupMixer = config.section,
    ctrlGroupFilter = config.section,
    ctrlGroupModLfo = config.section,
    ctrlGroupFilterEnvelope = config.section,
    ctrlGroupAmplifierEnvelope = config.section,
    ctrlGroupVoiceVariation = config.section,
    clock = {
      properties = {
        background = true,
        color = 'FFFFFF1F',
      }
    }
  }
}