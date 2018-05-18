-- Manages the streak (consecutive hits) and the side-effects it produces
-- such as exploding motivational words.

Streak = {
  count = 0,
  word = nil,
  opacity = 1,
  scale = 1,
}

function Streak:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Streak:render(adjustment)
  -- Render current word
end

function Streak:progress(adjustment)
  if adjustment > 0 then
    self:increment()
  else
    self:reset()
  end

  if self.word then
    self:progressWord();
  else
    self:setWord();
  end
end

function Streak:increment()
  self.count = self.count + 1
end

function Streak:reset()
  self.count = 0
end

function Streak:progressWord()
  self.scale = self.scale + STREAK_SCALE_FACTOR
  self.opacity = self.opacity - STREAK_OPACITY_FACTOR

  if self.opacity <= 0 then
    self:removeWord()
  end
end

function Streak:setWord()
  local streaks = fun.filter(function (s) return s.value == self.count end, STREAKS)
  local streak = fun.nth(1, streaks)

  if streak then
    self.word = streak.word
  end
end

function Streak:removeWord()
  self.word = nil
  self.scale = 1
  self.opacity = 1
end
