; Disk util for Junior80

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
V7_INTV	equ	131	; FDC intr vector in vers .7

PP_B	equ	1	; system cfg dipsw
CFG_801	equ	00000001b	; drives 0,1 are 8"
CFG_823	equ	00000010b	; drives 2,3 are 8"

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
	lxi	sp,stack
	lhld	cpm+1
	lxi	d,BIO_IDS
	dad	d
	mov	a,m
	cpi	'j'
	jnz	L011f
	lxi	d,BIO_VER-BIO_IDS
	dad	d
	mov	a,m
	cpi	'7'
	jz	chkdrv
L011f:	call	print
	db	CAN,BEL,'\WRONG SYSTEM, TRY ANOTHER ',21h,'\$'
	jmp	cpm

chkdrv:
	in	PP_B
	ani	CFG_801+CFG_823
	jz	L014b
	db	CAN,BEL,'\8" DRIVES NOT SUPPORTED',21h,'\$'
	jmp	cpm

L014b:
	lxi	d,V7_INTV
	lhld	cpm+1
	dad	d
	shld	vecptr
	mov	e,m
	inx	h
	mov	d,m
	dcx	h
	xchg
	shld	vecsav
	di
	lxi	h,fdcint
	xchg
	mov	m,e
	inx	h
	mov	m,d
	call	L04a3	; setup floppy drive type
	ei
menu:	call	print
	db	CAN,'\** junior-80 **  '
	db	'5" DISK UTILITY v2.72\\'
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
L0409:	call	print
	db	'\\\\\\Select option (C)opy, (F)ormat, (V)erify, (E)XIT: $'
	call	conine
	cpi	'F'
	jz	format
	cpi	'V'
	jz	verify
	cpi	'C'
	jz	copy
	cpi	'E'
	jz	exit
	cpi	CTLC
	jnz	menu
exit:	call	print
	db	'\\Load system disk A: and type (CR)$'
	call	conin
	mvi	a,CAN
	call	conout
	di
	lhld	vecptr
	xchg
	lhld	vecsav
	xchg
	mov	m,e
	inx	h
	mov	m,d
	ei
	jmp	cpm

; configure floppy parameters
L04a3:	xra	a
	sta	fdcres
; 5.25" drives selected
	ret

conine:	call	conin
conout:	push	psw
	push	b
	push	d
	push	h
	mov	e,a
	mvi	c,dircon
	call	bdos
	pop	h
	pop	d
	pop	b
	pop	psw
	ret

; Wait for input, toupper
conin:	push	b
	push	d
	push	h
L0576:	mvi	c,dircon
	mvi	e,0ffh
	call	bdos
	ora	a
	jz	L0576
	pop	h
	pop	d
	pop	b
	cpi	'a'
	rc
	cpi	'z'+1
	rnc
	sui	020h	; toupper
	ret

conbrk:	push	b
	push	d
	push	h
	mvi	c,dircon
	mvi	e,0ffh
	call	bdos
	pop	h
	pop	d
	pop	b
	ora	a
	rz
	cpi	CTLC
	rnz
break:	call	print
	db	'\Break program execution (Y/N)? $'
	call	conin
	cpi	'Y'
	jz	L05d4
	call	print
	db	'No$'
	jmp	crlf

L05d4:	call	print
	db	'Yes$'
	jmp	L0409

print:	xthl
	mov	a,m
	inx	h
	cpi	'$'
	xthl
	rz
	cpi	'\'
	cnz	conout
	cz	crlf
	jmp	print

crlf:	call	print
	db	CR,LF,'$'
	ret

; print HL in decimal (recursive)
decout:	push	b
	push	d
	push	h
	lxi	b,-10
	lxi	d,-1
L0600:	dad	b
	inx	d
	jc	L0600
	lxi	b,10
	dad	b
	xchg
	mov	a,h
	ora	l
	cnz	decout
	mov	a,e
	adi	'0'
	call	conout
	pop	h
	pop	d
	pop	b
	ret

; FORMAT option selected
format:	mvi	a,CAN
	call	conout
