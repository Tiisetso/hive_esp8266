-- 1) Set Wi-Fi to station mode (i.e. client, not AP)
wifi.setmode(wifi.STATION)

-- 2) Configure your SSID and password
--    (replace YOUR_SSID and YOUR_PASS with your network’s credentials)
wifi.sta.config{
  ssid = "Hive Stud",
  pwd  = "shifterambiancefinlesskilt",
  -- optional: auto-connect on boot
  auto = true
}

-- 3) Trigger the connection (optional—auto=true already does this)
wifi.sta.connect()

-- 4) Wait for an IP and print it
tmr.create():alarm(1000, tmr.ALARM_AUTO, function(t)
  local ip = wifi.sta.getip()
  if ip then
    print("Connected! IP address:", ip)
    t:unregister()  -- stop the timer
  else
    print("Waiting for IP…")
  end
end)
