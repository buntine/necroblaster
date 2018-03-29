fun = require "lib/fun"
require "song"
require "tapSet"
require "visibleTapSet"
require "tapMap"

function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)
  love.graphics.setColor(80, 80, 180)
  love.graphics.setLineWidth(3)

  song = Song:new("mh_ritual")
  tapMap = TapMap:new("mh_ritual")
  tapSet = TapSet:new()
  visibleTapSet = VisibleTapSet:new()

  song:play()
  tapMap:generate()
end

function love.draw()
  pos = tapMap:currentFrame()
  h = love.graphics.getHeight()
  w = love.graphics.getWidth()

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Frame: "..tostring(pos), 10, 40)
  love.graphics.print("Score: "..tostring(fun.foldl(function(acc, x) return acc + x.health end, 0, tapSet.taps)), 10, 70)

  love.graphics.line(20, h - 30, w - 20, h - 30)

  for _, v in ipairs(visibleTapSet.taps) do
    love.graphics.circle("fill", v.x, v.y, 50)
  end
end

function love.update()
  tapMap:progress()

  tap = tapMap:futureTap()

  if tap and tap.char and not visibleTapSet:seen(tap.id) then
    visibleTapSet:add(tap)
  end

  visibleTapSet:updateY(love.graphics.getHeight(), tapMap.speed)
end

function love.keypressed(key, sc, ...)
  tap = tapMap:currentTap()

  if tap and tap.char then
    if key == tap.char and not tapSet:seen(tap.id) then
      tapSet:add(tap)
    end
  end
end
