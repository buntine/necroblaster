require "widgets.menu"
require "widgets.selector"
require "gui.layout"
require "gamestates.play"
require "tweening.transition"

handedness = Transition()

function handedness:init()
  local menu = Menu:new(HANDEDNESS)

  self.selector = Selector:new(menu)
  self.layout = Layout("Dominant Hand...", "menu_bg_witches.png")
end

function handedness:enter(_, carry)
  self.carry = carry
end

function handedness:draw()
  scaleGraphics()
  self.layout:render()
  self.selector:render()
  self:drawTween()
end

function handedness:update()
  self.selector:progress()
  self:updateTween()
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

function handedness:leave()
  love.audio.stop()
end
