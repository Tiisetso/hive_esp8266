-- Module table
local P = {}

function P.get_values(json_text, search_term)
  local values = {}
  -- Pattern explanation:
  --   "search_term" followed by optional spaces, colon,
  --   optional spaces, then a double quote,
  --   we capture everything from here until closing quote
  local pattern = '"' .. search_term .. '"%s*:%s*"?([^",}]+)"?'
  
  for str in json_text:gmatch(pattern) do
    table.insert(values, str)
  end
  return values
end

function P.to_min(sec_from_midnight)
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

--display bus num, headsign, and minutes (max width <=21chars)
function P.arrival_display(json)
  local id, sda, scl, sla = 0, 2, 1, 0x3C

  local u8g2 = require("u8g2")
  i2c.setup(id, sda, scl, i2c.SLOW)
  local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)
  disp:drawStr(0, 16, "Next Buses:")

  local times = P.get_values(json, "realtimeArrival")
  local busses = P.get_values(json, "shortName")
  local headsigns = P.get_values(json, "headsign")

  if #times == 0 then
    disp:drawStr(0, 36, "No arrivals.")
  else
    local y = 36
    for i = 1, math.min(3, #times) do
		  local headsign = headsigns[i] or "?"
      local max_char = 14
      local msg = busses[i] .. " " .. string.sub(headsign, 1, max_char) .. " " .. P.to_min(times[i])
      disp:drawStr(0, y, msg)
      y = y + 10
    end
  end
  disp:sendBuffer()
  collectgarbage()
end

return P