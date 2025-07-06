-- Module table
local P = {}

--- Returns array of digit values after each search_term  in a given string
function P.get_values(json_text, search_term)
  local value = {}
  local pattern = '"' .. search_term .. '"%s*:%s*"?(%d+)"?'
  for num in json_text:gmatch(pattern) do
    table.insert(value, num)
  end
  return value
end


function P.to_minutes(sec_from_midnight)
  local now = rtctime.get() + 3 * 3600 --UTC to HEL
  if not now then
    return "?"  -- RTC not synced
  end

  local cal = rtctime.epoch2cal(now)
  local current_sec = cal.hour * 3600 + cal.min * 60 + cal.sec
  local delta = sec_from_midnight - current_sec

  if delta < 0 then
    return "0"  -- Bus arrived
  else
    return tostring(math.floor(delta / 60))
  end
end

--display bus no, headsign up to 14 chars, and minutes (21chars width)
function P.arrival_display(json)
  local id  = 0
  local sda = 2
  local scl = 1
  local sla = 0x3C
  local u8g2 = require("u8g2")
  i2c.setup(id, sda, scl, i2c.SLOW)
  local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

  local now = rtctime.get()
  local arrivals = P.get_values(json, "realtimeArrival")
  local busses = P.get_values(json, "shortName")
  local headsigns = P.get_values(json, "headsign")

  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)
  disp:drawStr(0, 16, "Next Buses:")

  if #arrivals == 0 then
    disp:drawStr(0, 36, "No arrivals.")
  else
    local y = 36
    for i = 1, math.min(3, #arrivals) do
      local msg = busses[i] .. "  " .. headsigns[i] .. "  " .. P.to_minutes(arrivals[i])
      disp:drawStr(0, y, msg)
      y = y + 10
    end
  end
  disp:sendBuffer()
  collectgarbage()
end
return P

-- Status:	200
-- Response:	{"data":{"stop":{"id":"U3RvcDpIU0w6MTExMjEyNg","name":"Haapaniemi","stoptimesWithoutPatterns":[{"realtimeArrival":59191,"headsign":"Rautatientori","trip":{"route":{"shortName":"78"}}},{"realtimeArrival":59257,"headsign":"Rautatientori","trip":{"route":{"shortName":"66"}}},{"realtimeArrival":59250,"headsign":"Rautatientori","trip":{"route":{"shortName":"75"}}},{"realtimeArrival":59283,"headsign":"Rautatientori","trip":{"route":{"shortName":"611"}}},{"realtimeArrival":59335,"headsign":"Rautatientori","trip":{"route":{"shortName":"77"}}}]}}}