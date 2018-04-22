fun = require "lib.fun"
Gamestate = require "lib.hump.gamestate"
require "constants"
require "gamestates.title"
require "result"

local play = {}
local results = {}

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(title)
end

function results:enter(_, score, bestScore)
  self.result = Result:new(score, bestScore)
end

function results:keypressed(_)
  Gamestate.switch(menu)
end

function results:draw()
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  self.result:render(w, h)
end
