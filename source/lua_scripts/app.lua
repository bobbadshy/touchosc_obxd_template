---@diagnostic disable: lowercase-global


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

function assert(c,s)
  if not c then error('Assertion failed: ' .. s) end
end

function buildTest()
  local debug = root.children.app.children.presetManager.children.presetModule.children.groupRunSettings.children.stBtnEnableDebug
  assert(
    debug ~= nil,
    'Debug option in Preset Manager not found! Preset Manager is missing or not functinal. Cannot continue build test.'
  )
  if not debug then
    print('Debug disabled. Skipping build test.')
    return
  end
  --[[ ...TODO... ]]
end

function init()
  buildTest()
end
