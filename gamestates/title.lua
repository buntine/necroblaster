require "gamestates.menu"
require "tweening.transition"

title = Transition:new()

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
  self.music = love.audio.newSource("assets/audio/intro.ogg", "stream")
  self.rain = love.audio.newSource("assets/audio/rain.ogg", "stream")
  self.droplets = {}
  self.titleOpacity = 0.0

  self.music:play()
  self.rain:setVolume(0.1)
  self.rain:play()
end

function title:draw()
  scaleGraphics()

  withOpacity(self.titleOpacity, function()
    drawInCenter(self.title)
  end)

  withoutScale(function()
    withColour(0.18,0.18,0.18,1,function()
      for _, d in pairs(self.droplets) do
        love.graphics.line(d.x, d.y, d.x - 20, d.y + 20)
      end
    end)
  end)

  self:drawTween()
end

function title:update()
  table.insert(self.droplets, {x = math.random(10, ACTUAL_WIDTH * 1.8), y = 0})

  for i, d in ipairs(self.droplets) do
    d.x = d.x - math.random(10, 13)
    d.y = d.y + math.random(14, 17)
  
    if d.x < 0 or d.y < 0 then
      table.remove(self.droplets, i)
    end
  end

  if self.titleOpacity < 1 then
    self.titleOpacity = self.titleOpacity + 0.001
  end

  self:updateTween()
end

function title:keypressed(_)
  self:transitionTo(menu)
end

function title:leave()
  self.music:stop()
end

