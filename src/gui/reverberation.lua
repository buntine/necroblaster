-- A graphical explosion off the hit plate when a hit is made. The tap itself
-- is also bounced off the plate.

Reverberation = Class{
  init = function(self, tap, x)
    local radius = TAP_RADIUS[tap.kind]
    local y = DESIRED_HEIGHT - PLATE_OFFSET - radius

    self.tap = tap
    self.reverb_x = x
    self.reverb_y = y
    self.rebound_x = x
    self.rebound_y = y
    self.rebound_velocity = REBOUND_VELOCITY

    speed = expand_normalise(normalise(x, 0, DESIRED_WIDTH, 1),
                             REBOUND_MIN_SPEED, REBOUND_MAX_SPEED)
    self.rebound_speed = math.random(speed - REBOUND_SPEED_VARIANCE,
                                     speed + REBOUND_SPEED_VARIANCE)
  end,
  opacity = 1,
  scaling = 1,
}

function Reverberation:progress()
  self.reverb_y = self.reverb_y - (TAP_RADIUS[self.tap.kind] / 1.5)

  self.rebound_x = self.rebound_x + self.rebound_speed
  self.rebound_y = self.rebound_y + self.rebound_velocity
  self.rebound_velocity = self.rebound_velocity + GRAVITY

  self.scaling = self.scaling + REVERB_SCALING_FACTOR
  self.opacity = self.opacity - REVERB_OPACITY_FACTOR
end

function Reverberation:render()
  local img = TAP_IMAGES[self.tap.kind]
  local radius = TAP_RADIUS[self.tap.kind]
  local offset = 0

  if (self.tap.kind == "doublekick") then
    offset = (self.tap.left and -DOUBLEKICK_SPACING or DOUBLEKICK_SPACING)
  end

  withOpacity(self.opacity, function()
    love.graphics.draw(img, self.reverb_x + offset - (radius * self.scaling), self.reverb_y, 0, self.scaling)
  end)

  love.graphics.draw(img, self.rebound_x + offset - radius, self.rebound_y)
end

function Reverberation:done()
  return self.rebound_y > ACTUAL_HEIGHT
end
