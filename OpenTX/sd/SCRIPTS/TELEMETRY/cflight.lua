-- TODO: WIP

local g_screen
local g_screenNames

-------------------------------------------------------------------------------

local function drawStatusBar(leftY, topY, lineType)
  local bottomY = topY + 17
  local midY = topY + 9
  local rightY = leftY + 92

  lcd.drawLine(leftY, bottomY, rightY, bottomY, lineType, FORCE)
  lcd.drawLine(leftY, topY, rightY, topY, lineType, FORCE)

  -- Separator
  lcd.drawLine(leftY, topY + 1, leftY, bottomY - 1, lineType, FORCE)

  -- Ready
  lcd.drawText(leftY + 2, topY + 1, "READY", DBLSIZE + INVERS)

  -- Separator
  lcd.drawLine(leftY + 57, topY + 1, leftY + 57, bottomY - 1, lineType, FORCE)

  -- Armed
  lcd.drawText(leftY + 59, topY + 1, "ARM", DBLSIZE + INVERS)

  -- Separator
  lcd.drawLine(leftY + 92, topY + 1, leftY + 92, bottomY - 1, lineType, FORCE)
end

-------------------------------------------------------------------------------

local function drawTelemetryScreen()
  drawStatusBar(118, 9, DOTTED)

  lcd.drawText(2, 10, "ACRO", DBLSIZE)
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
