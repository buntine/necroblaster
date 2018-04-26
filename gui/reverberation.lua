-- A graphical reflection off the hit plate when a hit is made.
--
-- This object maintains the state. Rendering is left to the lane.

Reverberation = {
  opacity = 1,
  x = 0,
  y = 0,
  kind = "tap",

}

function Reverberation:new(kind, x)
  local o = { kind = kind, x = x, y = love.graphics.getHeight() - 100 }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Reverberation:progress()
  self.y = self.y - 20
  self.opacity = self.opacity - 0.08
end

function Reverberation:done()
  return self.opacity <= 0
end
