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
PIO2_A	equ	50h	; input - ASCII keyboard
PIO2_B	equ	51h	; parallel printer data
PIO2_AC	equ	52h
PIO2_BC	equ	53h
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
rsx$pg	equ	ccp$pg-0100h ; to speed up wboot?

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

	jmp	cboot
wboote:	jmp	wboot
	jmp	const
	jmp	conin
	jmp	conout
	jmp	lstout
	jmp	punout
	jmp	rdrin
	jmp	home
	jmp	seldsk
	jmp	settrk
	jmp	setsec
	jmp	setdma
	jmp	read
	jmp	write
	jmp	lstst
	jmp	sectrn
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
Lde4e:	jmp	nulfnc
Lde51:	jmp	Leee7		; CRT mode 20h
	jmp	uc1out		; UC1: output
	jmp	uc1in		; UC1: input
	jmp	uc1st		; UC1: input status
	jmp	nulfnc
	jmp	extfnc		; extended functions, B=func, C=sub-fnc
	jmp	nulfnc
	jmp	nulfnc
	jmp	nulfnc
	jmp	ticfin

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
Lde86:	dw	vertbl	; xx86 - CTC1 ch3 - video? ("NVIMT")
	dw	nulint	; xx88 - CTC2 ch0
	dw	nulint	; xx8a - CTC2 ch1
	dw	nulint	; xx8c - CTC2 ch2
	dw	fdcint	; xx8e - CTC2 ch3 FDC
piovec:	dw	pckbint	; xx90 - PIO1 chA - PC keyboard (scan codes)
	dw	nulint	; xx92
p2avec:	dw	akbint	; xx94 - PIO chA - ASCII keyboard
p2bvec:	dw	lptint	; xx96 - PIO chB - LPT: ready (intr)

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

cboot:	lda	defiob
	sta	iobyte
	xra	a
	sta	usrdrv
	jmp	wboot

Ldecf:	lxi	h,ccp$cold
	shld	Ldf61+1
	lxi	h,Lf8e9
	lxi	d,ccp$cmd
	lxi	b,9
	ldir
	jmp	ccp$cold

wboot:	lxi	sp,tpa
	xra	a
	; since CCP not reloaded, reset it
	lxi	d,ccp$cmd
	mvi	c,129
	call	fill
	lxi	h,ccp$patt
	shld	ccp$pate
	lxi	d,ccp$fill1
	mvi	c,72
	call	fill
	lxi	d,bdos$fill1
	mvi	c,61
	call	fill
	;
	cma	; 0ffh
	sta	curfmt
	di
	mvi	a,0c3h
	sta	cpm
	lxi	h,wboote
	shld	cpm+1
	sta	bdos
	; this stub prevents CCP from being overwritten...
	lhld	Ldea8
	shld	bdos+1
	mvi	m,0c3h
	inx	h
	mvi	m,LOW bdose
	inx	h
	mvi	m,HIGH bdose
	;
	lxi	h,Lfdf2
	shld	ardptr
	shld	awrptr
	lxi	h,Lfe72
	shld	brdptr
	shld	bwrptr
	xra	a
	sta	affcnt
	sta	bffcnt
	lda	ffoflg
	ani	022h
	sta	ffoflg
	; call all wboot hooks...
	lxi	h,whooks
	mov	a,m
	inx	h
Ldf4c:	stc
	cmc
	rar
	push	psw
	push	h
	cc	icall
	pop	h
	pop	psw
	inx	h
	inx	h
	ora	a
	jnz	Ldf4c
	;
	lda	usrdrv
	mov	c,a
	ei
Ldf61:	jmp	Ldecf

; indirect call to (HL)
icall:	mov	e,m
	inx	h
	mov	d,m
	push	d
nulfnc:	ret

; C=new dsk (0-4), E=login bit
seldsk:	mov	a,c
Ldf6a:	cpi	005h	; 4 or 5 depending on ramdisk
	lxi	h,0
	jc	Ldf77
	xra	a
	sta	usrdrv
	ret

Ldf77:	sspd	savstk
	lxi	sp,biostk
	call	Ldf86
	lspd	savstk
	ret

; C=new dsk (0-4), A=C
Ldf86:	cpi	004h
	jz	Ldf9d	; ramdisk
	; C=new dsk (0-3)
	mov	b,e	; save login bit in B
	push	b
	push	h
	call	Le3f5	; flush dirty buffer?
	pop	h
	pop	b
	mov	a,c
	sta	newdrv
	push	b
	call	Ldfe9
	pop	b
	mov	a,c
; C=new dsk (0-4)
Ldf9d:	lxi	d,dphtbl
	add	a
	add	a
	add	a
	add	a
	add	c	; *17
	mov	l,a
	mvi	h,0
	dad	d
	shld	curdph
	lxi	d,16
	dad	d	; extension byte (format)
	mvi	a,4	; ramdisk
	cmp	c
	jz	Ldfde
	; floppies only
	mov	a,b	; login bit
	rrc
	jc	Ldfbd	; already logged in
	mvi	m,0ffh	; mark "not accessed"
Ldfbd:	mov	a,m
	sta	drvfmt	; login flag
	call	Le080
	lhld	curdph
	lda	drvsz5
	ora	a
	jz	Ldfd9
	lda	curfmt
	cpi	4	; dpb5mZ
	mvi	a,1	; "half track" mode
	jnz	Ldfd9
	xra	a
Ldfd9:	sta	hlftrk
	ora	a
	ret

; Use existing format from DPH
; HL=&DPH+16
Ldfde:	mov	a,m
	sta	curfmt
	sta	drvfmt
	lhld	curdph
	ret

Ldfe9:	lda	Lfcfd
	xra	c
	ani	002h	; 8"/5" change?
	mov	a,c
	sta	Lfcfd
	rz
	ani	002h
	mvi	b,CFG_501
	jz	Ldffd
	mvi	b,CFG_523
Ldffd:	in	PIO1_B
	ana	b	; test drive type
	jz	setdr8	; new drive is 8"
	jmp	setdr5	; new drive is 5"

; setup 8" drives
setdr8:	lxi	h,fd8fm0
	shld	Le0b9+1
	lxi	h,fd8fm1
	shld	Le0ca+1
	lxi	h,fd8fm2
	shld	Le0d1+1
	lxi	h,fd8fm3
	shld	Le0c2+1
	xra	a
	sta	drvsz5	; set 8" drives
	mvi	b,FDC_RST	; release i8272 RESET, 8" drives
	call	Le06f
	di
	mvi	b,003h	; SPECIFY command
	call	fdcbeg
	mvi	b,06fh	; SRT=6, HUT=15
	call	fdcout
	mvi	b,02eh	; HLT=23, ND=0 (DMA on?)
	call	fdcout
	jmp	recal

; setup 5.25" drives
setdr5:	lxi	h,fd5fm0
	shld	Le0b9+1
	lxi	h,fd5fm1
	shld	Le0ca+1
	lxi	h,fd5fm2
	shld	Le0d1+1
	lxi	h,fd5fm3
	shld	Le0c2+1
	mvi	a,001h
	sta	drvsz5	; set 5.25" drives
	mvi	b,FDC_RST+FDC_5IN ; release i8272 RESET, 5.25" drives
	call	Le06f
	di
	mvi	b,003h	; SPECIFY command
	call	fdcbeg
	mvi	b,0cfh	; SRT=12, HUT=15
	call	fdcout
	mvi	b,002h	; HLT=1, ND=0 (DMA on?)
	call	fdcout
	jmp	recal

; modify FDC_CTL RESET, 8/5 drives
; B=bits to replace
Le06f:	lda	Lde6f
	ani	NOT (FDC_RST+FDC_5IN)
	out	FDC_CTL
	nop
	nop
	nop
	ora	b
	sta	Lde6f
	out	FDC_CTL
	ret

Le080:	lda	newdrv
	mov	e,a
	mvi	d,0
	lda	fdcbuf+0	; old DS1/DS0
	ani	003h
	cmp	e
	jz	Le0a6
	; different drive - do select
	push	d
	lxi	h,savtrk
	mov	e,a
	dad	d
	lda	fdcbuf+1
	mov	m,a	; save old drive track num
	lxi	h,savtrk
	pop	d
	dad	d
	mov	a,m	; restore new drive track num
	sta	fdcbuf+1
	mov	a,e
	sta	fdcbuf+0	; new DS1/DS0 value
Le0a6:	lda	drvfmt
	cpi	0ffh
	jz	Le0f0	; format unknown
; force setup of new format
setfmt:	lxi	h,curfmt
	cmp	m
	jz	Le0e0
	mov	m,a
Le0b6:	lxi	d,fdcbuf+4
Le0b9:	lxi	h,fd8fm0	; replaced with current format
	mvi	b,6
	ora	a
	jz	Le0d4
Le0c2:	lxi	h,fd8fm3
	cpi	003h
	jz	Le0d4
Le0ca:	lxi	h,fd8fm1
	rar
	jc	Le0d4
Le0d1:	lxi	h,fd8fm2
Le0d4:	mov	a,m
	stax	d
	inx	h
	inx	d
	dcr	b
	jnz	Le0d4
	shld	fmtdpb	; pointer to fmt.dpb
	ret

Le0e0:	lda	Lfd0a
	mov	e,a
	lda	drvsz5
	sta	Lfd0a
	xra	e
	mov	a,m
	rz
	jmp	Le0b6

; init for new drive/diskette
Le0f0:	xra	a
	sta	curtrk
	sta	hlftrk
	call	recal
	call	setmtr
Le0fd:	lxi	b,2	; check format on track 2...
	call	settrk
	call	seek
	xra	a
	call	setfmt	; format 0
	call	readid	; read ID off nearest sector
	jz	Le138	; format same?
	mvi	a,2
	call	setfmt	; format 2
	call	readid
	jz	Le138
	mvi	a,1
	call	setfmt	; format 1
	call	readid
	jz	Le138
	mvi	a,3	; format 3
	call	setfmt
	call	readid
	jz	Le138
	lxi	h,0
	shld	curdph
	ret

