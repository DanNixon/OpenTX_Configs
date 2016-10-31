-- VTX channel table adapted to run from file browser.
-- http://helpmefpv.com/2016/03/16/5-8ghz-vtx-channel-chart-for-frsky-taranis/

local function run_func(event)
  lcd.clear()

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

  return 0
end

return { run=run_func }
