require "gui.lane"

LaneWays = {
  lanes = {}
}

function LaneWays:new()
  local o = {
    lanes = {
      a = Lane:new(0),
      b = Lane:new(1),
      c = Lane:new(2),
      d = Lane:new(3)
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
