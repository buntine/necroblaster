require "helpers"

Score = {
  clip = 30,
  lastScore = 0,
  bg = love.graphics.newImage("assets/images/score.png"),
  powerbar = love.graphics.newImage("assets/images/powerbar.png")
}

function Score:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Score:render()
  love.graphics.draw(self.bg, SCORE_X, 0)

  withScissor(SCORE_X, 48, self.clip, 50, function()
    love.graphics.draw(self.powerbar, SCORE_X, 48)
  end)
end

function Score:progress(score)
  local clip = self.clip

  -- Resistance is stronger as player performance gets better.
  local resistance = (clip / SCORE_WIDTH) * SCORE_RESISTANCE
  local adjustment = (score > self.lastScore) and SCORE_FORCE or -resistance
  local nextClip = clip + adjustment

  if nextClip >= 1 and nextClip < SCORE_WIDTH then
    self.clip = nextClip
  end

  self.lastScore = score
end
