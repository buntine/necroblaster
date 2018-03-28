SONG_PATH = "assets/sounds"

Song = {
  stream = nil
}

function Song:new(path) {
  local sound = love.audio.newSource(SONG_PATH .. "/" .. path .. ".ogg", "static")
  local o = {stream=sound}

  setmetatable(o, self)
  self.__index = self

  return o
}

function Song:play() {
  self.stream:setLooping(false)

  love.audio.play(self.stream)
}