L061e:	lxi	sp,stack
	call	print
	db	'\\\\FORMAT DISK UTILITY$'
L063c:	call	print
	db	'\\Select disk (A-D) to FORMAT or type (SPACE) to reboot: $'
	call	conine
	cpi	CR
	jz	L061e
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	menu
	sta	L07e7
	sui	'A'
	jc	L063c
	cpi	'D'-'A'+1
	jnc	L063c
	sta	fdcbuf+1
	sta	curcmd+2	; DS1/DS0
	call	L0d7f
	lxi	h,buffer
	shld	dmaadr
L06a7:
; 512-byte sector DD FORMAT case
	call	print
	db	'Double density, Double sided, 80-track, 512 bytes/sector$'
	mvi	a,2	; N - sector size 512
	sta	fdcbuf+2
	mvi	a,9	; SC - spt
	sta	fdcbuf+3
	mvi	a,54	; GPL
	sta	fdcbuf+4
	mvi	a,04dh	; FORMAT + MFM
	sta	fdcbuf
	mvi	a,2
	sta	ddflg
L07b2:	call	print
	db	'\Check diskette (FORMAT will destroy data on disk '
L07e7:	db	'A:)\'
	db	'Type (CR) to continue or (SPACE) to abort$'
	call	conin
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	L061e
	cpi	CR
	jnz	L07b2
	call	crlf
	jmp	L088c

; Alter sector list, update C (track)
updtrk:	lxi	d,4
	mvi	c,9
L0847:	mov	m,a
	dad	d
	dcr	c
	rz
	jmp	L0847

fmttrk:	mvi	a,5
L0850:	sta	retry
	di
	lxi	h,fmtbuf
	mov	a,l
	out	DMA_1A
	mov	a,h
	out	DMA_1A
	lda	fdcbuf+3	; SC (spt)
	ral
	ral
	ani	11111100b	; num bytes in sector list
	dcr	a
	out	DMA_1C
	mvi	a,DMA_RD
	out	DMA_1C
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL
	ei
	lxi	h,fdcbuf
	mvi	c,5
	call	fdccmd
	rz
	mov	a,m
	ani	00011000b
	cnz	L0d43
	lda	retry
	dcr	a
	jnz	L0850
	lxi	h,fdcres+2
	jmp	L0c20

L088c:	call	L0b0b
	call	L0d9b
	lda	fdcbuf+2
	mov	b,a
	lxi	h,fmtbuf
	xra	a
L089a:	inr	a
	cpi	9+1
	jnc	L08ad
	mvi	m,0
	inx	h
	mvi	m,0
	inx	h
	mov	m,a
	inx	h
	mov	m,b
	inx	h
	jmp	L089a

; 'fmttrk' already retries 5 times...
; why does this do more?
L08ad:	mvi	a,5
L08af:	sta	retry2
	call	fmttrk
	jz	L08c8
	lda	retry2
	dcr	a
	jnz	L08af
	call	crlf
	call	break
	jmp	L0900

L08c8:	lxi	b,0
L08cb:	push	b
	lda	ddflg
	lxi	h,ilv5m2
	cpi	002h
	jz	L08da
	lxi	h,ilv5m2
L08da:	dad	b
	mov	a,m
	sta	curcmd+5	; sector
	call	read
	pop	b
	jnz	L091b
	inr	c
	lda	ddflg
	cpi	002h
	mov	a,c
	jz	L08f5
	cpi	9
	jmp	L08f7

L08f5:	cpi	9
L08f7:	jc	L08cb
	call	print
	db	CR,SYN,'$'
L0900:	call	conbrk
	lda	curcmd+3	; next track
	inr	a
	sta	curcmd+3
	cpi	80
	jnc	L092b
	lxi	h,fmtbuf
	call	updtrk
	call	L0dac
	jmp	L08ad

L091b:	lda	retry2
	dcr	a
	jnz	L08af
	call	crlf
	call	break
	jmp	L0900

