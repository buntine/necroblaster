-- Represents a single laneway.
-- 
-- A lane maintains a set of upcoming/renderable taps and a graphical display
-- when a tap is successfully hit.

require "gui.reverberation"
require "gui.laneHighlight"
require "gui.visibleTap"

Lane = Class{
  init = function(self, nth)
    self.visibleTaps = {}
    self.nth = nth
    self.x = centerOfLane(nth)
    self.highlighter = LaneHighlight()
    self.reverbs = {}
    self.icon = love.graphics.newImage("assets/images/lane" .. nth .. ".png")
  end,
}

function Lane:seen(tap)
  return fun.any(function(t) return t.tap.id == tap.id end, self.visibleTaps)
end

function Lane:progress(speed)
  self.highlighter:progress()

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
  table.insert(self.visibleTaps, VisibleTap(tap, self.x))
end

function Lane:highlight()
  self.highlighter:start()
end

function Lane:hit(tap)
  table.insert(self.reverbs, Reverberation(tap, self.x))
end

function Lane:render()
  for _, tap in ipairs(self.visibleTaps) do
    if tap.renderable then
      tap:render()
    end
  end

  -- Reverberations from hits.
  for _, reverb in ipairs(self.reverbs) do
    reverb:render()
  end

  self.highlighter:render(self.x)
  love.graphics.draw(self.icon, self.x - 70 - (self.nth * 3), DESIRED_HEIGHT - PLATE_OFFSET)
end
