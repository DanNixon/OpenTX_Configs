--- INI file loading and saving function.

local INI = {}


--- Saves a set of key/value pairs.
-- @param file File to save to
-- @param data Data to save
local function save_kv_pairs(file, data)
  -- For each key/value pair
  for key, value in pairs(data) do
    -- Ignore tables
    if type(value) ~= "table" then
      -- Convert boolean to string
      if type(value) == "boolean" and value then
        value = "true"
      elseif type(value) == "boolean" and not value then
        value = "false"
      end

      -- Output data line
      local line = key .. "=" .. value .. "\n"
      io.write(file, line)
    end
  end
end


--- Loads data from an INI file to a table.
-- @param filename Filename to load from
-- @return Data as table
function INI.loadFile(filename)
  -- Number of bytes to read in each iteration
  local read_chunk_size = 50

  -- Open file
  local file = io.open(filename, "r")

  -- Return nothing if file cannot be opened
  if not file then
    return nil
  end

  local data = {}

  -- Current section name
  local current_header = nil

  -- Buffer for file contents
  local text = ''

  -- Read file in chunks
  while true do
    local text_segment = io.read(file, read_chunk_size)

    -- Append a newline if this was the end of the file
    if #text_segment < read_chunk_size and #text_segment > 0 then
      text_segment = text_segment .. "\n"
    end

    -- Append the chunk just read to the buffer
    text = text .. text_segment

    -- Check if there is a full like in the buffer
    if string.match(text, "\n") then
      -- Extract the line and remove it from the buffer
      local newline_pos = string.find(text, "\n")
      local line = string.sub(text, 1, newline_pos - 1)
      text = string.sub(text, newline_pos + 1)

      -- Match section header and key/value pairs
      local header_start, header_end = string.find(line, "%[[%s%w]*%]")
      local key, value = string.match(line, "%s*([-_%w]+)%s*=%s*([-_%w]+)%s*")

      -- If a header was found
      if header_start then
        -- Extract the section name
        current_header = string.sub(line, header_start + 1, header_end - 1)

        if string.len(current_header) == 0 then
          current_header = nil
        end
      -- If a key/value pair was found
      elseif key and value then
        if current_header then
          -- Create the table for the section if it does not already exist
          if not data[current_header] then
            data[current_header] = {}
          end

          data[current_header][key] = value
        else
          data[key] = value
        end
      end
    end

    -- Leave loop when buffer is empty (entire file has been read)
    if #text == 0 then
      break
    end
  end

  -- Close the file
  io.close(file)

  return data
end


--- Saves a table as an INI file.
-- @param filename Filename to save to
-- @param data Table to save
function INI.saveFile(filename, data)
  -- Open file
  local file = io.open(filename, "w")

  -- Output key/vaue pairs in default (no) section
  save_kv_pairs(file, data)

  -- Seperate sections with empty line
  io.write(file, "\n")

  -- Output tables (INI sections)
  for key, value in pairs(data) do
    if type(value) == "table" then
      -- Output section header
      local header_line = "[" .. key .. "]\n"
      io.write(file, header_line)

      -- Output key/value pairs
      save_kv_pairs(file, value)

      -- Seperate sections with empty line
      io.write(file, "\n")
    end
  end

  -- Close file
  io.close(file)
end


return INI
