-- Hourai model session logger.

local PRINTER = (loadfile("/SCRIPTS/LIB/PRINTER.lua"))()
local JSON = (loadfile("/SCRIPTS/LIB/JSON.lua"))()


local g_configFilename = "/HOURAI/config.json"
local g_logDirectory = "/HOURAI/LOGS/"
local g_sessionTemplateFilename = "/HOURAI/session_template.json"

local g_modelName = nil
local g_activeLogicalSwIdx = 0
local g_activeInputId = nil

local g_selectedFieldIdx = 1
local g_fieldEditMode = false

local g_config = nil
local g_activeModel = nil
local g_session = nil


--- Converts a date-time table to filename friendly string.
-- @param dt Datetime table
-- @return Filename friendly string
local function timeToTitle(dt)
  local datetime_str = string.format("%04d-%02d-%02dT%02d_%02d_%02dZ", dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec)
  return datetime_str
end


--- Writes the session cache to disk.
local function saveSessionFile()
  if g_session then
    print("Hourai: saving session state")

    local filename = g_logDirectory .. g_session.title .. ".json"
    JSON.saveFile(filename, g_session)
  end
end


--- Writes the config file to disk.
local function saveConfigFile()
  print("Hourai: saving config file")
  JSON.saveFile(g_configFilename, g_config)
end


--- Stores the model speciifc configuration in the file and saves to disk.
local function storeModelConfig()
  g_activeInputId = getFieldInfo("ls" .. (g_activeLogicalSwIdx + 1)).id
  g_config.model_active_inputs[model.getInfo().name] = g_activeLogicalSwIdx
  saveConfigFile()
end


--- Reads the model specific configuration.
local function readModelConfig()
  g_activeLogicalSwIdx = g_config.model_active_inputs[model.getInfo().name]
  if not g_activeLogicalSwIdx then
    g_activeLogicalSwIdx = 0
    storeModelConfig()
  end
  g_activeInputId = getFieldInfo("ls" .. (g_activeLogicalSwIdx + 1)).id
end


--- Gets the active model from the session data.
-- Inserts the model if it is not already in the cache.
-- @return Model data table
local function getModelFromSession()
  -- Must have both active session and active model
  if not (g_activeModel and g_session) then
    return nil
  end

  -- Get model name
  local model_name = g_activeModel.name

  -- Iterate through models
  for key, model in pairs(g_session.models) do
    if model.model_name == model_name then
      return model
    end
  end

  -- Could not find model in session cache
  return nil
end


--- Gets the active duration of the active model as a string.
-- @return Time as string "-" if no model or session is active
local function getActiveModelTimeStr()
  if g_activeModel and g_session then
    local model = getModelFromSession()
    if model then
      local time_s = model.time + (getTime() - g_activeModel.start_time) / 100.0
      return PRINTER.seconds_to_time(time_s)
    end
  end
  return "-"
end


