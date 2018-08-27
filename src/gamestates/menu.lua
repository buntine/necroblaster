require "src.widgets.songMenu"
require "src.widgets.selector"
require "src.gui.layout"
require "src.gamestates.difficulty"
require "src.tweening.transition"

menu = Transition()

function menu:init()
  local songs = fun.totable(love.filesystem.getDirectoryItems(DATA_PATH))
  local songMenu = SongMenu(songs)

  self.selector = Selector(songMenu)
  self.layout = Layout("Evil spell...", "menu_bg_forest.png")
end

function menu:draw()
  scaleGraphics()
  self.layout:render()
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
