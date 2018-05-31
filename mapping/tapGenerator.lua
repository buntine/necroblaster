-- Generates single taps during song loading.

TapGenerator = Class{
}

function TapGenerator:generate(d, laneChars)
  local taps = {}
  local index = math.floor(d.offset / TIME_SCALE)
  local id = math.random(9999999)

  for _it, i in fun.range(index - DAMPENING, index + DAMPENING) do
    local blurring = math.abs(index - i) + 1
    local tap = Tap(1 / blurring, id)

    tap.char = laneChars[d.lane]
    tap.kind = d.kind

    taps[i] = tap
  end

  return taps
end
