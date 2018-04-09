Song = {
  songid = nil,
  stream = nil
}

function Song:new(songid)
  local sound = love.audio.newSource(DATA_PATH .. "/" .. songid .. "/audio.ogg", "static")
  local o = {songid = songid, stream = sound}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Song:tell()
  return self.stream:tell()
end

function Song:playing()
  return self.stream:isPlaying()
end

function Song:play(offset)
  local o = offset or 0
  self.stream:setLooping(false)

  love.audio.play(self.stream)

  if o > 0 then
    self:seek(o)
  end
end

function Song:seek(offset)
  self.stream:seek(offset)
end

function Song:pause()
  love.audio.pause(self.stream)
end
