-- Pin defs (GPIO numbers)
local PIN_R, PIN_G, PIN_B = 1, 2, 3

-- PWM init: 500 Hz, start at 0 duty
for _, pin in ipairs{PIN_R,PIN_G,PIN_B} do
  pwm.setup(pin, 500, 0)
  pwm.start(pin)
end

-- Convert hue (0–360) to RGB (0–1 each)
local function hsv2rgb(h, s, v)
  local c = v * s
  local x = c * (1 - math.abs((h/60) % 2 - 1))
  local m = v - c
  local r,g,b
  if h < 60 then
    r, g, b = c, x, 0
  elseif h < 120 then
    r, g, b = x, c, 0
  elseif h < 180 then
    r, g, b = 0, c, x
  elseif h < 240 then
    r, g, b = 0, x, c
  elseif h < 300 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end
  return r + m, g + m, b + m
end

-- Map 0–1 float to 0–1023 PWM duty
local function duty_from(v) return math.floor(v * 1023 + 0.5) end

-- Cycling hue
local hue = 0
tmr.create():alarm(30, tmr.ALARM_AUTO, function(timer)
  -- increment hue, wrap at 360
  hue = (hue + 1) % 360

  -- full saturation & value for vivid colors
  local r, g, b = hsv2rgb(hue, 1, 1)

  -- set PWM duties
  pwm.setduty(PIN_R, duty_from(r))
  pwm.setduty(PIN_G, duty_from(g))
  pwm.setduty(PIN_B, duty_from(b))
end)
