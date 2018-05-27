-- Represents the set of taps that have been successfully "hit" for
-- the current song.
--
-- The current score is cached here.

TapSet = Class{
  init = function(self)
    self.taps = {}
  end,
  score = 0,
}

function TapSet:add(tap)
  table.insert(self.taps, tap)
  self.score = self.score + tap.health
end

function TapSet:seen(tap)
  return (not tap.id) or (#self.taps > 0 and self.taps[#self.taps].id == tap.id or false)
end
