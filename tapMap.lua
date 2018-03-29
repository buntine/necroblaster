json = require "lib/json"
fun = require "lib/fun"

DEFAULT_SPEED = 120
TIME_SCALE = 1000 / 15
FRAME_DELTA = 4
DAMPENING = 2
DATA_PATH = "data/songs"

TapMap = {
  data = {},
  keys = {},
  framePointer = 0,
  position = 0,
  speed = DEFAULT_SPEED
}

function TapMap:new(path)
  local o = {}

  setmetatable(o, self)
  self.__index = self

  local file = io.open(DATA_PATH .. "/" .. path .. ".json", "r")
  local data = file:read("*a")
  file:close()

  o.data = json.decode(data)

  return o
end

function TapMap:progress()
  self.framePointer = self.framePointer + 1
end

function TapMap:currentFrame(offset)
  return math.floor((self.framePointer + (offset or 0)) / FRAME_DELTA) + 1
end

function TapMap:currentTap()
  local frame = self:currentFrame()

  return self.keys[frame]
end

function TapMap:futureTap()
  local frame = self:currentFrame(self.speed)

  return self.keys[frame]
end

function TapMap:generate()
  local size = math.floor(self.data[#self.data].offset / TIME_SCALE) + DAMPENING
  self.keys = fun.totable(fun.take(size, fun.tabulate(function(x) return {} end)))

  for _it, d in fun.iter(self.data) do
    local index = math.floor(d.offset / TIME_SCALE)
    
    for _it, i in fun.range(index - DAMPENING, index + DAMPENING) do
      local diff = math.abs(index - i) + 1
      self.keys[i] = {id = index, char = d.char, health = 1 / diff}
    end
  end
end
