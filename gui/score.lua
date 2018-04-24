require "helpers"

Score = {
  x = SCORE_WIDTH / 2,
  bg = love.graphics.newImage("assets/images/score.png")
}

function Score:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Score:render(score)
  love.graphics.draw(self.bg, SCORE_X, SCORE_Y)

  withColour(0.24, 0.24, 0.35, 1, function()
    local diff = SCORE_WIDTH - self.x

    love.graphics.rectangle("fill",
      SCORE_X + self.x + SCORE_BORDER,
      SCORE_Y + SCORE_BORDER,
      diff,
      SCORE_HEIGHT)
  end)

  love.graphics.print(math.floor(score * 10) * 0.1, SCORE_X, SCORE_Y + SCORE_HEIGHT + 10)
end

function Score:progress(score, bestScore)
  if bestScore > 0 then
    local percentage = math.min(100, (score / (bestScore * 0.75)) * 100)

    self.x = (percentage * SCORE_WIDTH) / 100
  end
end
