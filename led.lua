RED, GREEN, BLUE = 7, 5, 6
local freq = 100

pwm.setup(RED, freq, 1023)
pwm.setup(GREEN, freq, 1023)
pwm.setup(BLUE, freq, 1023)

pwm.start(RED)
pwm.start(GREEN)
pwm.start(BLUE)

function led(r, g, b)
    pwm.setduty(RED, r)
    pwm.setduty(GREEN, g)
    pwm.setduty(BLUE, b)
end