L092b:	call	print
	db	'\FORMAT complete$'
	jmp	L061e

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
; current active fdc param block, from fdfmt2...
curfmt:	db	0	; N (sector size code)
	db	0	; SC/EOT (spt)
	db	0	; GPL
	db	0	; DTL (sector size if 128)
	db	0	; write command
	db	0	; read command

; FDC command buffer
fdcbuf:	db	0,0,0,0,0,0e5h

fdfmt2:	db	2	; 512 byte sectors
	db	9
	db	14
	db	255
	db	46h	; READ + MFM
	db	45h	; WRITE + MFM

ilv5m2:	db	1,3,5,7,9,2,4,6,8

; FDC command response buffer
; first byte is flag, not recv'd from FDC
fdcres:	db	0,0,0,0,0,0,0,0

; FORMAT sector list buffer
fmtbuf:	ds	9*4

	ds	64
stack:	ds	0

; Begin and FDC command - ensure chip is idle
fdcbeg:	push	psw
L0a6b:	in	FDC_STS
	ani	01fh	; anything BUSY
	jnz	L0a6b
	pop	psw
; output a byte to FDC - check only RQM/DIO
fdcout:	push	psw
L0a74:	in	FDC_STS
	ral		; RQM
	jnc	L0a74	; wait for RQM
	ral		; DIO
	jc	die1	; error if wrong direction
	pop	psw
	out	FDC_DAT
	ret

;
fdcin:	in	FDC_STS
	ral		; RQM
	jnc	fdcin	; wait for RQM
	ral		; DIO
	jnc	die	; error if wrong direction
	in	FDC_DAT
	ret

die1:	pop	psw
die:	call	print
	db	'\FDC ERROR, HARDWARE RESET REQUIRED',BEL,'$'
	di
	jmp	$

; HL=FDC command, C=num additional bytes
fdccmd:	di
	mov	a,m
	call	fdcbeg
L0ac1:	inx	h
	mov	a,m
	call	fdcout
	dcr	c
	jnz	L0ac1
	ei
	; wait for response (via intr)
	lxi	h,fdcres
L0ace:	mov	a,m
	ora	a
	jz	L0ace
	mvi	m,0
	inx	h
	mov	a,m
	ani	0c0h
	ret

L0ada:
	; DD setup
	lxi	h,(9*512)-1	; one track
L0aee:	lxi	d,fdfmt2
L0afa:	shld	dmalen
	lxi	h,curfmt
	mvi	b,6
L0b02:	ldax	d
	mov	m,a
	inx	h
	inx	d
	dcr	b
	jnz	L0b02
	ret

L0b0b:
	lxi	h,512-1	; one sector
	jmp	L0aee

L0b28:	call	L0d9b
	mvi	a,002h
	sta	ddflg
	lxi	h,512-1
	lxi	d,fdfmt2
	call	L0afa
	call	readid
	rz
	call	print
	db	'\CANNOT DETERMINE DENSITY on disk $'
	call	L0d8e
	mvi	a,BEL
	call	conout
	xra	a
	inr	a
	ret

; Setup for FDC write (DMA read)
write:	lda	curfmt+5	; FDC WRITE command
	mov	h,a
	mvi	l,DMA_RD
	mvi	a,0ffh	; write
	jmp	L0ba3

; Setup for FDC read (DMA write)
read:	lda	curfmt+4	; FDC READ command
	mov	h,a
	mvi	l,DMA_WR
	xra	a	; read
L0ba3:	sta	rwflg
	shld	curcmd
	xra	a
	sta	errflg
	mvi	a,10
	sta	retry
