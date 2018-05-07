-- Represents a single laneway.
-- 
-- A lane maintains a set of upcoming/renderable taps and a graphical display
-- when a tap is successfully hit.

require "gui.reverberation"
require "gui.visibleTap"

Lane = {}

function Lane:new(nth)
  local o = {
    visibleTaps = {},
    nth = nth,
    x = centerOfLane(nth),
    total = 0,
    highlightStep = 1,
    reverbs = {},
    icon = love.graphics.newImage("assets/images/lane" .. nth .. ".png"),
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Lane:seen(tap)
  return fun.any(function(t) return t.tap.id == tap.id end, self.visibleTaps)
end

function Lane:progress(speed)
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

  for i, tap in ipairs(self.visibleTaps) do
    tap:progress(speed)

    if tap:done() then
      table.remove(self.visibleTaps, i)
    end
  end
end

function Lane:add(tap)
  self.total = self.total + 1
  table.insert(self.visibleTaps, VisibleTap:new(tap, self.x, self.total))
end

function Lane:highlight()
  if self.highlightStep == 1 then
    self.highlightStep = HIGHLIGHT_STEP + 1
  else
    -- We are already mid-highlight, so just prolong the current one.
    self.highlightStep = #HIGHLIGHT_COLORS / 2
  end
end

function Lane:hit(tap)
  table.insert(self.reverbs, Reverberation:new(tap, self.x))
end

function Lane:render()
  local r, g, b = unpack(HIGHLIGHT_COLORS[math.floor(self.highlightStep)])

  for _, tap in ipairs(self.visibleTaps) do
    if tap.renderable then
      tap:render()
    end
  end

  -- Reverberations from hits.
  for _, reverb in ipairs(self.reverbs) do
    reverb:render()
  end

  -- Background of "tap plate" for highlights. Some dank hardcoding. :/
  withColour(r, g, b, 1, function()
    love.graphics.rectangle("fill", self.x - 30, DESIRED_HEIGHT - 38, 60, 28)
  end)

  love.graphics.draw(self.icon, self.x - 70 - (self.nth * 3), DESIRED_HEIGHT - PLATE_OFFSET)
end
