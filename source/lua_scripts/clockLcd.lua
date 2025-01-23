---@diagnostic disable: lowercase-global
local d0 = self.children.d0
local delay = 150
local last = 0
local checkDelay = 500
local lastDelay = 0
local buffer = ''
local lastTag = ''

function update()
  local now = getMillis()
  if (now - last > delay) then
    last = now
    if buffer ~= nil and #buffer ~= 0 then
      local d = string.sub(buffer, 1, 1)
      if d == ' ' then d = 'space' end
      d0:notify('shift', d)
      buffer = string.sub(buffer, 2)
    end
  end
  if (now - lastDelay > checkDelay) then
    lastDelay = now
    if self.tag ~= lastTag then
      if self.tag == nil or #self.tag == 0 then
        d0:notify('clear')
      else
        lastTag = self.tag 
        d0:notify('clear')
        buffer = lastTag
      end
    end
  end
end

function onReceiveNotify(c,v)
  if c == 'update' then
    d0:notify('update', v)
  elseif c == 'shift' then
    d0:notify('shift', v)
  elseif c == 'clear' then
    d0:notify('clear')
  elseif c == 'buffer' then
    d0:notify('clear')
    buffer = v
  end
end