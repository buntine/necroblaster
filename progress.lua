Progress = {
  total = 0,
}

function Progress:new(total)
  local o = {total = total}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Progress:render(pos, w)
  withColour(0, 0, 0, 255, function()
    love.graphics.rectangle("fill", 0, 0, w, PROGRESS_HEIGHT)
  end)

  withColour(120, 30, 30, 255, function()
    local width = w * (pos / self.total)
    love.graphics.rectangle("fill", 0, 0, width, PROGRESS_HEIGHT)
  end)
end
