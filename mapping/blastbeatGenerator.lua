-- Generates a range of double kick taps during song loading.

BlastbeatGenerator = Class{
}

function BlastbeatGenerator:generate(d, laneChars)
  local taps = {}
  local start = math.floor(d.offset / TIME_SCALE)
  local finish = math.floor(d.finish / TIME_SCALE)

  for _it, i in fun.range(start, finish) do
    local tap = Tap(1)

    tap.char = laneChars[d.lane]
    tap.kind = d.kind

    table.insert(taps, tap)
  end

  return taps
end
