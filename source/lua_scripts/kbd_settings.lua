---@diagnostic disable: lowercase-global, undefined-global
local start, orig, last

local scrollDec = .95
local scrollMin = 3
local scroll

local scrollbar = self.parent.children.scrollbar
local slider = self.parent.children.scrollbar.children.slider
local scrollable = self.parent.children.scrollable.frame
local parent = self.parent.frame

function update()
  if scroll then
    scrollable.x = scrollable.x + scroll.dx
    scrollable.y = scrollable.y + scroll.dy

    scroll.dx = scroll.dx * scrollDec
    scroll.dy = scroll.dy * scrollDec
    if math.abs(scroll.dx) < scrollMin then scroll.dx = 0 end
    if math.abs(scroll.dy) < scrollMin then scroll.dy = 0 end

    if scroll.dx == 0 and scroll.dy == 0 then scroll = nil end

    if scrollable.x >= 0 then
      scrollable.x = 0
      scroll = nil
    elseif scrollable.x + scrollable.w <= parent.w then
      scrollable.x = parent.w - scrollable.w
      scroll = nil
    end

    if scrollable.y >= 0 then
      scrollable.y = 0
      scroll = nil
    elseif scrollable.y + scrollable.h <= parent.h then
      scrollable.y = parent.h - scrollable.h
      scroll = nil
    end
  end
end

function pan(x, y)
  scrollable.x = orig.x + x - start.x
  scrollable.y = orig.y + y - start.y
  if scrollable.x > 0 then
    start.x = start.x + scrollable.x   -- move for immidiate reaction
    scrollable.x = 0
  elseif scrollable.x + scrollable.w < parent.w then
    local cor = parent.w - scrollable.x - scrollable.w
    scrollable.x = parent.w - scrollable.w
    start.x = start.x - cor
  end
  if scrollable.y > 0 then
    start.y = start.y + scrollable.y   -- move for immidiate reaction
    scrollable.y = 0
  elseif scrollable.y + scrollable.h < parent.h then
    local cor = parent.h - scrollable.y - scrollable.h
    scrollable.y = parent.h - scrollable.h
    start.y = start.y - cor
  end
end

function endAll()
  start = nil
  orig = nil
  dist = nil
  pointnum = 0
  scrollbar.properties.visible = false
end

function onPointer(pointer)
  if pointer[1].state == PointerState.END or #self.pointers ~= pointnum then
    pointnum = #self.pointers
    scrollbar.properties.visible = true
    if #self.pointers == 1 then
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
        orig = { x = scrollable.x, y = scrollable.y }
      end
    end
  elseif pointer[1].state == PointerState.MOVE then
    if #self.pointers == 1 then
      pan(self.pointers[1].x, self.pointers[1].y)
      updateScrollbar()
      last = { x = self.pointers[1].x, y = self.pointers[1].y }
    end
  end
end

function updateScrollbar()
  local scale = parent.h/scrollable.h
  slider.frame.h = math.max(50, scrollbar.frame.h * scale)
  slider.frame.y = math.abs(scrollable.y) * scale
end

function reset()
  scroll = nil
  scrollable.x = 0
  scrollable.y = 0
  endAll()
end

function onReceiveNotify(key, val)
  if key == 'reset' then reset() end
  enabled = false
end
