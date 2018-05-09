require "tweening.transition"

results = Transition:new()

function results:enter(_, carry)
  self.score = carry.score
  self.bestScore = carry.bestScore
  self.percentage = round((self.score / self.bestScore) * 100)
end

function results:keypressed(_)
  self:transitionTo(menu)
end

function results:draw()
  scaleGraphics()

  withColour(0.86, 0.11, 0.11, 1, function()
    local score = love.graphics.newText(fonts.huge, self.percentage .. "%")
    local x, y = unpack(center(DESIRED_WIDTH, DESIRED_HEIGHT, score:getWidth(), score:getHeight(), 0, -100))

    love.graphics.draw(score, x, y)
  end)

  withColour(0.78, 0.78, 0.78, 1, function()
    local rank = love.graphics.newText(fonts.big, self:getRank())
    local x, y = unpack(center(DESIRED_WIDTH, DESIRED_HEIGHT, rank:getWidth(), rank:getHeight(), 0, 50))

    love.graphics.draw(rank, x, y)
  end)

  self:drawTween()
end

function results:getRank()
  local ranks = fun.filter(function (r) return r[1] > self.percentage end, RANKS)

  return fun.nth(1, ranks)[2]
end
