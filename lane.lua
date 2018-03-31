fun = require "lib/fun"

Lane = {
  taps = {},
  x = 0
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
    local v = self.taps[i]
    v.y = v.y + (height / speed)

    if v.y > height + 50 then
      table.remove(self.taps, i)
    end
  end
end

function Lane:add(tap)
  table.insert(self.taps, {y=-75, id=tap.id, kind=tap.kind})
end
