; Disassembly of SYSGENT.COM from tpd801.td0

CR	equ	13
LF	equ	10

cpm	equ	0
bdos	equ	5
fcb	equ	005ch
dma	equ	0080h
tpa	equ	0100h
system	equ	0900h

;BDOS funcs
fconin	equ	1
fconout	equ	2
openf	equ	15
readf	equ	20

;BIOS offsets to wboot
bseldsk	equ	24
bsettrk	equ	27
bsetsec	equ	30
bsetdma	equ	33
bread	equ	36
bwrite	equ	39
bsectrn	equ	45

	org	tpa
	jmp	start

	db	'COPYRIGHT (C) 1978, DIGITAL RESEARCH'
	db	' '

systrk:	db	2	; number of system tracks
spt:	db	26	; 26 spt at 128b
sectbl:	db	1,3,5,7,9,11,13,15,17,19,21,23,25
	db	2,4,6,8,10,12,14,16,18,20,22,24,26

	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

mlt128:	mov	l,a
	mvi	h,000h
	dad	h
	dad	h
	dad	h
	dad	h
	dad	h
	dad	h
	dad	h
	ret

conin:	mvi	c,fconin
	call	bdos
	cpi	'a'
	rc
	cpi	'z'+1
	rnc
	ani	01011111b
	ret

conout:	mov	e,a
	mvi	c,fconout
	call	bdos
	ret

crlf:	mvi	a,CR
	call	conout
	mvi	a,LF
	call	conout
	ret

nlmsg:	push	h
	call	crlf
	pop	h
prmsg:	mov	a,m
	ora	a
	rz
	push	h
	call	conout
	pop	h
	inx	h
	jmp	prmsg

seldsk:	mov	c,a
	lhld	cpm+1
	lxi	d,bseldsk
	dad	d
	pchl

settrk:	lhld	cpm+1
	lxi	d,bsettrk
	dad	d
	pchl

setsec:	lhld	cpm+1
	lxi	d,bsetsec
	dad	d
	pchl

setdma:	lhld	cpm+1
	lxi	d,bsetdma
	dad	d
	pchl

read:	lhld	cpm+1
	lxi	d,bread
	dad	d
	pchl

write:	lhld	cpm+1
	lxi	d,bwrite
	dad	d
	pchl

fread:	mvi	c,readf
	jmp	bdos

fopen:	mvi	c,openf
	jmp	bdos

iosys:	lxi	h,system
	shld	dmaadr
	mvi	a,-1
	sta	track
gettrk:	lxi	h,track
	inr	m
	lda	systrk
	cmp	m
	jz	return
	mov	c,m
	call	settrk
	mvi	a,-1
	sta	sector
ioloop:	lda	spt
	lxi	h,sector
	inr	m
	cmp	m
	jz	nxttrk
	lxi	h,sector
	mov	e,m
	mvi	d,0
	lxi	h,sectbl
	mov	b,m
	dad	d
	mov	c,m
	push	b
	call	setsec
	pop	b
	mov	a,c
	sub	b
	call	mlt128
	xchg
	lhld	dmaadr
	dad	d
	mov	b,h
	mov	c,l
	call	setdma
	xra	a
	sta	retry
erloop:	lda	retry
	cpi	10	; max retries
	jc	more
	lxi	h,mperr
	call	prmsg
	call	conin
	cpi	CR
	jnz	exit
	call	crlf
	jmp	ioloop

more:	inr	a
	sta	retry
	lda	wrflag
	ora	a
	jz	rdsec
	call	write
	jmp	errchk

rdsec:	call	read
errchk:	ora	a
	jz	ioloop
	jmp	erloop

nxttrk:	lda	spt
	call	mlt128
	xchg
	lhld	dmaadr
	dad	d
	shld	dmaadr
	jmp	gettrk

return:	ret

; Program start
start:	lxi	sp,stack
	lxi	h,signon
	call	prmsg
	lda	fcb+1
	cpi	' '
	jz	getsrc
	lxi	d,fcb
	call	fopen
	inr	a
	jnz	getfil
	lxi	h,mnsrc
	call	nlmsg
	jmp	exit

getfil:	xra	a
	sta	fcb+32
	mvi	c,010h	; skip to 0900h...
skloop:	push	b
	lxi	d,fcb
	call	fread
	pop	b
	ora	a
	jnz	invsrc
	dcr	c
	jnz	skloop
	; now load system image
	lxi	h,system
rdloop:	push	h
	mov	b,h
	mov	c,l
	call	setdma
	lxi	d,fcb
	call	fread
	pop	h
	ora	a
	jnz	getdst
	lxi	d,128
	dad	d
	jmp	rdloop

invsrc:	lxi	h,misrc
	call	nlmsg
	jmp	exit

getsrc:	lxi	h,mpsrc
	call	nlmsg
	call	conin
	cpi	CR
	jz	getdst
	sui	'A'
	cpi	4
	jc	setsrc
	call	invald
	jmp	getsrc

setsrc:	adi	'A'
	sta	srcdrv
	sui	'A'
	call	seldsk
	call	crlf
	lxi	h,mgsrc
	call	prmsg
	call	conin
	cpi	CR
	jnz	exit
	call	crlf
	xra	a
	sta	wrflag
	call	iosys
	lxi	h,mdone
	call	prmsg
getdst:	lxi	h,mpdst
	call	nlmsg
	call	conin
	cpi	CR
	jz	exit
	sui	'A'
	cpi	4
	jc	setdst
	call	invald
	jmp	getdst

setdst:	adi	'A'
	sta	dstdrv
	sui	'A'
	call	seldsk
	lxi	h,mgdst
	call	nlmsg
	call	conin
	cpi	CR
	jnz	exit
	call	crlf
	lxi	h,wrflag
	mvi	m,1
	call	iosys
	lxi	h,mdone
	call	prmsg
	jmp	getdst

exit:	mvi	a,0
	call	seldsk
	call	crlf
	jmp	cpm

invald:	lxi	h,minvd
	call	nlmsg
	ret

signon:	db	'SYSGEN VER 2.0',0
mpsrc:	db	'SOURCE DRIVE NAME (OR RETURN TO SKIP)',0
mgsrc:	db	'SOURCE ON '
srcdrv:	db		9,', THEN TYPE RETURN',0
mpdst:	db	'DESTINATION DRIVE NAME (OR RETURN TO REBOOT)',0
mgdst:	db	'DESTINATION ON '
dstdrv:	db		0cdh,', THEN TYPE RETURN',0
mperr:	db	'PERMANENT ERROR, TYPE RETURN TO IGNORE',0
mdone:	db	'FUNCTION COMPLETE',0
minvd:	db	'INVALID DRIVE NAME (USE A, B, C, OR D)',0
mnsrc:	db	'NO SOURCE FILE ON DISK',0
misrc:	db	'SOURCE FILE INCOMPLETE',0

	db	0
track:	db	0
sector:	db	0
wrflag:	db	0
dmaadr:	dw	0
retry:	db	0

	dw	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
stack:	ds	0

	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	end
