; Disassembly of TPD801.TD0 boot tracks, BIOS image.
VERS	equ	270

	maclib	z80

cpm	equ	0000h
iobyte	equ	0003h
usrdrv	equ	0004h
bdos	equ	0005h
tpa	equ	0100h

; I/O ports
; i8255?
PP_A	equ	0	; RAM bank bits 0-2
PP_B	equ	1	; PC keyboard reset
PP_C	equ	2	; parallel printer config
PP_CTL	equ	3
;
SIO_A	equ	10h
SIO_B	equ	11h
SIO_AC	equ	12h
SIO_BC	equ	13h

CTC1_0	equ	20h	; 307.18KHz
CTC1_1	equ	21h	; CTC1_0 TC (1.2KHz)
CTC1_2	equ	22h	; not used? (L2)
CTC1_3	equ	23h	; vert retrace intr
; corresponds to Jr80 CTC @ 20h?
; at least for FDC intr.
CTC2_0	equ	24h	; not used? (L10)
CTC2_1	equ	25h	; not used? (L11)
CTC2_2	equ	26h	; CTC2_0 TC (1.2KHz)
CTC2_3	equ	27h	; FDC intr
; i8253 - same as Jr80 at 70h?
CTR_0	equ	28h	; baud (9600) @1.2288MHz
CTR_1	equ	29h	; baud (9600) @1.2288MHz
CTR_2	equ	2ah	; sound (951 = 1292Hz) @1.2288MHz
CTR_C	equ	2bh
;
PIO1_A	equ	2ch	; PC keyboard (scan codes)
PIO1_B	equ	2dh	; system config dipswitch
PIO1_AC	equ	2eh
PIO1_BC	equ	2fh
;
DMA_0A	equ	30h	; ch0 addr
DMA_0C	equ	31h	; ch0 count (-1)
DMA_1A	equ	32h	; ch1 addr
DMA_1C	equ	33h	; ch1 count (-1)
DMA_2A	equ	34h	; ch2 addr
DMA_2C	equ	35h	; ch2 count (-1)
DMA_3A	equ	36h	; ch3 addr
DMA_3C	equ	37h	; ch3 count (-1)
DMA_CTL	equ	38h	;

; FDC - same as Jr80?
FDC_STS	equ	40h
FDC_DAT	equ	41h
FDC_CTL	equ	42h	; Jr80 uses 48h
; same as Jr80?
PIO_A	equ	50h	; input - ASCII keyboard
PIO_B	equ	51h	; parallel printer data
PIO_AC	equ	52h
PIO_BC	equ	53h
; similar to Jr80 4a-4f?
CRT_ADR	equ	60h	; for graphics mode - start addr (0)
CRT_CTL	equ	62h
CRT_HUE	equ	63h	; how used?
CRT_ROW	equ	64h	; text mode top row of screen

; DMAC count reg high bits
DMA_RD	equ	80h
DMA_WR	equ	40h
DMA_FDC	equ	0010b	; DMA channel for FDC

; FDC_CTL port bits - same as Jr80
FDC_RST	equ	20h	; /RESET to i8272 (0=RESET)
FDC_5IN	equ	10h	; 5.25" drive type enable
MTR_DS0	equ	01h
MTR_DS1	equ	02h
MTR_DS2	equ	04h
MTR_DS3	equ	08h

; config dipswitch bits
CFG_SER	equ	00000001b	; 1 = serial console
CFG_PCK	equ	00000010b	; 1 = PC keyboard (scan codes)
CFG_RD	equ	00100000b	; 1 = ramdisk
CFG_523	equ	01000000b	; 1 = 5.25" floppy drives DS2/DS3
CFG_501	equ	10000000b	; 1 = 5.25" floppy drives DS0/DS1

PPA_BNK	equ	00000111b	; mask for memory bank select
PPA_SPG	equ	00010000b	; enable speaker clock (SPKGT)
PPA_SPK	equ	00100000b	; enable speaker sound (SPKDT)

PPB_KRS	equ	00000010b	; PC kbd disable (0=disable)

crtram	equ	4000h
ramwin	equ	4000h	; banked RAM window, 32K length
winlen	equ	8000h
winend	equ	ramwin+winlen

NIL	equ	0	; ^@
SOH	equ	1	; ^A
CTLC	equ	3	; ^C
ETX	equ	CTLC
EOT	equ	4	; ^D
ENQ	equ	5	; ^E
ACK	equ	6	; ^F
BEL	equ	7	; ^G
BS	equ	8	; ^H
TAB	equ	9	; ^I
LF	equ	10	; ^J
VT	equ	11	; ^K
FF	equ	12	; ^L
CR	equ	13	; ^M
SO	equ	14	; ^N reverse video
SI	equ	15	; ^O normal video
XON	equ	17	; ^Q
DC1	equ	XON
DC2	equ	18	; ^R
XOFF	equ	19	; ^S
DC3	equ	XOFF
NAK	equ	21	; ^U
SYN	equ	22	; ^V erase EOL
ETB	equ	23	; ^W
CAN	equ	24	; ^X clear screen
EM	equ	25	; ^Y
SUB	equ	26	; ^Z
ESC	equ	27	; ^[
GS	equ	29	; ^]
DEL	equ	127

ccp$pg	equ	0c800h
bdos$pg	equ	0d000h
bios$pg	equ	0de00h
rsx$pg	equ	ccp$pg-0100h ; used for???

bdose	equ	bdos$pg+6
rsxe	equ	rsx$pg+6
ccp$cold	equ	ccp$pg+0
ccp$warm	equ	ccp$pg+3

ccp$cmd		equ	ccp$pg+7
ccp$patt	equ	ccp$pg+0382h
ccp$pate	equ	ccp$pg+0799h
ccp$fill1	equ	ccp$pg+07b8h

bdos$fill1	equ	bdos$pg+030ah

	org	bios$pg

	jmp	cboot		;; de00: c3 c2 de    ...
wboote:	jmp	wboot		;; de03: c3 e3 de    ...
	jmp	const		;; de06: c3 6f e9    .o.
	jmp	conin		;; de09: c3 58 e9    .X.
	jmp	conout		;; de0c: c3 69 e9    .i.
	jmp	lstout		;; de0f: c3 90 e9    ...
	jmp	punout		;; de12: c3 84 e9    ...
	jmp	rdrin		;; de15: c3 75 e9    .u.
	jmp	home		;; de18: c3 96 e1    ...
	jmp	seldsk		;; de1b: c3 69 df    .i.
	jmp	settrk		;; de1e: c3 99 e1    ...
	jmp	setsec		;; de21: c3 9f e1    ...
	jmp	setdma		;; de24: c3 4b e2    .K.
	jmp	read		;; de27: c3 56 e2    .V.
	jmp	write		;; de2a: c3 51 e2    .Q.
	jmp	lstst		;; de2d: c3 91 e5    ...
	jmp	sectrn		;; de30: c3 c3 e1    ...
	; end of standard CP/M BIOS API

	dw	extdat	; 0x33, wboote+48
	; 11-char ID string, 0x35, wboote+50
	db	'Tpd '
	db	((VERS/100) MOD 10)+'0'
	db	'.'
	db	((VERS/10) MOD 10)+'0'	; wboote+56
	db	'/'
	db	(VERS MOD 10)+'1'
	db	' '	; wboote+59, indicates 8/5 config?
	db	'A'	; wboote+60, indicates 35/40 track?
	; floppy motor timers
	dw	fdcmtr	; 0x40, wboote+61

	; 0x42, wboote+63
	jmp	fdsens		; FDC SENSE command, C=drive
	jmp	ticset		; setup tick hook
	jmp	rdrst		; RDR: input status
	jmp	grphcs		; graphics routine - set/clear/get pixel
Lde4e:	jmp	nulfnc		;; de4e: c3 68 df    .h.
Lde51:	jmp	Leee7		; CRT mode 20h
	jmp	uc1out		; UC1: output
	jmp	uc1in		; UC1: input
	jmp	uc1st		; UC1: input status
	jmp	nulfnc		;; de5d: c3 68 df    .h.
	jmp	extfnc		; extended functions, B=func, C=sub-fnc
	jmp	nulfnc		;; de63: c3 68 df    .h.
	jmp	nulfnc		;; de66: c3 68 df    .h.
	jmp	nulfnc		;; de69: c3 68 df    .h.
	jmp	ticfin		;; de6c: c3 46 ea    .F.

	; 0x6f, wboote+108
Lde6f:	db	0	; FDC_CTL port image

; interrupt vectors - 0x70, wboote+109 - use pointer below
Lde70:	dw	nulint	; chB TxE
	dw	bxtint	; chB Ext/sts change
	dw	brxint	; chB RxA
	dw	bspint	; chB Rx spc
	dw	nulint	; chA TxE
	dw	axtint	; chA Ext/sts change
	dw	arxint	; chA RxA
	dw	aspint	; chA Rx spc
	dw	nulint	; xx80 - CTC1 ch0 - prescale for ch1
	dw	tick	; xx82 - CTC1 ch1 - general timeout?
	dw	nulint	; xx84 - CTC1 ch2
Lde86:	dw	Lf0da	; xx86 - CTC1 ch3 - video? ("NVIMT")
	dw	nulint	; xx88 - CTC2 ch0
	dw	nulint	; xx8a - CTC2 ch1
	dw	nulint	; xx8c - CTC2 ch2
	dw	fdcint	; xx8e - CTC2 ch3 FDC
	dw	pckbint	; xx90 - PIO1 chA - PC keyboard (scan codes)
	dw	nulint	; xx92
	dw	akbint	; xx94 - PIO chA - ASCII keyboard
	dw	lptint	; xx96 - PIO chB - LPT: ready (intr)

; extended data pointers - 0x98, wboote+149
extdat:	dw	Le920	; CON: input redir vectors
	dw	Le928	; CON: output redir vectors
	dw	Le948	; CON: input status redir
	dw	Le930	; RDR: input redir vectors
	dw	Le938	; PUN: output redir vectors
	dw	Le940	; LST: output redir vectors
	dw	tichook	; tick hook structure - 0xa4, wboote+161
	dw	Xfd1e	; external access to SIO data?
Ldea8:	dw	rsxe	; RSX?
	dw	Lde70	; interrupt vectors
	dw	nulfnc
	dw	Le950	; RDR: input status redir
	dw	whooks	; warm boot hooks - 0xb0, wboote+173
	dw	crtstr+12 ; ptr to CRT RAM curr page - 0xb2, wboote+175
	dw	0
	dw	0
	dw	Lf508	; hook 2 data? two words...
	dw	VERS	; version? 0xba, wboote+183
	dw	0,0,0

cboot:	lda	defiob		;; dec2: 3a 3b fd    :;.
	sta	iobyte		;; dec5: 32 03 00    2..
	xra	a		;; dec8: af          .
	sta	usrdrv		;; dec9: 32 04 00    2..
	jmp	wboot		;; decc: c3 e3 de    ...

Ldecf:	lxi	h,ccp$pg	;; decf: 21 00 c8    ...
	shld	Ldf61+1		;; ded2: 22 62 df    "b.
	lxi	h,Lf8e9		;; ded5: 21 e9 f8    ...
	lxi	d,ccp$cmd	;; ded8: 11 07 c8    ...
	lxi	b,9		;; dedb: 01 09 00    ...
	ldir			;; dede: ed b0       ..
	jmp	ccp$cold	;; dee0: c3 00 c8    ...

wboot:	lxi	sp,tpa		;; dee3: 31 00 01    1..
	xra	a		;; dee6: af          .
	; since CCP not reloaded, reset it
	lxi	d,ccp$cmd	;; dee7: 11 07 c8    ...
	mvi	c,129		;; deea: 0e 81       ..
	call	fill		;; deec: cd ce f5    ...
	lxi	h,ccp$patt	;; deef: 21 82 cb    ...
	shld	ccp$pate	;; def2: 22 99 cf    "..
	lxi	d,ccp$fill1	;; def5: 11 b8 cf    ...
	mvi	c,72		;; def8: 0e 48       .H
	call	fill		;; defa: cd ce f5    ...
	lxi	d,bdos$fill1	;; defd: 11 0a d3    ...
	mvi	c,61		;; df00: 0e 3d       .=
	call	fill		;; df02: cd ce f5    ...
	;
	cma	; 0ffh
	sta	curdsk		;; df06: 32 e0 fc    2..
	di			;; df09: f3          .
	mvi	a,0c3h		;; df0a: 3e c3       >.
	sta	cpm		;; df0c: 32 00 00    2..
	lxi	h,wboote	;; df0f: 21 03 de    ...
	shld	cpm+1		;; df12: 22 01 00    "..
	sta	bdos		;; df15: 32 05 00    2..
	; this stub prevents CCP from being overwritten...
	lhld	Ldea8		;; df18: 2a a8 de    *..
	shld	bdos+1		;; df1b: 22 06 00    "..
	mvi	m,0c3h		;; df1e: 36 c3       6.
	inx	h		;; df20: 23          #
	mvi	m,LOW bdose	;; df21: 36 06       6.
	inx	h		;; df23: 23          #
	mvi	m,HIGH bdose	;; df24: 36 d0       6.
	;
	lxi	h,Lfdf2		;; df26: 21 f2 fd    ...
	shld	ardptr		;; df29: 22 16 fd    "..
	shld	awrptr		;; df2c: 22 14 fd    "..
	lxi	h,Lfe72		;; df2f: 21 72 fe    .r.
	shld	brdptr		;; df32: 22 1b fd    "..
	shld	bwrptr		;; df35: 22 19 fd    "..
	xra	a		;; df38: af          .
	sta	affcnt		;; df39: 32 18 fd    2..
	sta	bffcnt		;; df3c: 32 1d fd    2..
	lda	ffoflg		;; df3f: 3a 13 fd    :..
	ani	022h		;; df42: e6 22       ."
	sta	ffoflg		;; df44: 32 13 fd    2..
	; call all wboot hooks...
	lxi	h,whooks	;; df47: 21 2a fd    .*.
	mov	a,m		;; df4a: 7e          ~
	inx	h		;; df4b: 23          #
Ldf4c:	stc			;; df4c: 37          7
	cmc			;; df4d: 3f          ?
	rar			;; df4e: 1f          .
	push	psw		;; df4f: f5          .
	push	h		;; df50: e5          .
	cc	icall		;; df51: dc 64 df    .d.
	pop	h		;; df54: e1          .
	pop	psw		;; df55: f1          .
	inx	h		;; df56: 23          #
	inx	h		;; df57: 23          #
	ora	a		;; df58: b7          .
	jnz	Ldf4c		;; df59: c2 4c df    .L.
	;
	lda	usrdrv		;; df5c: 3a 04 00    :..
	mov	c,a		;; df5f: 4f          O
	ei			;; df60: fb          .
Ldf61:	jmp	Ldecf		;; df61: c3 cf de    ...

; indirect call to (HL)
icall:	mov	e,m		;; df64: 5e          ^
	inx	h		;; df65: 23          #
	mov	d,m		;; df66: 56          V
	push	d		;; df67: d5          .
nulfnc:	ret			;; df68: c9          .

seldsk:	mov	a,c		;; df69: 79          y
Ldf6a:	cpi	005h	; 4 or 5 depending on ramdisk
	lxi	h,0		;; df6c: 21 00 00    ...
	jc	Ldf77		;; df6f: da 77 df    .w.
	xra	a		;; df72: af          .
	sta	usrdrv		;; df73: 32 04 00    2..
	ret			;; df76: c9          .

Ldf77:	sspd	savstk		;; df77: ed 73 6e fd .sn.
	lxi	sp,biostk	;; df7b: 31 6e fd    1n.
	call	Ldf86		;; df7e: cd 86 df    ...
	lspd	savstk		;; df81: ed 7b 6e fd .{n.
	ret			;; df85: c9          .

Ldf86:	cpi	004h		;; df86: fe 04       ..
	jz	Ldf9d	; ramdisk
	mov	b,e		;; df8b: 43          C
	push	b		;; df8c: c5          .
	push	h		;; df8d: e5          .
	call	Le3f5		;; df8e: cd f5 e3    ...
	pop	h		;; df91: e1          .
	pop	b		;; df92: c1          .
	mov	a,c		;; df93: 79          y
	sta	Lfcd8		;; df94: 32 d8 fc    2..
	push	b		;; df97: c5          .
	call	Ldfe9		;; df98: cd e9 df    ...
	pop	b		;; df9b: c1          .
	mov	a,c		;; df9c: 79          y
Ldf9d:	lxi	d,dphtbl	;; df9d: 11 7a e7    .z.
	add	a		;; dfa0: 87          .
	add	a		;; dfa1: 87          .
	add	a		;; dfa2: 87          .
	add	a		;; dfa3: 87          .
	add	c		;; dfa4: 81          .
	mov	l,a		;; dfa5: 6f          o
	mvi	h,0		;; dfa6: 26 00       &.
	dad	d		;; dfa8: 19          .
	shld	curdph		;; dfa9: 22 d9 fc    "..
	lxi	d,16		;; dfac: 11 10 00    ...
	dad	d		;; dfaf: 19          .
	mvi	a,004h		;; dfb0: 3e 04       >.
	cmp	c		;; dfb2: b9          .
	jz	Ldfde		;; dfb3: ca de df    ...
	mov	a,b		;; dfb6: 78          x
	rrc			;; dfb7: 0f          .
	jc	Ldfbd		;; dfb8: da bd df    ...
	mvi	m,0ffh		;; dfbb: 36 ff       6.
Ldfbd:	mov	a,m		;; dfbd: 7e          ~
	sta	Lfcdb		;; dfbe: 32 db fc    2..
	call	Le080		;; dfc1: cd 80 e0    ...
	lhld	curdph		;; dfc4: 2a d9 fc    *..
	lda	Lfd09		;; dfc7: 3a 09 fd    :..
	ora	a		;; dfca: b7          .
	jz	Ldfd9		;; dfcb: ca d9 df    ...
	lda	curdsk		;; dfce: 3a e0 fc    :..
	cpi	004h		;; dfd1: fe 04       ..
	mvi	a,1		;; dfd3: 3e 01       >.
	jnz	Ldfd9		;; dfd5: c2 d9 df    ...
	xra	a		;; dfd8: af          .
Ldfd9:	sta	Lfd0b		;; dfd9: 32 0b fd    2..
	ora	a		;; dfdc: b7          .
	ret			;; dfdd: c9          .

Ldfde:	mov	a,m		;; dfde: 7e          ~
	sta	curdsk		;; dfdf: 32 e0 fc    2..
	sta	Lfcdb		;; dfe2: 32 db fc    2..
	lhld	curdph		;; dfe5: 2a d9 fc    *..
	ret			;; dfe8: c9          .

Ldfe9:	lda	Lfcfd		;; dfe9: 3a fd fc    :..
	xra	c		;; dfec: a9          .
	ani	002h		;; dfed: e6 02       ..
	mov	a,c		;; dfef: 79          y
	sta	Lfcfd		;; dff0: 32 fd fc    2..
	rz			;; dff3: c8          .
	ani	002h		;; dff4: e6 02       ..
	mvi	b,CFG_501	;; dff6: 06 80       ..
	jz	Ldffd		;; dff8: ca fd df    ...
	mvi	b,CFG_523	;; dffb: 06 40       .@
Ldffd:	in	PIO1_B		;; dffd: db 2d       .-
	ana	b	; test drive type
	jz	Le006		;; e000: ca 06 e0    ...
	jmp	Le03a		;; e003: c3 3a e0    .:.

; setup 8" drives
Le006:	lxi	h,fd8fm0	;; e006: 21 e7 e7    ...
	shld	Le0b9+1		;; e009: 22 ba e0    "..
	lxi	h,fd8fm1	;; e00c: 21 cf e7    ...
	shld	Le0ca+1		;; e00f: 22 cb e0    "..
	lxi	h,fd8fm2	;; e012: 21 d7 e7    ...
	shld	Le0d1+1		;; e015: 22 d2 e0    "..
	lxi	h,fd8fm3	;; e018: 21 df e7    ...
	shld	Le0c2+1		;; e01b: 22 c3 e0    "..
	xra	a		;; e01e: af          .
	sta	Lfd09	; set 8" drives
	mvi	b,FDC_RST	; release i8272 RESET, 8" drives
	call	Le06f		;; e024: cd 6f e0    .o.
	di			;; e027: f3          .
	mvi	b,003h	; SPECIFY command
	call	fdcbeg		;; e02a: cd 28 e7    .(.
	mvi	b,06fh	; SRT=6, HUT=15
	call	fdcout		;; e02f: cd 2f e7    ./.
	mvi	b,02eh	; HLT=23, ND=0 (DMA on?)
	call	fdcout		;; e034: cd 2f e7    ./.
	jmp	Le6a7		;; e037: c3 a7 e6    ...

; setup 5.25" drives
Le03a:	lxi	h,fd5fm0	;; e03a: 21 7c e8    .|.
	shld	Le0b9+1		;; e03d: 22 ba e0    "..
	lxi	h,fd5fm1	;; e040: 21 64 e8    .d.
	shld	Le0ca+1		;; e043: 22 cb e0    "..
	lxi	h,fd5fm2	;; e046: 21 6c e8    .l.
	shld	Le0d1+1		;; e049: 22 d2 e0    "..
	lxi	h,fd5fm3	;; e04c: 21 74 e8    .t.
	shld	Le0c2+1		;; e04f: 22 c3 e0    "..
	mvi	a,001h		;; e052: 3e 01       >.
	sta	Lfd09	; set 5.25" drives
	mvi	b,FDC_RST+FDC_5IN ; release i8272 RESET, 5.25" drives
	call	Le06f		;; e059: cd 6f e0    .o.
	di			;; e05c: f3          .
	mvi	b,003h	; SPECIFY command
	call	fdcbeg		;; e05f: cd 28 e7    .(.
	mvi	b,0cfh	; SRT=12, HUT=15
	call	fdcout		;; e064: cd 2f e7    ./.
	mvi	b,002h	; HLT=1, ND=0 (DMA on?)
	call	fdcout		;; e069: cd 2f e7    ./.
	jmp	Le6a7		;; e06c: c3 a7 e6    ...

; modify FDC_CTL RESET, 8/5 drives
; B=bits to replace
Le06f:	lda	Lde6f		;; e06f: 3a 6f de    :o.
	ani	NOT (FDC_RST+FDC_5IN)	;; e072: e6 cf       ..
	out	FDC_CTL		;; e074: d3 42       .B
	nop			;; e076: 00          .
	nop			;; e077: 00          .
	nop			;; e078: 00          .
	ora	b		;; e079: b0          .
	sta	Lde6f		;; e07a: 32 6f de    2o.
	out	FDC_CTL		;; e07d: d3 42       .B
	ret			;; e07f: c9          .

Le080:	lda	Lfcd8		;; e080: 3a d8 fc    :..
	mov	e,a		;; e083: 5f          _
	mvi	d,000h		;; e084: 16 00       ..
	lda	fdcbuf		;; e086: 3a fe fc    :..
	ani	003h	; old DS1/DS0
	cmp	e		;; e08b: bb          .
	jz	Le0a6		;; e08c: ca a6 e0    ...
	; different drive - do select
	push	d		;; e08f: d5          .
	lxi	h,savtrk	;; e090: 21 f8 fc    ...
	mov	e,a		;; e093: 5f          _
	dad	d		;; e094: 19          .
	lda	fdcbuf+1	;; e095: 3a ff fc    :..
	mov	m,a	; save old drive track num
	lxi	h,savtrk	;; e099: 21 f8 fc    ...
	pop	d		;; e09c: d1          .
	dad	d		;; e09d: 19          .
	mov	a,m	; restore new drive track num
	sta	fdcbuf+1	;; e09f: 32 ff fc    2..
	mov	a,e		;; e0a2: 7b          {
	sta	fdcbuf	; new DS1/DS0 value
Le0a6:	lda	Lfcdb		;; e0a6: 3a db fc    :..
	cpi	0ffh		;; e0a9: fe ff       ..
	jz	Le0f0		;; e0ab: ca f0 e0    ...
Le0ae:	lxi	h,curdsk	;; e0ae: 21 e0 fc    ...
	cmp	m		;; e0b1: be          .
	jz	Le0e0		;; e0b2: ca e0 e0    ...
	mov	m,a		;; e0b5: 77          w
Le0b6:	lxi	d,fdcbuf+4	;; e0b6: 11 02 fd    ...
Le0b9:	lxi	h,fd8fm0	; replaced with current format
	mvi	b,006h		;; e0bc: 06 06       ..
	ora	a		;; e0be: b7          .
	jz	Le0d4		;; e0bf: ca d4 e0    ...
Le0c2:	lxi	h,fd8fm3	;; e0c2: 21 df e7    ...
	cpi	003h		;; e0c5: fe 03       ..
	jz	Le0d4		;; e0c7: ca d4 e0    ...
Le0ca:	lxi	h,fd8fm1	;; e0ca: 21 cf e7    ...
	rar			;; e0cd: 1f          .
	jc	Le0d4		;; e0ce: da d4 e0    ...
Le0d1:	lxi	h,fd8fm2	;; e0d1: 21 d7 e7    ...
Le0d4:	mov	a,m		;; e0d4: 7e          ~
	stax	d		;; e0d5: 12          .
	inx	h		;; e0d6: 23          #
	inx	d		;; e0d7: 13          .
	dcr	b		;; e0d8: 05          .
	jnz	Le0d4		;; e0d9: c2 d4 e0    ...
	shld	Lfcdc		;; e0dc: 22 dc fc    "..
	ret			;; e0df: c9          .

Le0e0:	lda	Lfd0a		;; e0e0: 3a 0a fd    :..
	mov	e,a		;; e0e3: 5f          _
	lda	Lfd09		;; e0e4: 3a 09 fd    :..
	sta	Lfd0a		;; e0e7: 32 0a fd    2..
	xra	e		;; e0ea: ab          .
	mov	a,m		;; e0eb: 7e          ~
	rz			;; e0ec: c8          .
	jmp	Le0b6		;; e0ed: c3 b6 e0    ...

Le0f0:	xra	a		;; e0f0: af          .
	sta	curtrk		;; e0f1: 32 de fc    2..
	sta	Lfd0b		;; e0f4: 32 0b fd    2..
	call	Le6a7		;; e0f7: cd a7 e6    ...
	call	Le742		;; e0fa: cd 42 e7    .B.
Le0fd:	lxi	b,00002h	;; e0fd: 01 02 00    ...
	call	settrk		;; e100: cd 99 e1    ...
	call	Le6bc		;; e103: cd bc e6    ...
	xra	a		;; e106: af          .
	call	Le0ae		;; e107: cd ae e0    ...
	call	Le17d	; read ID off nearest sector
	jz	Le138		;; e10d: ca 38 e1    .8.
	mvi	a,002h		;; e110: 3e 02       >.
	call	Le0ae		;; e112: cd ae e0    ...
	call	Le17d		;; e115: cd 7d e1    .}.
	jz	Le138		;; e118: ca 38 e1    .8.
	mvi	a,001h		;; e11b: 3e 01       >.
	call	Le0ae		;; e11d: cd ae e0    ...
	call	Le17d		;; e120: cd 7d e1    .}.
	jz	Le138		;; e123: ca 38 e1    .8.
	mvi	a,003h		;; e126: 3e 03       >.
	call	Le0ae		;; e128: cd ae e0    ...
	call	Le17d		;; e12b: cd 7d e1    .}.
	jz	Le138		;; e12e: ca 38 e1    .8.
	lxi	h,0		;; e131: 21 00 00    ...
	shld	curdph		;; e134: 22 d9 fc    "..
	ret			;; e137: c9          .

Le138:	xra	a		;; e138: af          .
	sta	curtrk		;; e139: 32 de fc    2..
	call	Le6a7		;; e13c: cd a7 e6    ...
	lhld	curdph		;; e13f: 2a d9 fc    *..
	lxi	d,10		;; e142: 11 0a 00    ...
	dad	d		;; e145: 19          .
	xchg			;; e146: eb          .
	lhld	Lfcdc		;; e147: 2a dc fc    *..
	mov	a,m		;; e14a: 7e          ~
	stax	d		;; e14b: 12          .
	mov	c,a		;; e14c: 4f          O
	inx	h		;; e14d: 23          #
	inx	d		;; e14e: 13          .
	mov	a,m		;; e14f: 7e          ~
	stax	d		;; e150: 12          .
	mov	b,a		;; e151: 47          G
	ldax	b	; DPB.SPT
	cpi	36	; dpb5m2?
	jnz	Le171		;; e155: c2 71 e1    .q.
	; check for 80-track drive...
	lda	fdcres+4	; C (track) number?
	ora	a		;; e15b: b7          .
	jz	Le0fd		;; e15c: ca fd e0    ...
	sui	002h		;; e15f: d6 02       ..
	jnz	Le171		;; e161: c2 71 e1    .q.
	; special handling for dpb5m2... DT...
	mov	l,e		;; e164: 6b          k
	mov	h,d		;; e165: 62          b
	lxi	b,dpb5mZ	;; e166: 01 a2 e8    ...
	mov	m,b		;; e169: 70          p
	dcx	h		;; e16a: 2b          +
	mov	m,c		;; e16b: 71          q
	mvi	a,004h		;; e16c: 3e 04       >.
	sta	curdsk		;; e16e: 32 e0 fc    2..
Le171:	lxi	h,00005h	;; e171: 21 05 00    ...
	dad	d		;; e174: 19          .
	lda	curdsk		;; e175: 3a e0 fc    :..
	mov	m,a		;; e178: 77          w
	sta	Lfcdb		;; e179: 32 db fc    2..
	ret			;; e17c: c9          .

Le17d:	lda	Lfd07		;; e17d: 3a 07 fd    :..
	ani	040h		;; e180: e6 40       .@
	ori	00ah	; READ ID command + MFM
	mov	b,a		;; e184: 47          G
	mvi	c,1		;; e185: 0e 01       ..
	call	fdccmd		;; e187: cd e1 e6    ...
	jc	Le17d		;; e18a: da 7d e1    .}.
	rnz			;; e18d: c0          .
	lxi	h,fdcres+7	;; e18e: 21 f7 fc    ...
	lda	curdsk		;; e191: 3a e0 fc    :..
	cmp	m		;; e194: be          .
	ret			;; e195: c9          .

