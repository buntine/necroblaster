-- A simple bump effect across the X axis.

Bump = {
  x = 0,
  initialX = 0,
  distance = 0,
}

function Bump:new(x, distance)
  local o = {
    x = x,
    initialX = x,
    distance = distance,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Bump:progress()
  -- throw away
  --if self.click == "prev" then
 --   if self.opacity > 4 then
 --     self.opacity = self.opacity - 3.5
 --   else
 --     self.click = "prevup"
 --   end
 -- elseif self.click == "prevup" then
 --   if self.opacity < 25 then
 --     self.opacity = self.opacity + 3.5
 --   else
 --     self.click = nil
 --   end
 -- end
end

function Bump:start()
end
