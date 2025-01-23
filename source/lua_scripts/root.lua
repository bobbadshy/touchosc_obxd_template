---@diagnostic disable: need-check-nil, lowercase-global, undefined-field
local midiSense = false
local senseCtrl = nil
local cc = 0
local val = 0

function onReceiveMIDI(message, connections)
  if midiSense then
    local midi = message
    local c = message[2]
    local v = message[3]/127
    if (c ~= cc) or (v ~= val) then
      cc = c
      val = v
      print(cc .. ' - ' .. val)
      senseCtrl.parent.tag = cc
      senseCtrl.parent.children.label.values.text = tostring(cc)
      senseCtrl.values.x = val
    end
  end
end

function onReceiveNotify(cmd, v)
  if cmd == 'keySense' then
    midiSense = true
    senseCtrl = v
  elseif cmd == 'keyStop' then
    midiSense = false
    senseCtrl = nil
  end
end
