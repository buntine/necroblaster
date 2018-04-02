Lane = {
  taps = {},
  nth = 0,
  x = 0,
  total = 0
}

function Lane:new(nth)
  local o = {
    taps = {},
    nth = nth,
    x = LANE_OFFSET + (LANE_WIDTH * nth) + (LANE_WIDTH / 2)
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Lane:seen(id)
  return fun.any(function(t) return t.id == id end, self.taps)
end

function Lane:progress(h, speed)
  for i=#self.taps, 1, -1 do
    local t = self.taps[i]

    -- Super simple projection from Z to Y.
    t.z = t.z - ((TAP_Z - 1) / speed)
    t.y = (h / t.z) - (h / TAP_Z)

    if t.y > h then
      table.remove(self.taps, i)
    end
  end
end

function Lane:add(tap)
  self.total = self.total + 1
  table.insert(self.taps, {y=-75, z=TAP_Z, id=tap.id, kind=tap.kind, nth=self.total})
end

function Lane:render(w, h)
  love.graphics.circle("fill", self.x, h - 40, 30)

  local xVanishingPoint = w / 2
  local a = (h - VANISHING_POINT_Y) / (self.x - xVanishingPoint)
  local b = VANISHING_POINT_Y - (a * xVanishingPoint)

  for _, t in ipairs(self.taps) do
    local x = (t.y - b) / a
    local normaliser = ((t.y - VANISHING_POINT_Y) / (h - VANISHING_POINT_Y))

    if t.kind == "tap" then
      local radius = TAP_RADIUS * normaliser

      love.graphics.circle("fill", x, t.y, radius)
    elseif t.kind == "doublekick" then
      local radius = DOUBLEKICK_RADIUS * normaliser
      local offset = DOUBLEKICK_SPACING * normaliser

      love.graphics.circle("fill", (t.nth % 2 == 0 and x - offset or x + offset), t.y, radius)
    end
  end
end
