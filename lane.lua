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

function Lane:progress(height, speed)
  for i=#self.taps, 1, -1 do
    local t = self.taps[i]
    t.y = t.y + (height / speed)

    if t.y > height + 50 then
      table.remove(self.taps, i)
    end
  end
end

function Lane:add(tap)
  self.total = self.total + 1
  table.insert(self.taps, {y=-75, id=tap.id, kind=tap.kind, nth=self.total})
end

function Lane:render(w, h)
  love.graphics.circle("fill", self.x, h - 40, 30)

  local xVanishingPoint = w / 2

  for _, t in ipairs(self.taps) do
    if t.kind == "tap" then
      local a = (h - VANISHING_POINT_Y) / (self.x - xVanishingPoint)
      local b = VANISHING_POINT_Y - (a * xVanishingPoint)
      local x = (t.y - b) / a

      love.graphics.circle("fill", x, t.y, 30)
    elseif t.kind == "doublekick" then
      love.graphics.circle("fill", (t.nth % 2 == 0 and self.x - 40 or self.x + 40), t.y, 15)
    end
  end
end
