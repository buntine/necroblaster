TapSet = {
  taps = {}
}

function TapSet:new()
  o = {taps = {}}

  setmetatable(o, self)
  self.__index = self

  return o
end

function TapSet:add(tap)
  table.insert(self.taps, tap)
end

function TapSet:seen(tapID)
  return (#self.taps > 0 and self.taps[#self.taps].id == tapID or false)
end
