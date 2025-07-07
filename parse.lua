-- Module table
local P = {}

function P.pad_right(str, len, char)
  char = char or " "
  return str .. string.rep(char, math.max(0, len - P.utf8len(str)))
end

function P.pad_left(str, len, char)
  char = char or " "
  return string.rep(char, math.max(0, len - P.utf8len(str))) .. str
end

--returns len of str in displayable characters
function P.utf8len(str)
  local _, count = string.gsub(str, "[^\128-\193]", "")
  return count
end

function P.to_mins(sec_from_midnight)
  local now = rtctime.get()
  if now == 0 or now == nil then
    return "?"  -- RTC not synced
  end
  now = now + 3 * 3600 --UTC to HEL
  
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
local id, sda, scl, sla = 0, 2, 1, 0x3C
local u8g2 = require("u8g2")
i2c.setup(id, sda, scl, i2c.SLOW)
local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
function P.arrival_display(json)

  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)
  -- -- 2) Inverted text: draw white box, then “erase” text
  disp:setDrawColor(1)                      -- draw the box in “1” (white)
  local box_w = 128
  local box_h = 12
  disp:drawBox(0, 0, box_w, box_h)         -- position box at top left

  local station_name = "Haapaniemi" --max 14 chars (total screen w is 21 chars)
  local station_type = "Buses"--'Buses' or 'Trams'
  disp:setDrawColor(0)                      -- 0 = erase pixels (black text)
  -- disp:sendBuffer()
  disp:drawUTF8(2, 9, station_name .. " " .. station_type .. ":")--1st num is left padding, 2nd is bottom start edge
  disp:setDrawColor(1)

  local times = P.get_values(json, "realtimeArrival")
  if #times == 0 then 
    times = P.get_values(json, "scheduledArrivals")
  end
  local busses = P.get_values(json, "shortName")
  local headsigns = P.get_values(json, "headsign")

  if #times == 0 then
    table.insert(strings, "No arrivals.")
  else
    for i = 1, math.min(5, #times) do
      local bus = P.pad_right((busses[i] or "?"), 5) --last num in padding tells width
		  local headsign = P.pad_right(string.sub((headsigns[i] or "unknown"), 1, 12), 12)

      local seconds = tonumber(times[i])
      local time_until = seconds and P.pad_left(P.to_mins(seconds), 2) or " ?"

      table.insert(strings, bus .. headsign .. " " .. time_until)
    end
  end
  collectgarbage()
  times = nil
  busses = nil
  headsigns = nil
  return strings
end

return P