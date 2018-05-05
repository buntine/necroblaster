-- A simple bump effect across the X axis.

Bump = {
  x = 0,
  initialX = 0,
  inertia = 0.75,
  gravity = 0,
  applicableGravity = 0,
}

function Bump:new(x, gravity, inertia)
  local n = inertia or self.inertia
  local o = {
    x = x,
    initialX = x,
    inertia = (gravity > 0) and -n or n,
    applicableGravity = gravity,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Bump:progress()
  if self:isRunning() then
    self.x = self.x + self.gravity
    self.gravity = self.gravity + self.inertia

    if self:finished() then
      self.gravity = 0
    end
  end
end

function Bump:isRunning()
  return self.x ~= self.initialX or self.gravity ~= 0
end

function Bump:finished()
  return math.abs(self.gravity) > math.abs(self.applicableGravity)
end

function Bump:start()
  if not self:isRunning() then
    self.gravity = self.applicableGravity
  end
end
