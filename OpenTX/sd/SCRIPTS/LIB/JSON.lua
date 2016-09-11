--- JSON file loading and saving functions.
--
-- Based on the JSON4Lua module:
-- Author: Craig Mason-Jones
-- Homepage: http://github.com/craigmj/json4lua/
-- Version: 1.0.0
-- This module is released under the MIT License (MIT).

local JSON = {}
local JSON_private = {}

-- Private functions
local decode_scanArray
local decode_scanComment
local decode_scanConstant
local decode_scanNumber
local decode_scanObject
local decode_scanString
local decode_scanWhitespace
local encodeString
local isArray
local isEncodable
local tableStrConcat
local tableGetN

-------------------------------------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------------------------------------

--- Loads data from a JSON file to a table.
-- @param filename Filename to load from
-- @param bytes Maximim length of read buffer
-- @return Data as table
function JSON.loadFile(filename, bytes)
  -- Open file
  local file = io.open(filename, "r")

  -- Return nothing if file cannot be opened
  if not file then
    return nil
  end

  bytes = bytes or 500

  -- Parse data
  local json_str = io.read(file, bytes)
  local data = JSON.decode(json_str)

  -- Close file
  io.close(file)

  return data
end


--- Saves a table as a JSON file.
-- @param filename Filename to save to
-- @param data Table to save
function JSON.saveFile(filename, data)
  -- Open file
  local file = io.open(filename, "w")

  -- Output data
  JSON.encode(file, data)

  -- Close file
  io.close(file)
end


--- Encodes an arbitrary Lua object / variable.
-- @param file File to save JSON data to
-- @param v The Lua object / variable to be JSON encoded.
-- @return String containing the JSON encoding in internal Lua string format (i.e. not unicode)
function JSON.encode(file, v)
  -- Handle nil values
  if v==nil then
    io.write(file, "null")
    return
  end

  local vtype = type(v)

  -- Handle strings
  if vtype=='string' then
    io.write(file, '"')
    io.write(file, JSON_private.encodeString(v))
    io.write(file, '"')
    return
  end

  -- Handle booleans
  if vtype=='number' or vtype=='boolean' then
    io.write(file, tostring(v))
    return
  end

  -- Handle tables
  if vtype=='table' then
    local bArray, maxCount = isArray(v)

    if bArray then
      io.write(file, '[')
    else
      io.write(file, '{')
    end

    -- Consider arrays separately
    if bArray then
      for i = 1,maxCount do
        if i > 1 then
          io.write(file, ',')
        end

        JSON.encode(file, v[i])
      end
      -- An object, not an array
    else
      local first = true
      for i,j in pairs(v) do
        if isEncodable(i) and isEncodable(j) then
          if first then
            first = false
          else
            io.write(file, ',')
          end

          io.write(file, '"')
          io.write(file, JSON_private.encodeString(i))
          io.write(file, '":')
          JSON.encode(file, j)
        end
      end
    end

    if bArray then
      io.write(file, ']')
    else
      io.write(file, '}')
    end

    return
  end

  -- Handle null values
  if vtype=='function' and v==null then
    io.write(file, 'null')
    return
  end

  assert(false)
end


