-- A rain droplet with randomised speed, angle, weight and starting position.

Droplet = Class{
  init = function(self)
    local distance = math.random(DROP_MIN_DISTANCE, DROP_MAX_DISTANCE)
    local speed = normalise(distance, DROP_MIN_DISTANCE, DROP_MAX_DISTANCE, DROP_MAX_SPEED) + DROP_MIN_SPEED
    local thickness = normalise(distance, DROP_MIN_DISTANCE, DROP_MAX_DISTANCE, DROP_MAX_THICKNESS) + DROP_MIN_THICKNESS
    local angle = math.random(DROP_MIN_ANGLE, DROP_MAX_ANGLE)
    local x = math.random(10, ACTUAL_WIDTH * 1.8)

    self.thickness = thickness
    self.angle = angle
    self.width = distance
    self.speed = speed
    self.x = x
  end,
  y = 0,
}

function Droplet:render()
  withLineWidth(self.thickness, function()
    love.graphics.line(self.x, self.y, self.x - self.width, self.y + self.width)
  end)
end

function Droplet:progress()
  self.x = self.x - self.speed
  self.y = self.y + self.speed + self.angle
end

function Droplet:done()
  return self.x < 0 or self.y < 0
end
