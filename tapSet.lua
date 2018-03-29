TapSet = {
  taps={}
}

function TapSet:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function TapSet:add(tap)
  table.insert(self.taps, tap)
end

function TapSet:lastTapID()
  return (#self.taps > 0 and self.taps[#self.taps].id or nil)
end
