local g_screen
local g_screenNames

-------------------------------------------------------------------------------

local function testStatusLineInvert(indicator)
  return INVERS
end

-------------------------------------------------------------------------------

local function drawStatusBar(topY, lineType)
  local bottomY = topY + 18
  local midY = topY + 9
  local endX = 211

  lcd.drawLine(0, bottomY, endX, bottomY, lineType, FORCE)
  lcd.drawLine(0, topY, endX, topY, lineType, FORCE)

  -- Ready
  lcd.drawText(1, topY + 1, "READY", DBLSIZE + testStatusLineInvert(0))
  lcd.drawLine(0, bottomY - 1, 55, bottomY - 1, SOLID, ERASE + testStatusLineInvert(0))

  -- Separator
  lcd.drawLine(56, topY + 1, 56, bottomY - 1, lineType, FORCE)

  -- Armed
  lcd.drawText(58, topY + 1, "ARM", DBLSIZE + testStatusLineInvert(1))
  lcd.drawLine(57, bottomY - 1, 90, bottomY - 1, SOLID, ERASE + testStatusLineInvert(1))

  -- Separator
  lcd.drawLine(91, topY + 1, 91, bottomY - 1, lineType, FORCE)

  -- Modes 1
  lcd.drawText(93, topY + 2, "ANGL", SMLSIZE + testStatusLineInvert(2))
  lcd.drawText(93, topY + 11, "HEAD", SMLSIZE + testStatusLineInvert(3))

  -- Separator
  lcd.drawLine(113, topY + 1, 113, bottomY - 1, lineType, FORCE)

  -- Modes 2
  lcd.drawText(115, topY + 2, "ACRO", SMLSIZE + testStatusLineInvert(4))
  lcd.drawText(115, topY + 11, "AIR_", SMLSIZE + testStatusLineInvert(5))

  -- Separator
  lcd.drawLine(135, topY + 1, 135, bottomY - 1, lineType, FORCE)

  -- Modes 3
  lcd.drawText(137, topY + 2, "BARO", SMLSIZE + testStatusLineInvert(6))
  lcd.drawText(137, topY + 11, "MAG_", SMLSIZE + testStatusLineInvert(7))

  -- Separator
  lcd.drawLine(157, topY + 1, 157, bottomY - 1, lineType, FORCE)

  -- Modes 4
  lcd.drawText(159, topY + 2, "GPSF", SMLSIZE + testStatusLineInvert(8))
  lcd.drawText(159, topY + 11, "GPSH", SMLSIZE + testStatusLineInvert(9))

  -- Separator
  lcd.drawLine(179, topY + 1, 179, bottomY - 1, lineType, FORCE)

  lcd.drawLine(91, midY, endX, midY, lineType, FORCE)
end

-------------------------------------------------------------------------------

local function drawTelemetryScreen()
  -- drawStatusBar(47, DOTTED)
  drawStatusBar(40, DOTTED)
end

-------------------------------------------------------------------------------

local function drawCommandsScreen()
  -- TODO
  lcd.drawText(1, 11, "TODO")
end

-------------------------------------------------------------------------------

local function init()
  g_screen = 1
  g_screenNames = {"CLEANFLIGHT TELEMETRY", "CLEANFLIGHT COMMANDS"}
end

-------------------------------------------------------------------------------

local function background()
  -- TODO
end

-------------------------------------------------------------------------------

local function run(event)
  background()

  if event == EVT_MENU_BREAK then
    g_screen = g_screen + 1
    if g_screen > 2 then
      g_screen = 1
    end
  end

  lcd.clear()
  lcd.drawScreenTitle(g_screenNames[g_screen], g_screen, 2)

  if g_screen == 1 then
    drawTelemetryScreen()
  elseif g_screen == 2 then
    drawCommandsScreen()
  end
end

-------------------------------------------------------------------------------

return { run=run, background=background, init=init }
