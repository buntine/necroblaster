fun = require "lib.fun"
Gamestate = require "lib.hump.gamestate"
Class = require "lib.hump.class"

require "src.constants"
require "src.gamestates.title"

function love.load()
  love.window.setMode(0, 0, {fullscreen = true})
  love.mouse.setVisible(false)

  Gamestate.registerEvents()
  Gamestate.switch(title)
end

function love.keypressed(k)
  if k == 'escape' and not isPlaying() then
    love.event.quit()
  end
end
