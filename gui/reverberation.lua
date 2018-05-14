-- A graphical reflection off the hit plate when a hit is made.
--
-- This object maintains the state. Rendering is left to the lane.

Reverberation = {
  opacity = 1,
  tap = nil,
  scaling = 1,
  x = 0,
  y = 0,
}

function Reverberation:new(tap, x)
  local radius = TAP_RADIUS[tap.kind]
  local y = DESIRED_HEIGHT - PLATE_OFFSET - radius
  local o = { tap = tap, x = x, y = y }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Reverberation:progress()
  self.y = self.y - (TAP_RADIUS[self.tap.kind] / 1.5)
  self.scaling = self.scaling + REVERB_SCALING_FACTOR
  self.opacity = self.opacity - REVERB_OPACITY_FACTOR
end

function Reverberation:render()
  local img = TAP_IMAGES[self.tap.kind]
  local radius = TAP_RADIUS[self.tap.kind]

  withOpacity(self.opacity, function()
    local offset = 0

    if (self.tap.kind == "doublekick") then
      offset = (self.tap.nth % 2 == 0 and -DOUBLEKICK_SPACING or DOUBLEKICK_SPACING)
    end

    love.graphics.draw(img, self.x + offset - (radius * self.scaling), self.y, 0, self.scaling)
  end)
end

function Reverberation:done()
  return self.opacity <= 0
end
