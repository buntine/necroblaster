require "widgets.chooser"
require "gamestates.handedness"

difficulty = {}

function difficulty:enter(_, songid)
  self.chooser = Chooser:new("Speed: ", DIFFICULTIES, 2)
  self.songid = songid
  print(songid)
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

    Gamestate.switch(handedness, self.songid, speed)
  end
end
