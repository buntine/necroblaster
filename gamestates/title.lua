require "gamestates.menu"

title = {}

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
end

function title:draw()
  love.graphics.draw(self.title, 0, 0)
end

function title:keypressed(_)
  Gamestate.switch(menu)
end
