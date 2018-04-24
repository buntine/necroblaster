-- Represents a single laneway.
-- 
-- A lane maintains a set of upcoming/renderable taps and a graphical display
-- when a tap is successfully hit.

require "gui.approachable"

Lane = Approachable:new()

function Lane:new(nth)
  local o = {
    items = {},
    nth = nth,
    x = LANE_OFFSET + (LANE_WIDTH * nth) + (LANE_WIDTH / 2),
    total = 0,
    highlightStep = 1,
    icon = love.graphics.newImage("assets/images/lane" .. nth .. ".png")
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

      withColour(0.93, 0.87, 0.87, 1, function()
        love.graphics.circle("fill", x, t.y, radius)
      end)
    elseif t.kind == "blastbeat" then
      -- Skip rendering of every second blastbeat (visually more appealing).
      if t.nth % 2 == 0 then
        return
      end

      local radius = DOUBLEKICK_RADIUS * scaling

      withColour(0.14, 0.34, 0.93, 1, function()
        love.graphics.circle("fill", x, t.y, radius)
      end)
    elseif t.kind == "doublekick" then
      local radius = DOUBLEKICK_RADIUS * scaling
      local offset = DOUBLEKICK_SPACING * scaling

      withColour(0.60, 0.93, 0.14, 1, function()
        love.graphics.circle("fill", (t.nth % 2 == 0 and x - offset or x + offset), t.y, radius)
      end)
    end
  end)

  withColour(r, g, b, 1, function()
    love.graphics.rectangle("fill", self.x - 20, h - 49, 40, 28)
  end)

  love.graphics.draw(self.icon, self.x - 76.5, h - 50)
end