home:	lxi	b,0		;; e196: 01 00 00    ...
settrk:	mov	h,b		;; e199: 60          `
	mov	l,c		;; e19a: 69          i
	shld	curtrk		;; e19b: 22 de fc    "..
	ret			;; e19e: c9          .

setsec:	mov	a,c		;; e19f: 79          y
	sta	cursec		;; e1a0: 32 e1 fc    2..
	lda	Lfd09		;; e1a3: 3a 09 fd    :..
	ora	a		;; e1a6: b7          .
	jz	Le1bd		;; e1a7: ca bd e1    ...
	lda	Lfd0b		;; e1aa: 3a 0b fd    :..
	ora	a		;; e1ad: b7          .
	mvi	a,000h		;; e1ae: 3e 00       >.
	jnz	Le1bd		;; e1b0: c2 bd e1    ...
	mov	a,c		;; e1b3: 79          y
	cpi	36		;; e1b4: fe 24       .$
	mvi	a,0		;; e1b6: 3e 00       >.
	jc	Le1bd		;; e1b8: da bd e1    ...
	mvi	a,1		;; e1bb: 3e 01       >.
Le1bd:	sta	cursid		;; e1bd: 32 0c fd    2..
	mov	a,c		;; e1c0: 79          y
	ora	a		;; e1c1: b7          .
	ret			;; e1c2: c9          .

sectrn:	mov	a,c		;; e1c3: 79          y
	sta	Lfce2		;; e1c4: 32 e2 fc    2..
	lda	curdsk		;; e1c7: 3a e0 fc    :..
	ora	a		;; e1ca: b7          .
	jz	Le1e1		;; e1cb: ca e1 e1    ...
	dcr	a		;; e1ce: 3d          =
	jz	Le204		;; e1cf: ca 04 e2    ...
	dcr	a		;; e1d2: 3d          =
	jz	Le1e6		;; e1d3: ca e6 e1    ...
	dcr	a		;; e1d6: 3d          =
	jz	Le1de		;; e1d7: ca de e1    ...
	dcr	a		;; e1da: 3d          =
	jz	Le230		;; e1db: ca 30 e2    .0.
Le1de:	mov	l,c		;; e1de: 69          i
	mov	a,c		;; e1df: 79          y
	ret			;; e1e0: c9          .

Le1e1:	xchg			;; e1e1: eb          .
	dad	b		;; e1e2: 09          .
	mov	l,m		;; e1e3: 6e          n
	mov	a,l		;; e1e4: 7d          }
	ret			;; e1e5: c9          .

Le1e6:	lda	Lfd09		;; e1e6: 3a 09 fd    :..
	ora	a		;; e1e9: b7          .
	lxi	h,trn5m2	;; e1ea: 21 df e8    ...
	jnz	Le1f3		;; e1ed: c2 f3 e1    ...
	lxi	h,trn8m2	;; e1f0: 21 45 e8    .E.
Le1f3:	mov	a,c		;; e1f3: 79          y
	push	psw		;; e1f4: f5          .
	rar			;; e1f5: 1f          .
	ora	a		;; e1f6: b7          .
	rar			;; e1f7: 1f          .
	mov	c,a		;; e1f8: 4f          O
	dad	b		;; e1f9: 09          .
	mov	a,m		;; e1fa: 7e          ~
	rlc			;; e1fb: 07          .
	rlc			;; e1fc: 07          .
	mov	c,a		;; e1fd: 4f          O
	pop	psw		;; e1fe: f1          .
	ani	003h		;; e1ff: e6 03       ..
	ora	c		;; e201: b1          .
	mov	l,a		;; e202: 6f          o
	ret			;; e203: c9          .

Le204:	lda	Lfd09		;; e204: 3a 09 fd    :..
	ora	a		;; e207: b7          .
	mvi	e,01ah		;; e208: 1e 1a       ..
	mvi	d,009h		;; e20a: 16 09       ..
	mvi	b,000h		;; e20c: 06 00       ..
	jz	Le217		;; e20e: ca 17 e2    ...
	mvi	e,010h		;; e211: 1e 10       ..
	mvi	d,008h		;; e213: 16 08       ..
	mvi	b,001h		;; e215: 06 01       ..
Le217:	mov	a,c		;; e217: 79          y
	rar			;; e218: 1f          .
	push	psw		;; e219: f5          .
	mov	c,a		;; e21a: 4f          O
	xra	a		;; e21b: af          .
Le21c:	dcr	c		;; e21c: 0d          .
	jm	Le22a		;; e21d: fa 2a e2    .*.
	add	d		;; e220: 82          .
	cmp	e		;; e221: bb          .
	jc	Le21c		;; e222: da 1c e2    ...
	sub	e		;; e225: 93          .
	add	b		;; e226: 80          .
	jmp	Le21c		;; e227: c3 1c e2    ...

Le22a:	mov	c,a		;; e22a: 4f          O
	pop	psw		;; e22b: f1          .
	mov	a,c		;; e22c: 79          y
	ral			;; e22d: 17          .
	mov	l,a		;; e22e: 6f          o
	ret			;; e22f: c9          .

Le230:	mov	a,c		;; e230: 79          y
	ani	0fch		;; e231: e6 fc       ..
	mvi	e,024h		;; e233: 1e 24       .$
	cmp	e		;; e235: bb          .
	mvi	b,000h		;; e236: 06 00       ..
	jc	Le23d		;; e238: da 3d e2    .=.
	sub	e		;; e23b: 93          .
	mov	b,e		;; e23c: 43          C
Le23d:	rlc			;; e23d: 07          .
	cmp	e		;; e23e: bb          .
	jc	Le243		;; e23f: da 43 e2    .C.
	sub	e		;; e242: 93          .
Le243:	add	b		;; e243: 80          .
	mov	l,a		;; e244: 6f          o
	mov	a,c		;; e245: 79          y
	ani	003h		;; e246: e6 03       ..
	ora	l		;; e248: b5          .
	mov	l,a		;; e249: 6f          o
	ret			;; e24a: c9          .

setdma:	mov	h,b		;; e24b: 60          `
	mov	l,c		;; e24c: 69          i
	shld	dmaadr		;; e24d: 22 e3 fc    "..
	ret			;; e250: c9          .

write:	mvi	a,1		;; e251: 3e 01       >.
	jmp	Le259		;; e253: c3 59 e2    .Y.

read:	xra	a		;; e256: af          .
	mvi	c,0		;; e257: 0e 00       ..
Le259:	sspd	savstk		;; e259: ed 73 6e fd .sn.
	lxi	sp,biostk	;; e25d: 31 6e fd    1n.
	call	Le268		;; e260: cd 68 e2    .h.
	lspd	savstk		;; e263: ed 7b 6e fd .{n.
	ret			;; e267: c9          .

Le268:	sta	wrflg		;; e268: 32 e5 fc    2..
	mov	a,c		;; e26b: 79          y
	sta	Lfce6		;; e26c: 32 e6 fc    2..
	lda	Lfcdb		;; e26f: 3a db fc    :..
	cpi	010h		;; e272: fe 10       ..
	jz	Le596		;; e274: ca 96 e5    ...
	ora	a		;; e277: b7          .
	jnz	Le2a0		;; e278: c2 a0 e2    ...
	call	Le3f5		;; e27b: cd f5 e3    ...
	call	Le61d		;; e27e: cd 1d e6    ...
	call	Le6bc		;; e281: cd bc e6    ...
	lxi	h,127		;; e284: 21 7f 00    ...
	shld	Lfce7		;; e287: 22 e7 fc    "..
	lda	cursec		;; e28a: 3a e1 fc    :..
	sta	fdcbuf+3	;; e28d: 32 01 fd    2..
	lda	cursid		;; e290: 3a 0c fd    :..
	sta	fdcbuf+2	;; e293: 32 00 fd    2..
	lda	wrflg		;; e296: 3a e5 fc    :..
	ora	a		;; e299: b7          .
	jz	Le43c		;; e29a: ca 3c e4    .<.
	jmp	Le431		;; e29d: c3 31 e4    .1.

Le2a0:	lxi	h,003ffh	;; e2a0: 21 ff 03    ...
	cpi	003h		;; e2a3: fe 03       ..
	jz	Le2b2		;; e2a5: ca b2 e2    ...
	lxi	h,000ffh	;; e2a8: 21 ff 00    ...
	rar			;; e2ab: 1f          .
	jc	Le2b2		;; e2ac: da b2 e2    ...
	lxi	h,001ffh	;; e2af: 21 ff 01    ...
Le2b2:	shld	Lfce7		;; e2b2: 22 e7 fc    "..
	lda	wrflg		;; e2b5: 3a e5 fc    :..
	ora	a		;; e2b8: b7          .
	jz	Le338		;; e2b9: ca 38 e3    .8.
	lda	Lfce6		;; e2bc: 3a e6 fc    :..
	cpi	002h		;; e2bf: fe 02       ..
	jnz	Le2e1		;; e2c1: c2 e1 e2    ...
	call	getdpb		;; e2c4: cd 2c e3    .,.
	inx	h		;; e2c7: 23          #
	inx	h		;; e2c8: 23          #
	inx	h		;; e2c9: 23          #
	mov	a,m		;; e2ca: 7e          ~
	inr	a		;; e2cb: 3c          <
	sta	curblm		;; e2cc: 32 e9 fc    2..
	lda	Lfcd8		;; e2cf: 3a d8 fc    :..
	sta	Lfcea		;; e2d2: 32 ea fc    2..
	lhld	curtrk		;; e2d5: 2a de fc    *..
	shld	Lfceb		;; e2d8: 22 eb fc    "..
	lda	Lfce2		;; e2db: 3a e2 fc    :..
	sta	Lfced		;; e2de: 32 ed fc    2..
Le2e1:	lda	curblm		;; e2e1: 3a e9 fc    :..
	ora	a		;; e2e4: b7          .
	jz	Le338		;; e2e5: ca 38 e3    .8.
	dcr	a		;; e2e8: 3d          =
	sta	curblm		;; e2e9: 32 e9 fc    2..
	lda	Lfcd8		;; e2ec: 3a d8 fc    :..
	lxi	h,Lfcea		;; e2ef: 21 ea fc    ...
	cmp	m		;; e2f2: be          .
	jnz	Le338		;; e2f3: c2 38 e3    .8.
	lhld	curtrk		;; e2f6: 2a de fc    *..
	xchg			;; e2f9: eb          .
	lhld	Lfceb		;; e2fa: 2a eb fc    *..
	mov	a,d		;; e2fd: 7a          z
	cmp	h		;; e2fe: bc          .
	jnz	Le338		;; e2ff: c2 38 e3    .8.
	mov	a,e		;; e302: 7b          {
	cmp	l		;; e303: bd          .
	jnz	Le338		;; e304: c2 38 e3    .8.
	lda	Lfce2		;; e307: 3a e2 fc    :..
	lxi	h,Lfced		;; e30a: 21 ed fc    ...
	cmp	m		;; e30d: be          .
	jnz	Le338		;; e30e: c2 38 e3    .8.
	inr	m		;; e311: 34          4
	mov	a,m		;; e312: 7e          ~
	call	getdpb		;; e313: cd 2c e3    .,.
	cmp	m	; DPB.SPT
	jc	Le325		;; e317: da 25 e3    .%.
	; at end of track...
	xra	a		;; e31a: af          .
	sta	Lfced		;; e31b: 32 ed fc    2..
	lhld	Lfceb		;; e31e: 2a eb fc    *..
	inx	h	; next track
	shld	Lfceb		;; e322: 22 eb fc    "..
Le325:	xra	a		;; e325: af          .
	sta	Lfcee		;; e326: 32 ee fc    2..
	jmp	Le340		;; e329: c3 40 e3    .@.

getdpb:	lhld	curdph		;; e32c: 2a d9 fc    *..
	lxi	d,10		;; e32f: 11 0a 00    ...
	dad	d		;; e332: 19          .
	mov	e,m		;; e333: 5e          ^
	inx	h		;; e334: 23          #
	mov	d,m		;; e335: 56          V
	xchg			;; e336: eb          .
	ret			;; e337: c9          .

Le338:	xra	a		;; e338: af          .
	sta	curblm		;; e339: 32 e9 fc    2..
	inr	a		;; e33c: 3c          <
	sta	Lfcee		;; e33d: 32 ee fc    2..
Le340:	lda	Lfcdb		;; e340: 3a db fc    :..
	cpi	004h		;; e343: fe 04       ..
	jnz	Le34a		;; e345: c2 4a e3    .J.
	mvi	a,002h		;; e348: 3e 02       >.
Le34a:	mov	b,a		;; e34a: 47          G
	lda	cursec		;; e34b: 3a e1 fc    :..
	dcr	b		;; e34e: 05          .
	jz	Le35a		;; e34f: ca 5a e3    .Z.
	dcr	b		;; e352: 05          .
	jz	Le358		;; e353: ca 58 e3    .X.
	ora	a		;; e356: b7          .
	rar			;; e357: 1f          .
Le358:	ora	a		;; e358: b7          .
	rar			;; e359: 1f          .
Le35a:	ora	a		;; e35a: b7          .
	rar			;; e35b: 1f          .
	inr	a		;; e35c: 3c          <
	mov	c,a		;; e35d: 4f          O
	lda	cursid		;; e35e: 3a 0c fd    :..
	mov	b,a		;; e361: 47          G
	ora	a		;; e362: b7          .
	jz	Le36a		;; e363: ca 6a e3    .j.
	mov	a,c		;; e366: 79          y
	sui	009h		;; e367: d6 09       ..
	mov	c,a		;; e369: 4f          O
Le36a:	lda	Lfcd8		;; e36a: 3a d8 fc    :..
	mov	l,a		;; e36d: 6f          o
	lda	Lfcfc		;; e36e: 3a fc fc    :..
	cmp	l		;; e371: bd          .
	jnz	Le38d		;; e372: c2 8d e3    ...
	lxi	h,curtrk	;; e375: 21 de fc    ...
	lda	fdcbuf+1	;; e378: 3a ff fc    :..
	cmp	m		;; e37b: be          .
	jnz	Le38d		;; e37c: c2 8d e3    ...
	lda	fdcbuf+2	;; e37f: 3a 00 fd    :..
	cmp	b		;; e382: b8          .
	jnz	Le38d		;; e383: c2 8d e3    ...
	lda	fdcbuf+3	;; e386: 3a 01 fd    :..
	cmp	c		;; e389: b9          .
	jz	Le3b7		;; e38a: ca b7 e3    ...
Le38d:	push	b		;; e38d: c5          .
	call	Le3f5		;; e38e: cd f5 e3    ...
	call	Le61d		;; e391: cd 1d e6    ...
	call	Le6bc		;; e394: cd bc e6    ...
	pop	b		;; e397: c1          .
	lxi	h,fdcbuf+3	;; e398: 21 01 fd    ...
	mov	m,c		;; e39b: 71          q
	dcx	h		;; e39c: 2b          +
	mov	m,b		;; e39d: 70          p
	lda	Lfcee		;; e39e: 3a ee fc    :..
	ora	a		;; e3a1: b7          .
	jz	Le3b7		;; e3a2: ca b7 e3    ...
	lhld	dmaadr		;; e3a5: 2a e3 fc    *..
	push	h		;; e3a8: e5          .
	lxi	h,Lf5d5		;; e3a9: 21 d5 f5    ...
	shld	dmaadr		;; e3ac: 22 e3 fc    "..
	call	Le43c		;; e3af: cd 3c e4    .<.
	pop	h		;; e3b2: e1          .
	shld	dmaadr		;; e3b3: 22 e3 fc    "..
	rnz			;; e3b6: c0          .
Le3b7:	lda	Lfcdb		;; e3b7: 3a db fc    :..
	cpi	003h		;; e3ba: fe 03       ..
	jz	Le41e		;; e3bc: ca 1e e4    ...
	rar			;; e3bf: 1f          .
	jc	Le40f		;; e3c0: da 0f e4    ...
	lda	cursec		;; e3c3: 3a e1 fc    :..
	ani	003h		;; e3c6: e6 03       ..
	rrc			;; e3c8: 0f          .
	rrc			;; e3c9: 0f          .
	mov	l,a		;; e3ca: 6f          o
	mvi	h,000h		;; e3cb: 26 00       &.
	dad	h		;; e3cd: 29          )
	lxi	d,Lf5d5		;; e3ce: 11 d5 f5    ...
Le3d1:	dad	d		;; e3d1: 19          .
	xchg			;; e3d2: eb          .
	lhld	dmaadr		;; e3d3: 2a e3 fc    *..
	mvi	c,128		;; e3d6: 0e 80       ..
	lda	wrflg		;; e3d8: 3a e5 fc    :..
	ora	a		;; e3db: b7          .
	jz	Le3e5		;; e3dc: ca e5 e3    ...
	mvi	a,001h		;; e3df: 3e 01       >.
	sta	Lfcd7		;; e3e1: 32 d7 fc    2..
	xchg			;; e3e4: eb          .
Le3e5:	ldax	d		;; e3e5: 1a          .
	mov	m,a		;; e3e6: 77          w
	inx	h		;; e3e7: 23          #
	inx	d		;; e3e8: 13          .
	dcr	c		;; e3e9: 0d          .
	jnz	Le3e5		;; e3ea: c2 e5 e3    ...
	lda	Lfce6		;; e3ed: 3a e6 fc    :..
	cpi	001h		;; e3f0: fe 01       ..
	mvi	a,000h		;; e3f2: 3e 00       >.
	rnz			;; e3f4: c0          .
Le3f5:	lxi	h,Lfcd7		;; e3f5: 21 d7 fc    ...
	mov	a,m		;; e3f8: 7e          ~
	mvi	m,000h		;; e3f9: 36 00       6.
	ora	a		;; e3fb: b7          .
	rz			;; e3fc: c8          .
	lhld	dmaadr		;; e3fd: 2a e3 fc    *..
	push	h		;; e400: e5          .
	lxi	h,Lf5d5		;; e401: 21 d5 f5    ...
	shld	dmaadr		;; e404: 22 e3 fc    "..
	call	Le431		;; e407: cd 31 e4    .1.
	pop	h		;; e40a: e1          .
	shld	dmaadr		;; e40b: 22 e3 fc    "..
	ret			;; e40e: c9          .

Le40f:	lda	cursec		;; e40f: 3a e1 fc    :..
	ani	001h		;; e412: e6 01       ..
	rrc			;; e414: 0f          .
	mov	e,a		;; e415: 5f          _
	mvi	d,000h		;; e416: 16 00       ..
	lxi	h,Lf5d5		;; e418: 21 d5 f5    ...
	jmp	Le3d1		;; e41b: c3 d1 e3    ...

Le41e:	lda	cursec		;; e41e: 3a e1 fc    :..
	ani	007h		;; e421: e6 07       ..
	rrc			;; e423: 0f          .
	rrc			;; e424: 0f          .
	rrc			;; e425: 0f          .
	mov	l,a		;; e426: 6f          o
	mvi	h,000h		;; e427: 26 00       &.
	dad	h		;; e429: 29          )
	dad	h		;; e42a: 29          )
	lxi	d,Lf5d5		;; e42b: 11 d5 f5    ...
	jmp	Le3d1		;; e42e: c3 d1 e3    ...

