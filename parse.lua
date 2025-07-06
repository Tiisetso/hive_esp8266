-- Module table
local P = {}

--- Returns array of digit values after each search_term  in a given string
function P.get_num_values(json_text, search_term)
  local value = {}
  local pattern = '"' .. search_term .. '"%s*:%s*"?(%d+)"?'
  for num in json_text:gmatch(pattern) do
    table.insert(value, num)
  end
  return value
end


function P.time(sec_from_midnight)
  local now = rtctime.get()
  if not now then
    return "?"  -- RTC not synced
  end

  local cal = rtctime.epoch2cal(now)
  local current_sec = cal.hour * 3600 + cal.min * 60 + cal.sec
  local delta = sec_from_midnight - current_sec

  if delta < 0 then
    return "0"  -- Bus has already arrived
  else
    return tostring(math.floor(delta / 60))
  end
end


function P.arrival_display(json)
  local id  = 0
  local sda = 2
  local scl = 1
  local sla = 0x3C
  local u8g2 = require("u8g2")
  i2c.setup(id, sda, scl, i2c.SLOW)
  local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

  local now = rtctime.get()
  print("Time rtc: ", now)--debug
  local arrivals = P.get_num_values(json, "realtimeArrival")
  local busses = P.get_num_values(json, "shortName")

  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)
  disp:drawStr(0, 16, "Next Buses:")

  if #arrivals == 0 then
    disp:drawStr(0, 36, "No arrivals.")
  else
    local y = 36
    for i = 1, math.min(3, #arrivals) do
      local msg = busses[i] .. " in " .. P.time(arrivals[i]) .. " minutes"
      disp:drawStr(0, y, msg)
      y = y + 10
    end
  end

  disp:sendBuffer()
end
return P

-- Status:	200
-- Response:	{"data":{"stop":{"id":"U3RvcDpIU0w6MTExMjEyNg","name":"Haapaniemi","stoptimesWithoutPatterns":[{"realtimeArrival":59191,"headsign":"Rautatientori","trip":{"route":{"shortName":"78"}}},{"realtimeArrival":59257,"headsign":"Rautatientori","trip":{"route":{"shortName":"66"}}},{"realtimeArrival":59250,"headsign":"Rautatientori","trip":{"route":{"shortName":"75"}}},{"realtimeArrival":59283,"headsign":"Rautatientori","trip":{"route":{"shortName":"611"}}},{"realtimeArrival":59335,"headsign":"Rautatientori","trip":{"route":{"shortName":"77"}}}]}}}