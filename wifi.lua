wifi.setmode(wifi.STATION)

local red, green, blue = 4, 5, 6
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
  if not ip then
    print("Waiting for IP…")
    gpio.write(red, gpio.LOW)
    gpio.write(green, gpio.HIGH)
    gpio.write(blue, gpio.HIGH)
    return
  end

  t:unregister()
  print("Connected! IP address:", ip)
  gpio.write(red, gpio.HIGH)
  gpio.write(green, gpio.HIGH)
  gpio.write(blue, gpio.LOW)
  tmr.delay(30000)
  gpio.write(red, gpio.HIGH)
  gpio.write(green, gpio.HIGH)
  gpio.write(blue, gpio.HIGH)

sntp.sync("pool.ntp.org",
function(sec,usec,server)
  rtctime.set(sec,usec)

  local q = ""
  if file.open("query.gql","r") then
	q = file.read()
	file.close()
  end

  local payload = sjson.encode({
	query     = q,
	variables = { stopId = "HSL:1112126" }
  })

  http.post(
	"https://api.digitransit.fi/routing/v2/hsl/gtfs/v1",
	"Content-Type: application/json\r\n"..
	"Digitransit-Subscription-Key: c23a0df762ec4c51a9794743b7470bf2\r\n",
	payload,
	function(code,data)
	  if code < 0 then
		print("HTTP request failed")
	  else
		print("Status:",code)
		print("Response:",data)
	  end
	end
  )
end,
function()
  print("NTP sync failed")
end)

end)