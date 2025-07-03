PORT := /dev/cu.wchusbserial140
BAUD := 115200

LUA_DIR := upload
LUA := $(wildcard $(LUA_DIR)/*.lua)

.PHONY: all upload clean rm-init rm-all restart console help

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
	${ls}

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