require "tweening.transition"
require "gui.layout"

results = Transition()

function results:enter(_, carry)
  local percentage = round((carry.score / carry.bestScore) * 100)

  self.layout = Layout("Results...", "menu_bg_church.png")
  self.score = love.graphics.newText(fonts.ridiculous, percentage .. "%")
  self.rank = love.graphics.newText(fonts.big, self:getRank(percentage))
end

function results:keypressed(_)
  self:transitionTo(menu)
end

function results:draw()
  scaleGraphics()
  self.layout:render()

  withColour(0.66, 0.66, 0.66, 1, function()
    drawInCenter(self.score, 0, -(self.score:getHeight() / 2) - 10)
    drawInCenter(self.rank, 0, self.rank:getHeight())
  end)

  self:drawTween()
end

function results:getRank(percentage)
  local ranks = fun.filter(function (r) return r[1] > percentage end, RANKS)

  return fun.nth(1, ranks)[2]
end
