require "gamestates.menu"

title = {
  transition = "down",
  opacity = 1,
}

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
end

function title:draw()
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  love.graphics.draw(self.title, 0, 0)

  if self.transition then
    withColour(0, 0, 0, self.opacity, function()
      love.graphics.rectangle("fill", 0, 0, w, h)
    end)
  end
end

function title:update()
  love.graphics.draw(self.title, 0, 0)

  if self.transition == "up" then
    if self.opacity >= 1 then
      Gamestate.switch(menu)
    end

    self.opacity = self.opacity + 0.04
  elseif self.transition == "down" then
    if self.opacity <= 0 then
      self.transition = nil
    end

    self.opacity = self.opacity - 0.04
  end
end

function title:keypressed(_)
  self.transition = "up"
end
