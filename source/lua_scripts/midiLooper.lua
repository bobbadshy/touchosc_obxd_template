---@diagnostic disable: lowercase-global
local delayDoubleTap = 300
local last = 0
local lastLongTap = 0
local delayBlink = 1000
local lastBlink = 0
local initialColor = nil
local resetColor = nil
MIDI_CC_CHANNEL = 0x9A

MIDI_RECORD_CTRL = 48
MIDI_RECORD_ENABLE = 127
MIDI_RECORD_DISABLE = 0
MIDI_RECORD_COLOR = Colors.red

MIDI_OVERDUB_CTRL = 49
MIDI_OVERDUB_ENABLE = 127
MIDI_OVERDUB_DISABLE = 0
MIDI_OVERDUB_COLOR = Colors.orange

MIDI_MUTE_CTRL = 50
MIDI_MUTE_ENABLE = 127
MIDI_MUTE_DISABLE = 0
MIDI_MUTE_COLOR = Colors.green

MIDI_UNDO_CTRL = 51
MIDI_UNDO_ENABLE = 127
MIDI_UNDO_DISABLE = 0
MIDI_UNDO_COLOR = Colors.yellow

MIDI_REDO_CTRL = 52
MIDI_REDO_ENABLE = 127
MIDI_REDO_DISABLE = 0
MIDI_REDO_COLOR = Colors.violet

MIDI_PLAY_COLOR = Colors.green

MIDI_PAUSE_CTRL = 53
MIDI_PAUSE_ENABLE = 127
MIDI_PAUSE_DISABLE = 0
MIDI_PAUSE_COLOR = nil

local handled = false

local armed = false
local loopPresent = false

local muted = false
local paused = true
local playing = false

local primed = nil
local recording = false
local overdubbing = false

local longTapped = false
local doubleLongTapped = false
local undone = false

function init()
  self.properties.outline = false
  initialColor = Color.fromHexString('44B3FFFF')
  self.properties.color = initialColor
  MIDI_PAUSE_COLOR = initialColor
  self:setValueField('x', ValueField.DEFAULT, 0)
end

function update()
  local now = getMillis()
  if (now - lastBlink) > delayBlink then
    if (
      armed and loopPresent and
      paused or muted or primed ~= nil
    ) then
      self.values.x = math.min(1, self:getValueField('x', ValueField.DEFAULT)*2)
    end
    lastBlink = now
  end
end

function onPointer()
  local now = getMillis()
  if self.values.touch then
    -- TODO: Clean up this delay condition, there must be a more correct way.. ;)
    if (
      now - self.pointers[1].created > 800 and
      now - lastLongTap > 800 and
      not longTapped
    ) then
      lastLongTap = now + 2400
      if (self.pointers[1].created - last) < delayDoubleTap then
        last = now
        if doubleLongTapped then
          extraLongTap()
        else
          doubleLongTap()
        end
        return
      end
      longTap()
    end
  end
end

function onValueChanged(k)
  -- tap should only register on touch release
  if k ~= 'touch' or self.values.touch then return end
  local now = getMillis()
  if (now - last) < delayDoubleTap then doubleTap() return end
  last = now
  if handled then
    if resetColor ~= nil then self.properties.color = Color.fromHexString(resetColor) end
    handled = false
    return
  end
  handled = (
    arm() or
    start() or
    overdubPrime() or
    overdubStart() or
    overdubStop() or
    recordStart() or
    recordStop()
  )
  handled = false
end

function doubleTap()
  -- functions to perform on double-tap
  print('double-tap')
  handled = (
    muteStart() or
    muteStop()
  )
end

function longTap()
  -- functions to perform on double-tap
  print('long-tap')
  handled = (
    unarm() or
    primeStop() or
    undoRedo() or
    arm()
  )
end

function doubleLongTap()
  -- functions to perform on double-tap
  print('double long-tap')
  doubleLongTapped = true
  if armed and loopPresent then
    resetColor = MIDI_RECORD_COLOR
    recordPrime()
  else
    pause()
    loopPresent = false
    resetColor = initialColor
  end
end

function extraLongTap()
  -- functions to perform on double-tap
  print('extra long-tap')
  doubleLongTapped = true
  resetColor = initialColor
  if paused then
    pause()
    unarm()
  else
    pause()
  end
