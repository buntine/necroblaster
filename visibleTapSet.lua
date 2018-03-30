fun = require "lib/fun"
require "tapSet"

VisibleTapSet = TapSet:new()

function VisibleTapSet:updateY(height, speed)
  for i=#self.taps, 1, -1 do
    local v = self.taps[i]
    v.y = v.y + (height / speed)

    if v.y > height + 50 then
      table.remove(self.taps, i)
    end
  end
end

function VisibleTapSet:add(tap)
  table.insert(self.taps, {x=x_for_char(tap.char), y=-75, id=tap.id, kind=tap.kind})
end

function x_for_char(c)
  local xs = {a=75, b=250, c=425, d=600}
  return xs[c]
end

function VisibleTapSet:seen(tapID)
  return fun.any(function(t) return t.id == tapID end, self.taps)
end
