require "widgets.menu"
require "widgets.selector"
require "gamestates.play"
require "tweening.transition"

handedness = Transition:new()

function handedness:enter(_, carry)
  local menu = Menu:new(HANDEDNESS)

  self.selector = Selector:new(menu, "Dominant Hand...")
  self.carry = carry
end

function handedness:draw()
  scaleGraphics()
  self.selector:render()
  self:drawTween()
end

function handedness:keypressed(key)
  if key == BTN_D then
    local dominant = self.selector:value()
    self.carry.dominant = dominant

    self:transitionTo(play, self.carry)
  else
    self.selector:keypressed(key)
  end
end