end

function start()
  if loopPresent then return false end
  print('started')
  return recordPrime()
end

function arm()
  if armed then return false end
  -- also pause (reset) looper when arming
  pause()
  armed = true
  self.properties.outline = true
  setButton(0.4, initialColor)
  print('armed')
  return true
end

function unarm()
  if not armed or loopPresent or primed ~= nil then return false end
  -- always pause looper when disarming
  pause()
  armed = false
  self.properties.outline = false
  setButton(0, initialColor)
  print('unarmed')
  return true
end

function pause()
  if paused then return false end
  resetPlayStates()
  paused = true
  setButton(0.4, MIDI_PAUSE_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_PAUSE_CTRL, MIDI_PAUSE_ENABLE })
  print('Pause')
  return true
end

function unpause()
  if not paused then return false end
  resetPlayStates()
  playing = true
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_PAUSE_CTRL, MIDI_PAUSE_DISABLE })
  print('Unpause')
  return true
end

function primeStop()
  if primed == nil then return false end
  primed = nil
  setButton(0.4, paused and MIDI_PAUSE_COLOR or MIDI_PLAY_COLOR)
  return true
end

function recordPrime()
  if recording or overdubbing or primed ~= nil then return false end
  primed = 'record'
  setButton(0.4, MIDI_RECORD_COLOR)
  return true
end

function recordStart()
  if primed ~= 'record' then return false end
  -- We have a first loop in the looper once we starte the first recording
  loopPresent = true
  resetPlayStates()
  undone = false
  recording = true
  setButton(0.8, MIDI_RECORD_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_RECORD_CTRL, MIDI_RECORD_ENABLE })
  print('Recording START')
  return true
end

function recordStop()
  if not recording then return false end
  resetPlayStates()
  playing = true
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_RECORD_CTRL, MIDI_RECORD_DISABLE })
  print('Recording STOP')
  return true
end

function overdubPrime()
  if not loopPresent or recording or overdubbing  or primed ~= nil then return false end
  primed = 'overdub'
  setButton(0.4, MIDI_OVERDUB_COLOR)
  return true
end

function overdubStart()
  if primed ~= 'overdub' then return false end
  resetPlayStates()
  undone = false
  overdubbing = true
  setButton(0.8, MIDI_OVERDUB_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_OVERDUB_CTRL, MIDI_OVERDUB_ENABLE })
  print('Overdub START')
  return true
end

function overdubStop()
  if not overdubbing then return false end
  resetPlayStates()
  playing = true
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_OVERDUB_CTRL, MIDI_OVERDUB_DISABLE })
  print('Overdub STOP')
  return true
end

function muteStart()
  if muted or not loopPresent or recording or overdubbing then return false end
  resetPlayStates()
  muted = true
  -- TODO: This behaviour might be different on other loopers!
  playing = true
  setButton(0.4, MIDI_MUTE_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_MUTE_CTRL, MIDI_MUTE_ENABLE })
  print('Mute START')
  return true
end

function muteStop()
  if not muted or not loopPresent then return false end
  resetPlayStates()
  -- TODO: This behaviour might be different on other loopers!
  playing = true
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_MUTE_CTRL, MIDI_MUTE_DISABLE })
  print('Mute STOP')
  return true
end

function undoRedo()
  if not loopPresent or recording or overdubbing then return false end
  if not undone then
    undone = true
    setButton(0.4, MIDI_UNDO_COLOR, true)
    sendMIDI({ MIDI_CC_CHANNEL, MIDI_UNDO_CTRL, MIDI_UNDO_ENABLE })
    print('Undo')
  else
    undone = false
    setButton(0.4, MIDI_REDO_COLOR, true)
    sendMIDI({ MIDI_CC_CHANNEL, MIDI_REDO_CTRL, MIDI_REDO_ENABLE })
  end
  return true
end

function resetPlayStates()
  paused = false
  playing = false
  muted = false
  recording = false
  overdubbing =  false
  primed = nil
end

function setButton(level, color, prev)
  resetColor = prev == true and Color.toHexString(self.properties.color) or nil
  self:setValueField('x', ValueField.DEFAULT, level)
  self.properties.color = color
  self.values.x = math.min(1, level*2)
end
