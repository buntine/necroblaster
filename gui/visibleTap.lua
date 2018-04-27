require "gui.approachable"

VisibleTap = Approachable:new()

function VisibleTap:new(tap, x, nth)
  local o = {
    z = TAP_Z,
    x = x,
    y = 0,
    tap = tap,
    nth = nth,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function VisibleTap:render(w, h)
  local tap = self.tap
  local x, scaling = unpack(self:project(w, h))

  if tap.kind == "tap" then
    love.graphics.draw(TAP_IMG, x - (TAP_RADIUS * scaling), self.y, 0, scaling)
  elseif tap.kind == "blastbeat" then
    -- Skip rendering of every second blastbeat (visually more appealing).
    if self.nth % 2 == 0 then
      return
    end

    love.graphics.draw(BLASTBEAT_IMG, x - (DOUBLEKICK_RADIUS * scaling), self.y, 0, scaling)
  elseif tap.kind == "doublekick" then
    local offset = DOUBLEKICK_SPACING * scaling
    local position = (self.nth % 2 == 0 and -offset or offset)

    love.graphics.draw(DOUBLEKICK_IMG, x + position - (DOUBLEKICK_RADIUS * scaling), self.y, 0, scaling)
  end
end

function VisibleTap:done(h)
  return self.y > h - APPROACH_MAX_OFFSET
end
