---@diagnostic disable: need-check-nil, lowercase-global, undefined-field
local midiSense = false
local senseCtrl = nil
local cc = 0
local val = 0
local delay = 1000
local last = 0

-- function update()
--   local now = getMillis()
--   if(now - last > delay) then
--     last = now
--     print(root.frame.w .. 'x' .. root.frame.h)
--   end
-- end

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

-- ##########
-- # == Viewport Zoom ==
-- #
-- # Code snippets taken from the awesome work of tshoppa! :)
-- #
-- #  - https://github.com/tshoppa/touchOSC/blob/main/modules/misc/PanZoom.tosc
-- #
local baseWidth = 1920
local baseHeight = 1200

local dist, start, orig, last

local pointernum = 0

local scrollDec = .95
local scrollMin = 3
local scroll

local scalableGroup = self.children.app
local scalableFrame = scalableGroup.frame
local rootFrame = self.frame

local labels = {}

function initLabelCache(ctrl)
  if (
        ctrl.type == ControlType.LABEL or
        ctrl.type == ControlType.TEXT
      ) then
    labels[ctrl.ID] = ctrl.textSize
  end

  for i = 1, #ctrl.children do
    initLabelCache(ctrl.children[i])
  end
end

initLabelCache(scalableGroup)

function scaleRec(ctrl, factWidth, factHeight, recursive)
  ctrl.frame.w = ctrl.frame.w * factWidth
  ctrl.frame.h = ctrl.frame.h * factHeight
  ctrl.frame.x = ctrl.frame.x * factWidth
  ctrl.frame.y = ctrl.frame.y * factHeight

  if (
        ctrl.type == ControlType.LABEL or
        ctrl.type == ControlType.TEXT
      ) then
    local size = labels[ctrl.ID] * factHeight
    labels[ctrl.ID] = size
    ctrl.textSize = size
  end

  if recursive == -1 or recursive > 0 then
    local chld = ctrl.children
    for i = 1, #chld do
      if recursive > 0 then recursive = recursive - 1 end
      print('Recursion: ' .. recursive .. ' - Scaling ' .. ctrl.name .. ' ' .. ctrl.frame.w .. 'x' .. ctrl.frame.h)
      scaleRec(chld[i], factWidth, factHeight, recursive)
    end
  end
end

function zoomTo(ctrl, factWidth, factHeight, center, recursive)
  local ctrlFrame = ctrl.frame
  local w = ctrlFrame.w * factWidth
  local h = ctrlFrame.h * factHeight

  -- if w < rootFrame.w then
  --   fact = rootFrame.w / ctrlFrame.w
  --   w = rootFrame.w
  --   h = ctrlFrame.h * fact
  -- end

  if w ~= ctrlFrame.w then
    ctrlFrame.x = ctrlFrame.x - (w - ctrlFrame.w) * center.x / ctrlFrame.w
    ctrlFrame.y = ctrlFrame.y - (h - ctrlFrame.h) * center.y / ctrlFrame.h
    ctrlFrame.w = w
    ctrlFrame.h = h

    if ctrlFrame.x > 0 then
      ctrlFrame.x = 0
    elseif ctrlFrame.x + ctrlFrame.w < rootFrame.w then
      ctrlFrame.x = rootFrame.w - ctrlFrame.w
    end

    if ctrlFrame.y > 0 then
      ctrlFrame.y = 0
    elseif ctrlFrame.y + ctrlFrame.h < rootFrame.h then
      ctrlFrame.y = rootFrame.h - ctrlFrame.h
    end

    if recursive == -1 or recursive > 0 then
      for i = 1, #ctrl.children do scaleRec(ctrl.children[i], factWidth, factHeight, recursive) end
    end
  end
end

function endAll()
  start = nil
  orig = nil
  dist = nil
  pointnum = 0
end

function reset()
  scroll = nil
  -- zoomTo(rootFrame.w / scalableFrame.w, { x = scalableFrame.w / 2, y = scalableFrame.h / 2 })
  scalableFrame.x = 0
  scalableFrame.y = 0
  endAll()
end

function scaleHorz()
  -- check if we need to scale
  local width = rootFrame.w
  local height = rootFrame.h
  local baseAspect = scalableFrame.w / scalableFrame.h
  local aspect = width / height
  if width == scalableFrame.w  and height == scalableFrame.h then return end


  -- First, zoom to rootFrame
  print('Scaling from ' .. scalableFrame.w .. 'x' .. scalableFrame.h .. ' to ' .. width .. 'x' .. height)
  zoomTo(root.children.app, height / scalableFrame.h, height / scalableFrame.h, { x = scalableFrame.w / 2, y = scalableFrame.h / 2 }, -1)

  -- calculate new horizontal scale
  print('Scaling horizontally from '.. scalableFrame.w .. 'x' ..scalableFrame.h .. ' to ' .. width .. 'x' .. height)
  local ctrl= root.children.app
  zoomTo(ctrl, width / ctrl.frame.w, 1, { x = ctrl.frame.w / 2, y = ctrl.frame.h / 2 }, 0)
  ctrl= root.children.app.children.background
  zoomTo(ctrl, width / ctrl.frame.w, 1, { x = ctrl.frame.w / 2, y = ctrl.frame.h / 2 }, 1)
  ctrl= root.children.app.children.obxd
  zoomTo(ctrl, width / ctrl.frame.w, 1, { x = ctrl.frame.w / 2, y = ctrl.frame.h / 2 }, 2)
  ctrl= root.children.app.children.keyboard
  zoomTo(ctrl, width / ctrl.frame.w, 1, { x = ctrl.frame.w / 2, y = ctrl.frame.h / 2 }, -1)

  -- scale the frames width horizontally

end

function init()
  scaleHorz()
end
