require "widgets.songMenu"
require "widgets.selector"
require "gamestates.difficulty"
require "tweening.transition"

menu = Transition:new()

function menu:enter()
  local songs = fun.totable(love.filesystem.getDirectoryItems(DATA_PATH))
  local songMenu = SongMenu:new(songs)

  self.selector = Selector:new(songMenu, "Evil spell...", "menu_bg_forest.png")
end

function menu:draw()
  scaleGraphics()
  self.selector:render()
  self:drawTween()
end

function menu:update()
  self.selector:progress()
  self:updateTween()
end

function menu:keypressed(key)
  if key == BTN_D then
    local carry = { songid = self.selector:value() }

    self:transitionTo(difficulty, carry)
  else
    self.selector:keypressed(key)
  end
end

function menu:leave()
  self.selector:reset()
end
