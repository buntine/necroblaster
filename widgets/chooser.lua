Chooser = {
  title = "",
  options = {},
  index = 1
}

function Chooser:new(title, options, selected)
  local s = selected or 1
  local o = { title = title, options = options, selected = s }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Chooser:render()
  local name = self.options[self.index].name

  withFont("medium", function()
    withColour(0.86, 0.11, 0.11, 1, function()
      love.graphics.print(self.title, 160, 780)
    end)

    withColour(0.78, 0.78, 0.78, 1, function()
      love.graphics.print(name, 307, 780)
    end)
  end)
end

function Chooser:previous()
  if self.index == 0 then
    self.index = #self.options
  else
    self.index = self.index - 1
  end
end

function Chooser:next()
  if self.index == #self.options then
    self.index = 1
  else
    self.index = self.index + 1
  end
end

function Chooser:value()
  return self.options[self.index].value
end
