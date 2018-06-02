-- Represents the set of taps that have been successfully "hit" for
-- the current song.
--
-- The current score is cached here.

TapSet = Class{
  init = function(self)
    self.taps = {}
  end,
}

function TapSet:add(tap)
  table.insert(self.taps, tap)
end

function TapSet:score()
  return #self.taps
end

function TapSet:accuracy()
  local total = fun.foldl(
    function(total, tap)
      return total + hap.health
    end,
    0,
    self.taps
  )

  return (total / #self.taps) * 100
end

function TapSet:seen(tap)
  return (#self.taps > 0 and self.taps[#self.taps].group == tap.group or false)
end
