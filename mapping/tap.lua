Tap = {
  id = 0,
  health = 1,
  kind = "tap",
  char = nil
}

function Tap:new(id, health)
  local o = {
    id = id,
    health = health
  }

  setmetatable(o, self)
  self.__index = self

  return o
end
