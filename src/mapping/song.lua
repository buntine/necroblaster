-- Wrapper around a streaming song.

Song = Class{
  init = function(self, songid)
    self.songid = songid
    self.stream = love.audio.newSource(DATA_PATH .. "/" .. songid .. "/audio.ogg", "static")
  end,
}

function Song:tell()
  return self.stream:tell()
end

function Song:finished()
  return not self.stream:isPlaying()
end

function Song:playing()
  return self.stream:isPlaying()
end

function Song:play(offset)
  local o = offset or 45
  self.stream:setLooping(false)

  self.stream:play()

  if o > 0 then
    self:seek(o)
  end
end

function Song:length()
  return self.stream:getDuration()
end

function Song:seek(offset)
  self.stream:seek(offset)
end

function Song:pause()
  self.stream:pause()
end

function Song:stop()
  self.stream:stop()
end
