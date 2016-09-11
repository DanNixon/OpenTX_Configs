--- Test script for parsers.

local PRINTER = (loadfile("../PRINTER.lua"))()
local table = (loadfile("../TABLECOM.lua"))()
local INI = (loadfile("../INI.lua"))()
local JSON = (loadfile("../JSON.lua"))()


--- Test loading and saving INI files.
local function test_ini()
  -- Some data
  local data =
  {
    text = {
      line1 = "hello",
      line2 = "world"
    },
    one = 1,
    two = "two",
    obvious = true,
    more_text = {
      abc = 123
    }
  }

  local ini_filename = "TEST.ini"

  -- Save an INI file
  INI.saveFile(ini_filename, data)

  -- Load data back
  local loaded_ini_data = INI.loadFile(ini_filename)

  -- Output INI file contents to log
  PRINTER.table(loaded_ini_data, 0)
end


--- Test loading and saving JSON files.
local function test_json()
  -- Some data
  local data =
  {
    text = {
      line1 = "hello",
      line2 = "world"
    },
    one = 1,
    two = "two",
    obvious = true,
    more_text = {
      abc = 123,
      even_more_text = {
        yes = nil,
        this = "that"
      }
    },
    things = {}
  }

  table.insert(data.things, { name = "one"})
  table.insert(data.things, { name = "two"})
  table.insert(data.things, { name = "three"})
  table.insert(data.things, { name = "four"})
  table.insert(data.things, { name = "five"})

  local json_filename = "TEST.json"

  -- Save a JSON file
  JSON.saveFile(json_filename, data)

  -- Load data back
  local loaded_json_data = JSON.loadFile(json_filename)

  -- Output JSON file contents to log
  PRINTER.table(loaded_json_data, 0)
end


local function init()
  test_ini()
  test_json()
end


local function run(event)
  return 1
end


return { init=init, run=run }
