-- A visible tap that is approaching the bottom of the screen.

require "src.gui.approachable"

VisibleTap = Class{
  __includes = Approachable,
  init = function(self, tap, x)
    self.z = TAP_Z
    self.x = x
    self.y = 0 - tap.offset
    self.opacity = 1
    self.tap = tap
    self.remove = false
  end,
}

function VisibleTap:progress(speed)
  -- Fade out tap after it's been hit.
  if self.remove then
    self.opacity = self.opacity - HIT_TAP_OPACITY_FACTOR
  end

  Approachable.progress(self, speed)
end

function VisibleTap:render()
  local tap = self.tap
  local x, scaling = unpack(self:project())
  local img = TAP_IMAGES[tap.kind]
  local radius = TAP_RADIUS[tap.kind]
  local finalX = x - (radius * scaling);
  
  if tap.kind == "doublekick" then
    local offset = DOUBLEKICK_SPACING * scaling
    local position = (self.tap.left and -offset or offset)

    finalX = finalX + position
  end

  withOpacity(self.opacity, function()
    love.graphics.draw(img, finalX, self.y, 0, scaling)
  end)
end

function VisibleTap:done()
  return (self.y > DESIRED_HEIGHT - APPROACH_MAX_OFFSET) or self.opacity <= 0
end

function VisibleTap:hit()
  -- Just remove doublekick, etc very quickly.
  if self.tap.kind ~= "tap" then
    self.opacity = 0.5
  end

  self.remove = true
end
