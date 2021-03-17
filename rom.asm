; Disassembly of Junior80 ROM

	maclib	z80

LF	equ	10
CR	equ	13

	org	00000h
L0000:	di			;; 0000: f3          .
L0001:	mvi	a,093h		;; 0001: 3e 93       >.
	out	003h		;; 0003: d3 03       ..
L0005:	jmp	L0014		;; 0005: c3 14 00    ...

; RST 1 - char to display (save regs)
L0008:	push	psw		;; 0008: f5          .
	push	b		;; 0009: c5          .
L000a:	push	d		;; 000a: d5          .
	push	h		;; 000b: e5          .
	call	0ff52h		;; 000c: cd 52 ff    .R.
	pop	h		;; 000f: e1          .
	pop	d		;; 0010: d1          .
	pop	b		;; 0011: c1          .
	pop	psw		;; 0012: f1          .
	ret			;; 0013: c9          .

L0014:	mvi	a,0b6h		;; 0014: 3e b6       >.
	out	073h		;; 0016: d3 73       .s
	mvi	a,0b7h		;; 0018: 3e b7       >.
	out	072h		;; 001a: d3 72       .r
	mvi	a,003h		;; 001c: 3e 03       >.
	out	072h		;; 001e: d3 72       .r
	out	04fh		;; 0020: d3 4f       .O
	; test all RAM... (above 16K)
	lxi	h,04000h	;; 0022: 21 00 40    ..@
L0025:	mov	a,m		;; 0025: 7e          ~
	cma			;; 0026: 2f          /
	mov	m,a		;; 0027: 77          w
	cmp	m		;; 0028: be          .
	jnz	L01ab		;; 0029: c2 ab 01    ...
	cma			;; 002c: 2f          /
	mov	m,a		;; 002d: 77          w
	inx	h		;; 002e: 23          #
	mov	a,h		;; 002f: 7c          |
	ora	l		;; 0030: b5          .
	jrnz	L0025		;; 0031: 20 f2        .
	lxi	h,L0046		;; 0033: 21 46 00    .F.
L0036:	jr	L003b		;; 0036: 18 03       ..

; RST 7
	jmp	L0802		;; 0038: c3 02 08    ...

L003b:	lxi	d,0fb4fh	;; 003b: 11 4f fb    .O.
	lxi	b,001fh		;; 003e: 01 1f 00    ...
	ldir			;; 0041: ed b0       ..
	jmp	0fb4fh		;; 0043: c3 4f fb    .O.

; copied into 0fb4fh
L0046:	mvi	a,092h		;; 0046: 3e 92       >.
	out	003h	; map RAM at 0
	; test RAM at 1st 16K
	lxi	h,0000h		;; 004a: 21 00 00    ...
L004d:	mov	a,m		;; 004d: 7e          ~
	cma			;; 004e: 2f          /
	mov	m,a		;; 004f: 77          w
	cmp	m		;; 0050: be          .
	jrnz	L005b		;; 0051: 20 08        .
	cma			;; 0053: 2f          /
	mov	m,a		;; 0054: 77          w
	inx	h		;; 0055: 23          #
	mov	a,h		;; 0056: 7c          |
	cpi	040h		;; 0057: fe 40       .@
	jrnz	L004d		;; 0059: 20 f2        .
L005b:	mvi	a,001h		;; 005b: 3e 01       >.
	out	002h	; restore ROM to 0
	jnz	L01ab		;; 005f: c2 ab 01    ...
	jmp	L0065		;; 0062: c3 65 00    .e.
; end of copied code

