fun = require "lib/fun"
require "song"
require "tapSet"
require "laneways"
require "tapMap"

function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)
  love.graphics.setColor(80, 80, 180)

  song = Song:new("mh_ritual")
  tapMap = TapMap:new("mh_ritual")
  tapSet = TapSet:new()
  laneways = LaneWays:new()

  song:play()
  tapMap:generate()
end

function love.draw()
  local frame = tapMap:currentFrame()
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Frame: "..tostring(frame), 10, 40)
  love.graphics.print("Score: "..tostring(fun.foldl(function(acc, x) return acc + x.health end, 0, tapSet.taps)), 10, 70)

  love.graphics.circle("fill", 75, h - 40, 30)
  love.graphics.circle("fill", 250, h - 40, 30)
  love.graphics.circle("fill", 425, h - 40, 30)
  love.graphics.circle("fill", 600, h - 40, 30)

  for _, l in pairs(laneways.lanes) do
    for i, v in ipairs(l.taps) do
      if v.kind == "tap" then
        love.graphics.circle("fill", l.x, v.y, 30)
      elseif v.kind == "doublekick" then
        love.graphics.circle("fill", (i % 2 == 0 and l.x - 40 or l.x + 40), v.y, 15)
      end
    end
  end
end

function love.update()
  tapMap:progress()

  for _, tap in ipairs(tapMap:futureTaps()) do
    if tap and not laneways:seen(tap) then
      laneways:add(tap)
    end
  end

  laneways:progress(love.graphics.getHeight(), tapMap.speed)
end

function love.keypressed(key, sc, ...)
  for _, tap in ipairs(tapMap:currentTaps()) do
    if tap and key == tap.char and not tapSet:seen(tap.id) then
      tapSet:add(tap)
    end
  end
end
