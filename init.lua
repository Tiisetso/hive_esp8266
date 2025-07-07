require("led")

local IDLE_AT_STARTUP_MS = 5000

local function wait_for_ip(on_ready)
  local t = tmr.create()
  t:alarm(1000, tmr.ALARM_AUTO, function()
    local ip = wifi.sta.getip()
    if not ip then
      print("Connecting…")
      led(512, 1023, 1023)
      return
    end
    t:unregister()
    print("Connected! IP address:", ip)
    led(512, 1023, 512)
    on_ready(ip)
  end)
end

tmr.create():alarm(IDLE_AT_STARTUP_MS, tmr.ALARM_SINGLE, function()
  print(("Starting Wi-Fi setup after %dms"):format(IDLE_AT_STARTUP_MS))

  wifi.setmode(wifi.STATION)
  wifi.sta.config{
    ssid = "Hive Stud",
    pwd  = "shifterambiancefinlesskilt",
    auto = true,
  }
  wifi.sta.connect()

  wait_for_ip(function()
    require("hsl")
  end)
end)
