require "widgets.menu"
require "widgets.selector"
require "gamestates.handedness"
require "tweening.transition"

difficulty = Transition:new()

function difficulty:enter(_, carry)
  local menu = Menu:new(DIFFICULTIES, 2)

  self.selector = Selector:new(menu, "Difficulty...")
  self.carry = carry
end

function difficulty:draw()
  scaleGraphics()
  self.selector:render()
  self:drawTween()
end

function difficulty:keypressed(key)
  if key == BTN_D then
    local speed = self.selector:value()
    self.carry.speed = speed

    self:transitionTo(handedness, self.carry)
  else
    self.selector:keypressed(key)
  end
end
