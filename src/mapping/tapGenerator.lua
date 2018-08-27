-- Generates single taps during song loading.

TapGenerator = Class{
}

function TapGenerator:generate(d, laneChars)
  local taps = {}
  local index = math.floor(d.offset / TIME_SCALE)
  local group = math.random(9999999)

  for _it, i in fun.range(index - DAMPENING, index + DAMPENING) do
    local blurring = math.abs(index - i) + 1
    local health = 1 / blurring
    local tap = Tap(health, group)

    tap.char = laneChars[d.lane]
    tap.kind = d.kind
    tap.renderable = (health == 1)

    -- When rendering, this offset will be used to position the tap correctly within it's
    -- segment so that spacing is visually correct.
    tap.offset = d.offset % TIME_SCALE

    taps[i] = tap
  end

  return taps
end
