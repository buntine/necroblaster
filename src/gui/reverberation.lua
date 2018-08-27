-- A graphical reflection off the hit plate when a hit is made.
--
-- This object maintains the state. Rendering is left to the lane.

Reverberation = Class{
  init = function(self, tap, x)
    local radius = TAP_RADIUS[tap.kind]
    local y = DESIRED_HEIGHT - PLATE_OFFSET - radius

    self.tap = tap
    self.x = x
    self.y = y
  end,
  opacity = 1,
  scaling = 1,
}

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
      offset = (self.tap.left and -DOUBLEKICK_SPACING or DOUBLEKICK_SPACING)
    end

    love.graphics.draw(img, self.x + offset - (radius * self.scaling), self.y, 0, self.scaling)
  end)
end

function Reverberation:done()
  return self.opacity <= 0
end
