---@diagnostic disable: lowercase-global, undefined-global
local obxd = root.children.app.children.obxd
local kbd = root.children.app.children.keyboard
local allControls = {}


function controlEligible(c)
  if #c.messages.MIDI > 0 then return true end
  return false
end

function getAllControls(c)
  if c == nil then return end
  for i = 1, #c.children do getAllControls(c.children[i]) end
  if controlEligible(c) then table.insert(allControls, c) end
end

function updateChannelTags(c)
  getAllControls(c)
  for k, cc in pairs(allControls) do
    cc.tag = tonumber(self.values.text) - 1
  end
end

function init()
  updateChannelTags(obxd)
  updateChannelTags(kbd)
end

function onReceiveNotify(c)
  if c == 'up' then
    self.values.text = math.min(16, tonumber(self.values.text) + 1)
  elseif c == 'down' then
    self.values.text = math.max(1, tonumber(self.values.text) - 1)
  end
end

function onValueChanged(k)
  allControls = {}
  if k == 'text' then
    i = tonumber(self.values.text)
    if i == nil then i = 1 end
    self.values.text = math.min(16, math.max(1, i))
    updateChannelTags(obxd)
    updateChannelTags(kbd)
  end
end
