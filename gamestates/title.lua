require "gamestates.menu"
require "tweening.transition"
require "gui.droplet"
require "gui.lightning"

title = Transition:new()

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
  self.music = love.audio.newSource("assets/audio/intro.ogg", "stream")
  self.rain = love.audio.newSource("assets/audio/rain.ogg", "stream")
  self.lightning = Lightning:new()
  self.droplets = {}
  self.titleOpacity = 0.0

  self.rain:setVolume(0.1)
  self.music:play()
  self.rain:play()
end

function title:draw()
  scaleGraphics()

  withoutScale(function()
    withColour(0.18, 0.18, 0.18, 1, function()
      for _, d in pairs(self.droplets) do
        d:render()
      end
    end)

    if self.lightning:running() then
      self.lightning:render()
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

  if self.lightning:running() then
    self.lightning:progress()

  -- Start lightning as soon as fade-in completes.
  elseif self.titleOpacity >= 1 and not self.lightning:completed() then
    self.lightning:start()
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
