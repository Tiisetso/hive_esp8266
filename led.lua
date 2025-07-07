RED, GREEN, BLUE = 7, 5, 6
local freq = 500

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

-- function led_off()
-- 	led(1023, 1023, 1023)
-- end

-- function led_alert()
-- 	led(0, 1023, 1023)
-- 	led_off()
-- end

-- function led_success()
-- 	led(0, 1023, 0)
-- 	led(512, 1023, 512)
-- 	led(0, 1023, 0)
-- 	led_off()
-- end