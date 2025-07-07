local P     = require("parse")
local http  = require("http")
local sjson = require("sjson")
local tmr   = tmr

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
          P.arrival_display(data)
        end
      end
    )
  end)
end

return M
