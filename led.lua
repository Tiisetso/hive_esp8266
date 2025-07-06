RED, GREEN, BLUE = 7, 5, 6

pwm.setup(RED, 500, 512)
pwm.setup(GREEN, 500, 512)
pwm.setup(BLUE, 500, 512)

pwm.start(RED)
pwm.start(GREEN)
pwm.start(BLUE)

function led(r, g, b)
    pwm.setduty(RED, r)
    pwm.setduty(GREEN, g)
    pwm.setduty(BLUE, b)
end