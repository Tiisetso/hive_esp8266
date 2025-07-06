

local red, green, blue = 5, 6, 7
gpio.mode(red, gpio.OUTPUT)
gpio.mode(green, gpio.OUTPUT)
gpio.mode(blue, gpio.OUTPUT)

gpio.write(red, gpio.LOW)
gpio.write(green, gpio.LOW)
gpio.write(blue, gpio.HIGH)