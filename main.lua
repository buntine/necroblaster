fun = require "lib.fun"
Gamestate = require "lib.hump.gamestate"
require "constants"
require "song"
require "tapSet"
require "tapMap"
require "laneways"
require "railing"
require "score"
require "selector"
require "difficulty"
require "progress"
require "result"

local title = {}
local menu = {}
local play = {}
local results = {}

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(title)
end

function title:enter()
  self.title = love.graphics.newImage("assets/images/title.png")
end

function title:draw()
  love.graphics.draw(self.title, 0, 0)
end

function title:keypressed(_)
  Gamestate.switch(menu)
end

function menu:enter()
  local songs = fun.totable(love.filesystem.getDirectoryItems(DATA_PATH))

  self.selector = Selector:new(songs)
  self.difficulty = Difficulty:new()
end

function menu:draw()
  self.selector:render()
  self.difficulty:render()
end

function menu:update()
  self.selector:progress()
end

function results:enter(_, score, bestScore)
  self.result = Result:new(score, bestScore)
end

function results:keypressed(_)
  Gamestate.switch(menu)
end

function results:draw()
  self.result:render()
end

function menu:keypressed(key)
  if key == BTN_A then
    self.selector:previous()
  elseif key == BTN_B then
    self.selector:next()
  elseif key == BTN_C then
    self.difficulty:next()
  elseif key == BTN_D then
    local songid = self.selector:song().songid
    local speed = self.difficulty:speed()

    Gamestate.switch(play, songid, speed)
  end
end

function menu:leave()
  self.selector:reset()
end

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
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()

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
