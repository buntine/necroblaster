-- Helper functions to get around Love2D oddities.
fonts = {
  small = love.graphics.newFont("assets/fonts/seagram_tfb.ttf", 24),
  medium = love.graphics.newFont("assets/fonts/seagram_tfb.ttf", 32),
  big = love.graphics.newFont("assets/fonts/seagram_tfb.ttf", 56),
  huge = love.graphics.newFont("assets/fonts/seagram_tfb.ttf", 124)
}

function withColour(r, g, b, a, f)
  local _r, _g, _b, _a = love.graphics.getColor()

  love.graphics.setColor(r, g, b, a)
  f()
  love.graphics.setColor(_r, _g, _b, _a)
end

function withOpacity(a, f)
  withColour(1, 1, 1, a, f)
end

function withFont(name, f)
  local _f = love.graphics.getFont()

  love.graphics.setFont(fonts[name])
  f()
  love.graphics.setFont(_f)
end

function withScissor(x, y, w, h, f)
  -- Scissors are not affected by graphical translations so we have to apply
  -- them manually.
  love.graphics.setScissor(x + X_TRANSLATE, y + HEIGHT_SCALE, w + WIDTH_SCALE, h + HEIGHT_SCALE)
  f()
  love.graphics.setScissor()
end

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function center(tw, th, w, h, ox, oy)
  local ox = ox or 0
  local oy = oy or 0

  return { (tw / 2 - w / 2) + ox, (th / 2 - h / 2) + oy }
end

function centerOfLane(nth)
  return LANE_OFFSET + (LANE_WIDTH * nth) + (LANE_WIDTH / 2)
end

-- Transforms coordination system so that GUI is drawn centered in
-- fullscreen mode.
function scaleGraphics()
  love.graphics.translate(X_TRANSLATE, 0)
  love.graphics.scale(WIDTH_SCALE, HEIGHT_SCALE)
end
