-- A simple bump effect across the X axis.

Bump = Class{
  init = function(self, x, gravity, inertia)
    local n = inertia or 0.75

    self.x = x
    self.initialX = x
    self.inertia = (gravity > 0) and -n or n
    self.applicableGravity = gravity
  end,
  gravity = 0,
}

function Bump:progress()
  if self:isRunning() then
    self.x = self.x + self.gravity
    self.gravity = self.gravity + self.inertia

    if self:isFinished() then
      self.gravity = 0
    end
  end
end

function Bump:isRunning()
  return self.x ~= self.initialX or self.gravity ~= 0
end

function Bump:isFinished()
  return math.abs(self.gravity) > math.abs(self.applicableGravity)
end

function Bump:start()
  if not self:isRunning() then
    self.gravity = self.applicableGravity
  end
end
