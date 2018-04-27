-- Represents the set of taps that have been successfully "hit" for
-- the current song.
--
-- The current score is cached here.

TapSet = {
  taps = {},
  score = 0
}

function TapSet:new()
  local o = {taps = {}}

  setmetatable(o, self)
  self.__index = self

  return o
end

function TapSet:add(tap)
  table.insert(self.taps, tap)
  self.score = self.score + tap.health
end

function TapSet:seen(tap)
  return (not tap.id) or (#self.taps > 0 and self.taps[#self.taps].id == tap.id or false)
end
