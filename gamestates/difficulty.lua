require "widgets.chooser"
require "gamestates.handedness"

difficulty = {}

function difficulty:enter(_, carry)
  self.chooser = Chooser:new("Speed: ", DIFFICULTIES, 2)
  self.carry = carry
end

function difficulty:draw()
  self.chooser:render()
end

function difficulty:keypressed(key)
  if key == BTN_A then
    self.chooser:previous()
  elseif key == BTN_B then
    self.chooser:next()
  elseif key == BTN_D then
    local speed = self.chooser:value()
    self.carry.speed = speed

    Gamestate.switch(handedness, self.carry)
  end
end
