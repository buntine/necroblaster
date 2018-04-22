fun = require "lib.fun"
Gamestate = require "lib.hump.gamestate"

require "constants"
require "gamestates.title"

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(title)
end

