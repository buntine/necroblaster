json = require "lib/json"
fun = require "lib/fun"

BLOCK_SIZE = 1000 / 15.0

function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)
  love.graphics.setColor(0, 0, 0)

  sounds = {
    song = love.audio.newSource("assets/sounds/mh_ritual.ogg", "static")
  }

  sounds.song:setLooping(false)
  love.audio.play(sounds.song)

  local songFile = io.open("data/songs/mh_ritual.json", "r")
  local songData = songFile:read("*a")
  songFile:close()

  keyMap = generateKeyMap(json.decode(songData))
  presses = {}
  frame = 0
end

function love.draw()
  pos = math.floor(frame / 4) + 1

  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
  love.graphics.print("Position: "..tostring(pos), 10, 40)
  love.graphics.print("Score: "..tostring(fun.foldl(function(acc, x) return acc + x.health end, 0, presses)), 10, 70)
end

function love.update()
  frame = frame + 1
end

function love.keypressed(key, sc, ...)
  pos = math.floor(frame / 4) + 1
  char = keyMap[pos]

  if char and char.char then
    if key == char.char then
      table.insert(presses, char)
    end
  end

end

function list_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
           i = i + 1
           if i <= n then return t[i] end
         end
end

function generateKeyMap(data)
  local pos = 0
  local songData = list_iter(data)
  local keyMap = {}
  local nextKey = songData()

  while true do
    local frameBlock = {char=nil, health=nil}
    local timeDiff = math.abs(nextKey.offset - pos)

    if timeDiff <= BLOCK_SIZE * 3 then
      frameBlock.char = nextKey.char

      if pos >= nextKey.offset then
        frameBlock.health = 0.5
        nextKey = songData()
      elseif timeDiff > BLOCK_SIZE then
        frameBlock.health = 0.5
      else
        frameBlock.health = 1.0
      end
    end

    table.insert(keyMap, frameBlock)
    pos = pos + BLOCK_SIZE

    if nextKey == nil then break end
  end
  print(keyMap)

  return keyMap
end
