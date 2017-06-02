-- Stick command cheatsheet for MultiWii, BaseFlight, CleanFlight and
-- BetaFlight.

-------------------------------------------------------------------------------

local function drawStick(x, y, w, h, vx, vy)
  local halfWidth = w / 2;
  local halfHeight = h / 2;

  lcd.drawRectangle(x - halfWidth, y - halfHeight, w, h)

  local stickDim = 10
  local halfStickDim = stickDim / 2

  local sx = x + ((halfWidth - halfStickDim) * vx)
  local sy = y - ((halfHeight - halfStickDim) * vy)

  lcd.drawFilledRectangle(sx - halfStickDim, sy - halfStickDim, stickDim, stickDim, FORCE)
end

-------------------------------------------------------------------------------

local function drawSticks(stickPositions)
  local stickDim = 50;
  local stickY = 36;
  drawStick(72, stickY, stickDim, stickDim, stickPositions[4], stickPositions[1])
  drawStick(140, stickY, stickDim, stickDim, stickPositions[2], stickPositions[3])
  -- drawStick(28, stickY, stickDim, stickDim, stickPositions[1], stickPositions[2])
  -- drawStick(184, stickY, stickDim, stickDim, stickPositions[3], stickPositions[4])
end

-------------------------------------------------------------------------------

local function drawAbout()
  lcd.drawText(2, 10, "MW/CF/BF Stick Commands", MIDSIZE)
  lcd.drawText(2, 25, "github.com/DanNixon/RC_Configs", SMLSIZE)
end

-------------------------------------------------------------------------------

local g_screen
local g_numScreens

-- Channel order is TAER
local g_stickCommands = {
  {"Arm", {-1, 0, 0, 1}},
  {"Disarm", {-1, 0, 0, -1}},
  {"Profile 1", {-1, -1, 0, -1}},
  {"Profile 2", {-1, 0, 1, -1}},
  {"Profile 3", {-1, 1, 0, -1}},
  {"Calibrate Gyro", {-1, 0, -1, -1}},
  {"Calibrate Accelerometer", {1, 0, -1, -1}},
  {"Calibrate Compass", {1, 0, -1, 1}},
  {"In-Flight Calibration Controls", {-1, 1, 1, -1}},
  {"Trim Accelerometer Left", {1, -1, 0, 0}},
  {"Trim Accelerometer Right", {1, 1, 0, 0}},
  {"Trim Accelerometer Forwards", {1, 0, 1, 0}},
  {"Trim Accelerometer Backwards", {1, 0, -1, 0}},
  {"Disable LCD Page Cycle", {-1, -1, 1, 0}},
  {"Enable LCD Page Cycle", {-1, 1, 1, 0}},
  {"Save Settings", {-1, 1, -1, -1}},
  {"Enter Betaflight CMS", {0, 0, 1, -1}},
  {"About", nil}
}

-------------------------------------------------------------------------------

local function init_func()
  -- Count the number of defined screens
  g_screen = 1
  g_numScreens = 0
  while (g_stickCommands[g_screen] ~= nil) do
    g_screen = g_screen + 1
    g_numScreens = g_numScreens + 1
  end

  g_screen = 1
end

-------------------------------------------------------------------------------

local function run_func(event)
  -- Handle plus button (next page)
  if event == EVT_PLUS_BREAK then
    g_screen = g_screen + 1
    if (g_screen > g_numScreens) then
      g_screen = 1
    end
  -- Handle minus button (previous page)
  elseif event == EVT_MINUS_BREAK then
    g_screen = g_screen - 1
    if (g_screen < 1) then
      g_screen = g_numScreens
    end
  -- Handle exit button (terminate)
  elseif event == EVT_EXIT_BREAK then
    return 1
  end

  -- Redraw
  lcd.clear()
  lcd.drawScreenTitle(g_stickCommands[g_screen][1], g_screen, g_numScreens)

  local stickPositions = g_stickCommands[g_screen][2]
  if stickPositions ~= nil then
    drawSticks(stickPositions)
  else
    drawAbout()
  end

  return 0
end

-------------------------------------------------------------------------------

return { init=init_func, run=run_func }
