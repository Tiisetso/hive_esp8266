PORT := /dev/cu.wchusbserial140
BAUD := 115200

FIRMWARE  := firmware/nodemcu-release-16-modules-2025-07-03-13-37-07-float.bin

LUA_DIR := upload
LUA := $(wildcard $(LUA_DIR)/*.lua)

.PHONY: all upload clean rm-init rm-all restart console help flash

all: help

upload: 
	@echo "Uploading from $(LUA_DIR):"
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload $(LUA)

upload-c: 
	@echo "Compiling & uploading: $(LUA)"
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload --compile $(LUA)

rm-init:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file remove init.lua

fclean:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file remove *
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file list

flash:
	@echo "Flashing firmware $(FIRMWARE) to $(PORT)…"
	esptool.py --port $(PORT) write_flash -fm dio -fs 4MB 0x00000 $(FIRMWARE)

re:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file remove *
	nodemcu-uploader --port $(PORT) --baud $(BAUD) upload $(LUA)

ls:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) file list

restart:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) node restart

terminal:
	nodemcu-uploader --port $(PORT) --baud $(BAUD) terminal

help:
	@echo "Usage:"
	@echo "  make upload      — upload all .lua files"
	@echo "  make upload-c    — compile & upload all .lua files"
	@echo "  make rm-init     — delete init.lua"
	@echo "  make rm-all      — delete everything"
	@echo "  make restart     — soft‐reset the ESP"
	@echo "  make console     — open serial console"