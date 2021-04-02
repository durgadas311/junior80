all:	zout/rom.cim zout/bios.cim

TITLE_jr80-1 = "Test Junior-80 boot disk"
TITLE_jr80-2 = "Test Junior-80 boot disk 2"
TITLE_jr80-ws = "WordStar Distro disk"

bios:	zout/bios.cim

imd: jr80-1.imd jr80-2.imd jr80-ws.imd
xz: jr80-1.dsk.xz jr80-2.dsk.xz jr80-ws.dsk.xz

zout/%.cim: %.asm
	zmac --dri -i -8 -c -s -n $<

%.dsk.xz: %.dsk
	xz -z -k -f $<

%.imd: %.dsk
	raw2imd -c 80 -h 2 -s 9 -l 512 -m -o 1 -T $(TITLE_$*) $< $@

check: rom.bin zout/rom.cim
	sum $^

# To patch CP/M into a disk image:
# Create a 720K blank image:
# dd if=/dev/zero count=1440 |tr '\000' '\345' >blank.dsk
# Create CP/M 2.2 distribution files:
# cp blank.dsk cpm22.dsk
# cpmcp -f jr80 cpm22.dsk ~/Downloads/cpm22dist/* 0:
# cpmcp -t -f jr80 cpm22.dsk dump.asm sysgen.asm 0:
# Create sysgen'd Junior-80 disk:
# cp cpm22.dsk jr80-1.dsk
# dd if=~/Downloads/junior80/tpd801.raw bs=1 count=5639 conv=notrunc of=jr80-1.dsk
# dd if=zout/bios.cim bs=1 seek=5639 conv=notrunc of=jr80-1.dsk
# Compress for github:
# xz -z -k -f jr80-1.dsk
# Create IMD
# raw2imd -c 80 -h 2 -s 9 -l 512 -m -o 1 -T "Test Junior-80 boot disk" jr80-1.dsk jr80-1.imd
# cpmcp -t -f jr80 jr80-2.dsk rom.mac 0:rom.asm
# cpmcp -t -f jr80 jr80-2.dsk bios.mac 0:bios.asm
