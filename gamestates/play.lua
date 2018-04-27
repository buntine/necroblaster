require "mapping.song"
require "mapping.tapSet"
require "mapping.songFrameset"
require "gui.laneways"
require "gui.railing"
require "gui.score"
require "gui.progress"
require "gamestates.results"

play = {}

function play:enter(_, carry)
  self.bg = love.graphics.newImage("assets/images/background.png")

  self.song = Song:new(carry.songid)
  self.songFrameset = SongFrameset:new(carry.songid, carry.speed, carry.dominant)
  self.tapSet = TapSet:new()
  self.laneways = LaneWays:new()
  self.railing = Railing:new()
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

  for _, l in pairs(self.laneways.lanes) do
    l:render(w, h)
  end

  self.score:render(self.tapSet.score)
  self.railing:render(w, h)
  self.progress:render(self.song:tell(), w)
end

function play:update()
  local h = love.graphics.getHeight()
  local pos = self.song:tell()

  if self.song:finished() then
    Gamestate.switch(results, self.tapSet.score, self.songFrameset.bestScore)
  end

  self.songFrameset:progress(pos)

  for _, tap in ipairs(self.songFrameset:futureTaps(pos)) do
    if tap and not self.laneways:seen(tap) then
      self.laneways:add(tap)
    end
  end

  if pos - self.railing.lastRail >= RAILING_FREQUENCY then
    self.railing:add(pos)
  end

  self.laneways:progress(h, self.songFrameset.speed)
  self.railing:progress(h, self.songFrameset.speed)
  self.score:progress(self.tapSet.score, self.songFrameset.bestScore)
end

function play:keypressed(key, sc, ...)
  for _, tap in ipairs(self.songFrameset:currentTaps()) do
    if tap and key == tap.char and not self.tapSet:seen(tap.id) then
      self.tapSet:add(tap)
      self.laneways.lanes[tap.char]:hit(tap)
    end
  end
end
