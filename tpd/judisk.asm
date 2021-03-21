; Disk util for Junior, not Junior80 or Tpd

	maclib	z80

cpm	equ	0000h
bdos	equ	0005h
tpa	equ	0100h

; BDOS functions
dircon	equ	6

; I/O ports
DMA_1A	equ	32h
DMA_1C	equ	33h
DMA_CTL	equ	38h

FDC_STS	equ	40h
FDC_DAT	equ	41h

DMA_RD	equ	80h
DMA_WR	equ	40h
DMA_FDC	equ	0010b

CTLC	equ	3
BEL	equ	7
TAB	equ	9
LF	equ	10
CR	equ	13
SYN	equ	22	; erase EOL
CAN	equ	24	; clear screen

	org	tpa
	lxi	sp,L0a6a	;; 0100: 31 6a 0a    1j.
	lhld	cpm+1		;; 0103: 2a 01 00    *..
	lxi	d,50		;; 0106: 11 32 00    .2.
	dad	d		;; 0109: 19          .
	mov	a,m		;; 010a: 7e          ~
	cpi	'j'		;; 010b: fe 6a       .j
	jnz	L011f		;; 010d: c2 1f 01    ...
	lxi	d,6		;; 0110: 11 06 00    ...
	dad	d		;; 0113: 19          .
	mov	a,m		;; 0114: 7e          ~
	cpi	'5'		;; 0115: fe 35       .5
	jz	L0145		;; 0117: ca 45 01    .E.
	cpi	'6'		;; 011a: fe 36       .6
	jz	L014b		;; 011c: ca 4b 01    .K.
L011f:	call	print		;; 011f: cd de 05    ...
	db	CAN,BEL,'\WRONG SYSTEM, TRY ANOTHER ',21h,'\$'
	jmp	cpm		;; 0142: c3 00 00    ...

L0145:	lxi	d,109		;; 0145: 11 6d 00    .m.
	jmp	L014e		;; 0148: c3 4e 01    .N.

