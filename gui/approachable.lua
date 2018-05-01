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

function Approachable:progress(speed)
  local h = DESIRED_HEIGHT

  -- Super simple projection from Z to Y.
  self.z = self.z - ((TAP_Z - 1) / speed)
  self.y = (h / self.z) - (h / TAP_Z)
end

function Approachable:project(f)
  local xVanishingPoint = DESIRED_WIDTH / 2
  local h = DESIRED_HEIGHT

  -- Calculate scale and X position to imply distance.
  local a = (h - VANISHING_POINT_Y) / (self.x - xVanishingPoint)
  local b = VANISHING_POINT_Y - (a * xVanishingPoint)
  local x = (self.y - b) / a
  local scaling = ((self.y - VANISHING_POINT_Y) / (h - VANISHING_POINT_Y))

  return {x, scaling}
end
