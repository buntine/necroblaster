require "approachable"

Lane = Approachable:new()

function Lane:new(nth)
  local o = {
    items = {},
    nth = nth,
    x = LANE_OFFSET + (LANE_WIDTH * nth) + (LANE_WIDTH / 2),
    total = 0
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Lane:seen(id)
  return fun.any(function(t) return t.id == id end, self.items)
end

function Lane:add(tap)
  self.total = self.total + 1
  table.insert(self.items, {y=0, x=self.x, z=TAP_Z, id=tap.id, kind=tap.kind, nth=self.total})
end

function Lane:render(w, h)
  love.graphics.circle("fill", self.x, h - 40, 30)

  self:project(w, h, function(t, x, scaling)
    if t.kind == "tap" then
      local radius = TAP_RADIUS * scaling

      love.graphics.circle("fill", x, t.y, radius)
    elseif t.kind == "blastbeat" then
      local radius = DOUBLEKICK_RADIUS * scaling

      love.graphics.circle("fill", x, t.y, radius)
    elseif t.kind == "doublekick" then
      local radius = DOUBLEKICK_RADIUS * scaling
      local offset = DOUBLEKICK_SPACING * scaling

      love.graphics.circle("fill", (t.nth % 2 == 0 and x - offset or x + offset), t.y, radius)
    end
  end)
end