; got format...
Le138:	xra	a
	sta	curtrk
	call	recal
	lhld	curdph
	lxi	d,10
	dad	d
	xchg		; DE=&dph.dpb
	lhld	fmtdpb
	mov	a,m	;
	stax	d	; set new dpb
	mov	c,a
	inx	h
	inx	d
	mov	a,m
	stax	d
	mov	b,a	; BC=new dpb
	ldax	b	; DPB.SPT
	cpi	36	; dpb5m2?
	jnz	Le171	; skip if not dpb5m2
	; check for 80-track drive...
	lda	fdcres+4	; C (track) number?
	ora	a
	jz	Le0fd	; format not yet checked?
	sui	002h
	jnz	Le171	; skip otherwise
	; special handling for dpb5m2... DT...
	mov	l,e
	mov	h,d	; HL=&DPH.DPB+1
	lxi	b,dpb5mZ
	mov	m,b
	dcx	h
	mov	m,c
	mvi	a,4
	sta	curfmt
Le171:	lxi	h,5
	dad	d
	lda	curfmt
	mov	m,a
	sta	drvfmt
	ret

readid:	lda	rdcmd
	ani	040h
	ori	00ah	; READ ID command + MFM
	mov	b,a
	mvi	c,1
	call	fdccmd
	jc	readid
	rnz
	lxi	h,fdcres+7
	lda	curfmt
	cmp	m
	ret

home:	lxi	b,0
settrk:	mov	h,b
	mov	l,c
	shld	curtrk
	ret

setsec:	mov	a,c
	sta	cursec
	lda	drvsz5
	ora	a
	jz	Le1bd
	lda	hlftrk
	ora	a
	mvi	a,0
	jnz	Le1bd
	mov	a,c
	cpi	36
	mvi	a,0
	jc	Le1bd
	mvi	a,1	; only for 5" fmt 2.
Le1bd:	sta	cursid
	mov	a,c
	ora	a
	ret

sectrn:	mov	a,c
	sta	Lfce2
	lda	curfmt
	ora	a
	jz	trnfm0	; format 0
	dcr	a
	jz	trnfm1	; format 1
	dcr	a
	jz	trnfm2	; format 2
	dcr	a
	jz	trnfm3	; format 3
	dcr	a
	jz	trnfm4	; format 4
trnfm3:	mov	l,c
	mov	a,c
	ret

; 128-byte sectors - use table
trnfm0:	xchg
	dad	b
	mov	l,m
	mov	a,l
	ret

; 512-byte sectors, use trn5m2/trn8m2
trnfm2:	lda	drvsz5
	ora	a
	lxi	h,trn5m2
	jnz	Le1f3
	lxi	h,trn8m2
Le1f3:	mov	a,c
	push	psw
	rar
	ora	a
	rar
	mov	c,a
	dad	b
	mov	a,m
	rlc
	rlc
	mov	c,a
	pop	psw
	ani	003h
	ora	c
	mov	l,a
	ret

; 256-byte sectors - hard-coded skew
trnfm1:	lda	drvsz5
	ora	a
	; 8" params
	mvi	e,26
	mvi	d,9	; skew
	mvi	b,0
	jz	Le217
	; 5" params
	mvi	e,16
	mvi	d,8	; skew
	mvi	b,1
Le217:	mov	a,c
	rar
	push	psw	; save CY
	mov	c,a
	xra	a
Le21c:	dcr	c
	jm	Le22a
	add	d
	cmp	e
	jc	Le21c
	sub	e
	add	b
	jmp	Le21c

Le22a:	mov	c,a
	pop	psw
	mov	a,c
	ral
	mov	l,a
	ret

; phy sec in:  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
; phy sec out: 0,2,4,6,8,1,3,5,7,9,11,13,15,17,10,12,14,16
; skew=2 but second side is +1
trnfm4:	mov	a,c
	ani	11111100b
	mvi	e,36
	cmp	e
	mvi	b,0
	jc	Le23d
	sub	e
	mov	b,e
Le23d:	rlc
	cmp	e
	jc	Le243
	sub	e
Le243:	add	b
	mov	l,a
	mov	a,c
	ani	003h
	ora	l
	mov	l,a
	ret

setdma:	mov	h,b
	mov	l,c
	shld	dmaadr
	ret

write:	mvi	a,1
	jmp	Le259

read:	xra	a
	mvi	c,0
Le259:	sspd	savstk
	lxi	sp,biostk
	call	Le268
	lspd	savstk
	ret

Le268:	sta	wrflg
	mov	a,c
	sta	Lfce6
	lda	drvfmt
	cpi	010h
	jz	Le596	; ramdisk
	ora	a
	jnz	Le2a0	; not SD
	call	Le3f5
	call	Le61d
	call	seek
	lxi	h,127
	shld	Lfce7
	lda	cursec
	sta	fdcbuf+3
	lda	cursid
	sta	fdcbuf+2
	lda	wrflg
	ora	a
	jz	Le43c
	jmp	Le431

; DD formats...
Le2a0:	lxi	h,003ffh
	cpi	003h
	jz	Le2b2
	lxi	h,000ffh
	rar
	jc	Le2b2
	lxi	h,001ffh
Le2b2:	shld	Lfce7
	lda	wrflg
	ora	a
	jz	Le338
	lda	Lfce6
	cpi	002h
	jnz	Le2e1
	call	getdpb
	inx	h
	inx	h
	inx	h
	mov	a,m
	inr	a
	sta	curblm
	lda	newdrv
	sta	Lfcea
	lhld	curtrk
	shld	Lfceb
	lda	Lfce2
	sta	Lfced
Le2e1:	lda	curblm
	ora	a
	jz	Le338
	dcr	a
	sta	curblm
	lda	newdrv
	lxi	h,Lfcea
	cmp	m
	jnz	Le338
	lhld	curtrk
	xchg
	lhld	Lfceb
	mov	a,d
	cmp	h
	jnz	Le338
	mov	a,e
	cmp	l
	jnz	Le338
	lda	Lfce2
	lxi	h,Lfced
	cmp	m
	jnz	Le338
	inr	m
	mov	a,m
	call	getdpb
	cmp	m	; DPB.SPT
	jc	Le325
	; at end of track...
	xra	a
	sta	Lfced
	lhld	Lfceb
	inx	h	; next track
	shld	Lfceb
Le325:	xra	a
	sta	Lfcee
	jmp	Le340

getdpb:	lhld	curdph
	lxi	d,10
	dad	d
	mov	e,m
	inx	h
	mov	d,m
	xchg
	ret

Le338:	xra	a
	sta	curblm
	inr	a
	sta	Lfcee
Le340:	lda	drvfmt
	cpi	4
	jnz	Le34a
	mvi	a,2	; pretend to be fmt2 (512b/sc)
Le34a:	mov	b,a
	; convert CP/M record to physical sector
	lda	cursec	; 0..N
	dcr	b
	jz	Le35a	; fmt1
	dcr	b
	jz	Le358	; fmt2
	; fmt3
	ora	a
	rar
Le358:	ora	a
	rar
Le35a:	ora	a
	rar
	inr	a	; 1-based phy sec nums
	mov	c,a	; phy sec num
	lda	cursid
	mov	b,a
	ora	a
	jz	Le36a
	; only for 5" fmt 2
	mov	a,c
	sui	9	; mod sec for side 2
	mov	c,a
Le36a:	lda	newdrv
	mov	l,a
	lda	Lfcfc
	cmp	l
	jnz	Le38d	; diff drive
	lxi	h,curtrk
	lda	fdcbuf+1	; C (track)
	cmp	m
	jnz	Le38d	; diff track
	lda	fdcbuf+2	; H (side)
	cmp	b
	jnz	Le38d	; diff side
	lda	fdcbuf+3	; R (sector)
	cmp	c
	jz	Le3b7	; buffer is fresh
	; diff sector
; flush buffer if dirty, seek new track
Le38d:	push	b
	call	Le3f5
	call	Le61d
	call	seek
	pop	b
	lxi	h,fdcbuf+3
	mov	m,c	; new R (sector)
	dcx	h
	mov	m,b	; new H (side)
	lda	Lfcee
	ora	a
	jz	Le3b7
	lhld	dmaadr
	push	h
	lxi	h,secbuf
	shld	dmaadr
	call	Le43c
	pop	h
	shld	dmaadr
	rnz
Le3b7:	lda	drvfmt
	cpi	3
	jz	Le41e	; fmt3
	rar
	jc	Le40f	; fmt1
	; fmt2 or fmt4
	lda	cursec
	ani	003h
	rrc
	rrc
	mov	l,a
	mvi	h,000h
	dad	h
	lxi	d,secbuf
Le3d1:	dad	d
	xchg
	lhld	dmaadr
	mvi	c,128
	lda	wrflg
	ora	a
	jz	Le3e5
	mvi	a,001h
	sta	Lfcd7
	xchg
Le3e5:	ldax	d
	mov	m,a
	inx	h
	inx	d
	dcr	c
	jnz	Le3e5
	lda	Lfce6
	cpi	001h
	mvi	a,000h
	rnz
Le3f5:	lxi	h,Lfcd7
	mov	a,m
	mvi	m,000h
	ora	a
	rz
	lhld	dmaadr
	push	h
	lxi	h,secbuf
	shld	dmaadr
	call	Le431
	pop	h
	shld	dmaadr
	ret

Le40f:	lda	cursec
	ani	001h
	rrc
	mov	e,a
	mvi	d,000h
	lxi	h,secbuf
	jmp	Le3d1

Le41e:	lda	cursec
	ani	007h
	rrc
	rrc
	rrc
	mov	l,a
	mvi	h,000h
	dad	h
	dad	h
	lxi	d,secbuf
	jmp	Le3d1

; write operation
Le431:	lda	wrcmd
	mov	b,a
	mvi	c,DMA_RD
	mvi	a,1
	jmp	Le443

; read operation
Le43c:	lda	rdcmd
	mov	b,a
	mvi	c,DMA_WR
	xra	a
Le443:	sta	Lfcd6
Le446:	xra	a
	sta	Lfcef
	mvi	a,010h
