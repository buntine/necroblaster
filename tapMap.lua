json = require "lib/json"

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

function TapMap:progress(pos)
  self.framePointer = math.floor((pos * 1000) / TIME_SCALE)
end

function TapMap:currentTaps()
  return self.keys[self.framePointer] or {}
end

-- Returns the taps for the frame we will be up to in exactly N=(self.speed / 60) seconds.
function TapMap:futureTaps(pos)
  local frame = math.floor(((pos + (self.speed / 60)) * 1000) / TIME_SCALE)

  return self.keys[frame] or {}
end

function TapMap:generate()
  local size = math.floor(self.data[#self.data].offset / TIME_SCALE) + DAMPENING
  self.keys = fun.totable(fun.take(size, fun.tabulate(function(x) return {} end)))

  for _it, d in fun.iter(self.data) do
    local index = math.floor(d.offset / TIME_SCALE)
    
    if d.kind == "tap" then
      self:populateKeys(index - DAMPENING, index + DAMPENING, d, function(i)
        local diff = math.abs(index - i) + 1
        return {id = index, health = 1 / diff}
      end)
    elseif d.kind == "doublekick" then
      local finishIndex = math.floor(d.finish / TIME_SCALE)

      self:populateKeys(index, finishIndex, d, function(i)
        return {id = i, health = 0.5}
      end)
    end
  end
end

function TapMap:populateKeys(start, stop, d, f)
  for _it, i in fun.range(start, stop) do
    local o = f(i)
    o.char = d.char
    o.kind = d.kind

    table.insert(self.keys[i], o)
  end
end
