; This appears to be for neither Junior80 nor Tpd systems...
; Only supports 8" drives (no motor-on)

cpm	equ	0000h
bdos	equ	0005h
tpa	equ	0100h

; BDOS functions
fconin	equ	1
fconout	equ	2

BEL	equ	7
LF	equ	10
CR	equ	13
SO	equ	14
SI	equ	15
ESC	equ	27

; I/O ports
FDC_STS	equ	90h
FDC_DAT	equ	91h
;FDC_CTL not used? no motor ctl for 8" drives...

DMA_0A	equ	80h	; unknown how/why this is used
DMA_2A	equ	84h	; Junior80/Tpd use ch 1
DMA_2C	equ	85h	;
DMA_CTL	equ	88h

DMA_RD	equ	80h
DMA_WR	equ	40h
DMA_FDC	equ	0100b	; DMA channel for FDC

	org	tpa
	lxi	sp,tpa
menu:	call	print
	db	ESC,'H',ESC,'J',SO
	db	' Single/Double Density Floppy Disk Controler - IDISK ',CR,LF
	db	' Copyright I.C.E. - A.P.P., 1984                     ',SI,CR,LF,LF
	db	' 0 - Set Sector Offset ( Actual Value is',SO,' '
L01a5:	db						'1 ',SI,' )',CR,LF
	db	' 1 - Single Density I.B.M. 3740 Format',CR,LF
	db	' 2 - Double Density I.B.M. System 34 (256 B/sector)',CR,LF
	db	' 3 - Double Density, 512 B/sector (CP/M)',CR,LF
	db	' 4 - Exit',CR,LF,LF,'$'
	call	conin
	sui	'0'
	jc	error
	cpi	5
	jnc	error
	add	a
	mov	e,a
	mvi	d,0
	lxi	h,fnctbl
	dad	d
	mov	e,m
	inx	h
	mov	d,m
	xchg
	pchl

error:	call	print
	db	CR,BEL,BEL,'$'
	jmp	menu

recal:	mvi	b,007h	; RECALIBRATE (seek track 0)
	mvi	c,2	; incl. command byte
	lxi	h,cmdbuf
	call	fdccmd
	jmp	sense

seek:	mvi	b,00fh	; SEEK command
	mvi	c,3	; incl. command byte
	lxi	h,cmdbuf
	call	fdccmd
sense:	mvi	b,008h	; SENSE intr status
	mvi	c,0
	lxi	h,cmdbuf
	call	fdccmd
	call	fdcres
	lda	resbuf
	ani	020h	; SEEK END
	jz	sense
	lda	resbuf
	ani	0c0h	; INTERRUPT CODE
	rz
	call	print
	db	'seek error$'
	call	conin
	jmp	exit

; B=command byte, HL=parameters, C=count (0=until FDC status)
fdccmd:	in	FDC_STS
	ani	010h	; FDC busy
	jnz	fdccmd
L02b1:	in	FDC_STS
	ral
	jnc	L02b1
	ral
	rc		; input phase, stop sending command bytes
	mov	a,b
	out	FDC_DAT
	mov	b,m
	inx	h
	mov	a,c
	ora	a
	jz	L02b1	; C=0 terminate by status
	dcr	c
	jnz	L02b1
	ret

fdcres:	lxi	h,resbuf
L02cb:	in	FDC_STS
	ral
	jnc	L02cb
	ral
	rnc
	in	FDC_DAT
	mov	m,a
	inx	h
	jmp	L02cb

fdcfmt:	mvi	b,00dh	; FORMAT TRACK (FM)
	lxi	d,00068h
	lda	secsiz
	ora	a
	jz	L02e8
	mvi	b,04dh	; FORMAT TRACK + MFM
