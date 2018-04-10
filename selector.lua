Selector = {
  songs = {},
  index = 1,
}

function Selector:new(songs)
  local o = {
    songs = fun.totable(fun.map(function(s)
      local file = io.open(DATA_PATH .. "/" .. s .. "/details.json", "r")
      local data = file:read("*a")
      file:close()

      return {
        song = Song:new(s),
        details = json.decode(data),
        image = love.graphics.newImage(DATA_PATH .. "/" .. s .. "/cover.jpg")
      }
    end, songs)),
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Selector:render()
  local details = self:details()
  local song = self:song()

  withColour(220, 29, 29, 255, function()
    withFont("big", function()
      love.graphics.print("Pick your evil spell", 30, 20)
    end)
  end)

  love.graphics.draw(self:image(), 160, 120)
  withColour(200, 200, 200, 255, function()
    love.graphics.rectangle("line", 159, 119, 481, 481)

    withFont("medium", function()
      love.graphics.print(details.artist, 160, 620)
    end)

    withFont("small", function()
      love.graphics.print(details.title, 160, 660)
    end)
  end)
end

function Selector:progress()
  local song = self:song()
  local details = self:details()
  local v = love.audio.getVolume()

  -- Play preview with fade in and fade out.
  if not song:playing() then
    love.audio.setVolume(0)
    song:play(details.sample_start)
  elseif song:tell() > details.sample_end then
    if v <= PREVIEW_FADE then
      song:seek(details.sample_start)
    else
      love.audio.setVolume(v - PREVIEW_FADE)
    end
  elseif v < 1 then
    love.audio.setVolume(v + PREVIEW_FADE)
  end
end

function Selector:previous()
  self:song():pause()

  if self.index == 1 then
    self.index = #self.songs
  else
    self.index = self.index - 1
  end
end

function Selector:next()
  self:song():pause()

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

function Selector:song()
  return self.songs[self.index].song
end

function Selector:details()
  return self.songs[self.index].details
end

function Selector:image()
  return self.songs[self.index].image
end
