-- A multi-item menu that keeps track of where it's up to.
--
-- This class conforms to the Selector interface.

require "src.widgets.menuOption"

Menu = Class{
  init = function(self, options, selected)
    local s = selected or 1

    self.index = s
    self.options = fun.totable(
      fun.map(function(o)
        return MenuOption(o.name, o.value)
      end, options)
    )
  end,
}

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
