-- A visible tap that is approaching the bottom of the screen.

require "gui.approachable"

VisibleTap = Approachable:new()

function VisibleTap:new(tap, x, nth)
  local o = {
    z = TAP_Z,
    x = x,
    y = 0,
    tap = tap,
    nth = nth,
    -- Skip rendering of every second blastbeat (visually more appealing).
    renderable = not (tap.kind == "blastbeat" and nth % 2 == 0)
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function VisibleTap:render(w, h)
  local tap = self.tap
  local x, scaling = unpack(self:project(w, h))
  local img = TAP_IMAGES[tap.kind]
  local radius = TAP_RADIUS[tap.kind]

  if tap.kind == "doublekick" then
    local offset = DOUBLEKICK_SPACING * scaling
    local position = (self.nth % 2 == 0 and -offset or offset)

    love.graphics.draw(img, x + position - (radius * scaling), self.y, 0, scaling)
  else
    love.graphics.draw(img, x - (radius * scaling), self.y, 0, scaling)
  end
end

function VisibleTap:done(h)
  return self.y > h - APPROACH_MAX_OFFSET
end
