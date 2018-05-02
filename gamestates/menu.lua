require "widgets.selector"
require "gamestates.difficulty"
require "tweening.transition"

menu = Transition:new()

function menu:enter()
  local songs = fun.totable(love.filesystem.getDirectoryItems(DATA_PATH))

  self.selector = Selector:new(songs)
end

function menu:draw()
  scaleGraphics()

  withoutScale(function()
    withColour(0.47, 0.12, 0.12, 1, function()
      withFont("medium", function()
        love.graphics.print("Choose your evil spell...", 25, 25)
      end)
    end)
  end)

  self.selector:render()
  self:drawTween()
end

function menu:update()
  self.selector:progress()
  self:updateTween()
end

function menu:keypressed(key)
  if key == BTN_A then
    self.selector:previous()
  elseif key == BTN_B then
    self.selector:next()
  elseif key == BTN_D then
    local carry = { songid = self.selector:song().songid }

    self:transitionTo(difficulty, carry)
  end
end

function menu:leave()
  self.selector:reset()
end
