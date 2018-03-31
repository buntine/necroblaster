fun = require "lib/fun"

Lane = {
  taps = {},
  x = 0,
  total = 0
}

function Lane:new(x)
  local o = {taps = {}, x = x}

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

function Lane:render(h)
  love.graphics.circle("fill", self.x, h - 40, 30)

  for _, t in ipairs(self.taps) do
    if t.kind == "tap" then
      love.graphics.circle("fill", self.x, t.y, 30)
    elseif t.kind == "doublekick" then
      love.graphics.circle("fill", (t.nth % 2 == 0 and self.x - 40 or self.x + 40), t.y, 15)
    end
  end
end
