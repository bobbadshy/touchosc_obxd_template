---@diagnostic disable: lowercase-global, undefined-global
local last
local scrollable = nil
local parent = nil

function init()
  scrollable = self.parent.frame
  parent = self.parent.parent.frame
  last = { x = scrollable.w / 2, y = scrollable.h / 2 }
end

function pan(x, y)
  scrollable.x = scrollable.x + x
  scrollable.y = scrollable.y + y
  scrollable.x = math.min(parent.w - scrollable.w, math.max(0, scrollable.x))
  scrollable.y = math.min(parent.h - scrollable.h, math.max(0, scrollable.y))
end

function onPointer(pointer)
  if pointer[1].state == PointerState.BEGIN then
    last = { x = self.pointers[1].x, y = self.pointers[1].y }
  elseif pointer[1].state == PointerState.MOVE then
    if #self.pointers == 1 then
      pan(self.pointers[1].x - last.x, self.pointers[1].y - last.y)
    end
  end
end
