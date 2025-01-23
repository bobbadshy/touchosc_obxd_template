---@diagnostic disable: lowercase-global, undefined-global
-- ##########
-- # == Check for double tap ==
-- #
local siblings = self.parent.children

local tapDelay = 300 -- Delay for registering a double-tap
local lastTap = 0
local zoomed = false
local doubleTapZoom = 1.2
local enabled = false

function onValueChanged(key)
  if key == 'touch' and not self.values.touch then
    local now = getMillis()
    if (now - lastTap < tapDelay) then
      if not enabled then
        enabled = true
      end
      if enabled then
        toggleZoom()
      end
      lastTap = 0
    else
      lastTap = now
    end
  end
end

-- ##########
-- # == Viewport Zoom ==
-- #
-- # Code snippets taken from the awesome work of tshoppa! :)
-- #
-- #  - https://github.com/tshoppa/touchOSC/blob/main/modules/misc/PanZoom.tosc
-- #

local dist, start, orig, last

local pointernum = 0

local scrollDec = .95
local scrollMin = 3
local scroll

local pz = siblings.app
local pzf = pz.frame
local parentf = self.parent.frame

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

initLabelCache(pz)

function update()
  if scroll then
    pzf.x = pzf.x + scroll.dx
    pzf.y = pzf.y + scroll.dy

    scroll.dx = scroll.dx * scrollDec
    scroll.dy = scroll.dy * scrollDec
    if math.abs(scroll.dx) < scrollMin then scroll.dx = 0 end
    if math.abs(scroll.dy) < scrollMin then scroll.dy = 0 end

    if scroll.dx == 0 and scroll.dy == 0 then scroll = nil end

    if pzf.x >= 0 then
      pzf.x = 0
      scroll = nil
    elseif pzf.x + pzf.w <= parentf.w then
      pzf.x = parentf.w - pzf.w
      scroll = nil
    end

    if pzf.y >= 0 then
      pzf.y = 0
      scroll = nil
    elseif pzf.y + pzf.h <= parentf.h then
      pzf.y = parentf.h - pzf.h
      scroll = nil
    end
  end
end

function scaleRec(ctrl, fact)
  ctrl.frame.w = ctrl.frame.w * fact
  ctrl.frame.h = ctrl.frame.h * fact
  ctrl.frame.x = ctrl.frame.x * fact
  ctrl.frame.y = ctrl.frame.y * fact

  if (
        ctrl.type == ControlType.LABEL or
        ctrl.type == ControlType.TEXT
      ) then
    local size = labels[ctrl.ID] * fact
    labels[ctrl.ID] = size
    ctrl.textSize = size
  end

  local chld = ctrl.children
  for i = 1, #chld do
    scaleRec(chld[i], fact)
  end
end

function calcDistance(x1, x2, y1, y2)
  local xdif = x1 - x2
  local ydif = y1 - y2
  return math.sqrt(xdif * xdif + ydif * ydif)
end

function calcMid(x1, x2, y1, y2)
  return { x = x1 + (x2 - x1) / 2, y = y1 + (y2 - y1) / 2 }
end

function zoomTo(fact, center)
  local w = pzf.w * fact
  local h = pzf.h * fact

  if w < parentf.w then
    fact = parentf.w / pzf.w
    w = parentf.w
    h = pzf.h * fact
  end

  if w ~= pzf.w then
    pzf.x = pzf.x - (w - pzf.w) * center.x / pzf.w
    pzf.y = pzf.y - (h - pzf.h) * center.y / pzf.h
    pzf.w = w
    pzf.h = h

    if pzf.x > 0 then
      pzf.x = 0
    elseif pzf.x + pzf.w < parentf.w then
      pzf.x = parentf.w - pzf.w
    end

    if pzf.y > 0 then
      pzf.y = 0
    elseif pzf.y + pzf.h < parentf.h then
      pzf.y = parentf.h - pzf.h
    end

    for i = 1, #pz.children do scaleRec(pz.children[i], fact) end
  end
end

function pan(x, y)
  pzf.x = orig.x + x - start.x
  pzf.y = orig.y + y - start.y
  if pzf.x > 0 then
    start.x = start.x + pzf.x   -- move for immidiate reaction
    pzf.x = 0
  elseif pzf.x + pzf.w < parentf.w then
    local cor = parentf.w - pzf.x - pzf.w
    pzf.x = parentf.w - pzf.w
    start.x = start.x - cor
  end

  if pzf.y > 0 then
    start.y = start.y + pzf.y   -- move for immidiate reaction
    pzf.y = 0
  elseif pzf.y + pzf.h < parentf.h then
    local cor = parentf.h - pzf.y - pzf.h
    pzf.y = parentf.h - pzf.h
    start.y = start.y - cor
  end
end

function endAll()
  start = nil
  orig = nil
  dist = nil
  pointnum = 0
end

function onPointer(pointer)
  if pointer[1].state == PointerState.END or #self.pointers ~= pointnum then
    pointnum = #self.pointers
    if #self.pointers == 2 then
      if pointer[1].state == PointerState.END then
        -- end Zoom
        last = nil
        endAll()
      else
        -- init zoom
        scroll = nill
        dist = calcDistance(self.pointers[1].x, self.pointers[2].x, self.pointers[1].y, self.pointers[2].y)
      end
    elseif #self.pointers == 1 then
      if pointer[1].state == PointerState.END then
        if last then
          local dx = pointer[1].x - last.x
          local dy = pointer[1].y - last.y
          if math.abs(dx) > scrollMin or math.abs(dy) > scrollMin then
            scroll = { dx = dx, dy = dy }
          end
        end
        last = nil
        endAll()
      else
        --init pan
        scroll = nil
        start = { x = self.pointers[1].x, y = self.pointers[1].y }
        last = { x = self.pointers[1].x, y = self.pointers[1].y }
        orig = { x = pzf.x, y = pzf.y }
      end
    end
  elseif pointer[1].state == PointerState.MOVE then
    if #self.pointers == 1 then
      pan(self.pointers[1].x, self.pointers[1].y)
      last = { x = self.pointers[1].x, y = self.pointers[1].y }
    end
  end
end

function toggleZoom()
  local maxBorderDist = 350
  local z = doubleTapZoom
  if not zoomed then
    if self.pointers[1] ~= nil then
      xx = self.pointers[1].x
      if xx < maxBorderDist then xx = 0 elseif (parentf.w - xx) < maxBorderDist then xx = parentf.w end
      yy = self.pointers[1].y
      if yy < maxBorderDist then yy = 0 elseif (parentf.h - yy) < maxBorderDist then yy = parentf.h end
    else
      xx = pzf.w / 2 * z
      yy = pzf.h / 2 * z
    end
    zoomTo(parentf.w * z / pzf.w * z, { x = xx, y = yy })
  else
    zoomTo(parentf.w / pzf.w, { x = pzf.w / 2, y = pzf.h / 2 })
  end
  zoomed = not zoomed
end

function reset()
  scroll = nil
  zoomTo(parentf.w / pzf.w, { x = pzf.w / 2, y = pzf.h / 2 })
  pzf.x = 0
  pzf.y = 0
  endAll()
end

function onReceiveNotify(key, val)
  if key == 'reset' then reset() end
  enabled = false
  zoomed = false
end
