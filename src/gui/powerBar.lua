-- Manages and renders the power bar to indicate the relative performance of the player.

require "src.gui.streak"

PowerBar = Class{
  init = function(self)
    self.streak = Streak()
  end,
  clip = MIN_SCORE_CLIP,
  lastScore = 0,
  bg = love.graphics.newImage("assets/images/score.png"),
  powerbar = love.graphics.newImage("assets/images/powerbar.png"),
}

function PowerBar:render()
  self.streak:render()

  withoutScale(function()
    love.graphics.draw(self.bg, SCORE_X, 0)

    withScissor(SCORE_X, 48, self.clip, 50, function()
      love.graphics.draw(self.powerbar, SCORE_X, 48)
    end)
  end)
end

function PowerBar:progress(score)
  local clip = self.clip

  -- Resistance is stronger as player performance gets better.
  local resistance = (clip / MAX_SCORE_CLIP) * SCORE_RESISTANCE
  local adjustment = (score > self.lastScore) and SCORE_FORCE or -resistance
  local nextClip = math.min(clip + adjustment, MAX_SCORE_CLIP)

  self.streak:progress(nextClip)

  if nextClip >= MIN_SCORE_CLIP then
    self.clip = nextClip
  end

  self.lastScore = score
end
