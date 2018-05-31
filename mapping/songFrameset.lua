-- Represents time throughout a song.
--
-- The song is broken into a list of small windows of time (~15ms), each of
-- which contains 0 or more potential "taps".
--
-- The framePointer moves through the list as time passes while a song is playing.

json = require "lib/json"
tap = require "mapping/tap"

SongFrameset = Class{
  init = function(self, songid, speed, handedness)
    self.speed = speed
    self.laneChars = BUTTON_MAPPING[handedness]
    self.laneTotals = {0, 0, 0, 0}

    local path = DATA_PATH .. "/" .. songid .. "/map.json"
    self.data = json.decode(readFile(path))
  end,
  frames = {},
  framePointer = 0,
  bestScore = 0,
}

function SongFrameset:progress(pos)
  self.framePointer = math.floor((pos * 1000) / TIME_SCALE)
end

function SongFrameset:currentTaps()
  return self.frames[self.framePointer] or {}
end

function SongFrameset:isEmptyFrame()
  return #self:currentTaps() == 0
end

-- Returns the taps for the frame we will be up to in exactly N=(self.speed / 60) seconds.
function SongFrameset:futureTaps(pos)
  local milliseconds = (pos + (self.speed / 60)) * 1000
  local frame = math.floor(milliseconds / TIME_SCALE)

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
        local nth = self.laneTotals[d.lane]

        return Tap(index, nth, 1 / blurring)
      end)
    else
      local finishIndex = math.floor(d.finish / TIME_SCALE)
      local step, health = unpack(
        (d.kind == "blastbeat" and {1, 1} or {1, 0.5})
      )

      self:populateKeys(index, finishIndex, step, d, function(i)
        local nth = self.laneTotals[d.lane]

        return Tap(i, nth, health)
      end)
    end
  end

  self.bestScore = 999 -- TODO: Sum all health=1 taps across all frames.
end

function SongFrameset:populateKeys(start, stop, step, d, f)
  for _it, i in fun.range(start, stop, step) do
    self:incrementLaneTotal(d.lane)

    local tap = f(i)

    tap.char = self.laneChars[d.lane]
    tap.kind = d.kind

    table.insert(self.frames[i], tap)
  end
end

function SongFrameset:incrementLaneTotal(lane)
  self.laneTotals[lane] = self.laneTotals[lane] + 1
end
