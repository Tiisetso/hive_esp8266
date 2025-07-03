id  = 0
sda = 2
scl = 1
sla = 0x3C

local u8g2 = require("u8g2")
i2c.setup(id, sda, scl, i2c.SLOW)

local disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)

disp:clearBuffer()          

disp:setFont(u8g2.font_6x10_tf)
disp:drawStr(0, 20, "Hello, world!")

disp:sendBuffer()