L0bb2:	lxi	h,curcmd
	mov	a,m	; DMAC byte
	inx	h
	push	h
	push	psw
	di
	lhld	dmalen
	mov	a,l
	out	DMA_1C
	pop	psw
	ora	h	; set ctl bits in count
	out	DMA_1C
	lhld	dmaadr
	mov	a,l
	out	DMA_1A
	mov	a,h
	out	DMA_1A
	; DMA auto-load, TC stop, ext write (+ch 2)
	mvi	a,0e4h+DMA_FDC	; why ch 2???
	out	DMA_CTL
	ei
	pop	h	; fdc cmd ptr
	mvi	c,8	; cmd+8 bytes
	call	fdccmd
	rz
	lxi	d,L0bb2
	push	d
	mov	a,m
	ani	00011000b
	jnz	L0d43
	inx	h
	inx	h
	mov	a,m
	ani	010h
	jz	L0c0d
	lda	errflg
	ora	a
	jnz	L0c0d
	cma
	sta	errflg
	lda	curcmd+1	; FDC command
	push	psw
	lda	curcmd+3	; track
	push	psw
	call	L0d9e
	pop	psw
	sta	curcmd+3	; restore track
	call	L0dac
	pop	psw
	sta	curcmd+1	; restore command
	ret

L0c0d:	lda	retry
	dcr	a
	sta	retry
	rnz
	pop	d
	lxi	h,fdcres+2
	lda	rwflg
	ora	a
	jz	L0c2f
L0c20:	call	print
	db	CR,SYN,'WRITE $'
	jmp	L0c3a

L0c2f:	call	print
	db	CR,SYN,'READ $'
L0c3a:	mov	a,m
	ani	080h
	jz	L0c50
	call	print
	db	'end of track$'
L0c50:	mov	a,m
	ani	020h
	jz	L0c77
	inx	h
	mov	a,m
	dcx	h
	ani	020h
	jz	L0c6d
	call	print
	db	'data CRC$'
	jmp	L0c77

L0c6d:	call	print
	db	'ID CRC$'
L0c77:	mov	a,m
	ani	004h
	jz	L0c91
	call	print
	db	'sector not found$'
L0c91:	mov	a,m
	ani	002h
	jz	L0ca2
	call	print
	db	'protect$'
L0ca2:	mov	a,m
	ani	001h
	jz	L0cd1
	inx	h
	mov	a,m
	ani	001h
	jz	L0cba
	call	print
	db	'data$'
	jmp	L0cc0

L0cba:	call	print
	db	'ID$'
L0cc0:	call	print
	db	' address mark$'
L0cd1:	call	print
	db	' ERROR on disk $'
	call	L0d8e
	call	L0cf2
	mvi	a,007h
	call	conout
	xra	a
	inr	a
	ret

L0cf2:	mvi	h,0
	call	print
	db	' - bad sector $'
	lda	curcmd+5	; print sector
	mov	l,a
	call	decout
L0d0d:	call	print
	db	' on track $'
	lda	curcmd+3	; print track
	mov	l,a
	call	decout
	lhld	errcnt
	inx	h
	shld	errcnt
	ret

sense:	di
	mvi	a,004h	; SENSE command
	call	fdcbeg
	lda	curcmd+2	; drive select
	call	fdcout
	call	fdcin
	ei
	ani	020h
	rnz
	call	L0d43
	jmp	sense

L0d43:	call	print
	db	'\Disk $'
	call	L0d8e
	call	print
	db	' not ready, type (CR) to continue',BEL,'$'
	call	conin
	cpi	003h
	jz	L0409
	ret

L0d7f:	call	print
	db	CR,SYN,'$'
L0d85:	call	print
	db	'Disk $'
L0d8e:	lda	curcmd+2	; print drive
	adi	'A'
	call	conout
	mvi	a,':'
	jmp	conout

L0d9b:	call	sense
L0d9e:	xra	a
	sta	curcmd+3	; track is 0
	lxi	h,curcmd+1	; overwrite FDC r/w cmd
	mvi	m,007h	; RECALIBRATE command
	mvi	c,1
	jmp	fdccmd

L0dac:	lxi	h,curcmd+1	; overwrite FDC r/w cmd
	mvi	m,00fh	; SEEK command
	mvi	c,2
	jmp	fdccmd

readid:	lda	curfmt+4	; FDC READ cmd
	ani	040h	; isolate MFM bit
	ori	00ah	; READ ID command
	lxi	h,curcmd+1	; overwrite FDC r/w cmd
	mov	m,a
	mvi	c,1
	call	fdccmd
	rnz
	lda	fdcres+7
	lxi	h,ddflg
	cmp	m
	ret