L02e8:	mov	a,e
	out	DMA_2C
	mov	a,d
	ori	DMA_RD
	out	DMA_2C
	lxi	d,fmtbuf
	mov	a,e
	out	DMA_2A
	mov	a,d
	out	DMA_2A
	mvi	a,040h+DMA_FDC	; TC stop, FDC ch ena
	out	DMA_CTL
	mvi	a,0ffh
	out	DMA_0A
	out	DMA_0A
	mvi	c,0
	call	fdccmd
	call	fdcres
	lda	resbuf
	cpi	040h
	rc
	call	print
	db	'format error$'
	call	conin
	jmp	exit

fdcfm0:	lxi	h,cmdfm0
L032a:	call	print
	db	CR,LF,ESC,'J',SO
	db	' Insert new disk for drive B:   ',CR,LF
	db	' and strike any key when ready. ',SI,CR,LF,'$'
	call	conin
	push	h
	call	recal
	xra	a
	sta	curtrk
	pop	h
	push	h
	inx	h
	mov	a,m
	sta	secsiz
	inx	h
	mov	d,m
	call	setfmt
	pop	h
L0390:	push	h
	push	d
	call	fdcfmt
	lxi	h,curtrk
	mov	a,m
	inr	m
	pop	d
	pop	h
	cpi	76	; last track
	jnc	menu
	push	h
	push	d
	call	setfmt
	call	seek
	pop	d
	pop	h
	jmp	L0390

fdcfm1:	lxi	h,cmdfm1
	jmp	L032a

fdcfm2:	lxi	h,cmdfm2
	jmp	L032a

fdcskw:	call	print
	db	CR,LF,ESC,'J'
	db	'new offset value : $'
	call	conin
	sta	L01a5
	sui	'1'
	jc	L03e9
	inr	a
	sta	skew
	cpi	10
	jc	menu
L03e9:	call	print
	db	BEL,BEL,'$'
	jmp	fdcskw

; setup format buffer - sector table... D=num sectors
setfmt:	lxi	h,fmtbuf
	mov	c,d
	mvi	b,0
L03f8:	lda	curtrk
	mov	m,a	; C (cylinder)
	inx	h
	mvi	m,0	; H (head)
	inx	h
	mov	m,b	; R (sector)
	inr	m	; 1-base sector numbers
	inx	h
	lda	secsiz	; N (bytes/sector)
	mov	m,a
	inx	h
	lda	skew
	add	b
	mov	b,a
	sub	d
	jc	L0412
	mov	b,a
L0412:	dcr	c
	jnz	L03f8
	ret

print:	xthl
	mov	a,m
	inx	h
	cpi	'$'
	xthl
	rz
	call	conout
	jmp	print

exit:	call	print
	db	ESC,'H',ESC,'J$'	; clear screen
	jmp	cpm

conin:	push	b
	push	d
	push	h
	mvi	c,fconin
	call	bdos
	pop	h
	pop	d
	pop	b
	ret

conout:	push	b
	push	d
	push	h
	mov	e,a
	mvi	c,fconout
	call	bdos
	pop	h
	pop	d
	pop	b
	ret

fnctbl:	dw	fdcskw
	dw	fdcfm0
	dw	fdcfm1
	dw	fdcfm2
	dw	exit

cmdfm0:	db	0001b	; DS1,DS0 for commands
	db	0	; 128-byte sectors
	db	26	; 26 spt
	db	27	; GAP3 length
	db	0e5h	; fill

cmdfm1:	db	0001b	; DS1,DS0 for commands
	db	1	; 256-byte sectors
	db	26
	db	54
	db	0e5h

cmdfm2:	db	0001b	; DS1,DS0 for commands
	db	2	; 512-byte sectors
	db	16
	db	54
	db	0e5h

cmdbuf:	db	0001b	; DS1,DS0 for commands
curtrk:	db	0	; NCN for SEEK
	db	0	; safety padding?
	db	1	; safety padding?

secsiz:	db	0
	db	1ah,7,80h
skew:	db	1
	db	0,0

; FDC response buffer
resbuf:	db	0,0,0,0,0,0,0

; Buffer space for FORMAT sector list
fmtbuf:	ds	0
	; keep binaries identical...
	rept	80h-($ AND 7fh)
	db	0
	endm

	end
