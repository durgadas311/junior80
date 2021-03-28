all:	zout/rom.cim zout/bios.cim

bios:	zout/bios.cim

zout/rom.cim: rom.asm
	zmac --dri -i -8 -c -s -n rom.asm

zout/bios.cim: bios.asm
	zmac --dri -i -8 -c -s -n bios.asm

check: rom.bin zout/rom.cim
	sum $^

# To patch CP/M into a disk image:
# Create a 720K blank image:
# dd if=/dev/zero count=1440 |tr '\000' '\345' >blank.dsk
# Create CP/M 2.2 distribution files:
# cp blank.dsk cpm22.dsk
# cpmcp -f jr80 cpm22.dsk ~/Downloads/cpm22dist/* 0:
# Create sysgen'd Junior-80 disk:
# cp cpm22.dsk jr80-1.dsk
# dd if=~/Downloads/junior80/tpd801.raw bs=1 count=5639 conv=notrunc of=jr80-1.dsk
# dd if=zout/bios.cim bs=1 seek=5639 conv=notrunc of=jr80-1.dsk
