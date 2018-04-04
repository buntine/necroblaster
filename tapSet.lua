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

function TapSet:seen(tapID)
  return (not tapID) or (#self.taps > 0 and self.taps[#self.taps].id == tapID or false)
end
