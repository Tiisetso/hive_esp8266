local P = require("parse")
local sntp = sntp

sntp.sync("pool.ntp.org",
  function(sec,usec,server)
    rtctime.set(sec,usec)
    collectgarbage()

    local q = ""
    if file.open("query.gql","r") then
      q = file.read()
      file.close()
    end

    local payload = sjson.encode({
      query     = q,
      variables = { stopId = "HSL:1100125" }
    })

    http.post(
      "https://api.digitransit.fi/routing/v2/hsl/gtfs/v1",
      "Content-Type: application/json\r\n"..
      "Digitransit-Subscription-Key: c23a0df762ec4c51a9794743b7470bf2\r\n",
      payload,
      function(code, data)
        if code < 0 then
          print("HTTP request failed")
        else
          print("Status:", code)
          print("Response:", data)
          P.arrival_display(data)
        end
      end
    )
  end,
  function()
    print("NTP sync failed")
  end
)