; write operation
Le431:	lda	Lfd06		;; e431: 3a 06 fd    :..
	mov	b,a		;; e434: 47          G
	mvi	c,DMA_RD	;; e435: 0e 80       ..
	mvi	a,1		;; e437: 3e 01       >.
	jmp	Le443		;; e439: c3 43 e4    .C.

; read operation
Le43c:	lda	Lfd07		;; e43c: 3a 07 fd    :..
	mov	b,a		;; e43f: 47          G
	mvi	c,DMA_WR	;; e440: 0e 40       .@
	xra	a		;; e442: af          .
Le443:	sta	Lfcd6		;; e443: 32 d6 fc    2..
Le446:	xra	a		;; e446: af          .
	sta	Lfcef		;; e447: 32 ef fc    2..
	mvi	a,010h		;; e44a: 3e 10       >.
Le44c:	sta	Lfcd5		;; e44c: 32 d5 fc    2..
Le44f:	lda	fdcbuf		;; e44f: 3a fe fc    :..
	ani	003h		;; e452: e6 03       ..
	mov	l,a		;; e454: 6f          o
	lda	fdcbuf+2	;; e455: 3a 00 fd    :..
	rlc			;; e458: 07          .
	rlc			;; e459: 07          .
	ora	l		;; e45a: b5          .
	sta	fdcbuf		;; e45b: 32 fe fc    2..
	call	Le742		;; e45e: cd 42 e7    .B.
	di			;; e461: f3          .
	lhld	Lfce7		;; e462: 2a e7 fc    *..
	mov	a,l		;; e465: 7d          }
	out	DMA_1C		;; e466: d3 33       .3
	mov	a,c		;; e468: 79          y
	ora	h		;; e469: b4          .
	out	DMA_1C		;; e46a: d3 33       .3
	lhld	dmaadr		;; e46c: 2a e3 fc    *..
	mov	a,l		;; e46f: 7d          }
	out	DMA_1A		;; e470: d3 32       .2
	mov	a,h		;; e472: 7c          |
	out	DMA_1A		;; e473: d3 32       .2
	mvi	a,040h+DMA_FDC	; TC stop, FDC ch ena
	out	DMA_CTL		;; e477: d3 38       .8
	ei			;; e479: fb          .
	push	b		;; e47a: c5          .
	mvi	c,008h		;; e47b: 0e 08       ..
	call	fdccmd		;; e47d: cd e1 e6    ...
	pop	b		;; e480: c1          .
	jc	Le44f		;; e481: da 4f e4    .O.
	rz			;; e484: c8          .
	push	b		;; e485: c5          .
	lda	fdcres+1	;; e486: 3a f1 fc    :..
	ani	018h		;; e489: e6 18       ..
	jz	Le492		;; e48b: ca 92 e4    ...
	pop	b		;; e48e: c1          .
	jmp	Le44f		;; e48f: c3 4f e4    .O.

Le492:	lda	fdcres+3	;; e492: 3a f3 fc    :..
	ani	010h		;; e495: e6 10       ..
	jz	Le4ab		;; e497: ca ab e4    ...
	lda	Lfcef		;; e49a: 3a ef fc    :..
	ora	a		;; e49d: b7          .
	jnz	Le4ab		;; e49e: c2 ab e4    ...
	cma			;; e4a1: 2f          /
	sta	Lfcef		;; e4a2: 32 ef fc    2..
	call	Le6a7		;; e4a5: cd a7 e6    ...
	call	Le6bc		;; e4a8: cd bc e6    ...
