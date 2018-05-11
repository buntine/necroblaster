-- General layout rendering of non-play-time screens.

Layout = {
  title = {},
  bg = {},
}

function Layout:new(title, bg)
  local o = {
    title = love.graphics.newText(fonts.big, title, bg),
    bg = love.graphics.newImage("assets/images/" .. bg),
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Layout:render()
  withoutScale(function()
    stretchToScreen(self.bg)

    withColour(0.47, 0.12, 0.12, 1, function()
      love.graphics.draw(self.title, MENU_BORDER, ACTUAL_HEIGHT - self.title:getHeight() - MENU_BORDER)
    end)
  end)
end
