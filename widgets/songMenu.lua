SongMenu = {
  songs = {},
  border = love.graphics.newImage("assets/images/menu_border.png"),
  index = 1,
}

function SongMenu:new(songs)
  local o = {
    songs = fun.totable(
      fun.map(function(s)
        local file = io.open(DATA_PATH .. "/" .. s .. "/details.json", "r")
        local data = file:read("*a")
        file:close()

        return {
          song = Song:new(s),
          details = json.decode(data),
          image = love.graphics.newImage(DATA_PATH .. "/" .. s .. "/cover.jpg")
        }
      end, songs)
    ),
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function SongMenu:render()
  local details = self:details()
  local song = self:song()

  love.graphics.draw(self:image(), 90, 175)
  love.graphics.draw(self.border, 23, 108)

  withColour(0.78, 0.78, 0.78, 1, function()
    withFont("medium", function()
      love.graphics.print(details.artist, 90, 808)
    end)

    withFont("small", function()
      love.graphics.print(details.title, 90, 848)
    end)
  end)
end

function SongMenu:progress()
  local details = self:details()
  local song = self:song()
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

function SongMenu:previous()
  self:song():pause()

  if self.index == 1 then
    self.index = #self.songs
  else
    self.index = self.index - 1
  end
end

function SongMenu:next()
  self:song():pause()

  if self.index == #self.songs then
    self.index = 1
  else
    self.index = self.index + 1
  end
end

function SongMenu:value()
  return self:song().songid
end

function SongMenu:reset()
  love.audio.setVolume(1)
  love.audio.stop()
end

function SongMenu:song()
  return self.songs[self.index].song
end

function SongMenu:details()
  return self.songs[self.index].details
end

function SongMenu:image()
  return self.songs[self.index].image
end
