-- Manages the streak (consecutive hits) and the side-effects it produces
-- such as exploding motivational words.

Streak = Class{
  prevPower = 0,
  prevValue = 0,
  word = nil,
  opacity = 1,
  scale = 1,
}

function Streak:render()
  if not self.word then
    return
  end

  withColour(0.15, 0.33, 0.17, self.opacity, function()
    drawInCenter(self.word, 0, 0, self.scale, self.scale)
  end)
end

function Streak:progress(clip)
  local power = (clip / MAX_SCORE_CLIP) * 100

  if self.word then
    self:progressWord()
  else
    local streak = self:findNextWord(power)

    if streak then
      self:setWord(streak)
    end
  end

  self.prevPower = power
end

function Streak:progressWord()
  self.scale = self.scale + STREAK_SCALE_FACTOR
  self.opacity = self.opacity - STREAK_OPACITY_FACTOR

  if self.opacity <= 0 then
    self:removeWord()
  end
end

function Streak:setWord(streak)
  self.word = streak.word
  self.prevValue = streak.value
end

function Streak:findNextWord(power)
  local streaks = fun.filter(function (s) return s.value <= power end, STREAKS)
  local streak = fun.nth(1, streaks)

  -- Ensure the next word was not the one we just saw and also ensure we have crossed over
  -- into it's domain and not fallen back into it from above.
  if streak and streak.value ~= self.prevValue and self.prevPower < streak.value then
    return streak
  end
end

function Streak:removeWord()
  self.word = nil
  self.scale = 1
  self.opacity = 1
end
