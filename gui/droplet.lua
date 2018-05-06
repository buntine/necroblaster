Droplet = {
  y = 0,
}

function Droplet:new(songid)
  local distance = math.random(DROP_MIN_DISTANCE, DROP_MAX_DISTANCE)
  local speed = normalise(distance, DROP_MIN_DISTANCE, DROP_MAX_DISTANCE, DROP_MAX_SPEED) + DROP_MIN_SPEED
  local thickness = normalise(distance, DROP_MIN_DISTANCE, DROP_MAX_DISTANCE, DROP_MAX_THICKNESS) + DROP_MIN_THICKNESS
  local angle = math.random(DROP_MIN_ANGLE, DROP_MAX_ANGLE)
  local x = math.random(10, ACTUAL_WIDTH * 1.8)

  local o = {
    thickness = thickness,
    angle = angle,
    width = distance,
    speed = speed,
    x = x,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

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
