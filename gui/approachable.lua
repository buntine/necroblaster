-- Abstract class for 2D projection and scaling.

Approachable = {
  z = 0,
  x = 0,
  y = 0
}

function Approachable:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Approachable:progress(h, speed)
  -- Super simple projection from Z to Y.
  self.z = self.z - ((TAP_Z - 1) / speed)
  self.y = (h / self.z) - (h / TAP_Z)
end

function Approachable:project(w, h, f)
  local xVanishingPoint = w / 2

  -- Calculate scale and X position to imply distance.
  local a = (h - VANISHING_POINT_Y) / (self.x - xVanishingPoint)
  local b = VANISHING_POINT_Y - (a * xVanishingPoint)
  local x = (self.y - b) / a
  local scaling = ((self.y - VANISHING_POINT_Y) / (h - VANISHING_POINT_Y))

  f(o, x, scaling)
end
