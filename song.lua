Song = {
  stream = nil
}

function Song:new(songid)
  local sound = love.audio.newSource(DATA_PATH .. "/" .. songid .. "/audio.ogg", "static")
  local o = {stream=sound}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Song:tell()
  return self.stream:tell()
end

function Song:play()
  self.stream:setLooping(false)

  love.audio.play(self.stream)
  self.stream:seek(47)
end
