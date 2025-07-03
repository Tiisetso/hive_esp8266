
local red = 1
local green = 2
local blue = 3

gpio.mode(red, gpio.OUTPUT)
gpio.mode(green, gpio.OUTPUT)
gpio.mode(blue, gpio.OUTPUT)

for x=1, 10 do

	for i=1, 100 do
		gpio.write(red, gpio.LOW)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(10000)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.LOW)
		tmr.delay(10000)
	end

	for i=1, 1000 do
		gpio.write(red, gpio.LOW)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(255)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.LOW)
		tmr.delay(255)
	end

	for i=1, 1000 do
		gpio.write(red, gpio.LOW)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(255)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.LOW)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(204)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.LOW)
		tmr.delay(204)
	end

	for i=1, 1000 do
		gpio.write(red, gpio.LOW)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(255)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.LOW)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(255)
	end

	for i=1, 1000 do
		gpio.write(red, gpio.LOW)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(255)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.LOW)
		gpio.write(blue, gpio.HIGH)
		tmr.delay(255)

		gpio.write(red, gpio.HIGH)
		gpio.write(green, gpio.HIGH)
		gpio.write(blue, gpio.LOW)
		tmr.delay(255)
	end
end

gpio.write(red, gpio.HIGH)
gpio.write(green, gpio.HIGH)
gpio.write(blue, gpio.HIGH)