require "approachable"
require "helpers"

Railing = Approachable:new()

function Railing:new()
  local o = {
    items = {}
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Railing:add()
  for _, x in ipairs(RAILING_POSITIONS) do
    table.insert(self.items, {x=x, y=0, z=TAP_Z})
  end
end

function Railing:render(w, h)
  self:project(w, h, function(t, x, scaling)
    withColour(159, 29, 29, 255, function ()
      local radius = RAILING_WIDTH * scaling

      love.graphics.rectangle("fill", x, t.y, radius, radius)
    end)
  end)
end
