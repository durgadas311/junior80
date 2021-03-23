; Disk util for Junior, not Junior80 or Tpd

	maclib	z80

cpm	equ	0000h
bdos	equ	0005h
tpa	equ	0100h

; BDOS functions
dircon	equ	6

; BIOS offsets from wboote
BIO_IDS	equ	50	; ID string start (e.g. "Tpd 2.7/1 A")
BIO_VER	equ	56	; (IDS) minor version
BIO_DRV	equ	59	; (IDS) floppy drive type indicators

V5_INTV	equ	109	; FDC intr vector in vers .5
V6_INTV	equ	123	; FDC intr vector in vers .6

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
	lxi	sp,stack	;; 0100: 31 6a 0a    1j.
	lhld	cpm+1		;; 0103: 2a 01 00    *..
	lxi	d,BIO_IDS	;; 0106: 11 32 00    .2.
	dad	d		;; 0109: 19          .
	mov	a,m		;; 010a: 7e          ~
	cpi	'j'		;; 010b: fe 6a       .j
	jnz	L011f		;; 010d: c2 1f 01    ...
	; "j.........."
	lxi	d,BIO_VER-BIO_IDS
	dad	d		;; 0113: 19          .
	mov	a,m		;; 0114: 7e          ~
	cpi	'5'		;; 0115: fe 35       .5
	jz	L0145		;; 0117: ca 45 01    .E.
	cpi	'6'		;; 011a: fe 36       .6
	jz	L014b		;; 011c: ca 4b 01    .K.
L011f:	call	print		;; 011f: cd de 05    ...
	db	CAN,BEL,'\WRONG SYSTEM, TRY ANOTHER ',21h,'\$'
	jmp	cpm		;; 0142: c3 00 00    ...

; "j.....5...."
L0145:	lxi	d,V5_INTV	;; 0145: 11 6d 00    .m.
	jmp	L014e		;; 0148: c3 4e 01    .N.