Le44c:	sta	Lfcd5
	; merge head select from H param
Le44f:	lda	fdcbuf+0	; HDS:DS1:DS0
	ani	003h		; DS1:DS0
	mov	l,a
	lda	fdcbuf+2	; H
	rlc
	rlc
	ora	l		; HDS:DS1:DS0
	sta	fdcbuf+0
	call	setmtr
	di
	lhld	Lfce7
	mov	a,l
	out	DMA_1C
	mov	a,c
	ora	h
	out	DMA_1C
	lhld	dmaadr
	mov	a,l
	out	DMA_1A
	mov	a,h
	out	DMA_1A
	mvi	a,040h+DMA_FDC	; TC stop, FDC ch ena
	out	DMA_CTL
	ei
	push	b
	mvi	c,008h
	call	fdccmd
	pop	b
	jc	Le44f
	rz
	push	b
	lda	fdcres+1
	ani	018h
	jz	Le492
	pop	b
	jmp	Le44f

Le492:	lda	fdcres+3
	ani	010h
	jz	Le4ab
	lda	Lfcef
	ora	a
	jnz	Le4ab
	cma
	sta	Lfcef
	call	recal
	call	seek
Le4ab:	pop	b
	lda	Lfcd5
	dcr	a
	jp	Le44c
	call	Le67b
	lxi	h,fdcres+2
	mov	a,m
	ani	080h
	jz	Le4cf
	call	print
	db	'end of track$'
Le4cf:	mov	a,m
	ani	020h
	jz	Le4f6
	inx	h
	mov	a,m
	dcx	h
	ani	020h
	jz	Le4ec
	call	print
	db	'data CRC$'
	jmp	Le4f6

Le4ec:	call	print
	db	'ID CRC$'
Le4f6:	mov	a,m
	ani	004h
	jz	Le510
	call	print
	db	'sector not found$'
Le510:	mov	a,m
	ani	002h
	cnz	Le69b
	mov	a,m
	ani	001h
	jz	Le545
	inx	h
	mov	a,m
	ani	001h
	jz	Le52e
	call	print
	db	'data$'
	jmp	Le534

Le52e:	call	print
	db	'ID$'
Le534:	call	print
	db	' address mark$'
Le545:	call	print
	db	' ERROR',CR,LF,'$'
	lda	Lfd08
	ora	a
	jnz	lstst
	call	print
	db	'Continue,Ignore,Retry ? $'
	push	b
	call	conin
	push	psw
	mov	c,a
	call	conout
	call	print
	db	CR,LF,'$'
	pop	psw
	pop	b
	ani	11011111b	; toupper
	cpi	'I'
	jz	Le594
	cpi	'R'
	jz	Le446
lstst:	xra	a
	dcr	a
	ret

Le594:	xra	a
	ret

Le596:	lhld	dmaadr
	lxi	d,winend+127
	dad	d
	jnc	Le608
	lda	dmaadr+1
	cpi	HIGH winend
	jnc	Le608
	lda	wrflg
	ora	a
	jnz	Le5c4
	call	rdadr
	xchg
	mvi	a,8
	call	Le5d3
	lxi	d,rdbuf
	mvi	c,128
	lhld	dmaadr
	xchg
	ldir
	ret

Le5c4:	lhld	dmaadr
	lxi	d,rdbuf
	lxi	b,128
	ldir
	call	rdadr
	xra	a
Le5d3:	mov	b,a
	lda	Lfd11
	sta	Lfd12
	mvi	a,002h	; prevent tick hook during I/O
	sta	Lfd11
	lda	curtrk	; a.k.a ramdisk bank number
	adi	2	; reserved banks...
	ora	b
	mov	c,a
	in	PP_A
	ora	c
	out	PP_A
	; user TPA no longer valid...
	lxi	b,128
	ldir
	ani	11110000b	; ENNMI off
	out	PP_A
	; user TPA safe again
	jmp	ticfin

; compute ramdisk address
; returns HL=rdbuf, DE=sector address (within track/bank)
rdadr:	lda	cursec
	rar
	mov	d,a
	mvi	a,0
	rar
	mov	e,a
	mov	a,d
	adi	HIGH ramwin
	mov	d,a
	lxi	h,rdbuf
	ret

Le608:	call	rdadr
	lhld	dmaadr
	lda	wrflg
	ora	a
	mvi	a,0
	jnz	Le5d3
	xchg
	mvi	a,8
	jmp	Le5d3

Le61d:	lda	newdrv
	sta	Lfcfc
	ret

Le624:	lda	fdcbuf+0
	ani	003h
	adi	'A'
	sta	Le633
	call	print
	db	CR,LF
Le633:	db	'A$'
	call	Le640
	rnz
	xra	a
	sta	usrdrv
	jmp	cpm

Le640:	call	print
	db	': not ready',16h,CR,BEL,'$'
	call	conin
	cpi	003h
	ret

; floppy drive SENSE, C=drive num
fdsens:	di
	mvi	b,4	; SENSE command
	call	fdcbeg
	mov	b,c	; drive select
	call	fdcout
	call	fdcin
	ei
	ret

print:	xthl
	mov	a,m
	inx	h
	cpi	'$'
	xthl
	rz
	push	b
	push	h
	push	d
	mov	c,a
	call	conout
	pop	d
	pop	h
	pop	b
	jmp	print

Le67b:	lda	Lfcd6
	ora	a
	jz	Le68f
	call	print
	db	CR,LF,'WRITE $'
	ret

Le68f:	call	print
	db	CR,LF,'READ $'
	ret

Le69b:	call	print
	db	'protect$'
	ret

recal:	call	Le6aa	; why twice, recursive?
Le6aa:	call	setmtr
	xra	a
	sta	fdcbuf+1
	mvi	b,007h	; RECALIBRATE command
	mvi	c,001h
	call	fdccmd
	jc	Le6aa
	ret

seek:	call	setmtr
	lda	curtrk
	lxi	h,fdcbuf+1
	cmp	m
	rz		; no SEEK needed
	mov	e,a
	lda	hlftrk
	ora	a
	mov	a,e
	jz	Le6d1
	rlc	; half-track, phytrk = logtrk*2
Le6d1:	mov	m,a	; fdcbuf+1
Le6d2:	mvi	b,00fh	; SEEK command
	mvi	c,2
	call	fdccmd
	jc	Le6d2
	mov	a,e
	sta	fdcbuf+1
	ret

; B=command, fdcbuf=params, C=num params
; returns NZ if error, CY if timeout
fdccmd:	lxi	h,fdcbuf
	di
	call	fdcbeg
Le6e8:	mov	b,m
	call	fdcout
	inx	h
	dcr	c
	jnz	Le6e8
	ei
	push	d
	push	b
	mvi	d,002h
	; wait for FDC intr - with timeout
Le6f6:	lxi	b,0
Le6f9:	dcx	b
	mov	a,b
	ora	c
	jz	Le710
	lxi	h,fdcres
	mov	a,m
	ora	a
	jz	Le6f9
	mvi	m,0
	inx	h
	mov	a,m
	ani	0c0h	; ST0 intr code (00=normal)
	pop	b
	pop	d
	ret

Le710:	dcr	d
	jnz	Le6f6
	lda	drvsz5	; drive type, 0=8"
	call	Le721
	call	Le624
	pop	b
	pop	d
	stc
	ret

; setup drives, A=0 for 8"
Le721:	ora	a
	jz	setdr8
	jmp	setdr5

; Begin FDC command sequence.
; B=byte
fdcbeg:	in	FDC_STS
	ani	01fh
	jnz	fdcbeg
; Send a byte to FDC.
; B=byte
fdcout:	in	FDC_STS
	ral
	jnc	fdcout
	mov	a,b
	out	FDC_DAT
	ret

fdcin:	in	FDC_STS
	ral
	jnc	fdcin
	in	FDC_DAT
	ret

; start motor and delay, if needed.
; re-sets drive timeout.
setmtr:	push	b
	lda	drvsz5
	ora	a
	jz	Le778
	lxi	h,fdcmtr-1
	lda	fdcbuf+0
	ani	003h
	mov	c,a
	inr	c
	mvi	a,10000000b	; MTR_DS0 rrc 1
Le756:	inx	h
	rlc
	dcr	c
	jnz	Le756
	; A = MTR_DS0/MTR_DS1/MTR_DS2/MTR_DS3
	mov	c,a
	di
	mov	a,m
	ora	a
	mvi	m,40	; 4.0 second timeout
	ei
	jnz	Le778	; drive is already active...
	lda	Lde6f
	ora	c
	sta	Lde6f
	out	FDC_CTL
	lxi	h,15000	; delay for motor on
Le772:	dcx	h
	mov	a,h
	ora	l
	jnz	Le772
Le778:	pop	b
	ret

; DPHs for drives A: to E: (DPBs may be filled in later)
dphtbl:
dph0:	dw	trn8m0,00000h,00000h,00000h,dirbuf,0000h,csv0,alv0
	db	0ffh	; fmt unknown
dph1:	dw	trn8m0,00000h,00000h,00000h,dirbuf,0000h,csv1,alv1
	db	0ffh	; fmt unknown
dph2:	dw	trn5m0,00000h,00000h,00000h,dirbuf,0000h,csv2,alv2
	db	0ffh	; fmt unknown
dph3:	dw	trn5m0,00000h,00000h,00000h,dirbuf,0000h,csv3,alv3
	db	0ffh	; fmt unknown
; extra DPH for ramdisk
	dw	00000h,00000h,00000h,00000h,dirbuf,dpbrd,csv4,alv4
	db	10h	; special format code?

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

conin:	lxi	h,Le920
Le95b:	lda	iobyte
Le95e:	rlc
Le95f:	ani	0110b
	call	addahl
	mov	a,m
	inx	h
	mov	h,m
	mov	l,a
	pchl

conout:	lxi	h,Le928
	jmp	Le95b

const:	lxi	h,Le948
	jmp	Le95b

rdrin:	lxi	h,Le930
Le978:	lda	iobyte
	jmp	Le98c

rdrst:	lxi	h,Le950
	jmp	Le978

