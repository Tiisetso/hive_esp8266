wifi.setmode(wifi.STATION)

local red = 5
local green = 6
local blue = 7

gpio.mode(red, gpio.OUTPUT)
gpio.mode(green, gpio.OUTPUT)
gpio.mode(blue, gpio.OUTPUT)


wifi.sta.config{
  ssid = "Hive Stud",
  pwd  = "shifterambiancefinlesskilt",
  auto = true
}

wifi.sta.connect()

tmr.create():alarm(1000, tmr.ALARM_AUTO, function(t)
  local ip = wifi.sta.getip()
  if ip then
    print("Connected! IP address:", ip)
	gpio.write(red, gpio.HIGH)
	gpio.write(green, gpio.HIGH)
	gpio.write(blue, gpio.LOW)
	tmr.delay(10000)
	gpio.write(red, gpio.HIGH)
	gpio.write(green, gpio.HIGH)
	gpio.write(blue, gpio.HIGH)
    t:unregister()
  
  sntp.sync("pool.ntp.org",
    function(sec, usec, server)
      rtctime.set(sec, usec)  -- set internal RTC time
      local tt = rtctime.epoch2cal(sec)

      local day = tonumber(tt.day) or 0
      local hour = tonumber(tt.hour) + 3 or 0
      local min = tonumber(tt.min) or 0
      local sec = tonumber(tt.sec) or 0

      print(string.format("Day of month and Time: %02d %02d:%02d:%02d", day, hour, min, sec))
    end,
    function()
      print("NTP sync failed")
    end
  )
  
  else
    print("Waiting for IP…")
	gpio.write(red, gpio.LOW)
	gpio.write(green, gpio.HIGH)
	gpio.write(blue, gpio.HIGH)
  end
end)
