require "tapSet"

VisibleTapSet = TapSet:new()

function VisibleTapSet:updateY(height, speed)
  for i=#self.taps, 1, -1 do
    v = self.taps[i]
    v.y = v.y + (height / speed)

    if v.y > h + 50 then
      table.remove(self.taps, i)
    end
  end
end

function VisibleTapSet:add(tap)
  table.insert(self.taps, {x=x_for_char(tap.char), y=-75, id=tap.id})
end

function x_for_char(c)
  xs = {a=75, b=250, c=425, d=600}
  return xs[c]
end
