require("led")

local IDLE_AT_STARTUP_MS = 5000
local FETCH_INTERVAL_MS  = 60 * 1000

local sntp = require("sntp")
local hsl  = require("hsl")

local function wait_for_ip(on_ready)
  local t = tmr.create()
  t:alarm(1000, tmr.ALARM_AUTO, function()
    local ip = wifi.sta.getip()
    if not ip then
      print("Connecting…")
	  led(512, 1023, 1023)
	  led(1023, 1023, 1023)
      return
    end
    t:unregister()
    print("Connected!\nIP address:", ip)
	led(512, 1023, 512)
	led(1023, 1023, 1023)
    on_ready()
  end)
end

tmr.create():alarm(IDLE_AT_STARTUP_MS, tmr.ALARM_SINGLE, function()
  print(("Starting Wi-Fi setup after %dms…"):format(IDLE_AT_STARTUP_MS))

  wifi.setmode(wifi.STATION)
  wifi.sta.config(
    { ssid = "Hive Stud",
      pwd  = "shifterambiancefinlesskilt" },
    true
  )

  wait_for_ip(function()
    print("Syncing time…")
    sntp.sync("pool.ntp.org",
      function(sec, usec)
        rtctime.set(sec, usec)
        print("Time synced:", sec)
        collectgarbage()

        hsl.fetch()
        local poll = tmr.create()
        poll:alarm(FETCH_INTERVAL_MS, tmr.ALARM_AUTO, hsl.fetch)
      end,
      function()
        print("NTP sync failed — fetching anyway")
        collectgarbage()
        hsl.fetch()
        local poll = tmr.create()
        poll:alarm(FETCH_INTERVAL_MS, tmr.ALARM_AUTO, hsl.fetch)
      end
    )
  end)
end)
