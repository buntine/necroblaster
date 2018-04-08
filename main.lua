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

local title = {}
local menu = {}
local play = {}

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

function title:keypressed(key)
  Gamestate.switch(menu)
end

function menu:enter()
  -- Grab each songid (dirs in ./data/*).
  self.selector = Selector:new(songs)
end

function menu:draw()
  self.selector:render()
  -- Songs with back/forth arrows
  -- Start button
end

function menu:update()
  self.selector:progress()
end

function menu:keypressed(key)
  if key == BTN_A then
    self.selector:previous()
  elseif key == BTN_B then
    self.selector:next()
  elseif key == BTN_C then
    -- Difficulty increment.
  else
    Gamestate.switch(play, self.selector.songid)
  end
end

function play:enter(_, songid)
  self.bg = love.graphics.newImage("assets/images/background.png")
  self.castle = love.graphics.newImage("assets/images/castle.png")

  self.song = Song:new(songid)
  self.tapMap = TapMap:new(songid)
  self.tapSet = TapSet:new()
  self.laneways = LaneWays:new()
  self.railing = Railing:new()
  self.score = Score:new()

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

  love.graphics.draw(self.castle, 0, 0)
end

function play:update()
  local h = love.graphics.getHeight()
  local pos = self.song:tell()

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
