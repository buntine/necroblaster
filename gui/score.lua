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
  love.graphics.draw(self.bg, SCORE_X, 0)

end

function Score:progress(score, bestScore)
  if bestScore > 0 then
    local percentage = math.min(100, (score / (bestScore * 0.75)) * 100)

    self.x = (percentage * SCORE_WIDTH) / 100
  end
end
