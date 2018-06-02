require "tweening.transition"
require "gui.layout"

results = Transition()

function results:enter(_, carry)
  local performance = round((carry.score / carry.bestScore) * 100)

  self.layout = Layout("Results...", "menu_bg_church.png")
  self.score = love.graphics.newText(fonts.ridiculous, performance .. "%")
  self.score_text = love.graphics.newText(fonts.big, "Performance")
  self.accuracy_text = love.graphics.newText(fonts.big, "Accuracy")
  self.accuracy = love.graphics.newText(fonts.ridiculous, carry.accuracy .. "%")
  self.rank = love.graphics.newText(fonts.ridiculous, self:getRank(performance))
end

function results:keypressed(_)
  self:transitionTo(menu)
end

function results:draw()
  scaleGraphics()
  self.layout:render()

  local quarter = ACTUAL_WIDTH / 4

  withColour(0.66, 0.66, 0.66, 1, function()
    drawInCenter(self.score, -quarter, -self.rank:getHeight())
    drawInCenter(self.accuracy, quarter, -self.rank:getHeight())
    drawInCenter(self.rank, 0, self.rank:getHeight())
  end)

  withColour(0.44, 0.44, 0.44, 1, function()
    local heading_offset = -self.rank:getHeight() + (self.score:getHeight() / 2) + 16

    drawInCenter(self.score_text, -quarter, heading_offset)
    drawInCenter(self.accuracy_text, quarter, heading_offset)
  end)

  self:drawTween()
end

function results:getRank(performance)
  local ranks = fun.filter(function (r) return r[1] > performance end, RANKS)

  return fun.nth(1, ranks)[2]
end