; private intr handler for FDC
fdcint:	push	psw
	push	h
	lxi	h,fdcres
	in	FDC_STS
	ani	010h
	jnz	L0dfb	; FDC has response for us
	mvi	a,008h	; SENSE command
	call	fdcout
	call	fdcin	; ST0
	inx	h
	mov	m,a
	ani	0c0h	; check intr code
	cpi	080h	; invalid command?
	jz	L0e0a
	call	fdcin	; PCN (ignored)
	mov	a,m
	ani	020h	; SEEK END
	jz	L0e0a
	dcx	h
	mvi	m,001h	; flag as completion
	jmp	L0e0a

L0dfb:	mvi	m,001h	; flag as completion
	push	b
	mvi	b,7	; 7 bytes in response
L0e00:	inx	h
	call	fdcin
	mov	m,a
	dcr	b
	jnz	L0e00
	pop	b
L0e0a:	pop	h
	pop	psw
	ei
	reti

; VERIFY option selected
verify:	mvi	a,CAN
	call	conout
L0e14:	lxi	sp,stack
	call	print
	db	'\\\\VERIFY DISK UTILITY$'
L0e32:	call	print
	db	'\\Select disk (A-D) to VERIFY or type (SPACE) to reboot: $'
	call	conine
	cpi	CR
	jz	L0e14
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	menu
	sta	L0f27
	sui	'A'
	jc	L0e32
	cpi	'D'-'A'+1
	jnc	L0e32
	sta	curcmd+2	; set DS1/DS0 in cmd buf
	call	L0b28
	jnz	L0e14
	call	L0d7f
	lda	ddflg
	ora	a
	jz	L0eaf
	call	print
	db	' double$'
	jmp	L0eba

L0eaf:	call	print
	db	' single$'
L0eba:	call	print
	db	' density\$'
	lxi	h,0
	shld	errcnt
	lxi	h,buffer
	shld	dmaadr
L0ed3:	call	conbrk
	call	L0dac
	call	L0f36
	lda	curcmd+3	; next track
	inr	a
	sta	curcmd+3
	cpi	80
	jc	L0ed3
	call	print
	db	'\VERIFY complete: $'
	lhld	errcnt
	mov	a,l
	ora	h
	jnz	L0f0f
	call	print
	db	'NO$'
	jmp	L0f12

L0f0f:	call	decout
L0f12:	call	print
	db	' read error(s) on '
L0f27:	db	'A: detected$'
	jmp	L0e14

L0f36:	lxi	b,0
L0f39:	push	b
	lda	ddflg
	lxi	h,ilv5m2
	cpi	002h
	jz	L0f48
	lxi	h,ilv5m2
L0f48:	dad	b
	mov	a,m
	sta	curcmd+5	; set sector
	call	read
	cnz	crlf
	pop	b
	inr	c
	lda	ddflg
	cpi	002h
	mov	a,c
	jz	L0f63
	cpi	9
	jmp	L0f65

L0f63:	cpi	9
L0f65:	jc	L0f39
	ret

; COPY option selected
copy:	mvi	a,CAN
	call	conout
L0f6e:	lxi	sp,stack
	call	print
	db	'\\\\COPY DISK UTILITY$'
L0f8a:	call	print
	db	'\\Select source disk (A-D) or type (SPACE) to reboot: $'
	call	conine
	cpi	CR
	jz	L0f6e
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	menu
	sta	L10b0
	sui	'A'
	jc	L0f8a
	cpi	'D'-'A'+1
	jnc	L0f8a
	sta	srcdrv
	sta	curcmd+2	; DS1/DS0
	call	print
	db	CR,SYN,'Source $'
	call	L0d85
