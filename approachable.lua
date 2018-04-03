Approachable = {
  items = {}
}

function Approachable:new()
  local o = {
    items = {},
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Approachable:progress(h, speed)
  for i=#self.items, 1, -1 do
    local o = self.items[i]

    -- Super simple projection from Z to Y.
    o.z = o.z - ((TAP_Z - 1) / speed)
    o.y = (h / o.z) - (h / TAP_Z)

    if o.y > h then
      table.remove(self.items, i)
    end
  end
end

function Approachable:project(w, h, f)
  local xVanishingPoint = w / 2

  for _, o in ipairs(self.items) do
    -- Calculate scale and X position to imply distance.
    local a = (h - VANISHING_POINT_Y) / (o.x - xVanishingPoint)
    local b = VANISHING_POINT_Y - (a * xVanishingPoint)
    local x = (o.y - b) / a
    local normaliser = ((o.y - VANISHING_POINT_Y) / (h - VANISHING_POINT_Y))

    f(o, x, normaliser)
  end
end
