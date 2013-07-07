setMode -bs
setMode -sm
setMode -hw140
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs

setCable -port auto

Identify -inferir
identifyMPM

assignFile -p 1 -file "BITSTREAM_FILE"
Program -p 1 -onlyFpga

quit
