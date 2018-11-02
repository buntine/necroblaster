-- Helper functions to get around Love2D oddities.
fonts = {
  small = love.graphics.newFont("assets/fonts/germgoth.ttf", 24),
  medium = love.graphics.newFont("assets/fonts/germgoth.ttf", 32),
  big = love.graphics.newFont("assets/fonts/germgoth.ttf", 56),
  huge = love.graphics.newFont("assets/fonts/germgoth.ttf", 124),
  ridiculous = love.graphics.newFont("assets/fonts/germgoth.ttf", 248)
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

function withLineWidth(width, f)
  local _width = love.graphics.getLineWidth()

  love.graphics.setLineWidth(width)
  f()
  love.graphics.setLineWidth(_width)
end

function withScaledScissor(x, y, w, h, f)
  -- Scissors are not affected by graphical translations so we have to apply
  -- them manually.
  withScissor(x + X_TRANSLATE, y + HEIGHT_SCALE, w + WIDTH_SCALE, h + HEIGHT_SCALE, f)
end

function withScissor(x, y, w, h, f)
  love.graphics.setScissor(x, y, w, h)
  f()
  love.graphics.setScissor()
end

function normalise(x, min, max, base)
  return ((x - min) / (max - min)) * base
end

function expand_normalise(val, min, max)
  return val * (max - min) + min
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

function drawInCenter(drawable, offsetx, offsety, scalex, scaley)
  local sx = scalex or 1
  local sy = scaley or 1
  local ox = offsetx or 0
  local oy = offsety or 0

  -- Account for scaling in X/Y offset.
  if sx > 1 or sy > 1 then
    ox = ox - (((sx - 1) * drawable:getWidth()) / 2)
    oy = oy - (((sy - 1) * drawable:getHeight()) / 2)
  end

  local x, y = unpack(
                 center(DESIRED_WIDTH, DESIRED_HEIGHT, drawable:getWidth(),
                        drawable:getHeight(), ox, oy)
               )

  love.graphics.draw(drawable, x, y, 0, sx, sy)
end

-- Transforms coordination system so that GUI is drawn centered in
-- fullscreen mode.
function scaleGraphics()
  love.graphics.translate(X_TRANSLATE, 0)
  love.graphics.scale(WIDTH_SCALE, HEIGHT_SCALE)
end

function withoutScale(f)
  -- Save and reset current transformation so we can draw on the whole screen.
  love.graphics.push()
  love.graphics.origin()
  f()
  love.graphics.pop() -- Restore previous transformation.
end

function stretchToScreen(img, zoom)
  local z = zoom or 0
  local sx = (ACTUAL_WIDTH + z) / img:getWidth()
  local sy = (ACTUAL_HEIGHT + z) / img:getHeight()

  love.graphics.draw(img, 0 - (z / 2), 0 - (z / 2), 0, sx, sy)
end

function readFile(path)
  local file = io.open(path)
  local data = file:read("*a")

  file:close()

  return data
end

function isPlaying()
  return Gamestate.current() == play
end

function mergeTables(parent, child)
  for i, value in pairs(child) do
    table.insert(parent[i], value)
  end
end
