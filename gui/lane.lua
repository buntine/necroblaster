-- Represents a single laneway.
-- 
-- A lane maintains a set of upcoming/renderable taps and a graphical display
-- when a tap is successfully hit.

require "gui.approachable"
require "gui.reverberation"

Lane = Approachable:new()

function Lane:new(nth)
  local o = {
    items = {},
    nth = nth,
    x = LANE_OFFSET + (LANE_WIDTH * nth) + (LANE_WIDTH / 2),
    total = 0,
    highlightStep = 1,
    reverbs = {},
    icon = love.graphics.newImage("assets/images/lane" .. nth .. ".png"),
    tap = love.graphics.newImage("assets/images/tap.png"),
    doublekick = love.graphics.newImage("assets/images/doublekick.png"),
    blastbeat = love.graphics.newImage("assets/images/blastbeat.png")
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

  for i, r in ipairs(self.reverbs) do
    r:progress()

    if r:done() then
      table.remove(self.reverbs, i)
    end
  end

  Approachable.progress(self, h, speed)
end

function Lane:add(tap)
  self.total = self.total + 1
  table.insert(self.items, {y=0, x=self.x, z=TAP_Z, id=tap.id, kind=tap.kind, nth=self.total})
end

function Lane:hit(tap)
  table.insert(self.reverbs, Reverberation:new(tap.kind, self.x - LANE_OFFSET))
  table.insert(self.reverbs, Reverberation:new(tap.kind, self.x + LANE_OFFSET))

  if self.highlightStep == 1 then
    self.highlightStep = HIGHLIGHT_STEP + 1
  else
    -- We are already mid-highlight, so just prolong the current one.
    self.highlightStep = #HIGHLIGHT_COLORS / 2
  end
end

function Lane:render(w, h)
  local r, g, b = unpack(HIGHLIGHT_COLORS[math.floor(self.highlightStep)])

  self:project(w, h, function(t, x, scaling)
    if t.kind == "tap" then
      love.graphics.draw(self.tap, x - (TAP_RADIUS * scaling), t.y, 0, scaling)
    elseif t.kind == "blastbeat" then
      -- Skip rendering of every second blastbeat (visually more appealing).
      if t.nth % 2 == 0 then
        return
      end

      love.graphics.draw(self.blastbeat, x - (DOUBLEKICK_RADIUS * scaling), t.y, 0, scaling)
    elseif t.kind == "doublekick" then
      local offset = DOUBLEKICK_SPACING * scaling
      local position = (t.nth % 2 == 0 and -offset or offset)

      love.graphics.draw(self.doublekick, x + position - (DOUBLEKICK_RADIUS * scaling), t.y, 0, scaling)
    end
  end)

  -- Reverberations from hits.
  for _, r in pairs(self.reverbs) do
    local img = self[r.kind]

    withColour(_, _, _, r.opacity, function()
      love.graphics.draw(img, r.x, r.y, 0, (r.kind == "tap" and 0.7 or 1))
    end)
  end

  -- Background of "tap plate" for highlights. Some dank hardcoding. :/
  withColour(r, g, b, 1, function()
    love.graphics.rectangle("fill", self.x - 30, h - 38, 60, 28)
  end)

  love.graphics.draw(self.icon, self.x - 70 - (self.nth * 3), h - 41)
end
