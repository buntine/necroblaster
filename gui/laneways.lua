-- A wrapper class over the set of lanes.
--
-- Each lane maintains a set of upcoming/renderable taps.

require "gui.lane"

Laneways = Class{
  init = function(self)
    self.lanes = {
      a = Lane(0),
      b = Lane(1),
      c = Lane(2),
      d = Lane(3),
    }
  end,
}

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
  local lane = self:laneFor(tap.char)

  lane:add(tap)
end

function Laneways:seen(tap)
  local lane = self:laneFor(tap.char)

  return lane:seen(tap)
end

function Laneways:laneFor(key)
  return self.lanes[key]
end
