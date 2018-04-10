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
