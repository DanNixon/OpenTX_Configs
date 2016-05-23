local g_screen

local g_batterySourceOptions
local g_batterySource
local g_cellVoltsFull
local g_cellVoltsWarn
local g_cellVoltsCritical

local g_selectedField
local g_numFields
local g_editing

local g_cells
local g_batteryVolts
local g_voltsPerCell

-------------------------------------------------------------------------------

local function fieldFlags(field)
  local flag = 0

  if g_selectedField == field then
    flag = INVERS

    if g_editing then
      flag = flag + BLINK
    end
  end

  return flag
end

-------------------------------------------------------------------------------

local function selectField()
end

-------------------------------------------------------------------------------

local function setValue()
end

-------------------------------------------------------------------------------

local function drawTelemScreen()
  -- TODO
  lcd.drawGauge(80, 10, 130, 52, g_batteryVolts, g_cells * g_cellVoltsFull)

  lcd.drawText(1, 45, "V/Cell:")
  lcd.drawNumber(45, 45, g_voltsPerCell, LEFT + PREC2)

  lcd.drawText(1, 55, "Cells:")
  lcd.drawNumber(45, 55, g_cells, LEFT)
end

-------------------------------------------------------------------------------

local function drawSettingsScreen()
  lcd.drawText(1, 12, "Voltage source", 0)
  lcd.drawCombobox(120, 10, 70, g_batterySourceOptions, g_batterySource, fieldFlags(0))

  lcd.drawText(1, 30, "Volts/cell full", 0)
  lcd.drawNumber(120, 30, g_cellVoltsWarn, fieldFlags(1) + LEFT + PREC2)

  lcd.drawText(1, 40, "Volts/cell warn", 0)
  lcd.drawNumber(120, 40, g_cellVoltsWarn, fieldFlags(2) + LEFT + PREC2)

  lcd.drawText(1, 50, "Volts/cell critical", 0)
  lcd.drawNumber(120, 50, g_cellVoltsCritical, fieldFlags(3) + LEFT + PREC2)
end

-------------------------------------------------------------------------------

local function init()
  g_screen = 0

  g_batterySourceOptions = {"VFAS", "Cels"}
  g_batterySource = 0
  g_cellVoltsFull = 420
  g_cellVoltsWarn = 350
  g_cellVoltsCritical = 330

  g_selectedField = 0
  g_numFields = 3
  g_editing = false

  g_cells = 0
  g_batteryVolts = 0
end

-------------------------------------------------------------------------------

local function background()
  -- TODO
  g_cells = 3
  g_batteryVolts = 1260

  g_voltsPerCell = g_batteryVolts / g_cells
end

-------------------------------------------------------------------------------

local function run(event)
  background()

  if event == EVT_MENU_BREAK then
    g_screen = (g_screen + 1) % 2
  end

  local screenName = "Battery Telemetry"
  if g_screen == 1 then
    screenName = screenName .. " - Settings"
  end

  lcd.clear()
  lcd.drawScreenTitle(screenName, g_screen + 1, 2)

  if g_screen == 0 then
    drawTelemScreen()
  elseif g_screen == 1 then
    drawSettingsScreen()
  end
end

-------------------------------------------------------------------------------

return { run=run, background=background, init=init }
