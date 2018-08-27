-- Represents time throughout a song.
--
-- The song is broken into a list of small windows of time (~15ms), each of
-- which contains 0 or more potential "taps".
--
-- The framePointer moves through the list as time passes while a song is playing.

json = require "lib.json"
tap = require "src.mapping.tap"

require "src.mapping.tapGenerator"
require "src.mapping.doubleKickGenerator"
require "src.mapping.blastbeatGenerator"

Frameset = Class{
  init = function(self, songid, speed, handedness)
    self.speed = speed
    self.laneChars = BUTTON_MAPPING[handedness]

    local path = DATA_PATH .. "/" .. songid .. "/map.json"
    self.data = json.decode(readFile(path))
  end,
  frames = {},
  framePointer = 0,
}

function Frameset:progress(pos)
  self.framePointer = math.floor((pos * 1000) / TIME_SCALE)
end

function Frameset:currentTaps()
  return self.frames[self.framePointer] or {}
end

function Frameset:isEmptyFrame()
  return #self:currentTaps() == 0
end

-- Returns the taps for the frame we will be up to in exactly N=(self.speed / 60) seconds.
function Frameset:futureTaps(pos)
  local milliseconds = (pos + (self.speed / 60)) * 1000
  local frame = math.floor(milliseconds / TIME_SCALE)

  return self.frames[frame] or {}
end

-- Loads a song from JSON into a list of time frames.
function Frameset:generate()
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
function Frameset:initializeFrames()
  local size = math.floor(self.data[#self.data].offset / TIME_SCALE) + DAMPENING

  self.frames = fun.totable(fun.take(size, fun.tabulate(function(x) return {} end)))
end

-- Returns the best possible score (if every tap was perfectly hit).
function Frameset:bestScore()
  local bestScoreForFrame = function(frame)
    return fun.foldl(
      function (total, tap)
        return total + (tap.renderable and tap.health or 0)
      end,
      0,
      frame
    )
  end

  return fun.foldl(
    function (total, frame)
      return total + bestScoreForFrame(frame)
    end,
    0,
    self.frames
  )
end