punout:	lxi	h,Le938
	lda	iobyte
	rrc
	rrc
Le98c:	rrc
	jmp	Le95f

lstout:	lxi	h,Le940
	lda	iobyte
	rlc
	rlc
	jmp	Le95e

tick:	sspd	savst2
	lxi	sp,ticstk
	push	h
	push	b
	push	psw
	; check all floppy motor timeouts
	lxi	h,fdcmtr
	mvi	b,4	; 4 drives total?
	mvi	c,11111110b
Le9ac:	mov	a,m
	ora	a
	jrz	Le9ba
	dcr	m
	jrnz	Le9ba
	; timeout, shut motor off
	lda	Lde6f
	ana	c
	sta	Lde6f
Le9ba:	rlcr	c
	inx	h
	dcr	b
	jrnz	Le9ac
	lda	Lde6f
	out	FDC_CTL
	; HL=Lfd11
	mov	a,m
	ora	a
	jrz	ticret
	dcr	m
	jrnz	ticret
	; --Lfd11 == 0 (i.e. Lfd11-- == 1)
	mvi	m,1	; Lfd11=1
	lhld	ticcnt
	dcx	h
	mov	a,h
	ora	l
	shld	ticcnt
	jrnz	ticret
	xra	a
	sta	Lfd11
	inr	a
	sta	tichit	; flag reached count
	lda	ticena
	rrc
	jrc	Le9f1	; ticena==1
ticret:	pop	psw
	pop	b
	pop	h
	lspd	savst2
	ei
	reti

; call tick hook function before return to interrupted code.
Le9f1:	pop	psw
	pop	b
	pop	h
	lspd	savst2
	push	h
	lhld	ticfnc
	xthl
	ei
	reti

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
ticset:	mov	a,e
	sta	ticena
	shld	ticfnc
	lxi	h,ticcnt
	mov	m,c
	inx	h
	mov	m,b
	ani	003h
	cpi	001h
	jz	Lea2e
	cpi	002h
	jz	Lea3b
	mvi	a,0ffh
	ret

; Arm tick hook
Lea2e:	di
	mvi	a,001h
	sta	Lfd11
	ei
	xra	a
Lea36:	lxi	h,tichit
	mov	m,a
	ret

; Disarm/abort tick hook
Lea3b:	di
	xra	a
	sta	Lfd11
	ei
	mvi	a,001h
	jmp	Lea36

; process tick hook after I/O
ticfin:	di
	lda	Lfd11
	cpi	002h
	lda	Lfd12
	sta	Lfd11
	jz	Lea7a
	ora	a
	jz	Lea7a
	; tick fired while suspended, process it now
	push	h
	lhld	ticcnt
	dcx	h
	mov	a,h
	ora	l
	shld	ticcnt
	jnz	Lea79
	mvi	a,1
	sta	tichit
	lda	ticena
	rrc
	jnc	Lea79
	xra	a
	lhld	ticfnc
	xthl
	ei
	ret

Lea79:	pop	h
Lea7a:	ei
	xra	a
	ret

; ASCII keyboard input
akbin:	call	kbdst
	jrz	akbin
	dcr	m	; 1 => 0
	inx	h
	mov	a,m	; get key
	ret

; ASCII keyboard physical input (intr)
akbint:	push	psw
	push	h
	in	PIO2_A
	ani	07fh
	lxi	h,kbdinp
	mvi	m,001h	; non-zero flag
	inx	h
	mov	m,a	; ASCII input char
reti2:	pop	h
	pop	psw
nulint:	ei
	reti

; Generic keyboard input status (from interrupt).
; Returns 00 or FF only.
kbdst:	lxi	h,kbdinp
Lea9b:	mov	a,m
	ora	a
	rz
	mvi	a,0ffh
	ret

; PC keyboard physical input (intr)
pckbint:
	push	psw
	push	h
	push	b
	push	d
	in	PIO1_A	; scan code
	mov	e,a
	ani	07fh
	lxi	b,nmetas
	lxi	h,mtakey+nmetas-1
	ccdr
	lxi	h,mtaflg
	jrnz	pckkey
	mov	b,c	; index of match
	inr	b
	mvi	a,040h	; convert meta-code into bitmap
Leabb:	rrc
	djnz	Leabb
	mov	b,a
	bit	7,e	; set or clear?
	jrnz	pckclr
	mov	a,b
	cpi	010h
	jrnc	pcktog	; toggles...
	ora	m	; set bit
pckset:	mov	m,a
	jr	pckret

pcktog:	xra	m
	jr	pckset

pckclr:	mov	a,b
	cpi	010h
	jrnc	pckret	; not for toggles...
	cma		; clear bit
	ana	m	;
	mov	m,a
pckret:	pop	d
	pop	b
	pop	h
	pop	psw
	ei
	reti

; keyboard scan codes - meta keys
; bit 7 indicates "key released"
mtakey:	db	3ah	; Caps Lock	D5 (toggle)
	db	45h	; Num Lock	D4 (toggle)
	db	38h	; l/r Alt	D3
	db	1dh	; l/r Ctrl	D2
	db	2ah	; left Shift	D1
	db	36h	; right Shift	D0
nmetas	equ	$-mtakey

mtaflg:	db	0

pckkey:	bit	7,e
	jrnz	pckret	; ignore key-up events
	sta	kbdinp+1; non-zero
	sta	kbdinp	; key scan code
	mov	a,m
	sta	kbdinp+2	; meta-key modifiers
	jr	pckret

; PC keyboard input - convert scan code to ASCII
pckbin:	call	kbdst	; 00 or FF only
	inr	a
	jrnz	pckbin
	mov	m,a	; clear flag
	inx	h
	mov	c,m	; get key
	inx	h
	mov	e,m	; get modifiers
	mov	a,c
	cpi	nkpad
	jrc	Leb0c
	; numeric keypad codes...
	bit	4,e	; Num Lock?
	jrz	Leb0c
	adi	zkpad
	mov	c,a
Leb0c:	lxi	h,keymap-1
	mvi	b,0
	dad	b
	mov	a,m
	cpi	'a'
	jrc	Leb30
	cpi	'z'+1
	jrnc	Leb30
	bit	5,e	; Caps Lock?
	jrz	Leb21
	xri	020h	; flip case
Leb21:	mov	b,a
	mov	a,e
	ani	003h	; left/right SHIFT keys
	mov	a,b
	jrz	Leb2a
	xri	020h	; flip case
Leb2a:	bit	2,e	; Ctrl active?
	rz		; no - pass unchanged
	ani	01fh	; convert to control
	ret

Leb30:	cpi	' '+1
	jrnc	Leb36
	ora	a	; blank or ctl codes (?)
	ret

Leb36:	bit	7,a	; special mapping keys
	rz
	ani	07fh
	mov	c,a
	mov	a,e
	ani	003h
	lxi	h,Lebab-1
	jrz	Leb47
	lxi	h,Lebc1-1
Leb47:	dad	b
	mov	a,m
	jr	Leb2a

; Keyboard scan code map to ASCII
keymap:	db	ESC,81h,82h,83h,84h,85h,86h,87h,88h,89h,8ah,8bh,8ch,BS
	db	TAB,'qwertyuiop',8dh,8eh,CR
	db	NIL,'asdfghjkl',8fh,90h,91h,NIL
	db	92h,'zxcvbnm',93h,94h,95h,NIL,96h
	db	NIL,' ',NIL
	; function keys, left of main, vertical
	db	DC3,EOT,SOH,ACK,ENQ	; F1-F5
	db	DC2,CAN,ETX, SO, SI	; F6-F10
	db	0	; (Num Lock)
	db	0	; (Scroll Lock)
skpad	equ	$
nkpad	equ	skpad-keymap+1
	; Keypad, NumLock off, right of main
	db	SYN,SUB,ETB,'-'	; home,   up,  PgUp, -
	db	 BS, GS,NAK,'+'	; left,  ---, right, +
	db	ACK, LF,ENQ	;  end, down,  PgDn
	db	DC2,    DEL	;  Ins 	        Del
zkpad	equ	$-skpad
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

lptout:	in	PP_C
Lebd9:	ani	060h	; BS1/BSENS
	cpi	020h	; BS1=0, BSENS=1
	jrnz	Lec0f	; LPT: not attached
Lebdf:	lxi	d,0
	mvi	b,10
	lxi	h,lptbsy
Lebe7:	mov	a,m
	ora	a
	jrz	Lec03
	dcx	d
	mov	a,e
	ora	d
	jrnz	Lebe7
	djnz	Lebe7
	call	print
	db	CR,LF,'LPT$'
	call	Le640
	jrnz	Lebdf
	jmp	cpm

Lec03:	dcr	m	; set BUSY
	in	PP_C
	ani	010h	; BS0 - LPT: data inverted?
	mov	a,c
	jrnz	Lec0c
	cma
Lec0c:	out	PIO2_B
	ret

Lec0f:	call	print
	db	7,CR,LF,'LPT not coupled.  Waiting...$'
	call	ctrlC
	jr	lptout

; Wait for key, if ^C then reboot
ctrlC:	push	b
	call	conin
	pop	b
	cpi	CTLC
	rnz
	jmp	cpm

lptint:	push	psw
	xra	a
	sta	lptbsy
	pop	psw
	ei
	reti

uc1st:	lxi	h,bffcnt
	jmp	Lea9b

Lec51:	lxi	h,affcnt
	jmp	Lea9b

Lec57:	sta	Lec6f
	cpi	'A'
	lda	Lfd21
	jrz	Lec64
	lda	Lfd25
Lec64:	rlc
	rc
	call	print
	db	CR,LF,'SIO/'
Lec6f:	db	'? ERROR',16h,'$'
	jmp	ctrlC

arxint:	sspd	rxsav
	lxi	sp,rxstk
	push	psw
	push	h
	push	b
	in	SIO_A
	lxi	h,Lfd21
	ana	m
	mov	b,a
	dcx	h
	mov	a,m
	rrc
	jrc	Lec9d
	mov	a,b
	cpi	XON
	jrz	Lecd9
	cpi	XOFF
	jrz	Lecd2
	ora	a
	jrz	Lecbe
