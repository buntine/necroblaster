-- A simple flash effect to simulate lightning.
--
-- Currently fairly not configurable by the called but easy to extend
-- if multiple strikes or differing animations are required.

Lightning = {
  flashes = {
    {opacity = 0.76, speed = 0.07},
    {opacity = 0.79, speed = 0.005},
  },
  opacity = 0,
  index = 0
}

function Lightning:new()
  local o = {
    thunder = love.audio.newSource("assets/audio/thunder.ogg", "stream"),
  }

  setmetatable(o, self)
  self.__index = self

  o.thunder:setVolume(0.1)

  return o
end

function Lightning:render()
  withColour(1, 1, 1, self.opacity, function()
    love.graphics.rectangle("fill", 0, 0, ACTUAL_WIDTH, ACTUAL_HEIGHT)
  end)
end

function Lightning:progress()
  local flash = self:currentFlash()

  if self.opacity <= 0 then
    self:nextFlash()
  else
    self.opacity = self.opacity - flash.speed
  end
end

function Lightning:currentFlash()
  if self:running() then
    return self.flashes[self.index]
  end
end

function Lightning:nextFlash()
  self.index = self.index + 1

  local flash = self:currentFlash()

  if flash then
    self.opacity = flash.opacity
  end
end

function Lightning:completed()
  return self.index > #self.flashes
end

function Lightning:running()
  return self.index > 0 and self.index <= #self.flashes
end

function Lightning:start()
  self:nextFlash()
  self.thunder:play()
end

function Lightning:stop()
  self.opacity = 0
  self.index = 0
  self.thunder:stop()
end
