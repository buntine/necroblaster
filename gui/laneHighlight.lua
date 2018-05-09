-- A highlight that appears behind a lane "plate" upon the appropriate keystroke.

LaneHighlight = {
  step = 1,
}

function LaneHighlight:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  return o
end

function LaneHighlight:progress()
  if self.step > 1 then
    self.step = self.step + HIGHLIGHT_STEP
  end

  if self.step > #HIGHLIGHT_COLORS then
    self.step = 1
  end
end

function LaneHighlight:render(x)
  local r, g, b = unpack(HIGHLIGHT_COLORS[math.floor(self.step)])

  withColour(r, g, b, 1, function()
    love.graphics.rectangle("fill", x - 30, DESIRED_HEIGHT - 38, 60, 28)
  end)
end

function LaneHighlight:start()
  if self.step == 1 then
    self.step = HIGHLIGHT_STEP + 1
  else
    -- We are already mid-highlight, so just prolong the current one.
    self.step = #HIGHLIGHT_COLORS / 2
  end
end
