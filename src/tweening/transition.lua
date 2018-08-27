-- The fade in/out transition between each gamestate.

local states = {down = "down", up = "up", neutral = "neutral"}

Transition = Class{
  init = function(self)
    self.carry = {}
  end,
  transition = states.down,
  opacity = 1,
  nextGameState = nil,
}

function Transition:draw()
  self:drawTween()
end

function Transition:update()
  self:updateTween()
end


function Transition:drawTween()
  if self.transition then
    withoutScale(function()
      withColour(0, 0, 0, self.opacity, function()
        love.graphics.rectangle("fill", 0, 0, ACTUAL_WIDTH, ACTUAL_HEIGHT)
      end)
    end)
  end
end

function Transition:updateTween()
  if self.transition == states.up then
    if self.opacity >= 1 then
      self.transition = states.down
      return Gamestate.switch(self.nextGameState, self.carry)
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
