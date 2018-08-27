-- A single item within a menu widget.

MenuOption = Class{
  init = function(self, name, value)
    self.text = love.graphics.newText(fonts.huge, name)
    self.value = value
  end,
}

function MenuOption:render()
  local w = self.text:getWidth()
  local h = self.text:getHeight()
  local x, y = unpack(center(DESIRED_WIDTH, DESIRED_HEIGHT, w, h))

  love.graphics.draw(self.text, x, y)
end
