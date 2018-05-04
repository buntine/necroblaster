-- A wrapper class that presents its "body" along with arrows to move back and forward through
-- the items available in body.

Selector = {
  body = {},
  title = {},
  arrow = love.graphics.newImage("assets/images/bone_arrow.png"),
}

function Selector:new(body, title)
  local o = {
    body = body,
    title = love.graphics.newText(fonts.big, title)
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Selector:render()
  withoutScale(function()
    withColour(0.47, 0.12, 0.12, 1, function()
      love.graphics.draw(self.title, MENU_BORDER, ACTUAL_HEIGHT - self.title:getHeight() - MENU_BORDER)
    end)

    local _, y = unpack(center(0, ACTUAL_HEIGHT, 0, self.arrow:getHeight()))

    love.graphics.draw(self.arrow, MENU_BORDER, y)
    love.graphics.draw(self.arrow, ACTUAL_WIDTH - MENU_BORDER, y, math.rad(180), 1, -1)
  end)

  self.body:render()
end

function Selector:progress()
  -- Arrow quads...

  if self.body.progress then
    self.body:progress()
  end
end

function Selector:keypressed(key)
  if key == BTN_A then
    self.body:previous()
  elseif key == BTN_B then
    self.body:next()
  end
end

function Selector:value()
  return self.body:value()
end

function Selector:reset()
  if self.body.reset then
    self.body:reset()
  end
end
