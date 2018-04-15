Result = {
  score = 0,
  bestScore = 0
}

function Result:new(s, bs)
  local o = {score = s, bestScore = bs}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Result:render()
  withColour(200, 200, 200, 255, function()
    love.graphics.print(self.score .. " OUT OF " .. self.bestScore, 10, 10)
  end)
end