Lec9d:	lxi	h,affcnt
	mov	a,m
	cpi	127
	jrnc	Lecc8
	inr	m
	lhld	awrptr
	mov	m,b
	inx	h
	shld	awrptr
	lxi	b,0018fh
	dad	b
	jrnc	Lecba
	lxi	h,Lfdf2
	shld	awrptr
Lecba:	cpi	95
	jrnc	Lece4
Lecbe:	pop	b
	pop	h
	pop	psw
	lspd	rxsav
Lecc5:	ei
	reti

Lecc8:	lda	ffoflg
	ori	0100b
Leccd:	sta	ffoflg
	jr	Lecbe

Lecd2:	lda	ffoflg
	ori	0001b
	jr	Leccd

Lecd9:	lda	ffoflg
	bit	0,a
	jrz	Lec9d
	ani	11111110b
	jr	Leccd

; high-water mark SIO A
Lece4:	lda	ffoflg
	bit	1,a
	jrnz	Lecbe
	ori	0010b
	sta	ffoflg
	pop	b
	pop	h
	pop	psw
	lspd	rxsav
	sspd	axosav
	lxi	sp,axostk
	push	psw
	push	b
	call	Lecc5
	mvi	c,XOFF
	call	Led6d
	pop	b
	pop	psw
	lspd	axosav
	ret

aspint:	push	psw
	lda	ffoflg
	ori	0100b
	sta	ffoflg
	mvi	a,030h
	out	SIO_AC
	in	SIO_A
	jr	Led25

axtint:	push	psw
	mvi	a,010h
	out	SIO_AC
Led25:	pop	psw
	ei
	reti

Led29:	ani	0fbh
	mov	m,a
	mvi	a,'A'
	call	Lec57
	jr	Led37

Led33:	ei
	call	Led61
Led37:	lxi	h,ffoflg
	mov	a,m
	bit	2,a
	jrnz	Led29
	di
	lxi	h,affcnt
	mov	a,m
	ora	a
	jrz	Led33
	dcr	m
	ei
	cz	Led61
	lhld	ardptr
	mov	a,m
	inx	h
	shld	ardptr
	lxi	b,0018fh
	dad	b
	rnc
	lxi	h,Lfdf2
	shld	ardptr
	cmc
	ret

Led61:	lxi	h,ffoflg
	mov	a,m
	bit	1,a
	rz
	ani	0fdh
	mov	m,a
	mvi	c,XON
Led6d:	in	SIO_AC
	bit	5,a
	stc
	rz
	ani	004h
	jrz	Led6d
	mov	a,c
	out	SIO_A
	ret

Led7b:	lda	ffoflg
	ani	0001b
	jrnz	Led7b
	call	Led6d
	rnc
	mvi	a,'A'
	call	Lec57
	jr	Led7b

brxint:	sspd	rxsav
	lspd	rxsav
	push	psw
	push	h
	push	b
	in	SIO_B
	lxi	h,Lfd25
	ana	m
	mov	b,a
	dcx	h
	mov	a,m
	rrc
	jrc	Ledb1
	mov	a,b
	cpi	XON
	jrz	Lede5
	cpi	XOFF
	jrz	Leddd
	ora	a
	jz	Lecbe
Ledb1:	lxi	h,bffcnt
	mov	a,m
	cpi	127
	jrnc	Ledd5
	inr	m
	lhld	bwrptr
	mov	m,b
	inx	h
	shld	bwrptr
	lxi	b,0010fh
	dad	b
	jrnc	Ledce
	; wrap buffer
	lxi	h,Lfe72
	shld	bwrptr
Ledce:	cpi	95	; high water mark?
	jrnc	Ledf1
	jmp	Lecbe

Ledd5:	lda	ffoflg
	ori	040h	; dropped chars
	jmp	Leccd

Leddd:	lda	ffoflg
	ori	010h
	jmp	Leccd

Lede5:	lda	ffoflg
	bit	4,a
	jrz	Ledb1
	ani	11101111b
	jmp	Leccd

; high-water mark for SIO B
Ledf1:	lda	ffoflg
	bit	5,a
	jnz	Lecbe
	ori	00100000b
	sta	ffoflg
	pop	b
	pop	h
	pop	psw
	lspd	rxsav
	sspd	bxosav
	lxi	sp,bxostk
	push	psw
	push	b
	call	Lecc5
	mvi	c,XOFF
	call	uc1pot
	pop	b
	pop	psw
	lspd	bxosav
	ret

; SIO B special condition intr
bspint:	push	psw
	lda	ffoflg
	ori	01000000b
	sta	ffoflg
	mvi	a,030h
	out	SIO_BC
	in	SIO_B
	jmp	Led25

bxtint:	push	psw
	mvi	a,010h
	out	SIO_BC
	jmp	Led25

Lee37:	ani	10111111b
	mov	m,a
	mvi	a,'B'
	call	Lec57
	jr	uc1in

; get char from FIFO
Lee41:	ei
	call	Lee6f
uc1in:	lxi	h,ffoflg
	mov	a,m
	bit	6,a
	jrnz	Lee37
	di
	lxi	h,bffcnt
	mov	a,m
	ora	a
	jrz	Lee41
	dcr	m
	ei
	cz	Lee6f
	lhld	brdptr
	mov	a,m
	inx	h
	shld	brdptr
	lxi	b,0010fh
	dad	b
	rnc
	lxi	h,Lfe72
	shld	brdptr
	cmc
	ret

Lee6f:	lxi	h,ffoflg
	mov	a,m
	bit	5,a
	rz
	ani	11011111b
	mov	m,a
	mvi	c,XON
uc1pot:	in	SIO_BC
	bit	5,a
	stc
	rz
	ani	004h
	jrz	uc1pot
	mov	a,c
	out	SIO_B
	ret

; UC1: output
uc1out:	lda	ffoflg
	ani	010h
	jrnz	uc1out
	call	uc1pot
	rnc
	mvi	a,'B'
	call	Lec57
	jr	uc1out

	dw	0,0,0,0,0
rxstk:	ds	0
rxsav:	dw	0

	dw	0,0,0,0,0
axostk:	ds	0
axosav:	dw	0

	dw	0,0,0,0,0
bxostk:	ds	0
bxosav:	dw	0

Leebf:	call	ticsus
	sspd	crtsav
	lxi	sp,crtstk
	pushix
	lxix	crtstr
	lda	crtstr+14
	setb	2,a	; enable WR vid ram
	out	CRT_CTL
	call	Lef13
Leed9:	lda	crtstr+14
	out	CRT_CTL
	popix
	lspd	crtsav
	jmp	ticfin

Leee7:	call	ticsus
	sspd	crtsav
	lxi	sp,crtstk
	pushix
	lxix	crtstr
	lda	crtstr+14
	setb	2,a	; enable CRT RAM access
	out	CRT_CTL
	mvi	a,020h
	call	crttgl	; set mode bit
	call	crtupd	; update attr/pos
	jr	Leed9

; suspend any tick hook action
ticsus:	di
	lxi	h,Lfd11
	mov	a,m
	mvi	m,002h
	inx	h
	mov	m,a
	ei
	ret

Lef13:	lxi	h,crtstr+4
	mov	a,m
	ora	a
	jnz	Lf0f8	; ESC prefix
	mov	a,c
	bitx	6,+2
	jrnz	Lef27
	ani	07fh
	cpi	DEL
	rz
Lef27:	cpi	' '
	jrc	Lef37
	lhld	crtstr+7
	mov	m,a
	lda	crtstr+11
	sta	crtstr+9
	jr	Lef47

Lef37:	lxi	h,Lf2cc
	lxi	b,nf2cc
	lxi	d,Lf2f1
	jmp	Lf190

; NAK / ESC C processing
; move right? (wrap to next row - if enabled)
curri:	setx	5,+3
Lef47:	lda	crtstr+0
	cmpx	+5
	jrnc	Lef54
	inrx	+0
	jr	Lefa2
; at rightmost col
Lef54:	bitx	1,+2
	rz
	mvix	0,+0
	lda	crtstr+1
	cmpx	+6
	jrnc	Lef6e
Lef65:	inrx	+1
	cpi	11
	jrnz	Lefa2
	jr	Lef87
; at bottom of screen
Lef6e:	bitx	5,+3
	jrnz	Lef7d
	bitx	3,+2
	jrz	Lef7d
	call	conin
Lef7d:	bitx	0,+2
	jrz	Lef9b
	mvix	0,+1
Lef87:	bitx	5,+3
	jrnz	Lefa2
	call	crtupd
	bitx	4,+2
	rz
	mvi	a,12-1
	inr	a	; A=12, NZ
	jmp	Lf1b6

Lef9b:	resx	5,+3
	jmp	Lf09e

Lefa2:	resx	5,+3
	jr	crtupd

; TAB to next 8th col
Lefa8:	lda	crtstr+0
	ani	11111000b
	adi	8
	cmpx	+5
	jrc	Lefb5
	dcr	a
Lefb5:	sta	crtstr+0
	jr	crtupd

curle:	lda	crtstr+0
	ora	a
	jrz	Lefc5
	dcrx	+0
	jr	crtupd

Lefc5:	bitx	1,+2
	rz
	; reverse-wrap line
	lda	crtstr+5
	sta	crtstr+0
	lda	crtstr+1
	ora	a
	jrnz	Lefe5
	bitx	0,+2
	jz	Lf08d
	; reverse wrap screen
	lda	crtstr+6
	sta	crtstr+1
	jr	crtupd

Lefe5:	dcrx	+1
; update cursor position/etc
crtupd:	lhld	crtstr+7	; cursor location
	lda	crtstr+9
	inx	h
	mov	m,a	; restore mode at cursor
	lda	crtstr+1	; row
	ldx	e,+0		; col
	call	crtadr		; compute new position
	shld	crtstr+7	; set new cursor adr
Leffc:	inx	h
	mov	a,m
	sta	crtstr+9	; cache mode
	bitx	5,+2
	rnz
	; show cursor as rev-vid
	cma
	mov	m,a
	ret

