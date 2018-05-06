require "gamestates.menu"
require "tweening.transition"
require "gui.droplet"

title = Transition:new()

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
  self.music = love.audio.newSource("assets/audio/intro.ogg", "stream")
  self.rain = love.audio.newSource("assets/audio/rain.ogg", "stream")
  self.thunder = love.audio.newSource("assets/audio/thunder.ogg", "stream")
  self.lightning = -1
  self.lightning1 = -1
  self.droplets = {}
  self.titleOpacity = 0.0

  self.music:play()
  self.rain:setVolume(0.1)
  self.rain:play()
  self.thunder:setVolume(0.1)
end

function title:draw()
  scaleGraphics()

  withoutScale(function()
    withColour(0.18, 0.18, 0.18, 1, function()
      for _, d in pairs(self.droplets) do
        d:render()
      end
    end)

    if self.lightning1 > 0 then
      withColour(1, 1, 1, self.lightning1, function()
        love.graphics.rectangle("fill", 0, 0, ACTUAL_WIDTH, ACTUAL_HEIGHT)
      end)
    end

    if self.lightning > 0 then
      withColour(1, 1, 1, self.lightning, function()
        love.graphics.rectangle("fill", 0, 0, ACTUAL_WIDTH, ACTUAL_HEIGHT)
      end)
    end
  end)

  withOpacity(self.titleOpacity, function()
    drawInCenter(self.title)
  end)

  self:drawTween()
end

function title:update()
  table.insert(self.droplets, Droplet:new())

  for i, d in ipairs(self.droplets) do
    d:progress()

    if d:done() then
      table.remove(self.droplets, i)
    end
  end

  if self.titleOpacity < 1 then
    self.titleOpacity = self.titleOpacity + 0.001
  end

  if self.lightning > 0 then
    self.lightning = self.lightning - 0.005
  end

  if self.lightning1 > 0 then
    self.thunder:play()
    self.lightning1 = self.lightning1 - 0.07
  end

  if self.titleOpacity > 0.97 and self.lightning1 == -1 then
    self.lightning1 = 0.76
  end

  if self.titleOpacity > 0.99 and self.lightning == -1 then
    self.lightning = 0.76
  end

  self:updateTween()
end

function title:keypressed(_)
  self:transitionTo(menu)
end

function title:leave()
  self.music:stop()
end
