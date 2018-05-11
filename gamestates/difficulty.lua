require "widgets.menu"
require "widgets.selector"
require "gui.layout"
require "gamestates.handedness"
require "tweening.transition"

difficulty = Transition:new()

function difficulty:init()
  local menu = Menu:new(DIFFICULTIES)

  self.selector = Selector:new(menu)
  self.layout = Layout:new("Difficulty...", "menu_bg_church.png")
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
