-- The fade in/out transition between each gamestate.

local states = {down = "down", up = "up", neutral = "neutral" }

Transition = {
  transition = states.down,
  opacity = 1,
  nextGameState = nil,
  carry = {},
}

function Transition:new(tap, x)
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Transition:draw()
  self:drawTween()
end

function Transition:update()
  self:updateTween()
end


function Transition:drawTween()
  if self.transition then
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    withColour(0, 0, 0, self.opacity, function()
      love.graphics.rectangle("fill", 0, 0, w, h)
    end)
  end
end

function Transition:updateTween()
  if self.transition == states.up then
    if self.opacity >= 1 then
      Gamestate.switch(self.nextGameState, self.carry)
    end

    self.opacity = self.opacity + TRANSITION_DELTA
  elseif self.transition == states.down then
    if self.opacity <= 0 then
      self.transition = states.neutral
    end

    self.opacity = self.opacity - TRANSITION_DELTA
  end
end

function Transition:transitionTo(gamestate, carry)
  self.nextGameState = gamestate
  self.carry = carry
  self.transition = states.up
end
