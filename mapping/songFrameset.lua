-- Represents time throughout a song.
--
-- The song is broken into a list of small windows of time (~15ms), each of
-- which contains 0 or more potential "taps".
--
-- The framePointer moves through the list as time passes while a song is playing.

json = require "lib.json"
tap = require "mapping.tap"

require "mapping.tapGenerator"
require "mapping.doubleKickGenerator"
require "mapping.blastbeatGenerator"

SongFrameset = Class{
  init = function(self, songid, speed, handedness)
    self.speed = speed
    self.laneChars = BUTTON_MAPPING[handedness]

    local path = DATA_PATH .. "/" .. songid .. "/map.json"
    self.data = json.decode(readFile(path))
  end,
  frames = {},
  framePointer = 0,
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
  self:initializeFrames()

  local generators = {
    tap = TapGenerator(),
    doublekick = DoubleKickGenerator(),
    blastbeat = BlastbeatGenerator(),
  }

  for _it, d in fun.iter(self.data) do
    local gen = generators[d.kind]
    local taps = gen:generate(d, self.laneChars)

    mergeTables(self.frames, taps)
  end
end

-- Populates the frames table with empty tables.
function SongFrameset:initializeFrames()
  local size = math.floor(self.data[#self.data].offset / TIME_SCALE) + DAMPENING

  self.frames = fun.totable(fun.take(size, fun.tabulate(function(x) return {} end)))
end

-- Returns the best possible score (if every tap was perfectly hit).
function SongFrameset:bestScore()
  return 999
end
