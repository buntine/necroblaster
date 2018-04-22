require "widgets.selector"
require "gamestates.difficulty"

menu = {}

function menu:enter()
  local songs = fun.totable(love.filesystem.getDirectoryItems(DATA_PATH))

  self.selector = Selector:new(songs)
  --self.difficulty = Difficulty:new()
end

function menu:draw()
  self.selector:render()
  --self.difficulty:render()
end

function menu:update()
  self.selector:progress()
end

function menu:keypressed(key)
  if key == BTN_A then
    self.selector:previous()
  elseif key == BTN_B then
    self.selector:next()
  --elseif key == BTN_C then
  --  self.difficulty:next()
  elseif key == BTN_D then
    local songid = self.selector:song().songid
    --local speed = self.difficulty:speed()

    Gamestate.switch(difficulty, songid, 120)
  end
end

function menu:leave()
  self.selector:reset()
end