; "j.....6...."
L014b:	lxi	d,V6_INTV	;; 014b: 11 7b 00    .{.
L014e:	lhld	cpm+1		;; 014e: 2a 01 00    *..
	dad	d		;; 0151: 19          .
	shld	vecptr		;; 0152: 22 44 09    "D.
	mov	e,m		;; 0155: 5e          ^
	inx	h		;; 0156: 23          #
	mov	d,m		;; 0157: 56          V
	dcx	h		;; 0158: 2b          +
	xchg			;; 0159: eb          .
	shld	vecsav		;; 015a: 22 42 09    "B.
	di			;; 015d: f3          .
	lxi	h,fdcint		;; 015e: 21 cf 0d    ...
	xchg			;; 0161: eb          .
	mov	m,e		;; 0162: 73          s
	inx	h		;; 0163: 23          #
	mov	m,d		;; 0164: 72          r
	call	L04a3	; setup floppy drive type
	ei			;; 0168: fb          .
menu:	call	print		;; 0169: cd de 05    ...
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
	jz	format		;; 044a: ca 19 06    ...
	cpi	'V'		;; 044d: fe 56       .V
	jz	verify		;; 044f: ca 0f 0e    ...
	cpi	'C'		;; 0452: fe 43       .C
	jz	copy		;; 0454: ca 69 0f    .i.
	cpi	'E'		;; 0457: fe 45       .E
	jz	exit		;; 0459: ca 61 04    .a.
	cpi	CTLC		;; 045c: fe 03       ..
	jnz	menu		;; 045e: c2 69 01    .i.
exit:	call	print		;; 0461: cd de 05    ...
	db	'\\Load system disk A: and type (CR)$'
	call	conin		;; 0488: cd 73 05    .s.
	mvi	a,CAN		;; 048b: 3e 18       >.
	call	conout		;; 048d: cd 64 05    .d.
	di			;; 0490: f3          .
	call	L04a3		;; 0491: cd a3 04    ...
	lhld	vecptr		;; 0494: 2a 44 09    *D.
	xchg			;; 0497: eb          .
	lhld	vecsav		;; 0498: 2a 42 09    *B.
	xchg			;; 049b: eb          .
	mov	m,e		;; 049c: 73          s
	inx	h		;; 049d: 23          #
	mov	m,d		;; 049e: 72          r
	ei			;; 049f: fb          .
	jmp	cpm		;; 04a0: c3 00 00    ...

; configure floppy parameters
L04a3:	xra	a		;; 04a3: af          .
	sta	fdcres		;; 04a4: 32 ba 09    2..
	lhld	cpm+1		;; 04a7: 2a 01 00    *..
	lxi	d,BIO_DRV	;; 04aa: 11 3b 00    .;.
	dad	d		;; 04ad: 19          .
	mov	a,m		;; 04ae: 7e          ~
	; 'm' indicates 5.25" drives, else 8".
	; Junior has no dipswitches to indicate this?
	; Also, Junior80/Tpd can have both.
	cpi	'm'		;; 04af: fe 6d       .m
	jz	L04e1		;; 04b1: ca e1 04    ...
	; 8" drives selected
	; "j.....6..[^m]."
	; "j.....5..[^m]."
	mvi	a,'8'		;; 04b4: 3e 38       >8
	sta	L017c		;; 04b6: 32 7c 01    2|.
	mvi	a,77		;; 04b9: 3e 4d       >M
	call	settrk		;; 04bb: cd 1a 05    ...
	mvi	b,16		;; 04be: 06 10       ..
	mvi	c,26		;; 04c0: 0e 1a       ..
	call	setspt		;; 04c2: cd 24 05    .$.
	lxi	d,ilv8m2	;; 04c5: 11 91 09    ...
	lxi	h,ilv8m0	;; 04c8: 21 77 09    .w.
	call	setilv		;; 04cb: cd 4d 05    .M.
	lxi	h,019ffh	;; 04ce: 21 ff 19    ...
	shld	L0ae2+1		;; 04d1: 22 e3 0a    "..
	lxi	h,01fffh	;; 04d4: 21 ff 1f    ...
	shld	L0aeb+1		;; 04d7: 22 ec 0a    "..
	lxi	h,00cffh	;; 04da: 21 ff 0c    ...
	shld	L0af4+1		;; 04dd: 22 f5 0a    "..
	ret			;; 04e0: c9          .

; 5.25" drives selected
; "Tpd 2.7/1 A" e.g.
; "j.....5..m."
; "j.....6..m."
L04e1:	mvi	a,'5'		;; 04e1: 3e 35       >5
	sta	L017c		;; 04e3: 32 7c 01    2|.
	inx	h		;; 04e6: 23          #
	mov	a,m		;; 04e7: 7e          ~
	; 'A' indicates 40-track, else 35-track.
	; Junior80/Tpd are all 40 track.
	cpi	'A'		;; 04e8: fe 41       .A
	jnz	L0515		;; 04ea: c2 15 05    ...
	; "j........mA"
	mvi	a,40		;; 04ed: 3e 28       >(
L04ef:	call	settrk		;; 04ef: cd 1a 05    ...
	mvi	b,9		;; 04f2: 06 09       ..
	mvi	c,16		;; 04f4: 0e 10       ..
	call	setspt		;; 04f6: cd 24 05    .$.
	lxi	d,ilv5m2	;; 04f9: 11 b1 09    ...
	lxi	h,ilv5m0	;; 04fc: 21 a1 09    ...
	call	setilv		;; 04ff: cd 4d 05    .M.
	lxi	h,00fffh	;; 0502: 21 ff 0f    ...
	shld	L0ae2+1		;; 0505: 22 e3 0a    "..
	lxi	h,011ffh	;; 0508: 21 ff 11    ...
	shld	L0aeb+1		;; 050b: 22 ec 0a    "..
	lxi	h,007ffh	;; 050e: 21 ff 07    ...
	shld	L0af4+1		;; 0511: 22 f5 0a    "..
	ret			;; 0514: c9          .

; "j........m[^A]"
L0515:	mvi	a,35		;; 0515: 3e 23       >#
	jmp	L04ef		;; 0517: c3 ef 04    ...

; changes num tracks... A=numtrk
settrk:	sta	L090a+1		;; 051a: 32 0b 09    2..
	sta	L0ee3+1		;; 051d: 32 e4 0e    2..
	sta	L11e2+1
	ret			;; 0523: c9          .

; changes spt... C=spt, B=hi-dens spt
setspt:	mov	a,c		;; 0524: 79          y
	sta	L0712+1		;; 0525: 32 13 07    2..
	sta	L083d+1		;; 0528: 32 3e 08    2>.
	sta	L0845+1		;; 052b: 32 46 08    2F.
	inr	a		;; 052e: 3c          <
	sta	L089b+1		;; 052f: 32 9c 08    2..
	dcr	a		;; 0532: 3d          =
	sta	L08f0+1		;; 0533: 32 f1 08    2..
	sta	fdfmt1+1	;; 0536: 32 66 09    2f.
	sta	fdfmt0+1	;; 0539: 32 72 09    2r.
	sta	L0f5e+1		;; 053c: 32 5f 0f    2_.
	mov	a,b		;; 053f: 78          x
	sta	L078e+1		;; 0540: 32 8f 07    2..
	sta	L08f5+1		;; 0543: 32 f6 08    2..
	sta	fdfmt2+1	;; 0546: 32 6c 09    2l.
	sta	L0f63+1		;; 0549: 32 64 0f    2d.
	ret			;; 054c: c9          .

; Set interleave tables, HL=low-dens, DE=hi-dens
setilv:	shld	L08d7+1		;; 054d: 22 d8 08    "..
	shld	L0f45+1		;; 0550: 22 46 0f    "F.
	shld	L1237+1		;; 0553: 22 38 12    "8.
	xchg			;; 0556: eb          .
	shld	L08cf+1		;; 0557: 22 d0 08    "..
	shld	L0f3d+1		;; 055a: 22 3e 0f    ">.
	shld	L122f+1		;; 055d: 22 30 12    "0.
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
break:	call	print		;; 059f: cd de 05    ...
	db	'\Break program execution (Y/N)? $'
	call	conin		;; 05c3: cd 73 05    .s.
	cpi	'Y'		;; 05c6: fe 59       .Y
	jz	L05d4		;; 05c8: ca d4 05    ...
	call	print		;; 05cb: cd de 05    ...
	db	'No$'
	jmp	crlf		;; 05d1: c3 f0 05    ...

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
	cz	crlf		;; 05ea: cc f0 05    ...
	jmp	print		;; 05ed: c3 de 05    ...

crlf:	call	print		;; 05f0: cd de 05    ...
	db	CR,LF,'$'
	ret			;; 05f6: c9          .

; print HL in decimal (recursive)
decout:	push	b		;; 05f7: c5          .
	push	d		;; 05f8: d5          .
	push	h		;; 05f9: e5          .
	lxi	b,-10		;; 05fa: 01 f6 ff    ...
	lxi	d,-1		;; 05fd: 11 ff ff    ...
L0600:	dad	b		;; 0600: 09          .
	inx	d		;; 0601: 13          .
	jc	L0600		;; 0602: da 00 06    ...
	lxi	b,10		;; 0605: 01 0a 00    ...
	dad	b		;; 0608: 09          .
	xchg			;; 0609: eb          .
	mov	a,h		;; 060a: 7c          |
	ora	l		;; 060b: b5          .
	cnz	decout		;; 060c: c4 f7 05    ...
	mov	a,e		;; 060f: 7b          {
	adi	'0'		;; 0610: c6 30       .0
	call	conout		;; 0612: cd 64 05    .d.
	pop	h		;; 0615: e1          .
	pop	d		;; 0616: d1          .
	pop	b		;; 0617: c1          .
	ret			;; 0618: c9          .

; FORMAT option selected
format:	mvi	a,CAN		;; 0619: 3e 18       >.
	call	conout		;; 061b: cd 64 05    .d.
L061e:	lxi	sp,stack	;; 061e: 31 6a 0a    1j.
	call	print		;; 0621: cd de 05    ...
	db	'\\\\FORMAT DISK UTILITY$'
L063c:	call	print		;; 063c: cd de 05    ...
	db	'\\Select disk (A-D) to FORMAT or type (SPACE) to reboot: $'
	call	conine		;; 0679: cd 61 05    .a.
	cpi	CR		;; 067c: fe 0d       ..
	jz	L061e		;; 067e: ca 1e 06    ...
	cpi	CTLC		;; 0681: fe 03       ..
	jz	exit		;; 0683: ca 61 04    .a.
	cpi	' '		;; 0686: fe 20       . 
	jz	menu		;; 0688: ca 69 01    .i.
	sta	L07e7		;; 068b: 32 e7 07    2..
	sui	'A'		;; 068e: d6 41       .A
	jc	L063c		;; 0690: da 3c 06    .<.
	cpi	'D'-'A'+1	;; 0693: fe 04       ..
	jnc	L063c		;; 0695: d2 3c 06    .<.
	sta	fdcbuf+1	;; 0698: 32 60 09    2`.
	sta	curcmd+2	; DS1/DS0
	call	L0d7f		;; 069e: cd 7f 0d    ...
	lxi	h,buffer	;; 06a1: 21 63 12    .c.
	shld	dmaadr		;; 06a4: 22 4c 09    "L.
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
	jz	exit		;; 06e7: ca 61 04    .a.
	cpi	' '		;; 06ea: fe 20       . 
	jz	menu		;; 06ec: ca 69 01    .i.
	jmp	L06a7		;; 06ef: c3 a7 06    ...

; 128-byte sector SD FORMAT case
L06f2:	call	print		;; 06f2: cd de 05    ...
	db	CR,SYN,'Single density$'
	mvi	b,000h		;; 0706: 06 00       ..
	mvi	a,00dh	; FORMAT TRACK
	sta	fdcbuf		;; 070a: 32 5f 09    2_.
	mvi	a,0	; N - sector size 128
	sta	fdcbuf+2	;; 070f: 32 61 09    2a.
L0712:	mvi	a,26	; SC - spt
	sta	fdcbuf+3	;; 0714: 32 62 09    2b.
	mvi	a,27	; GPL
	sta	fdcbuf+4	;; 0719: 32 63 09    2c.
	jmp	L07ae		;; 071c: c3 ae 07    ...

; DD FORMAT case - choose sector size
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
	jz	exit		;; 0773: ca 61 04    .a.
	cpi	' '		;; 0776: fe 20       . 
	jz	menu		;; 0778: ca 69 01    .i.
	jmp	L071f		;; 077b: c3 1f 07    ...

; 512-byte sector DD FORMAT case
L077e:	call	print		;; 077e: cd de 05    ...
	db	CR,SYN,'512$'
	mvi	b,002h		;; 0787: 06 02       ..
	mvi	a,002h	; N - sector size 512
	sta	fdcbuf+2	;; 078b: 32 61 09    2a.
L078e:	mvi	a,16	; SC - spt
L0790:	sta	fdcbuf+3	;; 0790: 32 62 09    2b.
	mvi	a,54	; GPL
	sta	fdcbuf+4	;; 0795: 32 63 09    2c.
	mvi	a,04dh	; FORMAT + MFM
	sta	fdcbuf		;; 079a: 32 5f 09    2_.
	call	print		;; 079d: cd de 05    ...
	db	' bytes/sector$'
L07ae:	mov	a,b		;; 07ae: 78          x
	sta	ddflg		;; 07af: 32 46 09    2F.
L07b2:	call	print		;; 07b2: cd de 05    ...
	db	'\Check diskette (FORMAT will destroy data on disk '
L07e7:	db	'A:)\'
	db	'Type (CR) to continue or (SPACE) to abort$'
	call	conin		;; 0815: cd 73 05    .s.
	cpi	CTLC		;; 0818: fe 03       ..
	jz	exit		;; 081a: ca 61 04    .a.
	cpi	' '		;; 081d: fe 20       . 
	jz	L061e		;; 081f: ca 1e 06    ...
	cpi	CR		;; 0822: fe 0d       ..
	jnz	L07b2		;; 0824: c2 b2 07    ...
	call	crlf		;; 0827: cd f0 05    ...
	jmp	L088c		;; 082a: c3 8c 08    ...

; 256-byte sector DD FORMAT case
L082d:	call	print		;; 082d: cd de 05    ...
	db	CR,SYN,'256$'
	mvi	b,001h		;; 0836: 06 01       ..
	mvi	a,001h	; N - sector size 256
	sta	fdcbuf+2	;; 083a: 32 61 09    2a.
L083d:	mvi	a,26	; SC - spt
	jmp	L0790		;; 083f: c3 90 07    ...

; Alter sector list, update C (track)
updtrk:	lxi	d,4		;; 0842: 11 04 00    ...
L0845:	mvi	c,26		;; 0845: 0e 1a       ..
L0847:	mov	m,a		;; 0847: 77          w
	dad	d		;; 0848: 19          .
	dcr	c		;; 0849: 0d          .
	rz			;; 084a: c8          .
	jmp	L0847		;; 084b: c3 47 08    .G.

fmttrk:	mvi	a,5		;; 084e: 3e 05       >.
L0850:	sta	retry		;; 0850: 32 47 09    2G.
	di			;; 0853: f3          .
	lxi	h,fmtbuf		;; 0854: 21 c2 09    ...
	mov	a,l		;; 0857: 7d          }
	out	DMA_1A		;; 0858: d3 32       .2
	mov	a,h		;; 085a: 7c          |
	out	DMA_1A		;; 085b: d3 32       .2
	lda	fdcbuf+3	; SC (spt)
	ral			;; 0860: 17          .
	ral			;; 0861: 17          .
	ani	11111100b	; num bytes in sector list
	dcr	a		;; 0864: 3d          =
	out	DMA_1C		;; 0865: d3 33       .3
	mvi	a,DMA_RD	;; 0867: 3e 80       >.
	out	DMA_1C		;; 0869: d3 33       .3
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL		;; 086d: d3 38       .8
	ei			;; 086f: fb          .
	lxi	h,fdcbuf		;; 0870: 21 5f 09    ._.
	mvi	c,5		;; 0873: 0e 05       ..
	call	fdccmd		;; 0875: cd bc 0a    ...
	rz			;; 0878: c8          .
	mov	a,m		;; 0879: 7e          ~
	ani	00011000b	;; 087a: e6 18       ..
	cnz	L0d43		;; 087c: c4 43 0d    .C.
	lda	retry		;; 087f: 3a 47 09    :G.
	dcr	a		;; 0882: 3d          =
	jnz	L0850		;; 0883: c2 50 08    .P.
	lxi	h,fdcres+2		;; 0886: 21 bc 09    ...
	jmp	L0c20		;; 0889: c3 20 0c    . .

L088c:	call	L0b0b		;; 088c: cd 0b 0b    ...
	call	L0d9b		;; 088f: cd 9b 0d    ...
	lda	fdcbuf+2		;; 0892: 3a 61 09    :a.
	mov	b,a		;; 0895: 47          G
	lxi	h,fmtbuf		;; 0896: 21 c2 09    ...
	xra	a		;; 0899: af          .
L089a:	inr	a		;; 089a: 3c          <
L089b:	cpi	26+1		;; 089b: fe 1b       ..
	jnc	L08ad		;; 089d: d2 ad 08    ...
	mvi	m,0		;; 08a0: 36 00       6.
	inx	h		;; 08a2: 23          #
	mvi	m,0		;; 08a3: 36 00       6.
	inx	h		;; 08a5: 23          #
	mov	m,a		;; 08a6: 77          w
	inx	h		;; 08a7: 23          #
	mov	m,b		;; 08a8: 70          p
	inx	h		;; 08a9: 23          #
	jmp	L089a		;; 08aa: c3 9a 08    ...

; 'fmttrk' already retries 5 times...
; why does this do more?
L08ad:	mvi	a,5		;; 08ad: 3e 05       >.
L08af:	sta	retry2		;; 08af: 32 49 09    2I.
	call	fmttrk		;; 08b2: cd 4e 08    .N.
	jz	L08c8		;; 08b5: ca c8 08    ...
	lda	retry2		;; 08b8: 3a 49 09    :I.
	dcr	a		;; 08bb: 3d          =
	jnz	L08af		;; 08bc: c2 af 08    ...
	call	crlf		;; 08bf: cd f0 05    ...
	call	break		;; 08c2: cd 9f 05    ...
	jmp	L0900		;; 08c5: c3 00 09    ...

L08c8:	lxi	b,0		;; 08c8: 01 00 00    ...
L08cb:	push	b		;; 08cb: c5          .
	lda	ddflg		;; 08cc: 3a 46 09    :F.
L08cf:	lxi	h,ilv8m2	;; 08cf: 21 91 09    ...
	cpi	002h		;; 08d2: fe 02       ..
	jz	L08da		;; 08d4: ca da 08    ...
L08d7:	lxi	h,ilv8m0	;; 08d7: 21 77 09    .w.
L08da:	dad	b		;; 08da: 09          .
	mov	a,m		;; 08db: 7e          ~
	sta	curcmd+5	; sector
	call	read		;; 08df: cd 9c 0b    ...
	pop	b		;; 08e2: c1          .
	jnz	L091b		;; 08e3: c2 1b 09    ...
	inr	c		;; 08e6: 0c          .
	lda	ddflg		;; 08e7: 3a 46 09    :F.
	cpi	002h		;; 08ea: fe 02       ..
	mov	a,c		;; 08ec: 79          y
	jz	L08f5		;; 08ed: ca f5 08    ...
L08f0:	cpi	26		;; 08f0: fe 1a       ..
	jmp	L08f7		;; 08f2: c3 f7 08    ...

L08f5:	cpi	16		;; 08f5: fe 10       ..
L08f7:	jc	L08cb		;; 08f7: da cb 08    ...
	call	print		;; 08fa: cd de 05    ...
	db	CR,SYN,'$'
L0900:	call	conbrk		;; 0900: cd 8d 05    ...
	lda	curcmd+3	; next track
	inr	a		;; 0906: 3c          <
	sta	curcmd+3	;; 0907: 32 56 09    2V.
L090a:	cpi	77		;; 090a: fe 4d       .M
	jnc	L092b		;; 090c: d2 2b 09    .+.
	lxi	h,fmtbuf	;; 090f: 21 c2 09    ...
	call	updtrk		;; 0912: cd 42 08    .B.
	call	L0dac		;; 0915: cd ac 0d    ...
	jmp	L08ad		;; 0918: c3 ad 08    ...

L091b:	lda	retry2		;; 091b: 3a 49 09    :I.
	dcr	a		;; 091e: 3d          =
	jnz	L08af		;; 091f: c2 af 08    ...
	call	crlf		;; 0922: cd f0 05    ...
	call	break		;; 0925: cd 9f 05    ...
	jmp	L0900		;; 0928: c3 00 09    ...

L092b:	call	print		;; 092b: cd de 05    ...
	db	'\FORMAT complete$'
	jmp	L061e		;; 093f: c3 1e 06    ...

vecsav:	dw	0	; original/BIOS FDC intr routine
vecptr:	dw	0	; FDC intr vector location

ddflg:	db	0	; 0=SD, 1/2=DD
retry:	db	5
errflg:	db	0	; controls retry (TBD)
retry2:	db	3
dmalen:	dw	0
dmaadr:	dw	0
errcnt:	dw	0

rwflg:	db	0
srcdrv:	db	0	; drive for source of COPY
dstdrv:	db	0	; drive for target of COPY

curcmd:	db	0	; DMA count flags
	db	0	; FDC read/write command
	db	0	; DS1/DS0 (drive select)
	db	0	; C (track)
	db	0	; H (side)
	db	1	; R (sector)
	; falls through to N, EOT, GPL, DTL for read/write
; current active fdc param block, from fdfmt1...
curfmt:	db	0	; N (sector size code)
	db	0	; SC/EOT (spt)
	db	0	; GPL
	db	0	; DTL (sector size if 128)
	db	0	; write command
	db	0	; read command

; FDC command buffer
fdcbuf:	db	0,0,0,0,0,0e5h

; These are modified for 5/8" drives...
fdfmt1:	db	1	; 256 byte sectors
	db	26
	db	14
	db	255
	db	46h	; READ + MFM
	db	45h	; WRITE + MFM

fdfmt2:	db	2	; 512 byte sectors
	db	16
	db	14
	db	255
	db	46h	; READ + MFM
	db	45h	; WRITE + MFM

fdfmt0:	db	0	; 128 byte sectors
	db	26
	db	7
	db	128
	db	6	; READ (FM)
	db	5	; WRITE (FM)

ilv8m0:	db	1,3,5,7,9,11,13,15,17,19,21,23,25
	db	2,4,6,8,10,12,14,16,18,20,22,24,26

ilv8m2:	db	1,3,5,7,9,11,13,15
	db	2,4,6,8,10,12,14,16

ilv5m0:	db	1,3,5,7,9,11,13,15
	db	2,4,6,8,10,12,14,16

ilv5m2:	db	1,3,5,7,9,2,4,6,8

; FDC command response buffer
; first byte is flag, not recv'd from FDC
fdcres:	db	0,0,0,0,0,0,0,0

; FORMAT sector list buffer
fmtbuf:	db	0	; ds 26*4

; i.e.
;fmtbuf: ds	26*4
;	ds	64
;stack:	ds	0
	; shadows from previous memory contents
	; these are only here so that the binaries match.
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
	db	'{n',5,'5',0e6h,'2',0,0,0,9bh,0ah,0eah,5,0f6h,5,0edh,5,'B'
	db	1
stack:	ds	0

; Begin and FDC command - ensure chip is idle
fdcbeg:	push	psw		;; 0a6a: f5          .
L0a6b:	in	FDC_STS		;; 0a6b: db 40       .@
	ani	01fh	; anything BUSY
	jnz	L0a6b		;; 0a6f: c2 6b 0a    .k.
	pop	psw		;; 0a72: f1          .
; output a byte to FDC - check only RQM/DIO
fdcout:	push	psw		;; 0a73: f5          .
L0a74:	in	FDC_STS		;; 0a74: db 40       .@
	ral		; RQM
	jnc	L0a74	; wait for RQM
	ral		; DIO
	jc	die1	; error if wrong direction
	pop	psw		;; 0a7e: f1          .
	out	FDC_DAT		;; 0a7f: d3 41       .A
	ret			;; 0a81: c9          .

;
fdcin:	in	FDC_STS		;; 0a82: db 40       .@
	ral		; RQM
	jnc	fdcin	; wait for RQM
	ral		; DIO
	jnc	die	; error if wrong direction
	in	FDC_DAT		;; 0a8c: db 41       .A
	ret			;; 0a8e: c9          .

die1:	pop	psw		;; 0a8f: f1          .
die:	call	print		;; 0a90: cd de 05    ...
	db	'\FDC ERROR, HARDWARE RESET REQUIRED',BEL,'$'
	di			;; 0ab8: f3          .
	jmp	$		;; 0ab9: c3 b9 0a    ...

; HL=FDC command, C=num additional bytes
fdccmd:	di			;; 0abc: f3          .
	mov	a,m		;; 0abd: 7e          ~
	call	fdcbeg		;; 0abe: cd 6a 0a    .j.
L0ac1:	inx	h		;; 0ac1: 23          #
	mov	a,m		;; 0ac2: 7e          ~
	call	fdcout		;; 0ac3: cd 73 0a    .s.
	dcr	c		;; 0ac6: 0d          .
	jnz	L0ac1		;; 0ac7: c2 c1 0a    ...
	ei			;; 0aca: fb          .
	; wait for response (via intr)
	lxi	h,fdcres	;; 0acb: 21 ba 09    ...
L0ace:	mov	a,m		;; 0ace: 7e          ~
	ora	a		;; 0acf: b7          .
	jz	L0ace		;; 0ad0: ca ce 0a    ...
	mvi	m,0		;; 0ad3: 36 00       6.
	inx	h		;; 0ad5: 23          #
	mov	a,m		;; 0ad6: 7e          ~
	ani	0c0h		;; 0ad7: e6 c0       ..
	ret			;; 0ad9: c9          .

L0ada:	lda	ddflg		;; 0ada: 3a 46 09    :F.
	ora	a		;; 0add: b7          .
	jz	L0af4		;; 0ade: ca f4 0a    ...
	; DD setup
	rar	; 1=>CY, 2=>NC
L0ae2:	lxi	h,019ffh	;; 0ae2: 21 ff 19    ...
	lxi	d,fdfmt1	;; 0ae5: 11 65 09    .e.
	jc	L0afa		;; 0ae8: da fa 0a    ...
L0aeb:	lxi	h,01fffh	;; 0aeb: 21 ff 1f    ...
L0aee:	lxi	d,fdfmt2	;; 0aee: 11 6b 09    .k.
	jmp	L0afa		;; 0af1: c3 fa 0a    ...

; SD setup
L0af4:	lxi	h,00cffh	;; 0af4: 21 ff 0c    ...
L0af7:	lxi	d,fdfmt0	;; 0af7: 11 71 09    .q.
L0afa:	shld	dmalen		;; 0afa: 22 4a 09    "J.
	lxi	h,curfmt	;; 0afd: 21 59 09    .Y.
	mvi	b,6		;; 0b00: 06 06       ..
L0b02:	ldax	d		;; 0b02: 1a          .
	mov	m,a		;; 0b03: 77          w
	inx	h		;; 0b04: 23          #
	inx	d		;; 0b05: 13          .
	dcr	b		;; 0b06: 05          .
	jnz	L0b02		;; 0b07: c2 02 0b    ...
	ret			;; 0b0a: c9          .

L0b0b:	lda	ddflg		;; 0b0b: 3a 46 09    :F.
	ora	a		;; 0b0e: b7          .
	jz	L0b22		;; 0b0f: ca 22 0b    .".
	rar			;; 0b12: 1f          .
	lxi	h,000ffh	;; 0b13: 21 ff 00    ...
	lxi	d,fdfmt1	;; 0b16: 11 65 09    .e.
	jc	L0afa		;; 0b19: da fa 0a    ...
	lxi	h,001ffh	;; 0b1c: 21 ff 01    ...
	jmp	L0aee		;; 0b1f: c3 ee 0a    ...

L0b22:	lxi	h,0007fh	;; 0b22: 21 7f 00    ...
	jmp	L0af7		;; 0b25: c3 f7 0a    ...

L0b28:	call	L0d9b		;; 0b28: cd 9b 0d    ...
	xra	a		;; 0b2b: af          .
	sta	ddflg		;; 0b2c: 32 46 09    2F.
	lxi	h,0007fh	;; 0b2f: 21 7f 00    ...
	lxi	d,fdfmt0	;; 0b32: 11 71 09    .q.
	call	L0afa		;; 0b35: cd fa 0a    ...
	call	readid		;; 0b38: cd b6 0d    ...
	rz			;; 0b3b: c8          .
	mvi	a,001h		;; 0b3c: 3e 01       >.
	sta	ddflg		;; 0b3e: 32 46 09    2F.
	lxi	h,000ffh	;; 0b41: 21 ff 00    ...
	lxi	d,fdfmt1	;; 0b44: 11 65 09    .e.
	call	L0afa		;; 0b47: cd fa 0a    ...
	call	readid		;; 0b4a: cd b6 0d    ...
	rz			;; 0b4d: c8          .
	mvi	a,002h		;; 0b4e: 3e 02       >.
	sta	ddflg		;; 0b50: 32 46 09    2F.
	lxi	h,001ffh	;; 0b53: 21 ff 01    ...
	lxi	d,fdfmt2	;; 0b56: 11 6b 09    .k.
	call	L0afa		;; 0b59: cd fa 0a    ...
	call	readid		;; 0b5c: cd b6 0d    ...
	rz			;; 0b5f: c8          .
	call	print		;; 0b60: cd de 05    ...
	db	'\CANNOT DETERMINE DENSITY on disk $'
	call	L0d8e		;; 0b86: cd 8e 0d    ...
	mvi	a,007h		;; 0b89: 3e 07       >.
	call	conout		;; 0b8b: cd 64 05    .d.
	xra	a		;; 0b8e: af          .
	inr	a		;; 0b8f: 3c          <
	ret			;; 0b90: c9          .

; Setup for FDC write (DMA read)
write:	lda	curfmt+5	; FDC WRITE command
	mov	h,a		;; 0b94: 67          g
	mvi	l,DMA_RD	;; 0b95: 2e 80       ..
	mvi	a,0ffh	; write
	jmp	L0ba3		;; 0b99: c3 a3 0b    ...

; Setup for FDC read (DMA write)
read:	lda	curfmt+4	; FDC READ command
	mov	h,a		;; 0b9f: 67          g
	mvi	l,DMA_WR	;; 0ba0: 2e 40       .@
	xra	a	; read
L0ba3:	sta	rwflg		;; 0ba3: 32 50 09    2P.
	shld	curcmd		;; 0ba6: 22 53 09    "S.
	xra	a		;; 0ba9: af          .
	sta	errflg		;; 0baa: 32 48 09    2H.
	mvi	a,10		;; 0bad: 3e 0a       >.
	sta	retry		;; 0baf: 32 47 09    2G.
L0bb2:	lxi	h,curcmd		;; 0bb2: 21 53 09    .S.
	mov	a,m	; DMAC byte
	inx	h		;; 0bb6: 23          #
	push	h		;; 0bb7: e5          .
	push	psw		;; 0bb8: f5          .
	di			;; 0bb9: f3          .
	lhld	dmalen		;; 0bba: 2a 4a 09    *J.
	mov	a,l		;; 0bbd: 7d          }
	out	DMA_1C		;; 0bbe: d3 33       .3
	pop	psw		;; 0bc0: f1          .
	ora	h	; set ctl bits in count
	out	DMA_1C		;; 0bc2: d3 33       .3
	lhld	dmaadr		;; 0bc4: 2a 4c 09    *L.
	mov	a,l		;; 0bc7: 7d          }
	out	DMA_1A		;; 0bc8: d3 32       .2
	mov	a,h		;; 0bca: 7c          |
	out	DMA_1A		;; 0bcb: d3 32       .2
	; DMA auto-load, TC stop, ext write (+ch 2)
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL		;; 0bcf: d3 38       .8
	ei			;; 0bd1: fb          .
	pop	h	; fdc cmd ptr
	mvi	c,8	; cmd+8 bytes
	call	fdccmd		;; 0bd5: cd bc 0a    ...
	rz			;; 0bd8: c8          .
	lxi	d,L0bb2		;; 0bd9: 11 b2 0b    ...
	push	d		;; 0bdc: d5          .
	mov	a,m		;; 0bdd: 7e          ~
	ani	00011000b	;; 0bde: e6 18       ..
	jnz	L0d43		;; 0be0: c2 43 0d    .C.
	inx	h		;; 0be3: 23          #
	inx	h		;; 0be4: 23          #
	mov	a,m		;; 0be5: 7e          ~
	ani	010h		;; 0be6: e6 10       ..
	jz	L0c0d		;; 0be8: ca 0d 0c    ...
	lda	errflg		;; 0beb: 3a 48 09    :H.
	ora	a		;; 0bee: b7          .
	jnz	L0c0d		;; 0bef: c2 0d 0c    ...
	cma			;; 0bf2: 2f          /
	sta	errflg		;; 0bf3: 32 48 09    2H.
	lda	curcmd+1	; FDC command
	push	psw		;; 0bf9: f5          .
	lda	curcmd+3	; track
	push	psw		;; 0bfd: f5          .
	call	L0d9e		;; 0bfe: cd 9e 0d    ...
	pop	psw		;; 0c01: f1          .
	sta	curcmd+3	; restore track
	call	L0dac		;; 0c05: cd ac 0d    ...
	pop	psw		;; 0c08: f1          .
	sta	curcmd+1	; restore command
	ret			;; 0c0c: c9          .

L0c0d:	lda	retry		;; 0c0d: 3a 47 09    :G.
	dcr	a		;; 0c10: 3d          =
	sta	retry		;; 0c11: 32 47 09    2G.
	rnz			;; 0c14: c0          .
	pop	d		;; 0c15: d1          .
	lxi	h,fdcres+2	;; 0c16: 21 bc 09    ...
	lda	rwflg		;; 0c19: 3a 50 09    :P.
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

L0cf2:	mvi	h,0		;; 0cf2: 26 00       &.
	call	print		;; 0cf4: cd de 05    ...
	db	' - bad sector $'
	lda	curcmd+5	; print sector
	mov	l,a		;; 0d09: 6f          o
	call	decout		;; 0d0a: cd f7 05    ...
L0d0d:	call	print		;; 0d0d: cd de 05    ...
	db	' on track $'
	lda	curcmd+3	; print track
	mov	l,a		;; 0d1e: 6f          o
	call	decout		;; 0d1f: cd f7 05    ...
	lhld	errcnt		;; 0d22: 2a 4e 09    *N.
	inx	h		;; 0d25: 23          #
	shld	errcnt		;; 0d26: 22 4e 09    "N.
	ret			;; 0d29: c9          .

sense:	di			;; 0d2a: f3          .
	mvi	a,004h	; SENSE command
	call	fdcbeg		;; 0d2d: cd 6a 0a    .j.
	lda	curcmd+2	; drive select
	call	fdcout		;; 0d33: cd 73 0a    .s.
	call	fdcin		;; 0d36: cd 82 0a    ...
	ei			;; 0d39: fb          .
	ani	020h		;; 0d3a: e6 20       . 
	rnz			;; 0d3c: c0          .
	call	L0d43		;; 0d3d: cd 43 0d    .C.
	jmp	sense		;; 0d40: c3 2a 0d    .*.

L0d43:	call	print		;; 0d43: cd de 05    ...
	db	'\Disk $'
	call	L0d8e		;; 0d4d: cd 8e 0d    ...
	call	print		;; 0d50: cd de 05    ...
	db	' not ready, type (CR) to continue',BEL,'$'
	call	conin		;; 0d76: cd 73 05    .s.
	cpi	003h		;; 0d79: fe 03       ..
	jz	L0409		;; 0d7b: ca 09 04    ...
	ret			;; 0d7e: c9          .

L0d7f:	call	print		;; 0d7f: cd de 05    ...
	db	CR,SYN,'$'
L0d85:	call	print		;; 0d85: cd de 05    ...
	db	'Disk $'
L0d8e:	lda	curcmd+2	; print drive
	adi	'A'		;; 0d91: c6 41       .A
	call	conout		;; 0d93: cd 64 05    .d.
	mvi	a,':'		;; 0d96: 3e 3a       >:
	jmp	conout		;; 0d98: c3 64 05    .d.

L0d9b:	call	sense		;; 0d9b: cd 2a 0d    .*.
L0d9e:	xra	a		;; 0d9e: af          .
	sta	curcmd+3	; track is 0
	lxi	h,curcmd+1	; overwrite FDC r/w cmd
	mvi	m,007h	; RECALIBRATE command
	mvi	c,1		;; 0da7: 0e 01       ..
	jmp	fdccmd		;; 0da9: c3 bc 0a    ...

L0dac:	lxi	h,curcmd+1	; overwrite FDC r/w cmd
	mvi	m,00fh	; SEEK command
	mvi	c,2		;; 0db1: 0e 02       ..
	jmp	fdccmd		;; 0db3: c3 bc 0a    ...

readid:	lda	curfmt+4	; FDC READ cmd
	ani	040h	; isolate MFM bit
	ori	00ah	; READ ID command
	lxi	h,curcmd+1	; overwrite FDC r/w cmd
	mov	m,a		;; 0dc0: 77          w
	mvi	c,1		;; 0dc1: 0e 01       ..
	call	fdccmd		;; 0dc3: cd bc 0a    ...
	rnz			;; 0dc6: c0          .
	lda	fdcres+7	;; 0dc7: 3a c1 09    :..
	lxi	h,ddflg		;; 0dca: 21 46 09    .F.
	cmp	m		;; 0dcd: be          .
	ret			;; 0dce: c9          .

; private intr handler for FDC
fdcint:	push	psw		;; 0dcf: f5          .
	push	h		;; 0dd0: e5          .
	lxi	h,fdcres	;; 0dd1: 21 ba 09    ...
	in	FDC_STS		;; 0dd4: db 40       .@
	ani	010h		;; 0dd6: e6 10       ..
	jnz	L0dfb	; FDC has response for us
	mvi	a,008h	; SENSE command
	call	fdcout		;; 0ddd: cd 73 0a    .s.
	call	fdcin	; ST0
	inx	h		;; 0de3: 23          #
	mov	m,a		;; 0de4: 77          w
	ani	0c0h	; check intr code
	cpi	080h	; invalid command?
	jz	L0e0a		;; 0de9: ca 0a 0e    ...
	call	fdcin	; PCN (ignored)
	mov	a,m		;; 0def: 7e          ~
	ani	020h	; SEEK END
	jz	L0e0a		;; 0df2: ca 0a 0e    ...
	dcx	h		;; 0df5: 2b          +
	mvi	m,001h	; flag as completion
	jmp	L0e0a		;; 0df8: c3 0a 0e    ...

L0dfb:	mvi	m,001h	; flag as completion
	push	b		;; 0dfd: c5          .
	mvi	b,7	; 7 bytes in response
L0e00:	inx	h		;; 0e00: 23          #
	call	fdcin		;; 0e01: cd 82 0a    ...
	mov	m,a		;; 0e04: 77          w
	dcr	b		;; 0e05: 05          .
	jnz	L0e00		;; 0e06: c2 00 0e    ...
	pop	b		;; 0e09: c1          .
L0e0a:	pop	h		;; 0e0a: e1          .
	pop	psw		;; 0e0b: f1          .
	ei			;; 0e0c: fb          .
	reti			;; 0e0d: ed 4d       .M

; VERIFY option selected
verify:	mvi	a,CAN		;; 0e0f: 3e 18       >.
	call	conout		;; 0e11: cd 64 05    .d.
L0e14:	lxi	sp,stack	;; 0e14: 31 6a 0a    1j.
	call	print		;; 0e17: cd de 05    ...
	db	'\\\\VERIFY DISK UTILITY$'
L0e32:	call	print		;; 0e32: cd de 05    ...
	db	'\\Select disk (A-D) to VERIFY or type (SPACE) to reboot: $'
	call	conine		;; 0e6f: cd 61 05    .a.
	cpi	CR		;; 0e72: fe 0d       ..
	jz	L0e14		;; 0e74: ca 14 0e    ...
	cpi	CTLC		;; 0e77: fe 03       ..
	jz	exit		;; 0e79: ca 61 04    .a.
	cpi	' '		;; 0e7c: fe 20       . 
	jz	menu		;; 0e7e: ca 69 01    .i.
	sta	L0f27		;; 0e81: 32 27 0f    2'.
	sui	'A'		;; 0e84: d6 41       .A
	jc	L0e32		;; 0e86: da 32 0e    .2.
	cpi	'D'-'A'+1	;; 0e89: fe 04       ..
	jnc	L0e32		;; 0e8b: d2 32 0e    .2.
	sta	curcmd+2	; set DS1/DS0 in cmd buf
	call	L0b28		;; 0e91: cd 28 0b    .(.
	jnz	L0e14		;; 0e94: c2 14 0e    ...
	call	L0d7f		;; 0e97: cd 7f 0d    ...
	lda	ddflg		;; 0e9a: 3a 46 09    :F.
	ora	a		;; 0e9d: b7          .
	jz	L0eaf		;; 0e9e: ca af 0e    ...
	call	print		;; 0ea1: cd de 05    ...
	db	' double$'
	jmp	L0eba		;; 0eac: c3 ba 0e    ...

L0eaf:	call	print		;; 0eaf: cd de 05    ...
	db	' single$'
L0eba:	call	print		;; 0eba: cd de 05    ...
	db	' density\$'
	lxi	h,0		;; 0ec7: 21 00 00    ...
	shld	errcnt		;; 0eca: 22 4e 09    "N.
	lxi	h,buffer	;; 0ecd: 21 63 12    .c.
	shld	dmaadr		;; 0ed0: 22 4c 09    "L.
L0ed3:	call	conbrk		;; 0ed3: cd 8d 05    ...
	call	L0dac		;; 0ed6: cd ac 0d    ...
	call	L0f36		;; 0ed9: cd 36 0f    .6.
	lda	curcmd+3	; next track
	inr	a		;; 0edf: 3c          <
	sta	curcmd+3	;; 0ee0: 32 56 09    2V.
L0ee3:	cpi	77		;; 0ee3: fe 4d       .M
	jc	L0ed3		;; 0ee5: da d3 0e    ...
	call	print		;; 0ee8: cd de 05    ...
	db	'\VERIFY complete: $'
	lhld	errcnt		;; 0efe: 2a 4e 09    *N.
	mov	a,l		;; 0f01: 7d          }
	ora	h		;; 0f02: b4          .
	jnz	L0f0f		;; 0f03: c2 0f 0f    ...
	call	print		;; 0f06: cd de 05    ...
	db	'NO$'
	jmp	L0f12		;; 0f0c: c3 12 0f    ...

L0f0f:	call	decout		;; 0f0f: cd f7 05    ...
L0f12:	call	print		;; 0f12: cd de 05    ...
	db	' read error(s) on '
L0f27:	db	'A: detected$'
	jmp	L0e14		;; 0f33: c3 14 0e    ...

L0f36:	lxi	b,0		;; 0f36: 01 00 00    ...
L0f39:	push	b		;; 0f39: c5          .
	lda	ddflg		;; 0f3a: 3a 46 09    :F.
L0f3d:	lxi	h,ilv8m2	;; 0f3d: 21 91 09    ...
	cpi	002h		;; 0f40: fe 02       ..
	jz	L0f48		;; 0f42: ca 48 0f    .H.
L0f45:	lxi	h,ilv8m0	;; 0f45: 21 77 09    .w.
L0f48:	dad	b		;; 0f48: 09          .
	mov	a,m		;; 0f49: 7e          ~
	sta	curcmd+5	; set sector
	call	read		;; 0f4d: cd 9c 0b    ...
	cnz	crlf		;; 0f50: c4 f0 05    ...
	pop	b		;; 0f53: c1          .
	inr	c		;; 0f54: 0c          .
	lda	ddflg		;; 0f55: 3a 46 09    :F.
	cpi	002h		;; 0f58: fe 02       ..
	mov	a,c		;; 0f5a: 79          y
	jz	L0f63		;; 0f5b: ca 63 0f    .c.
L0f5e:	cpi	26		;; 0f5e: fe 1a       ..
	jmp	L0f65		;; 0f60: c3 65 0f    .e.

L0f63:	cpi	16		;; 0f63: fe 10       ..
L0f65:	jc	L0f39		;; 0f65: da 39 0f    .9.
	ret			;; 0f68: c9          .

; COPY option selected
copy:	mvi	a,CAN		;; 0f69: 3e 18       >.
	call	conout		;; 0f6b: cd 64 05    .d.
L0f6e:	lxi	sp,stack	;; 0f6e: 31 6a 0a    1j.
	call	print		;; 0f71: cd de 05    ...
	db	'\\\\COPY DISK UTILITY$'
L0f8a:	call	print		;; 0f8a: cd de 05    ...
	db	'\\Select source disk (A-D) or type (SPACE) to reboot: $'
	call	conine		;; 0fc4: cd 61 05    .a.
	cpi	CR		;; 0fc7: fe 0d       ..
	jz	L0f6e		;; 0fc9: ca 6e 0f    .n.
	cpi	CTLC		;; 0fcc: fe 03       ..
	jz	exit		;; 0fce: ca 61 04    .a.
	cpi	' '		;; 0fd1: fe 20       . 
	jz	menu		;; 0fd3: ca 69 01    .i.
	sta	L10b0		;; 0fd6: 32 b0 10    2..
	sui	'A'		;; 0fd9: d6 41       .A
	jc	L0f8a		;; 0fdb: da 8a 0f    ...
	cpi	'D'-'A'+1	;; 0fde: fe 04       ..
	jnc	L0f8a		;; 0fe0: d2 8a 0f    ...
	sta	srcdrv		;; 0fe3: 32 51 09    2Q.
	sta	curcmd+2	; DS1/DS0
	call	print		;; 0fe9: cd de 05    ...
	db	CR,SYN,'Source $'
	call	L0d85		;; 0ff6: cd 85 0d    ...
L0ff9:	call	print		;; 0ff9: cd de 05    ...
	db	'\Select target disk (A-D) or type (SPACE) to reboot: $'
	call	conine		;; 1032: cd 61 05    .a.
	cpi	CR		;; 1035: fe 0d       ..
	jz	L0f6e		;; 1037: ca 6e 0f    .n.
	cpi	CTLC		;; 103a: fe 03       ..
	jz	exit		;; 103c: ca 61 04    .a.
	cpi	' '		;; 103f: fe 20       . 
	jz	menu		;; 1041: ca 69 01    .i.
	sta	L10f5		;; 1044: 32 f5 10    2..
	sui	'A'		;; 1047: d6 41       .A
	jc	L0ff9		;; 1049: da f9 0f    ...
	cpi	'D'-'A'+1	;; 104c: fe 04       ..
	jnc	L0ff9		;; 104e: d2 f9 0f    ...
	sta	dstdrv		;; 1051: 32 52 09    2R.
	sta	curcmd+2	; DS1/DS0
	lxi	h,srcdrv		;; 1057: 21 51 09    .Q.
	cmp	m		;; 105a: be          .
	jnz	L1087		;; 105b: c2 87 10    ...
	call	print		;; 105e: cd de 05    ...
	db	CR,SYN,'SAME DISK SELECTED, CANNOT COPY',BEL,'$'
	jmp	L0ff9		;; 1084: c3 f9 0f    ...

L1087:	call	print		;; 1087: cd de 05    ...
	db	CR,SYN,'Target $'
	call	L0d85		;; 1094: cd 85 0d    ...
	call	crlf		;; 1097: cd f0 05    ...
L109a:	call	print		;; 109a: cd de 05    ...
	db	CR,SYN,'Load source disk '
L10b0:	db	'A: and type (CR)$'
	call	conine		;; 10c1: cd 61 05    .a.
	cpi	CTLC		;; 10c4: fe 03       ..
	jz	exit		;; 10c6: ca 61 04    .a.
	cpi	' '		;; 10c9: fe 20       . 
	jz	menu		;; 10cb: ca 69 01    .i.
	cpi	CR		;; 10ce: fe 0d       ..
	jnz	L109a		;; 10d0: c2 9a 10    ...
	lda	srcdrv		;; 10d3: 3a 51 09    :Q.
	sta	curcmd+2	; DS1/DS0
	call	L0b28		;; 10d9: cd 28 0b    .(.
	jnz	L0f6e		;; 10dc: c2 6e 0f    .n.
L10df:	call	print		;; 10df: cd de 05    ...
	db	CR,SYN,'Load target disk '
L10f5:	db	'A: and type (CR)$'
	call	conine		;; 1106: cd 61 05    .a.
	cpi	CTLC		;; 1109: fe 03       ..
	jz	exit		;; 110b: ca 61 04    .a.
	cpi	' '		;; 110e: fe 20       . 
	jz	menu		;; 1110: ca 69 01    .i.
	cpi	CR		;; 1113: fe 0d       ..
	jnz	L10df		;; 1115: c2 df 10    ...
	call	print		;; 1118: cd de 05    ...
	db	CR,SYN,'$'
	lda	dstdrv		;; 111e: 3a 52 09    :R.
	sta	curcmd+2	; DS1/DS0
	lda	ddflg		;; 1124: 3a 46 09    :F.
	mov	c,a		;; 1127: 4f          O
	push	b		;; 1128: c5          .
	call	L0b28		;; 1129: cd 28 0b    .(.
	pop	b		;; 112c: c1          .
	jnz	L0f6e		;; 112d: c2 6e 0f    .n.
	lda	ddflg		;; 1130: 3a 46 09    :F.
	cmp	c		;; 1133: b9          .
	jz	L115d		;; 1134: ca 5d 11    .].
	call	print		;; 1137: cd de 05    ...
	db	'\DIFFERENT TARGET DISK DENSITY',BEL,'$'
	jmp	L0f6e		;; 115a: c3 6e 0f    .n.

L115d:	call	L0ada		;; 115d: cd da 0a    ...
L1160:	call	conbrk		;; 1160: cd 8d 05    ...
	lxi	h,buffer	;; 1163: 21 63 12    .c.
	shld	dmaadr		;; 1166: 22 4c 09    "L.
	lda	srcdrv		;; 1169: 3a 51 09    :Q.
	sta	curcmd+2	; DS1/DS0
	mvi	a,1		;; 116f: 3e 01       >.
	sta	curcmd+5	; sector
	call	L0dac		;; 1174: cd ac 0d    ...
	call	read		;; 1177: cd 9c 0b    ...
	jz	L1183		;; 117a: ca 83 11    ...
L117d:	call	break		;; 117d: cd 9f 05    ...
	jmp	L11db		;; 1180: c3 db 11    ...

L1183:	lda	ddflg		;; 1183: 3a 46 09    :F.
	ora	a		;; 1186: b7          .
	lxi	h,127		;; 1187: 21 7f 00    ...
	jz	L1197		;; 118a: ca 97 11    ...
	rar			;; 118d: 1f          .
	lxi	h,255		;; 118e: 21 ff 00    ...
	jc	L1197		;; 1191: da 97 11    ...
	lxi	h,511		;; 1194: 21 ff 01    ...
L1197:	shld	dmalen		;; 1197: 22 4a 09    "J.
	lda	dstdrv		;; 119a: 3a 52 09    :R.
	sta	curcmd+2	; DS1/DS0
	call	L0dac		;; 11a0: cd ac 0d    ...
	mvi	a,5		;; 11a3: 3e 05       >.
L11a5:	sta	retry2		;; 11a5: 32 49 09    2I.
	call	L1222		;; 11a8: cd 22 12    .".
	jnz	L117d		;; 11ab: c2 7d 11    .}.
	lxi	h,buffer2	;; 11ae: 21 63 32    .c2
	shld	dmaadr		;; 11b1: 22 4c 09    "L.
	call	L0ada		;; 11b4: cd da 0a    ...
	mvi	a,1		;; 11b7: 3e 01       >.
	sta	curcmd+5	; sector
	call	read		;; 11bc: cd 9c 0b    ...
	jz	L11cc		;; 11bf: ca cc 11    ...
	lda	retry2		;; 11c2: 3a 49 09    :I.
	dcr	a		;; 11c5: 3d          =
	jnz	L11a5		;; 11c6: c2 a5 11    ...
	jmp	L117d		;; 11c9: c3 7d 11    .}.

L11cc:	lhld	dmalen		;; 11cc: 2a 4a 09    *J.
	mov	c,l		;; 11cf: 4d          M
	mov	b,h		;; 11d0: 44          D
	inx	b		;; 11d1: 03          .
	lxi	h,buffer	;; 11d2: 21 63 12    .c.
	lxi	d,buffer2	;; 11d5: 11 63 32    .c2
	call	L11fc		;; 11d8: cd fc 11    ...
L11db:	lda	curcmd+3	; next track
	inr	a		;; 11de: 3c          <
	sta	curcmd+3	;; 11df: 32 56 09    2V.
L11e2:	cpi	77		;; 11e2: fe 4d       .M
	jnz	L1160		;; 11e4: c2 60 11    .`.
	call	print		;; 11e7: cd de 05    ...
	db	'\COPY complete$'
	jmp	L0f6e		;; 11f9: c3 6e 0f    .n.

L11fc:	ldax	d		;; 11fc: 1a          .
	cmp	m		;; 11fd: be          .
	jnz	L120a		;; 11fe: c2 0a 12    ...
	inx	h		;; 1201: 23          #
	inx	d		;; 1202: 13          .
	dcx	b		;; 1203: 0b          .
	mov	a,b		;; 1204: 78          x
	ora	c		;; 1205: b1          .
	jnz	L11fc		;; 1206: c2 fc 11    ...
	ret			;; 1209: c9          .

L120a:	call	print		;; 120a: cd de 05    ...
	db	'\VERIFY ERROR',BEL,'$'
	call	L0d0d		;; 121c: cd 0d 0d    ...
	jmp	break		;; 121f: c3 9f 05    ...

L1222:	lxi	h,buffer	;; 1222: 21 63 12    .c.
	shld	dmaadr		;; 1225: 22 4c 09    "L.
	lxi	b,0		;; 1228: 01 00 00    ...
L122b:	push	b		;; 122b: c5          .
	lda	ddflg		;; 122c: 3a 46 09    :F.
L122f:	lxi	h,ilv8m2	;; 122f: 21 91 09    ...
	cpi	002h		;; 1232: fe 02       ..
	jz	L123a		;; 1234: ca 3a 12    .:.
L1237:	lxi	h,ilv8m0	;; 1237: 21 77 09    .w.
L123a:	dad	b		;; 123a: 09          .
	mov	a,m		;; 123b: 7e          ~
	sta	curcmd+5	; sector
	dcr	a		;; 123f: 3d          =
	jz	L1253		;; 1240: ca 53 12    .S.
	lhld	dmalen		;; 1243: 2a 4a 09    *J.
	inx	h		;; 1246: 23          #
	xchg			;; 1247: eb          .
	lxi	h,buffer	;; 1248: 21 63 12    .c.
L124b:	dad	d		;; 124b: 19          .
	dcr	a		;; 124c: 3d          =
	jnz	L124b		;; 124d: c2 4b 12    .K.
	; computed location in buffer (&buffer[sector])
	shld	dmaadr		;; 1250: 22 4c 09    "L.
L1253:	call	write		;; 1253: cd 91 0b    ...
	pop	b		;; 1256: c1          .
	rnz			;; 1257: c0          .
	inr	c		;; 1258: 0c          .
	lxi	h,curfmt+1	;; 1259: 21 5a 09    .Z.
	mov	a,m	; SC (spt)
	cmp	c		;; 125d: b9          .
	jnz	L122b		;; 125e: c2 2b 12    .+.
	xra	a		;; 1261: af          .
	ret			;; 1262: c9          .

buffer:
; i.e.	ds 8192
	; shadows from previous memory contents
	; these are only here so that the binaries match.
	db	'I ',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,'$',92h,'I$',84h,1,'$',81h,4,92h,8,2
	db	10h,10h,2,4,92h,'A',9,21h,8,'A',0,0aah,0aah,0aah,0aah,0aah
	db	0aah,0a0h,0,'@',92h,'$',92h,'I$',89h,'"',21h,'$',92h,'H$I',0
	db	'$',92h,'I',11h,' ',92h,'"',21h,9,'$',90h,91h,10h,2,12h,'A$'
	db	88h,80h,92h,9,10h,90h,11h,2,8,4,' ',0,8,'H',84h,'H',0,90h,4
	db	0,90h,84h,'A',2,8,'A"',8,'I @',0,0,8,4,'BB',8,91h,9,' ',0
	db	84h,0,'$',90h,84h,11h,10h,10h
	db	92h,'A"'
	ds	(buffer+8192)-$
buffer2:
	ds	0
	end