--- Handles the start of model use.
local function modelStart()
  -- Stop the existing model if one is active
  if g_activeModel then
    if g_activeModel.name ~= model.getInfo().name then
      modelEnd()
    else
      return
    end
  end

  -- Do nothing if a session is not in progress
  if not g_session then
    return
  end

  print("Hourai: model start")

  g_activeModel = {
    name = model.getInfo().name,
    start_time = getTime()
  }

  -- Check if model is in the cache
  local model = getModelFromSession()
  if not model then
    -- Add it if it is not
    local new_model = {
      model_name = g_activeModel.name,
      time = 0.0,
      description = ""
    }

    g_session.models[#g_session.models + 1] = new_model
  end
end


--- Handles the end of use of the active model.
local function modelEnd()
  -- Do nothing if a model is not active
  if not g_activeModel then
    return
  end

  -- Do nothing if a session is not in progress
  if not g_session then
    -- Reset active model cache
    g_activeModel = nil

    return
  end

  print("Hourai: model end")

  -- Calculate operation time
  local delta_t = (getTime() - g_activeModel.start_time) / 100.0

  -- Update session cache file
  local model = getModelFromSession()
  model.time = model.time + delta_t

  -- Write changes to the session file
  saveSessionFile()

  -- Remove the active model cache
  g_activeModel = nil
end


--- Handles the start of a session.
local function sessionStart()
  print("Hourai: session start")

  -- Load the session template file
  g_session = JSON.loadFile(g_sessionTemplateFilename)
  if not g_session then
    error("No default session JSON file found")
    return
  end

  local start_time = getDateTime()

  -- Set start time and title
  g_session["start"] = PRINTER.rfc3339(start_time)
  g_session["title"] = timeToTitle(start_time)

  -- Save and lock session file
  g_config.locked_session = g_session["title"]
  saveSessionFile()
  saveConfigFile()
end


--- Handles the end of a session.
local function sessionEnd()
  print("Hourai: session end")

  -- End any active model first
  modelEnd()

  -- Add end timestamp to session
  g_session["end"] = PRINTER.rfc3339(getDateTime())

  -- Save and unlock session file
  saveSessionFile()
  g_config.locked_session = nil
  saveConfigFile()

  -- Remove session cache
  g_session = nil
end


--- Gets display flags for a given field.
-- @param field Field index
-- @return Flags
local function getFieldFlags(field)
  local flag = 0

  if field == g_selectedFieldIdx then
    flag = INVERS

    if g_fieldEditMode then
      flag = INVERS + BLINK
    end
  end

  return flag
end


local function editField(event, value, max)
  if event == EVT_PLUS_FIRST then
    value = value + 1
  elseif event == EVT_MINUS_FIRST then
    value = value - 1
  end

  value = value % (max + 1)

  return value
end


local function init()
  print("Hourai: init")

  -- Try to load the config
  g_config = JSON.loadFile(g_configFilename)
  if not g_config then
    g_config = {locked_session=nil, model_active_inputs={}}
    saveConfigFile()
  end

  -- If a locked session was found
  if g_config.locked_session then
    -- Load old session if session lock file exists
    local log_filename = g_logDirectory .. g_config.locked_session .. ".json"
    g_session = JSON.loadFile(log_filename)

    -- If no data was loaded then remove the lock
    if not g_session then
      g_config.locked_session = nil
      saveConfigFile()
    end
  end
end


local function background()
  if g_session and g_activeInputId then
    local active = getValue(g_activeInputId) > 0

    if active and g_activeModel == nil then
      modelStart()
    elseif not active then
      modelEnd()
    end
  end
end


local function run(event)
  background()

  -- Check if the model has been changed
  if model.getInfo().name ~= g_modelName then
    g_modelName = model.getInfo().name
    readModelConfig()
  end

  -- Handle events
  -- If enter is pressed
  if event == EVT_ENTER_BREAK then
    -- If on start/stop session button
    if g_selectedFieldIdx == 1 then
      if g_session == nil then
        sessionStart()
      else
        sessionEnd()
      end
    -- If on any other field
    else
      if g_fieldEditMode then
        storeModelConfig()
      end
      g_fieldEditMode = not g_fieldEditMode
    end
  -- All other events
  else
    -- If editing a field (currently only one editable field)
    if g_fieldEditMode and g_selectedFieldIdx == 0 then
      g_activeLogicalSwIdx = editField(event, g_activeLogicalSwIdx, 31)
    -- If selecting a field
    else
      g_selectedFieldIdx = editField(event, g_selectedFieldIdx, 1)
    end
  end

  -- Draw LCD
  lcd.clear()
  lcd.drawScreenTitle("Hourai Logger", 1, 1)

  local x_offset = 100

  local session_name = "-"
  if g_session ~= nil then
    session_name = g_session["title"]
  end

  -- Model active logical switch
  lcd.drawText(1, 11, "Active lg. switch", 0)
  lcd.drawNumber(x_offset, 11, g_activeLogicalSwIdx + 1, getFieldFlags(0) + LEFT)

  -- Current session start time
  lcd.drawText(1, 22, "Session name", 0)
  lcd.drawText(x_offset, 22, session_name, 0)

  -- Active model time
  lcd.drawText(1, 34, "Model time", 0)
  lcd.drawText(x_offset, 34, getActiveModelTimeStr(), 0)

  -- Session start/stop option
  local option_text = "Start session"
  if g_session ~= nil then
    option_text = "Stop session"
  end
  lcd.drawText(x_offset, 46, option_text, getFieldFlags(1))
end


return { init=init, background=background, run=run }
