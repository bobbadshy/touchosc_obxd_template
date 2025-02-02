local last = 0
local delay = 500

function update()
  local now = getMillis()
  if now - last < delay then return end
  last = now
  if (
    self.parent.children.presetModule.children.groupRunSettings.visible or
    self.parent.children.presetModule.children.groupKeyboard.visible or
    self.parent.children.presetModule.children.groupDirectLoadButtons.visible or
    self.parent.children.presetModule.children.groupManager.visible or
    self.parent.children.groupKeyboardLarge.visible
  ) then
    if self.children.starwars ~= nil then
      self.children.starwars.properties.visible = false
    end
    self.children.logo.properties.visible = false
  elseif self.children.starwars == nil or not self.children.starwars.properties.visible then
    self.children.logo.properties.visible = true
  end
end
