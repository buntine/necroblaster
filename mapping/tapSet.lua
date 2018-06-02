-- Represents the set of taps that have been successfully "hit" for
-- the current song.
--
-- The current score is cached here.

TapSet = Class{
  init = function(self)
    self.taps = {}
  end,
  score = 0,
  accuracy = 0,
}

function TapSet:add(tap)
  table.insert(self.taps, tap)
  self.score = self.score + 1
  self.accuracy = self.accuracy + tap.health
end

function TapSet:seen(tap)
  return (#self.taps > 0 and self.taps[#self.taps].group == tap.group or false)
end
