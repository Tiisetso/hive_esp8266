-- parse.lua

-- Module table
local P = {}

-- If you still need numeric regex parsing elsewhere, you can keep this;
-- otherwise it’s unused when using sjson.decode.
function P.get_values(json_text, search_term)
  local value = {}
  local pattern = '"' .. search_term .. '"%s*:%s*(%d+)'
  for num in json_text:gmatch(pattern) do
    table.insert(value, tonumber(num))
  end
  return value
end

-- Convert a seconds‐since‐midnight timestamp into minutes from now
function P.to_minutes(sec_from_midnight)
  local now = rtctime.get() + 3 * 3600  -- UTC → HEL
  if not now then return "?" end        -- RTC not synced

  local cal = rtctime.epoch2cal(now)
  local current_sec = cal.hour * 3600 + cal.min * 60 + cal.sec
  local delta = sec_from_midnight - current_sec
  if delta < 0 then return "0" end     -- already arrived
  return tostring(math.floor(delta / 60))
end

-- Display bus no, headsign (up to 14 chars), and minutes, on SSD1306 OLED
function P.arrival_display(json_text)
  local sjson = require("sjson")
  local ok, root = pcall(sjson.decode, json_text)
  if not ok or
     type(root) ~= "table" or
     not root.data or
     not root.data.stop or
     not root.data.stop.stoptimesWithoutPatterns then

    print("JSON decode error or unexpected format")
    return
  end

  local entries = root.data.stop.stoptimesWithoutPatterns
  -- Initialize I²C & OLED
  local id, sda, scl, sla = 0, 2, 1, 0x3C
  local u8g2 = require("u8g2")
  i2c.setup(id, sda, scl, i2c.SLOW)
  local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

  disp:clearBuffer()
  disp:setFont(u8g2.font_6x10_tf)
  disp:drawStr(0, 16, "Next Buses:")

  if #entries == 0 then
    disp:drawStr(0, 36, "No arrivals.")
  else
    local y = 36
    for i = 1, math.min(3, #entries) do
      local e    = entries[i]
      local bus  = (e.trip and e.trip.route and e.trip.route.shortName) or "?"
      local head =       e.headsign or "?"
      local mins = P.to_minutes(e.realtimeArrival or 0)

      -- truncate headsign to 14 chars
      head = head:sub(1, 14)
      -- format: bus(3) + space + head(14) + space + mins(3)
      local msg = string.format("%-3s %-14s %3s", bus, head, mins)
      disp:drawStr(0, y, msg)
      y = y + 10
    end
  end

  disp:sendBuffer()
  collectgarbage()
end

return P
