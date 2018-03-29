json = require "lib/json"

DEFAULT_SPEED = 90
TIME_SCALE = 1000 / 15
DATA_PATH = "data/songs"

TapMap = {
  data = {},
  keys = {},
  framePointer = 0,
  position = 0,
  speed = DEFAULT_SPEED
}

function TapMap:new(path, speed)
  local o = o or {}

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

function TapMap:currentFrame()
  return math.floor(self.framePointer / 4) + 1
end

function TapMap:currentTap()
  local frame = self:currentFrame()

  return self.data[frame]
end

function list_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
           i = i + 1
           if i <= n then
             return unpack({t[i], i})
           end
         end
end

function TapMap:generate()
  local pos = 0
  local dataIter = list_iter(self.data)
  local nextKey, i = dataIter()

  while true do
    local frameBlock = {id=nil, char=nil, health=nil}
    local timeDiff = math.abs(nextKey.offset - pos)

    if timeDiff <= BLOCK_SIZE * 3 then
      frameBlock.char = nextKey.char
      frameBlock.id = i

      if pos >= nextKey.offset then
        frameBlock.health = 0.5
        nextKey, i = dataIter()
      elseif timeDiff > BLOCK_SIZE then
        frameBlock.health = 0.5
      else
        frameBlock.health = 1.0
      end
    end

    table.insert(self.keys, frameBlock)
    pos = pos + BLOCK_SIZE

    if nextKey == nil then break end
  end
end
