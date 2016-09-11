local PRINTER = {}


--- Converts a value to a string.
-- @param v Value
-- @return String representation of value
function PRINTER.to_string(v)
  local s

  if v == nil then
    s = "null"
  else
    s = tostring(v)
  end

  return s
end


--- Converts a string to the correct type.
-- @param s String to convert
-- @return Value of string in the correct type
function PRINTER.from_string(s)
  local v

  if s == "null" or s == "nil" then
    v = nil
  elseif s == "true" then
    v = true
  elseif s == "false" then
    v = false
  elseif tonumber(s) then
    v = tonumber(s)
  else
    v = s
  end

  return v
end


--- Formats a time in seconds to a string of H:MM:SS.
-- @param t_sec Time in seconds
-- @return Time string
function PRINTER.seconds_to_time(t_sec)
  local sec = t_sec % 60
  local min_f = math.floor(t_sec / 60)
  local min = min_f % 60
  local hour = math.floor(min_f / 60)
  return string.format("%01d:%02d:%02d", hour, min, sec)
end


--- Creates an RFC3339 timestamp string from a date-time table.
-- @param dt OpenTX date-time table
-- @return RFC3339 formatted string
function PRINTER.rfc3339(dt)
  return string.format("%04d-%02d-%02dT%02d:%02d:%02dZ",
                       dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec)
end


--- Prints a table.
-- @param t Table
-- @param level Recrusion level (do not set when calling)
function PRINTER.table(t, level)
  local prefix = ""
  level = level or 0

  for i=0,level,1 do
    prefix = prefix .. " "
  end

  if not t then
    print(prefix .. "nil")
    return
  end

  for key, value in pairs(t) do
    if type(value) == "table" then
      print(prefix .. key .. "=")
      PRINTER.table(value, level + 1)
    else
      print(prefix .. key .. "=" .. PRINTER.to_string(value))
    end
  end
end


return PRINTER
