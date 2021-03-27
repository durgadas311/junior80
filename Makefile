all:	zout/rom.cim zout/bios.cim

bios:	zout/bios.cim

zout/rom.cim: rom.asm
	zmac --dri -i -8 -c -s -n rom.asm

zout/bios.cim: bios.asm
	zmac --dri -i -8 -c -s -n bios.asm

check: rom.bin zout/rom.cim
	sum $^
