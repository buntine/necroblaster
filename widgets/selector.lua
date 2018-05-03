Selector = {
  body = {},
  title = "",
  arrow = love.graphics.newImage("assets/images/bone_arrow.png"),
}

function Selector:new(body, title)
  local o = {
    body = body,
    title = title,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Selector:render()
  withoutScale(function()
    withColour(0.47, 0.12, 0.12, 1, function()
      withFont("medium", function()
        love.graphics.print(self.title, 25, ACTUAL_HEIGHT - 50)
      end)
    end)

    love.graphics.draw(self.arrow, 25, 390)
    love.graphics.draw(self.arrow, ACTUAL_WIDTH - 325, 390, math.rad(180), 1, -1, 300, 0)
  end)

  self.body:render()
end

function Selector:progress()
  -- Arrow quads...

  self.body:progress()
end

function Selector:keypressed(key)
  if key == BTN_A then
    self.body:previous()
  elseif key == BTN_B then
    self.body:next()
  end
end

function Selector:reset()
  if self.body.reset then
    self.body:reset()
  end
end