curdn:	lda	crtstr+1
	cmpx	+6
	jrnc	Lf016
	inrx	+1
	jr	crtupd

Lf016:	bitx	0,+2
	rz
	mvix	0,+1
	jr	crtupd

curup:	xra	a
	cmpx	+1
	jrnc	Lf02c
Lf027:	dcrx	+1
	jr	crtupd

Lf02c:	bitx	0,+2
	rz
	lda	crtstr+6
	sta	crtstr+1
	jr	crtupd

; carriage return (possible auto-linefeed)
; A=CR
Lf039:	mvix	0,+0
	bitx	2,+2
	jrz	crtupd
Lf043:	lda	crtstr+1
	cmpx	+6
	jnc	Lef7d
	jmp	Lef65

Lf04f:	resx	0,+2	; ESC I - turn off screen wrap?
clrscr:	mvi	a,004h	; off, ena RAM
	out	CRT_CTL
	lda	crtstr+11
	sta	crtstr+9
	xra	a
	sta	crtstr+10
	call	Lf19e
	di
	; setup vert. blanking intr
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3
	mvi	a,001h	; TC=1 (immediate)
	out	CTC1_3
	ei
	mvi	b,001h
	ldx	e,+11
	bitx	1,+3
	jrz	Lf07b
	mvi	e,007h
Lf07b:	call	Lf1a9
curhom:	lxi	h,0
	shld	crtstr+0
	jmp	crtupd

revidx:	lda	crtstr+1	; cursor row...
	ora	a
	jrnz	Lf027	; OK to decr
	; must scroll backwards...
Lf08d:	lda	crtstr+10
	ora	a
	jrz	Lf098	; at top row?
	dcrx	+10
	jr	Lf0ae

Lf098:	mvix	24,+10
	jr	Lf0ae

Lf09e:	lda	crtstr+10
	cpi	24
	jrnc	Lf0aa
	inrx	+10
	jr	Lf0ae
Lf0aa:	mvix	0,+10
Lf0ae:	di
	; setup vert. blanking intr
	mvi	a,0cfh
	out	CTC1_3	; intr, ctr, falling, TC, reset
	mvi	a,001h
	out	CTC1_3
	ei
	bitx	1,+3
	jrz	Lf0cb
	mvi	a,24
	call	crtadr0
	lxi	b,(1 shl 8)+80
	mvi	e,007h
	call	Lf1a7
Lf0cb:	ldx	a,+1
	call	crtadr0
	lxi	b,(1 shl 8)+80
	call	Lf1a4
	jmp	crtupd

; alternate vert. blanking interrupt...
; on-shot, only triggers when something changes
; CRT_ROW naturally stays in-sync?
vertbl:	push	psw
	lda	crtstr+10
	out	CRT_ROW
	lda	crtstr+16
	out	CRT_HUE
	mvi	a,003h	; disable intr
	out	CTC1_3
reti1:	pop	psw
	ei
	reti

; vert. blanking in graphics mode. no pages...
; same as Jr80 CTC ch1 - fires continuously
; CRT_ADR must be re-set every frame
Lf0ed:	push	psw
	xra	a
	out	CRT_ADR
	jr	reti1

escseq:	mvix	1,+4
	ret

; ESC prefix
Lf0f8:	dcr	a
	jrz	Lf104	; first char after ESC
	dcr	a
	jrz	Lf11d	; 2 = ESC Y x
	dcr	a
	jrz	Lf136	; 3  = EXC Y R x
	mvi	m,0	; clear ESC count
	ret

Lf104:	mov	a,c
	cpi	'a'
	jrc	Lf10f
	cpi	'z'+1
	jrnc	Lf10f
	ani	01011111b	; toupper
Lf10f:	mvi	m,0	; clear ESC flag
Lf111:	lxi	h,Lf2f3
	lxi	b,00005h
	lxi	d,Lf300
	jmp	Lf190

Lf11d:	mvi	m,3	; next is 3
	mov	a,c
	sui	' '
	bitx	4,+3
	jrnz	Lf12f	; ESC 1 case...
	call	Lf236	; normalize row
	sta	crtstr+1; row
	ret

Lf12f:	call	Lf22e		; normalize col
	sta	crtstr+0	; save new col
	ret

Lf136:	mvi	m,0	; done with ESC
	mov	a,c
	sui	' '
	bitx	4,+3
	jrz	Lf14a
	; ESC 1 case...
	call	Lf236		; normalize row
	sta	crtstr+1	; row
	jmp	crtupd

Lf14a:	call	Lf22e		; normalize col
	sta	crtstr+0	; column
	jmp	crtupd

Lf153:	mvi	a,010h
	jr	crttgl

Lf157:	mvi	a,001h
	jr	crttgl

Lf15b:	mvi	a,002h
	jr	crttgl

Lf15f:	mvi	a,040h
	jr	crttgl

Lf163:	mvi	a,008h
; Toggle CRT mode bit at crtstr+2
crttgl:	lxi	h,crtstr+2
	xra	m
	mov	m,a
	ret

; func 15 - normal video?
nrmvid:	bitx	0,+3
	rz
	resx	0,+3
	jr	Lf17f

; func 14 - reverse video?
revvid:	bitx	0,+3
	rnz
	setx	0,+3
	; reverse video? xRGBxRGB background/foreground?
Lf17f:	lxi	h,crtstr+11
	mov	a,m
	ani	088h
	mov	c,a
	mov	a,m
	rlc
	rlc
	rlc
	rlc
	ani	077h
	ora	c
	mov	m,a
	ret

Lf190:	ccir
	rnz
	slar	c
	xchg
	ora	a
	dsbc	b
	mov	e,m
	inx	h
	mov	d,m
	xchg
	pchl

; clear screen
Lf19e:	lhld	crtstr+12
	lxi	b,(24 shl 8)+80
Lf1a4:	ldx	e,+11
Lf1a7:	mvi	d,' '
Lf1a9:	mov	m,d
	inx	h
	mov	m,e
	inx	h
	dcr	c
	jrnz	Lf1a9
	mvi	c,80
	djnz	Lf1a9
	ret

eraeol:	xra	a
Lf1b6:	push	psw
	lda	crtstr+0
	bitx	2,+3
	jrz	Lf1c1
	add	a
Lf1c1:	mov	c,a
	mvi	a,80
	sub	c
	mov	c,a
	lhld	crtstr+7
Lf1c9:	mvi	b,001h
	call	Lf1a4
	pop	psw
	jrz	Lf1e0
	dcr	a
	jrz	Lf1e0
	push	psw
	push	d
	mov	a,h
	ani	00fh
	mov	h,a
	call	Lf212
	pop	d
	jr	Lf1c9

Lf1e0:	lhld	crtstr+7
	jmp	Leffc

eraeop:	lhld	crtstr+0
	mov	a,l
	ora	h
	jz	clrscr
	lda	crtstr+6
	subx	+1
	inr	a
	jr	Lf1b6

crtadr0:	; compute address of line
	mvi	e,0
; E = column, A=row
crtadr:	bitx	2,+3
	jrz	Lf201
	slar	e
Lf201:	addx	+10	; "home" row on CRT
	mov	d,a
	add	a
	add	a
	add	d	; *5
	mvi	h,0
	mov	d,h
	mov	l,a
	dad	h
	dad	h
	dad	h
	dad	h	; (*5)*16 = *80
	dad	d	; +col
	dad	h	; *2 (attr, 2 byte/cell)
Lf212:	xchg
	lxi	h,-4000	; wrap-point for addresses (25*80)*2
	dad	d
	jrnc	Lf21a
	xchg
Lf21a:	lhld	crtstr+12
	dad	d
	ret

Lf21f:	setx	4,+3
	jr	Lf229

; ESC Y (cursor addressing?)
Lf225:	resx	4,+3
Lf229:	mvix	2,+4
	ret

Lf22e:	cmpx	+5	; check max col
	rc
	lda	crtstr+5	; use max col
	ret

Lf236:	cmpx	+6	; check max row
	rc
	lda	crtstr+6	; force max row
	ret

; beep the speaker
beep:	in	PP_A
	ori	PPA_SPK
	out	PP_A
	lxi	b,08000h	; 250mS @ 2MHz
Lf247:	dcr	c
	jrnz	Lf247
	djnz	Lf247
	ani	NOT PPA_SPK
	out	PP_A
	ret

; screen print?
prtscr:	pop	h
	pop	h
	shld	pscshl
	lhld	crtsav
	shld	pscsav
	lxi	sp,pscstk
	lda	crtstr+14
	out	CRT_CTL
	call	ticfin
	xra	a
	ldx	c,+6
	inr	c	; num rows
Lf26c:	ldx	b,+5
	inr	b	; num cols
	mvi	e,0	; cur
Lf272:	push	psw
	push	b
	push	d
	call	crtadr	; compute CRT RAM addr
	lda	crtstr+14
	setb	2,a	; enable access CRT RAM
	di
	out	CRT_CTL
	mov	c,m	; get character
	res	2,a
	out	CRT_CTL
	ei
	call	lstout
	pop	d
	inr	e
	pop	b
	pop	psw
	djnz	Lf272
	push	psw
	push	b
	mvi	c,CR
	call	lstout
	mvi	c,LF
	call	lstout
	pop	b
	pop	psw
	inr	a
	dcr	c
	jrnz	Lf26c
	lixd	pscshl
	lspd	pscsav
	ret

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
extfnc:	pushix
	lxix	crtstr
	mov	a,b
	ora	a
	jz	Lf408	; func 0 - CRT modes?
	cpi	005h
	jrz	crtpag
	cpi	009h
	jrz	setclr	; set pixel/text color?
	cpi	00bh
	jrz	Lf3d0
	cpi	00fh
	jrz	Lf3e0
	cpi	010h
	jrz	Lf3eb
ixret3:	popix
	ret

