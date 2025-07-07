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

--takes in json response and parses all key values, returns array of lines for displaying 
function P.parse_arrivals(json)
  local strings = {}

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