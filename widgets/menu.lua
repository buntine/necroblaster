Menu = {
  options = {},
  index = 1
}

function Menu:new(options, selected)
  local s = selected or 1
  local o = { options = options, index = s }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Menu:render()
  local name = self.options[self.index].name

  withFont("medium", function()
    withColour(0.78, 0.78, 0.78, 1, function()
      love.graphics.print(name, 307, 780)
    end)
  end)
end

function Menu:previous()
  if self.index == 1 then
    self.index = #self.options
  else
    self.index = self.index - 1
  end
end

function Menu:next()
  if self.index == #self.options then
    self.index = 1
  else
    self.index = self.index + 1
  end
end


function Menu:value()
  return self.options[self.index].value
end
