

 esptool.py \                                                                                                         11:38:21
  --port /dev/cu.wchusbserial140 \
  write_flash \
    -fm dio \
    -fs 4MB \
    0x00000 \
    nodemcu-release-10-modules-2025-07-03-07-49-27-float.bin

Press RST
nodemcu-uploader --port /dev/cu.wchusbserial140 upload blink.lua 

screen /dev/cu.wchusbserial140 115200

