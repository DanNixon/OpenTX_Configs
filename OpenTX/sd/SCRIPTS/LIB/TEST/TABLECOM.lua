--- Test script for table compatibility module.

local PRINTER = (loadfile("../PRINTER.lua"))()
local table = (loadfile("../TABLECOM.lua"))()


local function init()
  -- insert
  local a = {}
  table.insert(a, "one")
  table.insert(a, "two")
  table.insert(a, "three")
  PRINTER.table(a)

  -- concat
  print(table.concat(a, ","))

  -- getn
  print(table.getn(a))
end


local function run(event)
  return 1
end


return { init=init, run=run }
