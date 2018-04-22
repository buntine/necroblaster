require "widgets.chooser"
require "gamestates.handedness"

difficulty = {}

function difficulty:enter(songid)
  self.chooser = Chooser:new(DIFFICULTIES, 2)
end

function difficulty:draw()
  self.chooser:render()
end

function difficulty:keypressed(key)
  if key == BTN_A then
    self.chooser:previous()
  elseif key == BTN_B then
    self.chooser:next()
  elseif key == BTN_D then
    local speed = self.chooser:value()

    Gamestate.switch(handedness, songid, speed)
  end
end
