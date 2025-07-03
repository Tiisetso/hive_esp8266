

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



https://api.digitransit.fi/graphiql/hsl/v2/gtfs/v1?query=%257B%250A%2520%2520stop%28id%253A%2520%2522HSL%253A1112126%2522%29%2520%257B%250A%2520%2520%2520%2520name%250A%2520%2520%2520%2520lat%250A%2520%2520%2520%2520lon%250A%2520%2520%2520%2520wheelchairBoarding%250A%2520%2520%2520%2520id%250A%2520%2520%2520%2520stoptimesWithoutPatterns%257B%250A%2520%2520%2520%2520%2520%2520realtimeArrival%250A%2520%2520%2520%2520%2520%2520headsign%250A%2520%2520%2520%2520trip%2520%257B%250A%2520%2520%2520%2520%2520%2520route%2520%257B%250A%2520%2520%2520%2520%2520%2520%2520%2520shortName%250A%2520%2520%2520%2520%2520%2520%257D%250A%2520%2520%2520%2520%257D%250A%2520%2520%257D%250A%2520%2520%257D%250A%257D