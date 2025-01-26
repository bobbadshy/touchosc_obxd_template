---@diagnostic disable: lowercase-global
local delaydoubbleTap = 300
local last = 0
local lastLongTap = 0
local delayBlink = 1000
local lastBlink = 0
local initialColor = nil
local resetColor = nil
-- whether initial tab has happend, usually mapped to "record" on looper
local armed = false
local started = false
-- toggle between record/overdub and play state o single tap
local recording = false
local overdubbing = false
local muted = false
local longTapped = false
local doubleLongTapped = false
local undone = false
local paused = false
local primed = nil

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
MIDI_REDO_COLOR = Colors.purple

MIDI_PLAY_COLOR = Colors.green

MIDI_PAUSE_CTRL = 53
MIDI_PAUSE_ENABLE = 127
MIDI_PAUSE_DISABLE = 0
MIDI_PAUSE_COLOR = nil

function init()
  self.properties.outline = false
  initialColor = Color.fromHexString('44B3FFFF')
  self.properties.color = initialColor
  MIDI_PAUSE_COLOR = initialColor
  self:setValueField('x', ValueField.DEFAULT, 0)
end

function update()
  local now = getMillis()
  if (
    ((now - lastBlink) > delayBlink) and
    (
      (armed and not started) or
      muted
      or primed ~= nil
    )
  ) then
    lastBlink = now
    self.values.x = 0.2
  end
end

function onPointer()
  local now = getMillis()
  if self.values.touch then
    if (
      now - self.pointers[1].created > 800 and
      now - lastLongTap > 800 and
      not longTapped
    ) then
      lastLongTap = now + 2400
      if (self.pointers[1].created - last) < delaydoubbleTap then
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
  if k ~= 'touch' then return end
  if self.values.touch then return end
  local now = getMillis()
  if (now - last) < delaydoubbleTap then
    doubleTap()
    return
  end
  last = now
  if doubleLongTapped then
    self.properties.color = resetColor
    doubleLongTapped = false
    return
  end
  if recording then
    longTapped = false
    recordStop()
    return
  end
  if overdubbing then
    longTapped = false
    overdubStop()
    return
  end
  if longTapped and primed ~= nil then
    longTapped = false
    return
  end
  if longTapped then
    self.properties.color = resetColor
    longTapped = false
    return
  end
  if not armed then arm() return end
  if not started then start() return end
  if primed == 'overdub' then overdubStart() end
  if primed == 'record' then recordStart() end
  if not (recording or overdubbing) then overdubPrime() end
end

function longTap()
  -- functions to perform on double-tap
  print('long-tap')
  longTapped = true
  resetColor = Color.fromHexString(Color.toHexString(self.properties.color))
  if armed and started then
    if primed ~= nil then
      primed = nil
      resetColor = MIDI_PLAY_COLOR
      self.properties.color = MIDI_PLAY_COLOR
    elseif not (recording or overdubbing) then
      undoRedo()
    end
  elseif armed then
    pause()
    unarm()
  else
    arm()
  end
end

function doubleLongTap()
  -- functions to perform on double-tap
  print('double long-tap')
  doubleLongTapped = true
  if armed and started then
    resetColor = MIDI_RECORD_COLOR
    recordPrime()
  else
    pause()
    started = false
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

function doubleTap()
  -- functions to perform on double-tap
  print('double-tap')
  if not started then return end
  if muted then
    muteStop()
  else
    muteStart()
  end
end

function arm()
  -- this will usually start initial "record" on loopers
  armed = true
  self.properties.outline = true
  self.properties.color = initialColor
  self:setValueField('x', ValueField.DEFAULT, 0.4)
  self.values.x = 1
  print('armed')
end

function unarm()
  armed = false
  recording = false
  overdubbing = false
  started = false
  primed = nil
  self.properties.outline = false
  self.properties.color = initialColor
  self:setValueField('x', ValueField.DEFAULT, 0)
  self.values.x = 0.5
  print('unarmed')
end

function start()
  print('start')
  started = true
  recordStart()
end

function pause()
  paused = true
  recording = false
  overdubbing = false
  primed = nil
  self.properties.color = MIDI_PAUSE_COLOR
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_PAUSE_CTRL, MIDI_PAUSE_ENABLE })
  print('Pause')
end

function unpause()
  paused = false
  self.properties.color = initialColor
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_PAUSE_CTRL, MIDI_PAUSE_DISABLE })
  print('Unpause')
end

function recordPrime()
  primed = 'record'
  self.properties.color = MIDI_RECORD_COLOR
end

function recordStart()
  -- start "record" new loop from scratch
  recording = true
  primed = nil
  undone = false
  -- looper should self-disable mute state on "record" start
  muted = false
  self.properties.color = MIDI_RECORD_COLOR
  self:setValueField('x', ValueField.DEFAULT, 0.8)
  self.values.x = 1
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_RECORD_CTRL, MIDI_RECORD_ENABLE })
  print('Recording START')
end  

function recordStop()
  recording = false
  self:setValueField('x', ValueField.DEFAULT, 0.4)
  self.properties.color = armed and MIDI_PLAY_COLOR or initialColor
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_RECORD_CTRL, MIDI_RECORD_DISABLE })
  print('Recording STOP')
end  

function overdubPrime()
  primed = 'overdub'
  self.properties.color = MIDI_OVERDUB_COLOR
end

function overdubStart()
  -- Add to the existing loop
  overdubbing = true
  primed = nil
  undone = false
  -- looper should self-disable mute state on "record" start
  muted = false
  self.properties.color = MIDI_OVERDUB_COLOR
  self:setValueField('x', ValueField.DEFAULT, 0.8)
  self.values.x = 1
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_OVERDUB_CTRL, MIDI_OVERDUB_ENABLE })
  print('Overdub START')
end

function overdubStop()
  overdubbing = false
  self:setValueField('x', ValueField.DEFAULT, 0.4)
  self.properties.color = armed and MIDI_PLAY_COLOR or initialColor
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_OVERDUB_CTRL, MIDI_OVERDUB_DISABLE })
  print('Overdub STOP')
end

function muteStart()
  -- keep playing the loop, but mute it
  muted = true
  primed = nil
  -- looper should self-disable record/overdub on "mute" start
  recording = false
  overdubbing = false
  self.properties.color = MIDI_MUTE_COLOR
  self.values.x = 1
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_MUTE_CTRL, MIDI_MUTE_ENABLE })
  print('Mute START')
end

function muteStop()
  muted = false
  unmuted = true
  primed = nil
  self.properties.color = armed and MIDI_PLAY_COLOR or initialColor
  self.values.x = 1
  sendMIDI({ MIDI_CC_CHANNEL, MIDI_MUTE_CTRL, MIDI_MUTE_DISABLE })
  print('Mute STOP')
end

function undoRedo()
  primed = nil
  if not undone then
    undone = true
    self.properties.color = MIDI_UNDO_COLOR
    self.values.x = 1
    sendMIDI({ MIDI_CC_CHANNEL, MIDI_UNDO_CTRL, MIDI_UNDO_ENABLE })
    print('Undo')
  else
    undone = false
    self.properties.color = MIDI_REDO_COLOR
    self.values.x = 1
    sendMIDI({ MIDI_CC_CHANNEL, MIDI_REDO_CTRL, MIDI_REDO_ENABLE })
  end
end