; function 5 - set text page
crtpag:	bitx	1,+14
	jrnz	ixret3	; ignored in graphics mode?
	mov	a,c
	ani	003h
	mov	c,a
	ldx	e,+18
	sta	crtstr+18	; 000000xx
	rrc
	rrc
	sta	crtstr+16	; xx000000 - for hardware
	rrc
	rrc
	ori	HIGH crtram	; 01xx0000 - for s/w
	sta	crtstr+13
	lxi	h,crtstr+19
	mvi	d,0
	mov	b,d
	dad	d
	lda	crtstr+10	; current row...
	mov	m,a	; save it
	dsbc	d
	dad	b
	mov	a,m	; new row...
	sta	crtstr+10	; set it
	di
	; setup vert. blanking intr
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3
	mvi	a,001h
	out	CTC1_3
	ei
	jr	ixret3

; Set pixel/text color (foreground)
; function 9, C=color
setclr:	bitx	1,+14	; graphics mode?
	jrnz	Lf3c0
	stx	c,+11	; text color
	jr	ixret3

; C=pixel color
Lf3c0:	mov	a,c
	ani	003h
	mov	c,a
	mvi	b,003h
Lf3c6:	rlc		; replicate 000000xx in all positions
	rlc
	add	c
	djnz	Lf3c6
	sta	crtstr+15
	jr	ixret3

; func 11 - set background?
Lf3d0:	bitx	1,+14
	jrz	ixret3	; ignored in text?
	mov	a,c
	ani	00111111b
	sta	crtstr+16
	out	CRT_HUE
	jr	ixret3

Lf3e0:	ldx	b,+16
	mov	a,b
	ani	11000000b	; preserve text page
	orax	+17		; add color
	jr	ixret3

; C=bitmap
Lf3eb:	lda	whooks
	ana	c
	jrz	ixret
	cpi	004h	; hook 2
	jrz	Lf3fb
	cpi	008h	; hook 3
	jrz	Lf400
	jr	ixret

Lf3fb:	lhld	Lf508
	jr	Lf403

Lf400:	lhld	Lde4e+1
Lf403:	dcx	h
	mov	a,m
ixret:	popix
	ret

; alter CRT modes?
; C=mode
Lf408:	mov	a,c
	lxi	d,(24 shl 8)+79	; 25x80
	lxi	h,0
	dcr	a
	jrz	Lf42c	; C==1 - text 40x25, blink
	dcr	a
	dcr	a
	jrz	Lf438	; C==3 - text, 80x25, blink
	dcr	a
	jz	Lf49b	; C==4 = graphics, 320x200
	dcr	a
	dcr	a
	jz	Lf4a9	; C==6 - graphics, 640x200
	dcr	d	; 23 lines (80x24/40x24)
	dcr	a
	dcr	a
	jrz	Lf434	; C==8 - text, VT52, 80x24, blink
	dcr	a
	jnz	ixret3
	;		; C==9 - text, 80x24, blink
	setb	1,h	; crtstr+3
	jr	Lf438

; (C==1) 40x25, text, blink
Lf42c:	mvi	e,39	; 39 cols?
	mvi	a,00101000b	; blink, on, text, 40x25, lo-res
	setb	2,h	; crtstr+3
	jr	Lf43a	; ZR

; (C==8) 80x24, VT52, text, blink
Lf434:	lxi	h,(12h shl 8)+82h	; default/init modes
	inr	a	; NZ
; entered with ZR unless fallthrough
Lf438:	mvi	a,00101001b	; blink, on, text, hi-res
Lf43a:	call	Lf4c8	; flags not altered
	mvix	007h,+11
	lxi	h,Lf4f6
	jrz	Lf449
	; NZ case... ??? modes
	lxi	h,Lf4e4
Lf449:	lxi	b,9
	lxi	d,Lef37
	ldir
	lxi	d,Lf111
	lxi	b,9
	ldir
	xra	a
	sta	crtstr+16
	sta	crtstr+18
	lxi	h,vertbl
	shld	Lde86
	lxi	h,Leebf
	lxi	d,Leee7
Lf46c:	push	d
	push	h
	mvi	c,CAN	; clear screen
	call	callhl	; conout to CRT:
	pop	h
	shld	Le92a
	shld	Le93a
	shld	Le942
	pop	h
	shld	Lde51+1
	bitx	1,+14	; graphics mode?
	jrz	ixret2	; skip if text mode
	lxi	h,Lf0ed
	shld	Lde86
	di
	; setup vert. blanking intr
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3
	mvi	a,1	; TC=1 (immediate)
	out	CTC1_3
	ei
ixret2:	popix
	ret

callhl:	pchl

; (C==4) 320x200 graphics
Lf49b:	mvi	e,39
	setb	2,h	; crtstr+3
	mvix	0ffh,+15
	mvi	b,020h		; color palette?
	mvi	a,00001010b	; graphics, 320x200, on
	jr	Lf4ad

; (C==6) graphics, 640x200
Lf4a9:	mvi	b,007h		; white?
	mvi	a,00011010b	; 640x200, on, graphics
Lf4ad:	push	h
	lxi	h,whooks
	bit	2,m	; hook 2?
	pop	h
	jrz	ixret2
	call	Lf4c8
	mov	a,b
	sta	crtstr+16
	out	CRT_HUE
	lhld	Lf508
	lded	Lf50a
	jr	Lf46c

; A = new CRT_CTL
; HL = new flags
; DE = new max row/col
; C = new crtstr+17
Lf4c8:	sta	crtstr+14	; set new CRT mode
	shld	crtstr+2	; and flags
	lxi	h,0
	shld	crtstr+0	; home cursor
	mvi	h,HIGH crtram	; CRT RAM at 04000h...
	shld	crtstr+12
	shld	crtstr+7
	sded	crtstr+5	; max row/col
	stx	c,+17
	ret

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
grphcs:	push	d
	mov	e,m
	inx	h
	mov	d,m
	lda	crtstr+14
	bit	4,a	; 640x200? (320x200)
	lxi	h,-320
	jrz	Lf532
	dad	h	; -640
Lf532:	dad	d
	pop	h
	rc
	push	d
	mov	e,m
	inx	h
	mov	d,m
	lxi	h,199
	dsbc	d
	xchg
	pop	h	; HL=column, DE=row
	rc
	sspd	crtsav
	lxi	sp,crtstk
	push	h
	mov	h,d
	mov	l,e
	dad	h
	dad	h
	dad	d	; *5
	dad	h
	dad	h
	dad	h
	dad	h	; *80
	xthl		; TOS=column, HL=row
	lda	crtstr+14
	bit	4,a
	jrnz	Lf578	; if 640x200
	lda	crtstr+15
	ani	003h
	mov	d,a	; D=
	mvi	a,003h	; 4 pixels per column?
	ana	l
	mov	b,a
	mvi	a,003h	; 2 bits per pixel
	inr	b
	push	b
Lf568:	rrc		; 0=xx000000, 1=00xx0000...
	rrc
	djnz	Lf568
	mov	e,a	; E=mask
	pop	b
	mov	a,d
Lf56f:	rrc
	rrc
	djnz	Lf56f
	mov	d,a
	mvi	b,002h
	jr	Lf586

Lf578:	mvi	a,007h	; 8 pixels per column?
	ana	l
	mov	b,a
	inr	b
	mvi	a,001h	; 1 bit per pixel (monochrome?)
Lf57f:	rrc		; 0=x0000000, 1=0x000000...
	djnz	Lf57f
	mov	e,a
	mov	d,a
	mvi	b,003h
Lf586:	xchg
	xthl
Lf588:	srlr	d
	rarr	e
	djnz	Lf588
	mvi	a,HIGH crtram
	add	d
	mov	d,a
	dad	d
	pop	d
	di
	lda	crtstr+14
	setb	2,a
	out	CRT_CTL
	mov	b,m
	mov	a,e
	cma
	inr	c
	dcr	c
	jrz	Lf5b7	; C=0
	dcr	c
	jrz	Lf5bf	; C=1
	dcr	c
	jrz	Lf5ba	; C=2
	ana	b	; C=3 - set value D
	ora	d
Lf5ab:	mov	m,a
Lf5ac:	lda	crtstr+14
	out	CRT_CTL
	ei
	lspd	crtsav
	ret

; C=0 - clear bits
Lf5b7:	ana	b
	jr	Lf5ab

; C=2 - get bit value?
Lf5ba:	mov	a,b
	ana	e
	mov	b,a	; return value only?
	jr	Lf5ac

; C=1 - ???
Lf5bf:	ana	b
	mov	c,a
	mov	a,b
	cma
	ana	e
	ora	c
	jr	Lf5ab

; add A to HL
addahl:	add	l
	mov	l,a
	mov	a,h
	aci	000h
	mov	h,a
	ret

fill:	stax	d
	inx	d
	dcr	c
	jnz	fill
	ret

