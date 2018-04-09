Selector = {
  songs = {},
  index = 1,
}

function Selector:new(songs)
  local o = {songs = songs, index = 1}

  setmetatable(o, self)
  self.__index = self

  return o
end

function Selector:render()
end

function Selector:progress()
  -- Determine where song is up to and calculate volume.
  -- If zero, start over at 0ms.
end

function Selector:previous()
  if self.index == 1 then
    self.index = #self.songs
  else
    self.index = self.index - 1
  end
end

function Selector:next()
  if self.index == #self.songs then
    self.index = 1
  else
    self.index = self.index + 1
  end
end

function Selector:song()
  return self.songs[self.index]
end
