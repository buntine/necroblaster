-- A wrapper class over the set of lanes.
-- Each lane maintains a set of upcoming/renderable taps.

require "gui.lane"

Laneways = {
  lanes = {}
}

function Laneways:new()
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

function Laneways:progress(height, speed)
  for _, l in pairs(self.lanes) do
    l:progress(height, speed)
  end
end

function Laneways:render()
  for _, l in pairs(self.lanes) do
    l:render()
  end
end

function Laneways:add(tap)
  local lane = self:laneFor(tap)

  lane:add(tap)
end

function Laneways:seen(tap)
  local lane = self:laneFor(tap)

  return lane:seen(tap)
end

function Laneways:laneFor(tap)
  return self.lanes[tap.char]
end
