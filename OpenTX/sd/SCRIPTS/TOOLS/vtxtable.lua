-- VTX channel table adapted to run from file browser.
-- http://helpmefpv.com/2016/03/16/5-8ghz-vtx-channel-chart-for-frsky-taranis/

-------------------------------------------------------------------------------

local function drawDipSwitch(x, y, numSwitches, positions, labelText, labelTextFlags)
  local switchPadding = 2
  local outerPadding = 1
  local switchWidth = 5
  local switchHeight = 9

  -- Draw outer rect
  local rw = (2 * outerPadding) + switchPadding + ((switchWidth + switchPadding) * numSwitches)
  local rh = (2 * (switchPadding + outerPadding)) + switchHeight
  lcd.drawRectangle(x, y, rw, rh)

  -- Draw switches
  local sy = y + outerPadding + switchPadding
  local halfSwitchHeight = switchHeight / 2
  for i = 1,numSwitches do
    local sx = x + outerPadding + switchPadding + ((i - 1) * (switchPadding + switchWidth))
    lcd.drawRectangle(sx, sy, switchWidth, switchHeight)

    -- Set switch state
    local swState = positions[i]
    if swState ~= nil then
      swState = (swState + 1) % 2
      local spy = sy + 1 + (halfSwitchHeight * swState)
      lcd.drawFilledRectangle(sx, spy, switchWidth, halfSwitchHeight - 1, FORCE)
    end
  end

  -- Draw label
  if labelText ~= nil then
    local tx = x + rw + (2 * outerPadding)
    local ty = y + 4
    lcd.drawText(tx, ty, labelText, labelTextFlags)
  end
end

-------------------------------------------------------------------------------

local function drawFreqTable()
  lcd.drawLine(1, 10, 208, 10, SOLID, FORCE)
  lcd.drawText(20, 2, "1", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "2", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "3", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "4", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "5", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "6", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "7", 0)
  lcd.drawText(lcd.getLastPos() + 20, 2, "8", 0)

  lcd.drawText(2, 12, "F", 0)
  lcd.drawLine(lcd.getLastPos() + 2, 1, lcd.getLastPos() + 2, 60, SOLID, FORCE)
  lcd.drawLine(1, 20, 208, 20, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5740", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5760", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5780", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5800", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5820", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5840", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5860", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 12, "5880", 0)
  lcd.drawLine(lcd.getLastPos() + 1,  1, lcd.getLastPos() + 1, 60, SOLID, FORCE)

  lcd.drawText(2, 22, "A", 0)
  lcd.drawLine(1, 30, 208, 30, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5865", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5845", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5825", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5805", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5785", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5765", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5745", 0)
  lcd.drawText(lcd.getLastPos() + 5, 22, "5725", 0)

  lcd.drawText(2, 32, "B", 0)
  lcd.drawLine(1, 40, 208, 40, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5733", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5752", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5771", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5790", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5809", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5828", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5847", 0)
  lcd.drawText(lcd.getLastPos() + 5, 32, "5866", 0)

  lcd.drawText(2, 42, "E", 0)
  lcd.drawLine(1, 50, 208, 50, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5705", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5685", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5665", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5645", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5885", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5905", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5925", 0)
  lcd.drawText(lcd.getLastPos() + 5, 42, "5945", 0)

  lcd.drawText(2, 52, "R", 0)
  lcd.drawLine(1, 60, 208, 60, SOLID, FORCE)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5658", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5695", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5732", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5769", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5806", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5843", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5880", 0)
  lcd.drawText(lcd.getLastPos() + 5, 52, "5917", 0)

  return nil
end

-------------------------------------------------------------------------------

local function drawDIPSwitchLegend()
  drawDipSwitch(5, 13, 1, {1}, "UP")
  drawDipSwitch(100, 13, 1, {0}, "DOWN")
  drawDipSwitch(5, 35, 1, {nil}, "Not Important")
  return "DIP switch legend"
end

-------------------------------------------------------------------------------

local function drawNexWaveVRXBandDIP()
  drawDipSwitch(5, 13, 2, {1, 0}, "BOSCAM A")
  drawDipSwitch(5, 35, 2, {0, 1}, "BOSCAM E")
  drawDipSwitch(100, 13, 2, {0, 0}, "IRC/FATSHARK")
  drawDipSwitch(100, 35, 2, {1, 1}, "RACEBAND")
  return "NexWave vRX Band Select DIP switch"
end

-------------------------------------------------------------------------------

local function drawAbout()
  lcd.drawText(2, 10, "5.8GHz FPV cheatsheet", MIDSIZE)
  lcd.drawText(2, 25, "github.com/DanNixon/RC_Configs", SMLSIZE)
  return "About"
end

-------------------------------------------------------------------------------

local g_screen
local g_numScreens

local g_screenFunctions = {
  drawFreqTable,
  drawDIPSwitchLegend,
  drawNexWaveVRXBandDIP,
  drawAbout
}

-------------------------------------------------------------------------------

local function init_func()
  -- Count the number of defined screens
  g_screen = 1
  g_numScreens = 0
  while (g_screenFunctions[g_screen] ~= nil) do
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
  local name = g_screenFunctions[g_screen]()

  -- Draw title if this screen has a name
  if name ~= nil then
    lcd.drawScreenTitle(name, g_screen, g_numScreens)
  end

  return 0
end

-------------------------------------------------------------------------------

return { init=init_func, run=run_func }
