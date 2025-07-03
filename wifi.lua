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
  else
    print("Waiting for IP…")
	gpio.write(red, gpio.LOW)
	gpio.write(green, gpio.HIGH)
	gpio.write(blue, gpio.HIGH)
  end
end)
