require "tweening.transition"
require "gui.layout"

results = Transition:new()

function results:enter(_, carry)
  self.score = carry.score
  self.bestScore = carry.bestScore
  self.percentage = round((self.score / self.bestScore) * 100)
  self.layout = Layout:new("Results...", "menu_bg_church.png")
end

function results:keypressed(_)
  self:transitionTo(menu)
end

function results:draw()
  local score = love.graphics.newText(fonts.ridiculous, self.percentage .. "%")
  local rank = love.graphics.newText(fonts.big, self:getRank())

  scaleGraphics()
  self.layout:render()

  withColour(0.66, 0.66, 0.66, 1, function()
    drawInCenter(score, 0, -(score:getHeight() / 2) - 10)
    drawInCenter(rank, 0, rank:getHeight())
  end)

  self:drawTween()
end

function results:getRank()
  local ranks = fun.filter(function (r) return r[1] > self.percentage end, RANKS)

  return fun.nth(1, ranks)[2]
end
