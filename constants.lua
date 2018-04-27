BTN_A = "a"
BTN_B = "b"
BTN_C = "c"
BTN_D = "d"
DATA_PATH = "data"
LANE_WIDTH = 175
LANE_OFFSET = 50
PLATE_OFFSET = 41
TIME_SCALE = 1000 / 15
DAMPENING = 2
VANISHING_POINT_Y = -100
DOUBLEKICK_SPACING = 37
TAP_Z = 4
HIGHLIGHT_COLORS = {{0.47, 0.12, 0.12}, {0.59, 0.12, 0.12}, {0.7, 0.12, 0.12}, {0.82, 0.12, 0.12}, {0.7, 0.12, 0.12}, {0.59, 0.12, 0.12}, {0.47, 0.12, 0.12}}
HIGHLIGHT_STEP = 0.25
APPROACH_MAX_OFFSET = 80
SCORE_WIDTH = 230
SCORE_HEIGHT = 28
SCORE_X = 540
SCORE_Y = 220
SCORE_BORDER = 3
PREVIEW_FADE = 0.01
PROGRESS_HEIGHT = 5
REVERB_SCALING_FACTOR = 0.2
REVERB_OPACITY_FACTOR = 0.1
DIFFICULTIES = {
  {value = 240, name = "Poser"},
  {value = 180, name = "Dexterity von Doom"},
  {value = 90, name = "Soul Crushing"}
}
HANDEDNESS = {
  {value = "right", name = "Right"},
  {value = "left", name = "Left"}
}
RANKS = {
  {25, "Total Poser"},
  {50, "Sum-Human Scum"},
  {65, "Die Hard"},
  {75, "Berserker!"},
  {85, "Immortal Warlord"},
  {100, "The Thundergod"}
}
TAP_IMAGES = {
  tap = love.graphics.newImage("assets/images/tap.png"),
  doublekick = love.graphics.newImage("assets/images/doublekick.png"),
  blastbeat = love.graphics.newImage("assets/images/blastbeat.png")
}
TAP_RADIUS = {
  tap = 47,
  doublekick = 31,
  blastbeat = 31
}
