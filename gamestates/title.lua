require "gamestates.menu"
require "tweening.transition"

title = Transition:new()

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
end

function title:draw()
  love.graphics.draw(self.title, 0, 0)
  self:drawTween()
end

function title:keypressed(_)
  self:transitionTo(menu)
end
