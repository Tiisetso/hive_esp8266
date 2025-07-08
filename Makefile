PORT := /dev/cu.wchusbserial140
BAUD := 115200

FIRMWARE  := firmware/nodemcu-release-14-modules-2025-07-07-14-04-28-float.bin

LUA := $(wildcard *.lua)
GQL := $(wildcard *.gql)
FILES := $(LUA) $(GQL)

.PHONY: all upload fclean rm-init restart console flash

all: re

where:
	ls /dev/cu.* /dev/tty.* 

upload: 
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload $(FILES)

upload-c: 
	@echo "Compiling & uploading: $(LUA)"
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload $(GQL)
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload --compile $(LUA)

rm-init:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file remove init.lua

format:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file format
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file list

flash:
	@echo "Flashing firmware $(FIRMWARE) to $(PORT)."
	esptool.py --port $(PORT) write_flash -fm dio -fs 4MB 0x00000 $(FIRMWARE)

re:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file remove $(FILES)
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload $(FILES)

ls:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file list

restart:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) node restart

terminal:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) terminal