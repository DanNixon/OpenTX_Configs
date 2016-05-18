-- Code by Nek v1.0.0
--
local aileronChannel = 2
local elevatorChannel = 3
local throttleChannel = 1
local rudderChannel = 4

local aileronChan = aileronChannel - 1
local elevatorChan = elevatorChannel - 1
local throttleChan = throttleChannel - 1
local rudderChan = rudderChannel - 1
local sendTime = 100
local headersTable = {"Load PID", "Calibrate", "Trim Acc", ""}
local optionsTable = {{"Profile 1", "Profile 2", "Profile 3"}, {"Gyro", "Acc", "Mag", "Inflight"}, {"Left", "Right", "Forwards", "Backwards"}, {"Save settings"}}
local boxLocs = {{48, 16, 59},{55, 16, 55},{48, 16, 66},{60, 26, 86}}
local maxFieldTable = {2,3,3,0}
local confirmTable = {"Yes", "No"}
local sendingStickPositions = false
local count = 0
local selectedOption = 0
local selectedPage = 1
local maxPages = 4
local confirmMsg = false
local confirmSelected = 1

local function editMix(channel, set, remove)
  mixCount = model.getMixesCount(channel)
  if remove then
    mixtoDelete = mixCount - 1
    model.deleteMix(channel, mixtoDelete)
    return 1
  end
  source = channel + 1
  mix = {}
  mix.name = "Lua"
  mix.source = source
  mix.weight = 0
  mix.offset = set
  mix.switch = 0
  mix.multiplex = 2
  model.insertMix(channel, mixCount, mix)
  return 0
end

local function fieldIncDec(event, value, max)
  if event == EVT_MINUS_FIRST then
    killEvents(event)
    value = (value + 1)
  elseif event == EVT_PLUS_FIRST then
    killEvents(event)
    value = (value - 1)
  end
  if value < 0 then
      value = max
    elseif value > max then
      value = 0
    end
  return value
end

local function sendPositions(thr, rud, ele, ail, delete)
  editMix(aileronChan, ail, delete)
  editMix(elevatorChan, ele, delete)
  editMix(throttleChan, thr, delete)
  editMix(rudderChan, rud, delete)
end

local function sendSticks()
  if selectedPage == 1 then
    if selectedOption == 0 then
      sendPositions(-100,-100,0,-100,false)
    elseif selectedOption == 1 then
      sendPositions(-100,-100,100,0,false)
    elseif selectedOption == 2 then
      sendPositions(-100,-100,0,100,false)
    end
  elseif selectedPage == 2 then
    if selectedOption == 0 then
      sendPositions(-100,-100,-100,0,false)
    elseif selectedOption == 1 then
      sendPositions(100,-100,-100,0,false)
    elseif selectedOption == 2 then
      sendPositions(100,100,-100,0,false)
    elseif selectedOption == 3 then
      sendPositions(-100,-100,100,100,false)
    end
  elseif selectedPage == 3 then
    if selectedOption == 0 then
      sendPositions(100,0,0,-100,false)
    elseif selectedOption == 1 then
      sendPositions(100,0,0,100,false)
    elseif selectedOption == 2 then
      sendPositions(100,0,100,0,false)
    elseif selectedOption == 3 then
      sendPositions(100,0,-100,0,false)
    end
  elseif selectedPage == 4 then
    if selectedOption == 0 then
      sendPositions(-100,-100,-100,100,false)
    end
  end
    sendingStickPositions = true
end

local function checkEvents(event)
  if event > 0 then
    if event == EVT_ENTER_BREAK then
      killEvents(event)
      confirmMsg = true
    elseif event == 96 then
      killEvents(event)
      selectedPage = selectedPage + 1
      if selectedPage > maxPages then
        selectedPage = 1
      end
      selectedOption = 0
    else
      selectedOption = fieldIncDec(event, selectedOption, maxFieldTable[selectedPage])
    end
  end
end

local function drawPage(event)
  lcd.drawText(4, 18, headersTable[selectedPage] , 0)
  lcd.drawCombobox(boxLocs[selectedPage][1],boxLocs[selectedPage][2],boxLocs[selectedPage][3],optionsTable[selectedPage],selectedOption,1)
  checkEvents(event)
end

local function run(event)
  if event == nil then
    error("Cannot be run as a model script!")
  end
  lcd.drawScreenTitle(" Cleanflight commands",selectedPage,maxPages)
  if sendingStickPositions then
    lcd.clear()
    lcd.lock()
    lcd.drawText(14, 28, "Transmitting Commands..." , MIDSIZE)
    count = count + 1
    if count > sendTime then
      sendPositions(0,0,0,0,true)
      sendingStickPositions = false
      count = 0
    end
  elseif confirmMsg then
    lcd.clear()
    lcd.lock()
    message = headersTable[selectedPage] .. " " .. optionsTable[selectedPage][selectedOption + 1] .. "?"
    lcd.drawText(10, 26, message , MIDSIZE)
    lcd.drawCombobox(191,22,30,confirmTable,confirmSelected,1)
    if event > 0 then
      if event == EVT_ENTER_BREAK then
        killEvents(event)
        if confirmSelected == 0 then
          sendSticks()
        end
        confirmMsg = false
        confirmSelected = 1
      elseif event == EVT_EXIT_BREAK then
        confirmMsg = false
        confirmSelected = 1
      else
        confirmSelected = fieldIncDec(event, confirmSelected, 1)
      end
    end
  else
    drawPage(event)
  end
  return 0
end

return { run=run }
