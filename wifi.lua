wifi.setmode(wifi.STATION)

local red = 1
local green = 2
local blue = 3

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
    
    -- Debug print
    print("epoch2cal result:", tt)

    -- Use or fallback to 0 for all fields if nil
    local year = tt.year or 0
    local month = tt.month or 0
    local day = tt.day or 0
    local hour = tt.hour or 0
    local min = tt.min or 0
    local sec = tt.sec or 0

    print(string.format("Time: %04d-%02d-%02d %02d:%02d:%02d",
      year, month, day, hour, min, sec))
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
