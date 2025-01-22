---@diagnostic disable: lowercase-global
function onReceiveNotify(cmd, value)
  if cmd == 'midiCC' then self.values.text = math.floor(value*127+0.5) end
end
