results = {}

function results:enter(_, s, bs)

  self.score = s
  self.bestScore = bs
  self.percentage = round((s / bs) * 100)
end

function results:keypressed(_)
  Gamestate.switch(menu)
end

function results:draw()
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  withColour(0.86, 0.11, 0.11, 1, function()
    local score = love.graphics.newText(fonts.huge, self.percentage .. "%")
    local x, y = unpack(center(w, h, score:getWidth(), score:getHeight(), 0, -100))

    love.graphics.draw(score, x, y)
  end)

  withColour(0.78, 0.78, 0.78, 1, function()
    local rank = love.graphics.newText(fonts.big, self:getRank())
    local x, y = unpack(center(w, h, rank:getWidth(), rank:getHeight(), 0, 50))

    love.graphics.draw(rank, x, y)
  end)
end

function results:getRank()
  local ranks = fun.filter(function (r) return r[1] > self.percentage end, RANKS)

  return fun.nth(1, ranks)[2]
end
