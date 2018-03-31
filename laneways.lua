fun = require "lib/fun"
require "tapSet"
require "lane"

LANE_WIDTH = 175
LANE_OFFSET = 75

LaneWays = {
  lanes = {}
}

function LaneWays:new()
  local o = {
    lanes = {
      a = Lane:new(LANE_OFFSET),
      b = Lane:new(LANE_OFFSET + LANE_WIDTH),
      c = Lane:new(LANE_OFFSET + LANE_WIDTH * 2),
      d = Lane:new(LANE_OFFSET + LANE_WIDTH * 3)
    }
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function LaneWays:progress(height, speed)
  fun.each(function(_, l)
    l:progress(height, speed)
  end, self.lanes)
end

function LaneWays:add(tap)
  local lane = self:lanefor(tap.char)

  lane:add(tap)
end

function LaneWays:seen(tap)
  local lane = self:lanefor(tap.char)

  return lane:seen(tap.id)
end

function LaneWays:lanefor(c)
  return self.lanes[c]
end
