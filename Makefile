all:	zout/rom.cim zout/bios.cim

TITLE_jr80-1 = "Test Junior-80 boot disk"
TITLE_jr80-2 = "Test Junior-80 boot disk 2"
TITLE_jr80-ws = "WordStar Distro disk"

bios:	zout/bios.cim

img: xz imd

imd: jr80-1.imd jr80-2.imd jr80-ws.imd
xz: jr80-1.dsk.xz jr80-2.dsk.xz jr80-ws.dsk.xz

zout/%.cim: %.asm
	zmac --dri -i -8 -c -s -n $<

%.dsk.xz: %.dsk
	xz -z -k -f $<

%.imd: %.dsk
	raw2imd -c 80 -h 2 -s 9 -l 512 -m -o 1 -T $(TITLE_$*) $< $@

# show sum of originam ROM and current build
check: rom.bin zout/rom.cim
	sum $^

# These should work as long as the system tracks layout is unchanged.
# 5639 = 0x1607 = 0x1600 (traditional BIOS offset) + 7 (Jr80 boot header)
jr80-1.dsk: zout/bios.cim
	dd if=zout/bios.cim bs=1 seek=5639 conv=notrunc of=$@

jr80-2.dsk:: zout/bios.cim
	dd if=zout/bios.cim bs=1 seek=5639 conv=notrunc of=$@

jr80-2.dsk:: rom.mac
	-cpmrm -f jr80 jr80-2.dsk 0:rom.asm
	cpmcp -t -f jr80 jr80-2.dsk ./rom.mac 0:rom.asm

jr80-2.dsk:: bios.mac
	-cpmrm -f jr80 jr80-2.dsk 0:bios.asm
	cpmcp -t -f jr80 jr80-2.dsk ./bios.mac 0:bios.asm

jr80-2.dsk:: zout/sysgen.cim
	-cpmrm -f jr80 jr80-2.dsk 0:'sysgen.*'
	cpmcp -f jr80 jr80-2.dsk $< 0:sysgen.com
	cpmcp -t -f jr80 jr80-2.dsk ./sysgen.asm 0:

#jr80-2.dsk:: zout/judisk.cim
#	-cpmrm -f jr80 jr80-2.dsk 0:'judisk.*'
#	cpmcp -f jr80 jr80-2.dsk $< 0:judisk.com
#	cpmcp -t -f jr80 jr80-2.dsk ./judisk.asm 0:

bios.mac: bios.asm
	sed -e 's/\([A-Z0-9]\)_\([A-Z0-9]\)/\1@\2/g' $< >$@

rom.mac: rom.asm
	sed -e 's/\([A-Z0-9]\)_\([A-Z0-9]\)/\1@\2/g' $< >$@

# To patch CP/M into a disk image:
# Create a 720K blank image:
# dd if=/dev/zero count=1440 |tr '\000' '\345' >blank.dsk
# Create CP/M 2.2 distribution files:
# cp blank.dsk cpm22.dsk
# cpmcp -f jr80 cpm22.dsk ~/Downloads/cpm22dist/* 0:
# cpmcp -t -f jr80 cpm22.dsk dump.asm 0:
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
