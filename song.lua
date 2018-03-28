SONG_PATH = "assets/sounds"

Song = {
  file = nil
}

function Song:new(path) {
  sound = love.audio.newSource(SONG_PATH .. "/" .. path, "static")
  o = {file=sound}

  setmetatable(o, self)
  self.__index = self

  return o
}

function Song:play() {
  self.file:setLooping(false)

  love.audio.play(self.file)
}
