---@diagnostic disable: lowercase-global, undefined-field

local settings = nil

local delayDoubleTap = 300
local last = 0
local lastLongTap = 0
local delayBlink = 1000
local lastBlink = 0
local initialColor = nil
local resetColor = nil

colorOrange = Color.fromHexString('FF8400FF')
colorGreen = Color.fromHexString('8BFF1BFF')
colorRed = Color.fromHexString('E60000FF')

MIDI_RECORD_CTRL = 36
MIDI_RECORD_ENABLE = 127
MIDI_RECORD_DISABLE = 0
MIDI_RECORD_COLOR = colorRed

MIDI_OVERDUB_CTRL = 37
MIDI_OVERDUB_ENABLE = 127
MIDI_OVERDUB_DISABLE = 0
MIDI_OVERDUB_COLOR = colorOrange

MIDI_MUTE_CTRL = 38
MIDI_MUTE_ENABLE = 127
MIDI_MUTE_DISABLE = 0
MIDI_MUTE_COLOR = colorGreen

MIDI_UNDO_CTRL = 39
MIDI_UNDO_ENABLE = 127
MIDI_UNDO_DISABLE = 0
MIDI_UNDO_COLOR = Colors.yellow

MIDI_REDO_CTRL = 40
MIDI_REDO_ENABLE = 127
MIDI_REDO_DISABLE = 0
MIDI_REDO_COLOR = Colors.violet

MIDI_PLAY_COLOR = colorGreen

MIDI_PAUSE_CTRL = 41
MIDI_PAUSE_ENABLE = 127
MIDI_PAUSE_DISABLE = 0
MIDI_PAUSE_COLOR = nil

local handled = false

local armed = false
local loopPresent = false

local muted = false
local paused = true

local primed = nil
local recording = false
local overdubbing = false

local longTapped = false
local doubleLongTapped = false
local undone = false

function init()
  settings = root:findByName('pageKbdSettings', true)
  self.properties.outline = false
  initialColor = Color.fromHexString('44B3FFFF')
  self.properties.color = initialColor
  MIDI_PAUSE_COLOR = initialColor
  self:setValueField('x', ValueField.DEFAULT, 0)
end

function getMidiNoteCode()
  ---@diagnostic disable-next-line: need-check-nil
  return math.floor(144+tonumber(settings.children.midiLoopChannel.children.label.values.text-1))
end

function onReceiveNotify(c,v)
  if c == 'state' then
    setState(v)
  end
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
      now - lastLongTap > 800
    ) then
      lastLongTap = now + 2400
      if not doubleLongTapped and (self.pointers[1].created - last) < delayDoubleTap then
        doubleLongTap()
        extraLongTapped = false
        last = now
        return
      end
      if longTapped or doubleLongTapped then
        if not extraLongTapped then extraLongTap() end
      else
        longTap()
        extraLongTapped = false
      end
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
    print('handled')
    if resetColor ~= nil then self.properties.color = Color.fromHexString(resetColor) end
    resetHandled()
    syncState()
    return
  end
  print('single tap')
  local result = (
    arm() or
    start() or
    overdubPrime() or
    overdubStart() or
    overdubStop() or
    recordStart() or
    recordStop()
  )
  resetHandled()
  syncState()
end

function doubleTap()
  -- functions to perform on double-tap
  print('double-tap')
  local result = (
    muteStart() or
    muteStop()
  )
end

function longTap()
  -- functions to perform on double-tap
  print('long-tap')
  local result = (
    primeStop() or
    undoRedo() or
    arm()
  )
  -- long-tap is handled in onPointer, so we need to notify the following
  -- tap on release when we already handled the event.
  handled = result
  longTapped = true
end

function extraLongTap()
  -- functions to perform on double-tap
  print('extra long-tap')
  local result = (
    unarm()
  )
  handled = true
  extraLongTapped = true
end

function doubleLongTap()
  -- functions to perform on double-tap
  print('double long-tap')
  local result = (
    recordPrime()
  )
  handled = true
  doubleLongTapped = true
end

function start()
  if loopPresent or primed ~= nil then return false end
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
  if not armed then return false end
  -- always pause looper when disarming
  pause()
  resetPlayStates()
  armed = false
  loopPresent = false
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
  sendMIDI({ getMidiNoteCode(), MIDI_PAUSE_CTRL, MIDI_PAUSE_ENABLE })
  print('Pause')
  return true
end

function unpause()
  if not paused then return false end
  resetPlayStates()
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ getMidiNoteCode(), MIDI_PAUSE_CTRL, MIDI_PAUSE_DISABLE })
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
  if recording or overdubbing then return false end
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
  sendMIDI({ getMidiNoteCode(), MIDI_RECORD_CTRL, MIDI_RECORD_ENABLE })
  print('Recording START')
  return true
