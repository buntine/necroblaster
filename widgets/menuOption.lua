MenuOption = {
  text = {},
  value = 1
}

function MenuOption:new(name, value)
  local o = {
    text = love.graphics.newText(fonts.huge, name),
    value = value
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function MenuOption:render()
  local w = self.text:getWidth()
  local h = self.text:getHeight()
  local x, y = unpack(center(DESIRED_WIDTH, DESIRED_HEIGHT, w, h))

  love.graphics.draw(self.text, x, y)
end
