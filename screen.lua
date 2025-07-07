-- Module table
local S = {}

-- id  = 0
-- sda = 2
-- scl = 1
-- sla = 0x3C

-- local u8g2 = require("u8g2")
-- i2c.setup(id, sda, scl, i2c.SLOW)

-- local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

-- disp:clearBuffer()

-- disp:setFont(u8g2.font_6x10_tf)
-- disp:drawStr(0, 20, "Hello, world! Again")

-- disp:sendBuffer()


-- id  = 0
-- sda = 2
-- scl = 1
-- sla = 0x3C


-- local u8g2 = require("u8g2")
-- local parse = require("parse")
-- i2c.setup(id, sda, scl, i2c.SLOW)
-- local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)


-- local json = [[
--   {"data":{"stop":{"name":"Haapaniemi","stoptimesWithoutPatterns":[
--     {"realtimeArrival":4,"headsign":"Rautatientori"},
--     {"realtimeArrival":7,"headsign":"Kamppi"},
--     {"realtimeArrival":15,"headsign":"Otaniemi"}
--   ]}}}
-- ]]


-- local arrivals = parse.get_num_values(json, "realtimeArrival")


-- disp:clearBuffer()
-- disp:setFont(u8g2.font_6x10_tf)
-- disp:drawStr(0, 16, "Next Buses:")

-- if #arrivals == 0 then
--   disp:drawStr(0, 36, "No arrivals.")
-- else
--   local y = 36
--   for i = 1, math.min(3, #arrivals) do
--     local msg = "BUS: " .. arrivals[i] .. " sec"
--     disp:drawStr(0, y, msg)
--     y = y + 16
--   end
-- end

-- disp:sendBuffer()


-- id  = 0
-- sda = 2
-- scl = 1
-- sla = 0x3C

-- local u8g2 = require("u8g2")
-- i2c.setup(id, sda, scl, i2c.SLOW)

-- local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

-- local first  = "Hello, world! "
-- local second = "Hello, world! "

-- -- Font metrics for font_6x10_tf
-- local char_w = 6    -- each character is 6px wide
-- local char_h = 10   -- font height is 10px

-- -- Calculate width of the second string
-- local box_w = #second * char_w
-- local box_h = char_h

-- disp:clearBuffer()

-- -- 1) Normal text
-- disp:setFont(u8g2.font_6x10_tf)
-- disp:setDrawColor(1)                      -- 1 = draw pixels (white on black)
-- disp:drawStr(0, 20, first)

-- -- 2) Inverted text: draw white box, then “erase” text
-- disp:setDrawColor(1)                      -- draw the box in “1” (white)
-- disp:drawBox(0, 32, box_w, box_h)         -- position box at y=30

-- disp:setDrawColor(0)                      -- 0 = erase pixels (black text)
-- disp:drawStr(0, 40, second)               -- baseline at y=40

-- disp:sendBuffer()


--displays up to 6 lines of text on 128x64 screen, first line is headline!
function S.display_lines(station_name, station_type, arrivals)
  local white, black = 1, 0
  local id, sda, scl, sla = 0, 2, 1, 0x3C
  local u8g2 = require("u8g2")
  local name_shortened = string.sub((station_name or "unknown"), 1, 14)

  i2c.setup(id, sda, scl, i2c.SLOW) --sets up i2c
  local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla) --contacts display
  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)

  -- draw boxed headline
  disp:setDrawColor(white)
  disp:drawBox(0, 0, 128, 12) -- position box at top left corner x=0 y=0 with 128w and 12height
  disp:setDrawColor(black)    -- 0 = erase pixels (black text)
  disp:drawUTF8(2, 9, name_shortened .. " " .. station_type or " " .. ":") --1st num is left padding, 2nd is bottom start edge
  disp:setDrawColor(white)
  name_shortened = nil
  station_name = nil

  local y = 22 --set bottom edge of first row after headline
  for i = 1, math.min(5, #arrivals) do
    disp:drawUTF8(0, y, arrivals[i] or " ") --displays space in case of empty/null line
    y = y + 10
  end
  disp:sendBuffer()

  collectgarbage()
  u8g2 = nil
  disp = nil
end

return S