-- Generates single taps during song loading.

require "mapping.generator"

TapGenerator = Class{
}

function TapGenerator:generate(d, laneChars)
  local taps = {}

  for _it, i in fun.range(-DAMPENING, DAMPENING) do
    local blurring = math.abs(i) + 1
    local tap = Tap(1 / blurring)

    tap.char = laneChars[d.lane]
    tap.kind = d.kind

    table.insert(taps, tap)
  end

  return taps
end
