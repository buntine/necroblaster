-- A graphical reflection off the hit plate when a hit is made.
--
-- This object maintains the state. Rendering is left to the lane.

Reverberation = {
  opacity = 1,
  tap = nil,
  scaling = 0.5,
  x = 0,
  y = 0,
}

function Reverberation:new(tap, x)
  local o = { tap = tap, x = x, y = love.graphics.getHeight() - 70 }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Reverberation:progress()
  self.y = self.y - 10
  self.scaling = self.scaling + 0.3
  self.opacity = self.opacity - 0.09
end

function Reverberation:render()
  local img = TAP_IMAGES[self.tap.kind]
  local radius = TAP_RADIUS[self.tap.kind]

  withColour(1, 1, 1, self.opacity, function()
    love.graphics.draw(img, self.x - (radius * self.scaling), self.y, 0, self.scaling)
  end)
end

function Reverberation:done()
  return self.opacity <= 0
end