Le4ab:	pop	b		;; e4ab: c1          .
	lda	Lfcd5		;; e4ac: 3a d5 fc    :..
	dcr	a		;; e4af: 3d          =
	jp	Le44c		;; e4b0: f2 4c e4    .L.
	call	Le67b		;; e4b3: cd 7b e6    .{.
	lxi	h,fdcres+2	;; e4b6: 21 f2 fc    ...
	mov	a,m		;; e4b9: 7e          ~
	ani	080h		;; e4ba: e6 80       ..
	jz	Le4cf		;; e4bc: ca cf e4    ...
	call	print		;; e4bf: cd 67 e6    .g.
	db	'end of track$'
Le4cf:	mov	a,m		;; e4cf: 7e          ~
	ani	020h		;; e4d0: e6 20       . 
	jz	Le4f6		;; e4d2: ca f6 e4    ...
	inx	h		;; e4d5: 23          #
	mov	a,m		;; e4d6: 7e          ~
	dcx	h		;; e4d7: 2b          +
	ani	020h		;; e4d8: e6 20       . 
	jz	Le4ec		;; e4da: ca ec e4    ...
	call	print		;; e4dd: cd 67 e6    .g.
	db	'data CRC$'
	jmp	Le4f6		;; e4e9: c3 f6 e4    ...

Le4ec:	call	print		;; e4ec: cd 67 e6    .g.
	db	'ID CRC$'
Le4f6:	mov	a,m		;; e4f6: 7e          ~
	ani	004h		;; e4f7: e6 04       ..
	jz	Le510		;; e4f9: ca 10 e5    ...
	call	print		;; e4fc: cd 67 e6    .g.
	db	'sector not found$'
Le510:	mov	a,m		;; e510: 7e          ~
	ani	002h		;; e511: e6 02       ..
	cnz	Le69b		;; e513: c4 9b e6    ...
	mov	a,m		;; e516: 7e          ~
	ani	001h		;; e517: e6 01       ..
	jz	Le545		;; e519: ca 45 e5    .E.
	inx	h		;; e51c: 23          #
	mov	a,m		;; e51d: 7e          ~
	ani	001h		;; e51e: e6 01       ..
	jz	Le52e		;; e520: ca 2e e5    ...
	call	print		;; e523: cd 67 e6    .g.
	db	'data$'
	jmp	Le534		;; e52b: c3 34 e5    .4.

Le52e:	call	print		;; e52e: cd 67 e6    .g.
	db	'ID$'
Le534:	call	print		;; e534: cd 67 e6    .g.
	db	' address mark$'
Le545:	call	print		;; e545: cd 67 e6    .g.
	db	' ERROR',CR,LF,'$'
	lda	Lfd08		;; e551: 3a 08 fd    :..
	ora	a		;; e554: b7          .
	jnz	lstst		;; e555: c2 91 e5    ...
	call	print		;; e558: cd 67 e6    .g.
	db	'Continue,Ignore,Retry ? $'
	push	b		;; e574: c5          .
	call	conin		;; e575: cd 58 e9    .X.
	push	psw		;; e578: f5          .
	mov	c,a		;; e579: 4f          O
	call	conout		;; e57a: cd 69 e9    .i.
	call	print		;; e57d: cd 67 e6    .g.
	db	CR,LF,'$'
	pop	psw		;; e583: f1          .
	pop	b		;; e584: c1          .
	ani	0dfh		;; e585: e6 df       ..
	cpi	'I'		;; e587: fe 49       .I
	jz	Le594		;; e589: ca 94 e5    ...
	cpi	'R'		;; e58c: fe 52       .R
	jz	Le446		;; e58e: ca 46 e4    .F.
lstst:	xra	a		;; e591: af          .
	dcr	a		;; e592: 3d          =
	ret			;; e593: c9          .

Le594:	xra	a		;; e594: af          .
	ret			;; e595: c9          .

Le596:	lhld	dmaadr		;; e596: 2a e3 fc    *..
	lxi	d,winend+127	;; e599: 11 7f c0    ...
	dad	d		;; e59c: 19          .
	jnc	Le608		;; e59d: d2 08 e6    ...
	lda	dmaadr+1	;; e5a0: 3a e4 fc    :..
	cpi	HIGH winend	;; e5a3: fe c0       ..
	jnc	Le608		;; e5a5: d2 08 e6    ...
	lda	wrflg		;; e5a8: 3a e5 fc    :..
	ora	a		;; e5ab: b7          .
	jnz	Le5c4		;; e5ac: c2 c4 e5    ...
	call	rdadr		;; e5af: cd f7 e5    ...
	xchg			;; e5b2: eb          .
	mvi	a,8		;; e5b3: 3e 08       >.
	call	Le5d3		;; e5b5: cd d3 e5    ...
	lxi	d,rdbuf		;; e5b8: 11 70 fd    .p.
	mvi	c,128		;; e5bb: 0e 80       ..
	lhld	dmaadr		;; e5bd: 2a e3 fc    *..
	xchg			;; e5c0: eb          .
	ldir			;; e5c1: ed b0       ..
	ret			;; e5c3: c9          .

Le5c4:	lhld	dmaadr		;; e5c4: 2a e3 fc    *..
	lxi	d,rdbuf		;; e5c7: 11 70 fd    .p.
	lxi	b,128		;; e5ca: 01 80 00    ...
	ldir			;; e5cd: ed b0       ..
	call	rdadr		;; e5cf: cd f7 e5    ...
	xra	a		;; e5d2: af          .
Le5d3:	mov	b,a		;; e5d3: 47          G
	lda	Lfd11		;; e5d4: 3a 11 fd    :..
	sta	Lfd12		;; e5d7: 32 12 fd    2..
	mvi	a,002h	; prevent tick hook during I/O
	sta	Lfd11		;; e5dc: 32 11 fd    2..
	lda	curtrk	; a.k.a ramdisk bank number
	adi	2	; reserved banks...
	ora	b		;; e5e4: b0          .
	mov	c,a		;; e5e5: 4f          O
	in	PP_A		;; e5e6: db 00       ..
	ora	c		;; e5e8: b1          .
	out	PP_A		;; e5e9: d3 00       ..
	; user TPA no longer valid...
	lxi	b,128		;; e5eb: 01 80 00    ...
	ldir			;; e5ee: ed b0       ..
	ani	11110000b	; ENNMI off
	out	PP_A		;; e5f2: d3 00       ..
	; user TPA safe again
	jmp	ticfin		;; e5f4: c3 46 ea    .F.

; compute ramdisk address
; returns HL=rdbuf, DE=sector address (within track/bank)
rdadr:	lda	cursec		;; e5f7: 3a e1 fc    :..
	rar			;; e5fa: 1f          .
	mov	d,a		;; e5fb: 57          W
	mvi	a,0		;; e5fc: 3e 00       >.
	rar			;; e5fe: 1f          .
	mov	e,a		;; e5ff: 5f          _
	mov	a,d		;; e600: 7a          z
	adi	HIGH ramwin	;; e601: c6 40       .@
	mov	d,a		;; e603: 57          W
	lxi	h,rdbuf		;; e604: 21 70 fd    .p.
	ret			;; e607: c9          .

Le608:	call	rdadr		;; e608: cd f7 e5    ...
	lhld	dmaadr		;; e60b: 2a e3 fc    *..
	lda	wrflg		;; e60e: 3a e5 fc    :..
	ora	a		;; e611: b7          .
	mvi	a,0		;; e612: 3e 00       >.
	jnz	Le5d3		;; e614: c2 d3 e5    ...
	xchg			;; e617: eb          .
	mvi	a,8		;; e618: 3e 08       >.
	jmp	Le5d3		;; e61a: c3 d3 e5    ...

Le61d:	lda	Lfcd8		;; e61d: 3a d8 fc    :..
	sta	Lfcfc		;; e620: 32 fc fc    2..
	ret			;; e623: c9          .

Le624:	lda	fdcbuf		;; e624: 3a fe fc    :..
	ani	003h		;; e627: e6 03       ..
	adi	'A'		;; e629: c6 41       .A
	sta	Le633		;; e62b: 32 33 e6    23.
	call	print		;; e62e: cd 67 e6    .g.
	db	CR,LF
Le633:	db	'A$'
	call	Le640		;; e635: cd 40 e6    .@.
	rnz			;; e638: c0          .
	xra	a		;; e639: af          .
	sta	usrdrv		;; e63a: 32 04 00    2..
	jmp	cpm		;; e63d: c3 00 00    ...

Le640:	call	print		;; e640: cd 67 e6    .g.
	db	': not ready',16h,CR,BEL,'$'
	call	conin		;; e652: cd 58 e9    .X.
	cpi	003h		;; e655: fe 03       ..
	ret			;; e657: c9          .

; floppy drive SENSE, C=drive num
fdsens:	di			;; e658: f3          .
	mvi	b,4	; SENSE command
	call	fdcbeg		;; e65b: cd 28 e7    .(.
	mov	b,c	; drive select
	call	fdcout		;; e65f: cd 2f e7    ./.
	call	fdcin		;; e662: cd 39 e7    .9.
	ei			;; e665: fb          .
	ret			;; e666: c9          .

print:	xthl			;; e667: e3          .
	mov	a,m		;; e668: 7e          ~
	inx	h		;; e669: 23          #
	cpi	'$'		;; e66a: fe 24       .$
	xthl			;; e66c: e3          .
	rz			;; e66d: c8          .
	push	b		;; e66e: c5          .
	push	h		;; e66f: e5          .
	push	d		;; e670: d5          .
	mov	c,a		;; e671: 4f          O
	call	conout		;; e672: cd 69 e9    .i.
	pop	d		;; e675: d1          .
	pop	h		;; e676: e1          .
	pop	b		;; e677: c1          .
	jmp	print		;; e678: c3 67 e6    .g.

Le67b:	lda	Lfcd6		;; e67b: 3a d6 fc    :..
	ora	a		;; e67e: b7          .
	jz	Le68f		;; e67f: ca 8f e6    ...
	call	print		;; e682: cd 67 e6    .g.
	db	CR,LF,'WRITE $'
	ret			;; e68e: c9          .

Le68f:	call	print		;; e68f: cd 67 e6    .g.
	db	CR,LF,'READ $'
	ret			;; e69a: c9          .

Le69b:	call	print		;; e69b: cd 67 e6    .g.
	db	'protect$'
	ret			;; e6a6: c9          .

Le6a7:	call	Le6aa		;; e6a7: cd aa e6    ...
Le6aa:	call	Le742		;; e6aa: cd 42 e7    .B.
	xra	a		;; e6ad: af          .
	sta	fdcbuf+1	;; e6ae: 32 ff fc    2..
	mvi	b,007h		;; e6b1: 06 07       ..
	mvi	c,001h		;; e6b3: 0e 01       ..
	call	fdccmd		;; e6b5: cd e1 e6    ...
	jc	Le6aa		;; e6b8: da aa e6    ...
	ret			;; e6bb: c9          .

Le6bc:	call	Le742		;; e6bc: cd 42 e7    .B.
	lda	curtrk		;; e6bf: 3a de fc    :..
	lxi	h,fdcbuf+1	;; e6c2: 21 ff fc    ...
	cmp	m		;; e6c5: be          .
	rz		; no SEEK needed
	mov	e,a		;; e6c7: 5f          _
	lda	Lfd0b		;; e6c8: 3a 0b fd    :..
	ora	a		;; e6cb: b7          .
	mov	a,e		;; e6cc: 7b          {
	jz	Le6d1		;; e6cd: ca d1 e6    ...
	rlc			;; e6d0: 07          .
Le6d1:	mov	m,a		;; e6d1: 77          w
Le6d2:	mvi	b,00fh	; SEEK command
	mvi	c,2		;; e6d4: 0e 02       ..
	call	fdccmd		;; e6d6: cd e1 e6    ...
	jc	Le6d2		;; e6d9: da d2 e6    ...
	mov	a,e		;; e6dc: 7b          {
	sta	fdcbuf+1	;; e6dd: 32 ff fc    2..
	ret			;; e6e0: c9          .

; B=command, fdcbuf=params, C=num params
; returns NZ if error, CY if timeout
fdccmd:	lxi	h,fdcbuf	;; e6e1: 21 fe fc    ...
	di			;; e6e4: f3          .
	call	fdcbeg		;; e6e5: cd 28 e7    .(.
Le6e8:	mov	b,m		;; e6e8: 46          F
	call	fdcout		;; e6e9: cd 2f e7    ./.
	inx	h		;; e6ec: 23          #
	dcr	c		;; e6ed: 0d          .
	jnz	Le6e8		;; e6ee: c2 e8 e6    ...
	ei			;; e6f1: fb          .
	push	d		;; e6f2: d5          .
	push	b		;; e6f3: c5          .
	mvi	d,002h		;; e6f4: 16 02       ..
	; wait for FDC intr - with timeout
Le6f6:	lxi	b,0		;; e6f6: 01 00 00    ...
Le6f9:	dcx	b		;; e6f9: 0b          .
	mov	a,b		;; e6fa: 78          x
	ora	c		;; e6fb: b1          .
	jz	Le710		;; e6fc: ca 10 e7    ...
	lxi	h,fdcres	;; e6ff: 21 f0 fc    ...
	mov	a,m		;; e702: 7e          ~
	ora	a		;; e703: b7          .
	jz	Le6f9		;; e704: ca f9 e6    ...
	mvi	m,0		;; e707: 36 00       6.
	inx	h		;; e709: 23          #
	mov	a,m		;; e70a: 7e          ~
	ani	0c0h	; ST0 intr code (00=normal)
	pop	b		;; e70d: c1          .
	pop	d		;; e70e: d1          .
	ret			;; e70f: c9          .

Le710:	dcr	d		;; e710: 15          .
	jnz	Le6f6		;; e711: c2 f6 e6    ...
	lda	Lfd09	; drive type, 0=8"
	call	Le721		;; e717: cd 21 e7    ...
	call	Le624		;; e71a: cd 24 e6    .$.
	pop	b		;; e71d: c1          .
	pop	d		;; e71e: d1          .
	stc			;; e71f: 37          7
	ret			;; e720: c9          .

; setup drives, A=0 for 8"
Le721:	ora	a		;; e721: b7          .
	jz	Le006		;; e722: ca 06 e0    ...
	jmp	Le03a		;; e725: c3 3a e0    .:.

; Begin FDC command sequence.
; B=byte
fdcbeg:	in	FDC_STS		;; e728: db 40       .@
	ani	01fh		;; e72a: e6 1f       ..
	jnz	fdcbeg		;; e72c: c2 28 e7    .(.
; Send a byte to FDC.
; B=byte
fdcout:	in	FDC_STS		;; e72f: db 40       .@
	ral			;; e731: 17          .
	jnc	fdcout		;; e732: d2 2f e7    ./.
	mov	a,b		;; e735: 78          x
	out	FDC_DAT		;; e736: d3 41       .A
	ret			;; e738: c9          .

fdcin:	in	FDC_STS		;; e739: db 40       .@
	ral			;; e73b: 17          .
	jnc	fdcin		;; e73c: d2 39 e7    .9.
	in	FDC_DAT		;; e73f: db 41       .A
	ret			;; e741: c9          .

Le742:	push	b		;; e742: c5          .
	lda	Lfd09		;; e743: 3a 09 fd    :..
	ora	a		;; e746: b7          .
	jz	Le778		;; e747: ca 78 e7    .x.
	lxi	h,fdcmtr-1	;; e74a: 21 0c fd    ...
	lda	fdcbuf		;; e74d: 3a fe fc    :..
	ani	003h		;; e750: e6 03       ..
	mov	c,a		;; e752: 4f          O
	inr	c		;; e753: 0c          .
	mvi	a,10000000b	; MTR_DS0 rrc 1
Le756:	inx	h		;; e756: 23          #
	rlc			;; e757: 07          .
	dcr	c		;; e758: 0d          .
	jnz	Le756		;; e759: c2 56 e7    .V.
	; A = MTR_DS0/MTR_DS1/MTR_DS2/MTR_DS3
	mov	c,a		;; e75c: 4f          O
	di			;; e75d: f3          .
	mov	a,m		;; e75e: 7e          ~
	ora	a		;; e75f: b7          .
	mvi	m,40	; 4.0 second timeout
	ei			;; e762: fb          .
	jnz	Le778	; drive is already active...
	lda	Lde6f		;; e766: 3a 6f de    :o.
	ora	c		;; e769: b1          .
	sta	Lde6f		;; e76a: 32 6f de    2o.
	out	FDC_CTL		;; e76d: d3 42       .B
	lxi	h,15000	; delay for motor on
Le772:	dcx	h		;; e772: 2b          +
	mov	a,h		;; e773: 7c          |
	ora	l		;; e774: b5          .
	jnz	Le772		;; e775: c2 72 e7    .r.
Le778:	pop	b		;; e778: c1          .
	ret			;; e779: c9          .

; DPHs for drives A: to E: (DPBs may be filled in later)
dphtbl:
dph0:	dw	trn8m0,00000h,00000h,00000h,dirbuf,0000h,csv0,alv0
	db	0ffh
dph1:	dw	trn8m0,00000h,00000h,00000h,dirbuf,0000h,csv1,alv1
	db	0ffh
dph2:	dw	trn5m0,00000h,00000h,00000h,dirbuf,0000h,csv2,alv2
	db	0ffh
dph3:	dw	trn5m0,00000h,00000h,00000h,dirbuf,0000h,csv3,alv3
	db	0ffh
; extra DPH for ramdisk
	dw	00000h,00000h,00000h,00000h,dirbuf,dpbrd,csv4,alv4
	db	10h

; FDC parameters for 8" disks
fd8fm1:	db	1	; fdcbuf N
	db	26	; fdcbuf EOT
	db	14	; fdcbuf GPL
	db	255	; fdcbuf DTL
	db	45h	; WRITE command
	db	46h	; READ command
	dw	dpb8m1

fd8fm2:	db	2
	db	16
	db	14
	db	255
	db	45h	; WRITE command
	db	46h	; READ command
	dw	dpb8m2

fd8fm3:	db	3
	db	8
	db	53
	db	255
	db	45h	; WRITE command
	db	46h	; READ command
	dw	dpb8m3

fd8fm0:	db	0
	db	26
	db	7
	db	128
	db	5	; WRITE command
	db	6	; READ command
	dw	dpb8m0

dpb8m1:	dw	52
	db	4,15,1
	dw	243-1,128-1
	db	11000000b,0
	dw	32
	dw	2

dpb8m2:	dw	64
	db	4,15,0
	dw	300-1,128-1
	db	11000000b,0
	dw	64
	dw	2

dpb8m3:	dw	64
	db	4,15,0
	dw	300-1,128-1
	db	11000000b,0
	dw	64
	dw	2

dpb8m0:	dw	26
	db	3,7,0
	dw	243-1,64-1
	db	11000000b,0
	dw	16
	dw	2

; sector translation tables
trn8m0:	db	1,7,13,19,25,5,11,17,23,3,9,15,21
	db	2,8,14,20,26,6,12,18,24,4,10,16,22
trn8m2:	db	0,7,14,5,12,3,10,1,8,15,6,13,4,11,2,9

; 192K ramdisk
dpbrd:	dw	256	; 32K "track" - one bank
	db	4,15,1
	dw	96-1,128-1
	db	11000000b,0
	dw	0
	dw	0

; FDC parameters for 5.25" disks
; Format 1: DD, SS, 16 sectors/track, 256-byte each, 40 tracks
fd5fm1:	db	1
	db	16
	db	10
	db	0ffh
	db	45h	; WRITE command
	db	46h	; READ command
	dw	dpb5m1

; Format 2: DD, SS, 9 sectors/track, 512-byte each, 40 tracks
; Format Z: DD, DS, DT, 18 sectors/track, 512-byte each, 80 "tracks" (side 0+1 = track)
fd5fm2:	db	2
	db	9
	db	10
	db	0ffh
	db	45h	; WRITE command
	db	46h	; READ command
	dw	dpb5m2

; Format 3: DD, 5 sectors/track, 1024-byte each
fd5fm3:	db	3
	db	5
	db	80h
	db	0ffh
	db	45h	; WRITE command
	db	46h	; READ command
	dw	dpb5m3

; Format 0: SD, 16 sectors/track, 128-byte each
fd5fm0:	db	0
	db	10h
	db	7
	db	80h
	db	5
	db	6
	dw	dpb5m0

dpb5m1:	dw	32
	db	3,7,0
	dw	152-1,64-1
	db	11000000b,0
	dw	16
	dw	2

; 5.25" DD SS ST
dpb5m2:	dw	36
	db	3,7,0
	dw	171-1,64-1
	db	11000000b,0
	dw	16
	dw	2

; 5.25" DD DS DT
dpb5mZ:	dw	72
	db	4,15,0
	dw	351-1,128-1
	db	11000000b,0
	dw	64
	dw	2

dpb5m0:	dw	16
	db	3,7,0
	dw	72-1,64-1
	db	11000000b,0
	dw	16
	dw	4

dpb5m3:	dw	40
	db	3,7,0
	dw	200-1,64-1
	db	11000000b,0
	dw	16
	dw	2

; sector translation tables
trn5m0:	db	1,5,9,13,2,6,10,14,3,7,11,15,4,8,12,16
trn5m2:	db	0,4,8,3,7,2,6,1,5

; FDC completion interrupt
fdcint:	push	psw
	in	FDC_STS
	push	h
	push	b
	lxi	h,fdcres
	ani	010h
	jnz	Le90f	; FDC still busy... has result...
	mvi	b,8	; SENSE INTR
	call	fdcout
	pop	b
	call	fdcin
	inx	h
	mov	m,a	; ST0
	call	fdcin	; ignore PCN
	mov	a,m
	ani	020h	; SEEK END
	jz	reti2
	dcx	h
	mvi	m,001h	; mark complete
	jmp	reti2

; FDC still busy
Le90f:	mvi	m,001h
	mvi	b,7
Le913:	inx	h
	call	fdcin
	mov	m,a
	dcr	b
	jnz	Le913
	pop	b
	jmp	reti2

; console input redirection
Le920:	dw	Led37	; CON:=TTY:
Le922:	dw	akbin	; CON:=CRT:
	dw	rdrin	; CON:=BAT:
	dw	uc1in	; CON:=UC1
; console output redirection
Le928:	dw	Led7b	; CON:=TTY:
Le92a:	dw	Leebf	; CON:=CRT:
	dw	lstout	; CON:=BAT:
	dw	uc1out	; CON:=UC1:
; reader input redirection
Le930:	dw	Led37	; RDR:=TTY:
Le932:	dw	akbin	; RDR:=PTR:
	dw	Led37	; RDR:=UR1:
	dw	uc1in	; RDR:=UR2:
; punch output redirection
Le938:	dw	Led7b	; PUN:=TTY:
Le93a:	dw	Leebf	; PUN:=PTP:
	dw	Led7b	; PUN:=UP1:
	dw	uc1out	; PUN:=UP2:
; printer output redirection
Le940:	dw	Led7b	; LST:=TTY:
Le942:	dw	Leebf	; LST:=CRT:
	dw	lptout	; LST:=LPT:
	dw	uc1out	; LST:=UL1:
; console input status redirection
Le948:	dw	Lec51	; CON:=TTY:
	dw	kbdst	; CON:=CRT:
	dw	Lec51	; CON:=BAT:
	dw	uc1st	; CON:=UC1:
; extension: reader input status redirection
Le950:	dw	Lec51
	dw	kbdst
	dw	Lec51
	dw	uc1st

conin:	lxi	h,Le920		;; e958: 21 20 e9    . .
Le95b:	lda	iobyte		;; e95b: 3a 03 00    :..
Le95e:	rlc			;; e95e: 07          .
Le95f:	ani	0110b		;; e95f: e6 06       ..
	call	addahl		;; e961: cd c7 f5    ...
	mov	a,m		;; e964: 7e          ~
	inx	h		;; e965: 23          #
	mov	h,m		;; e966: 66          f
	mov	l,a		;; e967: 6f          o
	pchl			;; e968: e9          .

conout:	lxi	h,Le928		;; e969: 21 28 e9    .(.
	jmp	Le95b		;; e96c: c3 5b e9    .[.

const:	lxi	h,Le948		;; e96f: 21 48 e9    .H.
	jmp	Le95b		;; e972: c3 5b e9    .[.

rdrin:	lxi	h,Le930		;; e975: 21 30 e9    .0.
Le978:	lda	iobyte		;; e978: 3a 03 00    :..
	jmp	Le98c		;; e97b: c3 8c e9    ...

rdrst:	lxi	h,Le950		;; e97e: 21 50 e9    .P.
	jmp	Le978		;; e981: c3 78 e9    .x.

punout:	lxi	h,Le938		;; e984: 21 38 e9    .8.
	lda	iobyte		;; e987: 3a 03 00    :..
	rrc			;; e98a: 0f          .
	rrc			;; e98b: 0f          .
Le98c:	rrc			;; e98c: 0f          .
	jmp	Le95f		;; e98d: c3 5f e9    ._.

lstout:	lxi	h,Le940		;; e990: 21 40 e9    .@.
	lda	iobyte		;; e993: 3a 03 00    :..
	rlc			;; e996: 07          .
	rlc			;; e997: 07          .
	jmp	Le95e		;; e998: c3 5e e9    .^.

tick:	sspd	savst2		;; e99b: ed 73 0a ea .s..
	lxi	sp,ticstk	;; e99f: 31 0a ea    1..
	push	h		;; e9a2: e5          .
	push	b		;; e9a3: c5          .
	push	psw		;; e9a4: f5          .
	; check all floppy motor timeouts
	lxi	h,fdcmtr	;; e9a5: 21 0d fd    ...
	mvi	b,4	; 4 drives total?
	mvi	c,11111110b	;; e9aa: 0e fe       ..
Le9ac:	mov	a,m		;; e9ac: 7e          ~
	ora	a		;; e9ad: b7          .
	jrz	Le9ba		;; e9ae: 28 0a       (.
	dcr	m		;; e9b0: 35          5
	jrnz	Le9ba		;; e9b1: 20 07        .
	; timeout, shut motor off
	lda	Lde6f		;; e9b3: 3a 6f de    :o.
	ana	c		;; e9b6: a1          .
	sta	Lde6f		;; e9b7: 32 6f de    2o.
Le9ba:	rlcr	c		;; e9ba: cb 01       ..
	inx	h		;; e9bc: 23          #
	dcr	b		;; e9bd: 05          .
	jrnz	Le9ac		;; e9be: 20 ec        .
	lda	Lde6f		;; e9c0: 3a 6f de    :o.
	out	FDC_CTL		;; e9c3: d3 42       .B
	; HL=Lfd11
	mov	a,m		;; e9c5: 7e          ~
	ora	a		;; e9c6: b7          .
	jrz	ticret		;; e9c7: 28 1e       (.
	dcr	m		;; e9c9: 35          5
	jrnz	ticret		;; e9ca: 20 1b        .
	; --Lfd11 == 0 (i.e. Lfd11-- == 1)
	mvi	m,1	; Lfd11=1
	lhld	ticcnt		;; e9ce: 2a 0d ea    *..
	dcx	h		;; e9d1: 2b          +
	mov	a,h		;; e9d2: 7c          |
	ora	l		;; e9d3: b5          .
	shld	ticcnt		;; e9d4: 22 0d ea    "..
	jrnz	ticret		;; e9d7: 20 0e        .
	xra	a		;; e9d9: af          .
	sta	Lfd11		;; e9da: 32 11 fd    2..
	inr	a		;; e9dd: 3c          <
	sta	tichit	; flag reached count
	lda	ticena		;; e9e1: 3a 0f ea    :..
	rrc			;; e9e4: 0f          .
	jrc	Le9f1	; ticena==1
ticret:	pop	psw		;; e9e7: f1          .
	pop	b		;; e9e8: c1          .
	pop	h		;; e9e9: e1          .
	lspd	savst2		;; e9ea: ed 7b 0a ea .{..
	ei			;; e9ee: fb          .
	reti			;; e9ef: ed 4d       .M

; call tick hook function before return to interrupted code.
Le9f1:	pop	psw		;; e9f1: f1          .
	pop	b		;; e9f2: c1          .
	pop	h		;; e9f3: e1          .
	lspd	savst2		;; e9f4: ed 7b 0a ea .{..
	push	h		;; e9f8: e5          .
	lhld	ticfnc		;; e9f9: 2a 10 ea    *..
	xthl			;; e9fc: e3          .
	ei			;; e9fd: fb          .
	reti			;; e9fe: ed 4d       .M

	dw	0,0,0,0,0
ticstk:	ds	0
savst2:	dw	0

; software sets ticcnt to number of ticks,
; optionally ticfnc to function to call, ticena to "1",
; waits for tichit to become "1" (or ticfnc to be called).
tichook:
tichit:	db	0	; flag for tick counter reaching 0
ticcnt:	dw	0	; tick counter, one-shot down-counter
ticena:	db	0	; enable for tick hook (D0=1)
ticfnc:	dw	0	; tick hook routine

; Setup tick hook.
; E=flag, HL=func, BC=count
; E=1: arm hook
; E=2: disarm hook
ticset:	mov	a,e		;; ea12: 7b          {
	sta	ticena		;; ea13: 32 0f ea    2..
	shld	ticfnc		;; ea16: 22 10 ea    "..
	lxi	h,ticcnt	;; ea19: 21 0d ea    ...
	mov	m,c		;; ea1c: 71          q
	inx	h		;; ea1d: 23          #
	mov	m,b		;; ea1e: 70          p
	ani	003h		;; ea1f: e6 03       ..
	cpi	001h		;; ea21: fe 01       ..
	jz	Lea2e		;; ea23: ca 2e ea    ...
	cpi	002h		;; ea26: fe 02       ..
	jz	Lea3b		;; ea28: ca 3b ea    .;.
	mvi	a,0ffh		;; ea2b: 3e ff       >.
	ret			;; ea2d: c9          .

; Arm tick hook
Lea2e:	di			;; ea2e: f3          .
	mvi	a,001h		;; ea2f: 3e 01       >.
	sta	Lfd11		;; ea31: 32 11 fd    2..
	ei			;; ea34: fb          .
	xra	a		;; ea35: af          .
Lea36:	lxi	h,tichit	;; ea36: 21 0c ea    ...
	mov	m,a		;; ea39: 77          w
	ret			;; ea3a: c9          .

; Disarm/abort tick hook
Lea3b:	di			;; ea3b: f3          .
	xra	a		;; ea3c: af          .
	sta	Lfd11		;; ea3d: 32 11 fd    2..
	ei			;; ea40: fb          .
	mvi	a,001h		;; ea41: 3e 01       >.
	jmp	Lea36		;; ea43: c3 36 ea    .6.

; process tick hook after I/O
ticfin:	di			;; ea46: f3          .
	lda	Lfd11		;; ea47: 3a 11 fd    :..
	cpi	002h		;; ea4a: fe 02       ..
	lda	Lfd12		;; ea4c: 3a 12 fd    :..
	sta	Lfd11		;; ea4f: 32 11 fd    2..
	jz	Lea7a		;; ea52: ca 7a ea    .z.
	ora	a		;; ea55: b7          .
	jz	Lea7a		;; ea56: ca 7a ea    .z.
	; tick fired while suspended, process it now
	push	h		;; ea59: e5          .
	lhld	ticcnt		;; ea5a: 2a 0d ea    *..
	dcx	h		;; ea5d: 2b          +
	mov	a,h		;; ea5e: 7c          |
	ora	l		;; ea5f: b5          .
	shld	ticcnt		;; ea60: 22 0d ea    "..
	jnz	Lea79		;; ea63: c2 79 ea    .y.
	mvi	a,1		;; ea66: 3e 01       >.
	sta	tichit		;; ea68: 32 0c ea    2..
	lda	ticena		;; ea6b: 3a 0f ea    :..
	rrc			;; ea6e: 0f          .
	jnc	Lea79		;; ea6f: d2 79 ea    .y.
	xra	a		;; ea72: af          .
	lhld	ticfnc		;; ea73: 2a 10 ea    *..
	xthl			;; ea76: e3          .
	ei			;; ea77: fb          .
	ret			;; ea78: c9          .

Lea79:	pop	h		;; ea79: e1          .
Lea7a:	ei			;; ea7a: fb          .
	xra	a		;; ea7b: af          .
	ret			;; ea7c: c9          .

; ASCII keyboard input
akbin:	call	kbdst		;; ea7d: cd 98 ea    ...
	jrz	akbin		;; ea80: 28 fb       (.
	dcr	m	; 1 => 0
	inx	h		;; ea83: 23          #
	mov	a,m	; get key
	ret			;; ea85: c9          .

; ASCII keyboard physical input (intr)
akbint:	push	psw		;; ea86: f5          .
	push	h		;; ea87: e5          .
	in	PIO_A		;; ea88: db 50       .P
	ani	07fh		;; ea8a: e6 7f       ..
	lxi	h,Lfd26		;; ea8c: 21 26 fd    .&.
	mvi	m,001h		;; ea8f: 36 01       6.
	inx	h		;; ea91: 23          #
	mov	m,a		;; ea92: 77          w
reti2:	pop	h		;; ea93: e1          .
	pop	psw		;; ea94: f1          .
nulint:	ei			;; ea95: fb          .
	reti			;; ea96: ed 4d       .M

; Generic keyboard input status (from interrupt).
kbdst:	lxi	h,Lfd26		;; ea98: 21 26 fd    .&.
Lea9b:	mov	a,m		;; ea9b: 7e          ~
	ora	a		;; ea9c: b7          .
	rz			;; ea9d: c8          .
	mvi	a,0ffh		;; ea9e: 3e ff       >.
	ret			;; eaa0: c9          .

; PC keyboard physical input (intr)
pckbint:
	push	psw		;; eaa1: f5          .
	push	h		;; eaa2: e5          .
	push	b		;; eaa3: c5          .
	push	d		;; eaa4: d5          .
	in	PIO1_A	; scan code
	mov	e,a		;; eaa7: 5f          _
	ani	07fh		;; eaa8: e6 7f       ..
	lxi	b,00006h	;; eaaa: 01 06 00    ...
	lxi	h,Leae4-1	;; eaad: 21 e3 ea    ...
	ccdr			;; eab0: ed b9       ..
	lxi	h,Leae4		;; eab2: 21 e4 ea    ...
	jrnz	Leae5		;; eab5: 20 2e        .
	mov	b,c	; index of match
	inr	b		;; eab8: 04          .
	mvi	a,040h	; convert meta-code into bitmap
Leabb:	rrc			;; eabb: 0f          .
	djnz	Leabb		;; eabc: 10 fd       ..
	mov	b,a		;; eabe: 47          G
	bit	7,e	; set or clear?
	jrnz	Leacf		;; eac1: 20 0c        .
	mov	a,b		;; eac3: 78          x
	cpi	010h		;; eac4: fe 10       ..
	jrnc	Leacc	; toggles...
	ora	m	; set bit
Leac9:	mov	m,a		;; eac9: 77          w
	jr	Lead7		;; eaca: 18 0b       ..

Leacc:	xra	m		;; eacc: ae          .
	jr	Leac9		;; eacd: 18 fa       ..

Leacf:	mov	a,b		;; eacf: 78          x
	cpi	010h		;; ead0: fe 10       ..
	jrnc	Lead7	; not for toggles...
	cma		; clear bit
	ana	m	;
	mov	m,a		;; ead6: 77          w
Lead7:	pop	d		;; ead7: d1          .
	pop	b		;; ead8: c1          .
	pop	h		;; ead9: e1          .
	pop	psw		;; eada: f1          .
	ei			;; eadb: fb          .
	reti			;; eadc: ed 4d       .M

; keyboard scan codes - meta keys
; bit 7 indicates "key released"
	db	3ah	; Caps Lock	D5 (toggle)
	db	45h	; Num Lock	D4 (toggle)
	db	38h	; l/r Alt	D3
	db	1dh	; l/r Ctrl	D2
	db	2ah	; left Shift	D1
	db	36h	; right Shift	D0
Leae4:	db	0

Leae5:	bit	7,e		;; eae5: cb 7b       .{
	jrnz	Lead7		;; eae7: 20 ee        .
	sta	Lfd27		;; eae9: 32 27 fd    2'.
	sta	Lfd26		;; eaec: 32 26 fd    2&.
	mov	a,m		;; eaef: 7e          ~
	sta	Lfd28		;; eaf0: 32 28 fd    2(.
	jr	Lead7		;; eaf3: 18 e2       ..

; PC keyboard input - convert scan code to ASCII
pckbin:	call	kbdst		;; eaf5: cd 98 ea    ...
	inr	a		;; eaf8: 3c          <
	jrnz	pckbin		;; eaf9: 20 fa        .
	mov	m,a	; clear flag
	inx	h		;; eafc: 23          #
	mov	c,m	; get key
	inx	h		;; eafe: 23          #
	mov	e,m	; get meta
	mov	a,c		;; eb00: 79          y
	cpi	71		;; eb01: fe 47       .G
	jrc	Leb0c		;; eb03: 38 07       8.
	; numeric keypad codes...
	bit	4,e	; Num Lock?
	jrz	Leb0c		;; eb07: 28 03       (.
	adi	13		;; eb09: c6 0d       ..
	mov	c,a		;; eb0b: 4f          O
Leb0c:	lxi	h,Leb4b-1	;; eb0c: 21 4a eb    .J.
	mvi	b,0		;; eb0f: 06 00       ..
	dad	b		;; eb11: 09          .
	mov	a,m		;; eb12: 7e          ~
	cpi	'a'		;; eb13: fe 61       .a
	jrc	Leb30		;; eb15: 38 19       8.
	cpi	'z'+1		;; eb17: fe 7b       .{
	jrnc	Leb30		;; eb19: 30 15       0.
	bit	5,e	; Caps Lock?
	jrz	Leb21		;; eb1d: 28 02       (.
	xri	020h	; flip case
Leb21:	mov	b,a		;; eb21: 47          G
	mov	a,e		;; eb22: 7b          {
	ani	003h	; left/right SHIFT keys
	mov	a,b		;; eb25: 78          x
	jrz	Leb2a		;; eb26: 28 02       (.
	xri	020h	; flip case
Leb2a:	bit	2,e	; Ctrl active?
	rz		; no - pass unchanged
	ani	01fh	; convert to control
	ret			;; eb2f: c9          .

Leb30:	cpi	' '+1		;; eb30: fe 21       ..
	jrnc	Leb36		;; eb32: 30 02       0.
	ora	a	; blank or ctl codes (?)
	ret			;; eb35: c9          .

Leb36:	bit	7,a	; special mapping keys
	rz			;; eb38: c8          .
	ani	07fh		;; eb39: e6 7f       ..
	mov	c,a		;; eb3b: 4f          O
	mov	a,e		;; eb3c: 7b          {
	ani	003h		;; eb3d: e6 03       ..
	lxi	h,Lebab-1	;; eb3f: 21 aa eb    ...
	jrz	Leb47		;; eb42: 28 03       (.
	lxi	h,Lebc1-1	;; eb44: 21 c0 eb    ...
Leb47:	dad	b		;; eb47: 09          .
	mov	a,m		;; eb48: 7e          ~
	jr	Leb2a		;; eb49: 18 df       ..

; Keyboard scan code map to ASCII
Leb4b:	db	ESC,81h,82h,83h,84h,85h,86h,87h,88h,89h,8ah,8bh,8ch,BS
	db	TAB,'qwertyuiop',8dh,8eh,CR
	db	NIL,'asdfghjkl',8fh,90h,91h,NIL
	db	92h,'zxcvbnm',93h,94h,95h,NIL,96h
	db	NIL,' ',NIL
	; function keys, left of main, vertical
	db	DC3,EOT,SOH,ACK,ENQ	; F1-F5
	db	DC2,CAN,ETX, SO, SI	; F6-F10
	db	0	; (Num Lock)
	db	0	; (Scroll Lock)
	; Keypad, NumLock off, right of main
	db	SYN,SUB,ETB,'-'	; home,   up,  PgUp, -
	db	 BS, GS,NAK,'+'	; left,  ---, right, +
	db	ACK, LF,ENQ	;  end, down,  PgDn
	db	DC2,    DEL	;  Ins 	        Del
	; Keypad, NumLock on
	db	'7','8','9','-'
	db	'4','5','6','+'
	db	'1','2','3'
	db	'0',    '.'

; special key maps - unshifted
Lebab:	db	'1234567890-='	; 81h-8ch (top row)
	db	'[]'		; 8dh-8eh
	db	';''`'		; 8fh-91h
	db	'\'		; 92h
	db	',./'		; 93h-95h
	db	'*'		; 96h

; special key maps - shifted
Lebc1:	db	'!@#$%^&*()_+'	; (top row)
	db	'{}'
	db	':"~'
	db	'|'
	db	'<>?'
	db	98h	; PRSC - print screen

lptout:	in	PP_C		;; ebd7: db 02       ..
Lebd9:	ani	060h	; BS1/BSENS
	cpi	020h	; BS1=0, BSENS=1
	jrnz	Lec0f	; LPT: not attached
Lebdf:	lxi	d,0		;; ebdf: 11 00 00    ...
	mvi	b,10		;; ebe2: 06 0a       ..
	lxi	h,lptbsy	;; ebe4: 21 29 fd    .).
Lebe7:	mov	a,m		;; ebe7: 7e          ~
	ora	a		;; ebe8: b7          .
	jrz	Lec03		;; ebe9: 28 18       (.
	dcx	d		;; ebeb: 1b          .
	mov	a,e		;; ebec: 7b          {
	ora	d		;; ebed: b2          .
	jrnz	Lebe7		;; ebee: 20 f7        .
	djnz	Lebe7		;; ebf0: 10 f5       ..
	call	print		;; ebf2: cd 67 e6    .g.
	db	CR,LF,'LPT$'
	call	Le640		;; ebfb: cd 40 e6    .@.
	jrnz	Lebdf		;; ebfe: 20 df        .
	jmp	cpm		;; ec00: c3 00 00    ...

Lec03:	dcr	m	; set BUSY
	in	PP_C		;; ec04: db 02       ..
	ani	010h	; BS0 - LPT: data inverted?
	mov	a,c		;; ec08: 79          y
	jrnz	Lec0c		;; ec09: 20 01        .
	cma			;; ec0b: 2f          /
Lec0c:	out	PIO_B		;; ec0c: d3 51       .Q
	ret			;; ec0e: c9          .

Lec0f:	call	print		;; ec0f: cd 67 e6    .g.
	db	7,CR,LF,'LPT not coupled.  Waiting...$'
	call	ctrlC		;; ec32: cd 37 ec    .7.
	jr	lptout		;; ec35: 18 a0       ..

; Wait for key, if ^C then reboot
ctrlC:	push	b		;; ec37: c5          .
	call	conin		;; ec38: cd 58 e9    .X.
	pop	b		;; ec3b: c1          .
	cpi	CTLC		;; ec3c: fe 03       ..
	rnz			;; ec3e: c0          .
	jmp	cpm		;; ec3f: c3 00 00    ...

lptint:	push	psw		;; ec42: f5          .
	xra	a		;; ec43: af          .
	sta	lptbsy		;; ec44: 32 29 fd    2).
	pop	psw		;; ec47: f1          .
	ei			;; ec48: fb          .
	reti			;; ec49: ed 4d       .M

uc1st:	lxi	h,bffcnt	;; ec4b: 21 1d fd    ...
	jmp	Lea9b		;; ec4e: c3 9b ea    ...

Lec51:	lxi	h,affcnt	;; ec51: 21 18 fd    ...
	jmp	Lea9b		;; ec54: c3 9b ea    ...

Lec57:	sta	Lec6f		;; ec57: 32 6f ec    2o.
	cpi	'A'		;; ec5a: fe 41       .A
	lda	Lfd21		;; ec5c: 3a 21 fd    :..
	jrz	Lec64		;; ec5f: 28 03       (.
	lda	Lfd25		;; ec61: 3a 25 fd    :%.
Lec64:	rlc			;; ec64: 07          .
	rc			;; ec65: d8          .
	call	print		;; ec66: cd 67 e6    .g.
	db	CR,LF,'SIO/'
Lec6f:	db	'? ERROR',16h,'$'
	jmp	ctrlC		;; ec78: c3 37 ec    .7.

arxint:	sspd	rxsav		;; ec7b: ed 73 a5 ee .s..
	lxi	sp,rxstk	;; ec7f: 31 a5 ee    1..
	push	psw		;; ec82: f5          .
	push	h		;; ec83: e5          .
	push	b		;; ec84: c5          .
	in	SIO_A		;; ec85: db 10       ..
	lxi	h,Lfd21		;; ec87: 21 21 fd    ...
	ana	m		;; ec8a: a6          .
	mov	b,a		;; ec8b: 47          G
	dcx	h		;; ec8c: 2b          +
	mov	a,m		;; ec8d: 7e          ~
	rrc			;; ec8e: 0f          .
	jrc	Lec9d		;; ec8f: 38 0c       8.
	mov	a,b		;; ec91: 78          x
	cpi	XON		;; ec92: fe 11       ..
	jrz	Lecd9		;; ec94: 28 43       (C
	cpi	XOFF		;; ec96: fe 13       ..
	jrz	Lecd2		;; ec98: 28 38       (8
	ora	a		;; ec9a: b7          .
	jrz	Lecbe		;; ec9b: 28 21       (.
Lec9d:	lxi	h,affcnt	;; ec9d: 21 18 fd    ...
	mov	a,m		;; eca0: 7e          ~
	cpi	127		;; eca1: fe 7f       ..
	jrnc	Lecc8		;; eca3: 30 23       0#
	inr	m		;; eca5: 34          4
	lhld	awrptr		;; eca6: 2a 14 fd    *..
	mov	m,b		;; eca9: 70          p
	inx	h		;; ecaa: 23          #
	shld	awrptr		;; ecab: 22 14 fd    "..
	lxi	b,0018fh	;; ecae: 01 8f 01    ...
	dad	b		;; ecb1: 09          .
	jrnc	Lecba		;; ecb2: 30 06       0.
	lxi	h,Lfdf2		;; ecb4: 21 f2 fd    ...
	shld	awrptr		;; ecb7: 22 14 fd    "..
Lecba:	cpi	95		;; ecba: fe 5f       ._
	jrnc	Lece4		;; ecbc: 30 26       0&
Lecbe:	pop	b		;; ecbe: c1          .
	pop	h		;; ecbf: e1          .
	pop	psw		;; ecc0: f1          .
	lspd	rxsav		;; ecc1: ed 7b a5 ee .{..
Lecc5:	ei			;; ecc5: fb          .
	reti			;; ecc6: ed 4d       .M

Lecc8:	lda	ffoflg		;; ecc8: 3a 13 fd    :..
	ori	0100b		;; eccb: f6 04       ..
Leccd:	sta	ffoflg		;; eccd: 32 13 fd    2..
	jr	Lecbe		;; ecd0: 18 ec       ..

Lecd2:	lda	ffoflg		;; ecd2: 3a 13 fd    :..
	ori	0001b		;; ecd5: f6 01       ..
	jr	Leccd		;; ecd7: 18 f4       ..

Lecd9:	lda	ffoflg		;; ecd9: 3a 13 fd    :..
	bit	0,a		;; ecdc: cb 47       .G
	jrz	Lec9d		;; ecde: 28 bd       (.
	ani	11111110b	;; ece0: e6 fe       ..
	jr	Leccd		;; ece2: 18 e9       ..

; high-water mark SIO A
Lece4:	lda	ffoflg		;; ece4: 3a 13 fd    :..
	bit	1,a		;; ece7: cb 4f       .O
	jrnz	Lecbe		;; ece9: 20 d3        .
	ori	0010b		;; eceb: f6 02       ..
	sta	ffoflg		;; eced: 32 13 fd    2..
	pop	b		;; ecf0: c1          .
	pop	h		;; ecf1: e1          .
	pop	psw		;; ecf2: f1          .
	lspd	rxsav		;; ecf3: ed 7b a5 ee .{..
	sspd	axosav		;; ecf7: ed 73 b1 ee .s..
	lxi	sp,axostk	;; ecfb: 31 b1 ee    1..
	push	psw		;; ecfe: f5          .
	push	b		;; ecff: c5          .
	call	Lecc5		;; ed00: cd c5 ec    ...
	mvi	c,XOFF		;; ed03: 0e 13       ..
	call	Led6d		;; ed05: cd 6d ed    .m.
	pop	b		;; ed08: c1          .
	pop	psw		;; ed09: f1          .
	lspd	axosav		;; ed0a: ed 7b b1 ee .{..
	ret			;; ed0e: c9          .

aspint:	push	psw		;; ed0f: f5          .
	lda	ffoflg		;; ed10: 3a 13 fd    :..
	ori	0100b		;; ed13: f6 04       ..
	sta	ffoflg		;; ed15: 32 13 fd    2..
	mvi	a,030h		;; ed18: 3e 30       >0
	out	SIO_AC		;; ed1a: d3 12       ..
	in	SIO_A		;; ed1c: db 10       ..
	jr	Led25		;; ed1e: 18 05       ..

axtint:	push	psw		;; ed20: f5          .
	mvi	a,010h		;; ed21: 3e 10       >.
	out	SIO_AC		;; ed23: d3 12       ..
Led25:	pop	psw		;; ed25: f1          .
	ei			;; ed26: fb          .
	reti			;; ed27: ed 4d       .M

Led29:	ani	0fbh		;; ed29: e6 fb       ..
	mov	m,a		;; ed2b: 77          w
	mvi	a,041h		;; ed2c: 3e 41       >A
	call	Lec57		;; ed2e: cd 57 ec    .W.
	jr	Led37		;; ed31: 18 04       ..

Led33:	ei			;; ed33: fb          .
	call	Led61		;; ed34: cd 61 ed    .a.
Led37:	lxi	h,ffoflg	;; ed37: 21 13 fd    ...
	mov	a,m		;; ed3a: 7e          ~
	bit	2,a		;; ed3b: cb 57       .W
	jrnz	Led29		;; ed3d: 20 ea        .
	di			;; ed3f: f3          .
	lxi	h,affcnt	;; ed40: 21 18 fd    ...
	mov	a,m		;; ed43: 7e          ~
	ora	a		;; ed44: b7          .
	jrz	Led33		;; ed45: 28 ec       (.
	dcr	m		;; ed47: 35          5
	ei			;; ed48: fb          .
	cz	Led61		;; ed49: cc 61 ed    .a.
	lhld	ardptr		;; ed4c: 2a 16 fd    *..
	mov	a,m		;; ed4f: 7e          ~
	inx	h		;; ed50: 23          #
	shld	ardptr		;; ed51: 22 16 fd    "..
	lxi	b,0018fh	;; ed54: 01 8f 01    ...
	dad	b		;; ed57: 09          .
	rnc			;; ed58: d0          .
	lxi	h,Lfdf2		;; ed59: 21 f2 fd    ...
	shld	ardptr		;; ed5c: 22 16 fd    "..
	cmc			;; ed5f: 3f          ?
	ret			;; ed60: c9          .

Led61:	lxi	h,ffoflg	;; ed61: 21 13 fd    ...
	mov	a,m		;; ed64: 7e          ~
	bit	1,a		;; ed65: cb 4f       .O
	rz			;; ed67: c8          .
	ani	0fdh		;; ed68: e6 fd       ..
	mov	m,a		;; ed6a: 77          w
	mvi	c,XON		;; ed6b: 0e 11       ..
Led6d:	in	SIO_AC		;; ed6d: db 12       ..
	bit	5,a		;; ed6f: cb 6f       .o
	stc			;; ed71: 37          7
	rz			;; ed72: c8          .
	ani	004h		;; ed73: e6 04       ..
	jrz	Led6d		;; ed75: 28 f6       (.
	mov	a,c		;; ed77: 79          y
	out	SIO_A		;; ed78: d3 10       ..
	ret			;; ed7a: c9          .

Led7b:	lda	ffoflg		;; ed7b: 3a 13 fd    :..
	ani	0001b		;; ed7e: e6 01       ..
	jrnz	Led7b		;; ed80: 20 f9        .
	call	Led6d		;; ed82: cd 6d ed    .m.
	rnc			;; ed85: d0          .
	mvi	a,'A'		;; ed86: 3e 41       >A
	call	Lec57		;; ed88: cd 57 ec    .W.
	jr	Led7b		;; ed8b: 18 ee       ..

brxint:	sspd	rxsav		;; ed8d: ed 73 a5 ee .s..
	lspd	rxsav		;; ed91: ed 7b a5 ee .{..
	push	psw		;; ed95: f5          .
	push	h		;; ed96: e5          .
	push	b		;; ed97: c5          .
	in	SIO_B		;; ed98: db 11       ..
	lxi	h,Lfd25		;; ed9a: 21 25 fd    .%.
	ana	m		;; ed9d: a6          .
	mov	b,a		;; ed9e: 47          G
	dcx	h		;; ed9f: 2b          +
	mov	a,m		;; eda0: 7e          ~
	rrc			;; eda1: 0f          .
	jrc	Ledb1		;; eda2: 38 0d       8.
	mov	a,b		;; eda4: 78          x
	cpi	XON		;; eda5: fe 11       ..
	jrz	Lede5		;; eda7: 28 3c       (<
	cpi	XOFF		;; eda9: fe 13       ..
	jrz	Leddd		;; edab: 28 30       (0
	ora	a		;; edad: b7          .
	jz	Lecbe		;; edae: ca be ec    ...
Ledb1:	lxi	h,bffcnt	;; edb1: 21 1d fd    ...
	mov	a,m		;; edb4: 7e          ~
	cpi	127		;; edb5: fe 7f       ..
	jrnc	Ledd5		;; edb7: 30 1c       0.
	inr	m		;; edb9: 34          4
	lhld	bwrptr		;; edba: 2a 19 fd    *..
	mov	m,b		;; edbd: 70          p
	inx	h		;; edbe: 23          #
	shld	bwrptr		;; edbf: 22 19 fd    "..
	lxi	b,0010fh	;; edc2: 01 0f 01    ...
	dad	b		;; edc5: 09          .
	jrnc	Ledce		;; edc6: 30 06       0.
	; wrap buffer
	lxi	h,Lfe72		;; edc8: 21 72 fe    .r.
	shld	bwrptr		;; edcb: 22 19 fd    "..
Ledce:	cpi	95	; high water mark?
	jrnc	Ledf1		;; edd0: 30 1f       0.
	jmp	Lecbe		;; edd2: c3 be ec    ...

Ledd5:	lda	ffoflg		;; edd5: 3a 13 fd    :..
	ori	040h	; dropped chars
	jmp	Leccd		;; edda: c3 cd ec    ...

Leddd:	lda	ffoflg		;; eddd: 3a 13 fd    :..
	ori	010h		;; ede0: f6 10       ..
	jmp	Leccd		;; ede2: c3 cd ec    ...

Lede5:	lda	ffoflg		;; ede5: 3a 13 fd    :..
	bit	4,a		;; ede8: cb 67       .g
	jrz	Ledb1		;; edea: 28 c5       (.
	ani	11101111b	;; edec: e6 ef       ..
	jmp	Leccd		;; edee: c3 cd ec    ...

; high-water mark for SIO B
Ledf1:	lda	ffoflg		;; edf1: 3a 13 fd    :..
	bit	5,a		;; edf4: cb 6f       .o
	jnz	Lecbe		;; edf6: c2 be ec    ...
	ori	00100000b	;; edf9: f6 20       . 
	sta	ffoflg		;; edfb: 32 13 fd    2..
	pop	b		;; edfe: c1          .
	pop	h		;; edff: e1          .
	pop	psw		;; ee00: f1          .
	lspd	rxsav		;; ee01: ed 7b a5 ee .{..
	sspd	bxosav		;; ee05: ed 73 bd ee .s..
	lxi	sp,bxostk	;; ee09: 31 bd ee    1..
	push	psw		;; ee0c: f5          .
	push	b		;; ee0d: c5          .
	call	Lecc5		;; ee0e: cd c5 ec    ...
	mvi	c,XOFF		;; ee11: 0e 13       ..
	call	uc1pot		;; ee13: cd 7b ee    .{.
	pop	b		;; ee16: c1          .
	pop	psw		;; ee17: f1          .
	lspd	bxosav		;; ee18: ed 7b bd ee .{..
	ret			;; ee1c: c9          .

; SIO B special condition intr
bspint:	push	psw		;; ee1d: f5          .
	lda	ffoflg		;; ee1e: 3a 13 fd    :..
	ori	01000000b	;; ee21: f6 40       .@
	sta	ffoflg		;; ee23: 32 13 fd    2..
	mvi	a,030h		;; ee26: 3e 30       >0
	out	SIO_BC		;; ee28: d3 13       ..
	in	SIO_B		;; ee2a: db 11       ..
	jmp	Led25		;; ee2c: c3 25 ed    .%.

bxtint:	push	psw		;; ee2f: f5          .
	mvi	a,010h		;; ee30: 3e 10       >.
	out	SIO_BC		;; ee32: d3 13       ..
	jmp	Led25		;; ee34: c3 25 ed    .%.

Lee37:	ani	10111111b	;; ee37: e6 bf       ..
	mov	m,a		;; ee39: 77          w
	mvi	a,'B'		;; ee3a: 3e 42       >B
	call	Lec57		;; ee3c: cd 57 ec    .W.
	jr	uc1in		;; ee3f: 18 04       ..

; get char from FIFO
Lee41:	ei			;; ee41: fb          .
	call	Lee6f		;; ee42: cd 6f ee    .o.
uc1in:	lxi	h,ffoflg	;; ee45: 21 13 fd    ...
	mov	a,m		;; ee48: 7e          ~
	bit	6,a		;; ee49: cb 77       .w
	jrnz	Lee37		;; ee4b: 20 ea        .
	di			;; ee4d: f3          .
	lxi	h,bffcnt	;; ee4e: 21 1d fd    ...
	mov	a,m		;; ee51: 7e          ~
	ora	a		;; ee52: b7          .
	jrz	Lee41		;; ee53: 28 ec       (.
	dcr	m		;; ee55: 35          5
	ei			;; ee56: fb          .
	cz	Lee6f		;; ee57: cc 6f ee    .o.
	lhld	brdptr		;; ee5a: 2a 1b fd    *..
	mov	a,m		;; ee5d: 7e          ~
	inx	h		;; ee5e: 23          #
	shld	brdptr		;; ee5f: 22 1b fd    "..
	lxi	b,0010fh	;; ee62: 01 0f 01    ...
	dad	b		;; ee65: 09          .
	rnc			;; ee66: d0          .
	lxi	h,Lfe72		;; ee67: 21 72 fe    .r.
	shld	brdptr		;; ee6a: 22 1b fd    "..
	cmc			;; ee6d: 3f          ?
	ret			;; ee6e: c9          .

Lee6f:	lxi	h,ffoflg	;; ee6f: 21 13 fd    ...
	mov	a,m		;; ee72: 7e          ~
	bit	5,a		;; ee73: cb 6f       .o
	rz			;; ee75: c8          .
	ani	11011111b	;; ee76: e6 df       ..
	mov	m,a		;; ee78: 77          w
	mvi	c,XON		;; ee79: 0e 11       ..
uc1pot:	in	SIO_BC		;; ee7b: db 13       ..
	bit	5,a		;; ee7d: cb 6f       .o
	stc			;; ee7f: 37          7
	rz			;; ee80: c8          .
	ani	004h		;; ee81: e6 04       ..
	jrz	uc1pot		;; ee83: 28 f6       (.
	mov	a,c		;; ee85: 79          y
	out	SIO_B		;; ee86: d3 11       ..
	ret			;; ee88: c9          .

; UC1: output
uc1out:	lda	ffoflg		;; ee89: 3a 13 fd    :..
	ani	010h		;; ee8c: e6 10       ..
	jrnz	uc1out		;; ee8e: 20 f9        .
	call	uc1pot		;; ee90: cd 7b ee    .{.
	rnc			;; ee93: d0          .
	mvi	a,'B'		;; ee94: 3e 42       >B
	call	Lec57		;; ee96: cd 57 ec    .W.
	jr	uc1out		;; ee99: 18 ee       ..

	dw	0,0,0,0,0
rxstk:	ds	0
rxsav:	dw	0

	dw	0,0,0,0,0
axostk:	ds	0
axosav:	dw	0

	dw	0,0,0,0,0
bxostk:	ds	0
bxosav:	dw	0

Leebf:	call	ticsus		;; eebf: cd 08 ef    ...
	sspd	crtsav		;; eec2: ed 73 f0 fd .s..
	lxi	sp,crtstk	;; eec6: 31 f0 fd    1..
	pushix			;; eec9: dd e5       ..
	lxix	crtstr		;; eecb: dd 21 0c f5 ....
	lda	crtstr+14	;; eecf: 3a 1a f5    :..
	setb	2,a	; enable WR vid ram
	out	CRT_CTL		;; eed4: d3 62       .b
	call	Lef13		;; eed6: cd 13 ef    ...
Leed9:	lda	crtstr+14	;; eed9: 3a 1a f5    :..
	out	CRT_CTL		;; eedc: d3 62       .b
	popix			;; eede: dd e1       ..
	lspd	crtsav		;; eee0: ed 7b f0 fd .{..
	jmp	ticfin		;; eee4: c3 46 ea    .F.

Leee7:	call	ticsus		;; eee7: cd 08 ef    ...
	sspd	crtsav		;; eeea: ed 73 f0 fd .s..
	lxi	sp,crtstk	;; eeee: 31 f0 fd    1..
	pushix			;; eef1: dd e5       ..
	lxix	crtstr		;; eef3: dd 21 0c f5 ....
	lda	crtstr+14	;; eef7: 3a 1a f5    :..
	setb	2,a	; enable CRT RAM access
	out	CRT_CTL		;; eefc: d3 62       .b
	mvi	a,020h		;; eefe: 3e 20       > 
	call	crttgl	; set mode bit
	call	crtupd	; update attr/pos
	jr	Leed9		;; ef06: 18 d1       ..

; suspend any tick hook action
ticsus:	di			;; ef08: f3          .
	lxi	h,Lfd11		;; ef09: 21 11 fd    ...
	mov	a,m		;; ef0c: 7e          ~
	mvi	m,002h		;; ef0d: 36 02       6.
	inx	h		;; ef0f: 23          #
	mov	m,a		;; ef10: 77          w
	ei			;; ef11: fb          .
	ret			;; ef12: c9          .

Lef13:	lxi	h,crtstr+4	;; ef13: 21 10 f5    ...
	mov	a,m		;; ef16: 7e          ~
	ora	a		;; ef17: b7          .
	jnz	Lf0f8	; ESC prefix
	mov	a,c		;; ef1b: 79          y
	bitx	6,+2		;; ef1c: dd cb 02 76 ...v
	jrnz	Lef27		;; ef20: 20 05        .
	ani	07fh		;; ef22: e6 7f       ..
	cpi	DEL		;; ef24: fe 7f       ..
	rz			;; ef26: c8          .
Lef27:	cpi	' '		;; ef27: fe 20       . 
	jrc	Lef37		;; ef29: 38 0c       8.
	lhld	crtstr+7	;; ef2b: 2a 13 f5    *..
	mov	m,a		;; ef2e: 77          w
	lda	crtstr+11	;; ef2f: 3a 17 f5    :..
	sta	crtstr+9	;; ef32: 32 15 f5    2..
	jr	Lef47		;; ef35: 18 10       ..

Lef37:	lxi	h,Lf2cc		;; ef37: 21 cc f2    ...
	lxi	b,nf2cc		;; ef3a: 01 0d 00    ...
	lxi	d,Lf2f1		;; ef3d: 11 f1 f2    ...
	jmp	Lf190		;; ef40: c3 90 f1    ...

; NAK / ESC C processing
; move right? (wrap to next row - if enabled)
curri:	setx	5,+3		;; ef43: dd cb 03 ee ....
Lef47:	lda	crtstr+0	;; ef47: 3a 0c f5    :..
	cmpx	+5		;; ef4a: dd be 05    ...
	jrnc	Lef54		;; ef4d: 30 05       0.
	inrx	+0		;; ef4f: dd 34 00    .4.
	jr	Lefa2		;; ef52: 18 4e       .N
; at rightmost col
Lef54:	bitx	1,+2		;; ef54: dd cb 02 4e ...N
	rz			;; ef58: c8          .
	mvix	0,+0		;; ef59: dd 36 00 00 .6..
	lda	crtstr+1	;; ef5d: 3a 0d f5    :..
	cmpx	+6		;; ef60: dd be 06    ...
	jrnc	Lef6e		;; ef63: 30 09       0.
Lef65:	inrx	+1		;; ef65: dd 34 01    .4.
	cpi	11		;; ef68: fe 0b       ..
	jrnz	Lefa2		;; ef6a: 20 36        6
	jr	Lef87		;; ef6c: 18 19       ..
; at bottom of screen
Lef6e:	bitx	5,+3		;; ef6e: dd cb 03 6e ...n
	jrnz	Lef7d		;; ef72: 20 09        .
	bitx	3,+2		;; ef74: dd cb 02 5e ...^
	jrz	Lef7d		;; ef78: 28 03       (.
	call	conin		;; ef7a: cd 58 e9    .X.
Lef7d:	bitx	0,+2		;; ef7d: dd cb 02 46 ...F
	jrz	Lef9b		;; ef81: 28 18       (.
	mvix	0,+1		;; ef83: dd 36 01 00 .6..
Lef87:	bitx	5,+3		;; ef87: dd cb 03 6e ...n
	jrnz	Lefa2		;; ef8b: 20 15        .
	call	crtupd		;; ef8d: cd e8 ef    ...
	bitx	4,+2		;; ef90: dd cb 02 66 ...f
	rz			;; ef94: c8          .
	mvi	a,12-1		;; ef95: 3e 0b       >.
	inr	a	; A=12, NZ
	jmp	Lf1b6		;; ef98: c3 b6 f1    ...

Lef9b:	resx	5,+3		;; ef9b: dd cb 03 ae ....
	jmp	Lf09e		;; ef9f: c3 9e f0    ...

Lefa2:	resx	5,+3		;; efa2: dd cb 03 ae ....
	jr	crtupd		;; efa6: 18 40       .@

; TAB to next 8th col
Lefa8:	lda	crtstr+0	;; efa8: 3a 0c f5    :..
	ani	11111000b	;; efab: e6 f8       ..
	adi	8		;; efad: c6 08       ..
	cmpx	+5		;; efaf: dd be 05    ...
	jrc	Lefb5		;; efb2: 38 01       8.
	dcr	a		;; efb4: 3d          =
Lefb5:	sta	crtstr+0	;; efb5: 32 0c f5    2..
	jr	crtupd		;; efb8: 18 2e       ..

curle:	lda	crtstr+0	;; efba: 3a 0c f5    :..
	ora	a		;; efbd: b7          .
	jrz	Lefc5		;; efbe: 28 05       (.
	dcrx	+0		;; efc0: dd 35 00    .5.
	jr	crtupd		;; efc3: 18 23       .#

Lefc5:	bitx	1,+2		;; efc5: dd cb 02 4e ...N
	rz			;; efc9: c8          .
	; reverse-wrap line
	lda	crtstr+5	;; efca: 3a 11 f5    :..
	sta	crtstr+0	;; efcd: 32 0c f5    2..
	lda	crtstr+1	;; efd0: 3a 0d f5    :..
	ora	a		;; efd3: b7          .
	jrnz	Lefe5		;; efd4: 20 0f        .
	bitx	0,+2		;; efd6: dd cb 02 46 ...F
	jz	Lf08d		;; efda: ca 8d f0    ...
	; reverse wrap screen
	lda	crtstr+6	;; efdd: 3a 12 f5    :..
	sta	crtstr+1	;; efe0: 32 0d f5    2..
	jr	crtupd		;; efe3: 18 03       ..

Lefe5:	dcrx	+1		;; efe5: dd 35 01    .5.
; update cursor position/etc
crtupd:	lhld	crtstr+7	; cursor location
	lda	crtstr+9	;; efeb: 3a 15 f5    :..
	inx	h		;; efee: 23          #
	mov	m,a	; restore mode at cursor
	lda	crtstr+1	; row
	ldx	e,+0		; col
	call	crtadr		; compute new position
	shld	crtstr+7	; set new cursor adr
Leffc:	inx	h		;; effc: 23          #
	mov	a,m		;; effd: 7e          ~
	sta	crtstr+9	; cache mode
	bitx	5,+2		;; f001: dd cb 02 6e ...n
	rnz			;; f005: c0          .
	; show cursor as rev-vid
	cma			;; f006: 2f          /
	mov	m,a		;; f007: 77          w
	ret			;; f008: c9          .

curdn:	lda	crtstr+1	;; f009: 3a 0d f5    :..
	cmpx	+6		;; f00c: dd be 06    ...
	jrnc	Lf016		;; f00f: 30 05       0.
	inrx	+1		;; f011: dd 34 01    .4.
	jr	crtupd		;; f014: 18 d2       ..

Lf016:	bitx	0,+2		;; f016: dd cb 02 46 ...F
	rz			;; f01a: c8          .
	mvix	0,+1		;; f01b: dd 36 01 00 .6..
	jr	crtupd		;; f01f: 18 c7       ..

curup:	xra	a		;; f021: af          .
	cmpx	+1		;; f022: dd be 01    ...
	jrnc	Lf02c		;; f025: 30 05       0.
Lf027:	dcrx	+1		;; f027: dd 35 01    .5.
	jr	crtupd		;; f02a: 18 bc       ..

Lf02c:	bitx	0,+2		;; f02c: dd cb 02 46 ...F
	rz			;; f030: c8          .
	lda	crtstr+6	;; f031: 3a 12 f5    :..
	sta	crtstr+1	;; f034: 32 0d f5    2..
	jr	crtupd		;; f037: 18 af       ..

; carriage return (possible auto-linefeed)
; A=CR
Lf039:	mvix	0,+0		;; f039: dd 36 00 00 .6..
	bitx	2,+2		;; f03d: dd cb 02 56 ...V
	jrz	crtupd		;; f041: 28 a5       (.
Lf043:	lda	crtstr+1	;; f043: 3a 0d f5    :..
	cmpx	+6		;; f046: dd be 06    ...
	jnc	Lef7d		;; f049: d2 7d ef    .}.
	jmp	Lef65		;; f04c: c3 65 ef    .e.

Lf04f:	resx	0,+2	; ESC I - turn off screen wrap?
clrscr:	mvi	a,004h	; off, ena RAM
	out	CRT_CTL		;; f055: d3 62       .b
	lda	crtstr+11	;; f057: 3a 17 f5    :..
	sta	crtstr+9	;; f05a: 32 15 f5    2..
	xra	a		;; f05d: af          .
	sta	crtstr+10	;; f05e: 32 16 f5    2..
	call	Lf19e		;; f061: cd 9e f1    ...
	di			;; f064: f3          .
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3		;; f067: d3 23       .#
	mvi	a,001h	; TC=1 (immediate)
	out	CTC1_3		;; f06b: d3 23       .#
	ei			;; f06d: fb          .
	mvi	b,001h		;; f06e: 06 01       ..
	ldx	e,+11		;; f070: dd 5e 0b    .^.
	bitx	1,+3		;; f073: dd cb 03 4e ...N
	jrz	Lf07b		;; f077: 28 02       (.
	mvi	e,007h		;; f079: 1e 07       ..
Lf07b:	call	Lf1a9		;; f07b: cd a9 f1    ...
curhom:	lxi	h,0		;; f07e: 21 00 00    ...
	shld	crtstr+0	;; f081: 22 0c f5    "..
	jmp	crtupd		;; f084: c3 e8 ef    ...

revidx:	lda	crtstr+1	; cursor row...
	ora	a		;; f08a: b7          .
	jrnz	Lf027	; OK to decr
	; must scroll backwards...
Lf08d:	lda	crtstr+10	;; f08d: 3a 16 f5    :..
	ora	a		;; f090: b7          .
	jrz	Lf098	; at top row?
	dcrx	+10		;; f093: dd 35 0a    .5.
	jr	Lf0ae		;; f096: 18 16       ..

Lf098:	mvix	24,+10		;; f098: dd 36 0a 18 .6..
	jr	Lf0ae		;; f09c: 18 10       ..

Lf09e:	lda	crtstr+10	;; f09e: 3a 16 f5    :..
	cpi	24		;; f0a1: fe 18       ..
	jrnc	Lf0aa		;; f0a3: 30 05       0.
	inrx	+10		;; f0a5: dd 34 0a    .4.
	jr	Lf0ae		;; f0a8: 18 04       ..
Lf0aa:	mvix	0,+10		;; f0aa: dd 36 0a 00 .6..
Lf0ae:	di			;; f0ae: f3          .
	mvi	a,0cfh		;; f0af: 3e cf       >.
	out	CTC1_3	; intr, ctr, falling, TC, reset
	mvi	a,001h		;; f0b3: 3e 01       >.
	out	CTC1_3		;; f0b5: d3 23       .#
	ei			;; f0b7: fb          .
	bitx	1,+3		;; f0b8: dd cb 03 4e ...N
	jrz	Lf0cb		;; f0bc: 28 0d       (.
	mvi	a,24		;; f0be: 3e 18       >.
	call	crtadr0		;; f0c0: cd f7 f1    ...
	lxi	b,(1 shl 8)+80	;; f0c3: 01 50 01    .P.
	mvi	e,007h		;; f0c6: 1e 07       ..
	call	Lf1a7		;; f0c8: cd a7 f1    ...
Lf0cb:	ldx	a,+1		;; f0cb: dd 7e 01    .~.
	call	crtadr0		;; f0ce: cd f7 f1    ...
	lxi	b,(1 shl 8)+80	;; f0d1: 01 50 01    .P.
	call	Lf1a4		;; f0d4: cd a4 f1    ...
	jmp	crtupd		;; f0d7: c3 e8 ef    ...

; alternate vert. blanking interrupt...
; on-shot, only triggers when something changes
; CRT_ROW naturally stays in-sync?
Lf0da:	push	psw		;; f0da: f5          .
	lda	crtstr+10	;; f0db: 3a 16 f5    :..
	out	CRT_ROW		;; f0de: d3 64       .d
	lda	crtstr+16	;; f0e0: 3a 1c f5    :..
	out	CRT_HUE		;; f0e3: d3 63       .c
	mvi	a,003h	; disable intr
	out	CTC1_3		;; f0e7: d3 23       .#
reti1:	pop	psw		;; f0e9: f1          .
	ei			;; f0ea: fb          .
	reti			;; f0eb: ed 4d       .M

; vert. blanking in graphics mode. no pages...
; same as Jr80 CTC ch1 - fires continuously
; CRT_ADR must be re-set every frame
Lf0ed:	push	psw		;; f0ed: f5          .
	xra	a		;; f0ee: af          .
	out	CRT_ADR		;; f0ef: d3 60       .`
	jr	reti1		;; f0f1: 18 f6       ..

escseq:	mvix	1,+4		;; f0f3: dd 36 04 01 .6..
	ret			;; f0f7: c9          .

; ESC prefix
Lf0f8:	dcr	a		;; f0f8: 3d          =
	jrz	Lf104	; first char after ESC
	dcr	a		;; f0fb: 3d          =
	jrz	Lf11d	; 2 = ESC Y x
	dcr	a		;; f0fe: 3d          =
	jrz	Lf136	; 3  = EXC Y R x
	mvi	m,0	; clear ESC count
	ret			;; f103: c9          .

Lf104:	mov	a,c		;; f104: 79          y
	cpi	'a'		;; f105: fe 61       .a
	jrc	Lf10f		;; f107: 38 06       8.
	cpi	'z'+1		;; f109: fe 7b       .{
	jrnc	Lf10f		;; f10b: 30 02       0.
	ani	01011111b	; toupper
Lf10f:	mvi	m,0	; clear ESC flag
Lf111:	lxi	h,Lf2f3		;; f111: 21 f3 f2    ...
	lxi	b,00005h	;; f114: 01 05 00    ...
	lxi	d,Lf300		;; f117: 11 00 f3    ...
	jmp	Lf190		;; f11a: c3 90 f1    ...

Lf11d:	mvi	m,3	; next is 3
	mov	a,c		;; f11f: 79          y
	sui	' '		;; f120: d6 20       . 
	bitx	4,+3		;; f122: dd cb 03 66 ...f
	jrnz	Lf12f	; ESC 1 case...
	call	Lf236	; normalize row
	sta	crtstr+1; row
	ret			;; f12e: c9          .

Lf12f:	call	Lf22e		; normalize col
	sta	crtstr+0	; save new col
	ret			;; f135: c9          .

Lf136:	mvi	m,0	; done with ESC
	mov	a,c		;; f138: 79          y
	sui	' '		;; f139: d6 20       . 
	bitx	4,+3		;; f13b: dd cb 03 66 ...f
	jrz	Lf14a		;; f13f: 28 09       (.
	; ESC 1 case...
	call	Lf236		; normalize row
	sta	crtstr+1	; row
	jmp	crtupd		;; f147: c3 e8 ef    ...

Lf14a:	call	Lf22e		; normalize col
	sta	crtstr+0	; column
	jmp	crtupd		;; f150: c3 e8 ef    ...

Lf153:	mvi	a,010h		;; f153: 3e 10       >.
	jr	crttgl		;; f155: 18 0e       ..

Lf157:	mvi	a,001h		;; f157: 3e 01       >.
	jr	crttgl		;; f159: 18 0a       ..

Lf15b:	mvi	a,002h		;; f15b: 3e 02       >.
	jr	crttgl		;; f15d: 18 06       ..

Lf15f:	mvi	a,040h		;; f15f: 3e 40       >@
	jr	crttgl		;; f161: 18 02       ..

Lf163:	mvi	a,008h		;; f163: 3e 08       >.
; Toggle CRT mode bit at crtstr+2
crttgl:	lxi	h,crtstr+2	;; f165: 21 0e f5    ...
	xra	m		;; f168: ae          .
	mov	m,a		;; f169: 77          w
	ret			;; f16a: c9          .

; func 15 - normal video?
nrmvid:	bitx	0,+3		;; f16b: dd cb 03 46 ...F
	rz			;; f16f: c8          .
	resx	0,+3		;; f170: dd cb 03 86 ....
	jr	Lf17f		;; f174: 18 09       ..

; func 14 - reverse video?
revvid:	bitx	0,+3		;; f176: dd cb 03 46 ...F
	rnz			;; f17a: c0          .
	setx	0,+3		;; f17b: dd cb 03 c6 ....
	; reverse video? xRGBxRGB background/foreground?
Lf17f:	lxi	h,crtstr+11	;; f17f: 21 17 f5    ...
	mov	a,m		;; f182: 7e          ~
	ani	088h		;; f183: e6 88       ..
	mov	c,a		;; f185: 4f          O
	mov	a,m		;; f186: 7e          ~
	rlc			;; f187: 07          .
	rlc			;; f188: 07          .
	rlc			;; f189: 07          .
	rlc			;; f18a: 07          .
	ani	077h		;; f18b: e6 77       .w
	ora	c		;; f18d: b1          .
	mov	m,a		;; f18e: 77          w
	ret			;; f18f: c9          .

Lf190:	ccir			;; f190: ed b1       ..
	rnz			;; f192: c0          .
	slar	c		;; f193: cb 21       ..
	xchg			;; f195: eb          .
	ora	a		;; f196: b7          .
	dsbc	b		;; f197: ed 42       .B
	mov	e,m		;; f199: 5e          ^
	inx	h		;; f19a: 23          #
	mov	d,m		;; f19b: 56          V
	xchg			;; f19c: eb          .
	pchl			;; f19d: e9          .

; clear screen
Lf19e:	lhld	crtstr+12	;; f19e: 2a 18 f5    *..
	lxi	b,(24 shl 8)+80	;; f1a1: 01 50 18    .P.
Lf1a4:	ldx	e,+11		;; f1a4: dd 5e 0b    .^.
Lf1a7:	mvi	d,' '		;; f1a7: 16 20       . 
Lf1a9:	mov	m,d		;; f1a9: 72          r
	inx	h		;; f1aa: 23          #
	mov	m,e		;; f1ab: 73          s
	inx	h		;; f1ac: 23          #
	dcr	c		;; f1ad: 0d          .
	jrnz	Lf1a9		;; f1ae: 20 f9        .
	mvi	c,80		;; f1b0: 0e 50       .P
	djnz	Lf1a9		;; f1b2: 10 f5       ..
	ret			;; f1b4: c9          .

eraeol:	xra	a		;; f1b5: af          .
Lf1b6:	push	psw		;; f1b6: f5          .
	lda	crtstr+0	;; f1b7: 3a 0c f5    :..
	bitx	2,+3		;; f1ba: dd cb 03 56 ...V
	jrz	Lf1c1		;; f1be: 28 01       (.
	add	a		;; f1c0: 87          .
Lf1c1:	mov	c,a		;; f1c1: 4f          O
	mvi	a,80		;; f1c2: 3e 50       >P
	sub	c		;; f1c4: 91          .
	mov	c,a		;; f1c5: 4f          O
	lhld	crtstr+7	;; f1c6: 2a 13 f5    *..
Lf1c9:	mvi	b,001h		;; f1c9: 06 01       ..
	call	Lf1a4		;; f1cb: cd a4 f1    ...
	pop	psw		;; f1ce: f1          .
	jrz	Lf1e0		;; f1cf: 28 0f       (.
	dcr	a		;; f1d1: 3d          =
	jrz	Lf1e0		;; f1d2: 28 0c       (.
	push	psw		;; f1d4: f5          .
	push	d		;; f1d5: d5          .
	mov	a,h		;; f1d6: 7c          |
	ani	00fh		;; f1d7: e6 0f       ..
	mov	h,a		;; f1d9: 67          g
	call	Lf212		;; f1da: cd 12 f2    ...
	pop	d		;; f1dd: d1          .
	jr	Lf1c9		;; f1de: 18 e9       ..

Lf1e0:	lhld	crtstr+7	;; f1e0: 2a 13 f5    *..
	jmp	Leffc		;; f1e3: c3 fc ef    ...

eraeop:	lhld	crtstr+0	;; f1e6: 2a 0c f5    *..
	mov	a,l		;; f1e9: 7d          }
	ora	h		;; f1ea: b4          .
	jz	clrscr		;; f1eb: ca 53 f0    .S.
	lda	crtstr+6	;; f1ee: 3a 12 f5    :..
	subx	+1		;; f1f1: dd 96 01    ...
	inr	a		;; f1f4: 3c          <
	jr	Lf1b6		;; f1f5: 18 bf       ..

crtadr0:	; compute address of line
	mvi	e,0		;; f1f7: 1e 00       ..
; E = column, A=row
crtadr:	bitx	2,+3		;; f1f9: dd cb 03 56 ...V
	jrz	Lf201		;; f1fd: 28 02       (.
	slar	e		;; f1ff: cb 23       .#
Lf201:	addx	+10	; "home" row on CRT
	mov	d,a		;; f204: 57          W
	add	a		;; f205: 87          .
	add	a		;; f206: 87          .
	add	d	; *5
	mvi	h,0		;; f208: 26 00       &.
	mov	d,h		;; f20a: 54          T
	mov	l,a		;; f20b: 6f          o
	dad	h		;; f20c: 29          )
	dad	h		;; f20d: 29          )
	dad	h		;; f20e: 29          )
	dad	h	; (*5)*16 = *80
	dad	d	; +col
	dad	h	; *2 (attr, 2 byte/cell)
Lf212:	xchg			;; f212: eb          .
	lxi	h,-4000	; wrap-point for addresses (25*80)*2
	dad	d		;; f216: 19          .
	jrnc	Lf21a		;; f217: 30 01       0.
	xchg			;; f219: eb          .
Lf21a:	lhld	crtstr+12	;; f21a: 2a 18 f5    *..
	dad	d		;; f21d: 19          .
	ret			;; f21e: c9          .

Lf21f:	setx	4,+3		;; f21f: dd cb 03 e6 ....
	jr	Lf229		;; f223: 18 04       ..

; ESC Y (cursor addressing?)
Lf225:	resx	4,+3		;; f225: dd cb 03 a6 ....
Lf229:	mvix	2,+4		;; f229: dd 36 04 02 .6..
	ret			;; f22d: c9          .

Lf22e:	cmpx	+5	; check max col
	rc			;; f231: d8          .
	lda	crtstr+5	; use max col
	ret			;; f235: c9          .

Lf236:	cmpx	+6	; check max row
	rc			;; f239: d8          .
	lda	crtstr+6	; force max row
	ret			;; f23d: c9          .

; beep the speaker
beep:	in	PP_A		;; f23e: db 00       ..
	ori	PPA_SPK		;; f240: f6 20       . 
	out	PP_A		;; f242: d3 00       ..
	lxi	b,08000h	; 250mS @ 2MHz
Lf247:	dcr	c		;; f247: 0d          .
	jrnz	Lf247		;; f248: 20 fd        .
	djnz	Lf247		;; f24a: 10 fb       ..
	ani	NOT PPA_SPK	;; f24c: e6 df       ..
	out	PP_A		;; f24e: d3 00       ..
	ret			;; f250: c9          .

; screen print?
prtscr:	pop	h		;; f251: e1          .
	pop	h		;; f252: e1          .
	shld	pscshl		;; f253: 22 aa f2    "..
	lhld	crtsav		;; f256: 2a f0 fd    *..
	shld	pscsav		;; f259: 22 ca f2    "..
	lxi	sp,pscstk	;; f25c: 31 ca f2    1..
	lda	crtstr+14	;; f25f: 3a 1a f5    :..
	out	CRT_CTL		;; f262: d3 62       .b
	call	ticfin		;; f264: cd 46 ea    .F.
	xra	a		;; f267: af          .
	ldx	c,+6		;; f268: dd 4e 06    .N.
	inr	c	; num rows
Lf26c:	ldx	b,+5		;; f26c: dd 46 05    .F.
	inr	b	; num cols
	mvi	e,0	; cur
Lf272:	push	psw		;; f272: f5          .
	push	b		;; f273: c5          .
	push	d		;; f274: d5          .
	call	crtadr	; compute CRT RAM addr
	lda	crtstr+14	;; f278: 3a 1a f5    :..
	setb	2,a	; enable access CRT RAM
	di			;; f27d: f3          .
	out	CRT_CTL		;; f27e: d3 62       .b
	mov	c,m	; get character
	res	2,a		;; f281: cb 97       ..
	out	CRT_CTL		;; f283: d3 62       .b
	ei			;; f285: fb          .
	call	lstout		;; f286: cd 90 e9    ...
	pop	d		;; f289: d1          .
	inr	e		;; f28a: 1c          .
	pop	b		;; f28b: c1          .
	pop	psw		;; f28c: f1          .
	djnz	Lf272		;; f28d: 10 e3       ..
	push	psw		;; f28f: f5          .
	push	b		;; f290: c5          .
	mvi	c,CR		;; f291: 0e 0d       ..
	call	lstout		;; f293: cd 90 e9    ...
	mvi	c,LF		;; f296: 0e 0a       ..
	call	lstout		;; f298: cd 90 e9    ...
	pop	b		;; f29b: c1          .
	pop	psw		;; f29c: f1          .
	inr	a		;; f29d: 3c          <
	dcr	c		;; f29e: 0d          .
	jrnz	Lf26c		;; f29f: 20 cb        .
	lixd	pscshl		;; f2a1: dd 2a aa f2 .*..
	lspd	pscsav		;; f2a5: ed 7b ca f2 .{..
	ret			;; f2a9: c9          .

pscshl:	dw	0
	dw	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
pscstk:	ds	0
pscsav:	dw	0

; Function dispatch table - CRT control codes?
Lf2cc:	db	BEL,BS,LF,CR,SO,SI,NAK,SYN,ETB,CAN,EM,SUB,ESC
nf2cc	equ	$-Lf2cc
	dw	beep	; BEL
	dw	curle	; BS
	dw	Lf043	; LF
	dw	Lf039	; CR
	dw	revvid	; SO
	dw	nrmvid	; SI
	dw	curri	; NAK
	dw	eraeol	; SYN
	dw	eraeop	; ETB
	dw	clrscr	; CAN
	dw	curhom	; EM
	dw	curup	; SUB
	; 13 bytes overwritten...???
Lf2f1:	dw	escseq	; ESC

Lf2f3:	db	'1289I'	; ESC commands...
	dw	Lf21f	; ESC 1 col row
	dw	Lf157	; ESC 2 - toggle screen wrap
	dw	Lf153	; ESC 8	- toggle (bit 4) ?era 12 lines?
	dw	Lf163	; ESC 9 - toggle scroll lock
Lf300:	dw	Lf04f	; ESC I - re-init? reset?

; alternate/advanced CRT control codes
Lf302:	db	BEL,BS,TAB,LF,VT,FF,CR,SO,SI,NAK,SYN,ETB,CAN,EM,SUB,ESC
nf302	equ	$-Lf302
Lf312:	dw	beep	; BEL
	dw	curle	; BS
	dw	Lefa8	; TAB
	dw	Lf043	; LF
	dw	Lf043	; VT
	dw	Lf043	; FF
	dw	Lf039	; CR
	dw	revvid	; SO - reverse video
	dw	nrmvid	; SI - normal video
	dw	curri	; NAK
	dw	eraeol	; SYN
	dw	eraeop	; ETB
	dw	clrscr	; CAN - clear screen
	dw	curhom	; EM
	dw	curup	; SUB
Lf330:	dw	escseq	; ESC

; VT-52 / H19?
Lf332:	db	'Y34+ABCDHIJK|'
Lf33f:	dw	Lf225	; ESC Y row col
	dw	Lf157	; ESC 3 - toggle screen wrap
	dw	Lf15b	; ESC 4 - toggle (bit 1)
	dw	Lf15f	; ESC + - toggle (bit 6)
	dw	curup	; ESC A - Cursor UP
	dw	curdn	; ESC B - Cursor DOWN
	dw	curri	; ESC C - Cursor RIGHT
	dw	curle	; ESC D	- Cursor LEFT
	dw	curhom	; ESC H - Home cursor
	dw	revidx	; ESC I	- reverse index w/scroll
	dw	eraeop	; ESC J - Erase to EOP
	dw	eraeol	; ESC K - Erase to EOL
Lf357:	dw	prtscr	; ESC | - print screen

; ext. function... B=func? C=data?
extfnc:	pushix			;; f359: dd e5       ..
	lxix	crtstr		;; f35b: dd 21 0c f5 ....
	mov	a,b		;; f35f: 78          x
	ora	a		;; f360: b7          .
	jz	Lf408	; func 0 - CRT modes?
	cpi	005h		;; f364: fe 05       ..
	jrz	crtpag		;; f366: 28 13       (.
	cpi	009h		;; f368: fe 09       ..
	jrz	setclr	; set pixel/text color?
	cpi	00bh		;; f36c: fe 0b       ..
	jrz	Lf3d0		;; f36e: 28 60       (`
	cpi	00fh		;; f370: fe 0f       ..
	jrz	Lf3e0		;; f372: 28 6c       (l
	cpi	010h		;; f374: fe 10       ..
	jrz	Lf3eb		;; f376: 28 73       (s
ixret3:	popix			;; f378: dd e1       ..
	ret			;; f37a: c9          .

; function 5 - set text page
crtpag:	bitx	1,+14		;; f37b: dd cb 0e 4e ...N
	jrnz	ixret3	; ignored in graphics mode?
	mov	a,c		;; f381: 79          y
	ani	003h		;; f382: e6 03       ..
	mov	c,a		;; f384: 4f          O
	ldx	e,+18		;; f385: dd 5e 12    .^.
	sta	crtstr+18	; 000000xx
	rrc			;; f38b: 0f          .
	rrc			;; f38c: 0f          .
	sta	crtstr+16	; xx000000 - for hardware
	rrc			;; f390: 0f          .
	rrc			;; f391: 0f          .
	ori	HIGH crtram	; 01xx0000 - for s/w
	sta	crtstr+13	;; f394: 32 19 f5    2..
	lxi	h,crtstr+19	;; f397: 21 1f f5    ...
	mvi	d,0		;; f39a: 16 00       ..
	mov	b,d		;; f39c: 42          B
	dad	d		;; f39d: 19          .
	lda	crtstr+10	; current row...
	mov	m,a	; save it
	dsbc	d		;; f3a2: ed 52       .R
	dad	b		;; f3a4: 09          .
	mov	a,m	; new row...
	sta	crtstr+10	; set it
	di			;; f3a9: f3          .
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3		;; f3ac: d3 23       .#
	mvi	a,001h		;; f3ae: 3e 01       >.
	out	CTC1_3		;; f3b0: d3 23       .#
	ei			;; f3b2: fb          .
	jr	ixret3		;; f3b3: 18 c3       ..

; Set pixel/text color (foreground)
; function 9, C=color
setclr:	bitx	1,+14	; graphics mode?
	jrnz	Lf3c0		;; f3b9: 20 05        .
	stx	c,+11	; text color
	jr	ixret3		;; f3be: 18 b8       ..

; C=pixel color
Lf3c0:	mov	a,c		;; f3c0: 79          y
	ani	003h		;; f3c1: e6 03       ..
	mov	c,a		;; f3c3: 4f          O
	mvi	b,003h		;; f3c4: 06 03       ..
Lf3c6:	rlc		; replicate 000000xx in all positions
	rlc			;; f3c7: 07          .
	add	c		;; f3c8: 81          .
	djnz	Lf3c6		;; f3c9: 10 fb       ..
	sta	crtstr+15	;; f3cb: 32 1b f5    2..
	jr	ixret3		;; f3ce: 18 a8       ..

; func 11 - set background?
Lf3d0:	bitx	1,+14		;; f3d0: dd cb 0e 4e ...N
	jrz	ixret3		;; f3d4: 28 a2       (.
	mov	a,c		;; f3d6: 79          y
	ani	00111111b	;; f3d7: e6 3f       .?
	sta	crtstr+16	;; f3d9: 32 1c f5    2..
	out	CRT_HUE		;; f3dc: d3 63       .c
	jr	ixret3		;; f3de: 18 98       ..

Lf3e0:	ldx	b,+16		;; f3e0: dd 46 10    .F.
	mov	a,b		;; f3e3: 78          x
	ani	11000000b	; preserve text page
	orax	+17		; add color
	jr	ixret3		;; f3e9: 18 8d       ..

; C=bitmap
Lf3eb:	lda	whooks		;; f3eb: 3a 2a fd    :*.
	ana	c		;; f3ee: a1          .
	jrz	ixret		;; f3ef: 28 14       (.
	cpi	004h	; hook 2
	jrz	Lf3fb		;; f3f3: 28 06       (.
	cpi	008h	; hook 3
	jrz	Lf400		;; f3f7: 28 07       (.
	jr	ixret		;; f3f9: 18 0a       ..

Lf3fb:	lhld	Lf508		;; f3fb: 2a 08 f5    *..
	jr	Lf403		;; f3fe: 18 03       ..

Lf400:	lhld	Lde4e+1		;; f400: 2a 4f de    *O.
Lf403:	dcx	h		;; f403: 2b          +
	mov	a,m		;; f404: 7e          ~
ixret:	popix			;; f405: dd e1       ..
	ret			;; f407: c9          .

; alter CRT modes?
; C=mode
Lf408:	mov	a,c		;; f408: 79          y
	lxi	d,(24 shl 8)+79	; 25x80
	lxi	h,0		;; f40c: 21 00 00    ...
	dcr	a		;; f40f: 3d          =
	jrz	Lf42c	; C==1
	dcr	a		;; f412: 3d          =
	dcr	a		;; f413: 3d          =
	jrz	Lf438	; C==3
	dcr	a		;; f416: 3d          =
	jz	Lf49b	; C==4
	dcr	a		;; f41a: 3d          =
	dcr	a		;; f41b: 3d          =
	jz	Lf4a9	; C==6
	dcr	d	; 23 lines (24x80)
	dcr	a		;; f420: 3d          =
	dcr	a		;; f421: 3d          =
	jrz	Lf434	; C==8
	dcr	a		;; f424: 3d          =
	jnz	ixret3
	; C==9 80x24
	setb	1,h	; crtstr+3
	jr	Lf438		;; f42a: 18 0c       ..

; (C==1) 40x25,
Lf42c:	mvi	e,39	; 39 cols?
	mvi	a,00101000b	; blink, 320x200, on, graphics, 40x25
	setb	2,h	; crtstr+3
	jr	Lf43a	; ZR

; (C==8) 80x24, VT52
Lf434:	lxi	h,(12h shl 8)+82h	; default/init modes
	inr	a	; NZ
; entered with ZR unless fallthrough
Lf438:	mvi	a,00101001b	; blink, 320x200, on, graphics, 80x25/24
Lf43a:	call	Lf4c8	; flags not altered
	mvix	007h,+11	;; f43d: dd 36 0b 07 .6..
	lxi	h,Lf4f6		;; f441: 21 f6 f4    ...
	jrz	Lf449		;; f444: 28 03       (.
	; NZ case... ??? modes
	lxi	h,Lf4e4		;; f446: 21 e4 f4    ...
Lf449:	lxi	b,9		;; f449: 01 09 00    ...
	lxi	d,Lef37		;; f44c: 11 37 ef    .7.
	ldir			;; f44f: ed b0       ..
	lxi	d,Lf111		;; f451: 11 11 f1    ...
	lxi	b,9		;; f454: 01 09 00    ...
	ldir			;; f457: ed b0       ..
	xra	a		;; f459: af          .
	sta	crtstr+16	;; f45a: 32 1c f5    2..
	sta	crtstr+18	;; f45d: 32 1e f5    2..
	lxi	h,Lf0da		;; f460: 21 da f0    ...
	shld	Lde86		;; f463: 22 86 de    "..
	lxi	h,Leebf		;; f466: 21 bf ee    ...
	lxi	d,Leee7		;; f469: 11 e7 ee    ...
Lf46c:	push	d		;; f46c: d5          .
	push	h		;; f46d: e5          .
	mvi	c,24		;; f46e: 0e 18       ..
	call	callhl		;; f470: cd 9a f4    ...
	pop	h		;; f473: e1          .
	shld	Le92a		;; f474: 22 2a e9    "*.
	shld	Le93a		;; f477: 22 3a e9    ":.
	shld	Le942		;; f47a: 22 42 e9    "B.
	pop	h		;; f47d: e1          .
	shld	Lde51+1		;; f47e: 22 52 de    "R.
	bitx	1,+14	; graphics mode?
	jrz	ixret2	; skip if text mode
	lxi	h,Lf0ed		;; f487: 21 ed f0    ...
	shld	Lde86		;; f48a: 22 86 de    "..
	di			;; f48d: f3          .
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3		;; f490: d3 23       .#
	mvi	a,1	; TC=1 (immediate)
	out	CTC1_3		;; f494: d3 23       .#
	ei			;; f496: fb          .
ixret2:	popix			;; f497: dd e1       ..
	ret			;; f499: c9          .

callhl:	pchl			;; f49a: e9          .

; (C==4) 40x25, text,
Lf49b:	mvi	e,39		;; f49b: 1e 27       .'
	setb	2,h	; crtstr+3
	mvix	0ffh,+15	;; f49f: dd 36 0f ff .6..
	mvi	b,020h		; color palette?
	mvi	a,00001010b	; 320x200, on, text, 40x25
	jr	Lf4ad		;; f4a7: 18 04       ..

; (C==6) 80x25, text, 640x200, 40x25?
Lf4a9:	mvi	b,007h		; white?
	mvi	a,00011010b	; 640x200, on, text, 40x25
Lf4ad:	push	h		;; f4ad: e5          .
	lxi	h,whooks	;; f4ae: 21 2a fd    .*.
	bit	2,m	; hook 2?
	pop	h		;; f4b3: e1          .
	jrz	ixret2		;; f4b4: 28 e1       (.
	call	Lf4c8		;; f4b6: cd c8 f4    ...
	mov	a,b		;; f4b9: 78          x
	sta	crtstr+16	;; f4ba: 32 1c f5    2..
	out	CRT_HUE		;; f4bd: d3 63       .c
	lhld	Lf508		;; f4bf: 2a 08 f5    *..
	lded	Lf50a		;; f4c2: ed 5b 0a f5 .[..
	jr	Lf46c		;; f4c6: 18 a4       ..

; A = new CRT_CTL
; HL = new flags
; DE = new max row/col
; C = new crtstr+17
Lf4c8:	sta	crtstr+14	; set new CRT mode
	shld	crtstr+2	; and flags
	lxi	h,0		;; f4ce: 21 00 00    ...
	shld	crtstr+0	; home cursor
	mvi	h,HIGH crtram	; CRT RAM at 04000h...
	shld	crtstr+12	;; f4d6: 22 18 f5    "..
	shld	crtstr+7	;; f4d9: 22 13 f5    "..
	sded	crtstr+5	; max row/col
	stx	c,+17		;; f4e0: dd 71 11    .q.
	ret			;; f4e3: c9          .

; code moved to Lef37 and Lf111
Lf4e4:	lxi	h,Lf2cc
	lxi	b,nf2cc
	lxi	d,Lf2f1
;
	lxi	h,Lf2f3
	lxi	b,00005h
	lxi	d,Lf300
; code moved to ('')
Lf4f6:	lxi	h,Lf302
	lxi	b,nf302
	lxi	d,Lf330
;
	lxi	h,Lf332
	lxi	b,0000dh
	lxi	d,Lf357

Lf508:	dw	0
Lf50a:	dw	0

; CRT display variables?
crtstr:
	db	0	; +0 column (cursor)
	db	0	; +1 row (cursor)
	db	10000010b	; +2 modes (user)
;               ; 0 - wrap screen?
;               ; 1 - * wrap line
;               ; 2 -
;               ; 3 - scroll lock
;               ; 4 - ? erase 12 lines?
;               ; 5 - cursor off
;               ; 6 - 8-bit chars?
;               ; 7 - *
	db	00010010b	; +3 modes (internal)
;               ; 0 -
;               ; 1 - *
;               ; 2 -
;               ; 3 -
;               ; 4 - *
;               ; 5 - NAK/ESC-C active
;               ; 6 -
;               ; 7 -
	db	0	; +4 ESC flag?
	db	79	; +5 max disp col
	db	23	; +6 max disp row
	dw	crtram	; +7,+8 cursor RAM addr
	db	7	; +9 saved/cached mode for +7
	db	0	; +10 CRT row of top of screen - CRT_ROW (0-24)
	db	7	; +11 cur active attrs
	dw	crtram	; +12,+13 - curr page CRT RAM addr
	db	00101001b ; +14 CRT_CTL mode? 640x200, on, 80x25
	db	0	; +15
	db	0	; +16 attrs - CRT_HUE
	db	8	; +17
	db	0	; +18
	db	0,0,0,0	; +19,+20,+21,+22 ; txt pgs save for crtstr+10

; CRT graphics handling?
; (HL)=pixel column address
; (DE)=pixel row address
; C=function
grphcs:	push	d		;; f523: d5          .
	mov	e,m		;; f524: 5e          ^
	inx	h		;; f525: 23          #
	mov	d,m		;; f526: 56          V
	lda	crtstr+14	;; f527: 3a 1a f5    :..
	bit	4,a	; 640x200? (320x200)
	lxi	h,-320		;; f52c: 21 c0 fe    ...
	jrz	Lf532		;; f52f: 28 01       (.
	dad	h	; -640
Lf532:	dad	d		;; f532: 19          .
	pop	h		;; f533: e1          .
	rc			;; f534: d8          .
	push	d		;; f535: d5          .
	mov	e,m		;; f536: 5e          ^
	inx	h		;; f537: 23          #
	mov	d,m		;; f538: 56          V
	lxi	h,199		;; f539: 21 c7 00    ...
	dsbc	d		;; f53c: ed 52       .R
	xchg			;; f53e: eb          .
	pop	h	; HL=column, DE=row
	rc			;; f540: d8          .
	sspd	crtsav		;; f541: ed 73 f0 fd .s..
	lxi	sp,crtstk	;; f545: 31 f0 fd    1..
	push	h		;; f548: e5          .
	mov	h,d		;; f549: 62          b
	mov	l,e		;; f54a: 6b          k
	dad	h		;; f54b: 29          )
	dad	h		;; f54c: 29          )
	dad	d	; *5
	dad	h		;; f54e: 29          )
	dad	h		;; f54f: 29          )
	dad	h		;; f550: 29          )
	dad	h	; *80
	xthl		; TOS=column, HL=row
	lda	crtstr+14	;; f553: 3a 1a f5    :..
	bit	4,a		;; f556: cb 67       .g
	jrnz	Lf578	; if 640x200
	lda	crtstr+15	;; f55a: 3a 1b f5    :..
	ani	003h		;; f55d: e6 03       ..
	mov	d,a	; D=
	mvi	a,003h	; 4 pixels per column?
	ana	l		;; f562: a5          .
	mov	b,a		;; f563: 47          G
	mvi	a,003h	; 2 bits per pixel
	inr	b		;; f566: 04          .
	push	b		;; f567: c5          .
Lf568:	rrc		; 0=xx000000, 1=00xx0000...
	rrc			;; f569: 0f          .
	djnz	Lf568		;; f56a: 10 fc       ..
	mov	e,a	; E=mask
	pop	b		;; f56d: c1          .
	mov	a,d		;; f56e: 7a          z
Lf56f:	rrc			;; f56f: 0f          .
	rrc			;; f570: 0f          .
	djnz	Lf56f		;; f571: 10 fc       ..
	mov	d,a		;; f573: 57          W
	mvi	b,002h		;; f574: 06 02       ..
	jr	Lf586		;; f576: 18 0e       ..

Lf578:	mvi	a,007h	; 8 pixels per column?
	ana	l		;; f57a: a5          .
	mov	b,a		;; f57b: 47          G
	inr	b		;; f57c: 04          .
	mvi	a,001h	; 1 bit per pixel (monochrome?)
Lf57f:	rrc		; 0=x0000000, 1=0x000000...
	djnz	Lf57f		;; f580: 10 fd       ..
	mov	e,a		;; f582: 5f          _
	mov	d,a		;; f583: 57          W
	mvi	b,003h		;; f584: 06 03       ..
Lf586:	xchg			;; f586: eb          .
	xthl			;; f587: e3          .
Lf588:	srlr	d		;; f588: cb 3a       .:
	rarr	e		;; f58a: cb 1b       ..
	djnz	Lf588		;; f58c: 10 fa       ..
	mvi	a,HIGH crtram	;; f58e: 3e 40       >@
	add	d		;; f590: 82          .
	mov	d,a		;; f591: 57          W
	dad	d		;; f592: 19          .
	pop	d		;; f593: d1          .
	di			;; f594: f3          .
	lda	crtstr+14	;; f595: 3a 1a f5    :..
	setb	2,a		;; f598: cb d7       ..
	out	CRT_CTL		;; f59a: d3 62       .b
	mov	b,m		;; f59c: 46          F
	mov	a,e		;; f59d: 7b          {
	cma			;; f59e: 2f          /
	inr	c		;; f59f: 0c          .
	dcr	c		;; f5a0: 0d          .
	jrz	Lf5b7	; C=0
	dcr	c		;; f5a3: 0d          .
	jrz	Lf5bf	; C=1
	dcr	c		;; f5a6: 0d          .
	jrz	Lf5ba	; C=2
	ana	b	; C=3 - set value D
	ora	d		;; f5aa: b2          .
Lf5ab:	mov	m,a		;; f5ab: 77          w
Lf5ac:	lda	crtstr+14	;; f5ac: 3a 1a f5    :..
	out	CRT_CTL		;; f5af: d3 62       .b
	ei			;; f5b1: fb          .
	lspd	crtsav		;; f5b2: ed 7b f0 fd .{..
	ret			;; f5b6: c9          .

; C=0 - clear bits
Lf5b7:	ana	b		;; f5b7: a0          .
	jr	Lf5ab		;; f5b8: 18 f1       ..

; C=2 - get bit value?
Lf5ba:	mov	a,b		;; f5ba: 78          x
	ana	e		;; f5bb: a3          .
	mov	b,a	; return value only?
	jr	Lf5ac		;; f5bd: 18 ed       ..

; C=1 - ???
Lf5bf:	ana	b		;; f5bf: a0          .
	mov	c,a		;; f5c0: 4f          O
	mov	a,b		;; f5c1: 78          x
	cma			;; f5c2: 2f          /
	ana	e		;; f5c3: a3          .
	ora	c		;; f5c4: b1          .
	jr	Lf5ab		;; f5c5: 18 e4       ..

; add A to HL
addahl:	add	l		;; f5c7: 85          .
	mov	l,a		;; f5c8: 6f          o
	mov	a,h		;; f5c9: 7c          |
	aci	000h		;; f5ca: ce 00       ..
	mov	h,a		;; f5cc: 67          g
	ret			;; f5cd: c9          .

fill:	stax	d		;; f5ce: 12          .
	inx	d		;; f5cf: 13          .
	dcr	c		;; f5d0: 0d          .
	jnz	fill		;; f5d1: c2 ce f5    ...
	ret			;; f5d4: c9          .

; overlayed???
; JMP Lf5d5 is planted in CCP at ccp$pg+7 (boot entry)
; This is the true cold start...
Lf5d5:	di			;; f5d5: f3          .
	xra	a		;; f5d6: af          .
	out	DMA_CTL		;; f5d7: d3 38       .8
	lxi	sp,00100h	;; f5d9: 31 00 01    1..
	im2			;; f5dc: ed 5e       .^
	mvi	a,HIGH Lde70	;; f5de: 3e de       >.
	stai			;; f5e0: ed 47       .G
	; CTC init...???
	lxi	d,05fdfh	;; f5e2: 11 df 5f    .._
	lxi	h,02f01h	;; f5e5: 21 01 2f    ../
	mvi	c,CTC1_0	;; f5e8: 0e 20       . 
	outp	d	;05fh - di, ctr, rising, TC, reset
	mvi	a,000h		;; f5ec: 3e 00       >.
	outp	a	;000h - TC=256 - from 307.18KHz
	mvi	a,080h	; 1.2KHz
	outp	a	;080h - intvec 80/82/84/86
	inr	c	;CTC1_1
	mvi	a,0dfh	; ei, ctr, rising, TC, reset
	outp	a	;0dfh	;; f5f7: ed 79       .y
	mvi	a,078h	; TC=120 - from ch0
	outp	a	; 10Hz
	inr	c	;CTC1_2
	inr	c	;CTC1_3
	inr	c	;CTC2_0
	; second CTC? same as Jr. 020h?
	outp	d	;05fh	;; f600: ed 51       .Q
	outp	l	;001h	;; f602: ed 69       .i
	mvi	a,088h		;; f604: 3e 88       >.
	outp	a	;088h - intvec 88/8a/8c/8e
	inr	c	;CTC2_1
	inr	c	;CTC2_2
	outp	d	;05fh	;; f60a: ed 51       .Q
	outp	l	;001h	;; f60c: ed 69       .i
	inr	c	;CTC2_3
	outp	e	;0dfh	;; f60f: ed 59       .Y
	outp	l	;001h	;; f611: ed 69       .i
	; i8253 - same as Jr80 70h?
	mvi	a,016h	; ctr 0: LSB only, mode 3, bin
	out	CTR_C		;; f615: d3 2b       .+
	mvi	a,008h	; count[0]=8 (9600baud)
	out	CTR_0		;; f619: d3 28       .(
	mvi	a,056h	; ctr 1: LSB only, mode 3, bin
	out	CTR_C		;; f61d: d3 2b       .+
	mvi	a,008h	; count[1]=8 (9600baud)
	out	CTR_1		;; f621: d3 29       .)
	mvi	a,0b6h	; ctr 2: LSB+MSB, mode 3, bin
	out	CTR_C		;; f625: d3 2b       .+
	mvi	a,LOW 951	; count[2]=0x03b7=951 (1292 Hz?)
	out	CTR_2		;; f629: d3 2a       .*
	mvi	a,HIGH 951	;; f62b: 3e 03       >.
	out	CTR_2		;; f62d: d3 2a       .*
	;
	mvi	a,089h	; A mode0 out, B mode0 out, C input
	out	PP_CTL		;; f631: d3 03       ..
	mvi	a,PPA_SPG	;; f633: 3e 10       >.
	out	PP_A		;; f635: d3 00       ..
	mvi	a,PPB_KRS	; enable kbd
	out	PP_B		;; f639: d3 01       ..
	; another CTC??? or PIO?
	mvi	a,04fh	; mode 1 input
	out	PIO1_AC		;; f63d: d3 2e       ..
	mvi	a,090h	; intr vector
	out	PIO1_AC		;; f641: d3 2e       ..
	; Z80-PIO
	mvi	a,04fh	; mode 1 input
	out	PIO_AC		;; f645: d3 52       .R
	mvi	a,00fh	; mode 0 output
	out	PIO_BC		;; f649: d3 53       .S
	mvi	a,094h	; intr vec
	out	PIO_AC		;; f64d: d3 52       .R
	mvi	a,096h	; intr vec
	out	PIO_BC		;; f651: d3 53       .S
	mvi	a,083h	; enable intr
	out	PIO_BC		;; f655: d3 53       .S
	; Z80-SIO
	mvi	b,008h		;; f657: 06 08       ..
	mvi	c,SIO_AC	;; f659: 0e 12       ..
	lxi	h,Lf8e1		;; f65b: 21 e1 f8    ...
	outir			;; f65e: ed b3       ..
	mvi	b,00bh		;; f660: 06 0b       ..
	inr	c	; SIO_BC
	lxi	h,Lf8de		;; f663: 21 de f8    ...
	outir			;; f666: ed b3       ..
	; zero memory
	lxi	d,Lfcd5		;; f668: 11 d5 fc    ...
	mvi	c,066h		;; f66b: 0e 66       .f
	xra	a		;; f66d: af          .
	call	fill		;; f66e: cd ce f5    ...
	lxi	h,04c05h	;; f671: 21 05 4c    ..L
	shld	Lfd1e		;; f674: 22 1e fd    "..
	shld	Lfd22		;; f677: 22 22 fd    "".
	mvi	a,0ffh		;; f67a: 3e ff       >.
	sta	Lfd21		;; f67c: 32 21 fd    2..
	sta	Lfd25		;; f67f: 32 25 fd    2%.
	mvi	a,00010001b	;; f682: 3e 11       >.
	sta	whooks		;; f684: 32 2a fd    2*.
	lxi	sp,whooks+17	;; f687: 31 3b fd    1;.
	lxi	h,nulfnc	;; f68a: 21 68 df    .h.
	push	h		;; f68d: e5          .
	push	h		;; f68e: e5          .
	push	h		;; f68f: e5          .
	push	h		;; f690: e5          .
	push	h		;; f691: e5          .
	push	h		;; f692: e5          .
	push	h		;; f693: e5          .
	push	h		;; f694: e5          .
	lxi	sp,tpa		;; f695: 31 00 01    1..
	in	PIO1_B		;; f698: db 2d       .-
	ani	CFG_RD		;; f69a: e6 20       . 
	lxi	h,Lf8f2		;; f69c: 21 f2 f8    ...
	mvi	m,0		;; f69f: 36 00       6.
	jrz	Lf6a5		;; f6a1: 28 02       (.
	mvi	m,5		;; f6a3: 36 05       6.
Lf6a5:	mvi	a,10111111b	; CON:=UC1: RDR:=UR2: PUN:=UP2: LST:=LPT:
	sta	defiob		;; f6a7: 32 3b fd    2;.
	in	PIO1_B		;; f6aa: db 2d       .-
	mov	b,a		;; f6ac: 47          G
	ani	CFG_SER		; serial console?
	jrnz	Lf6ea		;; f6af: 20 39        9
	; PC keyboard?
	mvi	a,10111101b	; CON:=CRT: RDR:=UR2: PUN:=UP2: LST:=LPT:
	sta	defiob		;; f6b3: 32 3b fd    2;.
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3		;; f6b8: d3 23       .#
	mvi	a,001h	; TC=1 (immediate)
	out	CTC1_3		;; f6bc: d3 23       .#
	mvi	l,083h	; EI on PIO chA
	mvi	c,PIO_AC	; ASCII kbd
	mov	a,b		;; f6c2: 78          x
	ani	CFG_PCK		; PC keyboard?
	jrz	Lf6e8		;; f6c5: 28 21       (.
	exx			;; f6c7: d9          .
	lxi	h,pckbin	;; f6c8: 21 f5 ea    ...
	shld	Le922		;; f6cb: 22 22 e9    "".
	shld	Le932		;; f6ce: 22 32 e9    "2.
	exaf			;; f6d1: 08          .
	; perform PC kbd clear-out...
	in	PP_B		;; f6d2: db 01       ..
	ani	NOT PPB_KRS	; disable kbd
	out	PP_B		;; f6d6: d3 01       ..
	lxi	b,2048	; delay some time
Lf6db:	dcr	c		;; f6db: 0d          .
	jrnz	Lf6db		;; f6dc: 20 fd        .
	djnz	Lf6db		;; f6de: 10 fb       ..
	ori	PPB_KRS		; re-enable kbd
	out	PP_B		;; f6e2: d3 01       ..
	;
	exaf			;; f6e4: 08          .
	exx			;; f6e5: d9          .
	mvi	c,02eh	; (PIO1_AC - PC kbd)
Lf6e8:	outp	l	; set kbd intr
; ASCII keyboard?
Lf6ea:	mov	a,b	; PIO1_B value
	ani	CFG_501	; 5.25" drives?
	lxi	h,trn8m0		;; f6ed: 21 2b e8    .+.
	jrz	Lf6fa		;; f6f0: 28 08       (.
	mvi	a,035h		;; f6f2: 3e 35       >5
	sta	Lf783		;; f6f4: 32 83 f7    2..
	lxi	h,trn5m0		;; f6f7: 21 cf e8    ...
Lf6fa:	shld	dph0		;; f6fa: 22 7a e7    "z.
	shld	dph1		;; f6fd: 22 8b e7    "..
	mov	a,b		;; f700: 78          x
	ani	CFG_523		;; f701: e6 40       .@
	lxi	h,trn8m0		;; f703: 21 2b e8    .+.
	jrz	Lf710		;; f706: 28 08       (.
	mvi	a,035h		;; f708: 3e 35       >5
	sta	Lf79b		;; f70a: 32 9b f7    2..
	lxi	h,trn5m0		;; f70d: 21 cf e8    ...
Lf710:	shld	dph2		;; f710: 22 9c e7    "..
	shld	dph3		;; f713: 22 ad e7    "..
	mov	a,b		;; f716: 78          x
	ani	CFG_501		;; f717: e6 80       ..
	jz	Lf869		;; f719: ca 69 f8    .i.
	call	Le03a		;; f71c: cd 3a e0    .:.
Lf71f:	ei			;; f71f: fb          .
	lda	defiob		;; f720: 3a 3b fd    :;.
	sta	iobyte		;; f723: 32 03 00    2..
	xra	a		;; f726: af          .
	sta	usrdrv		;; f727: 32 04 00    2..
	call	print		;; f72a: cd 67 e6    .g.
	db	18h,CR,LF
	db	'Tpd-80 DOS vers. 2.71 A  ** 57k CP/M 2.2 compatible **',CR,LF
	db	7,'$'
	call	print		;; f76a: cd 67 e6    .g.
	db	CR,LF
	db	'Disk drives A & B : '
Lf783:	db	'8"',CR,LF
	db	'Disk drives C & D : '
Lf79b:	db	'8"',CR,LF,'$'
	lda	Lf8f2		;; f7a0: 3a f2 f8    :..
	ora	a		;; f7a3: b7          .
	mvi	a,004h		;; f7a4: 3e 04       >.
	jz	Lf817		;; f7a6: ca 17 f8    ...
	call	print		;; f7a9: cd 67 e6    .g.
	db	'Virtual disk E: in configuration',CR,LF
	db	'192 kbytes storage capacity',CR,LF
	db	'Format Vdisk ? (y/*): $'
	call	conin		;; f802: cd 58 e9    .X.
	push	psw		;; f805: f5          .
	mov	c,a		;; f806: 4f          O
	call	conout		;; f807: cd 69 e9    .i.
	pop	psw		;; f80a: f1          .
	ani	11011111b	; toupper
	cpi	'Y'		;; f80d: fe 59       .Y
	cz	Lf86f	; erase
	cnz	Lf88f	; refresh (always called?)
	mvi	a,005h		;; f815: 3e 05       >.
Lf817:	sta	Ldf6a+1		;; f817: 32 6b df    2k.
	in	PIO1_B		;; f81a: db 2d       .-
	mov	b,a		;; f81c: 47          G
	ani	CFG_SER		;; f81d: e6 01       ..
	jnz	cboot	; silently cboot?
	call	print		;; f822: cd 67 e6    .g.
	db	CR,LF,'Console input : $'
	mov	a,b		;; f838: 78          x
	ani	CFG_PCK		;; f839: e6 02       ..
	jz	Lf85a		;; f83b: ca 5a f8    .Z.
	call	print		;; f83e: cd 67 e6    .g.
	db	'serial$'
Lf848:	call	print		;; f848: cd 67 e6    .g.
	db	' keyboard',CR,LF,'$'
	jmp	cboot		;; f857: c3 c2 de    ...

Lf85a:	call	print		;; f85a: cd 67 e6    .g.
	db	'parallel$'
	jmp	Lf848		;; f866: c3 48 f8    .H.

Lf869:	call	Le006	; setup 8" drives
	jmp	Lf71f		;; f86c: c3 1f f7    ...

; erase all of ramdisk...
Lf86f:	mvi	e,002h		;; f86f: 1e 02       ..
	call	Lf8ae		;; f871: cd ae f8    ...
	mvi	e,003h		;; f874: 1e 03       ..
	call	Lf8ae		;; f876: cd ae f8    ...
	mvi	e,004h		;; f879: 1e 04       ..
	call	Lf8ae		;; f87b: cd ae f8    ...
	mvi	e,005h		;; f87e: 1e 05       ..
	call	Lf8ae		;; f880: cd ae f8    ...
	mvi	e,006h		;; f883: 1e 06       ..
	call	Lf8ae		;; f885: cd ae f8    ...
	mvi	e,007h		;; f888: 1e 07       ..
	call	Lf8ae		;; f88a: cd ae f8    ...
	xra	a		;; f88d: af          .
	ret			;; f88e: c9          .

; "refresh" all of ramdisk
Lf88f:	mvi	e,002h		;; f88f: 1e 02       ..
	call	Lf8ca		;; f891: cd ca f8    ...
	mvi	e,003h		;; f894: 1e 03       ..
	call	Lf8ca		;; f896: cd ca f8    ...
	mvi	e,004h		;; f899: 1e 04       ..
	call	Lf8ca		;; f89b: cd ca f8    ...
	mvi	e,005h		;; f89e: 1e 05       ..
	call	Lf8ca		;; f8a0: cd ca f8    ...
	mvi	e,006h		;; f8a3: 1e 06       ..
	call	Lf8ca		;; f8a5: cd ca f8    ...
	mvi	e,007h		;; f8a8: 1e 07       ..
	call	Lf8ca		;; f8aa: cd ca f8    ...
	ret			;; f8ad: c9          .

; Erase a 32K chunk of ramdisk, E=bank
; returns NZ (if hi bits in PP_A)
Lf8ae:	in	PP_A		;; f8ae: db 00       ..
	ani	NOT PPA_BNK	;; f8b0: e6 f8       ..
	ora	e		;; f8b2: b3          .
	out	PP_A		;; f8b3: d3 00       ..
	lxi	h,04000h	;; f8b5: 21 00 40    ..@
	lxi	b,07fffh	;; f8b8: 01 ff 7f    ...
	push	h		;; f8bb: e5          .
	pop	d		;; f8bc: d1          .
	mvi	m,0e5h		;; f8bd: 36 e5       6.
	inx	h		;; f8bf: 23          #
	xchg			;; f8c0: eb          .
	ldir			;; f8c1: ed b0       ..
Lf8c3:	in	PP_A		;; f8c3: db 00       ..
	ani	NOT PPA_BNK	;return to bank 0
	out	PP_A		;; f8c7: d3 00       ..
	ret			;; f8c9: c9          .

; "refresh" a 32K chunk of ramdisk
; clears flags (NZ)
Lf8ca:	in	PP_A		;; f8ca: db 00       ..
	ani	NOT PPA_BNK	; mask off current bank
	ora	e		; add new bank
	out	PP_A		; select bank
	lxi	h,03fffh	;; f8d1: 21 ff 3f    ..?
Lf8d4:	inx	h		;; f8d4: 23          #
	mov	a,h		;; f8d5: 7c          |
	cpi	0c0h		;; f8d6: fe c0       ..
	jrz	Lf8c3		;; f8d8: 28 e9       (.
	mov	a,m		;; f8da: 7e          ~
	mov	m,a		;; f8db: 77          w
	jr	Lf8d4		;; f8dc: 18 f6       ..

; Z80-SIO chan B init (fallthrough to chan A)
Lf8de:	db	18h	; ch reset
	db	12h,LOW Lde70	; reg 2 - int vector
; Z80-SIO chan A init
Lf8e1:	db	14h,4ch	; reg 4 - 16x, 2st, NP
	db	15h,0eah ;reg 5 - DTR/RTS, Tx ena
	db	3,0c1h	; reg 3 - 8b, Rx ena
	db	1,15h	; reg 1 - INT on all, ext, status/parity affects vector

; Replace custom JMP in CCP and perform AUTOEXEC.BAT feature.
Lf8e9:	db	11,'AUTOEXEC' ; followed by 'BAT' = 11 chars

Lf8f2:	db	0
	db	0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h
	db	0e5h,0e5h
	ds	213
dirbuf:	ds	128	; scratch buffer

alv0:	ds	64	; ALV0
csv0:	ds	64	; CSV0
alv1:	ds	64	; ALV1
csv1:	ds	64	; CSV1
alv2:	ds	64	; ALV2
csv2:	ds	64	; CSV2
alv3:	ds	64	; ALV3
csv3:	ds	64	; CSV3
alv4:	ds	64	; ALV4
csv4:	ds	64	; CSV4

Lfcd5:	ds	1
Lfcd6:	ds	1	; write flag (again?)
Lfcd7:	ds	1
Lfcd8:	ds	1
curdph:	ds	2	; current drive's DPH
Lfcdb:	ds	1
Lfcdc:	ds	2
curtrk:	ds	2
curdsk:	ds	1
cursec:	ds	1
Lfce2:	ds	1
dmaadr:	ds	2
wrflg:	ds	1	; 1=write disk
Lfce6:	ds	1
Lfce7:	ds	2
curblm:	ds	1	; DPB.BLM+1
Lfcea:	ds	1	; Lfcd8
Lfceb:	ds	2	; curtrk
Lfced:	ds	1	; Lfce2
Lfcee:	ds	1
Lfcef:	ds	1

; FDC results block
fdcres:	ds	8

savtrk:	ds	4	; current track for each drive
Lfcfc:	ds	1
Lfcfd:	ds	1
fdcbuf:	ds	8	; FDC parameter block, start with HDS/DS1/DS0
Lfd06:	ds	1	; write command (from fdXfmY buffers)
Lfd07:	ds	1	; read command (from fdXfmY buffers)

Lfd08:	ds	1
Lfd09:	ds	1	; drive type, 0=8"
Lfd0a:	ds	1
Lfd0b:	ds	1	; num sides
cursid:	ds	1

fdcmtr:	ds	4	; motor/access timeouts for each drive
Lfd11:	ds	1	; enable/prescale for ticcnt tick counter
			;
Lfd12:	ds	1	; saved value for Lfd11 during ramdisk I/O

; SIO A/B input FIFOs
ffoflg:	ds	1	; XD1/2: fifo flags
			; 40h=dropped B
			; 10h=XOFF recv B
			; 20h=XOFF sent B
			; 04h=dropped A
			; 01h=XOFF recv A
			; 02h=XOFF sent A
awrptr:	ds	2	; SIO A fifo wr ptr
ardptr:	ds	2	; SIO A fifo rd ptr
affcnt:	ds	1	; SIO A fifo count
bwrptr:	ds	2	; SIO B fifo wr ptr
brdptr:	ds	2	; SIO B fifo rd ptr
bffcnt:	ds	1	; SIO B fifo count

; Some external block, associated with SIO A/B...
Xfd1e:
Lfd1e:	ds	3	; 05h, 4ch, ??
Lfd21:	ds	1	; 0ffh - input mask and...?
Lfd22:	ds	3	; 05h, 4ch, ??
Lfd25:	ds	1	; 0ffh - input mask and...?

Lfd26:	ds	1	; KBD: input status flag
Lfd27:	ds	1	; KBD: input character
Lfd28:	ds	1	; KBD: meta keys
lptbsy:	ds	1	; reflects LPT: BUSY

whooks:	ds	1	; wboot hooks bitmap
	ds	16	; initially filled with nulfnc

defiob:	ds	1

	ds	50
biostk:	ds	0
savstk:	ds	2

rdbuf:	ds	128	; buffer for ramdisk? also, CRT stack
crtstk:	ds	0
crtsav:	ds	2

Lfdf2:	ds	128	; FIFO for SIO_A
Lfe72:	ds	128	; FIFO for SIO_B

	end
