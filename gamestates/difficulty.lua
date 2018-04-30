require "widgets.chooser"
require "gamestates.handedness"
require "tweening.transition"

difficulty = Transition:new()

function difficulty:enter(_, carry)
  self.chooser = Chooser:new("Speed: ", DIFFICULTIES, 2)
  self.carry = carry
end

function difficulty:draw()
  self.chooser:render()
  self:drawTween()
end

function difficulty:keypressed(key)
  if key == BTN_A then
    self.chooser:previous()
  elseif key == BTN_B then
    self.chooser:next()
  elseif key == BTN_D then
    local speed = self.chooser:value()
    self.carry.speed = speed

    self:transitionTo(handedness, self.carry)
  end
end
