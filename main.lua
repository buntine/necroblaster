fun = require "lib.fun"
Gamestate = require "lib.hump.gamestate"

require "constants"
require "gamestates.title"

function love.load()
  love.window.setMode(0, 0, {fullscreen = true})
  Gamestate.registerEvents()
  Gamestate.switch(title)
end

