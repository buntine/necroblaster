require "gamestates.menu"
require "tweening.transition"

title = Transition:new()

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
  self.music = love.audio.newSource("assets/audio/intro.ogg", "stream")
  self.rain = love.audio.newSource("assets/audio/rain.ogg", "stream")
  self.titleOpacity = 0.1

  self.music:play()
  self.rain:setVolume(0.1)
  self.rain:play()
end

function title:draw()
  scaleGraphics()

  withOpacity(self.titleOpacity, function()
    drawInCenter(self.title)
  end)

  self:drawTween()
end

function title:update()
  if self.titleOpacity < 1 then
    self.titleOpacity = self.titleOpacity + 0.002
  end

  self:updateTween()
end

function title:keypressed(_)
  self:transitionTo(menu)
end

function title:leave()
  self.music:stop()
end

