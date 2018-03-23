json = require "lib/json"

function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)
  love.graphics.setColor(0, 0, 0)

  sounds = {
    song = love.audio.newSource("assets/sounds/mh_ritual.mp3")
  }

  sounds.song:setLooping(true)
  love.audio.play(sounds.song)

  local songFile = io.open("data/songs/mh_ritual.json", "r")
  local songData = songFile:read("*a")
  songFile:close()

  keyMap = generateKeyMap(json.decode(songData))
end

function love.draw()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
end

function generateKeyMap(songData)
  return songData
end