end

function recordStop()
  if not recording then return false end
  resetPlayStates()
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ getMidiNoteCode(), MIDI_RECORD_CTRL, MIDI_RECORD_DISABLE })
  print('Recording STOP')
  --[[
    maybe nice feature, but we can also stop and mute with double-tapping,
    and without below, accidentally tapping the button early is not problem,
    you can just wait with releasee until you want to actually stop the recording.
  ]]--
  -- if longTapped then longTapped = false muteStart() end
  return true
end

function overdubPrime()
  if not loopPresent or recording or overdubbing or primed ~= nil then return false end
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
  sendMIDI({ getMidiNoteCode(), MIDI_OVERDUB_CTRL, MIDI_OVERDUB_ENABLE })
  print('Overdub START')
  return true
end

function overdubStop()
  if not overdubbing then return false end
  resetPlayStates()
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ getMidiNoteCode(), MIDI_OVERDUB_CTRL, MIDI_OVERDUB_DISABLE })
  print('Overdub STOP')
  --[[
    maybe nice feature, but we can also stop and mute with double-tapping,
    and without below, accidentally tapping the button early is not problem,
    you can just wait with releasee until you want to actually stop the recording.
  ]]--
  -- if longTapped then longTapped = false muteStart() end
  return true
end

function muteStart()
  if muted or not loopPresent or recording or overdubbing then return false end
  resetPlayStates()
  muted = true
  -- TODO: This behaviour might be different on other loopers!
  setButton(0.4, MIDI_MUTE_COLOR)
  sendMIDI({ getMidiNoteCode(), MIDI_MUTE_CTRL, MIDI_MUTE_ENABLE })
  print('Mute START')
  return true
end

function muteStop()
  if not muted or not loopPresent then return false end
  resetPlayStates()
  -- TODO: This behaviour might be different on other loopers!
  setButton(0.4, MIDI_PLAY_COLOR)
  sendMIDI({ getMidiNoteCode(), MIDI_MUTE_CTRL, MIDI_MUTE_DISABLE })
  print('Mute STOP')
  return true
end

function undoRedo()
  if not loopPresent or recording or overdubbing then return false end
  if not undone then
    undone = true
    setButton(0.4, MIDI_UNDO_COLOR, true)
    sendMIDI({ getMidiNoteCode(), MIDI_UNDO_CTRL, MIDI_UNDO_ENABLE })
    print('Undo')
  else
    undone = false
    setButton(0.4, MIDI_REDO_COLOR, true)
    sendMIDI({ getMidiNoteCode(), MIDI_REDO_CTRL, MIDI_REDO_ENABLE })
  end
  return true
end

function resetPlayStates()
  paused = false
  muted = false
  recording = false
  overdubbing =  false
  primed = nil
end

function setButton(level, color, prev)
  if prev == true and resetColor == nil then
    resetColor = Color.toHexString(self.properties.color)
  else
    resetColor = nil
  end
  self:setValueField('x', ValueField.DEFAULT, level)
  self.properties.color = color
  self.values.x = math.min(1, level*2)
end

function resetHandled()
  handled = false
  longTapped = false
  extralongTapped = false
  doubleLongTapped= false
end

function getState()
  local result = {
    armed = armed,
    loopPresent = loopPresent,
    muted = muted,
    paused = paused,
    primed = primed,
    recording = recording,
    overdubbing = overdubbing,
    longTapped = longTapped,
    doubleLongTapped = doubleLongTapped,
    undone = undone,
    x = self.values.x,
    xD = self:getValueField('x', ValueField.DEFAULT),
    color = Color.toHexString(self.properties.color),
    outline = self.properties.outline,
  }
  return json.fromTable(result)
end

function setState(state)
  local t = json.toTable(state)
  armed = t.armed
  loopPresent = t.loopPresent
  muted = t.muted
  paused = t.paused
  primed = t.primed
  recording = t.recording
  overdubbing = t.overdubbing
  longTapped = t.longTapped
  doubleLongTapped = t.doubleLongTapped
  undone = t.undone
  self.properties.outline = t.outline
  self.values.x = t.x
  self:setValueField('x', ValueField.DEFAULT, t.xD)
  self.properties.color = Color.fromHexString(t.color)
end

function syncState()
  -- sync with 2nd instance of MIDI looper
  local loopers = root:findAllByName('midiLooper', true)
  for i=1,#loopers do
    if loopers[i].ID ~= self.ID then
      loopers[i]:notify('state', getState())
    end
  end
end

