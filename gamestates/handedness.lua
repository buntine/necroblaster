require "widgets.chooser"
require "gamestates.play"
require "tweening.transition"

handedness = Transition:new()

function handedness:enter(_, carry)
  self.chooser = Chooser:new("Dominant hand: ", HANDEDNESS)
  self.carry = carry
end

function handedness:draw()
  self.chooser:render()
  self:drawTween()
end

function handedness:keypressed(key)
  if key == BTN_A then
    self.chooser:previous()
  elseif key == BTN_B then
    self.chooser:next()
  elseif key == BTN_D then
    local dominant = self.chooser:value()
    self.carry.dominant = dominant

    self:transitionTo(play, self.carry)
  end
end
