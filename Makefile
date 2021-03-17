all:	zout/rom.cim

zout/rom.cim: rom.asm
	zmac --dri -i -8 -c -s -n rom.asm
