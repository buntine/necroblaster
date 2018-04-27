-- Represents time throughout a song.
--
-- The song is broken into a list of small windows of time (~15ms), each of
-- which contains 0 or more potential "taps".
--
-- The framePointer moves through the list as time passes while a song is playing.

json = require "lib/json"
tap = require "mapping/tap"

SongFrameset = {
  data = {},
  frames = {},
  laneChars = {},
  framePointer = 0,
  position = 0,
  bestScore = 0,
  speed = 180,
}

function SongFrameset:new(songid, speed, handedness)
  local o = {
    speed = speed,
    laneChars = (handedness == "right") and {BTN_D, BTN_C, BTN_B, BTN_A} or {BTN_A, BTN_B, BTN_C, BTN_D}
  }

  setmetatable(o, self)
  self.__index = self

  local file = io.open(DATA_PATH .. "/" .. songid .. "/map.json", "r")
  local data = file:read("*a")
  file:close()

  o.data = json.decode(data)

  return o
end

function SongFrameset:progress(pos)
  local currentFP = self.framePointer

  self.framePointer = math.floor((pos * 1000) / TIME_SCALE)

  -- Update the cached best possible score for this point in the song.
  if self.framePointer > currentFP then
    for _, t in ipairs(self:currentTaps()) do
      if not (t.kind == "tap" and t.health < 1) then
        self.bestScore = self.bestScore + t.health
      end
    end
  end
end

function SongFrameset:currentTaps()
  return self.frames[self.framePointer] or {}
end

-- Returns the taps for the frame we will be up to in exactly N=(self.speed / 60) seconds.
function SongFrameset:futureTaps(pos)
  local frame = math.floor(((pos + (self.speed / 60)) * 1000) / TIME_SCALE)

  return self.frames[frame] or {}
end

-- Loads a song from JSON into a list of time frames.
function SongFrameset:generate()
  local size = math.floor(self.data[#self.data].offset / TIME_SCALE) + DAMPENING

  self.frames = fun.totable(fun.take(size, fun.tabulate(function(x) return {} end)))

  for _it, d in fun.iter(self.data) do
    local index = math.floor(d.offset / TIME_SCALE)
    
    if d.kind == "tap" then
      self:populateKeys(index - DAMPENING, index + DAMPENING, 1, d, function(i)
        local blurring = math.abs(index - i) + 1
        return Tap:new(index, 1 / blurring)
      end)
    else
      local finishIndex = math.floor(d.finish / TIME_SCALE)
      local step, health = unpack(
        (d.kind == "blastbeat" and {1, 1} or {1, 0.5})
      )

      self:populateKeys(index, finishIndex, step, d, function(i)
        return Tap:new(i, health)
      end)
    end
  end
end

function SongFrameset:populateKeys(start, stop, step, d, f)
  for _it, i in fun.range(start, stop, step) do
    local tap = f(i)
    tap.char = self.laneChars[d.lane]
    tap.kind = d.kind

    table.insert(self.frames[i], tap)
  end
end
