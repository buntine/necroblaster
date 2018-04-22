require "widgets.chooser"
require "gamestates.play"

handedness = {}

function handedness:enter(_, carry)
  self.chooser = Chooser:new("Dominant hand: ", HANDEDNESS)
  self.carry = carry
end

function handedness:draw()
  self.chooser:render()
end

function handedness:keypressed(key)
  if key == BTN_A then
    self.chooser:previous()
  elseif key == BTN_B then
    self.chooser:next()
  elseif key == BTN_D then
    local dominant = self.chooser:value()
    self.carry.dominant = dominant

    Gamestate.switch(play, self.carry)
  end
end
