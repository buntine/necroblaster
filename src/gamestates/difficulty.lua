require "src.widgets.menu"
require "src.widgets.selector"
require "src.gui.layout"
require "src.gamestates.handedness"
require "src.tweening.transition"

difficulty = Transition()

function difficulty:init()
  local menu = Menu(DIFFICULTIES, 2)

  self.selector = Selector(menu)
  self.layout = Layout("Difficulty...", "menu_bg_church.png")
end

function difficulty:enter(_, carry)
  self.carry = carry
end

function difficulty:draw()
  scaleGraphics()
  self.layout:render()
  self.selector:render()
  self:drawTween()
end

function difficulty:update()
  self.selector:progress()
  self:updateTween()
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
