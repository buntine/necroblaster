require "mapping.song"
require "mapping.tapSet"
require "mapping.songFrameset"
require "gui.laneways"
require "gui.score"
require "gui.progress"
require "gamestates.results"
require "tweening.transition"

play = Transition:new()

function play:enter(_, carry)
  self.bg = love.graphics.newImage("assets/images/background.png")

  self.song = Song:new(carry.songid)
  self.songFrameset = SongFrameset:new(carry.songid, carry.speed, carry.dominant)
  self.tapSet = TapSet:new()
  self.laneways = Laneways:new()
  self.score = Score:new()
  self.progress = Progress:new(self.song:length())

  self.song:play()
  self.songFrameset:generate()
end

function play:draw()
  local frame = self.songFrameset.framePointer
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  love.graphics.draw(self.bg, 0, 0)

  self.laneways:render(w, h)
  self.progress:render(self.song:tell(), w)
  self.score:render()
  self:drawTween()
end

function play:update()
  local h = love.graphics.getHeight()
  local pos = self.song:tell()
  local score = self.tapSet.score

  if self.song:finished() then
    self:transitionTo(results, {score = score, bestScore = self.songFrameset.bestScore})
  end

  self.songFrameset:progress(pos)

  for _, tap in ipairs(self.songFrameset:futureTaps(pos)) do
    if tap and not self.laneways:seen(tap) then
      self.laneways:add(tap)
    end
  end

  self.laneways:progress(h, self.songFrameset.speed)
  self.score:progress(score)
  self:updateTween()
end

function play:keypressed(key, sc, ...)
  for _, tap in ipairs(self.songFrameset:currentTaps()) do
    if tap and key == tap.char and not self.tapSet:seen(tap) then
      local lane = self.laneways:laneFor(tap)

      self.tapSet:add(tap)
      lane:hit(tap)
    end
  end
end
