--- Table library compatability module.

local TABLECOM = {}

--- Appends an item ot an array.
-- @param t Table to insert into
-- @param v Value to insert
function TABLECOM.insert(t, v)
  local idx = #t + 1
  t[idx] = v
end


--- Returns a concatenated string of all table items.
-- @param t Table
-- @param delim Delimiter
-- @return Concatenated string
function TABLECOM.concat(t, delim)
  local s = ""
  for i = 1, #t do
    if i > 1 then
      s = s .. delim .. t[i]
    else
      s = s .. t[i]
    end
  end
  return s
end


--- Gets the length of a table.
-- @param t Table
-- @return Length, n
function TABLECOM.getn(t)
  local n = 0
  for i = 1, #t do
    if t[i] ~= nil then
      n = n + 1
    end
  end
  return n
end


return TABLECOM
