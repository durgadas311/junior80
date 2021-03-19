all:	zout/bios.cim

zout/bios.cim: bios.asm
	zmac --dri -i -8 -c -s -n bios.asm

check: bios.bin zout/bios.cim
	sum $^
