require "mapping.song"
require "mapping.tapSet"
require "mapping.frameset"
require "gui.laneways"
require "gui.powerBar"
require "gui.progress"
require "gui.background"
require "gamestates.results"
require "tweening.transition"

play = Transition()

function play:enter(_, carry)
  self.bg = love.graphics.newImage("assets/images/background.png")

  self.song = Song(carry.songid)
  self.frameset = Frameset(carry.songid, carry.speed, carry.dominant)
  self.tapSet = TapSet()
  self.laneways = Laneways()
  self.powerBar = PowerBar()
  self.progress = Progress(self.song:length())
  self.background = Background(carry.songid)

  self.song:play()
  self.song:seek(145)
  self.frameset:generate()
end

function play:draw()
  local frame = self.frameset.framePointer

  scaleGraphics()

  self.background:render()
  love.graphics.draw(self.bg)
  self.laneways:render()
  self.powerBar:render()
  self.progress:render(self.song:tell())

  self:drawTween()
end

function play:update()
  local pos = self.song:tell()
  local score = self.tapSet:score()

  if self.song:finished() then
    self:transitionTo(results, {
      score = score,
      accuracy = self.tapSet:accuracy(),
      bestScore = self.frameset:bestScore(),
    })
  end

  if not self.frameset:isEmptyFrame() then
    self.powerBar:progress(score)
  end

  self.frameset:progress(pos)
  self:showFutureTaps(pos)
  self.laneways:progress(self.frameset.speed)
  self.background:progress()
  self:updateTween()
end

function play:keypressed(key, sc, ...)
  local lane = self.laneways:laneFor(key)

  if key == 'escape' then
    self:transitionTo(menu)
  end

  if not lane then
    return
  end

  lane:highlight()

  for _, tap in ipairs(self.frameset:currentTaps()) do
    if key == tap.char and not self.tapSet:seen(tap) then
      self.tapSet:add(tap)
      lane:hit(tap)
    end
  end
end

function play:showFutureTaps(pos)
  for _, tap in ipairs(self.frameset:futureTaps(pos)) do
    if tap.renderable and not self.laneways:seen(tap) then
      self.laneways:add(tap)
    end
  end
end

function play:leave()
  self.song:stop()
end
