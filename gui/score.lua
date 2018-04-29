require "helpers"

Score = {
  clip = 0,
  bg = love.graphics.newImage("assets/images/score.png"),
  powerbar = love.graphics.newImage("assets/images/powerbar.png")
}

function Score:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Score:render(score)
  love.graphics.draw(self.bg, SCORE_X, 0)
  withScissor(SCORE_X, 48, self.clip, 50, function()
    love.graphics.draw(self.powerbar, SCORE_X, 48)
  end)
end

function Score:progress(score, bestScore)
  self.clip = self.clip + 0.5
end