; 64K RAM OK...
L0065:	mvi	a,0c3h		;; 0065: 3e c3       >.
	sta	0ff4fh		;; 0067: 32 4f ff    2O.
	sta	0ff52h		;; 006a: 32 52 ff    2R.
	in	001h		;; 006d: db 01       ..
	ani	004h	; console is serial port?
	jrnz	L00bc		;; 0071: 20 49        I
	; setup Z80-CTC... CRT... 
	mvi	a,0f0h		;; 0073: 3e f0       >.
	out	020h		;; 0075: d3 20       . 
	mvi	a,0cfh		;; 0077: 3e cf       >.
	out	021h		;; 0079: d3 21       ..
	mvi	a,001h		;; 007b: 3e 01       >.
	out	021h		;; 007d: d3 21       ..
	xra	a		;; 007f: af          .
	out	04ah		;; 0080: d3 4a       .J
	out	04ch		;; 0082: d3 4c       .L
	out	04bh		;; 0084: d3 4b       .K
	lxi	h,L02d1		;; 0086: 21 d1 02    ...
	shld	0ff52h+1	;; 0089: 22 53 ff    "S.
	lxi	h,L02b6		;; 008c: 21 b6 02    ...
	shld	0ff50h		;; 008f: 22 50 ff    "P.
	in	001h		;; 0092: db 01       ..
	ani	008h		;; 0094: e6 08       ..
	lxi	d,04f83h	;; 0096: 11 83 4f    ..O
	jrz	L00ad		;; 0099: 28 12       (.
	; serial keyboard?
	out	04fh		;; 009b: d3 4f       .O
	in	002h		;; 009d: db 02       ..
	ori	002h		;; 009f: f6 02       ..
	out	002h		;; 00a1: d3 02       ..
	mvi	a,0cfh		;; 00a3: 3e cf       >.
	out	022h		;; 00a5: d3 22       ."
	mvi	a,001h		;; 00a7: 3e 01       >.
	out	022h		;; 00a9: d3 22       ."
	jr	L00d8		;; 00ab: 18 2b       .+

; parallel keyboard?
L00ad:	lxi	b,0f852h	;; 00ad: 01 52 f8    .R.
	outp	d		;; 00b0: ed 51       .Q
	outp	b		;; 00b2: ed 41       .A
	outp	e		;; 00b4: ed 59       .Y
	dcr	c		;; 00b6: 0d          .
	dcr	c		;; 00b7: 0d          .
	inp	a		;; 00b8: ed 78       .x
	jr	L00d8		;; 00ba: 18 1c       ..

; Serial port for console...
; setup i8253 - baud generator
L00bc:	mvi	a,056h		;; 00bc: 3e 56       >V
	out	073h		;; 00be: d3 73       .s
	mvi	a,008h		;; 00c0: 3e 08       >.
	out	071h		;; 00c2: d3 71       .q
	lxi	h,L017a		;; 00c4: 21 7a 01    .z.
	lxi	b,L0913		;; 00c7: 01 13 09    ...
	outir			;; 00ca: ed b3       ..
	lxi	h,L030a		;; 00cc: 21 0a 03    ...
	shld	0ff52h+1	;; 00cf: 22 53 ff    "S.
	lxi	h,L0245		;; 00d2: 21 45 02    .E.
	shld	0ff50h		;; 00d5: 22 50 ff    "P.

L00d8:	xra	a		;; 00d8: af          .
	out	038h		;; 00d9: d3 38       .8
	im2			;; 00db: ed 5e       .^
	mvi	a,007h		;; 00dd: 3e 07       >.
	stai			;; 00df: ed 47       .G
	mvi	a,0f0h		;; 00e1: 3e f0       >.
	out	020h		;; 00e3: d3 20       . 
	mvi	a,0dfh		;; 00e5: 3e df       >.
	out	023h		;; 00e7: d3 23       .#
	mvi	a,001h		;; 00e9: 3e 01       >.
	out	023h		;; 00eb: d3 23       .#
	lxi	sp,0ffc1h	;; 00ed: 31 c1 ff    1..
	call	L0183		;; 00f0: cd 83 01    ...
	call	L01e1		;; 00f3: cd e1 01    ...
	ei			;; 00f6: fb          .
	call	L01c8		;; 00f7: cd c8 01    ...
	db	'\** Junior-80 computer **    BOOT vers 1.1$'
	call	L0749	; setup FDC/drive
	jmp	L0314	; try to boot

L012b:	lxi	sp,0ffc1h	;; 012b: 31 c1 ff    1..
	call	L01c8		;; 012e: cd c8 01    ...

	db	'\\BOOT main kernell [ L(oad sys.) ,T(est) ] : $'

	call	L0234		;; 0160: cd 34 02    .4.
	cpi	'L'		;; 0163: fe 4c       .L
	jz	L0314		;; 0165: ca 14 03    ...
	ora	a		;; 0168: b7          .
	lhld	L0800		;; 0169: 2a 00 08    *..
	lxi	d,055aah	;; 016c: 11 aa 55    ..U
	dsbc	d		;; 016f: ed 52       .R
	jrnz	L012b		;; 0171: 20 b8        .
	cpi	'T'		;; 0173: fe 54       .T
	jz	L0802		;; 0175: ca 02 08    ...
	jr	L012b		;; 0178: 18 b1       ..

L017a:	db	18h,13h		;; 017a: 18 13       ..
	db	0c1h,14h,4ch,5,0eah,1,0

L0183:	xra	a		;; 0183: af          .
	lxi	d,0ff5bh	;; 0184: 11 5b ff    .[.
	mvi	c,02dh		;; 0187: 0e 2d       .-
	call	L01c2		;; 0189: cd c2 01    ...
	in	001h		;; 018c: db 01       ..
	ani	004h		;; 018e: e6 04       ..
	rnz			;; 0190: c0          .
L0191:	mvi	a,004h		;; 0191: 3e 04       >.
	out	04ah		;; 0193: d3 4a       .J
	; clear disp RAM to blank
	lxi	h,04000h	;; 0195: 21 00 40    ..@
	lxi	b,4000		;; 0198: 01 a0 0f    ...
	push	h		;; 019b: e5          .
	push	h		;; 019c: e5          .
	pop	d		;; 019d: d1          .
	mvi	m,' '		;; 019e: 36 20       6 
	inx	h		;; 01a0: 23          #
	mvi	m,007h		;; 01a1: 36 07       6.
	inx	h		;; 01a3: 23          #
	xchg			;; 01a4: eb          .
	ldir			;; 01a5: ed b0       ..
	pop	h		;; 01a7: e1          .
	jmp	L02ee		;; 01a8: c3 ee 02    ...

L01ab:	mvi	a,0c1h		;; 01ab: 3e c1       >.
	out	002h		;; 01ad: d3 02       ..
	lxi	b,L0000		;; 01af: 01 00 00    ...
	mvi	a,005h		;; 01b2: 3e 05       >.
L01b4:	dcr	c		;; 01b4: 0d          .
	jrnz	L01b4		;; 01b5: 20 fd        .
	djnz	L01b4		;; 01b7: 10 fb       ..
	dcr	a		;; 01b9: 3d          =
	jrnz	L01b4		;; 01ba: 20 f8        .
	mvi	a,001h		;; 01bc: 3e 01       >.
	out	002h		;; 01be: d3 02       ..
L01c0:	jr	L01c0		;; 01c0: 18 fe       ..

L01c2:	stax	d		;; 01c2: 12          .
	inx	d		;; 01c3: 13          .
	dcr	c		;; 01c4: 0d          .
	jrnz	L01c2		;; 01c5: 20 fb        .
	ret			;; 01c7: c9          .

L01c8:	xthl			;; 01c8: e3          .
	mov	a,m		;; 01c9: 7e          ~
	inx	h		;; 01ca: 23          #
	cpi	'$'		;; 01cb: fe 24       .$
	xthl			;; 01cd: e3          .
	rz			;; 01ce: c8          .
	cpi	'\'		;; 01cf: fe 5c       .\
	mov	c,a		;; 01d1: 4f          O
	cnz	L0008	; a.k.a. RST 1
	cz	L01da	; CR LF
	jr	L01c8		;; 01d8: 18 ee       ..

L01da:	mvi	c,CR		;; 01da: 0e 0d       ..
	rst	1		;; 01dc: cf          .
	mvi	c,LF		;; 01dd: 0e 0a       ..
	rst	1		;; 01df: cf          .
	ret			;; 01e0: c9          .

L01e1:	lxi	h,L0210		;; 01e1: 21 10 02    ...
	mvi	b,004h		;; 01e4: 06 04       ..
	jr	L01ed		;; 01e6: 18 05       ..

L01e8:	lxi	h,L0218		;; 01e8: 21 18 02    ...
	mvi	b,008h		;; 01eb: 06 08       ..
L01ed:	in	002h		;; 01ed: db 02       ..
	ori	0c0h		;; 01ef: f6 c0       ..
	out	002h		;; 01f1: d3 02       ..
L01f3:	mov	a,m		;; 01f3: 7e          ~
	out	072h		;; 01f4: d3 72       .r
	inx	h		;; 01f6: 23          #
	mov	a,m		;; 01f7: 7e          ~
	out	072h		;; 01f8: d3 72       .r
	inx	h		;; 01fa: 23          #
	call	L0207		;; 01fb: cd 07 02    ...
	djnz	L01f3		;; 01fe: 10 f3       ..
	in	002h		;; 0200: db 02       ..
	ani	03fh		;; 0202: e6 3f       .?
	out	002h		;; 0204: d3 02       ..
	ret			;; 0206: c9          .

L0207:	lxi	d,03800h	;; 0207: 11 00 38    ..8
L020a:	dcx	d		;; 020a: 1b          .
	mov	a,e		;; 020b: 7b          {
	ora	d		;; 020c: b2          .
	jrnz	L020a		;; 020d: 20 fb        .
	ret			;; 020f: c9          .

L0210:	ora	a		;; 0210: b7          .
	inx	b		;; 0211: 03          .
	dcx	h		;; 0212: 2b          +
	inr	b		;; 0213: 04          .
	dcx	h		;; 0214: 2b          +
	inr	b		;; 0215: 04          .
	rar			;; 0216: 1f          .
	inx	b		;; 0217: 03          .
L0218:	add	c		;; 0218: 81          .
	inx	b		;; 0219: 03          .
	add	c		;; 021a: 81          .
	inx	b		;; 021b: 03          .
	add	c		;; 021c: 81          .
	inx	b		;; 021d: 03          .
	inx	b		;; 021e: 03          .
	rlc			;; 021f: 07          .
	add	c		;; 0220: 81          .
	inx	b		;; 0221: 03          .
	add	c		;; 0222: 81          .
	inx	b		;; 0223: 03          .
	add	c		;; 0224: 81          .
	inx	b		;; 0225: 03          .
	inx	b		;; 0226: 03          .
	rlc			;; 0227: 07          .
L0228:	call	L01c8		;; 0228: cd c8 01    ...
	db	' ERROR $'
	ret			;; 0233: c9          .

L0234:	call	0ff4fh		;; 0234: cd 4f ff    .O.
	ani	07fh		;; 0237: e6 7f       ..
	mov	c,a		;; 0239: 4f          O
	rst	1		;; 023a: cf          .
	mov	a,c		;; 023b: 79          y
	cpi	061h		;; 023c: fe 61       .a
	rc			;; 023e: d8          .
	cpi	07bh		;; 023f: fe 7b       .{
	rnc			;; 0241: d0          .
	ani	05fh		;; 0242: e6 5f       ._
	ret			;; 0244: c9          .

L0245:	in	013h		;; 0245: db 13       ..
	rar			;; 0247: 1f          .
	jrnc	L0245		;; 0248: 30 fb       0.
	in	011h		;; 024a: db 11       ..
	ret			;; 024c: c9          .

	push	psw		;; 024d: f5          .
	push	h		;; 024e: e5          .
	push	b		;; 024f: c5          .
	in	000h		;; 0250: db 00       ..
	out	04fh		;; 0252: d3 4f       .O
	bit	7,a		;; 0254: cb 7f       ..
	jrnz	L0273		;; 0256: 20 1b        .
	lxi	b,0007h		;; 0258: 01 07 00    ...
	lxi	h,L027c		;; 025b: 21 7c 02    .|.
	ccdr			;; 025e: ed b9       ..
	jrz	L0273		;; 0260: 28 11       (.
	cpi	03ah		;; 0262: fe 3a       .:
	jrnc	L0273		;; 0264: 30 0d       0.
	lxi	h,L027c		;; 0266: 21 7c 02    .|.
	mov	c,a		;; 0269: 4f          O
	dad	b		;; 026a: 09          .
	mov	a,m		;; 026b: 7e          ~
	lxi	h,0ff5bh	;; 026c: 21 5b ff    .[.
	mvi	m,0ffh		;; 026f: 36 ff       6.
	inx	h		;; 0271: 23          #
	mov	m,a		;; 0272: 77          w
L0273:	jmp	L07af		;; 0273: c3 af 07    ...

; lookup table? (L027c--) exceptions?
	db	3ah,45h,38h	;; 0276: 3a 45 38    :E8
	db	1dh		;; 0279: 1d          .
	db	2ah,36h		;; 027a: 2a 36 00    *6.
; Keyboard map?
L027c:	db	0
	db	1bh,'1234567890-=',8,7
	db	'QWERTYUIOP[]',13,0
	db	'ASDFGHJKL;''`',0,'\'
	db	'ZXCVBNM,./',0
	db	'*',0,' '


L02b6:	lxi	h,0ff5bh	;; 02b6: 21 5b ff    .[.
	mov	a,m		;; 02b9: 7e          ~
	ora	a		;; 02ba: b7          .
	jrz	L02b6		;; 02bb: 28 f9       (.
	di			;; 02bd: f3          .
	inr	m		;; 02be: 34          4
	inx	h		;; 02bf: 23          #
L02c0:	mov	a,m		;; 02c0: 7e          ~
	ei			;; 02c1: fb          .
	ret			;; 02c2: c9          .

	push	psw		;; 02c3: f5          .
	in	050h		;; 02c4: db 50       .P
	push	h		;; 02c6: e5          .
	lxi	h,0ff5bh	;; 02c7: 21 5b ff    .[.
	mvi	m,0ffh		;; 02ca: 36 ff       6.
	inx	h		;; 02cc: 23          #
	mov	m,a		;; 02cd: 77          w
	jmp	L07b0		;; 02ce: c3 b0 07    ...

; CON: is CRT
; Place char in C on display... handle CR
L02d1:	mvi	a,00dh	; disp on, validate ram, 80x25
	out	04ah		;; 02d3: d3 4a       .J
	lhld	0ff7fh		;; 02d5: 2a 7f ff    *..
	mov	a,c		;; 02d8: 79          y
	cpi	CR		;; 02d9: fe 0d       ..
	jrz	L02f8		;; 02db: 28 1b       (.
	cpi	' '		;; 02dd: fe 20       . 
	jrc	L02f3		;; 02df: 38 12       8.
	mov	m,a		;; 02e1: 77          w
	inx	h		;; 02e2: 23          #
	inx	h		;; 02e3: 23          #
L02e4:	lxi	d,(79 shl 8)+159	;; 02e4: 11 9f 4f    ..O
	push	h		;; 02e7: e5          .
	dsbc	d		;; 02e8: ed 52       .R
	pop	h		;; 02ea: e1          .
	jnc	L0191		;; 02eb: d2 91 01    ...
L02ee:	mvi	m,'_'	; cursor
	shld	0ff7fh		;; 02f0: 22 7f ff    "..
L02f3:	mvi	a,009h	; disp on, 80x25
	out	04ah		;; 02f5: d3 4a       .J
	ret			;; 02f7: c9          .

; Find start of current (next?) line...
L02f8:	mvi	m,' '		;; 02f8: 36 20       6 
	lxi	d,04000h	;; 02fa: 11 00 40    ..@
	lxi	b,80*2		;; 02fd: 01 a0 00    ...
	xchg			;; 0300: eb          .
L0301:	dad	b		;; 0301: 09          .
	push	h		;; 0302: e5          .
	dsbc	d		;; 0303: ed 52       .R
	pop	h		;; 0305: e1          .
	jrc	L0301		;; 0306: 38 f9       8.
	jr	L02e4		;; 0308: 18 da       ..

; CON: is serial port
L030a:	in	013h		;; 030a: db 13       ..
	ani	004h		;; 030c: e6 04       ..
	jrz	L030a		;; 030e: 28 fa       (.
	mov	a,c		;; 0310: 79          y
	out	011h		;; 0311: d3 11       ..
	ret			;; 0313: c9          .

; Load System
L0314:	call	L01c8		;; 0314: cd c8 01    ...
	db	'\System loading... $'

	lxi	h,L0000		;; 032b: 21 00 00    ...
	shld	0ff69h		;; 032e: 22 69 ff    "i.
	shld	0ff60h		;; 0331: 22 60 ff    "`.
	shld	0ff62h		;; 0334: 22 62 ff    "b.
	mvi	a,001h		;; 0337: 3e 01       >.
	sta	0ff63h		;; 0339: 32 63 ff    2c.
	call	L0434		;; 033c: cd 34 04    .4.
	jnz	L042d		;; 033f: c2 2d 04    .-.
	lxi	h,0006h	; N+1 = 7 bytes to read = boot header
	shld	0ff74h		;; 0345: 22 74 ff    "t.
	lxi	h,0ff78h	;; 0348: 21 78 ff    .x.
	shld	0ff72h		;; 034b: 22 72 ff    "r.
	lda	0ff77h		;; 034e: 3a 77 ff    :w.
	ora	a		;; 0351: b7          .
	mvi	a,006h	; READ DATA
	jz	L0359		;; 0354: ca 59 03    .Y.
	mvi	a,046h	; READ DATA + MFM
L0359:	sta	0ff68h		;; 0359: 32 68 ff    2h.
	call	L05a9		;; 035c: cd a9 05    ...
	jnz	L042d		;; 035f: c2 2d 04    .-.
	lhld	0ff79h		;; 0362: 2a 79 ff    *y.
	shld	0ff72h		;; 0365: 22 72 ff    "r.

; Old boot sector:
; 00000: 7f f9 c7 08 c8 fa 30 
; read into 0ff78h?
;	ff78: 7f = signature?
;	ff79: f9 = 0xc7f9 = load address? C800-7 for header...
;	ff7a: c7
;	ff7b: 08 = 0xc808 = entry?
;	ff7c: c8
;	ff7d: fa = 0x30fa = length of OS???
;	ff7e: 30

	lda	0ff78h		;; 0368: 3a 78 ff    :x.
	cpi	07fh		;; 036b: fe 7f       ..
	jnz	L0408		;; 036d: c2 08 04    ...
	in	001h		;; 0370: db 01       ..
	ani	001h		;; 0372: e6 01       ..
	lda	0ff77h		;; 0374: 3a 77 ff    :w.
	lxi	h,L03e5		;; 0377: 21 e5 03    ...
	jz	L0380		;; 037a: ca 80 03    ...
	lxi	h,L03dd		;; 037d: 21 dd 03    ...
L0380:	rlc			;; 0380: 07          .
	mvi	b,000h		;; 0381: 06 00       ..
	mov	c,a		;; 0383: 4f          O
	dad	b		;; 0384: 09          .
	mov	c,m		;; 0385: 4e          N
	inx	h		;; 0386: 23          #
	mov	h,m		;; 0387: 66          f
	mov	l,c		;; 0388: 69          i
	ora	a		;; 0389: b7          .
	mvi	a,006h		;; 038a: 3e 06       >.
	jz	L0391		;; 038c: ca 91 03    ...
	mvi	a,046h		;; 038f: 3e 46       >F
L0391:	sta	0ff68h		;; 0391: 32 68 ff    2h.
	shld	0ff74h		;; 0394: 22 74 ff    "t.
L0397:	call	L03ef		;; 0397: cd ef 03    ...
	jnc	L03a4		;; 039a: d2 a4 03    ...
	lhld	0ff7dh		;; 039d: 2a 7d ff    *}.
	dcx	h		;; 03a0: 2b          +
	shld	0ff74h		;; 03a1: 22 74 ff    "t.
L03a4:	call	L070f		;; 03a4: cd 0f 07    ...
	call	L05a9		;; 03a7: cd a9 05    ...
	jnz	L042d		;; 03aa: c2 2d 04    .-.
	call	L03ef		;; 03ad: cd ef 03    ...
	jc	L0400		;; 03b0: da 00 04    ...
	jz	L0400		;; 03b3: ca 00 04    ...
	shld	0ff7dh		;; 03b6: 22 7d ff    "}.
	lhld	0ff72h		;; 03b9: 2a 72 ff    *r.
	dad	d		;; 03bc: 19          .
	shld	0ff72h		;; 03bd: 22 72 ff    "r.
	lxi	h,0ff60h	;; 03c0: 21 60 ff    .`.
	lda	0ff77h		;; 03c3: 3a 77 ff    :w.
	cpi	004h		;; 03c6: fe 04       ..
	jnz	L03d8		;; 03c8: c2 d8 03    ...
	xra	m		;; 03cb: ae          .
	mov	m,a		;; 03cc: 77          w
	inx	h		;; 03cd: 23          #
	inx	h		;; 03ce: 23          #
	mov	a,m		;; 03cf: 7e          ~
	xri	001h		;; 03d0: ee 01       ..
	mov	m,a		;; 03d2: 77          w
	dcx	h		;; 03d3: 2b          +
	dcx	h		;; 03d4: 2b          +
	jnz	L0397		;; 03d5: c2 97 03    ...
L03d8:	inx	h		;; 03d8: 23          #
	inr	m		;; 03d9: 34          4
	jmp	L0397		;; 03da: c3 97 03    ...

; Sector/transfer block size? -1?
L03dd:	dw	0cffh,19ffh,1fffh,1fffh
L03e5:	dw	07ffh,0fffh,011ffh,013ffh,011ffh

L03ef:	lhld	0ff74h		;; 03ef: 2a 74 ff    *t.
	inx	h		;; 03f2: 23          #
	xchg			;; 03f3: eb          .
	lhld	0ff7dh		;; 03f4: 2a 7d ff    *}.
	mov	a,l		;; 03f7: 7d          }
	sub	e		;; 03f8: 93          .
	mov	l,a		;; 03f9: 6f          o
	mov	a,h		;; 03fa: 7c          |
	sbb	d		;; 03fb: 9a          .
	mov	h,a		;; 03fc: 67          g
	rnz			;; 03fd: c0          .
	ora	l		;; 03fe: b5          .
	ret			;; 03ff: c9          .

L0400:	di			;; 0400: f3          .
	xra	a		;; 0401: af          .
	out	038h		;; 0402: d3 38       .8
	lhld	0ff7bh		;; 0404: 2a 7b ff    *{.
	pchl			;; 0407: e9          .

L0408:	call	L01c8		;; 0408: cd c8 01    ...
	db	'\WRONG SYSTEM DISK, try another ',21h,'$'
L042d:	call	L01e8		;; 042d: cd e8 01    ...
	ei			;; 0430: fb          .
	jmp	L012b		;; 0431: c3 2b 01    .+.

L0434:	call	L0749		;; 0434: cd 49 07    .I.
	call	L06f3		;; 0437: cd f3 06    ...
	mvi	a,002h		;; 043a: 3e 02       >.
	sta	0ff61h		;; 043c: 32 61 ff    2a.
	xra	a		;; 043f: af          .
	sta	0ff5dh		;; 0440: 32 5d ff    2].
	call	L070f		;; 0443: cd 0f 07    ...
	xra	a		;; 0446: af          .
	call	L04ac		;; 0447: cd ac 04    ...
	call	L072d		;; 044a: cd 2d 07    .-.
	jz	L0492		;; 044d: ca 92 04    ...
	mvi	a,001h		;; 0450: 3e 01       >.
	call	L04ac		;; 0452: cd ac 04    ...
	call	L072d		;; 0455: cd 2d 07    .-.
	jz	L0492		;; 0458: ca 92 04    ...
	mvi	a,002h		;; 045b: 3e 02       >.
	call	L04ac		;; 045d: cd ac 04    ...
	call	L072d		;; 0460: cd 2d 07    .-.
	jz	L0492		;; 0463: ca 92 04    ...
	mvi	a,003h		;; 0466: 3e 03       >.
	call	L04ac		;; 0468: cd ac 04    ...
	call	L072d		;; 046b: cd 2d 07    .-.
	jz	L0492		;; 046e: ca 92 04    ...
	call	L01c8		;; 0471: cd c8 01    ...
	db	'\CANNOT DETERMINE DENSITY$'
	xra	a		;; 048e: af          .
	cma			;; 048f: 2f          /
	ora	a		;; 0490: b7          .
	ret			;; 0491: c9          .

L0492:	lda	0ff6dh		;; 0492: 3a 6d ff    :m.
	sui	002h		;; 0495: d6 02       ..
	sta	0ff5dh		;; 0497: 32 5d ff    2].
	jnz	L06f3		;; 049a: c2 f3 06    ...
	in	001h		;; 049d: db 01       ..
	ani	001h		;; 049f: e6 01       ..
	jnz	L06f3		;; 04a1: c2 f3 06    ...
	mvi	a,004h		;; 04a4: 3e 04       >.
	sta	0ff77h		;; 04a6: 32 77 ff    2w.
	jmp	L06f3		;; 04a9: c3 f3 06    ...

L04ac:	sta	0ff77h		;; 04ac: 32 77 ff    2w.
	in	001h		;; 04af: db 01       ..
	ani	001h		;; 04b1: e6 01       ..
	lda	0ff77h		;; 04b3: 3a 77 ff    :w.
	jz	L04de		;; 04b6: ca de 04    ...
	ora	a		;; 04b9: b7          .
	jz	L04d2		;; 04ba: ca d2 04    ...
	cpi	003h		;; 04bd: fe 03       ..
	lxi	h,L0507		;; 04bf: 21 07 05    ...
	jz	L04d5		;; 04c2: ca d5 04    ...
	rar			;; 04c5: 1f          .
	lxi	h,L04fd		;; 04c6: 21 fd 04    ...
	jc	L04d5		;; 04c9: da d5 04    ...
	lxi	h,L0502		;; 04cc: 21 02 05    ...
	jmp	L04d5		;; 04cf: c3 d5 04    ...

L04d2:	lxi	h,L050c		;; 04d2: 21 0c 05    ...
L04d5:	lxi	d,0ff64h	;; 04d5: 11 64 ff    .d.
	lxi	b,L0005		;; 04d8: 01 05 00    ...
	ldir			;; 04db: ed b0       ..
	ret			;; 04dd: c9          .

L04de:	ora	a		;; 04de: b7          .
	jz	L04f7		;; 04df: ca f7 04    ...
	cpi	003h		;; 04e2: fe 03       ..
	lxi	h,L051b		;; 04e4: 21 1b 05    ...
	jz	L04d5		;; 04e7: ca d5 04    ...
	rar			;; 04ea: 1f          .
	lxi	h,L0511		;; 04eb: 21 11 05    ...
	jc	L04d5		;; 04ee: da d5 04    ...
	lxi	h,L0516		;; 04f1: 21 16 05    ...
	jmp	L04d5		;; 04f4: c3 d5 04    ...

L04f7:	lxi	h,L0520		;; 04f7: 21 20 05    . .
	jmp	L04d5		;; 04fa: c3 d5 04    ...

L04fd:	db	1,1ah,0eh,0ffh,'F'
L0502:	db	2,10h,0eh,0ffh,'F'
L0507:	db	3,8,1bh,0ffh,'F'
L050c:	db	0,1ah,7,80h,6
L0511:	db	1,10h,0ah,0ffh,'F'
L0516:	db	2,9,0ah,0ffh,'F'
L051b:	db	3,5,' ',0ffh,'F'
L0520:	db	0,10h,7,80h
	db	6

L0525:	push	b		;; 0525: c5          .
	mvi	c,0ffh		;; 0526: 0e ff       ..
	push	psw		;; 0528: f5          .
L0529:	in	040h	; wait for not-busy (timeout)
	ani	01fh		;; 052b: e6 1f       ..
	jnz	L054e		;; 052d: c2 4e 05    .N.
	; now ready for command...
	pop	psw		;; 0530: f1          .
	pop	b		;; 0531: c1          .
L0532:	push	b		;; 0532: c5          .
	mvi	c,0ffh		;; 0533: 0e ff       ..
	push	psw		;; 0535: f5          .
L0536:	in	040h	; wait for RQM (timeout)
	ral			;; 0538: 17          .
	jnc	L0563		;; 0539: d2 63 05    .c.
	pop	psw		;; 053c: f1          .
	out	041h	; send command to FDC
	pop	b		;; 053f: c1          .
	ret			;; 0540: c9          .

L0541:	push	b		;; 0541: c5          .
	mvi	c,0ffh		;; 0542: 0e ff       ..
L0544:	in	040h		;; 0544: db 40       .@
	ral			;; 0546: 17          .
	jnc	L056a		;; 0547: d2 6a 05    .j.
	in	041h		;; 054a: db 41       .A
	pop	b		;; 054c: c1          .
	ret			;; 054d: c9          .

L054e:	dcr	c		;; 054e: 0d          .
	jnz	L0529		;; 054f: c2 29 05    .).
L0552:	call	L01c8		;; 0552: cd c8 01    ...
	db	' FDC ERROR$'
	jmp	L042d		;; 0560: c3 2d 04    .-.

L0563:	dcr	c		;; 0563: 0d          .
	jnz	L0536		;; 0564: c2 36 05    .6.
	jmp	L0552		;; 0567: c3 52 05    .R.

L056a:	dcr	c		;; 056a: 0d          .
	jnz	L0544		;; 056b: c2 44 05    .D.
	jmp	L0552		;; 056e: c3 52 05    .R.

L0571:	di			;; 0571: f3          .
	mov	a,m		;; 0572: 7e          ~
	call	L0525		;; 0573: cd 25 05    .%.
L0576:	inx	h		;; 0576: 23          #
	mov	a,m		;; 0577: 7e          ~
	call	L0532		;; 0578: cd 32 05    .2.
	dcr	c		;; 057b: 0d          .
	jnz	L0576		;; 057c: c2 76 05    .v.
	ei			;; 057f: fb          .
	push	d		;; 0580: d5          .
	mvi	c,002h		;; 0581: 0e 02       ..
L0583:	lxi	d,0ffffh	;; 0583: 11 ff ff    ...
L0586:	dcx	d		;; 0586: 1b          .
	mov	a,d		;; 0587: 7a          z
	ora	e		;; 0588: b3          .
	jz	L059c		;; 0589: ca 9c 05    ...
	lxi	h,0ff69h	;; 058c: 21 69 ff    .i.
	mov	a,m		;; 058f: 7e          ~
	ora	a		;; 0590: b7          .
	jz	L0586		;; 0591: ca 86 05    ...
	mvi	m,000h		;; 0594: 36 00       6.
	inx	h		;; 0596: 23          #
	mov	a,m		;; 0597: 7e          ~
	ani	0c0h		;; 0598: e6 c0       ..
	pop	d		;; 059a: d1          .
	ret			;; 059b: c9          .

L059c:	dcr	c		;; 059c: 0d          .
	jnz	L0583		;; 059d: c2 83 05    ...
	call	L0749		;; 05a0: cd 49 07    .I.
	call	L06cc		;; 05a3: cd cc 06    ...
	pop	d		;; 05a6: d1          .
	stc			;; 05a7: 37          7
	ret			;; 05a8: c9          .

; Read data from disk?
L05a9:	lda	0ff68h		;; 05a9: 3a 68 ff    :h.
	mov	h,a		;; 05ac: 67          g
	mvi	l,040h		;; 05ad: 2e 40       .@
	shld	0ff5eh		;; 05af: 22 5e ff    "^.
	mvi	a,020h		;; 05b2: 3e 20       > 
	sta	0ff76h		;; 05b4: 32 76 ff    2v.
L05b7:	lxi	h,0ff5eh	;; 05b7: 21 5e ff    .^.
	mov	a,m		;; 05ba: 7e          ~
	inx	h		;; 05bb: 23          #
	push	h		;; 05bc: e5          .
	push	psw		;; 05bd: f5          .
	lhld	0ff74h		;; 05be: 2a 74 ff    *t.
	mov	a,l		;; 05c1: 7d          }
	out	033h		;; 05c2: d3 33       .3
	pop	psw		;; 05c4: f1          .
	ora	h		;; 05c5: b4          .
	out	033h		;; 05c6: d3 33       .3
	lhld	0ff72h		;; 05c8: 2a 72 ff    *r.
	mov	a,l		;; 05cb: 7d          }
	out	032h		;; 05cc: d3 32       .2
	mov	a,h		;; 05ce: 7c          |
	out	032h		;; 05cf: d3 32       .2
	mvi	a,042h		;; 05d1: 3e 42       >B
	out	038h		;; 05d3: d3 38       .8
	pop	h		;; 05d5: e1          .
	mvi	c,008h		;; 05d6: 0e 08       ..
	call	L0571		;; 05d8: cd 71 05    .q.
	jc	L05b7		;; 05db: da b7 05    ...
	rz			;; 05de: c8          .
	lda	0ff76h		;; 05df: 3a 76 ff    :v.
	dcr	a		;; 05e2: 3d          =
	sta	0ff76h		;; 05e3: 32 76 ff    2v.
	jnz	L05b7		;; 05e6: c2 b7 05    ...
	lxi	h,0ff6bh	;; 05e9: 21 6b ff    .k.
	call	L01c8		;; 05ec: cd c8 01    ...
	db	'\READ $'
	mov	a,m		;; 05f6: 7e          ~
	ani	080h		;; 05f7: e6 80       ..
	jz	L060c		;; 05f9: ca 0c 06    ...
	call	L01c8		;; 05fc: cd c8 01    ...
	db	'end of track$'
L060c:	mov	a,m		;; 060c: 7e          ~
	ani	020h		;; 060d: e6 20       . 
	jz	L0633		;; 060f: ca 33 06    .3.
	inx	h		;; 0612: 23          #
	mov	a,m		;; 0613: 7e          ~
	dcx	h		;; 0614: 2b          +
	ani	020h		;; 0615: e6 20       . 
	jz	L0629		;; 0617: ca 29 06    .).
	call	L01c8		;; 061a: cd c8 01    ...
	db	'data CRC$'
	jmp	L0633		;; 0626: c3 33 06    .3.

L0629:	call	L01c8		;; 0629: cd c8 01    ...
	db	'ID CRC$'
L0633:	mov	a,m		;; 0633: 7e          ~
	ani	004h		;; 0634: e6 04       ..
	jz	L064d		;; 0636: ca 4d 06    .M.
	call	L01c8		;; 0639: cd c8 01    ...
	db	'sector not found$'
L064d:	mov	a,m		;; 064d: 7e          ~
	ani	001h		;; 064e: e6 01       ..
	jz	L067c		;; 0650: ca 7c 06    .|.
	inx	h		;; 0653: 23          #
	mov	a,m		;; 0654: 7e          ~
	ani	001h		;; 0655: e6 01       ..
	jz	L0665		;; 0657: ca 65 06    .e.
	call	L01c8		;; 065a: cd c8 01    ...
	db	'data$'
	jmp	L066b		;; 0662: c3 6b 06    .k.

L0665:	call	L01c8		;; 0665: cd c8 01    ...
	db	'ID$'
L066b:	call	L01c8		;; 066b: cd c8 01    ...
	db	' addr'
	db	'ess mark'
	db	'$'
L067c:	call	L0228		;; 067c: cd 28 02    .(.
	call	L01c8		;; 067f: cd c8 01    ...
	db	'- sector $'
	mvi	h,000h		;; 068c: 26 00       &.
	lda	0ff63h		;; 068e: 3a 63 ff    :c.
	mov	l,a		;; 0691: 6f          o
	call	L06ab		;; 0692: cd ab 06    ...
	call	L01c8		;; 0695: cd c8 01    ...
	db	', track $'
	lda	0ff61h		;; 06a1: 3a 61 ff    :a.
	mov	l,a		;; 06a4: 6f          o
	call	L06ab		;; 06a5: cd ab 06    ...
	xra	a		;; 06a8: af          .
	inr	a		;; 06a9: 3c          <
	ret			;; 06aa: c9          .

L06ab:	push	b		;; 06ab: c5          .
	push	d		;; 06ac: d5          .
	push	h		;; 06ad: e5          .
	lxi	b,0fff6h	;; 06ae: 01 f6 ff    ...
	lxi	d,0ffffh	;; 06b1: 11 ff ff    ...
L06b4:	dad	b		;; 06b4: 09          .
	inx	d		;; 06b5: 13          .
	jc	L06b4		;; 06b6: da b4 06    ...
	lxi	b,L000a		;; 06b9: 01 0a 00    ...
	dad	b		;; 06bc: 09          .
	xchg			;; 06bd: eb          .
	mov	a,h		;; 06be: 7c          |
	ora	l		;; 06bf: b5          .
	cnz	L06ab		;; 06c0: c4 ab 06    ...
	mov	a,e		;; 06c3: 7b          {
	adi	030h		;; 06c4: c6 30       .0
	mov	c,a		;; 06c6: 4f          O
	rst	1		;; 06c7: cf          .
	pop	h		;; 06c8: e1          .
	pop	d		;; 06c9: d1          .
	pop	b		;; 06ca: c1          .
	ret			;; 06cb: c9          .

L06cc:	call	L01c8		;; 06cc: cd c8 01    ...
	db	'dr'
	db	'ive not ready (A-abo'
	db	'rt)\$'
	call	L0234		;; 06ea: cd 34 02    .4.
	cpi	041h		;; 06ed: fe 41       .A
	rnz			;; 06ef: c0          .
	jmp	L012b		;; 06f0: c3 2b 01    .+.

L06f3:	in	001h		;; 06f3: db 01       ..
	ani	001h		;; 06f5: e6 01       ..
	jnz	L06fd		;; 06f7: c2 fd 06    ...
	call	L06fd		;; 06fa: cd fd 06    ...
L06fd:	xra	a		;; 06fd: af          .
	sta	0ff61h		;; 06fe: 32 61 ff    2a.
	lxi	h,0ff5fh	;; 0701: 21 5f ff    ._.
	mvi	m,007h		;; 0704: 36 07       6.
	mvi	c,001h		;; 0706: 0e 01       ..
	call	L0571		;; 0708: cd 71 05    .q.
	jc	L06fd		;; 070b: da fd 06    ...
	ret			;; 070e: c9          .

L070f:	lda	0ff5dh		;; 070f: 3a 5d ff    :].
	ora	a		;; 0712: b7          .
	lxi	d,0ff61h	;; 0713: 11 61 ff    .a.
	ldax	d		;; 0716: 1a          .
	push	psw		;; 0717: f5          .
	jz	L071d		;; 0718: ca 1d 07    ...
	rlc			;; 071b: 07          .
	stax	d		;; 071c: 12          .
L071d:	lxi	h,0ff5fh	;; 071d: 21 5f ff    ._.
	mvi	m,00fh		;; 0720: 36 0f       6.
	mvi	c,002h		;; 0722: 0e 02       ..
	call	L0571		;; 0724: cd 71 05    .q.
	jc	L071d		;; 0727: da 1d 07    ...
	pop	psw		;; 072a: f1          .
	stax	d		;; 072b: 12          .
	ret			;; 072c: c9          .

L072d:	lda	0ff68h		;; 072d: 3a 68 ff    :h.
	ani	040h		;; 0730: e6 40       .@
	ori	00ah		;; 0732: f6 0a       ..
	lxi	h,0ff5fh	;; 0734: 21 5f ff    ._.
	mov	m,a		;; 0737: 77          w
	mvi	c,001h		;; 0738: 0e 01       ..
	call	L0571		;; 073a: cd 71 05    .q.
	jc	L072d		;; 073d: da 2d 07    .-.
	rnz			;; 0740: c0          .
	lda	0ff70h		;; 0741: 3a 70 ff    :p.
	lxi	h,0ff77h	;; 0744: 21 77 ff    .w.
	cmp	m		;; 0747: be          .
	ret			;; 0748: c9          .

; setup FDC/drive
L0749:	xra	a		;; 0749: af          .
	out	048h		;; 074a: d3 48       .H
	in	001h		;; 074c: db 01       ..
	ani	001h	; option... 8" or 5"?
	di			;; 0750: f3          .
	jz	L0769		;; 0751: ca 69 07    .i.
	; 8" drive boot
	mvi	a,020h		;; 0754: 3e 20       > 
	out	048h		;; 0756: d3 48       .H
	mvi	a,003h	; SPECIFY command...
	call	L0525		;; 075a: cd 25 05    .%.
	mvi	a,06fh	; step rate/head load
	call	L0532		;; 075f: cd 32 05    .2.
	mvi	a,02eh	; head load time/non-DMA
L0764:	call	L0532		;; 0764: cd 32 05    .2.
	ei			;; 0767: fb          .
	ret			;; 0768: c9          .

; 5.25" drive boot
L0769:	mvi	a,033h		;; 0769: 3e 33       >3
	out	048h		;; 076b: d3 48       .H
	mvi	a,003h	; SPECIFY command...
	call	L0525		;; 076f: cd 25 05    .%.
	mvi	a,00fh	; step rate/head load
	call	L0532		;; 0774: cd 32 05    .2.
	mvi	a,026h	; head load time/non-DMA
	jmp	L0764		;; 0779: c3 64 07    .d.

L077c:	push	psw		;; 077c: f5          .
	push	h		;; 077d: e5          .
	lxi	h,0ff69h	;; 077e: 21 69 ff    .i.
	in	040h		;; 0781: db 40       .@
	ani	010h		;; 0783: e6 10       ..
	jnz	L07a1		;; 0785: c2 a1 07    ...
	mvi	a,008h		;; 0788: 3e 08       >.
	call	L0532		;; 078a: cd 32 05    .2.
	call	L0541		;; 078d: cd 41 05    .A.
	inx	h		;; 0790: 23          #
	mov	m,a		;; 0791: 77          w
	call	L0541		;; 0792: cd 41 05    .A.
	mov	a,m		;; 0795: 7e          ~
	ani	020h		;; 0796: e6 20       . 
	jz	L07b0		;; 0798: ca b0 07    ...
	dcx	h		;; 079b: 2b          +
	mvi	m,001h		;; 079c: 36 01       6.
	jmp	L07b0		;; 079e: c3 b0 07    ...

L07a1:	mvi	m,001h		;; 07a1: 36 01       6.
	push	b		;; 07a3: c5          .
	mvi	b,007h		;; 07a4: 06 07       ..
L07a6:	inx	h		;; 07a6: 23          #
	call	L0541		;; 07a7: cd 41 05    .A.
	mov	m,a		;; 07aa: 77          w
	dcr	b		;; 07ab: 05          .
	jnz	L07a6		;; 07ac: c2 a6 07    ...
L07af:	pop	b		;; 07af: c1          .
L07b0:	pop	h		;; 07b0: e1          .
L07b1:	pop	psw		;; 07b1: f1          .
	ei			;; 07b2: fb          .
	reti			;; 07b3: ed 4d       .M

	push	psw		;; 07b5: f5          .
	xra	a		;; 07b6: af          .
	out	04ch		;; 07b7: d3 4c       .L
	jmp	L07b1		;; 07b9: c3 b1 07    ...

	db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
	db	0ffh,0ffh,0ffh,0ffh
	db	0b2h,7,0b5h,7,'M',2,'|',7,0c3h,2,0b2h,7
	db	0ffh,0ffh,0ffh,0ffh
L0800:	ds	0
	ds	2
L0802:	ds	0
	ds	273
L0913:	ds	0
	ds	1677
L0fa0:	ds	0
	ds	4192
L2000:	ds	0
	end
