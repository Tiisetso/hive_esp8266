-- Main.lua (all‑in‑one)

-- Module table
local M = {}

--- Returns the first realtimeArrival value (digits only) found in a JSON string
-- @param json_text (string) raw JSON
-- @return (string) digits or nil
function M.get_realtime_arrival(json_text)
  return json_text:match('"realtimeArrival"%s*:%s*"?(%d+)"?')
end

--- Returns all realtimeArrival values (digits only) found in a JSON string
-- @param json_text (string) raw JSON
-- @return (table) array of digit‑strings (empty if none)
function M.get_all_realtime_arrivals(json_text)
  local arrivals = {}
  for num in json_text:gmatch('"realtimeArrival"%s*:%s*"?(%d+)"?') do
    table.insert(arrivals, num)
  end
  return arrivals
end

-- ──────────────────────────────────────────────────────────────────
-- Test 

-- Sample JSON
local sample = [[
{
  "stopId":"HSL:1100911",
  "etas":[
    { "route":"23", "realtimeArrival":"52792", "scheduledArrival":"1678833660" },
    { "route":"42", "realtimeArrival":"52792", "scheduledArrival":"1678837260" }
  ],
  "name":"Mannerheimintie 20"
}
]]

-- 1) Print the first arrival
local first = M.get_realtime_arrival(sample)
if first then
  print("First realtimeArrival:", first)
else
  print("No realtimeArrival found")
end

-- 2) Print all arrivals
local all = M.get_all_realtime_arrivals(sample)
if #all > 0 then
  print("All realtimeArrivals:")
  for i, ts in ipairs(all) do
    print(string.format("  #%d → %s", i, ts))
  end
else
  print("No realtimeArrivals found")
end

