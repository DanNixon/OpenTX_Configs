-- RSSI Model Locator
-- Modified from the original version by Scott Bauer

local g_nextPlayTime

local function init_func()
  g_nextPlayTime = getTime()
end

local function run_func(event)
  lcd.clear()

  lcd.drawScreenTitle("RSSI Model Locator", 1, 1)

  lcd.drawNumber(210, 10, getValue("RSSI"), XXLSIZE)
  lcd.drawText(187, 54, "RSSI", 0)

  if getTime() >= g_nextPlayTime then
    local rssi = getValue("RSSI")
    playTone(2000 + (10 * rssi), 2 * (-rssi + 140), 10)
    g_nextPlayTime = getTime() + 105 - rssi
  end
end

return { init=init_func, run=run_func }
