function love.load(a)
  love.graphics.setBackgroundColor(171, 205, 236)

  sounds = {
    song = love.audio.newSource("assets/sounds/mh_ritual.mp3")
  }

  sounds.song:setLooping(true)
  love.audio.play(sounds.song)

  
end

function love.draw()
     love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("Hello World", 400, 300)
end