; overlayed???
; JMP Lf5d5 is planted in CCP at ccp$pg+7 (boot entry)
; This is the true cold start...
secbuf:	ds	0	; ds 1024...
Lf5d5:	di
	xra	a
	out	DMA_CTL
	lxi	sp,00100h
	im2
	mvi	a,HIGH Lde70
	stai
	; CTC init...
	lxi	d,05fdfh
	lxi	h,02f01h
	mvi	c,CTC1_0
	outp	d	;05fh - di, ctr, rising, TC, reset
	mvi	a,000h
	outp	a	;000h - TC=256 - from 307.18KHz
	mvi	a,080h	; 1.2KHz
	outp	a	;080h - intvec 80/82/84/86
	inr	c	;CTC1_1
	mvi	a,0dfh	; ei, ctr, rising, TC, reset
	outp	a	;0dfh
	mvi	a,078h	; TC=120 - from ch0
	outp	a	; 10Hz
	inr	c	;CTC1_2
	inr	c	;CTC1_3
	inr	c	;CTC2_0
	; second CTC? same as Jr. 020h?
	outp	d	;05fh
	outp	l	;001h
	mvi	a,088h
	outp	a	;088h - intvec 88/8a/8c/8e
	inr	c	;CTC2_1
	inr	c	;CTC2_2
	outp	d	;05fh
	outp	l	;001h
	inr	c	;CTC2_3
	outp	e	;0dfh
	outp	l	;001h
	; i8253 - same as Jr80 70h?
	mvi	a,016h	; ctr 0: LSB only, mode 3, bin
	out	CTR_C
	mvi	a,008h	; count[0]=8 (9600baud)
	out	CTR_0
	mvi	a,056h	; ctr 1: LSB only, mode 3, bin
	out	CTR_C
	mvi	a,008h	; count[1]=8 (9600baud)
	out	CTR_1
	mvi	a,0b6h	; ctr 2: LSB+MSB, mode 3, bin
	out	CTR_C
	mvi	a,LOW 951	; count[2]=0x03b7=951 (1292 Hz?)
	out	CTR_2
	mvi	a,HIGH 951
	out	CTR_2
	;
	mvi	a,089h	; A mode0 out, B mode0 out, C input
	out	PP_CTL
	mvi	a,PPA_SPG
	out	PP_A
	mvi	a,PPB_KRS	; enable kbd
	out	PP_B
	; Z80-PIO
	mvi	a,04fh	; mode 1 input
	out	PIO1_AC
	mvi	a,LOW piovec	; intr vector
	out	PIO1_AC
	; Z80-PIO
	mvi	a,04fh	; mode 1 input
	out	PIO2_AC
	mvi	a,00fh	; mode 0 output
	out	PIO2_BC
	mvi	a,LOW p2avec	; intr vec
	out	PIO2_AC
	mvi	a,LOW p2bvec	; intr vec
	out	PIO2_BC
	mvi	a,083h	; enable intr
	out	PIO2_BC
	; Z80-SIO
	mvi	b,8
	mvi	c,SIO_AC
	lxi	h,Lf8e1
	outir
	mvi	b,11
	inr	c	; SIO_BC
	lxi	h,Lf8de
	outir
	; zero memory
	lxi	d,Lfcd5
	mvi	c,066h	; B=0 from outir
	xra	a
	call	fill
	lxi	h,04c05h
	shld	Lfd1e
	shld	Lfd22
	mvi	a,0ffh
	sta	Lfd21
	sta	Lfd25
	mvi	a,00010001b
	sta	whooks
	lxi	sp,whooks+17
	lxi	h,nulfnc
	push	h
	push	h
	push	h
	push	h
	push	h
	push	h
	push	h
	push	h
	lxi	sp,tpa
	in	PIO1_B
	ani	CFG_RD
	lxi	h,Lf8f2
	mvi	m,0
	jrz	Lf6a5
	mvi	m,5
Lf6a5:	mvi	a,10111111b	; CON:=UC1: RDR:=UR2: PUN:=UP2: LST:=LPT:
	sta	defiob
	in	PIO1_B
	mov	b,a
	ani	CFG_SER		; serial console?
	jrnz	Lf6ea
	; internal console
	mvi	a,10111101b	; CON:=CRT: RDR:=UR2: PUN:=UP2: LST:=LPT:
	sta	defiob
	; setup vert. retrace intr
	mvi	a,0cfh	; intr, ctr, falling, TC, reset
	out	CTC1_3
	mvi	a,001h	; TC=1 (immediate)
	out	CTC1_3
	; setup keyboard
	mvi	l,083h	; EI on PIO chA
	mvi	c,PIO2_AC	; ASCII kbd
	mov	a,b
	ani	CFG_PCK		; PC keyboard?
	jrz	Lf6e8
	; PC keyboard
	exx
	lxi	h,pckbin
	shld	Le922
	shld	Le932
	exaf
	; perform PC kbd clear-out...
	in	PP_B
	ani	NOT PPB_KRS	; disable kbd
	out	PP_B
	lxi	b,2048	; delay some time
Lf6db:	dcr	c
	jrnz	Lf6db
	djnz	Lf6db
	ori	PPB_KRS		; re-enable kbd
	out	PP_B
	;
	exaf
	exx
	; TODO: fallthrough enables *both* keyboards...
	; jr	Lf6ea	;???
; ASCII (parallel) keyboard
	mvi	c,PIO1_AC	; ASCII kbd
Lf6e8:	outp	l		; set kbd intr
	; setup disk drives
Lf6ea:	mov	a,b	; sys cfg dipsw
	ani	CFG_501	; 5.25" drives?
	lxi	h,trn8m0
	jrz	Lf6fa
	mvi	a,'5'
	sta	Lf783
	lxi	h,trn5m0
Lf6fa:	shld	dph0
	shld	dph1
	mov	a,b
	ani	CFG_523
	lxi	h,trn8m0
	jrz	Lf710
	mvi	a,'5'
	sta	Lf79b
	lxi	h,trn5m0
Lf710:	shld	dph2
	shld	dph3
	mov	a,b
	ani	CFG_501
	jz	Lf869	; 8" drives
	call	setdr5	; drive A: is 5", set it up
Lf71f:	ei
	lda	defiob
	sta	iobyte
	xra	a
	sta	usrdrv
	call	print
	db	CAN,CR,LF
	db	'Tpd-80 DOS vers. '
	db	((VERS/100) MOD 10)+'0'
	db	'.'
	db	((VERS/10) MOD 10)+'0'
	db	(VERS MOD 10)+'1'
	db	' A  ** 57k CP/M 2.2 compatible **',CR,LF
	db	BEL,'$'
	call	print
	db	CR,LF
	db	'Disk drives A & B : '
Lf783:	db	'8"',CR,LF
	db	'Disk drives C & D : '
Lf79b:	db	'8"',CR,LF,'$'
	lda	Lf8f2
	ora	a
	mvi	a,4	; total number of drives supported
	jz	Lf817
	call	print
	db	'Virtual disk E: in configuration',CR,LF
	db	'192 kbytes storage capacity',CR,LF
	db	'Format Vdisk ? (y/*): $'
	call	conin
	push	psw
	mov	c,a
	call	conout
	pop	psw
	ani	11011111b	; toupper
	cpi	'Y'
	cz	Lf86f	; erase
	cnz	Lf88f	; refresh (always called?)
	mvi	a,005h
Lf817:
	sta	Ldf6a+1
	in	PIO1_B
	mov	b,a
	ani	CFG_SER
	jnz	cboot	; silently cboot?
	call	print
	db	CR,LF,'Console input : $'
	mov	a,b
	ani	CFG_PCK
	jz	Lf85a
	call	print
	db	'serial$'
Lf848:	call	print
	db	' keyboard',CR,LF,'$'
	jmp	cboot

Lf85a:	call	print
	db	'parallel$'
	jmp	Lf848

Lf869:	call	setdr8	; setup 8" drives
	jmp	Lf71f

; erase all of ramdisk...
Lf86f:	mvi	e,002h
	call	Lf8ae
	mvi	e,003h
	call	Lf8ae
	mvi	e,004h
	call	Lf8ae
	mvi	e,005h
	call	Lf8ae
	mvi	e,006h
	call	Lf8ae
	mvi	e,007h
	call	Lf8ae
	xra	a
	ret

; "refresh" all of ramdisk
Lf88f:	mvi	e,002h
	call	Lf8ca
	mvi	e,003h
	call	Lf8ca
	mvi	e,004h
	call	Lf8ca
	mvi	e,005h
	call	Lf8ca
	mvi	e,006h
	call	Lf8ca
	mvi	e,007h
	call	Lf8ca
	ret

; Erase a 32K chunk of ramdisk, E=bank
; returns NZ (if hi bits in PP_A)
Lf8ae:	in	PP_A
	ani	NOT PPA_BNK
	ora	e
	out	PP_A
	lxi	h,04000h
	lxi	b,07fffh
	push	h
	pop	d
	mvi	m,0e5h
	inx	h
	xchg
	ldir
Lf8c3:	in	PP_A
	ani	NOT PPA_BNK	;return to bank 0
	out	PP_A
	ret

; "refresh" a 32K chunk of ramdisk
; clears flags (NZ)
Lf8ca:	in	PP_A
	ani	NOT PPA_BNK	; mask off current bank
	ora	e		; add new bank
	out	PP_A		; select bank
	lxi	h,03fffh
Lf8d4:	inx	h
	mov	a,h
	cpi	0c0h
	jrz	Lf8c3
	mov	a,m
	mov	m,a
	jr	Lf8d4

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
	ds	1024-($-secbuf)

dirbuf:	ds	128	; scratch buffer for BDOS

alv0:	ds	512/8	; ALV0 - space for 512 blocks
csv0:	ds	256/4	; CSV0 - space for 256 dir ents
alv1:	ds	512/8	; ALV1
csv1:	ds	256/4	; CSV1
alv2:	ds	512/8	; ALV2
csv2:	ds	256/4	; CSV2
alv3:	ds	512/8	; ALV3
csv3:	ds	256/4	; CSV3
alv4:	ds	512/8	; ALV4
csv4:	ds	256/4	; CSV4

Lfcd5:	ds	1
Lfcd6:	ds	1	; write flag (again?)
Lfcd7:	ds	1
newdrv:	ds	1	; drive passed to seldsk
curdph:	ds	2	; current drive's DPH
drvfmt:	ds	1	; FF if first access to drive (login)
fmtdpb:	ds	2	; point to dpb addr in fmt struct
curtrk:	ds	2
curfmt:	ds	1
cursec:	ds	1
Lfce2:	ds	1
dmaadr:	ds	2
wrflg:	ds	1	; 1=write disk
Lfce6:	ds	1
Lfce7:	ds	2
curblm:	ds	1	; DPB.BLM+1
Lfcea:	ds	1	; newdrv
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
wrcmd:	ds	1	; write command (from fdXfmY buffers)
rdcmd:	ds	1	; read command (from fdXfmY buffers)

Lfd08:	ds	1
drvsz5:	ds	1	; drive type, 0=8"
Lfd0a:	ds	1
hlftrk:	ds	1	; 1=half-track mode (40t media in 80t drive)
cursid:	ds	1

; These three must be adjacent
fdcmtr:	ds	4	; motor/access timeouts for each drive
Lfd11:	ds	1	; enable/prescale for ticcnt tick counter
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

; Used for both keyboards - consumer must translate scan codes if needed.
kbdinp:	ds	1	; KBD: input status flag (non-zero)
	ds	1	; KBD: input character
	ds	1	; KBD: meta keys - modifiers
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
