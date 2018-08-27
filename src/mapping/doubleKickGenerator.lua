-- Generates a range of double kick taps during song loading.

DoubleKickGenerator = Class{
}

function DoubleKickGenerator:generate(d, laneChars)
  local taps = {}
  local start = math.floor(d.offset / TIME_SCALE)
  local finish = math.floor(d.finish / TIME_SCALE)

  for _it, i in fun.range(start, finish) do
    local tap = Tap(1)

    tap.left = i % 2 == 0
    tap.char = laneChars[d.lane]
    tap.kind = d.kind

    taps[i] = tap
  end

  return taps
end