L0ff9:	call	print
	db	'\Select target disk (A-D) or type (SPACE) to reboot: $'
	call	conine
	cpi	CR
	jz	L0f6e
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	menu
	sta	L10f5
	sui	'A'
	jc	L0ff9
	cpi	'D'-'A'+1
	jnc	L0ff9
	sta	dstdrv
	sta	curcmd+2	; DS1/DS0
	lxi	h,srcdrv
	cmp	m
	jnz	L1087
	call	print
	db	CR,SYN,'SAME DISK SELECTED, CANNOT COPY',BEL,'$'
	jmp	L0ff9

L1087:	call	print
	db	CR,SYN,'Target $'
	call	L0d85
	call	crlf
L109a:	call	print
	db	CR,SYN,'Load source disk '
L10b0:	db	'A: and type (CR)$'
	call	conine
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	menu
	cpi	CR
	jnz	L109a
	lda	srcdrv
	sta	curcmd+2	; DS1/DS0
	call	L0b28
	jnz	L0f6e
L10df:	call	print
	db	CR,SYN,'Load target disk '
L10f5:	db	'A: and type (CR)$'
	call	conine
	cpi	CTLC
	jz	exit
	cpi	' '
	jz	menu
	cpi	CR
	jnz	L10df
	call	print
	db	CR,SYN,'$'
	lda	dstdrv
	sta	curcmd+2	; DS1/DS0
	lda	ddflg
	mov	c,a
	push	b
	call	L0b28
	pop	b
	jnz	L0f6e
	lda	ddflg
	cmp	c
	jz	L115d
	call	print
	db	'\DIFFERENT TARGET DISK DENSITY',BEL,'$'
	jmp	L0f6e

L115d:	call	L0ada
L1160:	call	conbrk
	lxi	h,buffer
	shld	dmaadr
	lda	srcdrv
	sta	curcmd+2	; DS1/DS0
	mvi	a,1
	sta	curcmd+5	; sector
	call	L0dac
	call	read
	jz	L1183
L117d:	call	break
	jmp	L11db

L1183:	lda	ddflg
	ora	a
	lxi	h,127
	jz	L1197
	rar
	lxi	h,255
	jc	L1197
	lxi	h,511
L1197:	shld	dmalen
	lda	dstdrv
	sta	curcmd+2	; DS1/DS0
	call	L0dac
	mvi	a,5
L11a5:	sta	retry2
	call	L1222
	jnz	L117d
	lxi	h,buffer2
	shld	dmaadr
	call	L0ada
	mvi	a,1
	sta	curcmd+5	; sector
	call	read
	jz	L11cc
	lda	retry2
	dcr	a
	jnz	L11a5
	jmp	L117d

L11cc:	lhld	dmalen
	mov	c,l
	mov	b,h
	inx	b
	lxi	h,buffer
	lxi	d,buffer2
	call	L11fc
L11db:	lda	curcmd+3	; next track
	inr	a
	sta	curcmd+3
	cpi	80
	jnz	L1160
	call	print
	db	'\COPY complete$'
	jmp	L0f6e

L11fc:	ldax	d
	cmp	m
	jnz	L120a
	inx	h
	inx	d
	dcx	b
	mov	a,b
	ora	c
	jnz	L11fc
	ret

L120a:	call	print
	db	'\VERIFY ERROR',BEL,'$'
	call	L0d0d
	jmp	break

L1222:	lxi	h,buffer
	shld	dmaadr
	lxi	b,0
L122b:	push	b
	lda	ddflg
	lxi	h,ilv5m2
	cpi	002h
	jz	L123a
	lxi	h,ilv5m2
L123a:	dad	b
	mov	a,m
	sta	curcmd+5	; sector
	dcr	a
	jz	L1253
	lhld	dmalen
	inx	h
	xchg
	lxi	h,buffer
L124b:	dad	d
	dcr	a
	jnz	L124b
	; computed location in buffer (&buffer[sector])
	shld	dmaadr
L1253:	call	write
	pop	b
	rnz
	inr	c
	lxi	h,curfmt+1
	mov	a,m	; SC (spt)
	cmp	c
	jnz	L122b
	xra	a
	ret

buffer:
	ds 8192
buffer2:
	ds	0
	end
