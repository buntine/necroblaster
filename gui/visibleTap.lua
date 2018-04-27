require "gui.approachable"

VisibleTap = Approachable:new()

function VisibleTap:new(tap, x, nth)
  local o = {
    y = 0,
    z = TAP_Z,
    tap = tap,
    x = x,
    nth = nth,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function VisibleTap:render(w, h)
  local tap = self.tap

  self:project(w, h, function(x, scaling)
    if tap.kind == "tap" then
      love.graphics.draw(TAP_IMG, self.x - (TAP_RADIUS * scaling), tap.y, 0, scaling)
    elseif tap.kind == "blastbeat" then
      -- Skip rendering of every second blastbeat (visually more appealing).
      if self.nth % 2 == 0 then
        return
      end

      love.graphics.draw(BLASTBEAT_IMG, self.x - (DOUBLEKICK_RADIUS * scaling), tap.y, 0, scaling)
    elseif tap.kind == "doublekick" then
      local offset = DOUBLEKICK_SPACING * scaling
      local position = (self.nth % 2 == 0 and -offset or offset)

      love.graphics.draw(DOUBLEKICK_IMG, self.x + position - (DOUBLEKICK_RADIUS * scaling), tap.y, 0, scaling)
    end
  end)
end

function VisibleTap:done(h)
  return self.y > h - APPROACH_MAX_OFFSET
end
