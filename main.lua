fun = require "lib/fun"
require "song"
require "tapSet"
require "tapMap"

function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)
  love.graphics.setColor(80, 80, 180)
  love.graphics.setLineWidth(3)

  song = Song:new("mh_ritual")
  tapMap = TapMap:new("mh_ritual")
  tapSet = TapSet:new()

  song:play()
  tapMap:generate()

  visible = {}
end

function love.draw()
  pos = tapMap:currentFrame()
  h = love.graphics.getHeight()
  w = love.graphics.getWidth()

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Position: "..tostring(pos), 10, 40)
  love.graphics.print("Score: "..tostring(fun.foldl(function(acc, x) return acc + x.health end, 0, tapSet.taps)), 10, 70)

  love.graphics.line(20, h - 30, w - 20, h - 30)

  for _, v in ipairs(visible) do
    love.graphics.circle("fill", v.x, v.y, 50)
  end
end

function love.update()
  tapMap:progress()

  tap = tapMap:futureTap()
  lastId = (#visible > 0 and visible[#visible].id or nil)

  if tap and tap.char and tap.id ~= lastId then
    table.insert(visible, {x=x_for_char(tap.char), y=-75, id=tap.id})
  end

  for i=#visible, 1, -1 do
    v = visible[i]
    h = love.graphics.getHeight()
    v.y = v.y + (h / tapMap.speed)

    if v.y > h + 50 then
      table.remove(visible, i)
    end
  end
end

function love.keypressed(key, sc, ...)
  tap = tapMap:currentTap()
  lastId = tapSet:lastTapID()

  if tap and tap.char then
    if key == tap.char and lastId ~= tap.id then
      tapSet:add(tap)
    end
  end
end

function x_for_char(c)
  xs = {a=75, b=250, c=425, d=600}
  return xs[c]
end
