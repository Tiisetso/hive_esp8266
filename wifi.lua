-- -- wifi.setmode(wifi.STATION)

-- -- local red = 5
-- -- local green = 6
-- -- local blue = 7

-- -- gpio.mode(red, gpio.OUTPUT)
-- -- gpio.mode(green, gpio.OUTPUT)
-- -- gpio.mode(blue, gpio.OUTPUT)


-- -- wifi.sta.config{
-- --   ssid = "Hive Stud",
-- --   pwd  = "shifterambiancefinlesskilt",
-- --   auto = true
-- -- }

-- -- wifi.sta.connect()

-- -- tmr.create():alarm(1000, tmr.ALARM_AUTO, function(t)
-- --   local ip = wifi.sta.getip()
-- --   if ip then
-- --     print("Connected! IP address:", ip)
-- -- 	gpio.write(red, gpio.HIGH)
-- -- 	gpio.write(green, gpio.HIGH)
-- -- 	gpio.write(blue, gpio.LOW)
-- -- 	tmr.delay(10000)
-- -- 	gpio.write(red, gpio.HIGH)
-- -- 	gpio.write(green, gpio.HIGH)
-- -- 	gpio.write(blue, gpio.HIGH)
-- --     t:unregister()
  
-- --   sntp.sync("pool.ntp.org",
-- --     function(sec, usec, server)
-- --       rtctime.set(sec, usec)  -- set internal RTC time
-- --       local tt = rtctime.epoch2cal(sec)

-- --       local day = tonumber(tt.day) or 0
-- --       local hour = tonumber(tt.hour) + 3 or 0a
-- --       local min = tonumber(tt.min) or 0
-- --       local sec = tonumber(tt.sec) or 0

-- --       print(string.format("Day of month and Time: %02d %02d:%02d:%02d", day, hour, min, sec))
-- --     end,
-- --     function()
-- --       print("NTP sync failed")
-- --     end
-- --   )
  
-- --   else
-- --     print("Waiting for IP…")
-- -- 	gpio.write(red, gpio.LOW)
-- -- 	gpio.write(green, gpio.HIGH)
-- -- 	gpio.write(blue, gpio.HIGH)
-- --   end
-- -- end)


-- -- 1) Wi-Fi + LED setup
-- wifi.setmode(wifi.STATION)

-- local red, green, blue = 4, 5, 6
-- gpio.mode(red, gpio.OUTPUT)
-- gpio.mode(green, gpio.OUTPUT)
-- gpio.mode(blue, gpio.OUTPUT)

-- wifi.sta.config{
--   ssid = "Hive Stud",
--   pwd  = "shifterambiancefinlesskilt",
--   auto = true
-- }
-- wifi.sta.connect()

-- -- 2) Poll for IP
-- tmr.create():alarm(1000, tmr.ALARM_AUTO, function(t)
--   local ip = wifi.sta.getip()
--   if not ip then
--     print("Waiting for IP…")
--     gpio.write(red, gpio.LOW)
--     gpio.write(green, gpio.HIGH)
--     gpio.write(blue, gpio.HIGH)
--     return
--   end

--   -- we have IP!
--   t:unregister()
--   print("Connected! IP address:", ip)
--   gpio.write(red, gpio.HIGH)
--   gpio.write(green, gpio.HIGH)
--   gpio.write(blue, gpio.LOW)
--   tmr.delay(30000)
--   gpio.write(red, gpio.HIGH)
--   gpio.write(green, gpio.HIGH)
--   gpio.write(blue, gpio.HIGH)


--   sntp.sync("pool.ntp.org",
--     function(sec, usec, server)
--       rtctime.set(sec, usec)  -- set internal RTC time
--       local tt = rtctime.epoch2cal(sec)

--       local day = tonumber(tt.day) or 0
--       local hour = tonumber(tt.hour) + 3 or 0
--       local min = tonumber(tt.min) or 0
--       local sec = tonumber(tt.sec) or 0

--       print(string.format("Day of month and Time: %02d %02d:%02d:%02d", day, hour, min, sec))
--     end,
--     function()
--       print("NTP sync failed")
--     end
--   )
--   -- 3) Sync time so HTTPS works
-- --   sntp.sync("pool.ntp.org",
-- --     function(sec, usec, server)
-- --       rtctime.set(sec, usec)
-- --       local tt = rtctime.epoch2cal(sec)
-- --       print(string.format("Time: %04d-%02d-%02d %02d:%02d:%02d",
-- --         tt.year, tt.month, tt.day, tt.hour, tt.min, tt.sec))

--       -- 4) Perform HTTPS POST
--       local url = "https://api.digitransit.fi/routing/v2/hsl/gtfs/v1"
--       local headers =
--         "Content-Type: application/json\r\n" ..
--         "Digitransit-Subscription-Key: c23a0df762ec4c51a9794743b7470bf2\r\n"
--       local body = [[
-- {"query":"{ stop(id:\"HSL:1112126\"){ name stoptimesWithoutPatterns { realtimeArrival headsign } } }"}
--       ]]

--       http.post(url, headers, body,
--         function(code, data)
--           if code < 0 then
--             print("HTTP request failed")
--           else
--             print("Status:", code)
--             print("Response:", data)
--           end
--         end
--       )
--     end,
--     function()
--       print("NTP sync failed")
--     end
--   )
-- end
----

-- 1) Wi-Fi + LED setup
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

-- 2) Poll for IP
tmr.create():alarm(1000, tmr.ALARM_AUTO, function(t)
  local ip = wifi.sta.getip()
  if not ip then
    print("Waiting for IP…")
    gpio.write(red, gpio.LOW)
    gpio.write(green, gpio.HIGH)
    gpio.write(blue, gpio.HIGH)
    return
  end

  -- we have IP!
  t:unregister()
  print("Connected! IP address:", ip)
  gpio.write(red, gpio.HIGH)
  gpio.write(green, gpio.HIGH)
  gpio.write(blue, gpio.LOW)
  tmr.delay(30000)
  gpio.write(red, gpio.HIGH)
  gpio.write(green, gpio.HIGH)
  gpio.write(blue, gpio.HIGH)

  -- 3) Sync time so HTTPS works
  sntp.sync("pool.ntp.org",
    function(sec, usec, server)
      -- set internal RTC time
      rtctime.set(sec, usec)
      local tt = rtctime.epoch2cal(sec)

      -- print local time (UTC+3)
      local day  = tonumber(tt.day)  or 0
      local hour = (tonumber(tt.hour) or 0) + 3
      local min  = tonumber(tt.min)  or 0
      local sec2 = tonumber(tt.sec)  or 0
      print(string.format(
        "Day of month and Time: %02d %02d:%02d:%02d",
        day, hour, min, sec2
      ))

      -- 4) Perform HTTPS POST
      local url = "https://api.digitransit.fi/routing/v2/hsl/gtfs/v1"
      local headers =
        "Content-Type: application/json\r\n" ..
        "Digitransit-Subscription-Key: c23a0df762ec4c51a9794743b7470bf2\r\n"
      local body = [[
{"query":"{ stop(id:\"HSL:1112126\"){ name stoptimesWithoutPatterns { realtimeArrival headsign } } }"}
      ]]

      http.post(url, headers, body,
        function(code, data)
          if code < 0 then
            print("HTTP request failed")
          else
            print("Status:", code)
            print("Response:", data)
          end
        end
      )
    end,
    function()
      print("NTP sync failed")
    end
  )
end)
