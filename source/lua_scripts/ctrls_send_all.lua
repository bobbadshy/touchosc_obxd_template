---@diagnostic disable: lowercase-global, undefined-global
local obxd = root.children.app.children.obxd
local kbd = root.children.app.children.keyboard
local allControls = {}
local channel = 1

function controlEligible(c)
  -- Check if MIDI msg attached
  if #c.messages.MIDI > 0 then return true end
  return false
end

function getAllControls(c)
  if c == nil then
    print('ERROR')
    return
  end
  for i = 1, #c.children do
    getAllControls(c.children[i])
  end
  if controlEligible(c) then table.insert(allControls, c) end
end

function sendAllMidi()
  allControls = {}
  getAllControls(obxd)
  for k,c in pairs(allControls) do
    local m = c.messages.MIDI
    if m ~= nil then
      for i=1, #m do
        if m[i].send == true and m[i].enabled == true then
          m[i]:trigger()
        end
      end
    end
  end
end

function onValueChanged(k)
  if k == 'x' and self.values.x == 1 then
  sendAllMidi()
  end
end