-- Cross-fading set of band images for use during gameplay.

Background = {
  images = {},
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
    stretchToScreen(self.images[self.index], self.zoom)
  end)
end

function Background:progress()
  self.zoom = self.zoom + 0.25
end
