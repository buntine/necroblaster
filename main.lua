fun = require "lib/fun"
require "constants"
require "song"
require "tapSet"
require "laneways"
require "railings"
require "tapMap"

function love.load(a)
  bg = love.graphics.newImage("assets/images/background.png")

  song = Song:new("mh_ritual")
  tapMap = TapMap:new("mh_ritual")
  tapSet = TapSet:new()
  laneways = LaneWays:new()
  railings = Railings:new()

  song:play()
  tapMap:generate()
end

function love.draw()
  local frame = tapMap.framePointer
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()

  love.graphics.draw(bg, 0, 0)

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Frame: "..tostring(frame), 10, 40)
  love.graphics.print("Score: "..tostring(fun.foldl(function(acc, x) return acc + x.health end, 0, tapSet.taps)), 10, 70)

  for _, l in pairs(laneways.lanes) do
    l:render(w, h)
  end

  railings:render(w, h)
end

function love.update()
  local h = love.graphics.getHeight()
  local pos = song:tell()

  tapMap:progress(pos)

  for _, tap in ipairs(tapMap:futureTaps(pos)) do
    if tap and not laneways:seen(tap) then
      laneways:add(tap)
    end
  end

  if math.floor(pos * 1000) % 1000 == 0 then
    railings:add()
  end

  laneways:progress(h, tapMap.speed)
  railings:progress(h, tapMap.speed)
end

function love.keypressed(key, sc, ...)
  for _, tap in ipairs(tapMap:currentTaps()) do
    if tap and key == tap.char and not tapSet:seen(tap.id) then
      tapSet:add(tap)
    end
  end
end
