local red = 1
local green = 2
local blue = 3

local brightness = 512      -- start near middle for smooth oscillation
local t = 0                -- phase variable for sin
local amplitude = 5        -- max increment step size

function offset(val)
    val = math.floor(val)
    if val > 1023 then
        return val - 1024
    elseif val < 0 then
        return val + 1024
    else
        return val
    end
end

function oscillateFunction()
    t = t + 0.1                         -- advance phase by 0.1 radians
    local step = math.sin(t) * amplitude -- step changes between -5 and 5

    brightness = brightness + step

    -- Clamp brightness to 0-1023
    if brightness > 1023 then
        brightness = 1023
        t = t + math.pi  -- flip sin phase to go backward
    elseif brightness < 0 then
        brightness = 0
        t = t + math.pi  -- flip sin phase to go forward
    end

    pwm.setduty(red, offset(brightness + 341))
    pwm.setduty(green, offset(brightness))
    pwm.setduty(blue, offset(brightness - 341))
end

pwm.setup(red, 1000, 0)
pwm.setup(green, 1000, 0)
pwm.setup(blue, 1000, 0)

pwm.start(red)
pwm.start(green)
pwm.start(blue)

tmr.create():alarm(10, tmr.ALARM_AUTO, oscillateFunction)
