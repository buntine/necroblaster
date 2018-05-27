-- A progress bar that runs across the top of the screen to indicate progress
-- through the playing song.

Progress = Class{
  init = function(self, total)
    self.total = total
  end,
  total = 0,
}

function Progress:render(pos)
  withoutScale(function()
    withColour(0, 0, 0, 1, function()
      love.graphics.rectangle("fill", 0, 0, ACTUAL_WIDTH, PROGRESS_HEIGHT)
    end)

    withColour(0.47, 0.12, 0.12, 1, function()
      local width = ACTUAL_WIDTH * (pos / self.total)
      love.graphics.rectangle("fill", 0, 0, width, PROGRESS_HEIGHT)
    end)
  end)
end
