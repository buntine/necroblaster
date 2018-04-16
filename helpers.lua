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

function withFont(name, f)
  local _f = love.graphics.getFont()

  love.graphics.setFont(fonts[name])
  f()
  love.graphics.setFont(_f)
end

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function center(tw, th, w, h, ox, oy)
  local ox = ox or 0
  local oy = oy or 0

  return { (tw / 2 - w / 2) + ox, (th / 2 - h / 2) + oy }
end
