Progress = {
  total = 0,
}

function Progress:new(total)
  local o = {total = total}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Progress:render(pos)
  withColour(0, 0, 0, 1, function()
    love.graphics.rectangle("fill", 0, 0, DESIRED_WIDTH, PROGRESS_HEIGHT)
  end)

  withColour(0.47, 0.12, 0.12, 1, function()
    local width = DESIRED_WIDTH * (pos / self.total)
    love.graphics.rectangle("fill", 0, 0, width, PROGRESS_HEIGHT)
  end)
end
