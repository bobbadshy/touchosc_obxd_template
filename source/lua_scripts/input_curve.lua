---@diagnostic disable: lowercase-global, undefined-global
local siblings = self.parent.children
local ctrlinfo = root.children.app.children.keyboard.children.buttons.children.midiSendInfo

MIDI = 0
LINEAR = 1
LOG = 2
EXP2 = 3
EXP3 = 4
dB = 5
CMD_CONFIG = 'cmdConfig'

local config = {
  sens = 1.5,
  lblControlName = 'midi',
  lblShow = true,
  low = 0,
  high = 127,
  min = nil,
  max = nil,
  decimals = 0,
  unit = '',
  type = MIDI,
  doubleTap = true,
  tapDelay = 300,
  centered = false,
  default = 0.0,
}

local zero_x
local zero_y
local horz_x = nil
local scale = 0
local lastTap = 0
local configSet = false

function init()
  if siblings.topNotch ~= nil then
    siblings.topNotch.values.x = self.values.x*0.8+0.1
  end
  _showTrueValue(self.values.x)
end

function onReceiveNotify(c,v)
  if c == 'reset' then
    _resetValuesToDefault()
  elseif c == CMD_CONFIG then
    -- print('Got config!')
    config = json.toTable(v)
    if config.sens == nil then config.sens = 1.5 end
    if config.lblControlName == nil then config.lblControlName = nil end
    if config.lblShow == nil then config.lblShow = true end
    if config.low == nil then config.low = 0 end
    if config.high == nil then config.high = 127 end
    if config.min == nil then config.min = nil end
    if config.max == nil then config.max = nil end
    if config.decimals == nil then config.decimals = 0 end
    if config.unit == nil then config.unit = '' end
    if config.type == nil then config.type = MIDI end
    if config.doubleTap == nil then config.doubleTap = true end
    if config.tapDelay == nil then config.tapDelay = 300 end
    if config.centered == nil then config.centered = false end
    config.sens = tonumber(config.sens)
    config.lblControlName = tostring(config.lblControlName)
    config.low = tonumber(config.low)
    config.high = tonumber(config.high)
    config.min = tonumber(config.min)
    config.max = tonumber(config.max)
    config.decimals = tonumber(config.decimals)
    config.unit = tostring(config.unit)
    if config.default ~= nil then
      self:setValueField('x', ValueField.DEFAULT, config.default)
    end
    if self.properties.centered ~= nil then
      self.properties.centered = config.centered
    end
    configSet = true
    _showTrueValue(self.values.x)
  end
end

function onValueChanged(k)
  -- Check for double-tap
  if k == 'touch' then
    if config.lblShow then
      siblings[config.lblControlName].properties.visible = self.values.touch
    end
    if self.values.touch then
      _setStartPoint()
    end
  elseif k == 'x' or k == 'y' then
    -- break if we don't have a pointer (programmatic value update)
    if self.pointers[1] == nil and config.lblShow then
      _showTrueValue(self.values[k])
      siblings[config.lblControlName].properties.visible = false
      return
    end
    -- initialize orientation
    if horz_x == nil then _getOrientation() end
    _applySmoothedValue(k)
    -- handle knobs "movement" (turn slave radial on knob)
    if siblings.topNotch ~= nil and k == 'x' then
      siblings.topNotch.values.x = self.values.x*0.8+0.1
    end
    ctrlinfo:notify('midiCC', self.values[k])
    _showTrueValue(self.values[k])
  end
end

function _applySmoothedValue(k)
  if not (k == 'x' or k == 'y') then print('Invalid key: ' .. k) return end
  -- process current pointer position
  scale = _getScaleFactor()
  local lastValue = self:getValueField(k, ValueField.LAST)
  local delta = (self.values[k] - lastValue) * scale
  self.values[k] = lastValue + delta
end

function _getOrientation()
  horz_x = true
  if (
    self.properties.orientation == Orientation.NORTH or
    self.properties.orientation == Orientation.SOUTH
  ) then
    -- vertical fader!
    if self.type == ControlType.FADER then horz_x = false end
  else
    -- 90 degrees rotated XY control!
    if (
      self.type == ControlType.XY or
      self.type == ControlType.RADIAL or
      self.type == ControlType.ENCODER
    ) then
      horz_x = false
    end
  end
end

function _resetValuesToDefault()
  local k ={ 'x', 'y' }
  for i=1,2 do
    if self.values[k[i]] ~= nil then
      if self:getValueProperty(k[i], ValueProperty.LOCKED_DEFAULT_CURRENT) then
        self.values[k[i]] = self.properties.centered == true and 0.5 or 0
      else
        self.values[k[i]] = self:getValueField(k[i], ValueField.DEFAULT)
      end
    end
  end
end

function _showTrueValue(val)
  if config.lblControlName == nil then return end
  local label = siblings[config.lblControlName]
  if label == nil then return end
  local r = _calcRealValue(val)
  local s
  if config.decimals > 0 then
    s = string.format('%.' .. config.decimals .. 'f', r)
  else
    s = r
  end
  if config.unit ~= '' then  
    s = s .. ' ' .. config.unit
  end
  label.values.text = s
end

function _calcRealValue(val)
  local v = math.floor(val*127+0.5)/127 -- snap to midi values
  local decimals = 10^config.decimals
  if (
    config.type == LINEAR or
    config.type == EXP2 or
    config.type == EXP3
  ) then
    if config.type == EXP2 then v = v^2
    elseif config.type == EXP3 then v = v^2.7 end
    local low = config.low
    local high = config.high
    if low == nil or high == nil then return _showAsMidi(v) end
    local min = config.min
    local max = config.max
    if min == nil then min = low end
    if max == nil then max = high end
    local delta = high - low
    return math.min(
      max, math.max(
        min, math.floor(v * delta * decimals +0.5 ) / decimals + low
    ))
  elseif config.type == dB then
    return 25*math.log(v, 10)
  elseif config.type == LOG then
    return math.log(v)
  end
  -- return as MIDI by default
  return _showAsMidi(v)
end

function _showAsMidi(val)
  return math.floor(0.5+val*127)
end

function _checkForDoubleTap()
  if config.doubleTap then
    local now = getMillis()
    if(now - lastTap < config.tapDelay) then
      _resetValuesToDefault()
      lastTap = 0
    else
      lastTap = now
    end
  end
end

function _setStartPoint()
  zero_x = self.pointers[1].x
  zero_y = self.pointers[1].y
  scale = 0.0
end

function _getScaleFactor()
  local rel, max
  if (
    self.type == ControlType.RADIAL or
    self.type == ControlType.ENCODER
  ) then
    max = ((self.frame.h * config.sens)^2 + (self.frame.w * config.sens)^2)^0.5
    rel = ((self.pointers[1].y - zero_y)^2 + (self.pointers[1].x - zero_x)^2)^0.5
  elseif (k == 'x' and not horz_x) or (k == 'y' and horz_x) then
    max = self.frame.h * config.sens
    rel = self.pointers[1].y - zero_y
  else
    max = self.frame.w * config.sens
    rel = self.pointers[1].x - zero_x
  end
  if math.abs(rel) <= 0 then
    -- If not moved, yet, use value delta to calculate scale
    -- For absolute faders, this ensures movement start on touch begin
    rel = rel + (max * (scale + 0.02) / config.sens)
  end
  return math.max(0, scale, math.min(1, math.abs(rel/max)))
end
