local IDLE_AT_STARTUP_MS = 10000;

tmr.create():alarm(IDLE_AT_STARTUP_MS, tmr.ALARM_SINGLE,function()
    dofile("blink.lua")
end)
