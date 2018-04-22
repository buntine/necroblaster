require "song"
require "tapSet"
require "tapMap"
require "laneways"
require "railing"
require "score"
require "progress"
require "gamestates.progress"

play = {}

function play:enter(_, songid, speed)
  self.bg = love.graphics.newImage("assets/images/background.png")
  self.castle = love.graphics.newImage("assets/images/castle.png")

  self.song = Song:new(songid)
  self.tapMap = TapMap:new(songid, speed)
  self.tapSet = TapSet:new()
  self.laneways = LaneWays:new()
  self.railing = Railing:new()
  self.score = Score:new()
  self.progress = Progress:new(self.song:length())

  self.song:play()
  self.tapMap:generate()
end

function play:draw()
  local frame = self.tapMap.framePointer
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  love.graphics.draw(self.bg, 0, 0)

  for _, l in pairs(self.laneways.lanes) do
    l:render(w, h)
  end

  self.score:render(self.tapSet.score)
  self.railing:render(w, h)
  self.progress:render(self.song:tell(), w)

  love.graphics.draw(self.castle, 0, PROGRESS_HEIGHT)
end

function play:update()
  local h = love.graphics.getHeight()
  local pos = self.song:tell()

  if self.song:finished() then
    Gamestate.switch(results, self.tapSet.score, self.tapMap.bestScore)
  end

  self.tapMap:progress(pos)

  for _, tap in ipairs(self.tapMap:futureTaps(pos)) do
    if tap and not self.laneways:seen(tap) then
      self.laneways:add(tap)
    end
  end

  if pos - self.railing.lastRail >= RAILING_FREQUENCY then
    self.railing:add(pos)
  end

  self.laneways:progress(h, self.tapMap.speed)
  self.railing:progress(h, self.tapMap.speed)
  self.score:progress(self.tapSet.score, self.tapMap.bestScore)
end

function play:keypressed(key, sc, ...)
  for _, tap in ipairs(self.tapMap:currentTaps()) do
    if tap and key == tap.char and not self.tapSet:seen(tap.id) then
      self.tapSet:add(tap)
      self.laneways.lanes[tap.char]:hit()
    end
  end
end
