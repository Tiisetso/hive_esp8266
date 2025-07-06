require("led")

local IDLE_AT_STARTUP_MS = 5000;

tmr.create():alarm(IDLE_AT_STARTUP_MS, tmr.ALARM_SINGLE,function()
	dofile("wifi.lua")
end)
