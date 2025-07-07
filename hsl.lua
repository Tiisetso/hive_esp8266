local P     = require("parse")
local http  = require("http")
local sjson = require("sjson")
local S     = require("screen")
local tmr   = tmr
local station_name = "Haapaniemi" --max 14 chars (total screen w is 21 chars)
local station_type = "Buses"--'Buses' or 'Trams' or empty

local _payload = (function()
  local q = ""
  if file.open("query.gql", "r") then
    q = file.read()
    file.close()
  end
  return sjson.encode({
    query     = q,
    variables = { stopId = "HSL:1100125" },
  })
end)()

local M = {}

function M.fetch()
  collectgarbage()
  collectgarbage()
  
  tmr.create():alarm(200, tmr.ALARM_SINGLE, function()
    http.post(
      "https://api.digitransit.fi/routing/v2/hsl/gtfs/v1",
      "Content-Type: application/json\r\n" ..
        "Digitransit-Subscription-Key: c23a0df762ec4c51a9794743b7470bf2\r\n",
      _payload,
      function(code, data)
        if code < 0 then
          print("HTTP request failed", code)
        else
          print("Status:", code)
          S.display_lines(station_name, station_type, P.parse_arrivals(data))
        end
		collectgarbage()
      end
    )
  end)
end

P = nil
S = nil
http = nil
sjson = nil

return M
