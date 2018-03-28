DEFAULT_SPEED = 90
TIME_SCALE = 1000 / 15

TapMap = {
  keys = {},
  framePointer = 1,
  position = 1,
  speed = DEFAULT_SPEED
}

function TapMap:new(o) {
  o = o or {}

  setmetatable(o, self)
  self.__index = self

  return o
}
