fun = require "lib.fun"
Gamestate = require "lib.hump.gamestate"
require "constants"
require "song"
require "tapSet"
require "tapMap"
require "laneways"
require "railing"
require "score"

local play = {}
local menu = {}

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function menu:enter()
  -- Grab each songid (dirs in ./data/*).
end

function menu:draw()
  -- Logo
  -- Songs with back/forth arrows
  -- Start button
end

function play:enter(_, songid)
  bg = love.graphics.newImage("assets/images/background.png")
  castle = love.graphics.newImage("assets/images/castle.png")

  song = Song:new(songid)
  tapMap = TapMap:new(songid)
  tapSet = TapSet:new()
  laneways = LaneWays:new()
  railing = Railing:new()
  score = Score:new()

  song:play()
  tapMap:generate()
end

function play:draw()
  local frame = tapMap.framePointer
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()

  love.graphics.draw(bg, 0, 0)

  for _, l in pairs(laneways.lanes) do
    l:render(w, h)
  end

  score:render(tapSet.score)
  railing:render(w, h)

  love.graphics.draw(castle, 0, 0)
end

function play:update()
  local h = love.graphics.getHeight()
  local pos = song:tell()

  tapMap:progress(pos)

  for _, tap in ipairs(tapMap:futureTaps(pos)) do
    if tap and not laneways:seen(tap) then
      laneways:add(tap)
    end
  end

  if pos - railing.lastRail >= RAILING_FREQUENCY then
    railing:add(pos)
  end

  laneways:progress(h, tapMap.speed)
  railing:progress(h, tapMap.speed)
  score:progress(tapSet.score, tapMap.bestScore)
end

function play:keypressed(key, sc, ...)
  for _, tap in ipairs(tapMap:currentTaps()) do
    if tap and key == tap.char and not tapSet:seen(tap.id) then
      tapSet:add(tap)
      laneways.lanes[tap.char]:hit()
    end
  end
end
