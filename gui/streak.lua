-- Manages the streak (consecutive hits) and the side-effects it produces
-- such as exploding motivational words.

Streak = {
  count = 0,
  word = 0,
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

  -- Has passed threshold?
  ---- Set word
  --
  -- Is current word?
  ---- Progress 
end

function Streak:increment()
  self.count = self.count + 1
end

function Streak:reset()
  self.count = 0
end
