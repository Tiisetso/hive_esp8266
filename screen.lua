-- id  = 0
-- sda = 2
-- scl = 1
-- sla = 0x3C

-- local u8g2 = require("u8g2")
-- i2c.setup(id, sda, scl, i2c.SLOW)

-- local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

-- disp:clearBuffer()

-- disp:setFont(u8g2.font_6x10_tf)
-- disp:drawStr(0, 20, "Hello, world!")

-- disp:sendBuffer()


id  = 0
sda = 2
scl = 1
sla = 0x3C


local u8g2 = require("u8g2")
local parse = require("parse")
i2c.setup(id, sda, scl, i2c.SLOW)
local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)


local json = [[
  {"data":{"stop":{"name":"Haapaniemi","stoptimesWithoutPatterns":[
    {"realtimeArrival":4,"headsign":"Rautatientori"},
    {"realtimeArrival":7,"headsign":"Kamppi"},
    {"realtimeArrival":15,"headsign":"Otaniemi"}
  ]}}}
]]


local arrivals = parse.get_num_values(json, "realtimeArrival")


disp:clearBuffer()
disp:setFont(u8g2.font_6x10_tf)
disp:drawStr(0, 16, "Next Buses:")

if #arrivals == 0 then
  disp:drawStr(0, 36, "No arrivals.")
else
  local y = 36
  for i = 1, math.min(3, #arrivals) do
    local msg = "BUS: " .. arrivals[i] .. " sec"
    disp:drawStr(0, y, msg)
    y = y + 16
  end
end

disp:sendBuffer()