L014b:	lxi	d,123		;; 014b: 11 7b 00    .{.
L014e:	lhld	cpm+1		;; 014e: 2a 01 00    *..
	dad	d		;; 0151: 19          .
	shld	L0944		;; 0152: 22 44 09    "D.
	mov	e,m		;; 0155: 5e          ^
	inx	h		;; 0156: 23          #
	mov	d,m		;; 0157: 56          V
	dcx	h		;; 0158: 2b          +
	xchg			;; 0159: eb          .
	shld	L0942		;; 015a: 22 42 09    "B.
	di			;; 015d: f3          .
	lxi	h,L0dcf		;; 015e: 21 cf 0d    ...
	xchg			;; 0161: eb          .
	mov	m,e		;; 0162: 73          s
	inx	h		;; 0163: 23          #
	mov	m,d		;; 0164: 72          r
	call	L04a3		;; 0165: cd a3 04    ...
	ei			;; 0168: fb          .
L0169:	call	print		;; 0169: cd de 05    ...
	db	CAN,'\** junior **  '
L017c:	db	' " DISK UTILITY v2.62\\'
	db	TAB,'The disk utility has the following options:\\'
	db	'COPY DISK   -  duplicate a diskette using two floppy disk drives.\'
	db	'Both source and target diskettes must have the same density.\'
	db	'After writing a track, it is read into memory and verified.\\'
	db	'FORMAT DISK - format diskettes in single or double density.\'
	db	'After format the diskette is read and verified to be all 0E5H.\\'
	db	'VERIFY DISK - verify all sectors on a diskette.\'
	db	'Errors are reported by physical track and sector locations.\'
	db	'After completion, the number of read errors is typed.\'
	db	'The test will not destroy data on the diskette.\\'
	db	'Press any time CTRL/C to break execution and exit to system.$'
L0409:	call	print		;; 0409: cd de 05    ...
	db	'\\\\\\Select option (C)opy, (F)ormat, (V)erify, (E)XIT: $'
	call	conine		;; 0445: cd 61 05    .a.
	cpi	'F'		;; 0448: fe 46       .F
	jz	L0619		;; 044a: ca 19 06    ...
	cpi	'V'		;; 044d: fe 56       .V
	jz	L0e0f		;; 044f: ca 0f 0e    ...
	cpi	'C'		;; 0452: fe 43       .C
	jz	L0f69		;; 0454: ca 69 0f    .i.
	cpi	'E'		;; 0457: fe 45       .E
	jz	L0461		;; 0459: ca 61 04    .a.
	cpi	CTLC		;; 045c: fe 03       ..
	jnz	L0169		;; 045e: c2 69 01    .i.
L0461:	call	print		;; 0461: cd de 05    ...
	db	'\\Load system disk A: and type (CR)$'
	call	conin		;; 0488: cd 73 05    .s.
	mvi	a,018h		;; 048b: 3e 18       >.
	call	conout		;; 048d: cd 64 05    .d.
	di			;; 0490: f3          .
	call	L04a3		;; 0491: cd a3 04    ...
	lhld	L0944		;; 0494: 2a 44 09    *D.
	xchg			;; 0497: eb          .
	lhld	L0942		;; 0498: 2a 42 09    *B.
	xchg			;; 049b: eb          .
	mov	m,e		;; 049c: 73          s
	inx	h		;; 049d: 23          #
	mov	m,d		;; 049e: 72          r
	ei			;; 049f: fb          .
	jmp	00000h		;; 04a0: c3 00 00    ...

L04a3:	xra	a		;; 04a3: af          .
	sta	L09ba		;; 04a4: 32 ba 09    2..
	lhld	cpm+1		;; 04a7: 2a 01 00    *..
	lxi	d,59		;; 04aa: 11 3b 00    .;.
	dad	d		;; 04ad: 19          .
	mov	a,m		;; 04ae: 7e          ~
	cpi	'm'		;; 04af: fe 6d       .m
	jz	L04e1		;; 04b1: ca e1 04    ...
	mvi	a,'8'		;; 04b4: 3e 38       >8
	sta	L017c		;; 04b6: 32 7c 01    2|.
	mvi	a,04dh		;; 04b9: 3e 4d       >M
	call	L051a		;; 04bb: cd 1a 05    ...
	mvi	b,010h		;; 04be: 06 10       ..
	mvi	c,01ah		;; 04c0: 0e 1a       ..
	call	L0524		;; 04c2: cd 24 05    .$.
	lxi	d,L0991		;; 04c5: 11 91 09    ...
	lxi	h,L0977		;; 04c8: 21 77 09    .w.
	call	L054d		;; 04cb: cd 4d 05    .M.
	lxi	h,019ffh	;; 04ce: 21 ff 19    ...
	shld	L0ae2+1		;; 04d1: 22 e3 0a    "..
	lxi	h,01fffh	;; 04d4: 21 ff 1f    ...
	shld	L0aeb+1		;; 04d7: 22 ec 0a    "..
	lxi	h,L0cff		;; 04da: 21 ff 0c    ...
	shld	L0af4+1		;; 04dd: 22 f5 0a    "..
	ret			;; 04e0: c9          .

L04e1:	mvi	a,035h		;; 04e1: 3e 35       >5
	sta	L017c		;; 04e3: 32 7c 01    2|.
	inx	h		;; 04e6: 23          #
	mov	a,m		;; 04e7: 7e          ~
	cpi	041h		;; 04e8: fe 41       .A
	jnz	L0515		;; 04ea: c2 15 05    ...
	mvi	a,028h		;; 04ed: 3e 28       >(
L04ef:	call	L051a		;; 04ef: cd 1a 05    ...
	mvi	b,009h		;; 04f2: 06 09       ..
	mvi	c,010h		;; 04f4: 0e 10       ..
	call	L0524		;; 04f6: cd 24 05    .$.
	lxi	d,L09b1		;; 04f9: 11 b1 09    ...
	lxi	h,L09a1		;; 04fc: 21 a1 09    ...
	call	L054d		;; 04ff: cd 4d 05    .M.
	lxi	h,00fffh	;; 0502: 21 ff 0f    ...
	shld	L0ae2+1		;; 0505: 22 e3 0a    "..
	lxi	h,011ffh	;; 0508: 21 ff 11    ...
	shld	L0aeb+1		;; 050b: 22 ec 0a    "..
	lxi	h,007ffh	;; 050e: 21 ff 07    ...
	shld	L0af4+1		;; 0511: 22 f5 0a    "..
	ret			;; 0514: c9          .

L0515:	mvi	a,023h		;; 0515: 3e 23       >#
	jmp	L04ef		;; 0517: c3 ef 04    ...

L051a:	sta	L090a+1		;; 051a: 32 0b 09    2..
	sta	L0ee3+1		;; 051d: 32 e4 0e    2..
	sta	L11e3		;; 0520: 32 e3 11    2..
	ret			;; 0523: c9          .

L0524:	mov	a,c		;; 0524: 79          y
	sta	L0712+1		;; 0525: 32 13 07    2..
	sta	L083d+1		;; 0528: 32 3e 08    2>.
	sta	L0845+1		;; 052b: 32 46 08    2F.
	inr	a		;; 052e: 3c          <
	sta	L089b+1		;; 052f: 32 9c 08    2..
	dcr	a		;; 0532: 3d          =
	sta	L08f0+1		;; 0533: 32 f1 08    2..
	sta	L0966		;; 0536: 32 66 09    2f.
	sta	L0972		;; 0539: 32 72 09    2r.
	sta	L0f5e+1		;; 053c: 32 5f 0f    2_.
	mov	a,b		;; 053f: 78          x
	sta	L078e+1		;; 0540: 32 8f 07    2..
	sta	L08f5+1		;; 0543: 32 f6 08    2..
	sta	L096c		;; 0546: 32 6c 09    2l.
	sta	L0f63+1		;; 0549: 32 64 0f    2d.
	ret			;; 054c: c9          .

L054d:	shld	L08d7+1		;; 054d: 22 d8 08    "..
	shld	L0f45+1		;; 0550: 22 46 0f    "F.
	shld	L1238		;; 0553: 22 38 12    "8.
	xchg			;; 0556: eb          .
	shld	L08cf+1		;; 0557: 22 d0 08    "..
	shld	L0f3d+1		;; 055a: 22 3e 0f    ">.
	shld	L1230		;; 055d: 22 30 12    "0.
	ret			;; 0560: c9          .

conine:	call	conin		;; 0561: cd 73 05    .s.
conout:	push	psw		;; 0564: f5          .
	push	b		;; 0565: c5          .
	push	d		;; 0566: d5          .
	push	h		;; 0567: e5          .
	mov	e,a		;; 0568: 5f          _
	mvi	c,dircon	;; 0569: 0e 06       ..
	call	bdos		;; 056b: cd 05 00    ...
	pop	h		;; 056e: e1          .
	pop	d		;; 056f: d1          .
	pop	b		;; 0570: c1          .
	pop	psw		;; 0571: f1          .
	ret			;; 0572: c9          .

; Wait for input, toupper
conin:	push	b		;; 0573: c5          .
	push	d		;; 0574: d5          .
	push	h		;; 0575: e5          .
L0576:	mvi	c,dircon	;; 0576: 0e 06       ..
	mvi	e,0ffh		;; 0578: 1e ff       ..
	call	bdos		;; 057a: cd 05 00    ...
	ora	a		;; 057d: b7          .
	jz	L0576		;; 057e: ca 76 05    .v.
	pop	h		;; 0581: e1          .
	pop	d		;; 0582: d1          .
	pop	b		;; 0583: c1          .
	cpi	'a'		;; 0584: fe 61       .a
	rc			;; 0586: d8          .
	cpi	'z'+1		;; 0587: fe 7b       .{
	rnc			;; 0589: d0          .
	sui	020h	; toupper
	ret			;; 058c: c9          .

conbrk:	push	b		;; 058d: c5          .
	push	d		;; 058e: d5          .
	push	h		;; 058f: e5          .
	mvi	c,dircon	;; 0590: 0e 06       ..
	mvi	e,0ffh		;; 0592: 1e ff       ..
	call	bdos		;; 0594: cd 05 00    ...
	pop	h		;; 0597: e1          .
	pop	d		;; 0598: d1          .
	pop	b		;; 0599: c1          .
	ora	a		;; 059a: b7          .
	rz			;; 059b: c8          .
	cpi	CTLC		;; 059c: fe 03       ..
	rnz			;; 059e: c0          .
L059f:	call	print		;; 059f: cd de 05    ...
	db	'\Break program execution (Y/N)? $'
	call	conin		;; 05c3: cd 73 05    .s.
	cpi	'Y'		;; 05c6: fe 59       .Y
	jz	L05d4		;; 05c8: ca d4 05    ...
	call	print		;; 05cb: cd de 05    ...
	db	'No$'
	jmp	L05f0		;; 05d1: c3 f0 05    ...

L05d4:	call	print		;; 05d4: cd de 05    ...
	db	'Yes$'
	jmp	L0409		;; 05db: c3 09 04    ...

print:	xthl			;; 05de: e3          .
	mov	a,m		;; 05df: 7e          ~
	inx	h		;; 05e0: 23          #
	cpi	024h		;; 05e1: fe 24       .$
	xthl			;; 05e3: e3          .
	rz			;; 05e4: c8          .
	cpi	05ch		;; 05e5: fe 5c       .\
	cnz	conout		;; 05e7: c4 64 05    .d.
	cz	L05f0		;; 05ea: cc f0 05    ...
	jmp	print		;; 05ed: c3 de 05    ...

L05f0:	call	print		;; 05f0: cd de 05    ...
	db	CR,LF,'$'
	ret			;; 05f6: c9          .

L05f7:	push	b		;; 05f7: c5          .
	push	d		;; 05f8: d5          .
	push	h		;; 05f9: e5          .
	lxi	b,0fff6h	;; 05fa: 01 f6 ff    ...
	lxi	d,0ffffh	;; 05fd: 11 ff ff    ...
L0600:	dad	b		;; 0600: 09          .
	inx	d		;; 0601: 13          .
	jc	L0600		;; 0602: da 00 06    ...
	lxi	b,0000ah	;; 0605: 01 0a 00    ...
	dad	b		;; 0608: 09          .
	xchg			;; 0609: eb          .
	mov	a,h		;; 060a: 7c          |
	ora	l		;; 060b: b5          .
	cnz	L05f7		;; 060c: c4 f7 05    ...
	mov	a,e		;; 060f: 7b          {
	adi	030h		;; 0610: c6 30       .0
	call	conout		;; 0612: cd 64 05    .d.
	pop	h		;; 0615: e1          .
	pop	d		;; 0616: d1          .
	pop	b		;; 0617: c1          .
	ret			;; 0618: c9          .

L0619:	mvi	a,018h		;; 0619: 3e 18       >.
	call	conout		;; 061b: cd 64 05    .d.
L061e:	lxi	sp,L0a6a	;; 061e: 31 6a 0a    1j.
	call	print		;; 0621: cd de 05    ...
	db	'\\\\FORMAT DISK UTILITY$'
L063c:	call	print		;; 063c: cd de 05    ...
	db	'\\Select disk (A-D) to FORMAT or type (SPACE) to reboot: $'
	call	conine		;; 0679: cd 61 05    .a.
	cpi	CR		;; 067c: fe 0d       ..
	jz	L061e		;; 067e: ca 1e 06    ...
	cpi	CTLC		;; 0681: fe 03       ..
	jz	L0461		;; 0683: ca 61 04    .a.
	cpi	' '		;; 0686: fe 20       . 
	jz	L0169		;; 0688: ca 69 01    .i.
	sta	L07e7		;; 068b: 32 e7 07    2..
	sui	'A'		;; 068e: d6 41       .A
	jc	L063c		;; 0690: da 3c 06    .<.
	cpi	'D'-'A'+1	;; 0693: fe 04       ..
	jnc	L063c		;; 0695: d2 3c 06    .<.
	sta	L0960		;; 0698: 32 60 09    2`.
	sta	L0955		;; 069b: 32 55 09    2U.
	call	L0d7f		;; 069e: cd 7f 0d    ...
	lxi	h,L1263		;; 06a1: 21 63 12    .c.
	shld	L094c		;; 06a4: 22 4c 09    "L.
L06a7:	call	print		;; 06a7: cd de 05    ...
	db	'\Select single or double density (S/D): $'
	call	conin		;; 06d3: cd 73 05    .s.
	cpi	'D'		;; 06d6: fe 44       .D
	jz	L071f		;; 06d8: ca 1f 07    ...
	cpi	'S'		;; 06db: fe 53       .S
	jz	L06f2		;; 06dd: ca f2 06    ...
	cpi	CR		;; 06e0: fe 0d       ..
	jz	L061e		;; 06e2: ca 1e 06    ...
	cpi	CTLC		;; 06e5: fe 03       ..
	jz	L0461		;; 06e7: ca 61 04    .a.
	cpi	' '		;; 06ea: fe 20       . 
	jz	L0169		;; 06ec: ca 69 01    .i.
	jmp	L06a7		;; 06ef: c3 a7 06    ...

L06f2:	call	print		;; 06f2: cd de 05    ...
	db	CR,SYN,'Single density$'
	mvi	b,000h		;; 0706: 06 00       ..
	mvi	a,00dh		;; 0708: 3e 0d       >.
	sta	L095f		;; 070a: 32 5f 09    2_.
	mvi	a,000h		;; 070d: 3e 00       >.
	sta	L0961		;; 070f: 32 61 09    2a.
L0712:	mvi	a,01ah		;; 0712: 3e 1a       >.
	sta	L0962		;; 0714: 32 62 09    2b.
	mvi	a,01bh		;; 0717: 3e 1b       >.
	sta	L0963		;; 0719: 32 63 09    2c.
	jmp	L07ae		;; 071c: c3 ae 07    ...

L071f:	call	print		;; 071f: cd de 05    ...
	db	CR,SYN,'Double density$'
	call	print		;; 0733: cd de 05    ...
	db	'\Select 256 or 512 bytes/sector  (2/5): $'
	call	conin		;; 075f: cd 73 05    .s.
	cpi	'2'		;; 0762: fe 32       .2
	jz	L082d		;; 0764: ca 2d 08    .-.
	cpi	'5'		;; 0767: fe 35       .5
	jz	L077e		;; 0769: ca 7e 07    .~.
	cpi	CR		;; 076c: fe 0d       ..
	jz	L061e		;; 076e: ca 1e 06    ...
	cpi	CTLC		;; 0771: fe 03       ..
	jz	L0461		;; 0773: ca 61 04    .a.
	cpi	' '		;; 0776: fe 20       . 
	jz	L0169		;; 0778: ca 69 01    .i.
	jmp	L071f		;; 077b: c3 1f 07    ...

L077e:	call	print		;; 077e: cd de 05    ...
	db	CR,SYN,'512$'
	mvi	b,002h		;; 0787: 06 02       ..
	mvi	a,002h		;; 0789: 3e 02       >.
	sta	L0961		;; 078b: 32 61 09    2a.
L078e:	mvi	a,010h		;; 078e: 3e 10       >.
L0790:	sta	L0962		;; 0790: 32 62 09    2b.
	mvi	a,036h		;; 0793: 3e 36       >6
	sta	L0963		;; 0795: 32 63 09    2c.
	mvi	a,04dh		;; 0798: 3e 4d       >M
	sta	L095f		;; 079a: 32 5f 09    2_.
	call	print		;; 079d: cd de 05    ...
	db	' bytes/sector$'
L07ae:	mov	a,b		;; 07ae: 78          x
	sta	L0946		;; 07af: 32 46 09    2F.
L07b2:	call	print		;; 07b2: cd de 05    ...
	db	'\Check diskette (FORMAT will destroy data on disk '
L07e7:	db	'A:)\'
	db	'Type (CR) to continue or (SPACE) to abort$'
	call	conin		;; 0815: cd 73 05    .s.
	cpi	CTLC		;; 0818: fe 03       ..
	jz	L0461		;; 081a: ca 61 04    .a.
	cpi	' '		;; 081d: fe 20       . 
	jz	L061e		;; 081f: ca 1e 06    ...
	cpi	CR		;; 0822: fe 0d       ..
	jnz	L07b2		;; 0824: c2 b2 07    ...
	call	L05f0		;; 0827: cd f0 05    ...
	jmp	L088c		;; 082a: c3 8c 08    ...

L082d:	call	print		;; 082d: cd de 05    ...
	db	CR,SYN,'256$'
	mvi	b,001h		;; 0836: 06 01       ..
	mvi	a,001h		;; 0838: 3e 01       >.
	sta	L0961		;; 083a: 32 61 09    2a.
L083d:	mvi	a,01ah		;; 083d: 3e 1a       >.
	jmp	L0790		;; 083f: c3 90 07    ...

L0842:	lxi	d,00004h	;; 0842: 11 04 00    ...
L0845:	mvi	c,01ah		;; 0845: 0e 1a       ..
L0847:	mov	m,a		;; 0847: 77          w
	dad	d		;; 0848: 19          .
	dcr	c		;; 0849: 0d          .
	rz			;; 084a: c8          .
	jmp	L0847		;; 084b: c3 47 08    .G.

L084e:	mvi	a,005h		;; 084e: 3e 05       >.
L0850:	sta	L0947		;; 0850: 32 47 09    2G.
	di			;; 0853: f3          .
	lxi	h,L09c2		;; 0854: 21 c2 09    ...
	mov	a,l		;; 0857: 7d          }
	out	DMA_1A		;; 0858: d3 32       .2
	mov	a,h		;; 085a: 7c          |
	out	DMA_1A		;; 085b: d3 32       .2
	lda	L0962		;; 085d: 3a 62 09    :b.
	ral			;; 0860: 17          .
	ral			;; 0861: 17          .
	ani	0fch		;; 0862: e6 fc       ..
	dcr	a		;; 0864: 3d          =
	out	DMA_1C		;; 0865: d3 33       .3
	mvi	a,DMA_RD	;; 0867: 3e 80       >.
	out	DMA_1C		;; 0869: d3 33       .3
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL		;; 086d: d3 38       .8
	ei			;; 086f: fb          .
	lxi	h,L095f		;; 0870: 21 5f 09    ._.
	mvi	c,005h		;; 0873: 0e 05       ..
	call	L0abc		;; 0875: cd bc 0a    ...
	rz			;; 0878: c8          .
	mov	a,m		;; 0879: 7e          ~
	ani	018h		;; 087a: e6 18       ..
	cnz	L0d43		;; 087c: c4 43 0d    .C.
	lda	L0947		;; 087f: 3a 47 09    :G.
	dcr	a		;; 0882: 3d          =
	jnz	L0850		;; 0883: c2 50 08    .P.
	lxi	h,L09bc		;; 0886: 21 bc 09    ...
	jmp	L0c20		;; 0889: c3 20 0c    . .

L088c:	call	L0b0b		;; 088c: cd 0b 0b    ...
	call	L0d9b		;; 088f: cd 9b 0d    ...
	lda	L0961		;; 0892: 3a 61 09    :a.
	mov	b,a		;; 0895: 47          G
	lxi	h,L09c2		;; 0896: 21 c2 09    ...
	xra	a		;; 0899: af          .
L089a:	inr	a		;; 089a: 3c          <
L089b:	cpi	01bh		;; 089b: fe 1b       ..
	jnc	L08ad		;; 089d: d2 ad 08    ...
	mvi	m,000h		;; 08a0: 36 00       6.
	inx	h		;; 08a2: 23          #
	mvi	m,000h		;; 08a3: 36 00       6.
	inx	h		;; 08a5: 23          #
	mov	m,a		;; 08a6: 77          w
	inx	h		;; 08a7: 23          #
	mov	m,b		;; 08a8: 70          p
	inx	h		;; 08a9: 23          #
	jmp	L089a		;; 08aa: c3 9a 08    ...

L08ad:	mvi	a,005h		;; 08ad: 3e 05       >.
L08af:	sta	L0949		;; 08af: 32 49 09    2I.
	call	L084e		;; 08b2: cd 4e 08    .N.
	jz	L08c8		;; 08b5: ca c8 08    ...
	lda	L0949		;; 08b8: 3a 49 09    :I.
	dcr	a		;; 08bb: 3d          =
	jnz	L08af		;; 08bc: c2 af 08    ...
	call	L05f0		;; 08bf: cd f0 05    ...
	call	L059f		;; 08c2: cd 9f 05    ...
	jmp	L0900		;; 08c5: c3 00 09    ...

L08c8:	lxi	b,00000h	;; 08c8: 01 00 00    ...
L08cb:	push	b		;; 08cb: c5          .
	lda	L0946		;; 08cc: 3a 46 09    :F.
L08cf:	lxi	h,L0991		;; 08cf: 21 91 09    ...
	cpi	002h		;; 08d2: fe 02       ..
	jz	L08da		;; 08d4: ca da 08    ...
L08d7:	lxi	h,L0977		;; 08d7: 21 77 09    .w.
L08da:	dad	b		;; 08da: 09          .
	mov	a,m		;; 08db: 7e          ~
	sta	L0958		;; 08dc: 32 58 09    2X.
	call	L0b9c		;; 08df: cd 9c 0b    ...
	pop	b		;; 08e2: c1          .
	jnz	L091b		;; 08e3: c2 1b 09    ...
	inr	c		;; 08e6: 0c          .
	lda	L0946		;; 08e7: 3a 46 09    :F.
	cpi	002h		;; 08ea: fe 02       ..
	mov	a,c		;; 08ec: 79          y
	jz	L08f5		;; 08ed: ca f5 08    ...
L08f0:	cpi	01ah		;; 08f0: fe 1a       ..
	jmp	L08f7		;; 08f2: c3 f7 08    ...

L08f5:	cpi	010h		;; 08f5: fe 10       ..
L08f7:	jc	L08cb		;; 08f7: da cb 08    ...
	call	print		;; 08fa: cd de 05    ...
	db	CR,SYN,'$'
L0900:	call	conbrk		;; 0900: cd 8d 05    ...
	lda	L0956		;; 0903: 3a 56 09    :V.
	inr	a		;; 0906: 3c          <
	sta	L0956		;; 0907: 32 56 09    2V.
L090a:	cpi	04dh		;; 090a: fe 4d       .M
	jnc	L092b		;; 090c: d2 2b 09    .+.
	lxi	h,L09c2		;; 090f: 21 c2 09    ...
	call	L0842		;; 0912: cd 42 08    .B.
	call	L0dac		;; 0915: cd ac 0d    ...
	jmp	L08ad		;; 0918: c3 ad 08    ...

L091b:	lda	L0949		;; 091b: 3a 49 09    :I.
	dcr	a		;; 091e: 3d          =
	jnz	L08af		;; 091f: c2 af 08    ...
	call	L05f0		;; 0922: cd f0 05    ...
	call	L059f		;; 0925: cd 9f 05    ...
	jmp	L0900		;; 0928: c3 00 09    ...

L092b:	call	print		;; 092b: cd de 05    ...
	db	'\FORMAT complete$'
	jmp	L061e		;; 093f: c3 1e 06    ...

L0942:	db	0,0
L0944:	db	0,0
L0946:	db	0
L0947:	db	5
L0948:	db	0
L0949:	db	3
L094a:	db	0,0
L094c:	db	0,0
L094e:	db	0,0
L0950:	db	0
L0951:	db	0
L0952:	db	0
L0953:	db	0
L0954:	db	0
L0955:	db	0
L0956:	db	0,0
L0958:	db	1
L0959:	db	0,0,0,0
L095d:	db	0
L095e:	db	0
L095f:	db	0
L0960:	db	0
L0961:	db	0
L0962:	db	0
L0963:	db	0,0e5h
L0965:	db	1
L0966:	db	1ah,0eh,0ffh,'FE'
L096b:	db	2
L096c:	db	10h,0eh,0ffh,'FE'
L0971:	db	0
L0972:	db	1ah,7,80h,6,5
L0977:	db	1,3,5,7,9,0bh,0dh,0fh,11h,13h,15h,17h,19h,2,4,6,8,0ah,0ch
	db	0eh,10h,12h,14h,16h,18h,1ah
L0991:	db	1,3,5,7,9,0bh,0dh,0fh,2,4,6,8,0ah,0ch,0eh,10h
L09a1:	db	1,3,5,7,9,0bh,0dh,0fh,2,4,6,8,0ah,0ch,0eh,10h
L09b1:	db	1,3,5,7,9,2,4,6,8
L09ba:	db	0,0
L09bc:	db	0,0,0,0,0
L09c1:	db	0
L09c2:	db	0
if 0
	jmp	L06fe		;; 09c3: c3 fe 06    ...

	call	L0c90		;; 09c6: cd 90 0c    ...
	jz	L07e5		;; 09c9: ca e5 07    ...
	call	L0c66		;; 09cc: cd 66 0c    .f.
	jc	L07d5		;; 09cf: da d5 07    ...
	shld	L0f5d		;; 09d2: 22 5d 0f    "].
	ani	07fh		;; 09d5: e6 7f       ..
	dcr	a		;; 09d7: 3d          =
	jz	L07e5		;; 09d8: ca e5 07    ...
	call	L0c66		;; 09db: cd 66 0c    .f.
	dcr	a		;; 09de: 3d          =
	jnz	L0bab		;; 09df: c2 ab 0b    ...
	jmp	L07f0		;; 09e2: c3 f0 07    ...

	lhld	L0f5d		;; 09e5: 2a 5d 0f    *].
	mov	a,l		;; 09e8: 7d          }
	ani	0f0h		;; 09e9: e6 f0       ..
	mov	l,a		;; 09eb: 6f          o
	lxi	d,000bfh	;; 09ec: 11 bf 00    ...
	dad	d		;; 09ef: 19          .
	shld	L0f5e+1		;; 09f0: 22 5f 0f    "_.
	call	L0c15		;; 09f3: cd 15 0c    ...
	call	L0c1f		;; 09f6: cd 1f 0c    ...
	jnz	L06fe		;; 09f9: c2 fe 06    ...
	lhld	L0f5d		;; 09fc: 2a 5d 0f    *].
	shld	L0f61		;; 09ff: 22 61 0f    "a.
	call	L0c2e		;; 0a02: cd 2e 0c    ...
	call	L0bc5		;; 0a05: cd c5 0b    ...
	mov	a,m		;; 0a08: 7e          ~
	call	L0c05		;; 0a09: cd 05 0c    ...
	inx	h		;; 0a0c: 23          #
	call	L0c45		;; 0a0d: cd 45 0c    .E.
	jc	L0819		;; 0a10: da 19 08    ...
	mov	a,l		;; 0a13: 7d          }
	ani	00fh		;; 0a14: e6 0f       ..
	jnz	L0805		;; 0a16: c2 05 08    ...
	shld	L0f5d		;; 0a19: 22 5d 0f    "].
	lhld	L0f61		;; 0a1c: 2a 61 0f    *a.
	xchg			;; 0a1f: eb          .
	call	L0bc5		;; 0a20: cd c5 0b    ...
	ldax	d		;; 0a23: 1a          .
	call	L0c36		;; 0a24: cd 36 0c    .6.
	inx	d		;; 0a27: 13          .
	lhld	L0f5d		;; 0a28: 2a 5d 0f    *].
	mov	a,l		;; 0a2b: 7d          }
	sub	e		;; 0a2c: 93          .
	jnz	L0823		;; 0a2d: c2 23 08    .#.
	mov	a,h		;; 0a30: 7c          |
	sub	d		;; 0a31: 92          .
	jnz	L0823		;; 0a32: c2 23 08    .#.
	lhld	L0f5d		;; 0a35: 2a 5d 0f    *].
	call	L0c45		;; 0a38: cd 45 0c    .E.
	jc	L06fe		;; 0a3b: da fe 06    ...
	jmp	L07f3		;; 0a3e: c3 f3 07    ...

	call	L0c90		;; 0a41: cd 90 0c    ...
	cpi	003h		;; 0a44: fe 03       ..
	jnz	L0bab		;; 0a46: c2 ab 0b    ...
	call	L0c66		;; 0a49: cd 66 0c    .f.
	push	h		;; 0a4c: e5          .
	call	L0c66		;; 0a4d: cd 66 0c    .f.
	push	h		;; 0a50: e5          .
	call	L0c66		;; 0a51: cd 66 0c    .f.
	pop	d		;; 0a54: d1          .
	pop	b		;; 0a55: c1          .
	ret			;; 0a56: c9          .
else
	db	0c3h,0feh,6,0cdh,90h,0ch,0cah,0e5h,7,0cdh,'f',0ch,0dah
	db	0d5h,7,'"]',0fh,0e6h,7fh,'=',0cah,0e5h,7,0cdh,'f',0ch,'='
	db	0c2h,0abh,0bh,0c3h,0f0h,7,'*]',0fh,'}',0e6h,0f0h,'o',11h
	db	0bfh,0,19h,'"_',0fh,0cdh,15h,0ch,0cdh,1fh,0ch,0c2h,0feh,6,'*'
	db	']',0fh,'"a',0fh,0cdh,'.',0ch,0cdh,0c5h,0bh,'~',0cdh,5,0ch
	db	'#',0cdh,'E',0ch,0dah,19h,8,'}',0e6h,0fh,0c2h,5,8,'"]',0fh
	db	'*a',0fh,0ebh,0cdh,0c5h,0bh,1ah,0cdh,'6',0ch,13h,'*]',0fh,'}'
	db	93h,0c2h,'#',8,'|',92h,0c2h,'#',8,'*]',0fh,0cdh,'E',0ch,0dah
	db	0feh,6,0c3h,0f3h,7,0cdh,90h,0ch,0feh,3,0c2h,0abh,0bh,0cdh,'f'
	db	0ch,0e5h,0cdh,'f',0ch,0e5h,0cdh,'f',0ch,0d1h,0c1h,0c9h
endif
	db	'{n',5,'5',0e6h,'2',0,0,0,9bh,0ah,0eah,5,0f6h,5,0edh,5,'B'
	db	1

L0a6a:	push	psw		;; 0a6a: f5          .
L0a6b:	in	FDC_STS		;; 0a6b: db 40       .@
	ani	01fh		;; 0a6d: e6 1f       ..
	jnz	L0a6b		;; 0a6f: c2 6b 0a    .k.
	pop	psw		;; 0a72: f1          .
L0a73:	push	psw		;; 0a73: f5          .
L0a74:	in	FDC_STS		;; 0a74: db 40       .@
	ral			;; 0a76: 17          .
	jnc	L0a74		;; 0a77: d2 74 0a    .t.
	ral			;; 0a7a: 17          .
	jc	L0a8f		;; 0a7b: da 8f 0a    ...
	pop	psw		;; 0a7e: f1          .
	out	FDC_DAT		;; 0a7f: d3 41       .A
	ret			;; 0a81: c9          .

L0a82:	in	FDC_STS		;; 0a82: db 40       .@
	ral			;; 0a84: 17          .
	jnc	L0a82		;; 0a85: d2 82 0a    ...
	ral			;; 0a88: 17          .
	jnc	L0a90		;; 0a89: d2 90 0a    ...
	in	FDC_DAT		;; 0a8c: db 41       .A
	ret			;; 0a8e: c9          .

L0a8f:	pop	psw		;; 0a8f: f1          .
L0a90:	call	print		;; 0a90: cd de 05    ...
	db	'\FDC ERROR, HARDWARE RESET REQUIRED',7,'$'
	di			;; 0ab8: f3          .
L0ab9:	jmp	L0ab9		;; 0ab9: c3 b9 0a    ...

L0abc:	di			;; 0abc: f3          .
	mov	a,m		;; 0abd: 7e          ~
	call	L0a6a		;; 0abe: cd 6a 0a    .j.
L0ac1:	inx	h		;; 0ac1: 23          #
	mov	a,m		;; 0ac2: 7e          ~
	call	L0a73		;; 0ac3: cd 73 0a    .s.
	dcr	c		;; 0ac6: 0d          .
	jnz	L0ac1		;; 0ac7: c2 c1 0a    ...
	ei			;; 0aca: fb          .
	lxi	h,L09ba		;; 0acb: 21 ba 09    ...
L0ace:	mov	a,m		;; 0ace: 7e          ~
	ora	a		;; 0acf: b7          .
	jz	L0ace		;; 0ad0: ca ce 0a    ...
	mvi	m,000h		;; 0ad3: 36 00       6.
	inx	h		;; 0ad5: 23          #
	mov	a,m		;; 0ad6: 7e          ~
	ani	0c0h		;; 0ad7: e6 c0       ..
	ret			;; 0ad9: c9          .

	lda	L0946		;; 0ada: 3a 46 09    :F.
	ora	a		;; 0add: b7          .
	jz	L0af4		;; 0ade: ca f4 0a    ...
	rar			;; 0ae1: 1f          .
L0ae2:	lxi	h,019ffh	;; 0ae2: 21 ff 19    ...
	lxi	d,L0965		;; 0ae5: 11 65 09    .e.
	jc	L0afa		;; 0ae8: da fa 0a    ...
L0aeb:	lxi	h,01fffh	;; 0aeb: 21 ff 1f    ...
L0aee:	lxi	d,L096b		;; 0aee: 11 6b 09    .k.
	jmp	L0afa		;; 0af1: c3 fa 0a    ...

L0af4:	lxi	h,L0cff		;; 0af4: 21 ff 0c    ...
L0af7:	lxi	d,L0971		;; 0af7: 11 71 09    .q.
L0afa:	shld	L094a		;; 0afa: 22 4a 09    "J.
	lxi	h,L0959		;; 0afd: 21 59 09    .Y.
	mvi	b,006h		;; 0b00: 06 06       ..
L0b02:	ldax	d		;; 0b02: 1a          .
	mov	m,a		;; 0b03: 77          w
	inx	h		;; 0b04: 23          #
	inx	d		;; 0b05: 13          .
	dcr	b		;; 0b06: 05          .
	jnz	L0b02		;; 0b07: c2 02 0b    ...
	ret			;; 0b0a: c9          .

L0b0b:	lda	L0946		;; 0b0b: 3a 46 09    :F.
	ora	a		;; 0b0e: b7          .
	jz	L0b22		;; 0b0f: ca 22 0b    .".
	rar			;; 0b12: 1f          .
	lxi	h,000ffh	;; 0b13: 21 ff 00    ...
	lxi	d,L0965		;; 0b16: 11 65 09    .e.
	jc	L0afa		;; 0b19: da fa 0a    ...
	lxi	h,001ffh	;; 0b1c: 21 ff 01    ...
	jmp	L0aee		;; 0b1f: c3 ee 0a    ...

L0b22:	lxi	h,0007fh	;; 0b22: 21 7f 00    ...
	jmp	L0af7		;; 0b25: c3 f7 0a    ...

L0b28:	call	L0d9b		;; 0b28: cd 9b 0d    ...
	xra	a		;; 0b2b: af          .
	sta	L0946		;; 0b2c: 32 46 09    2F.
	lxi	h,0007fh	;; 0b2f: 21 7f 00    ...
	lxi	d,L0971		;; 0b32: 11 71 09    .q.
	call	L0afa		;; 0b35: cd fa 0a    ...
	call	L0db6		;; 0b38: cd b6 0d    ...
	rz			;; 0b3b: c8          .
	mvi	a,001h		;; 0b3c: 3e 01       >.
	sta	L0946		;; 0b3e: 32 46 09    2F.
	lxi	h,000ffh	;; 0b41: 21 ff 00    ...
	lxi	d,L0965		;; 0b44: 11 65 09    .e.
	call	L0afa		;; 0b47: cd fa 0a    ...
	call	L0db6		;; 0b4a: cd b6 0d    ...
	rz			;; 0b4d: c8          .
	mvi	a,002h		;; 0b4e: 3e 02       >.
	sta	L0946		;; 0b50: 32 46 09    2F.
	lxi	h,001ffh	;; 0b53: 21 ff 01    ...
	lxi	d,L096b		;; 0b56: 11 6b 09    .k.
	call	L0afa		;; 0b59: cd fa 0a    ...
	call	L0db6		;; 0b5c: cd b6 0d    ...
	rz			;; 0b5f: c8          .
	call	print		;; 0b60: cd de 05    ...
	db	'\CANNOT DETERMINE DENSITY on disk $'
	call	L0d8e		;; 0b86: cd 8e 0d    ...
	mvi	a,007h		;; 0b89: 3e 07       >.
	call	conout		;; 0b8b: cd 64 05    .d.
	xra	a		;; 0b8e: af          .
	inr	a		;; 0b8f: 3c          <
	ret			;; 0b90: c9          .

	lda	L095e		;; 0b91: 3a 5e 09    :^.
	mov	h,a		;; 0b94: 67          g
	mvi	l,DMA_RD	;; 0b95: 2e 80       ..
	mvi	a,0ffh		;; 0b97: 3e ff       >.
	jmp	L0ba3		;; 0b99: c3 a3 0b    ...

L0b9c:	lda	L095d		;; 0b9c: 3a 5d 09    :].
	mov	h,a		;; 0b9f: 67          g
	mvi	l,DMA_WR	;; 0ba0: 2e 40       .@
	xra	a		;; 0ba2: af          .
L0ba3:	sta	L0950		;; 0ba3: 32 50 09    2P.
	shld	L0953		;; 0ba6: 22 53 09    "S.
	xra	a		;; 0ba9: af          .
	sta	L0948		;; 0baa: 32 48 09    2H.
	mvi	a,00ah		;; 0bad: 3e 0a       >.
	sta	L0947		;; 0baf: 32 47 09    2G.
L0bb2:	lxi	h,L0953		;; 0bb2: 21 53 09    .S.
	mov	a,m		;; 0bb5: 7e          ~
	inx	h		;; 0bb6: 23          #
	push	h		;; 0bb7: e5          .
	push	psw		;; 0bb8: f5          .
	di			;; 0bb9: f3          .
	lhld	L094a		;; 0bba: 2a 4a 09    *J.
	mov	a,l		;; 0bbd: 7d          }
	out	DMA_1C		;; 0bbe: d3 33       .3
	pop	psw		;; 0bc0: f1          .
	ora	h		;; 0bc1: b4          .
	out	DMA_1C		;; 0bc2: d3 33       .3
	lhld	L094c		;; 0bc4: 2a 4c 09    *L.
	mov	a,l		;; 0bc7: 7d          }
	out	DMA_1A		;; 0bc8: d3 32       .2
	mov	a,h		;; 0bca: 7c          |
	out	DMA_1A		;; 0bcb: d3 32       .2
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL		;; 0bcf: d3 38       .8
	ei			;; 0bd1: fb          .
	pop	h		;; 0bd2: e1          .
	mvi	c,008h		;; 0bd3: 0e 08       ..
	call	L0abc		;; 0bd5: cd bc 0a    ...
	rz			;; 0bd8: c8          .
	lxi	d,L0bb2		;; 0bd9: 11 b2 0b    ...
	push	d		;; 0bdc: d5          .
	mov	a,m		;; 0bdd: 7e          ~
	ani	018h		;; 0bde: e6 18       ..
	jnz	L0d43		;; 0be0: c2 43 0d    .C.
	inx	h		;; 0be3: 23          #
	inx	h		;; 0be4: 23          #
	mov	a,m		;; 0be5: 7e          ~
	ani	010h		;; 0be6: e6 10       ..
	jz	L0c0d		;; 0be8: ca 0d 0c    ...
	lda	L0948		;; 0beb: 3a 48 09    :H.
	ora	a		;; 0bee: b7          .
	jnz	L0c0d		;; 0bef: c2 0d 0c    ...
	cma			;; 0bf2: 2f          /
	sta	L0948		;; 0bf3: 32 48 09    2H.
	lda	L0954		;; 0bf6: 3a 54 09    :T.
	push	psw		;; 0bf9: f5          .
	lda	L0956		;; 0bfa: 3a 56 09    :V.
	push	psw		;; 0bfd: f5          .
	call	L0d9e		;; 0bfe: cd 9e 0d    ...
	pop	psw		;; 0c01: f1          .
	sta	L0956		;; 0c02: 32 56 09    2V.
	call	L0dac		;; 0c05: cd ac 0d    ...
	pop	psw		;; 0c08: f1          .
	sta	L0954		;; 0c09: 32 54 09    2T.
	ret			;; 0c0c: c9          .

L0c0d:	lda	L0947		;; 0c0d: 3a 47 09    :G.
	dcr	a		;; 0c10: 3d          =
	sta	L0947		;; 0c11: 32 47 09    2G.
	rnz			;; 0c14: c0          .
	pop	d		;; 0c15: d1          .
	lxi	h,L09bc		;; 0c16: 21 bc 09    ...
	lda	L0950		;; 0c19: 3a 50 09    :P.
	ora	a		;; 0c1c: b7          .
	jz	L0c2f		;; 0c1d: ca 2f 0c    ./.
L0c20:	call	print		;; 0c20: cd de 05    ...
	db	CR,SYN,'WRITE $'
	jmp	L0c3a		;; 0c2c: c3 3a 0c    .:.

L0c2f:	call	print		;; 0c2f: cd de 05    ...
	db	CR,SYN,'READ $'
L0c3a:	mov	a,m		;; 0c3a: 7e          ~
	ani	080h		;; 0c3b: e6 80       ..
	jz	L0c50		;; 0c3d: ca 50 0c    .P.
	call	print		;; 0c40: cd de 05    ...
	db	'end of track$'
L0c50:	mov	a,m		;; 0c50: 7e          ~
	ani	020h		;; 0c51: e6 20       . 
	jz	L0c77		;; 0c53: ca 77 0c    .w.
	inx	h		;; 0c56: 23          #
	mov	a,m		;; 0c57: 7e          ~
	dcx	h		;; 0c58: 2b          +
	ani	020h		;; 0c59: e6 20       . 
	jz	L0c6d		;; 0c5b: ca 6d 0c    .m.
	call	print		;; 0c5e: cd de 05    ...
	db	'data CRC$'
	jmp	L0c77		;; 0c6a: c3 77 0c    .w.

L0c6d:	call	print		;; 0c6d: cd de 05    ...
	db	'ID CRC$'
L0c77:	mov	a,m		;; 0c77: 7e          ~
	ani	004h		;; 0c78: e6 04       ..
	jz	L0c91		;; 0c7a: ca 91 0c    ...
	call	print		;; 0c7d: cd de 05    ...
	db	'sector not found$'
L0c91:	mov	a,m		;; 0c91: 7e          ~
	ani	002h		;; 0c92: e6 02       ..
	jz	L0ca2		;; 0c94: ca a2 0c    ...
	call	print		;; 0c97: cd de 05    ...
	db	'protect$'
L0ca2:	mov	a,m		;; 0ca2: 7e          ~
	ani	001h		;; 0ca3: e6 01       ..
	jz	L0cd1		;; 0ca5: ca d1 0c    ...
	inx	h		;; 0ca8: 23          #
	mov	a,m		;; 0ca9: 7e          ~
	ani	001h		;; 0caa: e6 01       ..
	jz	L0cba		;; 0cac: ca ba 0c    ...
	call	print		;; 0caf: cd de 05    ...
	db	'data$'
	jmp	L0cc0		;; 0cb7: c3 c0 0c    ...

L0cba:	call	print		;; 0cba: cd de 05    ...
	db	'ID$'
L0cc0:	call	print		;; 0cc0: cd de 05    ...
	db	' address mark$'
L0cd1:	call	print		;; 0cd1: cd de 05    ...
	db	' ERROR on disk $'
	call	L0d8e		;; 0ce4: cd 8e 0d    ...
	call	L0cf2		;; 0ce7: cd f2 0c    ...
	mvi	a,007h		;; 0cea: 3e 07       >.
	call	conout		;; 0cec: cd 64 05    .d.
	xra	a		;; 0cef: af          .
	inr	a		;; 0cf0: 3c          <
	ret			;; 0cf1: c9          .

L0cf2:	mvi	h,000h		;; 0cf2: 26 00       &.
	call	print		;; 0cf4: cd de 05    ...
	db	' - bad s'
L0cff:	db	'ector $'
	lda	L0958		;; 0d06: 3a 58 09    :X.
	mov	l,a		;; 0d09: 6f          o
	call	L05f7		;; 0d0a: cd f7 05    ...
	call	print		;; 0d0d: cd de 05    ...
	db	' on track $'
	lda	L0956		;; 0d1b: 3a 56 09    :V.
	mov	l,a		;; 0d1e: 6f          o
	call	L05f7		;; 0d1f: cd f7 05    ...
	lhld	L094e		;; 0d22: 2a 4e 09    *N.
	inx	h		;; 0d25: 23          #
	shld	L094e		;; 0d26: 22 4e 09    "N.
	ret			;; 0d29: c9          .

L0d2a:	di			;; 0d2a: f3          .
	mvi	a,004h		;; 0d2b: 3e 04       >.
	call	L0a6a		;; 0d2d: cd 6a 0a    .j.
	lda	L0955		;; 0d30: 3a 55 09    :U.
	call	L0a73		;; 0d33: cd 73 0a    .s.
	call	L0a82		;; 0d36: cd 82 0a    ...
	ei			;; 0d39: fb          .
	ani	020h		;; 0d3a: e6 20       . 
	rnz			;; 0d3c: c0          .
	call	L0d43		;; 0d3d: cd 43 0d    .C.
	jmp	L0d2a		;; 0d40: c3 2a 0d    .*.

L0d43:	call	print		;; 0d43: cd de 05    ...
	db	'\Disk $'
	call	L0d8e		;; 0d4d: cd 8e 0d    ...
	call	print		;; 0d50: cd de 05    ...
	db	' not ready, type (CR) to continue',7,'$'
	call	conin		;; 0d76: cd 73 05    .s.
	cpi	003h		;; 0d79: fe 03       ..
	jz	L0409		;; 0d7b: ca 09 04    ...
	ret			;; 0d7e: c9          .

L0d7f:	call	print		;; 0d7f: cd de 05    ...
	db	CR,SYN,'$'
L0d85:	call	print		;; 0d85: cd de 05    ...
	db	'Disk $'
L0d8e:	lda	L0955		;; 0d8e: 3a 55 09    :U.
	adi	041h		;; 0d91: c6 41       .A
	call	conout		;; 0d93: cd 64 05    .d.
	mvi	a,03ah		;; 0d96: 3e 3a       >:
	jmp	conout		;; 0d98: c3 64 05    .d.

L0d9b:	call	L0d2a		;; 0d9b: cd 2a 0d    .*.
L0d9e:	xra	a		;; 0d9e: af          .
	sta	L0956		;; 0d9f: 32 56 09    2V.
	lxi	h,L0954		;; 0da2: 21 54 09    .T.
	mvi	m,007h		;; 0da5: 36 07       6.
	mvi	c,001h		;; 0da7: 0e 01       ..
	jmp	L0abc		;; 0da9: c3 bc 0a    ...

L0dac:	lxi	h,L0954		;; 0dac: 21 54 09    .T.
	mvi	m,00fh		;; 0daf: 36 0f       6.
	mvi	c,002h		;; 0db1: 0e 02       ..
	jmp	L0abc		;; 0db3: c3 bc 0a    ...

L0db6:	lda	L095d		;; 0db6: 3a 5d 09    :].
	ani	040h		;; 0db9: e6 40       .@
	ori	00ah		;; 0dbb: f6 0a       ..
	lxi	h,L0954		;; 0dbd: 21 54 09    .T.
	mov	m,a		;; 0dc0: 77          w
	mvi	c,001h		;; 0dc1: 0e 01       ..
	call	L0abc		;; 0dc3: cd bc 0a    ...
	rnz			;; 0dc6: c0          .
	lda	L09c1		;; 0dc7: 3a c1 09    :..
	lxi	h,L0946		;; 0dca: 21 46 09    .F.
	cmp	m		;; 0dcd: be          .
	ret			;; 0dce: c9          .

L0dcf:	push	psw		;; 0dcf: f5          .
	push	h		;; 0dd0: e5          .
	lxi	h,L09ba		;; 0dd1: 21 ba 09    ...
	in	FDC_STS		;; 0dd4: db 40       .@
	ani	010h		;; 0dd6: e6 10       ..
	jnz	L0dfb		;; 0dd8: c2 fb 0d    ...
	mvi	a,008h		;; 0ddb: 3e 08       >.
	call	L0a73		;; 0ddd: cd 73 0a    .s.
	call	L0a82		;; 0de0: cd 82 0a    ...
	inx	h		;; 0de3: 23          #
	mov	m,a		;; 0de4: 77          w
	ani	0c0h		;; 0de5: e6 c0       ..
	cpi	080h		;; 0de7: fe 80       ..
	jz	L0e0a		;; 0de9: ca 0a 0e    ...
	call	L0a82		;; 0dec: cd 82 0a    ...
	mov	a,m		;; 0def: 7e          ~
	ani	020h		;; 0df0: e6 20       . 
	jz	L0e0a		;; 0df2: ca 0a 0e    ...
	dcx	h		;; 0df5: 2b          +
	mvi	m,001h		;; 0df6: 36 01       6.
	jmp	L0e0a		;; 0df8: c3 0a 0e    ...

L0dfb:	mvi	m,001h		;; 0dfb: 36 01       6.
	push	b		;; 0dfd: c5          .
	mvi	b,007h		;; 0dfe: 06 07       ..
L0e00:	inx	h		;; 0e00: 23          #
	call	L0a82		;; 0e01: cd 82 0a    ...
	mov	m,a		;; 0e04: 77          w
	dcr	b		;; 0e05: 05          .
	jnz	L0e00		;; 0e06: c2 00 0e    ...
	pop	b		;; 0e09: c1          .
L0e0a:	pop	h		;; 0e0a: e1          .
	pop	psw		;; 0e0b: f1          .
	ei			;; 0e0c: fb          .
	reti			;; 0e0d: ed 4d       .M

L0e0f:	mvi	a,018h		;; 0e0f: 3e 18       >.
	call	conout		;; 0e11: cd 64 05    .d.
L0e14:	lxi	sp,L0a6a	;; 0e14: 31 6a 0a    1j.
	call	print		;; 0e17: cd de 05    ...
	db	'\\\\VERIFY DISK UTILITY$'
L0e32:	call	print		;; 0e32: cd de 05    ...
	db	'\\Select disk (A-D) to VERIFY or type (SPACE) to reboot: $'
	call	conine		;; 0e6f: cd 61 05    .a.
	cpi	CR		;; 0e72: fe 0d       ..
	jz	L0e14		;; 0e74: ca 14 0e    ...
	cpi	CTLC		;; 0e77: fe 03       ..
	jz	L0461		;; 0e79: ca 61 04    .a.
	cpi	' '		;; 0e7c: fe 20       . 
	jz	L0169		;; 0e7e: ca 69 01    .i.
	sta	L0f27		;; 0e81: 32 27 0f    2'.
	sui	'A'		;; 0e84: d6 41       .A
	jc	L0e32		;; 0e86: da 32 0e    .2.
	cpi	'D'-'A'+1	;; 0e89: fe 04       ..
	jnc	L0e32		;; 0e8b: d2 32 0e    .2.
	sta	L0955		;; 0e8e: 32 55 09    2U.
	call	L0b28		;; 0e91: cd 28 0b    .(.
	jnz	L0e14		;; 0e94: c2 14 0e    ...
	call	L0d7f		;; 0e97: cd 7f 0d    ...
	lda	L0946		;; 0e9a: 3a 46 09    :F.
	ora	a		;; 0e9d: b7          .
	jz	L0eaf		;; 0e9e: ca af 0e    ...
	call	print		;; 0ea1: cd de 05    ...
	db	' double$'
	jmp	L0eba		;; 0eac: c3 ba 0e    ...

L0eaf:	call	print		;; 0eaf: cd de 05    ...
	db	' single$'
L0eba:	call	print		;; 0eba: cd de 05    ...
	db	' density\$'
	lxi	h,00000h	;; 0ec7: 21 00 00    ...
	shld	L094e		;; 0eca: 22 4e 09    "N.
	lxi	h,L1263		;; 0ecd: 21 63 12    .c.
	shld	L094c		;; 0ed0: 22 4c 09    "L.
L0ed3:	call	conbrk		;; 0ed3: cd 8d 05    ...
	call	L0dac		;; 0ed6: cd ac 0d    ...
	call	L0f36		;; 0ed9: cd 36 0f    .6.
	lda	L0956		;; 0edc: 3a 56 09    :V.
	inr	a		;; 0edf: 3c          <
	sta	L0956		;; 0ee0: 32 56 09    2V.
L0ee3:	cpi	04dh		;; 0ee3: fe 4d       .M
	jc	L0ed3		;; 0ee5: da d3 0e    ...
	call	print		;; 0ee8: cd de 05    ...
	db	'\VERIFY complete: $'
	lhld	L094e		;; 0efe: 2a 4e 09    *N.
	mov	a,l		;; 0f01: 7d          }
	ora	h		;; 0f02: b4          .
	jnz	L0f0f		;; 0f03: c2 0f 0f    ...
	call	print		;; 0f06: cd de 05    ...
	db	'NO$'
	jmp	L0f12		;; 0f0c: c3 12 0f    ...

L0f0f:	call	L05f7		;; 0f0f: cd f7 05    ...
L0f12:	call	print		;; 0f12: cd de 05    ...
	db	' read error(s) on '
L0f27:	db	'A: detected$'
	jmp	L0e14		;; 0f33: c3 14 0e    ...

L0f36:	lxi	b,00000h	;; 0f36: 01 00 00    ...
L0f39:	push	b		;; 0f39: c5          .
	lda	L0946		;; 0f3a: 3a 46 09    :F.
L0f3d:	lxi	h,L0991		;; 0f3d: 21 91 09    ...
	cpi	002h		;; 0f40: fe 02       ..
	jz	L0f48		;; 0f42: ca 48 0f    .H.
L0f45:	lxi	h,L0977		;; 0f45: 21 77 09    .w.
L0f48:	dad	b		;; 0f48: 09          .
	mov	a,m		;; 0f49: 7e          ~
	sta	L0958		;; 0f4a: 32 58 09    2X.
	call	L0b9c		;; 0f4d: cd 9c 0b    ...
	cnz	L05f0		;; 0f50: c4 f0 05    ...
	pop	b		;; 0f53: c1          .
	inr	c		;; 0f54: 0c          .
	lda	L0946		;; 0f55: 3a 46 09    :F.
	cpi	002h		;; 0f58: fe 02       ..
	mov	a,c		;; 0f5a: 79          y
	jz	L0f63		;; 0f5b: ca 63 0f    .c.
L0f5e:	cpi	26		;; 0f5e: fe 1a       ..
	jmp	L0f65		;; 0f60: c3 65 0f    .e.

L0f63:	cpi	16		;; 0f63: fe 10       ..
L0f65:	jc	L0f39		;; 0f65: da 39 0f    .9.
	ret			;; 0f68: c9          .

L0f69:	mvi	a,CAN		;; 0f69: 3e 18       >.
	call	conout		;; 0f6b: cd 64 05    .d.
L0f6e:	lxi	sp,L0a6a	;; 0f6e: 31 6a 0a    1j.
	call	print		;; 0f71: cd de 05    ...
	db	'\\\\COPY DISK UTILITY$'
L0f8a:	call	print		;; 0f8a: cd de 05    ...
	db	'\\Select source disk (A-D) or type (SPACE) to reboot: $'
	call	conine		;; 0fc4: cd 61 05    .a.
	cpi	CR		;; 0fc7: fe 0d       ..
	jz	L0f6e		;; 0fc9: ca 6e 0f    .n.
	cpi	CTLC		;; 0fcc: fe 03       ..
	jz	L0461		;; 0fce: ca 61 04    .a.
	cpi	' '		;; 0fd1: fe 20       . 
	jz	L0169		;; 0fd3: ca 69 01    .i.
	sta	L10b0		;; 0fd6: 32 b0 10    2..
	sui	'A'		;; 0fd9: d6 41       .A
	jc	L0f8a		;; 0fdb: da 8a 0f    ...
	cpi	'D'-'A'+1	;; 0fde: fe 04       ..
	jnc	L0f8a		;; 0fe0: d2 8a 0f    ...
	sta	L0951		;; 0fe3: 32 51 09    2Q.
	sta	L0955		;; 0fe6: 32 55 09    2U.
	call	print		;; 0fe9: cd de 05    ...
	db	CR,SYN,'Source $'
	call	L0d85		;; 0ff6: cd 85 0d    ...
L0ff9:	call	print		;; 0ff9: cd de 05    ...
	db	'\Select target disk (A-D) or type (SPACE) to reboot: $'
	call	conine		;; 1032: cd 61 05    .a.
	cpi	CR		;; 1035: fe 0d       ..
	jz	L0f6e		;; 1037: ca 6e 0f    .n.
	cpi	CTLC		;; 103a: fe 03       ..
	jz	L0461		;; 103c: ca 61 04    .a.
	cpi	' '		;; 103f: fe 20       . 
	jz	L0169		;; 1041: ca 69 01    .i.
	sta	L10f5		;; 1044: 32 f5 10    2..
	sui	'A'		;; 1047: d6 41       .A
	jc	L0ff9		;; 1049: da f9 0f    ...
	cpi	'D'-'A'+1	;; 104c: fe 04       ..
	jnc	L0ff9		;; 104e: d2 f9 0f    ...
	sta	L0952		;; 1051: 32 52 09    2R.
	sta	L0955		;; 1054: 32 55 09    2U.
	lxi	h,L0951		;; 1057: 21 51 09    .Q.
	cmp	m		;; 105a: be          .
	jnz	L1087		;; 105b: c2 87 10    ...
	call	print		;; 105e: cd de 05    ...
	db	CR,SYN,'SAME DISK SELECTED, CANNOT COPY',7,'$'
	jmp	L0ff9		;; 1084: c3 f9 0f    ...

L1087:	call	print		;; 1087: cd de 05    ...
	db	CR,SYN,'Target $'
	call	L0d85		;; 1094: cd 85 0d    ...
	call	L05f0		;; 1097: cd f0 05    ...
L109a:	call	print		;; 109a: cd de 05    ...
	db	CR,SYN,'Load source disk '
L10b0:	db	'A: and type (CR)$'
	call	conine		;; 10c1: cd 61 05    .a.
	cpi	CTLC		;; 10c4: fe 03       ..
	jz	L0461		;; 10c6: ca 61 04    .a.
	cpi	' '		;; 10c9: fe 20       . 
	jz	L0169		;; 10cb: ca 69 01    .i.
	cpi	CR		;; 10ce: fe 0d       ..
	jnz	L109a		;; 10d0: c2 9a 10    ...
	lda	L0951		;; 10d3: 3a 51 09    :Q.
	sta	L0955		;; 10d6: 32 55 09    2U.
	call	L0b28		;; 10d9: cd 28 0b    .(.
	jnz	L0f6e		;; 10dc: c2 6e 0f    .n.
	call	print		;; 10df: cd de 05    ...
	db	CR,SYN,'Load target disk '
L10f5:	db	'A: and typensity$'
	mvi	b,000h		;; 1106: 06 00       ..
	mvi	a,00dh		;; 1108: 3e 0d       >.
	sta	L095f		;; 110a: 32 5f 09    2_.
	mvi	a,000h		;; 110d: 3e 00       >.
	sta	L0961		;; 110f: 32 61 09    2a.
	mvi	a,01ah		;; 1112: 3e 1a       >.
	sta	L0962		;; 1114: 32 62 09    2b.
	mvi	a,01bh		;; 1117: 3e 1b       >.
	sta	L0963		;; 1119: 32 63 09    2c.
	jmp	L07ae		;; 111c: c3 ae 07    ...

	call	print		;; 111f: cd de 05    ...
	db	CR,SYN,'Double density$'
	call	print		;; 1133: cd de 05    ...
	db	'\Select 256 or 512 bytes/sector  (2/5): $'
	call	conin		;; 115f: cd 73 05    .s.
	cpi	'2'		;; 1162: fe 32       .2
	jz	L082d		;; 1164: ca 2d 08    .-.
	cpi	'5'		;; 1167: fe 35       .5
	jz	L077e		;; 1169: ca 7e 07    .~.
	cpi	CR		;; 116c: fe 0d       ..
	jz	L061e		;; 116e: ca 1e 06    ...
	cpi	CTLC		;; 1171: fe 03       ..
	jz	L0461		;; 1173: ca 61 04    .a.
	cpi	' '		;; 1176: fe 20       . 
	jz	L0169		;; 1178: ca 69 01    .i.
	jmp	L071f		;; 117b: c3 1f 07    ...

	call	print		;; 117e: cd de 05    ...
	db	CR,SYN,'512$'
	mvi	b,002h		;; 1187: 06 02       ..
	mvi	a,002h		;; 1189: 3e 02       >.
	sta	L0961		;; 118b: 32 61 09    2a.
	mvi	a,010h		;; 118e: 3e 10       >.
	sta	L0962		;; 1190: 32 62 09    2b.
	mvi	a,036h		;; 1193: 3e 36       >6
	sta	L0963		;; 1195: 32 63 09    2c.
	mvi	a,04dh		;; 1198: 3e 4d       >M
	sta	L095f		;; 119a: 32 5f 09    2_.
	call	print		;; 119d: cd de 05    ...
	db	' bytes/sector$'
	mov	a,b		;; 11ae: 78          x
	sta	L0946		;; 11af: 32 46 09    2F.
	call	print		;; 11b2: cd de 05    ...
	db	'\Check diskette (FORMAT will destroy data on d'
L11e3:	db	'isk A:)\Type (CR) to continue or (SPACE) to abort$'
	call	conin		;; 1215: cd 73 05    .s.
	cpi	CTLC		;; 1218: fe 03       ..
	jz	L0461		;; 121a: ca 61 04    .a.
	cpi	' '		;; 121d: fe 20       . 
	jz	L061e		;; 121f: ca 1e 06    ...
	cpi	CR		;; 1222: fe 0d       ..
	jnz	L07b2		;; 1224: c2 b2 07    ...
	call	L05f0		;; 1227: cd f0 05    ...
	jmp	L088c		;; 122a: c3 8c 08    ...

	call	print		;; 122d: cd de 05    ...
L1230:	db	CR,SYN,'256$'
	mvi	b,001h		;; 1236: 06 01       ..
L1238:	mvi	a,001h		;; 1238: 3e 01       >.
	sta	L0961		;; 123a: 32 61 09    2a.
	mvi	a,01ah		;; 123d: 3e 1a       >.
	jmp	L0790		;; 123f: c3 90 07    ...

; more buffer space?
;	ds	33
;L1263:	ds	0
if 0
	lxi	d,00004h	;; 1242: 11 04 00    ...
	mvi	c,01ah		;; 1245: 0e 1a       ..
	mov	m,a		;; 1247: 77          w
	dad	d		;; 1248: 19          .
	dcr	c		;; 1249: 0d          .
	rz			;; 124a: c8          .
	jmp	L0847		;; 124b: c3 47 08    .G.

	mvi	a,005h		;; 124e: 3e 05       >.
	sta	L0947		;; 1250: 32 47 09    2G.
	di			;; 1253: f3          .
	lxi	h,L09c2		;; 1254: 21 c2 09    ...
	mov	a,l		;; 1257: 7d          }
	out	DMA_1A		;; 1258: d3 32       .2
	mov	a,h		;; 125a: 7c          |
	out	DMA_1A		;; 125b: d3 32       .2
	lda	L0962		;; 125d: 3a 62 09    :b.
	ral			;; 1260: 17          .
	ral			;; 1261: 17          .
	ani	0fch		;; 1262: e6 fc       ..
	dcr	a		;; 1264: 3d          =
	out	DMA_1C		;; 1265: d3 33       .3
	mvi	a,DMA_RD	;; 1267: 3e 80       >.
	out	DMA_1C		;; 1269: d3 33       .3
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL		;; 126d: d3 38       .8
	ei			;; 126f: fb          .
	lxi	h,L095f		;; 1270: 21 5f 09    ._.
	mvi	c,005h		;; 1273: 0e 05       ..
	call	L0abc		;; 1275: cd bc 0a    ...
	rz			;; 1278: c8          .
	mov	a,m		;; 1279: 7e          ~
	ani	018h		;; 127a: e6 18       ..
	cnz	L0d43		;; 127c: c4 43 0d    .C.
	lda	L0947		;; 127f: 3a 47 09    :G.
	dcr	a		;; 1282: 3d          =
	jnz	L0850		;; 1283: c2 50 08    .P.
	lxi	h,L09bc		;; 1286: 21 bc 09    ...
	jmp	L0c20		;; 1289: c3 20 0c    . .

	call	L0b0b		;; 128c: cd 0b 0b    ...
	call	L0d9b		;; 128f: cd 9b 0d    ...
	lda	L0961		;; 1292: 3a 61 09    :a.
	mov	b,a		;; 1295: 47          G
	lxi	h,L09c2		;; 1296: 21 c2 09    ...
	xra	a		;; 1299: af          .
	inr	a		;; 129a: 3c          <
	cpi	01bh		;; 129b: fe 1b       ..
	jnc	L08ad		;; 129d: d2 ad 08    ...
	mvi	m,000h		;; 12a0: 36 00       6.
	inx	h		;; 12a2: 23          #
	mvi	m,000h		;; 12a3: 36 00       6.
	inx	h		;; 12a5: 23          #
	mov	m,a		;; 12a6: 77          w
	inx	h		;; 12a7: 23          #
	mov	m,b		;; 12a8: 70          p
	inx	h		;; 12a9: 23          #
	jmp	L089a		;; 12aa: c3 9a 08    ...

	mvi	a,005h		;; 12ad: 3e 05       >.
	sta	L0949		;; 12af: 32 49 09    2I.
	call	L084e		;; 12b2: cd 4e 08    .N.
	jz	L08c8		;; 12b5: ca c8 08    ...
	lda	L0949		;; 12b8: 3a 49 09    :I.
	dcr	a		;; 12bb: 3d          =
	jnz	L08af		;; 12bc: c2 af 08    ...
	call	L05f0		;; 12bf: cd f0 05    ...
	call	L059f		;; 12c2: cd 9f 05    ...
	jmp	L0900		;; 12c5: c3 00 09    ...

	lxi	b,00000h	;; 12c8: 01 00 00    ...
	push	b		;; 12cb: c5          .
	lda	L0946		;; 12cc: 3a 46 09    :F.
	lxi	h,L0991		;; 12cf: 21 91 09    ...
	cpi	002h		;; 12d2: fe 02       ..
	jz	L08da		;; 12d4: ca da 08    ...
	lxi	h,L0977		;; 12d7: 21 77 09    .w.
	dad	b		;; 12da: 09          .
	mov	a,m		;; 12db: 7e          ~
	sta	L0958		;; 12dc: 32 58 09    2X.
	call	L0b9c		;; 12df: cd 9c 0b    ...
	pop	b		;; 12e2: c1          .
	jnz	L091b		;; 12e3: c2 1b 09    ...
	inr	c		;; 12e6: 0c          .
	lda	L0946		;; 12e7: 3a 46 09    :F.
	cpi	002h		;; 12ea: fe 02       ..
	mov	a,c		;; 12ec: 79          y
	jz	L08f5		;; 12ed: ca f5 08    ...
	cpi	01ah		;; 12f0: fe 1a       ..
	jmp	L08f7		;; 12f2: c3 f7 08    ...

	cpi	010h		;; 12f5: fe 10       ..
	jc	L08cb		;; 12f7: da cb 08    ...
	call	print		;; 12fa: cd de 05    ...
	db	CR,SYN,'$'
else
	db	11h,4,0,0eh,1ah,'w',19h,0dh,0c8h,0c3h,'G',8,'>',5,'2G',9
	db	0f3h,21h,0c2h,9,'}',0d3h,'2|',0d3h,'2:b',9,17h,17h,0e6h
L1263:	db	0fch,'=',0d3h,'3>',80h,0d3h,'3>',0e6h,0d3h,'8',0fbh,21h,'_'
	db	9,0eh,5,0cdh,0bch,0ah,0c8h,'~',0e6h,18h,0c4h,'C',0dh,':G',9
	db	'=',0c2h,'P',8,21h,0bch,9,0c3h,' ',0ch,0cdh,0bh,0bh,0cdh,9bh
	db	0dh,':a',9,'G',21h,0c2h,9,0afh,'<',0feh,1bh,0d2h,0adh,8,'6'
	db	0,'#6',0,'#w#p#',0c3h,9ah,8,'>',5,'2I',9,0cdh,'N',8,0cah
	db	0c8h,8,':I',9,'=',0c2h,0afh,8,0cdh,0f0h,5,0cdh,9fh,5,0c3h,0
	db	9,1,0,0,0c5h,':F',9,21h,91h,9,0feh,2,0cah,0dah,8,21h,'w',9,9
	db	'~2X',9,0cdh,9ch,0bh,0c1h,0c2h,1bh,9,0ch,':F',9,0feh,2,'y'
	db	0cah,0f5h,8,0feh,1ah,0c3h,0f7h,8,0feh,10h,0dah,0cbh,8,0cdh
	db	0deh,5
	db	0dh,16h,'$'
endif
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0
	end
