---@diagnostic disable: lowercase-global, undefined-global

-- CONSTANTS
MIDI = 0
LINEAR = 1
LOG = 2
EXP2 = 3
EXP3 = 4
dB = 5

-- CONFIG
local globalMidiLabel = root.children.app.children.keyboard.children.buttons.children.midiSendInfo
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

-- STATE
local start = {
  scale = 0,
  x = 0,
  y = 0,
}
local siblings = self.parent.children
local handlers = {}
local label
local horizontal = nil
local last = 0
local initialized = false

function registerHandlers()
  handlers =  {
    reset = resetValuesToDefault,
    cmdConfig = applyConfigFromJson,
  }
end

-- === CALLBACK HANDLERS ===

function init()
  registerHandlers()
  syncKnobPlate()
  initLabel()
  getOrientation()
  initialized = true
end

function onReceiveNotify(c,v)
  if not initialized then init() end
  if handlers[c] == nil then return end
  handlers[c](v)
end

function onValueChanged(k)
  if self.pointers[1] == nil or not (k == 'x' or k == 'y') then return end
  applySmoothedValue(k)
  if k == 'x' then syncKnobPlate() end
  notifyGlobalMidiLabel(self.values[k])
  showTrueValue(self.values[k])
end

function onPointer(pointers)
  local p = pointers[1]
  if p.state == PointerState.BEGIN then
    setStartPoint()
    showlLabel(true)
  elseif p.state == PointerState.MOVE then
    showlLabel(true)
  elseif p.state == PointerState.END then
    showlLabel(false)
  end
end

-- === FUNCTIONS ===

function syncKnobPlate()
  -- sync top notch to value on knobs that have it
  if siblings.topNotch == nil then return end
  siblings.topNotch.values.x = self.values.x*0.8+0.1
end

function initLabel()
  if not (config.lblControlName ~= nil and config.lblShow) then return end
  label = siblings[config.lblControlName]
end

function showlLabel(visible)
  if label ~= nil then label.properties.visible = visible end
end

function notifyGlobalMidiLabel(midiValue)
  globalMidiLabel:notify('midiCC', midiValue)
end

function applyConfigFromJson(data)
  config = json.toTable(data)
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
  initLabel()
end

function applySmoothedValue(k)
  if not (k == 'x' or k == 'y') then print('Invalid key: ' .. k) return end
  start.scale = getScaleFactor()
  local lastValue = self:getValueField(k, ValueField.LAST)
  local delta = (self.values[k] - lastValue) * start.scale
  self.values[k] = lastValue + delta
end

function getOrientation()
  horizontal = true
  if (
    self.properties.orientation == Orientation.NORTH or
    self.properties.orientation == Orientation.SOUTH
  ) then
    -- vertical fader!
    if self.type == ControlType.FADER then horizontal = false end
  else
    -- 90 degrees rotated XY control!
    if (
      self.type == ControlType.XY or
      self.type == ControlType.RADIAL or
      self.type == ControlType.ENCODER
    ) then
      horizontal = false
    end
  end
end

function resetValuesToDefault()
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

function showTrueValue(val)
  if label == nil then return end
  local r = calcRealValue(val)
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

function calcRealValue(val)
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
    if low == nil or high == nil then return showAsMidi(v) end
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
  return showAsMidi(v)
end

function showAsMidi(val)
  return math.floor(0.5+val*127)
end

function checkForDoubleTap()
  if config.doubleTap then
    local now = getMillis()
    if(now - last < config.tapDelay) then
      resetValuesToDefault()
      last = 0
    else
      last = now
    end
  end
end

function setStartPoint()
  start.x = self.pointers[1].x
  start.y = self.pointers[1].y
  start.scale = 0.0
end

function getScaleFactor()
  local rel, max
  if (
    self.type == ControlType.RADIAL or
    self.type == ControlType.ENCODER
  ) then
    max = ((self.frame.h * config.sens)^2 + (self.frame.w * config.sens)^2)^0.5
    rel = ((self.pointers[1].y - start.y)^2 + (self.pointers[1].x - start.x)^2)^0.5
  elseif (k == 'x' and not horizontal) or (k == 'y' and horizontal) then
    max = self.frame.h * config.sens
    rel = self.pointers[1].y - start.y
  else
    max = self.frame.w * config.sens
    rel = self.pointers[1].x - start.x
  end
  if math.abs(rel) <= 0 then
    -- If not moved, yet, use value delta to calculate start.scale
    -- For absolute faders, this ensures movement start on touch begin
    rel = rel + (max * (start.scale + 0.02) / config.sens)
  end
  return math.max(0, start.scale, math.min(1, math.abs(rel/max)))
end
