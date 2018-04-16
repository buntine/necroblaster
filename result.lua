Result = {
  score = 0,
  bestScore = 0,
  percentage = 0
}

function Result:new(s, bs)
  local p = round((s / bs) * 100)
  local o = {score = s, bestScore = bs, percentage = p}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Result:render(w, h)
  withColour(220, 29, 29, 255, function()
    local score = love.graphics.newText(fonts.huge, self.percentage .. "%")
    local x, y = unpack(center(w, h, score:getWidth(), score:getHeight(), 0, -100))

    love.graphics.draw(score, x, y)
  end)

  withColour(200, 200, 200, 255, function()
    local rank = love.graphics.newText(fonts.big, self:getRank())
    local x, y = unpack(center(w, h, rank:getWidth(), rank:getHeight(), 0, 50))

    love.graphics.draw(rank, x, y)
  end)
end

function Result:getRank()
  local ranks = fun.filter(function (r) return r[1] > self.percentage end, RANKS)

  return fun.nth(1, ranks)[2]
end
