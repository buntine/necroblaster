require "approachable"

Lane = Approachable:new()

function Lane:new(nth)
  local o = {
    items = {},
    nth = nth,
    x = LANE_OFFSET + (LANE_WIDTH * nth) + (LANE_WIDTH / 2),
    total = 0,
    highlightStep = 1,
    icon = love.graphics.newImage("assets/images/lanea.png")
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Lane:seen(id)
  return fun.any(function(t) return t.id == id end, self.items)
end

function Lane:progress(h, speed)
  if self.highlightStep > 1 then
    self.highlightStep = self.highlightStep + HIGHLIGHT_STEP
  end

  if self.highlightStep > #HIGHLIGHT_COLORS then
    self.highlightStep = 1
  end

  Approachable.progress(self, h, speed)
end

function Lane:add(tap)
  self.total = self.total + 1
  table.insert(self.items, {y=0, x=self.x, z=TAP_Z, id=tap.id, kind=tap.kind, nth=self.total})
end

function Lane:hit()
  if self.highlightStep == 1 then
    self.highlightStep = HIGHLIGHT_STEP + 1
  else
    self.highlightStep = #HIGHLIGHT_COLORS / 2
  end
end

function Lane:render(w, h)
  local r, g, b = unpack(HIGHLIGHT_COLORS[math.floor(self.highlightStep)])

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

  withColour(r, g, b, 255, function()
    love.graphics.rectangle("fill", self.x - 20, h - 49, 40, 28)
  end)

  love.graphics.draw(self.icon, self.x - 70, h - 50)
end