--- Decodes a JSON string and returns the decoded value as a Lua data structure / value.
-- @param s The string to scan.
-- @param [startPos] Optional starting position where the JSON string is located. Defaults to 1.
-- @param Lua object, number The object that was scanned, as a Lua table / string / number / boolean or nil,
-- and the position of the first character after
-- the scanned JSON object.
function JSON.decode(s, startPos)
  startPos = startPos and startPos or 1
  startPos = decode_scanWhitespace(s,startPos)
  assert(startPos<=string.len(s))
  local curChar = string.sub(s,startPos,startPos)
  -- Object
  if curChar=='{' then
    return decode_scanObject(s,startPos)
  end
  -- Array
  if curChar=='[' then
    return decode_scanArray(s,startPos)
  end
  -- Number
  if string.find("+-0123456789.e", curChar, 1, true) then
    return decode_scanNumber(s,startPos)
  end
  -- String
  if curChar==[["]] or curChar==[[']] then
    return decode_scanString(s,startPos)
  end
  if string.sub(s,startPos,startPos+1)=='/*' then
    return decode(s, decode_scanComment(s,startPos))
  end
  -- Otherwise, it must be a constant
  return decode_scanConstant(s,startPos)
end


--- The null function allows one to specify a null value in an associative array (which is otherwise
-- discarded if you set the value with 'nil' in Lua. Simply set t = { first=JSON.null }
function null()
  return null -- so JSON.null() will also return null ;-)
end

-------------------------------------------------------------------------------
-- Internal, PRIVATE functions.
-- Following a Python-like convention, I have prefixed all these 'PRIVATE'
-- functions with an underscore.
-------------------------------------------------------------------------------

--- Scans an array from JSON into a Lua object
-- startPos begins at the start of the array.
-- Returns the array and the next starting position
-- @param s The string being scanned.
-- @param startPos The starting position for the scan.
-- @return table, int The scanned array as a table, and the position of the next character to scan.
function decode_scanArray(s,startPos)
  local array = {}  -- The return value
  local stringLen = string.len(s)
  assert(string.sub(s,startPos,startPos)=='[')
  startPos = startPos + 1
  -- Infinite loop for array elements
  repeat
    startPos = decode_scanWhitespace(s,startPos)
    assert(startPos<=stringLen)
    local curChar = string.sub(s,startPos,startPos)
    if (curChar==']') then
      return array, startPos+1
    end
    if (curChar==',') then
      startPos = decode_scanWhitespace(s,startPos+1)
    end
    assert(startPos<=stringLen)
    object, startPos = JSON.decode(s,startPos)
    array[#array+1] = object
  until false
end


--- Scans a comment and discards the comment.
-- Returns the position of the next character following the comment.
-- @param string s The JSON string to scan.
-- @param int startPos The starting position of the comment
function decode_scanComment(s, startPos)
  assert(string.sub(s,startPos,startPos+1)=='/*')
  local endPos = string.find(s,'*/',startPos+2)
  assert(endPos~=nil)
  return endPos+2
end


--- Scans for given constants: true, false or null
-- Returns the appropriate Lua type, and the position of the next character to read.
-- @param s The string being scanned.
-- @param startPos The position in the string at which to start scanning.
-- @return object, int The object (true, false or nil) and the position at which the next character should be
-- scanned.
function decode_scanConstant(s, startPos)
  local consts = { ["true"] = true, ["false"] = false, ["null"] = nil }
  local constNames = {"true","false","null"}

  for i,k in pairs(constNames) do
    if string.sub(s,startPos, startPos + string.len(k) -1 )==k then
      return consts[k], startPos + string.len(k)
    end
  end
  assert(nil)
end


--- Scans a number from the JSON encoded string.
-- Returns the number, and the position of the next character
-- after the number.
-- @param s The string being scanned.
-- @param startPos The position at which to start scanning.
-- @return number, int The extracted number and the position of the next character to scan.
function decode_scanNumber(s,startPos)
  local endPos = startPos+1
  local stringLen = string.len(s)
  local acceptableChars = "+-0123456789.e"
  while (string.find(acceptableChars, string.sub(s,endPos,endPos), 1, true)
    and endPos<=stringLen
    ) do
    endPos = endPos + 1
  end
  local stringValue = string.sub(s,startPos, endPos-1)
  local stringEval = tonumber(stringValue)
  assert(stringEval)
  return stringEval, endPos
end


--- Scans a JSON object into a Lua object.
-- startPos begins at the start of the object.
-- Returns the object and the next starting position.
-- @param s The string being scanned.
-- @param startPos The starting position of the scan.
-- @return table, int The scanned object as a table and the position of the next character to scan.
function decode_scanObject(s,startPos)
  local object = {}
  local stringLen = string.len(s)
  local key, value
  assert(string.sub(s,startPos,startPos)=='{')
  startPos = startPos + 1
  repeat
    startPos = decode_scanWhitespace(s,startPos)
    assert(startPos<=stringLen)
    local curChar = string.sub(s,startPos,startPos)
    if (curChar=='}') then
      return object,startPos+1
    end
    if (curChar==',') then
      startPos = decode_scanWhitespace(s,startPos+1)
    end
    assert(startPos<=stringLen)
    -- Scan the key
    key, startPos = JSON.decode(s,startPos)
    assert(startPos<=stringLen)
    startPos = decode_scanWhitespace(s,startPos)
    assert(startPos<=stringLen)
    assert(string.sub(s,startPos,startPos)==':')
    startPos = decode_scanWhitespace(s,startPos+1)
    assert(startPos<=stringLen)
    value, startPos = JSON.decode(s,startPos)
    object[key]=value
  until false -- infinite loop while key-value pairs are found
end


-- START SoniEx2
-- Initialize some things used by decode_scanString
-- You know, for efficiency
local escapeSequences = {
  ["\\t"] = "\t",
  ["\\f"] = "\f",
  ["\\r"] = "\r",
  ["\\n"] = "\n",
  ["\\b"] = "\b"
}
setmetatable(escapeSequences, {__index = function(t,k)
  -- skip "\" aka strip escape
  return string.sub(k,2)
end})
-- END SoniEx2


--- Scans a JSON string from the opening inverted comma or single quote to the
-- end of the string.
-- Returns the string extracted as a Lua string,
-- and the position of the next non-string character
-- (after the closing inverted comma or single quote).
-- @param s The string being scanned.
-- @param startPos The starting position of the scan.
-- @return string, int The extracted string as a Lua string, and the next character to parse.
function decode_scanString(s,startPos)
  assert(startPos)
  local startChar = string.sub(s,startPos,startPos)
  -- START SoniEx2
  -- PS: I don't think single quotes are valid JSON
  assert(startChar == [["]] or startChar == [[']])
  local t = {}
  local i,j = startPos,startPos
  while string.find(s, startChar, j+1) ~= j+1 do
    local oldj = j
    i,j = string.find(s, "\\.", j+1)
    local x,y = string.find(s, startChar, oldj+1)
    if not i or x < i then
      i,j = x,y-1
    end
    t[#t+1] = string.sub(s, oldj+1, i-1)
    if string.sub(s, i, j) == "\\u" then
      local a = string.sub(s,j+1,j+4)
      j = j + 4
      local n = tonumber(a, 16)
      assert(n)
      -- math.floor(x/2^y) == lazy right shift
      -- a % 2^b == bitwise_and(a, (2^b)-1)
      -- 64 = 2^6
      -- 4096 = 2^12 (or 2^6 * 2^6)
      local x
      if n < 0x80 then
        x = string.char(n % 0x80)
      elseif n < 0x800 then
        -- [110x xxxx] [10xx xxxx]
        x = string.char(0xC0 + (math.floor(n/64) % 0x20), 0x80 + (n % 0x40))
      else
        -- [1110 xxxx] [10xx xxxx] [10xx xxxx]
        x = string.char(0xE0 + (math.floor(n/4096) % 0x10), 0x80 + (math.floor(n/64) % 0x40), 0x80 + (n % 0x40))
      end
      t[#t+1] = x
    else
      t[#t+1] = string.sub(s, i, j)
    end
  end
  t[#t+1] = string.sub(j, j+1)
  assert(string.find(s, startChar, j+1))
  return tableStrConcat(t), j+2
  -- END SoniEx2
end


--- Scans a JSON string skipping all whitespace from the current start position.
-- Returns the position of the first non-whitespace character, or nil if the whole end of string is reached.
-- @param s The string being scanned
-- @param startPos The starting position where we should begin removing whitespace.
-- @return int The first position where non-whitespace was encountered, or string.len(s)+1 if the end of string
-- was reached.
function decode_scanWhitespace(s,startPos)
  local whitespace=" \n\r\t"
  local stringLen = string.len(s)
  while ( string.find(whitespace, string.sub(s,startPos,startPos), 1, true)  and startPos <= stringLen) do
    startPos = startPos + 1
  end
  return startPos
end


local escapeList = {
  ['"']  = '\\"',
  ['\\'] = '\\\\',
  ['/']  = '\\/',
  ['\b'] = '\\b',
  ['\f'] = '\\f',
  ['\n'] = '\\n',
  ['\r'] = '\\r',
  ['\t'] = '\\t'
}

--- Encodes a string to be JSON-compatible.
-- This just involves back-quoting inverted commas, back-quotes and newlines, I think ;-)
-- @param s The string to return as a JSON encoded (i.e. backquoted string)
-- @return The string appropriately escaped.
function JSON_private.encodeString(s)
  local s = tostring(s)
  s = string.gsub(s, ".", function(c) return escapeList[c] end) -- SoniEx2: 5.0 compat
  return s
end


-- Determines whether the given Lua type is an array or a table / dictionary.
-- We consider any table an array if it has indexes 1..n for its n items, and no
-- other data in the table.
-- I think this method is currently a little 'flaky', but can't think of a good way around it yet...
-- @param t The table to evaluate as an array
-- @return boolean, number True if the table can be represented as an array, false otherwise. If true,
-- the second returned value is the maximum
-- number of indexed elements in the array.
function isArray(t)
  -- Next we count all the elements, ensuring that any non-indexed elements are not-encodable
  -- (with the possible exception of 'n')
  local maxIndex = 0
  for k,v in pairs(t) do
    if (type(k)=='number' and math.floor(k)==k and 1<=k) then -- k,v is an indexed pair
      if (not isEncodable(v)) then return false end -- All array elements must be encodable
      maxIndex = math.max(maxIndex,k)
    else
      if (k=='n') then
        if v ~= tableGetN(t) then return false end  -- False if n does not hold the number of elements
      else -- Else of (k=='n')
        if isEncodable(v) then return false end
      end  -- End of (k~='n')
    end -- End of k,v not an indexed pair
  end  -- End of loop across all pairs
  return true, maxIndex
end


--- Determines whether the given Lua object / table / variable can be JSON encoded. The only
-- types that are JSON encodable are: string, boolean, number, nil, table and JSON.null.
-- In this implementation, all other types are ignored.
-- @param o The object to examine.
-- @return boolean True if the object should be JSON encoded, false if it should be ignored.
function isEncodable(o)
  local t = type(o)
  return (t=='string' or t=='boolean' or t=='number' or t=='nil' or t=='table') or (t=='function' and o==null)
end

function tableStrConcat(t)
  local s = ""
  for i = 1, #t do
    s = s .. t[i]
  end
  return s
end

--- Gets the length of a table.
-- @param t Table
-- @return Length, n
function tableGetN(t)
  local n = 0
  for i = 1, #t do
    if t[i] ~= nil then
      n = n + 1
    end
  end
  return n
end

return JSON
