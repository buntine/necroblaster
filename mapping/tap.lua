-- A single tap in a song.
--
-- Taps can be of a particular kind ("double kick", "blast beat", etc). And
-- have a concept known as "health", that deteriorates the further away from
-- the middle.
--
-- E.g If we expect a tap at exactly 129ms then there will be taps preceding
-- and following it with deteriorating health:
--   Tap: 125ms, health = 0.25
--   Tap: 127ms, health = 0.5
--   Tap: 127ms, health = 1
--   Tap: 127ms, health = 0.5
--   Tap: 129ms, health = 0.25

Tap = Class{
  init = function(self, health, group)
    local group = group or math.random(99999999)
    self.group = group
    self.health = health
  end,
  kind = "tap",
  char = nil,
  renderable = true,
  left = false,
}
