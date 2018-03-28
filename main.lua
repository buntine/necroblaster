fun = require "lib/fun"

BLOCK_SIZE = 1000 / 15.0
SPEED = 120

function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)
  love.graphics.setColor(80, 80, 180)
  love.graphics.setLineWidth(3)

  song = Song:new("mh_ritual")
  tapMap = TapMap:new("mh_ritual")

  song:play()
  tapMap:generate()

  presses = {}
  visible = {}
  frame = 0
end

function love.draw()
  pos = math.floor(frame / 4) + 1
  h = love.graphics.getHeight()
  w = love.graphics.getWidth()

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Position: "..tostring(pos), 10, 40)
  love.graphics.print("Score: "..tostring(fun.foldl(function(acc, x) return acc + x.health end, 0, presses)), 10, 70)

  love.graphics.line(20, h - 30, w - 20, h - 30)

  for _, v in ipairs(visible) do
    love.graphics.circle("fill", v.x, v.y, 50)
  end
end

function love.update()
  frame = frame + 1

  pos = math.floor((frame + SPEED) / 4) + 1
  char = keyMap[pos]
  lastId = (#visible > 0 and visible[#visible].id or nil)

  if char and char.char and char.id ~= lastId then
    table.insert(visible, {x=x_for_char(char.char), y=-75, id=char.id})
  end

  for i=#visible, 1, -1 do
    v = visible[i]
    h = love.graphics.getHeight()
    v.y = v.y + (h / SPEED)

    if v.y > h + 50 then
      table.remove(visible, i)
    end
  end
end

function love.keypressed(key, sc, ...)
  pos = math.floor(frame / 4) + 1
  char = keyMap[pos]
  lastId = (#presses > 0 and presses[#presses].id or nil)

  if char and char.char then
    if key == char.char and lastId ~= char.id then
      table.insert(presses, char)
    end
  end
end

function x_for_char(c)
  xs = {a=75, b=250, c=425, d=600}
  return xs[c]
end

