---@diagnostic disable: lowercase-global, undefined-global
local obxd = root:findByName('obxdCtrls', true)
local kbd = self.parent.parent.parent
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

function updateChannelTags(c)
  getAllControls(c)
  for k,_ in pairs(allControls) do
    c.tag = channel
  end
end

function init()
    updateChannelTags(obxd)
    updateChannelTags(kbd)
end    

function onReceiveNotify(c)
  if c == 'up' then
    channel = math.min(15, channel+1)
  elseif c == 'down' then
    channel = math.max(0, channel-1)
  end
  self.values.text = channel+1
end

function onValueChanged(k)
  allControls = {}
  if k == 'text' then
    i = tonumber(self.values.text)
    if i ~= nil then
      channel = math.min(15, math.max(0, i-1))
    end
    self.values.text = channel + 1
    updateChannelTags(obxd)
  end
end
