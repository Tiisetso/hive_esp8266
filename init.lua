require("led")

local IDLE_AT_STARTUP_MS = 5000;

tmr.create():alarm(IDLE_AT_STARTUP_MS, tmr.ALARM_SINGLE,function()

	local seq = {
	{r=512, g=1023,   b=1023},   -- full red
	{r=0, g=1023,   b=1023},   -- full red
	{r=1023,   g=512, b=1023},   -- full green
	{r=1023,   g=0, b=1023},   -- full green
	{r=1023,   g=1023,   b=512}, -- full blue
	{r=1023,   g=1023,   b=0}, -- full blue
	{r=512, g=512, b=1023},   -- yellow
	{r=1023,   g=512, b=512}, -- cyan
	{r=512, g=1023,   b=512}, -- magenta
	{r=256, g=256, b=256}, -- white (half-brightness)
	{r=0, g=0, b=0}, -- white (half-brightness)
	{r=768, g=768, b=768}, -- white (half-brightness)
	{r=100, g=700,   b=200},
	-- {r=1023,   g=1023,   b=1023},   -- off
	}

	local idx = 1
	tmr.create():alarm(100, tmr.ALARM_AUTO, function(t)
	local color = seq[idx]
	led(color.r, color.g, color.b)
	idx = idx % #seq + 1
	end)
end)
