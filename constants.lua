BTN_A = "a"
BTN_B = "b"
BTN_C = "c"
BTN_D = "d"
DATA_PATH = "data"
DESIRED_WIDTH = 800
DESIRED_HEIGHT = 970
ASPECT_RATIO = DESIRED_WIDTH / DESIRED_HEIGHT
ACTUAL_WIDTH = love.graphics.getWidth()
ACTUAL_HEIGHT = love.graphics.getHeight()
SCALED_WIDTH = ACTUAL_HEIGHT * ASPECT_RATIO
SCALED_HEIGHT = ACTUAL_WIDTH / ASPECT_RATIO
WIDTH_SCALE = SCALED_WIDTH / DESIRED_WIDTH
HEIGHT_SCALE = ACTUAL_HEIGHT / DESIRED_HEIGHT
X_MIDPOINT = ACTUAL_WIDTH / 2
X_TRANSLATE = X_MIDPOINT - (SCALED_WIDTH / 2)
LANE_WIDTH = 175
LANE_OFFSET = 50
PLATE_OFFSET = 41
TIME_SCALE = 1000 / 15
DAMPENING = 2
VANISHING_POINT_Y = -100
DOUBLEKICK_SPACING = 37
TAP_Z = 4
HIGHLIGHT_COLORS = {
  {0.47, 0.12, 0.12}, {0.59, 0.12, 0.12}, {0.7, 0.12, 0.12}, {0.82, 0.12, 0.12},
  {0.95, 0.12, 0.12}, {0.82, 0.12, 0.12}, {0.7, 0.12, 0.12}, {0.59, 0.12, 0.12},
  {0.47, 0.12, 0.12}
}
HIGHLIGHT_STEP = 0.25
APPROACH_MAX_OFFSET = 80
SCORE_WIDTH = 230
SCORE_X = ACTUAL_WIDTH - 500
SCORE_RESISTANCE = 0.2
SCORE_FORCE = 2
MIN_SCORE_CLIP = 59
PREVIEW_FADE = 0.01
PROGRESS_HEIGHT = 5
REVERB_SCALING_FACTOR = 0.2
REVERB_OPACITY_FACTOR = 0.1
TRANSITION_DELTA = 0.04
MENU_BORDER = 25
DROP_MIN_DISTANCE = 8
DROP_MAX_DISTANCE = 30
DROP_MIN_SPEED = 7
DROP_MAX_SPEED = 30
DROP_MIN_THICKNESS = 1
DROP_MAX_THICKNESS = 3
DROP_MIN_ANGLE = 3
DROP_MAX_ANGLE = 10
DIFFICULTIES = {
  {value = 240, name = "Poser"},
  {value = 180, name = "Infantry"},
  {value = 120, name = "Commando"},
  {value = 60, name = "Soul Crusher"}
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
