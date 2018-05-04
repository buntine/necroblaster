-- A multi-item menu used as a "body" to Selector.

require "widgets.menuOption"

Menu = {
  options = {},
  index = 1
}

function Menu:new(options, selected)
  local s = selected or 1
  local o = {
    options = fun.totable(
      fun.map(function(o)
        return MenuOption:new(o.name, o.value)
      end, options)
    ),
    index = s
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function Menu:render()
  local option = self.options[self.index]

  withColour(0.66, 0.66, 0.66, 1, function()
    option:render()
  end)
end

function Menu:previous()
  if self.index == 1 then
    self.index = #self.options
  else
    self.index = self.index - 1
  end
end

function Menu:next()
  if self.index == #self.options then
    self.index = 1
  else
    self.index = self.index + 1
  end
end


function Menu:value()
  return self.options[self.index].value
end
