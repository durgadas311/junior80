all:	zout/bios.cim

zout/%.cim: %.asm
	zmac --dri -i -8 -c -s -n $<

check: chk_bios

chk_bios: bios.bin zout/bios.cim
	sum $^

chk_idisk: idisk.com zout/idisk.cim
	sum $^

chk_judisk: judisk.com zout/judisk.cim
	sum $^
