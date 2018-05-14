-- A visible tap that is approaching the bottom of the screen.

require "gui.approachable"

VisibleTap = Approachable:new()

function VisibleTap:new(tap, x)
  local o = {
    z = TAP_Z,
    x = x,
    y = 0,
    tap = tap,
    -- Skip rendering of every second blastbeat (visually more appealing).
    renderable = not (tap.kind == "blastbeat" and tap.nth % 2 == 0)
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function VisibleTap:render()
  local tap = self.tap
  local x, scaling = unpack(self:project())
  local img = TAP_IMAGES[tap.kind]
  local radius = TAP_RADIUS[tap.kind]

  if tap.kind == "doublekick" then
    local offset = DOUBLEKICK_SPACING * scaling
    local position = (self.tap.nth % 2 == 0 and -offset or offset)

    love.graphics.draw(img, x + position - (radius * scaling), self.y, 0, scaling)
  else
    love.graphics.draw(img, x - (radius * scaling), self.y, 0, scaling)
  end
end

function VisibleTap:done()
  return self.y > DESIRED_HEIGHT - APPROACH_MAX_OFFSET
end
