Difficulty = {
  levels = DIFFICULTIES,
  index = 2
}

function Difficulty:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Difficulty:render()
  local name = self.levels[self.index].name

  withFont("medium", function()
    withColour(0.86, 0.11, 0.11, 1, function()
      love.graphics.print("Difficulty: ", 160, 780)
    end)

    withColour(0.78, 0.78, 0.78, 1, function()
      love.graphics.print(name, 307, 780)
    end)
  end)
end

function Difficulty:next()
  if self.index == #self.levels then
    self.index = 1
  else
    self.index = self.index + 1
  end
end

function Difficulty:speed()
  return self.levels[self.index].speed
end
