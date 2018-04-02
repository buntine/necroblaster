require "helpers"

Railings = {
  rails = {}
}

function Railings:new()
  local o = {
    rails = {}
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Railings:progress(h, speed)
  for i=#self.rails, 1, -1 do
    local r = self.rails[i]

    -- Super simple projection from Z to Y.
    r.z = r.z - ((TAP_Z - 1) / speed)
    r.y = (h / r.z) - (h / TAP_Z)

    if r.y > h then
      table.remove(self.rails, i)
    end
  end
end

function Railings:add()
  table.insert(self.rails, {y=0, z=TAP_Z})
end

function Railings:render(w, h)
  local xVanishingPoint = w / 2

  for _, bottomx in ipairs(RAILING_POSITIONS) do
    local a = (h - VANISHING_POINT_Y) / (bottomx - xVanishingPoint)
    local b = VANISHING_POINT_Y - (a * xVanishingPoint)

    for _, r in ipairs(self.rails) do
      local x = (r.y - b) / a
      local normaliser = ((r.y - VANISHING_POINT_Y) / (h - VANISHING_POINT_Y))
      local radius = RAILING_WIDTH * normaliser

      withColour(159, 29, 29, 255, function ()
        love.graphics.rectangle("fill", x, r.y, radius, radius)
      end)
    end
  end
end
