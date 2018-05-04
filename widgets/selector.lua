-- A wrapper class that presents its "body" along with arrows to move back and forward through
-- the items available in body.

require "tweening.bump"

Selector = {
  body = {},
  title = {},
  leftBump = {},
  rightBump = {},
  arrow = love.graphics.newImage("assets/images/bone_arrow.png"),
}

function Selector:new(body, title)
  local o = {
    body = body,
    title = love.graphics.newText(fonts.big, title),
    leftBump = Bump:new(MENU_BORDER, -3),
    rightBump = Bump:new(ACTUAL_WIDTH - MENU_BORDER, 3),
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

    love.graphics.draw(self.arrow, self.leftBump.x, y)
    love.graphics.draw(self.arrow, self.rightBump.x, y, math.rad(180), 1, -1)
  end)

  self.body:render()
end

function Selector:progress()
  self.leftBump:progress()
  self.rightBump:progress()

  if self.body.progress then
    self.body:progress()
  end
end

function Selector:keypressed(key)
  if key == BTN_A then
    self.leftBump:start()
    self.body:previous()
  elseif key == BTN_B then
    self.rightBump:start()
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
