require "widgets.chooser"
require "gamestates.play"

handedness = {}

function handedness:enter(songid, speed)
  self.chooser = Chooser:new("Dominant hand: ", HANDEDNESS)
  self.songid = songid
  self.speed = speed
end

function handedness:draw()
  self.chooser:render()
end

function handedness:keypressed(key)
  if key == BTN_A then
    self.chooser:previous()
  elseif key == BTN_B then
    self.chooser:next()
  elseif key == BTN_D then
    local dominant = self.chooser:value()

    Gamestate.switch(play, self.songid, self.speed, dominant)
  end
end
