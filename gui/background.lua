-- Cross-fading set of band images for use during gameplay. The
-- images cycle endlessly until the song finshes.

Background = {
  images = {},
  auxillery = nil,
  index = 1,
  zoom = 0,
  opacity = 1,
}

function Background:new(songid)
  local path = DATA_PATH .. "/" .. songid .. "/backgrounds/"
  local images = love.filesystem.getDirectoryItems(path)
  local o = {
    images = fun.totable(
               fun.map(function (image)
                 return love.graphics.newImage(path .. image)
               end, images)
             ),
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Background:render()
  withoutScale(function()
    if self.auxillery then 
      stretchToScreen(self.images[self.auxillery])
    end

    withOpacity(self.opacity, function()
      stretchToScreen(self.images[self.index], self.zoom)
    end)
  end)
end

function Background:progress()
  self.zoom = self.zoom + BACKGROUND_ZOOM_AMOUNT

  if self.zoom > BACKGROUND_ZOOM_THRESHOLD then
    self:scheduleNextImage()
  end

  if self.auxillery then
    self:fadeImage()
  end
end

function Background:fadeImage()
  self.opacity = self.opacity - BACKGROUND_FADE_SPEED

  if self.opacity <= 0 then
    self:nextImage()
  end
end

function Background:scheduleNextImage()
  self.auxillery = self:nextIndex()
end

function Background:nextImage()
  self.zoom = 1
  self.auxillery = nil
  self.opacity = 1
  self.index = self:nextIndex()
end

function Background:nextIndex()
  return math.max(
    (self.index + 1) % (#self.images + 1),
    1
  )
end
