---@diagnostic disable: lowercase-global, undefined-global
local lcdDigitsMain = self.children.clockLcd
local lcdDigits = self.children.clockLcd.children
delay = 1000
last = 0

function init()
  lcdDigits.d0:notify('blink', false)
end

function update()
  now = getMillis()
  if now - last > delay then
    last = now
    self:notify('update')
    local time = getTime()
    local s = string.format("%02d", time[1]) .. string.format("%02d", time[2])
    if math.fmod(time[2], 5) > 1 then
      lcdDigits.d0:notify('blink', true)
      lcdDigitsMain.tag = 'OBXD'
      lcdDigits.dots.properties.visible = false
    else
      if math.floor(time[3]/2) == time[3]/2 then
        lcdDigits.dots.properties.visible = false
      else
        lcdDigits.dots.properties.visible = true
      end
      if math.fmod(time[2], 5) == 0 then
        lcdDigitsMain.tag = s
      else
        lcdDigits.d0:notify('blink', false)
        local d
        for i=1, 4 do
          d = string.sub(s, 1, 1)
          lcdDigits.d0:notify('shift', d)
          s = string.sub(s, 2)
        end
      end
    end
  end
end