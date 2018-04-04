require "helpers"

Score = {
  x = SCORE_WIDTH / 2,
}

function Score:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Score:render(score)
  withColour(186, 66, 66, 255, function()
    love.graphics.rectangle("fill", SCORE_X, SCORE_Y, SCORE_WIDTH, SCORE_HEIGHT)
  end)

  withColour(66, 66, 66, 255, function()
    local diff = SCORE_WIDTH - self.x

    love.graphics.rectangle("fill", SCORE_X + self.x, SCORE_Y, diff, SCORE_HEIGHT)
  end)

  love.graphics.print(math.floor(score * 10) * 0.1, SCORE_X, SCORE_Y + SCORE_HEIGHT + 5)
end

function Score:progress(score, bestScore)
  if bestScore > 0 then
    local percentage = math.min(100, (score / (bestScore * 0.75)) * 100)

    self.x = (percentage * SCORE_WIDTH) / 100
  end
end
