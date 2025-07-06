-- Module table
local P = {}

--- Returns array of digit values after each search_term  in a given string
function P.get_num_values(json_text, search_term)
  local arrivals = {}
  local pattern = '"' .. search_term .. '"%s*:%s*"?(%d+)"?'
  for num in json_text:gmatch(pattern) do
    table.insert(arrivals, num)
  end
  return arrivals
end

-- prints the results with up to max arrivals, or 'no arrivals' if none
-- prefers realtime to scheduled
function P.arrival_printing(json_text)
  local max = 3
  
  local arrivals = P.get_num_values(json_text, "realtimeArrival")
  --we want the realtime ideally but it may not be there
  if #arrivals == 0 then
    arrivals = P.get_num_values(json_text, "scheduledArrival")
    if #arrivals == 0 then
      print("No arrivals.")
    end
  else
    for i = 1, math.min(#arrivals, max) do
      if i == 1 then
        print("First arrival:", arrivals[1])
      elseif i == 2 then
        print("next arrivals:")
        print(" " .. arrivals[i])
      else
        print(" " .. arrivals[i])
      end
    end
  end

end



function P.arrival_display(json)
  id  = 0
  sda = 2
  scl = 1
  sla = 0x3C
  local u8g2 = require("u8g2")
  -- local parse = require("parse")
  i2c.setup(id, sda, scl, i2c.SLOW)
  local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

  -- local json = require("data")
  -- json = data

  local arrivals = P.get_num_values(json, "realtimeArrival")


  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)
  disp:drawStr(0, 16, "Next Buses:")

  if #arrivals == 0 then
    disp:drawStr(0, 36, "No arrivals.")
  else
    local y = 36
    for i = 1, math.min(3, #arrivals) do
      local msg = "In: " .. arrivals[i] .. " sec"
      disp:drawStr(0, y, msg)
      y = y + 10
    end
  end

  disp:sendBuffer()
end
return P

-- Status:	200
-- Response:	{"data":{"stop":{"id":"U3RvcDpIU0w6MTExMjEyNg","name":"Haapaniemi","stoptimesWithoutPatterns":[{"realtimeArrival":59191,"headsign":"Rautatientori","trip":{"route":{"shortName":"78"}}},{"realtimeArrival":59257,"headsign":"Rautatientori","trip":{"route":{"shortName":"66"}}},{"realtimeArrival":59250,"headsign":"Rautatientori","trip":{"route":{"shortName":"75"}}},{"realtimeArrival":59283,"headsign":"Rautatientori","trip":{"route":{"shortName":"611"}}},{"realtimeArrival":59335,"headsign":"Rautatientori","trip":{"route":{"shortName":"77"}}}]}}}