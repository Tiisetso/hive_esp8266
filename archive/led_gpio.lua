local L = {}

local RED, GREEN, BLUE = 7, 5, 6

gpio.mode(RED,   gpio.OUTPUT)
gpio.mode(GREEN, gpio.OUTPUT)
gpio.mode(BLUE,  gpio.OUTPUT)
gpio.write(RED,   gpio.HIGH)

function L.green()
	gpio.write(RED,   gpio.HIGH)
	gpio.write(GREEN, gpio.LOW)
	gpio.write(BLUE,  gpio.HIGH)
end

function L.red()
	gpio.write(RED,   gpio.LOW)
	gpio.write(GREEN, gpio.HIGH)
	gpio.write(BLUE,  gpio.HIGH)
end

function L.blue()
	gpio.write(RED,   gpio.HIGH)
	gpio.write(GREEN, gpio.HIGH)
	gpio.write(BLUE,  gpio.LOW)
end

function L.magenta()
	gpio.write(RED,   gpio.LOW)
	gpio.write(GREEN, gpio.HIGH)
	gpio.write(BLUE,  gpio.LOW)
end

function L.off()
	gpio.write(RED,   gpio.HIGH)
	gpio.write(GREEN, gpio.HIGH)
	gpio.write(BLUE,  gpio.HIGH)
end

return L
