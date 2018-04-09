Selector = {
  songs = {},
  index = 1,
}

function Selector:new(songs)
  local o = {
    songs = fun.totable(fun.map(function(s) return Song:new(s) end, songs)),
    index = 1
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Selector:render()
end

function Selector:progress()
  local song = self.songs[self.index]
  local v = love.audio.getVolume()

  -- Play preview with fade in and fade out.
  if not song:playing() then
    love.audio.setVolume(0)
    song:play(PREVIEW_OFFSET)
  elseif song:tell() > PREVIEW_OFFSET + PREVIEW_LENGTH then
    if v <= PREVIEW_FADE then
      song:seek(PREVIEW_OFFSET)
    else
      love.audio.setVolume(v - PREVIEW_FADE)
    end
  elseif v < 1 then
    love.audio.setVolume(v + PREVIEW_FADE)
  end
end

function Selector:previous()
  self.songs[self.index]:pause()

  if self.index == 1 then
    self.index = #self.songs
  else
    self.index = self.index - 1
  end
end

function Selector:next()
  self.songs[self.index]:pause()

  if self.index == #self.songs then
    self.index = 1
  else
    self.index = self.index + 1
  end
end

function Selector:reset()
  love.audio.setVolume(1)
  love.audio.stop()
end

function Selector:songid()
  return self.songs[self.index].songid
end
