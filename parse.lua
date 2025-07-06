-- Module table
local P = {}

function pad_right(str, len, char)
  char = char or " "
  return str .. string.rep(char, math.max(0, len - #str))
end

function pad_left(str, len, char)
  char = char or " "
  return string.rep(char, math.max(0, len - #str)) .. str
end

function P.to_mins(sec_from_midnight)
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

--display bus number, headsign, and minutes (max display width <=21chars)
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
      local bus = pad_right((busses[i] or "?"), 5) --last num in padding tells width
		  local headsign = pad_right(string.sub((headsigns[i] or "unknown"), 1, 11), 11)
      local time_until = pad_left(P.to_mins(times[i] or "?"), 3)

      local msg = bus .. " " .. headsign .. " " .. time_until
      disp:drawStr(0, y, msg)
      y = y + 10
    end
  end
  disp:sendBuffer()
  collectgarbage()
end

return P