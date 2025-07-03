-- Pin setup
local red = 1
local green = 2
local blue = 3

-- PWM setup: frequency = 500 Hz, initial duty = 0 (off), max = 1023
pwm.setup(red, 500, 0)
pwm.setup(green, 500, 0)
pwm.setup(blue, 500, 0)

pwm.start(red)
pwm.start(green)
pwm.start(blue)

-- Function to fade in and out
local duty = 0
local step = 10
local increasing = true

tmr.create():alarm(10, tmr.ALARM_AUTO, function()
    pwm.setduty(red, duty)
    pwm.setduty(green, duty)
    pwm.setduty(blue, duty)

    if increasing then
        duty = duty + step
        if duty >= 1023 then
            duty = 1023
            increasing = false
        end
    else
        duty = duty - step
        if duty <= 0 then
            duty = 0
            increasing = true
        end
    end
end)