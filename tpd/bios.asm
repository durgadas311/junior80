	org	0de00h

	jmp	Ldec2		;; de00: c3 c2 de    ...
Lde03:	jmp	Ldee3		;; de03: c3 e3 de    ...
	jmp	Le96f		;; de06: c3 6f e9    .o.
	jmp	Le958		;; de09: c3 58 e9    .X.
	jmp	Le969		;; de0c: c3 69 e9    .i.
	jmp	Le990		;; de0f: c3 90 e9    ...
	jmp	Le984		;; de12: c3 84 e9    ...
	jmp	Le975		;; de15: c3 75 e9    .u.
	jmp	Le196		;; de18: c3 96 e1    ...
	jmp	Ldf69		;; de1b: c3 69 df    .i.
	jmp	Le199		;; de1e: c3 99 e1    ...
	jmp	Le19f		;; de21: c3 9f e1    ...
	jmp	Le24b		;; de24: c3 4b e2    .K.
	jmp	Le256		;; de27: c3 56 e2    .V.
	jmp	Le251		;; de2a: c3 51 e2    .Q.
	jmp	Le591		;; de2d: c3 91 e5    ...
	jmp	Le1c3		;; de30: c3 c3 e1    ...

	dw	Lde98
	db	'Tpd 2.7/1 A'
	dw	Lfd0d

	jmp	Le658		;; de42: c3 58 e6    .X.
	jmp	Lea12		;; de45: c3 12 ea    ...
	jmp	Le97e		;; de48: c3 7e e9    .~.
	jmp	Lf523		;; de4b: c3 23 f5    .#.
	jmp	Ldf68		;; de4e: c3 68 df    .h.
Lde4f	equ	$-2
	jmp	Leee7		;; de51: c3 e7 ee    ...
Lde52	equ	$-2
	jmp	Lee89		;; de54: c3 89 ee    ...
	jmp	Lee45		;; de57: c3 45 ee    .E.
	jmp	Lec4b		;; de5a: c3 4b ec    .K.
	jmp	Ldf68		;; de5d: c3 68 df    .h.
	jmp	Lf359		;; de60: c3 59 f3    .Y.
	jmp	Ldf68		;; de63: c3 68 df    .h.
	jmp	Ldf68		;; de66: c3 68 df    .h.
	jmp	Ldf68		;; de69: c3 68 df    .h.
	jmp	Lea46		;; de6c: c3 46 ea    .F.

Lde6f:	db	0,95h,0eah,'/',0eeh,8dh,0edh,1dh,0eeh,95h,0eah,' ',0edh,'{'
	db	0ech,0fh,0edh,95h,0eah,9bh,0e9h,95h,0eah
Lde86:	db	0dah,0f0h,95h,0eah,95h,0eah,95h,0eah,0e8h,0e8h,0a1h,0eah,95h
	db	0eah,86h,0eah,'B',0ech
Lde98:	db	' ',0e9h,'(',0e9h,'H',0e9h,'0',0e9h,'8',0e9h,'@',0e9h,0ch
	db	0eah,1eh,0fdh
Ldea8:	db	6,0c7h,'p',0deh,'h',0dfh,'P',0e9h,'*',0fdh,18h,0f5h,0,0,0,0
	db	8,0f5h,0eh,1,0,0,0,0,0,0
Ldec2:	lda	Lfd3b		;; dec2: 3a 3b fd    :;.
	sta	00003h		;; dec5: 32 03 00    2..
	xra	a		;; dec8: af          .
	sta	00004h		;; dec9: 32 04 00    2..
	jmp	Ldee3		;; decc: c3 e3 de    ...

Ldecf:	lxi	h,0c800h	;; decf: 21 00 c8    ...
	shld	Ldf62		;; ded2: 22 62 df    "b.
	lxi	h,Lf8e9		;; ded5: 21 e9 f8    ...
	lxi	d,0c807h	;; ded8: 11 07 c8    ...
	lxi	b,00009h	;; dedb: 01 09 00    ...
	ldir			;; dede: ed b0       ..
	jmp	0c800h		;; dee0: c3 00 c8    ...

Ldee3:	lxi	sp,00100h	;; dee3: 31 00 01    1..
	xra	a		;; dee6: af          .
	lxi	d,0c807h	;; dee7: 11 07 c8    ...
	mvi	c,081h		;; deea: 0e 81       ..
	call	Lf5ce		;; deec: cd ce f5    ...
	lxi	h,0cb82h	;; deef: 21 82 cb    ...
	shld	0cf99h		;; def2: 22 99 cf    "..
	lxi	d,0cfb8h	;; def5: 11 b8 cf    ...
	mvi	c,048h		;; def8: 0e 48       .H
	call	Lf5ce		;; defa: cd ce f5    ...
	lxi	d,0d30ah	;; defd: 11 0a d3    ...
	mvi	c,03dh		;; df00: 0e 3d       .=
	call	Lf5ce		;; df02: cd ce f5    ...
	cma			;; df05: 2f          /
	sta	Lfce0		;; df06: 32 e0 fc    2..
	di			;; df09: f3          .
	mvi	a,0c3h		;; df0a: 3e c3       >.
	sta	00000h		;; df0c: 32 00 00    2..
	lxi	h,Lde03		;; df0f: 21 03 de    ...
	shld	00001h		;; df12: 22 01 00    "..
	sta	00005h		;; df15: 32 05 00    2..
	lhld	Ldea8		;; df18: 2a a8 de    *..
	shld	00006h		;; df1b: 22 06 00    "..
	mvi	m,0c3h		;; df1e: 36 c3       6.
	inx	h		;; df20: 23          #
	mvi	m,006h		;; df21: 36 06       6.
	inx	h		;; df23: 23          #
	mvi	m,0d0h		;; df24: 36 d0       6.
	lxi	h,Lfdf2		;; df26: 21 f2 fd    ...
	shld	Lfd16		;; df29: 22 16 fd    "..
	shld	Lfd14		;; df2c: 22 14 fd    "..
	lxi	h,Lfe72		;; df2f: 21 72 fe    .r.
	shld	Lfd1b		;; df32: 22 1b fd    "..
	shld	Lfd19		;; df35: 22 19 fd    "..
	xra	a		;; df38: af          .
	sta	Lfd18		;; df39: 32 18 fd    2..
	sta	Lfd1d		;; df3c: 32 1d fd    2..
	lda	Lfd13		;; df3f: 3a 13 fd    :..
	ani	022h		;; df42: e6 22       ."
	sta	Lfd13		;; df44: 32 13 fd    2..
	lxi	h,Lfd2a		;; df47: 21 2a fd    .*.
	mov	a,m		;; df4a: 7e          ~
	inx	h		;; df4b: 23          #
Ldf4c:	stc			;; df4c: 37          7
	cmc			;; df4d: 3f          ?
	rar			;; df4e: 1f          .
	push	psw		;; df4f: f5          .
	push	h		;; df50: e5          .
	cc	Ldf64		;; df51: dc 64 df    .d.
	pop	h		;; df54: e1          .
	pop	psw		;; df55: f1          .
	inx	h		;; df56: 23          #
	inx	h		;; df57: 23          #
	ora	a		;; df58: b7          .
	jnz	Ldf4c		;; df59: c2 4c df    .L.
	lda	00004h		;; df5c: 3a 04 00    :..
	mov	c,a		;; df5f: 4f          O
	ei			;; df60: fb          .
	jmp	Ldecf		;; df61: c3 cf de    ...

Ldf62	equ	$-2
Ldf64:	mov	e,m		;; df64: 5e          ^
	inx	h		;; df65: 23          #
	mov	d,m		;; df66: 56          V
	push	d		;; df67: d5          .
Ldf68:	ret			;; df68: c9          .

Ldf69:	mov	a,c		;; df69: 79          y
	cpi	005h		;; df6a: fe 05       ..
Ldf6b	equ	$-1
	lxi	h,00000h	;; df6c: 21 00 00    ...
	jc	Ldf77		;; df6f: da 77 df    .w.
	xra	a		;; df72: af          .
	sta	00004h		;; df73: 32 04 00    2..
	ret			;; df76: c9          .

Ldf77:	sspd	Lfd6e		;; df77: ed 73 6e fd .sn.
	lxi	sp,Lfd6e	;; df7b: 31 6e fd    1n.
	call	Ldf86		;; df7e: cd 86 df    ...
	lspd	Lfd6e		;; df81: ed 7b 6e fd .{n.
	ret			;; df85: c9          .

Ldf86:	cpi	004h		;; df86: fe 04       ..
	jz	Ldf9d		;; df88: ca 9d df    ...
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
Ldf9d:	lxi	d,Le77a		;; df9d: 11 7a e7    .z.
	add	a		;; dfa0: 87          .
	add	a		;; dfa1: 87          .
	add	a		;; dfa2: 87          .
	add	a		;; dfa3: 87          .
	add	c		;; dfa4: 81          .
	mov	l,a		;; dfa5: 6f          o
	mvi	h,000h		;; dfa6: 26 00       &.
	dad	d		;; dfa8: 19          .
	shld	Lfcd9		;; dfa9: 22 d9 fc    "..
	lxi	d,00010h	;; dfac: 11 10 00    ...
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
	lhld	Lfcd9		;; dfc4: 2a d9 fc    *..
	lda	Lfd09		;; dfc7: 3a 09 fd    :..
	ora	a		;; dfca: b7          .
	jz	Ldfd9		;; dfcb: ca d9 df    ...
	lda	Lfce0		;; dfce: 3a e0 fc    :..
	cpi	004h		;; dfd1: fe 04       ..
	mvi	a,001h		;; dfd3: 3e 01       >.
	jnz	Ldfd9		;; dfd5: c2 d9 df    ...
	xra	a		;; dfd8: af          .
Ldfd9:	sta	Lfd0b		;; dfd9: 32 0b fd    2..
	ora	a		;; dfdc: b7          .
	ret			;; dfdd: c9          .

Ldfde:	mov	a,m		;; dfde: 7e          ~
	sta	Lfce0		;; dfdf: 32 e0 fc    2..
	sta	Lfcdb		;; dfe2: 32 db fc    2..
	lhld	Lfcd9		;; dfe5: 2a d9 fc    *..
	ret			;; dfe8: c9          .

Ldfe9:	lda	Lfcfd		;; dfe9: 3a fd fc    :..
	xra	c		;; dfec: a9          .
	ani	002h		;; dfed: e6 02       ..
	mov	a,c		;; dfef: 79          y
	sta	Lfcfd		;; dff0: 32 fd fc    2..
	rz			;; dff3: c8          .
	ani	002h		;; dff4: e6 02       ..
	mvi	b,080h		;; dff6: 06 80       ..
	jz	Ldffd		;; dff8: ca fd df    ...
	mvi	b,040h		;; dffb: 06 40       .@
Ldffd:	in	02dh		;; dffd: db 2d       .-
	ana	b		;; dfff: a0          .
	jz	Le006		;; e000: ca 06 e0    ...
	jmp	Le03a		;; e003: c3 3a e0    .:.

Le006:	lxi	h,Le7e7		;; e006: 21 e7 e7    ...
	shld	Le0ba		;; e009: 22 ba e0    "..
	lxi	h,Le7cf		;; e00c: 21 cf e7    ...
	shld	Le0cb		;; e00f: 22 cb e0    "..
	lxi	h,Le7d7		;; e012: 21 d7 e7    ...
	shld	Le0d2		;; e015: 22 d2 e0    "..
	lxi	h,Le7df		;; e018: 21 df e7    ...
	shld	Le0c3		;; e01b: 22 c3 e0    "..
	xra	a		;; e01e: af          .
	sta	Lfd09		;; e01f: 32 09 fd    2..
	mvi	b,020h		;; e022: 06 20       . 
	call	Le06f		;; e024: cd 6f e0    .o.
	di			;; e027: f3          .
	mvi	b,003h		;; e028: 06 03       ..
	call	Le728		;; e02a: cd 28 e7    .(.
	mvi	b,06fh		;; e02d: 06 6f       .o
	call	Le72f		;; e02f: cd 2f e7    ./.
	mvi	b,02eh		;; e032: 06 2e       ..
	call	Le72f		;; e034: cd 2f e7    ./.
	jmp	Le6a7		;; e037: c3 a7 e6    ...

Le03a:	lxi	h,Le87c		;; e03a: 21 7c e8    .|.
	shld	Le0ba		;; e03d: 22 ba e0    "..
	lxi	h,Le864		;; e040: 21 64 e8    .d.
	shld	Le0cb		;; e043: 22 cb e0    "..
	lxi	h,Le86c		;; e046: 21 6c e8    .l.
	shld	Le0d2		;; e049: 22 d2 e0    "..
	lxi	h,Le874		;; e04c: 21 74 e8    .t.
	shld	Le0c3		;; e04f: 22 c3 e0    "..
	mvi	a,001h		;; e052: 3e 01       >.
	sta	Lfd09		;; e054: 32 09 fd    2..
	mvi	b,030h		;; e057: 06 30       .0
	call	Le06f		;; e059: cd 6f e0    .o.
	di			;; e05c: f3          .
	mvi	b,003h		;; e05d: 06 03       ..
	call	Le728		;; e05f: cd 28 e7    .(.
	mvi	b,0cfh		;; e062: 06 cf       ..
	call	Le72f		;; e064: cd 2f e7    ./.
	mvi	b,002h		;; e067: 06 02       ..
	call	Le72f		;; e069: cd 2f e7    ./.
	jmp	Le6a7		;; e06c: c3 a7 e6    ...

Le06f:	lda	Lde6f		;; e06f: 3a 6f de    :o.
	ani	0cfh		;; e072: e6 cf       ..
	out	042h		;; e074: d3 42       .B
	nop			;; e076: 00          .
	nop			;; e077: 00          .
	nop			;; e078: 00          .
	ora	b		;; e079: b0          .
	sta	Lde6f		;; e07a: 32 6f de    2o.
	out	042h		;; e07d: d3 42       .B
	ret			;; e07f: c9          .

Le080:	lda	Lfcd8		;; e080: 3a d8 fc    :..
	mov	e,a		;; e083: 5f          _
	mvi	d,000h		;; e084: 16 00       ..
	lda	Lfcfe		;; e086: 3a fe fc    :..
	ani	003h		;; e089: e6 03       ..
	cmp	e		;; e08b: bb          .
	jz	Le0a6		;; e08c: ca a6 e0    ...
	push	d		;; e08f: d5          .
	lxi	h,Lfcf8		;; e090: 21 f8 fc    ...
	mov	e,a		;; e093: 5f          _
	dad	d		;; e094: 19          .
	lda	Lfcff		;; e095: 3a ff fc    :..
	mov	m,a		;; e098: 77          w
	lxi	h,Lfcf8		;; e099: 21 f8 fc    ...
	pop	d		;; e09c: d1          .
	dad	d		;; e09d: 19          .
	mov	a,m		;; e09e: 7e          ~
	sta	Lfcff		;; e09f: 32 ff fc    2..
	mov	a,e		;; e0a2: 7b          {
	sta	Lfcfe		;; e0a3: 32 fe fc    2..
Le0a6:	lda	Lfcdb		;; e0a6: 3a db fc    :..
	cpi	0ffh		;; e0a9: fe ff       ..
	jz	Le0f0		;; e0ab: ca f0 e0    ...
Le0ae:	lxi	h,Lfce0		;; e0ae: 21 e0 fc    ...
	cmp	m		;; e0b1: be          .
	jz	Le0e0		;; e0b2: ca e0 e0    ...
	mov	m,a		;; e0b5: 77          w
Le0b6:	lxi	d,Lfd02		;; e0b6: 11 02 fd    ...
	lxi	h,Le7e7		;; e0b9: 21 e7 e7    ...
Le0ba	equ	$-2
	mvi	b,006h		;; e0bc: 06 06       ..
	ora	a		;; e0be: b7          .
	jz	Le0d4		;; e0bf: ca d4 e0    ...
	lxi	h,Le7df		;; e0c2: 21 df e7    ...
Le0c3	equ	$-2
	cpi	003h		;; e0c5: fe 03       ..
	jz	Le0d4		;; e0c7: ca d4 e0    ...
	lxi	h,Le7cf		;; e0ca: 21 cf e7    ...
Le0cb	equ	$-2
	rar			;; e0cd: 1f          .
	jc	Le0d4		;; e0ce: da d4 e0    ...
	lxi	h,Le7d7		;; e0d1: 21 d7 e7    ...
Le0d2	equ	$-2
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
	sta	Lfcde		;; e0f1: 32 de fc    2..
	sta	Lfd0b		;; e0f4: 32 0b fd    2..
	call	Le6a7		;; e0f7: cd a7 e6    ...
	call	Le742		;; e0fa: cd 42 e7    .B.
Le0fd:	lxi	b,00002h	;; e0fd: 01 02 00    ...
	call	Le199		;; e100: cd 99 e1    ...
	call	Le6bc		;; e103: cd bc e6    ...
	xra	a		;; e106: af          .
	call	Le0ae		;; e107: cd ae e0    ...
	call	Le17d		;; e10a: cd 7d e1    .}.
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
	lxi	h,00000h	;; e131: 21 00 00    ...
	shld	Lfcd9		;; e134: 22 d9 fc    "..
	ret			;; e137: c9          .

Le138:	xra	a		;; e138: af          .
	sta	Lfcde		;; e139: 32 de fc    2..
	call	Le6a7		;; e13c: cd a7 e6    ...
	lhld	Lfcd9		;; e13f: 2a d9 fc    *..
	lxi	d,0000ah	;; e142: 11 0a 00    ...
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
	ldax	b		;; e152: 0a          .
	cpi	024h		;; e153: fe 24       .$
	jnz	Le171		;; e155: c2 71 e1    .q.
	lda	Lfcf4		;; e158: 3a f4 fc    :..
	ora	a		;; e15b: b7          .
	jz	Le0fd		;; e15c: ca fd e0    ...
	sui	002h		;; e15f: d6 02       ..
	jnz	Le171		;; e161: c2 71 e1    .q.
	mov	l,e		;; e164: 6b          k
	mov	h,d		;; e165: 62          b
	lxi	b,Le8a2		;; e166: 01 a2 e8    ...
	mov	m,b		;; e169: 70          p
	dcx	h		;; e16a: 2b          +
	mov	m,c		;; e16b: 71          q
	mvi	a,004h		;; e16c: 3e 04       >.
	sta	Lfce0		;; e16e: 32 e0 fc    2..
Le171:	lxi	h,00005h	;; e171: 21 05 00    ...
	dad	d		;; e174: 19          .
	lda	Lfce0		;; e175: 3a e0 fc    :..
	mov	m,a		;; e178: 77          w
	sta	Lfcdb		;; e179: 32 db fc    2..
	ret			;; e17c: c9          .

Le17d:	lda	Lfd07		;; e17d: 3a 07 fd    :..
	ani	040h		;; e180: e6 40       .@
	ori	00ah		;; e182: f6 0a       ..
	mov	b,a		;; e184: 47          G
	mvi	c,001h		;; e185: 0e 01       ..
	call	Le6e1		;; e187: cd e1 e6    ...
	jc	Le17d		;; e18a: da 7d e1    .}.
	rnz			;; e18d: c0          .
	lxi	h,Lfcf7		;; e18e: 21 f7 fc    ...
	lda	Lfce0		;; e191: 3a e0 fc    :..
	cmp	m		;; e194: be          .
	ret			;; e195: c9          .

Le196:	lxi	b,00000h	;; e196: 01 00 00    ...
Le199:	mov	h,b		;; e199: 60          `
	mov	l,c		;; e19a: 69          i
	shld	Lfcde		;; e19b: 22 de fc    "..
	ret			;; e19e: c9          .

Le19f:	mov	a,c		;; e19f: 79          y
	sta	Lfce1		;; e1a0: 32 e1 fc    2..
	lda	Lfd09		;; e1a3: 3a 09 fd    :..
	ora	a		;; e1a6: b7          .
	jz	Le1bd		;; e1a7: ca bd e1    ...
	lda	Lfd0b		;; e1aa: 3a 0b fd    :..
	ora	a		;; e1ad: b7          .
	mvi	a,000h		;; e1ae: 3e 00       >.
	jnz	Le1bd		;; e1b0: c2 bd e1    ...
	mov	a,c		;; e1b3: 79          y
	cpi	024h		;; e1b4: fe 24       .$
	mvi	a,000h		;; e1b6: 3e 00       >.
	jc	Le1bd		;; e1b8: da bd e1    ...
	mvi	a,001h		;; e1bb: 3e 01       >.
Le1bd:	sta	Lfd0c		;; e1bd: 32 0c fd    2..
	mov	a,c		;; e1c0: 79          y
	ora	a		;; e1c1: b7          .
	ret			;; e1c2: c9          .

Le1c3:	mov	a,c		;; e1c3: 79          y
	sta	Lfce2		;; e1c4: 32 e2 fc    2..
	lda	Lfce0		;; e1c7: 3a e0 fc    :..
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
	lxi	h,Le8df		;; e1ea: 21 df e8    ...
	jnz	Le1f3		;; e1ed: c2 f3 e1    ...
	lxi	h,Le845		;; e1f0: 21 45 e8    .E.
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

Le24b:	mov	h,b		;; e24b: 60          `
	mov	l,c		;; e24c: 69          i
	shld	Lfce3		;; e24d: 22 e3 fc    "..
	ret			;; e250: c9          .

Le251:	mvi	a,001h		;; e251: 3e 01       >.
	jmp	Le259		;; e253: c3 59 e2    .Y.

Le256:	xra	a		;; e256: af          .
	mvi	c,000h		;; e257: 0e 00       ..
Le259:	sspd	Lfd6e		;; e259: ed 73 6e fd .sn.
	lxi	sp,Lfd6e	;; e25d: 31 6e fd    1n.
	call	Le268		;; e260: cd 68 e2    .h.
	lspd	Lfd6e		;; e263: ed 7b 6e fd .{n.
	ret			;; e267: c9          .

Le268:	sta	Lfce5		;; e268: 32 e5 fc    2..
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
	lxi	h,0007fh	;; e284: 21 7f 00    ...
	shld	Lfce7		;; e287: 22 e7 fc    "..
	lda	Lfce1		;; e28a: 3a e1 fc    :..
	sta	Lfd01		;; e28d: 32 01 fd    2..
	lda	Lfd0c		;; e290: 3a 0c fd    :..
	sta	Lfd00		;; e293: 32 00 fd    2..
	lda	Lfce5		;; e296: 3a e5 fc    :..
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
	lda	Lfce5		;; e2b5: 3a e5 fc    :..
	ora	a		;; e2b8: b7          .
	jz	Le338		;; e2b9: ca 38 e3    .8.
	lda	Lfce6		;; e2bc: 3a e6 fc    :..
	cpi	002h		;; e2bf: fe 02       ..
	jnz	Le2e1		;; e2c1: c2 e1 e2    ...
	call	Le32c		;; e2c4: cd 2c e3    .,.
	inx	h		;; e2c7: 23          #
	inx	h		;; e2c8: 23          #
	inx	h		;; e2c9: 23          #
	mov	a,m		;; e2ca: 7e          ~
	inr	a		;; e2cb: 3c          <
	sta	Lfce9		;; e2cc: 32 e9 fc    2..
	lda	Lfcd8		;; e2cf: 3a d8 fc    :..
	sta	Lfcea		;; e2d2: 32 ea fc    2..
	lhld	Lfcde		;; e2d5: 2a de fc    *..
	shld	Lfceb		;; e2d8: 22 eb fc    "..
	lda	Lfce2		;; e2db: 3a e2 fc    :..
	sta	Lfced		;; e2de: 32 ed fc    2..
Le2e1:	lda	Lfce9		;; e2e1: 3a e9 fc    :..
	ora	a		;; e2e4: b7          .
	jz	Le338		;; e2e5: ca 38 e3    .8.
	dcr	a		;; e2e8: 3d          =
	sta	Lfce9		;; e2e9: 32 e9 fc    2..
	lda	Lfcd8		;; e2ec: 3a d8 fc    :..
	lxi	h,Lfcea		;; e2ef: 21 ea fc    ...
	cmp	m		;; e2f2: be          .
	jnz	Le338		;; e2f3: c2 38 e3    .8.
	lhld	Lfcde		;; e2f6: 2a de fc    *..
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
	call	Le32c		;; e313: cd 2c e3    .,.
	cmp	m		;; e316: be          .
	jc	Le325		;; e317: da 25 e3    .%.
	xra	a		;; e31a: af          .
	sta	Lfced		;; e31b: 32 ed fc    2..
	lhld	Lfceb		;; e31e: 2a eb fc    *..
	inx	h		;; e321: 23          #
	shld	Lfceb		;; e322: 22 eb fc    "..
Le325:	xra	a		;; e325: af          .
	sta	Lfcee		;; e326: 32 ee fc    2..
	jmp	Le340		;; e329: c3 40 e3    .@.

Le32c:	lhld	Lfcd9		;; e32c: 2a d9 fc    *..
	lxi	d,0000ah	;; e32f: 11 0a 00    ...
	dad	d		;; e332: 19          .
	mov	e,m		;; e333: 5e          ^
	inx	h		;; e334: 23          #
	mov	d,m		;; e335: 56          V
	xchg			;; e336: eb          .
	ret			;; e337: c9          .

Le338:	xra	a		;; e338: af          .
	sta	Lfce9		;; e339: 32 e9 fc    2..
	inr	a		;; e33c: 3c          <
	sta	Lfcee		;; e33d: 32 ee fc    2..
Le340:	lda	Lfcdb		;; e340: 3a db fc    :..
	cpi	004h		;; e343: fe 04       ..
	jnz	Le34a		;; e345: c2 4a e3    .J.
	mvi	a,002h		;; e348: 3e 02       >.
Le34a:	mov	b,a		;; e34a: 47          G
	lda	Lfce1		;; e34b: 3a e1 fc    :..
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
	lda	Lfd0c		;; e35e: 3a 0c fd    :..
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
	lxi	h,Lfcde		;; e375: 21 de fc    ...
	lda	Lfcff		;; e378: 3a ff fc    :..
	cmp	m		;; e37b: be          .
	jnz	Le38d		;; e37c: c2 8d e3    ...
	lda	Lfd00		;; e37f: 3a 00 fd    :..
	cmp	b		;; e382: b8          .
	jnz	Le38d		;; e383: c2 8d e3    ...
	lda	Lfd01		;; e386: 3a 01 fd    :..
	cmp	c		;; e389: b9          .
	jz	Le3b7		;; e38a: ca b7 e3    ...
Le38d:	push	b		;; e38d: c5          .
	call	Le3f5		;; e38e: cd f5 e3    ...
	call	Le61d		;; e391: cd 1d e6    ...
	call	Le6bc		;; e394: cd bc e6    ...
	pop	b		;; e397: c1          .
	lxi	h,Lfd01		;; e398: 21 01 fd    ...
	mov	m,c		;; e39b: 71          q
	dcx	h		;; e39c: 2b          +
	mov	m,b		;; e39d: 70          p
	lda	Lfcee		;; e39e: 3a ee fc    :..
	ora	a		;; e3a1: b7          .
	jz	Le3b7		;; e3a2: ca b7 e3    ...
	lhld	Lfce3		;; e3a5: 2a e3 fc    *..
	push	h		;; e3a8: e5          .
	lxi	h,Lf5d5		;; e3a9: 21 d5 f5    ...
	shld	Lfce3		;; e3ac: 22 e3 fc    "..
	call	Le43c		;; e3af: cd 3c e4    .<.
	pop	h		;; e3b2: e1          .
	shld	Lfce3		;; e3b3: 22 e3 fc    "..
	rnz			;; e3b6: c0          .
Le3b7:	lda	Lfcdb		;; e3b7: 3a db fc    :..
	cpi	003h		;; e3ba: fe 03       ..
	jz	Le41e		;; e3bc: ca 1e e4    ...
	rar			;; e3bf: 1f          .
	jc	Le40f		;; e3c0: da 0f e4    ...
	lda	Lfce1		;; e3c3: 3a e1 fc    :..
	ani	003h		;; e3c6: e6 03       ..
	rrc			;; e3c8: 0f          .
	rrc			;; e3c9: 0f          .
	mov	l,a		;; e3ca: 6f          o
	mvi	h,000h		;; e3cb: 26 00       &.
	dad	h		;; e3cd: 29          )
	lxi	d,Lf5d5		;; e3ce: 11 d5 f5    ...
Le3d1:	dad	d		;; e3d1: 19          .
	xchg			;; e3d2: eb          .
	lhld	Lfce3		;; e3d3: 2a e3 fc    *..
	mvi	c,080h		;; e3d6: 0e 80       ..
	lda	Lfce5		;; e3d8: 3a e5 fc    :..
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
	lhld	Lfce3		;; e3fd: 2a e3 fc    *..
	push	h		;; e400: e5          .
	lxi	h,Lf5d5		;; e401: 21 d5 f5    ...
	shld	Lfce3		;; e404: 22 e3 fc    "..
	call	Le431		;; e407: cd 31 e4    .1.
	pop	h		;; e40a: e1          .
	shld	Lfce3		;; e40b: 22 e3 fc    "..
	ret			;; e40e: c9          .

Le40f:	lda	Lfce1		;; e40f: 3a e1 fc    :..
	ani	001h		;; e412: e6 01       ..
	rrc			;; e414: 0f          .
	mov	e,a		;; e415: 5f          _
	mvi	d,000h		;; e416: 16 00       ..
	lxi	h,Lf5d5		;; e418: 21 d5 f5    ...
	jmp	Le3d1		;; e41b: c3 d1 e3    ...

Le41e:	lda	Lfce1		;; e41e: 3a e1 fc    :..
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

Le431:	lda	Lfd06		;; e431: 3a 06 fd    :..
	mov	b,a		;; e434: 47          G
	mvi	c,080h		;; e435: 0e 80       ..
	mvi	a,001h		;; e437: 3e 01       >.
	jmp	Le443		;; e439: c3 43 e4    .C.

Le43c:	lda	Lfd07		;; e43c: 3a 07 fd    :..
	mov	b,a		;; e43f: 47          G
	mvi	c,040h		;; e440: 0e 40       .@
	xra	a		;; e442: af          .
Le443:	sta	Lfcd6		;; e443: 32 d6 fc    2..
Le446:	xra	a		;; e446: af          .
	sta	Lfcef		;; e447: 32 ef fc    2..
	mvi	a,010h		;; e44a: 3e 10       >.
Le44c:	sta	Lfcd5		;; e44c: 32 d5 fc    2..
Le44f:	lda	Lfcfe		;; e44f: 3a fe fc    :..
	ani	003h		;; e452: e6 03       ..
	mov	l,a		;; e454: 6f          o
	lda	Lfd00		;; e455: 3a 00 fd    :..
	rlc			;; e458: 07          .
	rlc			;; e459: 07          .
	ora	l		;; e45a: b5          .
	sta	Lfcfe		;; e45b: 32 fe fc    2..
	call	Le742		;; e45e: cd 42 e7    .B.
	di			;; e461: f3          .
	lhld	Lfce7		;; e462: 2a e7 fc    *..
	mov	a,l		;; e465: 7d          }
	out	033h		;; e466: d3 33       .3
	mov	a,c		;; e468: 79          y
	ora	h		;; e469: b4          .
	out	033h		;; e46a: d3 33       .3
	lhld	Lfce3		;; e46c: 2a e3 fc    *..
	mov	a,l		;; e46f: 7d          }
	out	032h		;; e470: d3 32       .2
	mov	a,h		;; e472: 7c          |
	out	032h		;; e473: d3 32       .2
	mvi	a,042h		;; e475: 3e 42       >B
	out	038h		;; e477: d3 38       .8
	ei			;; e479: fb          .
	push	b		;; e47a: c5          .
	mvi	c,008h		;; e47b: 0e 08       ..
	call	Le6e1		;; e47d: cd e1 e6    ...
	pop	b		;; e480: c1          .
	jc	Le44f		;; e481: da 4f e4    .O.
	rz			;; e484: c8          .
	push	b		;; e485: c5          .
	lda	Lfcf1		;; e486: 3a f1 fc    :..
	ani	018h		;; e489: e6 18       ..
	jz	Le492		;; e48b: ca 92 e4    ...
	pop	b		;; e48e: c1          .
	jmp	Le44f		;; e48f: c3 4f e4    .O.

Le492:	lda	Lfcf3		;; e492: 3a f3 fc    :..
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
	lxi	h,Lfcf2		;; e4b6: 21 f2 fc    ...
	mov	a,m		;; e4b9: 7e          ~
	ani	080h		;; e4ba: e6 80       ..
	jz	Le4cf		;; e4bc: ca cf e4    ...
	call	Le667		;; e4bf: cd 67 e6    .g.
	db	'end of track$'
Le4cf:	mov	a,m		;; e4cf: 7e          ~
	ani	020h		;; e4d0: e6 20       . 
	jz	Le4f6		;; e4d2: ca f6 e4    ...
	inx	h		;; e4d5: 23          #
	mov	a,m		;; e4d6: 7e          ~
	dcx	h		;; e4d7: 2b          +
	ani	020h		;; e4d8: e6 20       . 
	jz	Le4ec		;; e4da: ca ec e4    ...
	call	Le667		;; e4dd: cd 67 e6    .g.
	db	'data CRC$'
	jmp	Le4f6		;; e4e9: c3 f6 e4    ...

Le4ec:	call	Le667		;; e4ec: cd 67 e6    .g.
	db	'ID CRC$'
Le4f6:	mov	a,m		;; e4f6: 7e          ~
	ani	004h		;; e4f7: e6 04       ..
	jz	Le510		;; e4f9: ca 10 e5    ...
	call	Le667		;; e4fc: cd 67 e6    .g.
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
	call	Le667		;; e523: cd 67 e6    .g.
	db	'data$'
	jmp	Le534		;; e52b: c3 34 e5    .4.

Le52e:	call	Le667		;; e52e: cd 67 e6    .g.
	db	'ID$'
Le534:	call	Le667		;; e534: cd 67 e6    .g.
	db	' address mark$'
Le545:	call	Le667		;; e545: cd 67 e6    .g.
	db	' ERROR',0dh,0ah,'$'
	lda	Lfd08		;; e551: 3a 08 fd    :..
	ora	a		;; e554: b7          .
	jnz	Le591		;; e555: c2 91 e5    ...
	call	Le667		;; e558: cd 67 e6    .g.
	db	'Continue,Ignore,Retry ? $'
	push	b		;; e574: c5          .
	call	Le958		;; e575: cd 58 e9    .X.
	push	psw		;; e578: f5          .
	mov	c,a		;; e579: 4f          O
	call	Le969		;; e57a: cd 69 e9    .i.
	call	Le667		;; e57d: cd 67 e6    .g.
	db	0dh,0ah,'$'
	pop	psw		;; e583: f1          .
	pop	b		;; e584: c1          .
	ani	0dfh		;; e585: e6 df       ..
	cpi	049h		;; e587: fe 49       .I
	jz	Le594		;; e589: ca 94 e5    ...
	cpi	052h		;; e58c: fe 52       .R
	jz	Le446		;; e58e: ca 46 e4    .F.
Le591:	xra	a		;; e591: af          .
	dcr	a		;; e592: 3d          =
	ret			;; e593: c9          .

Le594:	xra	a		;; e594: af          .
	ret			;; e595: c9          .

Le596:	lhld	Lfce3		;; e596: 2a e3 fc    *..
	lxi	d,0c07fh	;; e599: 11 7f c0    ...
	dad	d		;; e59c: 19          .
	jnc	Le608		;; e59d: d2 08 e6    ...
	lda	Lfce4		;; e5a0: 3a e4 fc    :..
	cpi	0c0h		;; e5a3: fe c0       ..
	jnc	Le608		;; e5a5: d2 08 e6    ...
	lda	Lfce5		;; e5a8: 3a e5 fc    :..
	ora	a		;; e5ab: b7          .
	jnz	Le5c4		;; e5ac: c2 c4 e5    ...
	call	Le5f7		;; e5af: cd f7 e5    ...
	xchg			;; e5b2: eb          .
	mvi	a,008h		;; e5b3: 3e 08       >.
	call	Le5d3		;; e5b5: cd d3 e5    ...
	lxi	d,Lfd70		;; e5b8: 11 70 fd    .p.
	mvi	c,080h		;; e5bb: 0e 80       ..
	lhld	Lfce3		;; e5bd: 2a e3 fc    *..
	xchg			;; e5c0: eb          .
	ldir			;; e5c1: ed b0       ..
	ret			;; e5c3: c9          .

Le5c4:	lhld	Lfce3		;; e5c4: 2a e3 fc    *..
	lxi	d,Lfd70		;; e5c7: 11 70 fd    .p.
	lxi	b,00080h	;; e5ca: 01 80 00    ...
	ldir			;; e5cd: ed b0       ..
	call	Le5f7		;; e5cf: cd f7 e5    ...
	xra	a		;; e5d2: af          .
Le5d3:	mov	b,a		;; e5d3: 47          G
	lda	Lfd11		;; e5d4: 3a 11 fd    :..
	sta	Lfd12		;; e5d7: 32 12 fd    2..
	mvi	a,002h		;; e5da: 3e 02       >.
	sta	Lfd11		;; e5dc: 32 11 fd    2..
	lda	Lfcde		;; e5df: 3a de fc    :..
	adi	002h		;; e5e2: c6 02       ..
	ora	b		;; e5e4: b0          .
	mov	c,a		;; e5e5: 4f          O
	in	000h		;; e5e6: db 00       ..
	ora	c		;; e5e8: b1          .
	out	000h		;; e5e9: d3 00       ..
	lxi	b,00080h	;; e5eb: 01 80 00    ...
	ldir			;; e5ee: ed b0       ..
	ani	0f0h		;; e5f0: e6 f0       ..
	out	000h		;; e5f2: d3 00       ..
	jmp	Lea46		;; e5f4: c3 46 ea    .F.

Le5f7:	lda	Lfce1		;; e5f7: 3a e1 fc    :..
	rar			;; e5fa: 1f          .
	mov	d,a		;; e5fb: 57          W
	mvi	a,000h		;; e5fc: 3e 00       >.
	rar			;; e5fe: 1f          .
	mov	e,a		;; e5ff: 5f          _
	mov	a,d		;; e600: 7a          z
	adi	040h		;; e601: c6 40       .@
	mov	d,a		;; e603: 57          W
	lxi	h,Lfd70		;; e604: 21 70 fd    .p.
	ret			;; e607: c9          .

Le608:	call	Le5f7		;; e608: cd f7 e5    ...
	lhld	Lfce3		;; e60b: 2a e3 fc    *..
	lda	Lfce5		;; e60e: 3a e5 fc    :..
	ora	a		;; e611: b7          .
	mvi	a,000h		;; e612: 3e 00       >.
	jnz	Le5d3		;; e614: c2 d3 e5    ...
	xchg			;; e617: eb          .
	mvi	a,008h		;; e618: 3e 08       >.
	jmp	Le5d3		;; e61a: c3 d3 e5    ...

Le61d:	lda	Lfcd8		;; e61d: 3a d8 fc    :..
	sta	Lfcfc		;; e620: 32 fc fc    2..
	ret			;; e623: c9          .

Le624:	lda	Lfcfe		;; e624: 3a fe fc    :..
	ani	003h		;; e627: e6 03       ..
	adi	041h		;; e629: c6 41       .A
	sta	Le633		;; e62b: 32 33 e6    23.
	call	Le667		;; e62e: cd 67 e6    .g.
	db	0dh,0ah
Le633:	db	'A$'
	call	Le640		;; e635: cd 40 e6    .@.
	rnz			;; e638: c0          .
	xra	a		;; e639: af          .
	sta	00004h		;; e63a: 32 04 00    2..
	jmp	00000h		;; e63d: c3 00 00    ...

Le640:	call	Le667		;; e640: cd 67 e6    .g.
	db	': not ready',16h,0dh,7,'$'
	call	Le958		;; e652: cd 58 e9    .X.
	cpi	003h		;; e655: fe 03       ..
	ret			;; e657: c9          .

Le658:	di			;; e658: f3          .
	mvi	b,004h		;; e659: 06 04       ..
	call	Le728		;; e65b: cd 28 e7    .(.
	mov	b,c		;; e65e: 41          A
	call	Le72f		;; e65f: cd 2f e7    ./.
	call	Le739		;; e662: cd 39 e7    .9.
	ei			;; e665: fb          .
	ret			;; e666: c9          .

Le667:	xthl			;; e667: e3          .
	mov	a,m		;; e668: 7e          ~
	inx	h		;; e669: 23          #
	cpi	024h		;; e66a: fe 24       .$
	xthl			;; e66c: e3          .
	rz			;; e66d: c8          .
	push	b		;; e66e: c5          .
	push	h		;; e66f: e5          .
	push	d		;; e670: d5          .
	mov	c,a		;; e671: 4f          O
	call	Le969		;; e672: cd 69 e9    .i.
	pop	d		;; e675: d1          .
	pop	h		;; e676: e1          .
	pop	b		;; e677: c1          .
	jmp	Le667		;; e678: c3 67 e6    .g.

Le67b:	lda	Lfcd6		;; e67b: 3a d6 fc    :..
	ora	a		;; e67e: b7          .
	jz	Le68f		;; e67f: ca 8f e6    ...
	call	Le667		;; e682: cd 67 e6    .g.
	db	0dh,0ah,'WRITE $'
	ret			;; e68e: c9          .

Le68f:	call	Le667		;; e68f: cd 67 e6    .g.
	db	0dh,0ah,'READ $'
	ret			;; e69a: c9          .

Le69b:	call	Le667		;; e69b: cd 67 e6    .g.
	db	'protect$'
	ret			;; e6a6: c9          .

Le6a7:	call	Le6aa		;; e6a7: cd aa e6    ...
Le6aa:	call	Le742		;; e6aa: cd 42 e7    .B.
	xra	a		;; e6ad: af          .
	sta	Lfcff		;; e6ae: 32 ff fc    2..
	mvi	b,007h		;; e6b1: 06 07       ..
	mvi	c,001h		;; e6b3: 0e 01       ..
	call	Le6e1		;; e6b5: cd e1 e6    ...
	jc	Le6aa		;; e6b8: da aa e6    ...
	ret			;; e6bb: c9          .

Le6bc:	call	Le742		;; e6bc: cd 42 e7    .B.
	lda	Lfcde		;; e6bf: 3a de fc    :..
	lxi	h,Lfcff		;; e6c2: 21 ff fc    ...
	cmp	m		;; e6c5: be          .
	rz			;; e6c6: c8          .
	mov	e,a		;; e6c7: 5f          _
	lda	Lfd0b		;; e6c8: 3a 0b fd    :..
	ora	a		;; e6cb: b7          .
	mov	a,e		;; e6cc: 7b          {
	jz	Le6d1		;; e6cd: ca d1 e6    ...
	rlc			;; e6d0: 07          .
Le6d1:	mov	m,a		;; e6d1: 77          w
Le6d2:	mvi	b,00fh		;; e6d2: 06 0f       ..
	mvi	c,002h		;; e6d4: 0e 02       ..
	call	Le6e1		;; e6d6: cd e1 e6    ...
	jc	Le6d2		;; e6d9: da d2 e6    ...
	mov	a,e		;; e6dc: 7b          {
	sta	Lfcff		;; e6dd: 32 ff fc    2..
	ret			;; e6e0: c9          .

Le6e1:	lxi	h,Lfcfe		;; e6e1: 21 fe fc    ...
	di			;; e6e4: f3          .
	call	Le728		;; e6e5: cd 28 e7    .(.
Le6e8:	mov	b,m		;; e6e8: 46          F
	call	Le72f		;; e6e9: cd 2f e7    ./.
	inx	h		;; e6ec: 23          #
	dcr	c		;; e6ed: 0d          .
	jnz	Le6e8		;; e6ee: c2 e8 e6    ...
	ei			;; e6f1: fb          .
	push	d		;; e6f2: d5          .
	push	b		;; e6f3: c5          .
	mvi	d,002h		;; e6f4: 16 02       ..
Le6f6:	lxi	b,00000h	;; e6f6: 01 00 00    ...
Le6f9:	dcx	b		;; e6f9: 0b          .
	mov	a,b		;; e6fa: 78          x
	ora	c		;; e6fb: b1          .
	jz	Le710		;; e6fc: ca 10 e7    ...
	lxi	h,Lfcf0		;; e6ff: 21 f0 fc    ...
	mov	a,m		;; e702: 7e          ~
	ora	a		;; e703: b7          .
	jz	Le6f9		;; e704: ca f9 e6    ...
	mvi	m,000h		;; e707: 36 00       6.
	inx	h		;; e709: 23          #
	mov	a,m		;; e70a: 7e          ~
	ani	0c0h		;; e70b: e6 c0       ..
	pop	b		;; e70d: c1          .
	pop	d		;; e70e: d1          .
	ret			;; e70f: c9          .

Le710:	dcr	d		;; e710: 15          .
	jnz	Le6f6		;; e711: c2 f6 e6    ...
	lda	Lfd09		;; e714: 3a 09 fd    :..
	call	Le721		;; e717: cd 21 e7    ...
	call	Le624		;; e71a: cd 24 e6    .$.
	pop	b		;; e71d: c1          .
	pop	d		;; e71e: d1          .
	stc			;; e71f: 37          7
	ret			;; e720: c9          .

Le721:	ora	a		;; e721: b7          .
	jz	Le006		;; e722: ca 06 e0    ...
	jmp	Le03a		;; e725: c3 3a e0    .:.

Le728:	in	040h		;; e728: db 40       .@
	ani	01fh		;; e72a: e6 1f       ..
	jnz	Le728		;; e72c: c2 28 e7    .(.
Le72f:	in	040h		;; e72f: db 40       .@
	ral			;; e731: 17          .
	jnc	Le72f		;; e732: d2 2f e7    ./.
	mov	a,b		;; e735: 78          x
	out	041h		;; e736: d3 41       .A
	ret			;; e738: c9          .

Le739:	in	040h		;; e739: db 40       .@
	ral			;; e73b: 17          .
	jnc	Le739		;; e73c: d2 39 e7    .9.
	in	041h		;; e73f: db 41       .A
	ret			;; e741: c9          .

Le742:	push	b		;; e742: c5          .
	lda	Lfd09		;; e743: 3a 09 fd    :..
	ora	a		;; e746: b7          .
	jz	Le778		;; e747: ca 78 e7    .x.
	lxi	h,Lfd0c		;; e74a: 21 0c fd    ...
	lda	Lfcfe		;; e74d: 3a fe fc    :..
	ani	003h		;; e750: e6 03       ..
	mov	c,a		;; e752: 4f          O
	inr	c		;; e753: 0c          .
	mvi	a,080h		;; e754: 3e 80       >.
Le756:	inx	h		;; e756: 23          #
	rlc			;; e757: 07          .
	dcr	c		;; e758: 0d          .
	jnz	Le756		;; e759: c2 56 e7    .V.
	mov	c,a		;; e75c: 4f          O
	di			;; e75d: f3          .
	mov	a,m		;; e75e: 7e          ~
	ora	a		;; e75f: b7          .
	mvi	m,028h		;; e760: 36 28       6(
	ei			;; e762: fb          .
	jnz	Le778		;; e763: c2 78 e7    .x.
	lda	Lde6f		;; e766: 3a 6f de    :o.
	ora	c		;; e769: b1          .
	sta	Lde6f		;; e76a: 32 6f de    2o.
	out	042h		;; e76d: d3 42       .B
	lxi	h,03a98h	;; e76f: 21 98 3a    ..:
Le772:	dcx	h		;; e772: 2b          +
	mov	a,h		;; e773: 7c          |
	ora	l		;; e774: b5          .
	jnz	Le772		;; e775: c2 72 e7    .r.
Le778:	pop	b		;; e778: c1          .
	ret			;; e779: c9          .

Le77a:	dw	Le82b
	dw	00000h
	dw	00000h
	dw	00000h
	dw	Lf9d5
	dw	00000h
	dw	Lfa95
	dw	Lfa55
	db	0ffh
Le78b:	dw	Le82b
	dw	00000h
	dw	00000h
	dw	00000h
	dw	Lf9d5
	dw	00000h
	dw	Lfb15
	dw	Lfad5
	db	0ffh
Le79c:	dw	Le8cf
	dw	00000h
	dw	00000h
	dw	00000h
	dw	Lf9d5
	dw	00000h
	dw	Lfb95
	dw	Lfb55
	db	0ffh
Le7ad:	dw	Le8cf
	dw	00000h
	dw	00000h
	dw	00000h
	dw	Lf9d5
	dw	00000h
	dw	Lfc15
	dw	Lfbd5
	db	0ffh
	dw	00000h
	dw	00000h
	dw	00000h
	dw	00000h
	dw	Lf9d5
	dw	Le855
	dw	Lfc95
	dw	Lfc55
	db	10h
Le7cf:	db	1,1ah,0eh
	db	0ffh
	db	'EF',0efh,0e7h
Le7d7:	db	2,10h,0eh,0ffh,'EF',0feh,0e7h
Le7df:	db	3,8,'5',0ffh,'EF',0dh,0e8h
Le7e7:	db	0,1ah,7,80h,5,6,1ch,0e8h
	db	'4',0,4,0fh,1,0f2h,0,7fh,0,0c0h,0,' ',0,2,0
	db	'@',0,4,0fh,0,'+',1,7fh,0,0c0h,0,'@',0,2,0
	db	'@',0,4,0fh,0,'+',1,7fh,0,0c0h,0,'@',0,2,0
	db	1ah,0,3,7,0,0f2h,0,'?',0,0c0h,0,10h,0,2,0
Le82b:	db	1,7,0dh,13h,19h,5,0bh,11h,17h,3,9,0fh,15h,2,8,0eh,14h,1ah,6
	db	0ch,12h,18h,4,0ah,10h,16h
Le845:	db	0,7,0eh,5,0ch,3,0ah,1,8,0fh,6,0dh,4,0bh,2,9,0,1,4,0fh,1,'_'
Le855	equ	$-6
	db	0,7fh,0,0c0h,0,0,0,0,0
Le864:	db	1,10h,0ah,0ffh,'EF',84h,0e8h
Le86c:	db	2,9,0ah,0ffh,'EF',93h,0e8h
Le874:	db	3,5,80h,0ffh,'EF',0c0h,0e8h
Le87c:	db	0,10h,7,80h,5,6,0b1h,0e8h,' ',0,3,7,0,97h,0,'?',0,0c0h,0,10h
	db	0,2,0,'$',0,3,7,0,0aah,0,'?',0,0c0h,0,10h,0,2,0
Le8a2:	db	'H',0,4,0fh,0,'^',1,7fh,0,0c0h,0,'@',0,2,0,10h,0,3,7,0,'G',0
	db	'?',0,0c0h,0,10h,0,4,0,'(',0,3,7,0,0c7h,0,'?',0,0c0h,0,10h,0
	db	2,0
Le8cf:	db	1,5,9,0dh,2,6,0ah,0eh,3,7,0bh,0fh,4,8,0ch,10h
Le8df:	db	0,4,8,3,7,2,6,1,5,0f5h,0dbh,'@',0e5h,0c5h,21h,0f0h,0fch,0e6h
	db	10h,0c2h,0fh,0e9h,6,8,0cdh,'/',0e7h,0c1h,0cdh,'9',0e7h,'#w'
	db	0cdh,'9',0e7h,'~',0e6h,' ',0cah,93h,0eah,'+6',1,0c3h,93h
	db	0eah
	db	'6',1,6,7,'#',0cdh,'9',0e7h,'w',5,0c2h,13h,0e9h,0c1h,0c3h
	db	93h,0eah
Le920:	dw	Led37
Le922:	dw	Lea7d
	dw	Le975
	dw	Lee45
Le928:	dw	Led7b
Le92a:	dw	Leebf
	dw	Le990
	dw	Lee89
Le930:	dw	Led37
Le932:	dw	Lea7d
	dw	Led37
	dw	Lee45
Le938:	dw	Led7b
Le93a:	dw	Leebf
	dw	Led7b
	dw	Lee89
Le940:	dw	Led7b
Le942:	dw	Leebf
	dw	Lebd7
	dw	Lee89
Le948:	dw	Lec51
	dw	Lea98
	dw	Lec51
	dw	Lec4b
Le950:	dw	Lec51
	dw	Lea98
	dw	Lec51
	dw	Lec4b
Le958:	lxi	h,Le920		;; e958: 21 20 e9    . .
Le95b:	lda	00003h		;; e95b: 3a 03 00    :..
Le95e:	rlc			;; e95e: 07          .
Le95f:	ani	006h		;; e95f: e6 06       ..
	call	Lf5c7		;; e961: cd c7 f5    ...
	mov	a,m		;; e964: 7e          ~
	inx	h		;; e965: 23          #
	mov	h,m		;; e966: 66          f
	mov	l,a		;; e967: 6f          o
	pchl			;; e968: e9          .

Le969:	lxi	h,Le928		;; e969: 21 28 e9    .(.
	jmp	Le95b		;; e96c: c3 5b e9    .[.

Le96f:	lxi	h,Le948		;; e96f: 21 48 e9    .H.
	jmp	Le95b		;; e972: c3 5b e9    .[.

Le975:	lxi	h,Le930		;; e975: 21 30 e9    .0.
Le978:	lda	00003h		;; e978: 3a 03 00    :..
	jmp	Le98c		;; e97b: c3 8c e9    ...

Le97e:	lxi	h,Le950		;; e97e: 21 50 e9    .P.
	jmp	Le978		;; e981: c3 78 e9    .x.

Le984:	lxi	h,Le938		;; e984: 21 38 e9    .8.
	lda	00003h		;; e987: 3a 03 00    :..
	rrc			;; e98a: 0f          .
	rrc			;; e98b: 0f          .
Le98c:	rrc			;; e98c: 0f          .
	jmp	Le95f		;; e98d: c3 5f e9    ._.

Le990:	lxi	h,Le940		;; e990: 21 40 e9    .@.
	lda	00003h		;; e993: 3a 03 00    :..
	rlc			;; e996: 07          .
	rlc			;; e997: 07          .
	jmp	Le95e		;; e998: c3 5e e9    .^.

	sspd	Lea0a		;; e99b: ed 73 0a ea .s..
	lxi	sp,Lea0a	;; e99f: 31 0a ea    1..
	push	h		;; e9a2: e5          .
	push	b		;; e9a3: c5          .
	push	psw		;; e9a4: f5          .
	lxi	h,Lfd0d		;; e9a5: 21 0d fd    ...
	mvi	b,004h		;; e9a8: 06 04       ..
	mvi	c,0feh		;; e9aa: 0e fe       ..
Le9ac:	mov	a,m		;; e9ac: 7e          ~
	ora	a		;; e9ad: b7          .
	jrz	Le9ba		;; e9ae: 28 0a       (.
	dcr	m		;; e9b0: 35          5
	jrnz	Le9ba		;; e9b1: 20 07        .
	lda	Lde6f		;; e9b3: 3a 6f de    :o.
	ana	c		;; e9b6: a1          .
	sta	Lde6f		;; e9b7: 32 6f de    2o.
Le9ba:	rlcr	c		;; e9ba: cb 01       ..
	inx	h		;; e9bc: 23          #
	dcr	b		;; e9bd: 05          .
	jrnz	Le9ac		;; e9be: 20 ec        .
	lda	Lde6f		;; e9c0: 3a 6f de    :o.
	out	042h		;; e9c3: d3 42       .B
	mov	a,m		;; e9c5: 7e          ~
	ora	a		;; e9c6: b7          .
	jrz	Le9e7		;; e9c7: 28 1e       (.
	dcr	m		;; e9c9: 35          5
	jrnz	Le9e7		;; e9ca: 20 1b        .
	mvi	m,001h		;; e9cc: 36 01       6.
	lhld	Lea0d		;; e9ce: 2a 0d ea    *..
	dcx	h		;; e9d1: 2b          +
	mov	a,h		;; e9d2: 7c          |
	ora	l		;; e9d3: b5          .
	shld	Lea0d		;; e9d4: 22 0d ea    "..
	jrnz	Le9e7		;; e9d7: 20 0e        .
	xra	a		;; e9d9: af          .
	sta	Lfd11		;; e9da: 32 11 fd    2..
	inr	a		;; e9dd: 3c          <
	sta	Lea0c		;; e9de: 32 0c ea    2..
	lda	Lea0f		;; e9e1: 3a 0f ea    :..
	rrc			;; e9e4: 0f          .
	jrc	Le9f1		;; e9e5: 38 0a       8.
Le9e7:	pop	psw		;; e9e7: f1          .
	pop	b		;; e9e8: c1          .
	pop	h		;; e9e9: e1          .
	lspd	Lea0a		;; e9ea: ed 7b 0a ea .{..
	ei			;; e9ee: fb          .
	reti			;; e9ef: ed 4d       .M

Le9f1:	pop	psw		;; e9f1: f1          .
	pop	b		;; e9f2: c1          .
	pop	h		;; e9f3: e1          .
	lspd	Lea0a		;; e9f4: ed 7b 0a ea .{..
	push	h		;; e9f8: e5          .
	lhld	Lea10		;; e9f9: 2a 10 ea    *..
	xthl			;; e9fc: e3          .
	ei			;; e9fd: fb          .
	reti			;; e9fe: ed 4d       .M

	db	0,0,0,0,0,0,0,0,0,0
Lea0a:	db	0,0
Lea0c:	db	0
Lea0d:	db	0,0
Lea0f:	db	0
Lea10:	db	0,0
Lea12:	mov	a,e		;; ea12: 7b          {
	sta	Lea0f		;; ea13: 32 0f ea    2..
	shld	Lea10		;; ea16: 22 10 ea    "..
	lxi	h,Lea0d		;; ea19: 21 0d ea    ...
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

Lea2e:	di			;; ea2e: f3          .
	mvi	a,001h		;; ea2f: 3e 01       >.
	sta	Lfd11		;; ea31: 32 11 fd    2..
	ei			;; ea34: fb          .
	xra	a		;; ea35: af          .
Lea36:	lxi	h,Lea0c		;; ea36: 21 0c ea    ...
	mov	m,a		;; ea39: 77          w
	ret			;; ea3a: c9          .

Lea3b:	di			;; ea3b: f3          .
	xra	a		;; ea3c: af          .
	sta	Lfd11		;; ea3d: 32 11 fd    2..
	ei			;; ea40: fb          .
	mvi	a,001h		;; ea41: 3e 01       >.
	jmp	Lea36		;; ea43: c3 36 ea    .6.

Lea46:	di			;; ea46: f3          .
	lda	Lfd11		;; ea47: 3a 11 fd    :..
	cpi	002h		;; ea4a: fe 02       ..
	lda	Lfd12		;; ea4c: 3a 12 fd    :..
	sta	Lfd11		;; ea4f: 32 11 fd    2..
	jz	Lea7a		;; ea52: ca 7a ea    .z.
	ora	a		;; ea55: b7          .
	jz	Lea7a		;; ea56: ca 7a ea    .z.
	push	h		;; ea59: e5          .
	lhld	Lea0d		;; ea5a: 2a 0d ea    *..
	dcx	h		;; ea5d: 2b          +
	mov	a,h		;; ea5e: 7c          |
	ora	l		;; ea5f: b5          .
	shld	Lea0d		;; ea60: 22 0d ea    "..
	jnz	Lea79		;; ea63: c2 79 ea    .y.
	mvi	a,001h		;; ea66: 3e 01       >.
	sta	Lea0c		;; ea68: 32 0c ea    2..
	lda	Lea0f		;; ea6b: 3a 0f ea    :..
	rrc			;; ea6e: 0f          .
	jnc	Lea79		;; ea6f: d2 79 ea    .y.
	xra	a		;; ea72: af          .
	lhld	Lea10		;; ea73: 2a 10 ea    *..
	xthl			;; ea76: e3          .
	ei			;; ea77: fb          .
	ret			;; ea78: c9          .

Lea79:	pop	h		;; ea79: e1          .
Lea7a:	ei			;; ea7a: fb          .
	xra	a		;; ea7b: af          .
	ret			;; ea7c: c9          .

Lea7d:	call	Lea98		;; ea7d: cd 98 ea    ...
	jrz	Lea7d		;; ea80: 28 fb       (.
	dcr	m		;; ea82: 35          5
	inx	h		;; ea83: 23          #
	mov	a,m		;; ea84: 7e          ~
	ret			;; ea85: c9          .

	push	psw		;; ea86: f5          .
	push	h		;; ea87: e5          .
	in	050h		;; ea88: db 50       .P
	ani	07fh		;; ea8a: e6 7f       ..
	lxi	h,Lfd26		;; ea8c: 21 26 fd    .&.
	mvi	m,001h		;; ea8f: 36 01       6.
	inx	h		;; ea91: 23          #
	mov	m,a		;; ea92: 77          w
	pop	h		;; ea93: e1          .
	pop	psw		;; ea94: f1          .
	ei			;; ea95: fb          .
	reti			;; ea96: ed 4d       .M

Lea98:	lxi	h,Lfd26		;; ea98: 21 26 fd    .&.
Lea9b:	mov	a,m		;; ea9b: 7e          ~
	ora	a		;; ea9c: b7          .
	rz			;; ea9d: c8          .
	mvi	a,0ffh		;; ea9e: 3e ff       >.
	ret			;; eaa0: c9          .

	push	psw		;; eaa1: f5          .
	push	h		;; eaa2: e5          .
	push	b		;; eaa3: c5          .
	push	d		;; eaa4: d5          .
	in	02ch		;; eaa5: db 2c       .,
	mov	e,a		;; eaa7: 5f          _
	ani	07fh		;; eaa8: e6 7f       ..
	lxi	b,00006h	;; eaaa: 01 06 00    ...
	lxi	h,Leae3		;; eaad: 21 e3 ea    ...
	ccdr			;; eab0: ed b9       ..
	lxi	h,Leae4		;; eab2: 21 e4 ea    ...
	jrnz	Leae5		;; eab5: 20 2e        .
	mov	b,c		;; eab7: 41          A
	inr	b		;; eab8: 04          .
	mvi	a,040h		;; eab9: 3e 40       >@
Leabb:	rrc			;; eabb: 0f          .
	djnz	Leabb		;; eabc: 10 fd       ..
	mov	b,a		;; eabe: 47          G
	bit	7,e		;; eabf: cb 7b       .{
	jrnz	Leacf		;; eac1: 20 0c        .
	mov	a,b		;; eac3: 78          x
	cpi	010h		;; eac4: fe 10       ..
	jrnc	Leacc		;; eac6: 30 04       0.
	ora	m		;; eac8: b6          .
Leac9:	mov	m,a		;; eac9: 77          w
	jr	Lead7		;; eaca: 18 0b       ..

Leacc:	xra	m		;; eacc: ae          .
	jr	Leac9		;; eacd: 18 fa       ..

Leacf:	mov	a,b		;; eacf: 78          x
	cpi	010h		;; ead0: fe 10       ..
	jrnc	Lead7		;; ead2: 30 03       0.
	cma			;; ead4: 2f          /
	ana	m		;; ead5: a6          .
	mov	m,a		;; ead6: 77          w
Lead7:	pop	d		;; ead7: d1          .
	pop	b		;; ead8: c1          .
	pop	h		;; ead9: e1          .
	pop	psw		;; eada: f1          .
	ei			;; eadb: fb          .
	reti			;; eadc: ed 4d       .M

	lda	03845h		;; eade: 3a 45 38    :E8
	dcr	e		;; eae1: 1d          .
	lhld	00036h		;; eae2: 2a 36 00    *6.
Leae3	equ	$-2
Leae4	equ	$-1
Leae5:	bit	7,e		;; eae5: cb 7b       .{
	jrnz	Lead7		;; eae7: 20 ee        .
	sta	Lfd27		;; eae9: 32 27 fd    2'.
	sta	Lfd26		;; eaec: 32 26 fd    2&.
	mov	a,m		;; eaef: 7e          ~
	sta	Lfd28		;; eaf0: 32 28 fd    2(.
	jr	Lead7		;; eaf3: 18 e2       ..

Leaf5:	call	Lea98		;; eaf5: cd 98 ea    ...
	inr	a		;; eaf8: 3c          <
	jrnz	Leaf5		;; eaf9: 20 fa        .
	mov	m,a		;; eafb: 77          w
	inx	h		;; eafc: 23          #
	mov	c,m		;; eafd: 4e          N
	inx	h		;; eafe: 23          #
	mov	e,m		;; eaff: 5e          ^
	mov	a,c		;; eb00: 79          y
	cpi	047h		;; eb01: fe 47       .G
	jrc	Leb0c		;; eb03: 38 07       8.
	bit	4,e		;; eb05: cb 63       .c
	jrz	Leb0c		;; eb07: 28 03       (.
	adi	00dh		;; eb09: c6 0d       ..
	mov	c,a		;; eb0b: 4f          O
Leb0c:	lxi	h,Leb4a		;; eb0c: 21 4a eb    .J.
	mvi	b,000h		;; eb0f: 06 00       ..
	dad	b		;; eb11: 09          .
	mov	a,m		;; eb12: 7e          ~
	cpi	061h		;; eb13: fe 61       .a
	jrc	Leb30		;; eb15: 38 19       8.
	cpi	07bh		;; eb17: fe 7b       .{
	jrnc	Leb30		;; eb19: 30 15       0.
	bit	5,e		;; eb1b: cb 6b       .k
	jrz	Leb21		;; eb1d: 28 02       (.
	xri	020h		;; eb1f: ee 20       . 
Leb21:	mov	b,a		;; eb21: 47          G
	mov	a,e		;; eb22: 7b          {
	ani	003h		;; eb23: e6 03       ..
	mov	a,b		;; eb25: 78          x
	jrz	Leb2a		;; eb26: 28 02       (.
	xri	020h		;; eb28: ee 20       . 
Leb2a:	bit	2,e		;; eb2a: cb 53       .S
	rz			;; eb2c: c8          .
	ani	01fh		;; eb2d: e6 1f       ..
	ret			;; eb2f: c9          .

Leb30:	cpi	021h		;; eb30: fe 21       ..
	jrnc	Leb36		;; eb32: 30 02       0.
	ora	a		;; eb34: b7          .
	ret			;; eb35: c9          .

Leb36:	bit	7,a		;; eb36: cb 7f       ..
	rz			;; eb38: c8          .
	ani	07fh		;; eb39: e6 7f       ..
	mov	c,a		;; eb3b: 4f          O
	mov	a,e		;; eb3c: 7b          {
	ani	003h		;; eb3d: e6 03       ..
	lxi	h,Lebaa		;; eb3f: 21 aa eb    ...
	jrz	Leb47		;; eb42: 28 03       (.
	lxi	h,Lebc0		;; eb44: 21 c0 eb    ...
Leb47:	dad	b		;; eb47: 09          .
	mov	a,m		;; eb48: 7e          ~
	jr	Leb2a		;; eb49: 18 df       ..

Leb4a	equ	$-1
	dcx	d		;; eb4b: 1b          .
	add	c		;; eb4c: 81          .
	add	d		;; eb4d: 82          .
	add	e		;; eb4e: 83          .
	add	h		;; eb4f: 84          .
	add	l		;; eb50: 85          .
	add	m		;; eb51: 86          .
	add	a		;; eb52: 87          .
	adc	b		;; eb53: 88          .
	adc	c		;; eb54: 89          .
	adc	d		;; eb55: 8a          .
	adc	e		;; eb56: 8b          .
	adc	h		;; eb57: 8c          .
	exaf			;; eb58: 08          .
	dad	b		;; eb59: 09          .
	mov	m,c		;; eb5a: 71          q
	mov	m,a		;; eb5b: 77          w
	mov	h,l		;; eb5c: 65          e
	mov	m,d		;; eb5d: 72          r
	mov	m,h		;; eb5e: 74          t
	mov	a,c		;; eb5f: 79          y
	mov	m,l		;; eb60: 75          u
	mov	l,c		;; eb61: 69          i
	mov	l,a		;; eb62: 6f          o
	mov	m,b		;; eb63: 70          p
	adc	l		;; eb64: 8d          .
	adc	m		;; eb65: 8e          .
	dcr	c		;; eb66: 0d          .
	nop			;; eb67: 00          .
	mov	h,c		;; eb68: 61          a
	mov	m,e		;; eb69: 73          s
	mov	h,h		;; eb6a: 64          d
	mov	h,m		;; eb6b: 66          f
	mov	h,a		;; eb6c: 67          g
	mov	l,b		;; eb6d: 68          h
	mov	l,d		;; eb6e: 6a          j
	mov	l,e		;; eb6f: 6b          k
	mov	l,h		;; eb70: 6c          l
	adc	a		;; eb71: 8f          .
	sub	b		;; eb72: 90          .
	sub	c		;; eb73: 91          .
	nop			;; eb74: 00          .
	sub	d		;; eb75: 92          .
	mov	a,d		;; eb76: 7a          z
	mov	a,b		;; eb77: 78          x
	mov	h,e		;; eb78: 63          c
	hlt			;; eb79: 76          v
	mov	h,d		;; eb7a: 62          b
	mov	l,m		;; eb7b: 6e          n
	mov	l,l		;; eb7c: 6d          m
	sub	e		;; eb7d: 93          .
	sub	h		;; eb7e: 94          .
	sub	l		;; eb7f: 95          .
	nop			;; eb80: 00          .
	sub	m		;; eb81: 96          .
	nop			;; eb82: 00          .
	jrnz	Leb85		;; eb83: 20 00        .
Leb85:	inx	d		;; eb85: 13          .
	inr	b		;; eb86: 04          .
	lxi	b,00506h	;; eb87: 01 06 05    ...
	stax	d		;; eb8a: 12          .
	jr	Leb90		;; eb8b: 18 03       ..

	mvi	c,00fh		;; eb8d: 0e 0f       ..
	nop			;; eb8f: 00          .
Leb90:	nop			;; eb90: 00          .
	mvi	d,01ah		;; eb91: 16 1a       ..
	ral			;; eb93: 17          .
	dcr	l		;; eb94: 2d          -
	exaf			;; eb95: 08          .
	dcr	e		;; eb96: 1d          .
	dcr	d		;; eb97: 15          .
	dcx	h		;; eb98: 2b          +
	mvi	b,00ah		;; eb99: 06 0a       ..
	dcr	b		;; eb9b: 05          .
	stax	d		;; eb9c: 12          .
	mov	a,a		;; eb9d: 7f          .
	stc			;; eb9e: 37          7
	jrc	Lebda		;; eb9f: 38 39       89
	dcr	l		;; eba1: 2d          -
	inr	m		;; eba2: 34          4
	dcr	m		;; eba3: 35          5
	mvi	m,02bh		;; eba4: 36 2b       6+
	lxi	sp,03332h	;; eba6: 31 32 33    123
	jrnc	Lebd9		;; eba9: 30 2e       0.
Lebaa	equ	$-1
	lxi	sp,03332h	;; ebab: 31 32 33    123
	inr	m		;; ebae: 34          4
	dcr	m		;; ebaf: 35          5
	mvi	m,037h		;; ebb0: 36 37       67
	jrc	Lebed		;; ebb2: 38 39       89
	jrnc	Lebe3		;; ebb4: 30 2d       0-
	dcr	a		;; ebb6: 3d          =
	mov	e,e		;; ebb7: 5b          [
	mov	e,l		;; ebb8: 5d          ]
	dcx	sp		;; ebb9: 3b          ;
	daa			;; ebba: 27          '
	mov	h,b		;; ebbb: 60          `
	mov	e,h		;; ebbc: 5c          \
	inr	l		;; ebbd: 2c          ,
	mvi	l,02fh		;; ebbe: 2e 2f       ./
Lebc0:	lhld	04021h		;; ebc0: 2a 21 40    *.@
	inx	h		;; ebc3: 23          #
	inr	h		;; ebc4: 24          $
	dcr	h		;; ebc5: 25          %
	mov	e,m		;; ebc6: 5e          ^
	mvi	h,02ah		;; ebc7: 26 2a       &*
	jrz	Lebf4		;; ebc9: 28 29       ()
	mov	e,a		;; ebcb: 5f          _
	dcx	h		;; ebcc: 2b          +
	mov	a,e		;; ebcd: 7b          {
	mov	a,l		;; ebce: 7d          }
	lda	07e22h		;; ebcf: 3a 22 7e    :"~
	mov	a,h		;; ebd2: 7c          |
	inr	a		;; ebd3: 3c          <
	mvi	a,03fh		;; ebd4: 3e 3f       >?
	sbb	b		;; ebd6: 98          .
Lebd7:	in	002h		;; ebd7: db 02       ..
Lebd9:	ani	060h		;; ebd9: e6 60       .`
Lebda	equ	$-1
	cpi	020h		;; ebdb: fe 20       . 
	jrnz	Lec0f		;; ebdd: 20 30        0
Lebdf:	lxi	d,00000h	;; ebdf: 11 00 00    ...
	mvi	b,00ah		;; ebe2: 06 0a       ..
Lebe3	equ	$-1
	lxi	h,Lfd29		;; ebe4: 21 29 fd    .).
Lebe7:	mov	a,m		;; ebe7: 7e          ~
	ora	a		;; ebe8: b7          .
	jrz	Lec03		;; ebe9: 28 18       (.
	dcx	d		;; ebeb: 1b          .
	mov	a,e		;; ebec: 7b          {
Lebed:	ora	d		;; ebed: b2          .
	jrnz	Lebe7		;; ebee: 20 f7        .
	djnz	Lebe7		;; ebf0: 10 f5       ..
	call	Le667		;; ebf2: cd 67 e6    .g.
Lebf4	equ	$-1
	db	0dh,0ah,'LPT$'
	call	Le640		;; ebfb: cd 40 e6    .@.
	jrnz	Lebdf		;; ebfe: 20 df        .
	jmp	00000h		;; ec00: c3 00 00    ...

Lec03:	dcr	m		;; ec03: 35          5
	in	002h		;; ec04: db 02       ..
	ani	010h		;; ec06: e6 10       ..
	mov	a,c		;; ec08: 79          y
	jrnz	Lec0c		;; ec09: 20 01        .
	cma			;; ec0b: 2f          /
Lec0c:	out	051h		;; ec0c: d3 51       .Q
	ret			;; ec0e: c9          .

Lec0f:	call	Le667		;; ec0f: cd 67 e6    .g.
	db	7,0dh,0ah,'LPT not coupled.  Waiting...$'
	call	Lec37		;; ec32: cd 37 ec    .7.
	jr	Lebd7		;; ec35: 18 a0       ..

Lec37:	push	b		;; ec37: c5          .
	call	Le958		;; ec38: cd 58 e9    .X.
	pop	b		;; ec3b: c1          .
	cpi	003h		;; ec3c: fe 03       ..
	rnz			;; ec3e: c0          .
	jmp	00000h		;; ec3f: c3 00 00    ...

	push	psw		;; ec42: f5          .
	xra	a		;; ec43: af          .
	sta	Lfd29		;; ec44: 32 29 fd    2).
	pop	psw		;; ec47: f1          .
	ei			;; ec48: fb          .
	reti			;; ec49: ed 4d       .M

Lec4b:	lxi	h,Lfd1d		;; ec4b: 21 1d fd    ...
	jmp	Lea9b		;; ec4e: c3 9b ea    ...

Lec51:	lxi	h,Lfd18		;; ec51: 21 18 fd    ...
	jmp	Lea9b		;; ec54: c3 9b ea    ...

Lec57:	sta	Lec6f		;; ec57: 32 6f ec    2o.
	cpi	041h		;; ec5a: fe 41       .A
	lda	Lfd21		;; ec5c: 3a 21 fd    :..
	jrz	Lec64		;; ec5f: 28 03       (.
	lda	Lfd25		;; ec61: 3a 25 fd    :%.
Lec64:	rlc			;; ec64: 07          .
	rc			;; ec65: d8          .
	call	Le667		;; ec66: cd 67 e6    .g.
	db	0dh,0ah,'SIO/'
Lec6f:	db	'? ERROR',16h,'$'
	jmp	Lec37		;; ec78: c3 37 ec    .7.

	sspd	Leea5		;; ec7b: ed 73 a5 ee .s..
	lxi	sp,Leea5	;; ec7f: 31 a5 ee    1..
	push	psw		;; ec82: f5          .
	push	h		;; ec83: e5          .
	push	b		;; ec84: c5          .
	in	010h		;; ec85: db 10       ..
	lxi	h,Lfd21		;; ec87: 21 21 fd    ...
	ana	m		;; ec8a: a6          .
	mov	b,a		;; ec8b: 47          G
	dcx	h		;; ec8c: 2b          +
	mov	a,m		;; ec8d: 7e          ~
	rrc			;; ec8e: 0f          .
	jrc	Lec9d		;; ec8f: 38 0c       8.
	mov	a,b		;; ec91: 78          x
	cpi	011h		;; ec92: fe 11       ..
	jrz	Lecd9		;; ec94: 28 43       (C
	cpi	013h		;; ec96: fe 13       ..
	jrz	Lecd2		;; ec98: 28 38       (8
	ora	a		;; ec9a: b7          .
	jrz	Lecbe		;; ec9b: 28 21       (.
Lec9d:	lxi	h,Lfd18		;; ec9d: 21 18 fd    ...
	mov	a,m		;; eca0: 7e          ~
	cpi	07fh		;; eca1: fe 7f       ..
	jrnc	Lecc8		;; eca3: 30 23       0#
	inr	m		;; eca5: 34          4
	lhld	Lfd14		;; eca6: 2a 14 fd    *..
	mov	m,b		;; eca9: 70          p
	inx	h		;; ecaa: 23          #
	shld	Lfd14		;; ecab: 22 14 fd    "..
	lxi	b,0018fh	;; ecae: 01 8f 01    ...
	dad	b		;; ecb1: 09          .
	jrnc	Lecba		;; ecb2: 30 06       0.
	lxi	h,Lfdf2		;; ecb4: 21 f2 fd    ...
	shld	Lfd14		;; ecb7: 22 14 fd    "..
Lecba:	cpi	05fh		;; ecba: fe 5f       ._
	jrnc	Lece4		;; ecbc: 30 26       0&
Lecbe:	pop	b		;; ecbe: c1          .
	pop	h		;; ecbf: e1          .
	pop	psw		;; ecc0: f1          .
	lspd	Leea5		;; ecc1: ed 7b a5 ee .{..
Lecc5:	ei			;; ecc5: fb          .
	reti			;; ecc6: ed 4d       .M

Lecc8:	lda	Lfd13		;; ecc8: 3a 13 fd    :..
	ori	004h		;; eccb: f6 04       ..
Leccd:	sta	Lfd13		;; eccd: 32 13 fd    2..
	jr	Lecbe		;; ecd0: 18 ec       ..

Lecd2:	lda	Lfd13		;; ecd2: 3a 13 fd    :..
	ori	001h		;; ecd5: f6 01       ..
	jr	Leccd		;; ecd7: 18 f4       ..

Lecd9:	lda	Lfd13		;; ecd9: 3a 13 fd    :..
	bit	0,a		;; ecdc: cb 47       .G
	jrz	Lec9d		;; ecde: 28 bd       (.
	ani	0feh		;; ece0: e6 fe       ..
	jr	Leccd		;; ece2: 18 e9       ..

Lece4:	lda	Lfd13		;; ece4: 3a 13 fd    :..
	bit	1,a		;; ece7: cb 4f       .O
	jrnz	Lecbe		;; ece9: 20 d3        .
	ori	002h		;; eceb: f6 02       ..
	sta	Lfd13		;; eced: 32 13 fd    2..
	pop	b		;; ecf0: c1          .
	pop	h		;; ecf1: e1          .
	pop	psw		;; ecf2: f1          .
	lspd	Leea5		;; ecf3: ed 7b a5 ee .{..
	sspd	Leeb1		;; ecf7: ed 73 b1 ee .s..
	lxi	sp,Leeb1	;; ecfb: 31 b1 ee    1..
	push	psw		;; ecfe: f5          .
	push	b		;; ecff: c5          .
	call	Lecc5		;; ed00: cd c5 ec    ...
	mvi	c,013h		;; ed03: 0e 13       ..
	call	Led6d		;; ed05: cd 6d ed    .m.
	pop	b		;; ed08: c1          .
	pop	psw		;; ed09: f1          .
	lspd	Leeb1		;; ed0a: ed 7b b1 ee .{..
	ret			;; ed0e: c9          .

	push	psw		;; ed0f: f5          .
	lda	Lfd13		;; ed10: 3a 13 fd    :..
	ori	004h		;; ed13: f6 04       ..
	sta	Lfd13		;; ed15: 32 13 fd    2..
	mvi	a,030h		;; ed18: 3e 30       >0
	out	012h		;; ed1a: d3 12       ..
	in	010h		;; ed1c: db 10       ..
	jr	Led25		;; ed1e: 18 05       ..

	push	psw		;; ed20: f5          .
	mvi	a,010h		;; ed21: 3e 10       >.
	out	012h		;; ed23: d3 12       ..
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
Led37:	lxi	h,Lfd13		;; ed37: 21 13 fd    ...
	mov	a,m		;; ed3a: 7e          ~
	bit	2,a		;; ed3b: cb 57       .W
	jrnz	Led29		;; ed3d: 20 ea        .
	di			;; ed3f: f3          .
	lxi	h,Lfd18		;; ed40: 21 18 fd    ...
	mov	a,m		;; ed43: 7e          ~
	ora	a		;; ed44: b7          .
	jrz	Led33		;; ed45: 28 ec       (.
	dcr	m		;; ed47: 35          5
	ei			;; ed48: fb          .
	cz	Led61		;; ed49: cc 61 ed    .a.
	lhld	Lfd16		;; ed4c: 2a 16 fd    *..
	mov	a,m		;; ed4f: 7e          ~
	inx	h		;; ed50: 23          #
	shld	Lfd16		;; ed51: 22 16 fd    "..
	lxi	b,0018fh	;; ed54: 01 8f 01    ...
	dad	b		;; ed57: 09          .
	rnc			;; ed58: d0          .
	lxi	h,Lfdf2		;; ed59: 21 f2 fd    ...
	shld	Lfd16		;; ed5c: 22 16 fd    "..
	cmc			;; ed5f: 3f          ?
	ret			;; ed60: c9          .

Led61:	lxi	h,Lfd13		;; ed61: 21 13 fd    ...
	mov	a,m		;; ed64: 7e          ~
	bit	1,a		;; ed65: cb 4f       .O
	rz			;; ed67: c8          .
	ani	0fdh		;; ed68: e6 fd       ..
	mov	m,a		;; ed6a: 77          w
	mvi	c,011h		;; ed6b: 0e 11       ..
Led6d:	in	012h		;; ed6d: db 12       ..
	bit	5,a		;; ed6f: cb 6f       .o
	stc			;; ed71: 37          7
	rz			;; ed72: c8          .
	ani	004h		;; ed73: e6 04       ..
	jrz	Led6d		;; ed75: 28 f6       (.
	mov	a,c		;; ed77: 79          y
	out	010h		;; ed78: d3 10       ..
	ret			;; ed7a: c9          .

Led7b:	lda	Lfd13		;; ed7b: 3a 13 fd    :..
	ani	001h		;; ed7e: e6 01       ..
	jrnz	Led7b		;; ed80: 20 f9        .
	call	Led6d		;; ed82: cd 6d ed    .m.
	rnc			;; ed85: d0          .
	mvi	a,041h		;; ed86: 3e 41       >A
	call	Lec57		;; ed88: cd 57 ec    .W.
	jr	Led7b		;; ed8b: 18 ee       ..

	sspd	Leea5		;; ed8d: ed 73 a5 ee .s..
	lspd	Leea5		;; ed91: ed 7b a5 ee .{..
	push	psw		;; ed95: f5          .
	push	h		;; ed96: e5          .
	push	b		;; ed97: c5          .
	in	011h		;; ed98: db 11       ..
	lxi	h,Lfd25		;; ed9a: 21 25 fd    .%.
	ana	m		;; ed9d: a6          .
	mov	b,a		;; ed9e: 47          G
	dcx	h		;; ed9f: 2b          +
	mov	a,m		;; eda0: 7e          ~
	rrc			;; eda1: 0f          .
	jrc	Ledb1		;; eda2: 38 0d       8.
	mov	a,b		;; eda4: 78          x
	cpi	011h		;; eda5: fe 11       ..
	jrz	Lede5		;; eda7: 28 3c       (<
	cpi	013h		;; eda9: fe 13       ..
	jrz	Leddd		;; edab: 28 30       (0
	ora	a		;; edad: b7          .
	jz	Lecbe		;; edae: ca be ec    ...
Ledb1:	lxi	h,Lfd1d		;; edb1: 21 1d fd    ...
	mov	a,m		;; edb4: 7e          ~
	cpi	07fh		;; edb5: fe 7f       ..
	jrnc	Ledd5		;; edb7: 30 1c       0.
	inr	m		;; edb9: 34          4
	lhld	Lfd19		;; edba: 2a 19 fd    *..
	mov	m,b		;; edbd: 70          p
	inx	h		;; edbe: 23          #
	shld	Lfd19		;; edbf: 22 19 fd    "..
	lxi	b,0010fh	;; edc2: 01 0f 01    ...
	dad	b		;; edc5: 09          .
	jrnc	Ledce		;; edc6: 30 06       0.
	lxi	h,Lfe72		;; edc8: 21 72 fe    .r.
	shld	Lfd19		;; edcb: 22 19 fd    "..
Ledce:	cpi	05fh		;; edce: fe 5f       ._
	jrnc	Ledf1		;; edd0: 30 1f       0.
	jmp	Lecbe		;; edd2: c3 be ec    ...

Ledd5:	lda	Lfd13		;; edd5: 3a 13 fd    :..
	ori	040h		;; edd8: f6 40       .@
	jmp	Leccd		;; edda: c3 cd ec    ...

Leddd:	lda	Lfd13		;; eddd: 3a 13 fd    :..
	ori	010h		;; ede0: f6 10       ..
	jmp	Leccd		;; ede2: c3 cd ec    ...

Lede5:	lda	Lfd13		;; ede5: 3a 13 fd    :..
	bit	4,a		;; ede8: cb 67       .g
	jrz	Ledb1		;; edea: 28 c5       (.
	ani	0efh		;; edec: e6 ef       ..
	jmp	Leccd		;; edee: c3 cd ec    ...

Ledf1:	lda	Lfd13		;; edf1: 3a 13 fd    :..
	bit	5,a		;; edf4: cb 6f       .o
	jnz	Lecbe		;; edf6: c2 be ec    ...
	ori	020h		;; edf9: f6 20       . 
	sta	Lfd13		;; edfb: 32 13 fd    2..
	pop	b		;; edfe: c1          .
	pop	h		;; edff: e1          .
	pop	psw		;; ee00: f1          .
	lspd	Leea5		;; ee01: ed 7b a5 ee .{..
	sspd	Leebd		;; ee05: ed 73 bd ee .s..
	lxi	sp,Leebd	;; ee09: 31 bd ee    1..
	push	psw		;; ee0c: f5          .
	push	b		;; ee0d: c5          .
	call	Lecc5		;; ee0e: cd c5 ec    ...
	mvi	c,013h		;; ee11: 0e 13       ..
	call	Lee7b		;; ee13: cd 7b ee    .{.
	pop	b		;; ee16: c1          .
	pop	psw		;; ee17: f1          .
	lspd	Leebd		;; ee18: ed 7b bd ee .{..
	ret			;; ee1c: c9          .

	push	psw		;; ee1d: f5          .
	lda	Lfd13		;; ee1e: 3a 13 fd    :..
	ori	040h		;; ee21: f6 40       .@
	sta	Lfd13		;; ee23: 32 13 fd    2..
	mvi	a,030h		;; ee26: 3e 30       >0
	out	013h		;; ee28: d3 13       ..
	in	011h		;; ee2a: db 11       ..
	jmp	Led25		;; ee2c: c3 25 ed    .%.

	push	psw		;; ee2f: f5          .
	mvi	a,010h		;; ee30: 3e 10       >.
	out	013h		;; ee32: d3 13       ..
	jmp	Led25		;; ee34: c3 25 ed    .%.

Lee37:	ani	0bfh		;; ee37: e6 bf       ..
	mov	m,a		;; ee39: 77          w
	mvi	a,042h		;; ee3a: 3e 42       >B
	call	Lec57		;; ee3c: cd 57 ec    .W.
	jr	Lee45		;; ee3f: 18 04       ..

Lee41:	ei			;; ee41: fb          .
	call	Lee6f		;; ee42: cd 6f ee    .o.
Lee45:	lxi	h,Lfd13		;; ee45: 21 13 fd    ...
	mov	a,m		;; ee48: 7e          ~
	bit	6,a		;; ee49: cb 77       .w
	jrnz	Lee37		;; ee4b: 20 ea        .
	di			;; ee4d: f3          .
	lxi	h,Lfd1d		;; ee4e: 21 1d fd    ...
	mov	a,m		;; ee51: 7e          ~
	ora	a		;; ee52: b7          .
	jrz	Lee41		;; ee53: 28 ec       (.
	dcr	m		;; ee55: 35          5
	ei			;; ee56: fb          .
	cz	Lee6f		;; ee57: cc 6f ee    .o.
	lhld	Lfd1b		;; ee5a: 2a 1b fd    *..
	mov	a,m		;; ee5d: 7e          ~
	inx	h		;; ee5e: 23          #
	shld	Lfd1b		;; ee5f: 22 1b fd    "..
	lxi	b,0010fh	;; ee62: 01 0f 01    ...
	dad	b		;; ee65: 09          .
	rnc			;; ee66: d0          .
	lxi	h,Lfe72		;; ee67: 21 72 fe    .r.
	shld	Lfd1b		;; ee6a: 22 1b fd    "..
	cmc			;; ee6d: 3f          ?
	ret			;; ee6e: c9          .

Lee6f:	lxi	h,Lfd13		;; ee6f: 21 13 fd    ...
	mov	a,m		;; ee72: 7e          ~
	bit	5,a		;; ee73: cb 6f       .o
	rz			;; ee75: c8          .
	ani	0dfh		;; ee76: e6 df       ..
	mov	m,a		;; ee78: 77          w
	mvi	c,011h		;; ee79: 0e 11       ..
Lee7b:	in	013h		;; ee7b: db 13       ..
	bit	5,a		;; ee7d: cb 6f       .o
	stc			;; ee7f: 37          7
	rz			;; ee80: c8          .
	ani	004h		;; ee81: e6 04       ..
	jrz	Lee7b		;; ee83: 28 f6       (.
	mov	a,c		;; ee85: 79          y
	out	011h		;; ee86: d3 11       ..
	ret			;; ee88: c9          .

Lee89:	lda	Lfd13		;; ee89: 3a 13 fd    :..
	ani	010h		;; ee8c: e6 10       ..
	jrnz	Lee89		;; ee8e: 20 f9        .
	call	Lee7b		;; ee90: cd 7b ee    .{.
	rnc			;; ee93: d0          .
	mvi	a,042h		;; ee94: 3e 42       >B
	call	Lec57		;; ee96: cd 57 ec    .W.
	jr	Lee89		;; ee99: 18 ee       ..

	db	0,0,0,0,0,0,0,0,0,0
Leea5:	db	0,0,0,0,0,0,0,0,0,0,0,0
Leeb1:	db	0,0,0,0,0,0,0,0,0,0,0,0
Leebd:	db	0,0
Leebf:	call	Lef08		;; eebf: cd 08 ef    ...
	sspd	Lfdf0		;; eec2: ed 73 f0 fd .s..
	lxi	sp,Lfdf0	;; eec6: 31 f0 fd    1..
	pushix			;; eec9: dd e5       ..
	lxix	Lf50c		;; eecb: dd 21 0c f5 ....
	lda	Lf51a		;; eecf: 3a 1a f5    :..
	setb	2,a		;; eed2: cb d7       ..
	out	062h		;; eed4: d3 62       .b
	call	Lef13		;; eed6: cd 13 ef    ...
Leed9:	lda	Lf51a		;; eed9: 3a 1a f5    :..
	out	062h		;; eedc: d3 62       .b
	popix			;; eede: dd e1       ..
	lspd	Lfdf0		;; eee0: ed 7b f0 fd .{..
	jmp	Lea46		;; eee4: c3 46 ea    .F.

Leee7:	call	Lef08		;; eee7: cd 08 ef    ...
	sspd	Lfdf0		;; eeea: ed 73 f0 fd .s..
	lxi	sp,Lfdf0	;; eeee: 31 f0 fd    1..
	pushix			;; eef1: dd e5       ..
	lxix	Lf50c		;; eef3: dd 21 0c f5 ....
	lda	Lf51a		;; eef7: 3a 1a f5    :..
	setb	2,a		;; eefa: cb d7       ..
	out	062h		;; eefc: d3 62       .b
	mvi	a,020h		;; eefe: 3e 20       > 
	call	Lf165		;; ef00: cd 65 f1    .e.
	call	Lefe8		;; ef03: cd e8 ef    ...
	jr	Leed9		;; ef06: 18 d1       ..

Lef08:	di			;; ef08: f3          .
	lxi	h,Lfd11		;; ef09: 21 11 fd    ...
	mov	a,m		;; ef0c: 7e          ~
	mvi	m,002h		;; ef0d: 36 02       6.
	inx	h		;; ef0f: 23          #
	mov	m,a		;; ef10: 77          w
	ei			;; ef11: fb          .
	ret			;; ef12: c9          .

Lef13:	lxi	h,Lf510		;; ef13: 21 10 f5    ...
	mov	a,m		;; ef16: 7e          ~
	ora	a		;; ef17: b7          .
	jnz	Lf0f8		;; ef18: c2 f8 f0    ...
	mov	a,c		;; ef1b: 79          y
	bitx	6,+2		;; ef1c: dd cb 02 76 ...v
	jrnz	Lef27		;; ef20: 20 05        .
	ani	07fh		;; ef22: e6 7f       ..
	cpi	07fh		;; ef24: fe 7f       ..
	rz			;; ef26: c8          .
Lef27:	cpi	020h		;; ef27: fe 20       . 
	jrc	Lef37		;; ef29: 38 0c       8.
	lhld	Lf513		;; ef2b: 2a 13 f5    *..
	mov	m,a		;; ef2e: 77          w
	lda	Lf517		;; ef2f: 3a 17 f5    :..
	sta	Lf515		;; ef32: 32 15 f5    2..
	jr	Lef47		;; ef35: 18 10       ..

Lef37:	lxi	h,Lf2cc		;; ef37: 21 cc f2    ...
	lxi	b,0000dh	;; ef3a: 01 0d 00    ...
	lxi	d,Lf2f1		;; ef3d: 11 f1 f2    ...
	jmp	Lf190		;; ef40: c3 90 f1    ...

Lef43:	setx	5,+3		;; ef43: dd cb 03 ee ....
Lef47:	lda	Lf50c		;; ef47: 3a 0c f5    :..
	cmpx	+5		;; ef4a: dd be 05    ...
	jrnc	Lef54		;; ef4d: 30 05       0.
	inrx	+0		;; ef4f: dd 34 00    .4.
	jr	Lefa2		;; ef52: 18 4e       .N

Lef54:	bitx	1,+2		;; ef54: dd cb 02 4e ...N
	rz			;; ef58: c8          .
	mvix	000h,+0		;; ef59: dd 36 00 00 .6..
	lda	Lf50d		;; ef5d: 3a 0d f5    :..
	cmpx	+6		;; ef60: dd be 06    ...
	jrnc	Lef6e		;; ef63: 30 09       0.
Lef65:	inrx	+1		;; ef65: dd 34 01    .4.
	cpi	00bh		;; ef68: fe 0b       ..
	jrnz	Lefa2		;; ef6a: 20 36        6
	jr	Lef87		;; ef6c: 18 19       ..

Lef6e:	bitx	5,+3		;; ef6e: dd cb 03 6e ...n
	jrnz	Lef7d		;; ef72: 20 09        .
	bitx	3,+2		;; ef74: dd cb 02 5e ...^
	jrz	Lef7d		;; ef78: 28 03       (.
	call	Le958		;; ef7a: cd 58 e9    .X.
Lef7d:	bitx	0,+2		;; ef7d: dd cb 02 46 ...F
	jrz	Lef9b		;; ef81: 28 18       (.
	mvix	000h,+1		;; ef83: dd 36 01 00 .6..
Lef87:	bitx	5,+3		;; ef87: dd cb 03 6e ...n
	jrnz	Lefa2		;; ef8b: 20 15        .
	call	Lefe8		;; ef8d: cd e8 ef    ...
	bitx	4,+2		;; ef90: dd cb 02 66 ...f
	rz			;; ef94: c8          .
	mvi	a,00bh		;; ef95: 3e 0b       >.
	inr	a		;; ef97: 3c          <
	jmp	Lf1b6		;; ef98: c3 b6 f1    ...

Lef9b:	resx	5,+3		;; ef9b: dd cb 03 ae ....
	jmp	Lf09e		;; ef9f: c3 9e f0    ...

Lefa2:	resx	5,+3		;; efa2: dd cb 03 ae ....
	jr	Lefe8		;; efa6: 18 40       .@

Lefa8:	lda	Lf50c		;; efa8: 3a 0c f5    :..
	ani	0f8h		;; efab: e6 f8       ..
	adi	008h		;; efad: c6 08       ..
	cmpx	+5		;; efaf: dd be 05    ...
	jrc	Lefb5		;; efb2: 38 01       8.
	dcr	a		;; efb4: 3d          =
Lefb5:	sta	Lf50c		;; efb5: 32 0c f5    2..
	jr	Lefe8		;; efb8: 18 2e       ..

Lefba:	lda	Lf50c		;; efba: 3a 0c f5    :..
	ora	a		;; efbd: b7          .
	jrz	Lefc5		;; efbe: 28 05       (.
	dcrx	+0		;; efc0: dd 35 00    .5.
	jr	Lefe8		;; efc3: 18 23       .#

Lefc5:	bitx	1,+2		;; efc5: dd cb 02 4e ...N
	rz			;; efc9: c8          .
	lda	Lf511		;; efca: 3a 11 f5    :..
	sta	Lf50c		;; efcd: 32 0c f5    2..
	lda	Lf50d		;; efd0: 3a 0d f5    :..
	ora	a		;; efd3: b7          .
	jrnz	Lefe5		;; efd4: 20 0f        .
	bitx	0,+2		;; efd6: dd cb 02 46 ...F
	jz	Lf08d		;; efda: ca 8d f0    ...
	lda	Lf512		;; efdd: 3a 12 f5    :..
	sta	Lf50d		;; efe0: 32 0d f5    2..
	jr	Lefe8		;; efe3: 18 03       ..

Lefe5:	dcrx	+1		;; efe5: dd 35 01    .5.
Lefe8:	lhld	Lf513		;; efe8: 2a 13 f5    *..
	lda	Lf515		;; efeb: 3a 15 f5    :..
	inx	h		;; efee: 23          #
	mov	m,a		;; efef: 77          w
	lda	Lf50d		;; eff0: 3a 0d f5    :..
	ldx	e,+0		;; eff3: dd 5e 00    .^.
	call	Lf1f9		;; eff6: cd f9 f1    ...
	shld	Lf513		;; eff9: 22 13 f5    "..
Leffc:	inx	h		;; effc: 23          #
	mov	a,m		;; effd: 7e          ~
	sta	Lf515		;; effe: 32 15 f5    2..
	bitx	5,+2		;; f001: dd cb 02 6e ...n
	rnz			;; f005: c0          .
	cma			;; f006: 2f          /
	mov	m,a		;; f007: 77          w
	ret			;; f008: c9          .

Lf009:	lda	Lf50d		;; f009: 3a 0d f5    :..
	cmpx	+6		;; f00c: dd be 06    ...
	jrnc	Lf016		;; f00f: 30 05       0.
	inrx	+1		;; f011: dd 34 01    .4.
	jr	Lefe8		;; f014: 18 d2       ..

Lf016:	bitx	0,+2		;; f016: dd cb 02 46 ...F
	rz			;; f01a: c8          .
	mvix	000h,+1		;; f01b: dd 36 01 00 .6..
	jr	Lefe8		;; f01f: 18 c7       ..

Lf021:	xra	a		;; f021: af          .
	cmpx	+1		;; f022: dd be 01    ...
	jrnc	Lf02c		;; f025: 30 05       0.
Lf027:	dcrx	+1		;; f027: dd 35 01    .5.
	jr	Lefe8		;; f02a: 18 bc       ..

Lf02c:	bitx	0,+2		;; f02c: dd cb 02 46 ...F
	rz			;; f030: c8          .
	lda	Lf512		;; f031: 3a 12 f5    :..
	sta	Lf50d		;; f034: 32 0d f5    2..
	jr	Lefe8		;; f037: 18 af       ..

Lf039:	mvix	000h,+0		;; f039: dd 36 00 00 .6..
	bitx	2,+2		;; f03d: dd cb 02 56 ...V
	jrz	Lefe8		;; f041: 28 a5       (.
Lf043:	lda	Lf50d		;; f043: 3a 0d f5    :..
	cmpx	+6		;; f046: dd be 06    ...
	jnc	Lef7d		;; f049: d2 7d ef    .}.
	jmp	Lef65		;; f04c: c3 65 ef    .e.

Lf04f:	resx	0,+2		;; f04f: dd cb 02 86 ....
Lf053:	mvi	a,004h		;; f053: 3e 04       >.
	out	062h		;; f055: d3 62       .b
	lda	Lf517		;; f057: 3a 17 f5    :..
	sta	Lf515		;; f05a: 32 15 f5    2..
	xra	a		;; f05d: af          .
	sta	Lf516		;; f05e: 32 16 f5    2..
Lf060	equ	$-1
	call	Lf19e		;; f061: cd 9e f1    ...
	di			;; f064: f3          .
	mvi	a,0cfh		;; f065: 3e cf       >.
	out	023h		;; f067: d3 23       .#
	mvi	a,001h		;; f069: 3e 01       >.
	out	023h		;; f06b: d3 23       .#
	ei			;; f06d: fb          .
	mvi	b,001h		;; f06e: 06 01       ..
	ldx	e,+11		;; f070: dd 5e 0b    .^.
	bitx	1,+3		;; f073: dd cb 03 4e ...N
	jrz	Lf07b		;; f077: 28 02       (.
	mvi	e,007h		;; f079: 1e 07       ..
Lf07b:	call	Lf1a9		;; f07b: cd a9 f1    ...
Lf07e:	lxi	h,00000h	;; f07e: 21 00 00    ...
	shld	Lf50c		;; f081: 22 0c f5    "..
	jmp	Lefe8		;; f084: c3 e8 ef    ...

Lf087:	lda	Lf50d		;; f087: 3a 0d f5    :..
	ora	a		;; f08a: b7          .
	jrnz	Lf027		;; f08b: 20 9a        .
Lf08d:	lda	Lf516		;; f08d: 3a 16 f5    :..
	ora	a		;; f090: b7          .
	jrz	Lf098		;; f091: 28 05       (.
	dcrx	+10		;; f093: dd 35 0a    .5.
	jr	Lf0ae		;; f096: 18 16       ..

Lf098:	mvix	018h,+10	;; f098: dd 36 0a 18 .6..
	jr	Lf0ae		;; f09c: 18 10       ..

Lf09e:	lda	Lf516		;; f09e: 3a 16 f5    :..
	cpi	018h		;; f0a1: fe 18       ..
	jrnc	Lf0aa		;; f0a3: 30 05       0.
	inrx	+10		;; f0a5: dd 34 0a    .4.
	jr	Lf0ae		;; f0a8: 18 04       ..

Lf0aa:	mvix	000h,+10	;; f0aa: dd 36 0a 00 .6..
Lf0ae:	di			;; f0ae: f3          .
	mvi	a,0cfh		;; f0af: 3e cf       >.
	out	023h		;; f0b1: d3 23       .#
	mvi	a,001h		;; f0b3: 3e 01       >.
	out	023h		;; f0b5: d3 23       .#
	ei			;; f0b7: fb          .
	bitx	1,+3		;; f0b8: dd cb 03 4e ...N
	jrz	Lf0cb		;; f0bc: 28 0d       (.
	mvi	a,018h		;; f0be: 3e 18       >.
	call	Lf1f7		;; f0c0: cd f7 f1    ...
	lxi	b,00150h	;; f0c3: 01 50 01    .P.
	mvi	e,007h		;; f0c6: 1e 07       ..
	call	Lf1a7		;; f0c8: cd a7 f1    ...
Lf0cb:	ldx	a,+1		;; f0cb: dd 7e 01    .~.
	call	Lf1f7		;; f0ce: cd f7 f1    ...
	lxi	b,00150h	;; f0d1: 01 50 01    .P.
	call	Lf1a4		;; f0d4: cd a4 f1    ...
	jmp	Lefe8		;; f0d7: c3 e8 ef    ...

Lf0da:	push	psw		;; f0da: f5          .
	lda	Lf516		;; f0db: 3a 16 f5    :..
	out	064h		;; f0de: d3 64       .d
	lda	Lf51c		;; f0e0: 3a 1c f5    :..
	out	063h		;; f0e3: d3 63       .c
	mvi	a,003h		;; f0e5: 3e 03       >.
	out	023h		;; f0e7: d3 23       .#
Lf0e9:	pop	psw		;; f0e9: f1          .
	ei			;; f0ea: fb          .
	reti			;; f0eb: ed 4d       .M

Lf0ed:	push	psw		;; f0ed: f5          .
	xra	a		;; f0ee: af          .
	out	060h		;; f0ef: d3 60       .`
	jr	Lf0e9		;; f0f1: 18 f6       ..

Lf0f3:	mvix	001h,+4		;; f0f3: dd 36 04 01 .6..
	ret			;; f0f7: c9          .

Lf0f8:	dcr	a		;; f0f8: 3d          =
	jrz	Lf104		;; f0f9: 28 09       (.
	dcr	a		;; f0fb: 3d          =
	jrz	Lf11d		;; f0fc: 28 1f       (.
	dcr	a		;; f0fe: 3d          =
	jrz	Lf136		;; f0ff: 28 35       (5
	mvi	m,000h		;; f101: 36 00       6.
	ret			;; f103: c9          .

Lf104:	mov	a,c		;; f104: 79          y
	cpi	061h		;; f105: fe 61       .a
	jrc	Lf10f		;; f107: 38 06       8.
	cpi	07bh		;; f109: fe 7b       .{
	jrnc	Lf10f		;; f10b: 30 02       0.
	ani	05fh		;; f10d: e6 5f       ._
Lf10f:	mvi	m,000h		;; f10f: 36 00       6.
Lf111:	lxi	h,Lf2f3		;; f111: 21 f3 f2    ...
	lxi	b,00005h	;; f114: 01 05 00    ...
	lxi	d,Lf300		;; f117: 11 00 f3    ...
	jmp	Lf190		;; f11a: c3 90 f1    ...

Lf11d:	mvi	m,003h		;; f11d: 36 03       6.
	mov	a,c		;; f11f: 79          y
	sui	020h		;; f120: d6 20       . 
	bitx	4,+3		;; f122: dd cb 03 66 ...f
	jrnz	Lf12f		;; f126: 20 07        .
	call	Lf236		;; f128: cd 36 f2    .6.
	sta	Lf50d		;; f12b: 32 0d f5    2..
	ret			;; f12e: c9          .

Lf12f:	call	Lf22e		;; f12f: cd 2e f2    ...
	sta	Lf50c		;; f132: 32 0c f5    2..
	ret			;; f135: c9          .

Lf136:	mvi	m,000h		;; f136: 36 00       6.
	mov	a,c		;; f138: 79          y
	sui	020h		;; f139: d6 20       . 
	bitx	4,+3		;; f13b: dd cb 03 66 ...f
	jrz	Lf14a		;; f13f: 28 09       (.
	call	Lf236		;; f141: cd 36 f2    .6.
	sta	Lf50d		;; f144: 32 0d f5    2..
	jmp	Lefe8		;; f147: c3 e8 ef    ...

Lf14a:	call	Lf22e		;; f14a: cd 2e f2    ...
	sta	Lf50c		;; f14d: 32 0c f5    2..
	jmp	Lefe8		;; f150: c3 e8 ef    ...

Lf153:	mvi	a,010h		;; f153: 3e 10       >.
	jr	Lf165		;; f155: 18 0e       ..

Lf157:	mvi	a,001h		;; f157: 3e 01       >.
	jr	Lf165		;; f159: 18 0a       ..

Lf15b:	mvi	a,002h		;; f15b: 3e 02       >.
	jr	Lf165		;; f15d: 18 06       ..

Lf15f:	mvi	a,040h		;; f15f: 3e 40       >@
	jr	Lf165		;; f161: 18 02       ..

Lf163:	mvi	a,008h		;; f163: 3e 08       >.
Lf165:	lxi	h,Lf50e		;; f165: 21 0e f5    ...
	xra	m		;; f168: ae          .
	mov	m,a		;; f169: 77          w
	ret			;; f16a: c9          .

Lf16b:	bitx	0,+3		;; f16b: dd cb 03 46 ...F
	rz			;; f16f: c8          .
	resx	0,+3		;; f170: dd cb 03 86 ....
	jr	Lf17f		;; f174: 18 09       ..

Lf176:	bitx	0,+3		;; f176: dd cb 03 46 ...F
	rnz			;; f17a: c0          .
	setx	0,+3		;; f17b: dd cb 03 c6 ....
Lf17f:	lxi	h,Lf517		;; f17f: 21 17 f5    ...
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

Lf19e:	lhld	Lf518		;; f19e: 2a 18 f5    *..
	lxi	b,01850h	;; f1a1: 01 50 18    .P.
Lf1a4:	ldx	e,+11		;; f1a4: dd 5e 0b    .^.
Lf1a7:	mvi	d,020h		;; f1a7: 16 20       . 
Lf1a9:	mov	m,d		;; f1a9: 72          r
	inx	h		;; f1aa: 23          #
	mov	m,e		;; f1ab: 73          s
	inx	h		;; f1ac: 23          #
	dcr	c		;; f1ad: 0d          .
	jrnz	Lf1a9		;; f1ae: 20 f9        .
	mvi	c,050h		;; f1b0: 0e 50       .P
	djnz	Lf1a9		;; f1b2: 10 f5       ..
	ret			;; f1b4: c9          .

Lf1b5:	xra	a		;; f1b5: af          .
Lf1b6:	push	psw		;; f1b6: f5          .
	lda	Lf50c		;; f1b7: 3a 0c f5    :..
	bitx	2,+3		;; f1ba: dd cb 03 56 ...V
	jrz	Lf1c1		;; f1be: 28 01       (.
	add	a		;; f1c0: 87          .
Lf1c1:	mov	c,a		;; f1c1: 4f          O
	mvi	a,050h		;; f1c2: 3e 50       >P
	sub	c		;; f1c4: 91          .
	mov	c,a		;; f1c5: 4f          O
	lhld	Lf513		;; f1c6: 2a 13 f5    *..
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

Lf1e0:	lhld	Lf513		;; f1e0: 2a 13 f5    *..
	jmp	Leffc		;; f1e3: c3 fc ef    ...

Lf1e6:	lhld	Lf50c		;; f1e6: 2a 0c f5    *..
	mov	a,l		;; f1e9: 7d          }
	ora	h		;; f1ea: b4          .
	jz	Lf053		;; f1eb: ca 53 f0    .S.
	lda	Lf512		;; f1ee: 3a 12 f5    :..
	subx	+1		;; f1f1: dd 96 01    ...
	inr	a		;; f1f4: 3c          <
	jr	Lf1b6		;; f1f5: 18 bf       ..

Lf1f7:	mvi	e,000h		;; f1f7: 1e 00       ..
Lf1f9:	bitx	2,+3		;; f1f9: dd cb 03 56 ...V
	jrz	Lf201		;; f1fd: 28 02       (.
	slar	e		;; f1ff: cb 23       .#
Lf201:	addx	+10		;; f201: dd 86 0a    ...
	mov	d,a		;; f204: 57          W
	add	a		;; f205: 87          .
	add	a		;; f206: 87          .
	add	d		;; f207: 82          .
	mvi	h,000h		;; f208: 26 00       &.
	mov	d,h		;; f20a: 54          T
	mov	l,a		;; f20b: 6f          o
	dad	h		;; f20c: 29          )
	dad	h		;; f20d: 29          )
	dad	h		;; f20e: 29          )
	dad	h		;; f20f: 29          )
	dad	d		;; f210: 19          .
	dad	h		;; f211: 29          )
Lf212:	xchg			;; f212: eb          .
	lxi	h,Lf060		;; f213: 21 60 f0    .`.
	dad	d		;; f216: 19          .
	jrnc	Lf21a		;; f217: 30 01       0.
	xchg			;; f219: eb          .
Lf21a:	lhld	Lf518		;; f21a: 2a 18 f5    *..
	dad	d		;; f21d: 19          .
	ret			;; f21e: c9          .

Lf21f:	setx	4,+3		;; f21f: dd cb 03 e6 ....
	jr	Lf229		;; f223: 18 04       ..

Lf225:	resx	4,+3		;; f225: dd cb 03 a6 ....
Lf229:	mvix	002h,+4		;; f229: dd 36 04 02 .6..
	ret			;; f22d: c9          .

Lf22e:	cmpx	+5		;; f22e: dd be 05    ...
	rc			;; f231: d8          .
	lda	Lf511		;; f232: 3a 11 f5    :..
	ret			;; f235: c9          .

Lf236:	cmpx	+6		;; f236: dd be 06    ...
	rc			;; f239: d8          .
	lda	Lf512		;; f23a: 3a 12 f5    :..
	ret			;; f23d: c9          .

Lf23e:	in	000h		;; f23e: db 00       ..
	ori	020h		;; f240: f6 20       . 
	out	000h		;; f242: d3 00       ..
	lxi	b,08000h	;; f244: 01 00 80    ...
Lf247:	dcr	c		;; f247: 0d          .
	jrnz	Lf247		;; f248: 20 fd        .
	djnz	Lf247		;; f24a: 10 fb       ..
	ani	0dfh		;; f24c: e6 df       ..
	out	000h		;; f24e: d3 00       ..
	ret			;; f250: c9          .

Lf251:	pop	h		;; f251: e1          .
	pop	h		;; f252: e1          .
	shld	Lf2aa		;; f253: 22 aa f2    "..
	lhld	Lfdf0		;; f256: 2a f0 fd    *..
	shld	Lf2ca		;; f259: 22 ca f2    "..
	lxi	sp,Lf2ca	;; f25c: 31 ca f2    1..
	lda	Lf51a		;; f25f: 3a 1a f5    :..
	out	062h		;; f262: d3 62       .b
	call	Lea46		;; f264: cd 46 ea    .F.
	xra	a		;; f267: af          .
	ldx	c,+6		;; f268: dd 4e 06    .N.
	inr	c		;; f26b: 0c          .
Lf26c:	ldx	b,+5		;; f26c: dd 46 05    .F.
	inr	b		;; f26f: 04          .
	mvi	e,000h		;; f270: 1e 00       ..
Lf272:	push	psw		;; f272: f5          .
	push	b		;; f273: c5          .
	push	d		;; f274: d5          .
	call	Lf1f9		;; f275: cd f9 f1    ...
	lda	Lf51a		;; f278: 3a 1a f5    :..
	setb	2,a		;; f27b: cb d7       ..
	di			;; f27d: f3          .
	out	062h		;; f27e: d3 62       .b
	mov	c,m		;; f280: 4e          N
	res	2,a		;; f281: cb 97       ..
	out	062h		;; f283: d3 62       .b
	ei			;; f285: fb          .
	call	Le990		;; f286: cd 90 e9    ...
	pop	d		;; f289: d1          .
	inr	e		;; f28a: 1c          .
	pop	b		;; f28b: c1          .
	pop	psw		;; f28c: f1          .
	djnz	Lf272		;; f28d: 10 e3       ..
	push	psw		;; f28f: f5          .
	push	b		;; f290: c5          .
	mvi	c,00dh		;; f291: 0e 0d       ..
	call	Le990		;; f293: cd 90 e9    ...
	mvi	c,00ah		;; f296: 0e 0a       ..
	call	Le990		;; f298: cd 90 e9    ...
	pop	b		;; f29b: c1          .
	pop	psw		;; f29c: f1          .
	inr	a		;; f29d: 3c          <
	dcr	c		;; f29e: 0d          .
	jrnz	Lf26c		;; f29f: 20 cb        .
	lixd	Lf2aa		;; f2a1: dd 2a aa f2 .*..
	lspd	Lf2ca		;; f2a5: ed 7b ca f2 .{..
	ret			;; f2a9: c9          .

Lf2aa:	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db	0,0
Lf2ca:	db	0,0
Lf2cc:	db	7,8,0ah,0dh,0eh,0fh,15h,16h,17h,18h,19h,1ah,1bh
	dw	Lf23e
	dw	Lefba
	dw	Lf043
	dw	Lf039
	dw	Lf176
	dw	Lf16b
	dw	Lef43
	dw	Lf1b5
	dw	Lf1e6
	dw	Lf053
	dw	Lf07e
	dw	Lf021
Lf2f1:	dw	Lf0f3
Lf2f3:	db	'1289I'
	dw	Lf21f
	dw	Lf157
	dw	Lf153
	dw	Lf163
Lf300:	dw	Lf04f
	db	7,8,9,0ah,0bh,0ch,0dh,0eh,0fh,15h,16h,17h,18h,19h,1ah,1bh
	dw	Lf23e
	dw	Lefba
	dw	Lefa8
	dw	Lf043
	dw	Lf043
	dw	Lf043
	dw	Lf039
	dw	Lf176
	dw	Lf16b
	dw	Lef43
	dw	Lf1b5
	dw	Lf1e6
	dw	Lf053
	dw	Lf07e
	dw	Lf021
	dw	Lf0f3
	db	'Y34+ABCDHIJK|'
	dw	Lf225
	dw	Lf157
	dw	Lf15b
	dw	Lf15f
	dw	Lf021
	dw	Lf009
	dw	Lef43
	dw	Lefba
	dw	Lf07e
	dw	Lf087
	dw	Lf1e6
	dw	Lf1b5
	dw	Lf251
Lf359:	pushix			;; f359: dd e5       ..
	lxix	Lf50c		;; f35b: dd 21 0c f5 ....
	mov	a,b		;; f35f: 78          x
	ora	a		;; f360: b7          .
	jz	Lf408		;; f361: ca 08 f4    ...
	cpi	005h		;; f364: fe 05       ..
	jrz	Lf37b		;; f366: 28 13       (.
	cpi	009h		;; f368: fe 09       ..
	jrz	Lf3b5		;; f36a: 28 49       (I
	cpi	00bh		;; f36c: fe 0b       ..
	jrz	Lf3d0		;; f36e: 28 60       (`
	cpi	00fh		;; f370: fe 0f       ..
	jrz	Lf3e0		;; f372: 28 6c       (l
	cpi	010h		;; f374: fe 10       ..
	jrz	Lf3eb		;; f376: 28 73       (s
Lf378:	popix			;; f378: dd e1       ..
	ret			;; f37a: c9          .

Lf37b:	bitx	1,+14		;; f37b: dd cb 0e 4e ...N
	jrnz	Lf378		;; f37f: 20 f7        .
	mov	a,c		;; f381: 79          y
	ani	003h		;; f382: e6 03       ..
	mov	c,a		;; f384: 4f          O
	ldx	e,+18		;; f385: dd 5e 12    .^.
	sta	Lf51e		;; f388: 32 1e f5    2..
	rrc			;; f38b: 0f          .
	rrc			;; f38c: 0f          .
	sta	Lf51c		;; f38d: 32 1c f5    2..
	rrc			;; f390: 0f          .
	rrc			;; f391: 0f          .
	ori	040h		;; f392: f6 40       .@
	sta	Lf519		;; f394: 32 19 f5    2..
	lxi	h,Lf51f		;; f397: 21 1f f5    ...
	mvi	d,000h		;; f39a: 16 00       ..
	mov	b,d		;; f39c: 42          B
	dad	d		;; f39d: 19          .
	lda	Lf516		;; f39e: 3a 16 f5    :..
	mov	m,a		;; f3a1: 77          w
	dsbc	d		;; f3a2: ed 52       .R
	dad	b		;; f3a4: 09          .
	mov	a,m		;; f3a5: 7e          ~
	sta	Lf516		;; f3a6: 32 16 f5    2..
	di			;; f3a9: f3          .
	mvi	a,0cfh		;; f3aa: 3e cf       >.
	out	023h		;; f3ac: d3 23       .#
	mvi	a,001h		;; f3ae: 3e 01       >.
	out	023h		;; f3b0: d3 23       .#
	ei			;; f3b2: fb          .
	jr	Lf378		;; f3b3: 18 c3       ..

Lf3b5:	bitx	1,+14		;; f3b5: dd cb 0e 4e ...N
	jrnz	Lf3c0		;; f3b9: 20 05        .
	stx	c,+11		;; f3bb: dd 71 0b    .q.
	jr	Lf378		;; f3be: 18 b8       ..

Lf3c0:	mov	a,c		;; f3c0: 79          y
	ani	003h		;; f3c1: e6 03       ..
	mov	c,a		;; f3c3: 4f          O
	mvi	b,003h		;; f3c4: 06 03       ..
Lf3c6:	rlc			;; f3c6: 07          .
	rlc			;; f3c7: 07          .
	add	c		;; f3c8: 81          .
	djnz	Lf3c6		;; f3c9: 10 fb       ..
	sta	Lf51b		;; f3cb: 32 1b f5    2..
	jr	Lf378		;; f3ce: 18 a8       ..

Lf3d0:	bitx	1,+14		;; f3d0: dd cb 0e 4e ...N
	jrz	Lf378		;; f3d4: 28 a2       (.
	mov	a,c		;; f3d6: 79          y
	ani	03fh		;; f3d7: e6 3f       .?
	sta	Lf51c		;; f3d9: 32 1c f5    2..
	out	063h		;; f3dc: d3 63       .c
	jr	Lf378		;; f3de: 18 98       ..

Lf3e0:	ldx	b,+16		;; f3e0: dd 46 10    .F.
	mov	a,b		;; f3e3: 78          x
	ani	0c0h		;; f3e4: e6 c0       ..
	orax	+17		;; f3e6: dd b6 11    ...
	jr	Lf378		;; f3e9: 18 8d       ..

Lf3eb:	lda	Lfd2a		;; f3eb: 3a 2a fd    :*.
	ana	c		;; f3ee: a1          .
	jrz	Lf405		;; f3ef: 28 14       (.
	cpi	004h		;; f3f1: fe 04       ..
	jrz	Lf3fb		;; f3f3: 28 06       (.
	cpi	008h		;; f3f5: fe 08       ..
	jrz	Lf400		;; f3f7: 28 07       (.
	jr	Lf405		;; f3f9: 18 0a       ..

Lf3fb:	lhld	Lf508		;; f3fb: 2a 08 f5    *..
	jr	Lf403		;; f3fe: 18 03       ..

Lf400:	lhld	Lde4f		;; f400: 2a 4f de    *O.
Lf403:	dcx	h		;; f403: 2b          +
	mov	a,m		;; f404: 7e          ~
Lf405:	popix			;; f405: dd e1       ..
	ret			;; f407: c9          .

Lf408:	mov	a,c		;; f408: 79          y
	lxi	d,0184fh	;; f409: 11 4f 18    .O.
	lxi	h,00000h	;; f40c: 21 00 00    ...
	dcr	a		;; f40f: 3d          =
	jrz	Lf42c		;; f410: 28 1a       (.
	dcr	a		;; f412: 3d          =
	dcr	a		;; f413: 3d          =
	jrz	Lf438		;; f414: 28 22       ("
	dcr	a		;; f416: 3d          =
	jz	Lf49b		;; f417: ca 9b f4    ...
	dcr	a		;; f41a: 3d          =
	dcr	a		;; f41b: 3d          =
	jz	Lf4a9		;; f41c: ca a9 f4    ...
	dcr	d		;; f41f: 15          .
	dcr	a		;; f420: 3d          =
	dcr	a		;; f421: 3d          =
	jrz	Lf434		;; f422: 28 10       (.
	dcr	a		;; f424: 3d          =
	jnz	Lf378		;; f425: c2 78 f3    .x.
	setb	1,h		;; f428: cb cc       ..
	jr	Lf438		;; f42a: 18 0c       ..

Lf42c:	mvi	e,027h		;; f42c: 1e 27       .'
	mvi	a,028h		;; f42e: 3e 28       >(
	setb	2,h		;; f430: cb d4       ..
	jr	Lf43a		;; f432: 18 06       ..

Lf434:	lxi	h,01282h	;; f434: 21 82 12    ...
	inr	a		;; f437: 3c          <
Lf438:	mvi	a,029h		;; f438: 3e 29       >)
Lf43a:	call	Lf4c8		;; f43a: cd c8 f4    ...
	mvix	007h,+11	;; f43d: dd 36 0b 07 .6..
	lxi	h,Lf4f6		;; f441: 21 f6 f4    ...
	jrz	Lf449		;; f444: 28 03       (.
	lxi	h,Lf4e4		;; f446: 21 e4 f4    ...
Lf449:	lxi	b,00009h	;; f449: 01 09 00    ...
	lxi	d,Lef37		;; f44c: 11 37 ef    .7.
	ldir			;; f44f: ed b0       ..
	lxi	d,Lf111		;; f451: 11 11 f1    ...
	lxi	b,00009h	;; f454: 01 09 00    ...
	ldir			;; f457: ed b0       ..
	xra	a		;; f459: af          .
	sta	Lf51c		;; f45a: 32 1c f5    2..
	sta	Lf51e		;; f45d: 32 1e f5    2..
	lxi	h,Lf0da		;; f460: 21 da f0    ...
	shld	Lde86		;; f463: 22 86 de    "..
	lxi	h,Leebf		;; f466: 21 bf ee    ...
	lxi	d,Leee7		;; f469: 11 e7 ee    ...
Lf46c:	push	d		;; f46c: d5          .
	push	h		;; f46d: e5          .
	mvi	c,018h		;; f46e: 0e 18       ..
	call	Lf49a		;; f470: cd 9a f4    ...
	pop	h		;; f473: e1          .
	shld	Le92a		;; f474: 22 2a e9    "*.
	shld	Le93a		;; f477: 22 3a e9    ":.
	shld	Le942		;; f47a: 22 42 e9    "B.
	pop	h		;; f47d: e1          .
	shld	Lde52		;; f47e: 22 52 de    "R.
	bitx	1,+14		;; f481: dd cb 0e 4e ...N
	jrz	Lf497		;; f485: 28 10       (.
	lxi	h,Lf0ed		;; f487: 21 ed f0    ...
	shld	Lde86		;; f48a: 22 86 de    "..
	di			;; f48d: f3          .
	mvi	a,0cfh		;; f48e: 3e cf       >.
	out	023h		;; f490: d3 23       .#
	mvi	a,001h		;; f492: 3e 01       >.
	out	023h		;; f494: d3 23       .#
	ei			;; f496: fb          .
Lf497:	popix			;; f497: dd e1       ..
	ret			;; f499: c9          .

Lf49a:	pchl			;; f49a: e9          .

Lf49b:	mvi	e,027h		;; f49b: 1e 27       .'
	setb	2,h		;; f49d: cb d4       ..
	mvix	0ffh,+15	;; f49f: dd 36 0f ff .6..
	mvi	b,020h		;; f4a3: 06 20       . 
	mvi	a,00ah		;; f4a5: 3e 0a       >.
	jr	Lf4ad		;; f4a7: 18 04       ..

Lf4a9:	mvi	b,007h		;; f4a9: 06 07       ..
	mvi	a,01ah		;; f4ab: 3e 1a       >.
Lf4ad:	push	h		;; f4ad: e5          .
	lxi	h,Lfd2a		;; f4ae: 21 2a fd    .*.
	bit	2,m		;; f4b1: cb 56       .V
	pop	h		;; f4b3: e1          .
	jrz	Lf497		;; f4b4: 28 e1       (.
	call	Lf4c8		;; f4b6: cd c8 f4    ...
	mov	a,b		;; f4b9: 78          x
	sta	Lf51c		;; f4ba: 32 1c f5    2..
	out	063h		;; f4bd: d3 63       .c
	lhld	Lf508		;; f4bf: 2a 08 f5    *..
	lded	Lf50a		;; f4c2: ed 5b 0a f5 .[..
	jr	Lf46c		;; f4c6: 18 a4       ..

Lf4c8:	sta	Lf51a		;; f4c8: 32 1a f5    2..
	shld	Lf50e		;; f4cb: 22 0e f5    "..
	lxi	h,00000h	;; f4ce: 21 00 00    ...
	shld	Lf50c		;; f4d1: 22 0c f5    "..
	mvi	h,040h		;; f4d4: 26 40       &@
	shld	Lf518		;; f4d6: 22 18 f5    "..
	shld	Lf513		;; f4d9: 22 13 f5    "..
	sded	Lf511		;; f4dc: ed 53 11 f5 .S..
	stx	c,+17		;; f4e0: dd 71 11    .q.
	ret			;; f4e3: c9          .

Lf4e4:	db	21h,0cch,0f2h,1,0dh,0,11h,0f1h,0f2h,21h,0f3h,0f2h,1,5,0,11h
	db	0,0f3h
Lf4f6:	db	21h,2,0f3h,1,10h,0,11h,'0',0f3h,21h,'2',0f3h,1,0dh,0
	db	11h,'W',0f3h
Lf508:	db	0,0
Lf50a:	db	0,0
Lf50c:	db	0
Lf50d:	db	0
Lf50e:	db	82h,12h
Lf510:	db	0
Lf511:	db	'O'
Lf512:	db	17h
Lf513:	db	0,'@'
Lf515:	db	7
Lf516:	db	0
Lf517:	db	7
Lf518:	db	0
Lf519:	db	'@'
Lf51a:	db	')'
Lf51b:	db	0
Lf51c:	db	0,8
Lf51e:	db	0
Lf51f:	db	0,0,0,0
Lf523:	push	d		;; f523: d5          .
	mov	e,m		;; f524: 5e          ^
	inx	h		;; f525: 23          #
	mov	d,m		;; f526: 56          V
	lda	Lf51a		;; f527: 3a 1a f5    :..
	bit	4,a		;; f52a: cb 67       .g
	lxi	h,Lfec0		;; f52c: 21 c0 fe    ...
	jrz	Lf532		;; f52f: 28 01       (.
	dad	h		;; f531: 29          )
Lf532:	dad	d		;; f532: 19          .
	pop	h		;; f533: e1          .
	rc			;; f534: d8          .
	push	d		;; f535: d5          .
	mov	e,m		;; f536: 5e          ^
	inx	h		;; f537: 23          #
	mov	d,m		;; f538: 56          V
	lxi	h,000c7h	;; f539: 21 c7 00    ...
	dsbc	d		;; f53c: ed 52       .R
	xchg			;; f53e: eb          .
	pop	h		;; f53f: e1          .
	rc			;; f540: d8          .
	sspd	Lfdf0		;; f541: ed 73 f0 fd .s..
	lxi	sp,Lfdf0	;; f545: 31 f0 fd    1..
	push	h		;; f548: e5          .
	mov	h,d		;; f549: 62          b
	mov	l,e		;; f54a: 6b          k
	dad	h		;; f54b: 29          )
	dad	h		;; f54c: 29          )
	dad	d		;; f54d: 19          .
	dad	h		;; f54e: 29          )
	dad	h		;; f54f: 29          )
	dad	h		;; f550: 29          )
	dad	h		;; f551: 29          )
	xthl			;; f552: e3          .
	lda	Lf51a		;; f553: 3a 1a f5    :..
	bit	4,a		;; f556: cb 67       .g
	jrnz	Lf578		;; f558: 20 1e        .
	lda	Lf51b		;; f55a: 3a 1b f5    :..
	ani	003h		;; f55d: e6 03       ..
	mov	d,a		;; f55f: 57          W
	mvi	a,003h		;; f560: 3e 03       >.
	ana	l		;; f562: a5          .
	mov	b,a		;; f563: 47          G
	mvi	a,003h		;; f564: 3e 03       >.
	inr	b		;; f566: 04          .
	push	b		;; f567: c5          .
Lf568:	rrc			;; f568: 0f          .
	rrc			;; f569: 0f          .
	djnz	Lf568		;; f56a: 10 fc       ..
	mov	e,a		;; f56c: 5f          _
	pop	b		;; f56d: c1          .
	mov	a,d		;; f56e: 7a          z
Lf56f:	rrc			;; f56f: 0f          .
	rrc			;; f570: 0f          .
	djnz	Lf56f		;; f571: 10 fc       ..
	mov	d,a		;; f573: 57          W
	mvi	b,002h		;; f574: 06 02       ..
	jr	Lf586		;; f576: 18 0e       ..

Lf578:	mvi	a,007h		;; f578: 3e 07       >.
	ana	l		;; f57a: a5          .
	mov	b,a		;; f57b: 47          G
	inr	b		;; f57c: 04          .
	mvi	a,001h		;; f57d: 3e 01       >.
Lf57f:	rrc			;; f57f: 0f          .
	djnz	Lf57f		;; f580: 10 fd       ..
	mov	e,a		;; f582: 5f          _
	mov	d,a		;; f583: 57          W
	mvi	b,003h		;; f584: 06 03       ..
Lf586:	xchg			;; f586: eb          .
	xthl			;; f587: e3          .
Lf588:	srlr	d		;; f588: cb 3a       .:
	rarr	e		;; f58a: cb 1b       ..
	djnz	Lf588		;; f58c: 10 fa       ..
	mvi	a,040h		;; f58e: 3e 40       >@
	add	d		;; f590: 82          .
	mov	d,a		;; f591: 57          W
	dad	d		;; f592: 19          .
	pop	d		;; f593: d1          .
	di			;; f594: f3          .
	lda	Lf51a		;; f595: 3a 1a f5    :..
	setb	2,a		;; f598: cb d7       ..
	out	062h		;; f59a: d3 62       .b
	mov	b,m		;; f59c: 46          F
	mov	a,e		;; f59d: 7b          {
	cma			;; f59e: 2f          /
	inr	c		;; f59f: 0c          .
	dcr	c		;; f5a0: 0d          .
	jrz	Lf5b7		;; f5a1: 28 14       (.
	dcr	c		;; f5a3: 0d          .
	jrz	Lf5bf		;; f5a4: 28 19       (.
	dcr	c		;; f5a6: 0d          .
	jrz	Lf5ba		;; f5a7: 28 11       (.
	ana	b		;; f5a9: a0          .
	ora	d		;; f5aa: b2          .
Lf5ab:	mov	m,a		;; f5ab: 77          w
Lf5ac:	lda	Lf51a		;; f5ac: 3a 1a f5    :..
	out	062h		;; f5af: d3 62       .b
	ei			;; f5b1: fb          .
	lspd	Lfdf0		;; f5b2: ed 7b f0 fd .{..
	ret			;; f5b6: c9          .

Lf5b7:	ana	b		;; f5b7: a0          .
	jr	Lf5ab		;; f5b8: 18 f1       ..

Lf5ba:	mov	a,b		;; f5ba: 78          x
	ana	e		;; f5bb: a3          .
	mov	b,a		;; f5bc: 47          G
	jr	Lf5ac		;; f5bd: 18 ed       ..

Lf5bf:	ana	b		;; f5bf: a0          .
	mov	c,a		;; f5c0: 4f          O
	mov	a,b		;; f5c1: 78          x
	cma			;; f5c2: 2f          /
	ana	e		;; f5c3: a3          .
	ora	c		;; f5c4: b1          .
	jr	Lf5ab		;; f5c5: 18 e4       ..

Lf5c7:	add	l		;; f5c7: 85          .
	mov	l,a		;; f5c8: 6f          o
	mov	a,h		;; f5c9: 7c          |
	aci	000h		;; f5ca: ce 00       ..
	mov	h,a		;; f5cc: 67          g
	ret			;; f5cd: c9          .

Lf5ce:	stax	d		;; f5ce: 12          .
	inx	d		;; f5cf: 13          .
	dcr	c		;; f5d0: 0d          .
	jnz	Lf5ce		;; f5d1: c2 ce f5    ...
	ret			;; f5d4: c9          .

Lf5d5:	di			;; f5d5: f3          .
	xra	a		;; f5d6: af          .
	out	038h		;; f5d7: d3 38       .8
	lxi	sp,00100h	;; f5d9: 31 00 01    1..
	im2			;; f5dc: ed 5e       .^
	mvi	a,0deh		;; f5de: 3e de       >.
	stai			;; f5e0: ed 47       .G
	lxi	d,05fdfh	;; f5e2: 11 df 5f    .._
	lxi	h,02f01h	;; f5e5: 21 01 2f    ../
	mvi	c,020h		;; f5e8: 0e 20       . 
	outp	d		;; f5ea: ed 51       .Q
	mvi	a,000h		;; f5ec: 3e 00       >.
	outp	a		;; f5ee: ed 79       .y
	mvi	a,080h		;; f5f0: 3e 80       >.
	outp	a		;; f5f2: ed 79       .y
	inr	c		;; f5f4: 0c          .
	mvi	a,0dfh		;; f5f5: 3e df       >.
	outp	a		;; f5f7: ed 79       .y
	mvi	a,078h		;; f5f9: 3e 78       >x
	outp	a		;; f5fb: ed 79       .y
	inr	c		;; f5fd: 0c          .
	inr	c		;; f5fe: 0c          .
	inr	c		;; f5ff: 0c          .
	outp	d		;; f600: ed 51       .Q
	outp	l		;; f602: ed 69       .i
	mvi	a,088h		;; f604: 3e 88       >.
	outp	a		;; f606: ed 79       .y
	inr	c		;; f608: 0c          .
	inr	c		;; f609: 0c          .
	outp	d		;; f60a: ed 51       .Q
	outp	l		;; f60c: ed 69       .i
	inr	c		;; f60e: 0c          .
	outp	e		;; f60f: ed 59       .Y
	outp	l		;; f611: ed 69       .i
	mvi	a,016h		;; f613: 3e 16       >.
	out	02bh		;; f615: d3 2b       .+
	mvi	a,008h		;; f617: 3e 08       >.
	out	028h		;; f619: d3 28       .(
	mvi	a,056h		;; f61b: 3e 56       >V
	out	02bh		;; f61d: d3 2b       .+
	mvi	a,008h		;; f61f: 3e 08       >.
	out	029h		;; f621: d3 29       .)
	mvi	a,0b6h		;; f623: 3e b6       >.
	out	02bh		;; f625: d3 2b       .+
	mvi	a,0b7h		;; f627: 3e b7       >.
	out	02ah		;; f629: d3 2a       .*
	mvi	a,003h		;; f62b: 3e 03       >.
	out	02ah		;; f62d: d3 2a       .*
	mvi	a,089h		;; f62f: 3e 89       >.
	out	003h		;; f631: d3 03       ..
	mvi	a,010h		;; f633: 3e 10       >.
	out	000h		;; f635: d3 00       ..
	mvi	a,002h		;; f637: 3e 02       >.
	out	001h		;; f639: d3 01       ..
	mvi	a,04fh		;; f63b: 3e 4f       >O
	out	02eh		;; f63d: d3 2e       ..
	mvi	a,090h		;; f63f: 3e 90       >.
	out	02eh		;; f641: d3 2e       ..
	mvi	a,04fh		;; f643: 3e 4f       >O
	out	052h		;; f645: d3 52       .R
	mvi	a,00fh		;; f647: 3e 0f       >.
	out	053h		;; f649: d3 53       .S
	mvi	a,094h		;; f64b: 3e 94       >.
	out	052h		;; f64d: d3 52       .R
	mvi	a,096h		;; f64f: 3e 96       >.
	out	053h		;; f651: d3 53       .S
	mvi	a,083h		;; f653: 3e 83       >.
	out	053h		;; f655: d3 53       .S
	mvi	b,008h		;; f657: 06 08       ..
	mvi	c,012h		;; f659: 0e 12       ..
	lxi	h,Lf8e1		;; f65b: 21 e1 f8    ...
	outir			;; f65e: ed b3       ..
	mvi	b,00bh		;; f660: 06 0b       ..
	inr	c		;; f662: 0c          .
	lxi	h,Lf8de		;; f663: 21 de f8    ...
	outir			;; f666: ed b3       ..
	lxi	d,Lfcd5		;; f668: 11 d5 fc    ...
	mvi	c,066h		;; f66b: 0e 66       .f
	xra	a		;; f66d: af          .
	call	Lf5ce		;; f66e: cd ce f5    ...
	lxi	h,04c05h	;; f671: 21 05 4c    ..L
	shld	Lfd1e		;; f674: 22 1e fd    "..
	shld	Lfd22		;; f677: 22 22 fd    "".
	mvi	a,0ffh		;; f67a: 3e ff       >.
	sta	Lfd21		;; f67c: 32 21 fd    2..
	sta	Lfd25		;; f67f: 32 25 fd    2%.
	mvi	a,011h		;; f682: 3e 11       >.
	sta	Lfd2a		;; f684: 32 2a fd    2*.
	lxi	sp,Lfd3b	;; f687: 31 3b fd    1;.
	lxi	h,Ldf68		;; f68a: 21 68 df    .h.
	push	h		;; f68d: e5          .
	push	h		;; f68e: e5          .
	push	h		;; f68f: e5          .
	push	h		;; f690: e5          .
	push	h		;; f691: e5          .
	push	h		;; f692: e5          .
	push	h		;; f693: e5          .
	push	h		;; f694: e5          .
	lxi	sp,00100h	;; f695: 31 00 01    1..
	in	02dh		;; f698: db 2d       .-
	ani	020h		;; f69a: e6 20       . 
	lxi	h,Lf8f2		;; f69c: 21 f2 f8    ...
	mvi	m,000h		;; f69f: 36 00       6.
	jrz	Lf6a5		;; f6a1: 28 02       (.
	mvi	m,005h		;; f6a3: 36 05       6.
Lf6a5:	mvi	a,0bfh		;; f6a5: 3e bf       >.
	sta	Lfd3b		;; f6a7: 32 3b fd    2;.
	in	02dh		;; f6aa: db 2d       .-
	mov	b,a		;; f6ac: 47          G
	ani	001h		;; f6ad: e6 01       ..
	jrnz	Lf6ea		;; f6af: 20 39        9
	mvi	a,0bdh		;; f6b1: 3e bd       >.
	sta	Lfd3b		;; f6b3: 32 3b fd    2;.
	mvi	a,0cfh		;; f6b6: 3e cf       >.
	out	023h		;; f6b8: d3 23       .#
	mvi	a,001h		;; f6ba: 3e 01       >.
	out	023h		;; f6bc: d3 23       .#
	mvi	l,083h		;; f6be: 2e 83       ..
	mvi	c,052h		;; f6c0: 0e 52       .R
	mov	a,b		;; f6c2: 78          x
	ani	002h		;; f6c3: e6 02       ..
	jrz	Lf6e8		;; f6c5: 28 21       (.
	exx			;; f6c7: d9          .
	lxi	h,Leaf5		;; f6c8: 21 f5 ea    ...
	shld	Le922		;; f6cb: 22 22 e9    "".
	shld	Le932		;; f6ce: 22 32 e9    "2.
	exaf			;; f6d1: 08          .
	in	001h		;; f6d2: db 01       ..
	ani	0fdh		;; f6d4: e6 fd       ..
	out	001h		;; f6d6: d3 01       ..
	lxi	b,00800h	;; f6d8: 01 00 08    ...
Lf6db:	dcr	c		;; f6db: 0d          .
	jrnz	Lf6db		;; f6dc: 20 fd        .
	djnz	Lf6db		;; f6de: 10 fb       ..
	ori	002h		;; f6e0: f6 02       ..
	out	001h		;; f6e2: d3 01       ..
	exaf			;; f6e4: 08          .
	exx			;; f6e5: d9          .
	mvi	c,02eh		;; f6e6: 0e 2e       ..
Lf6e8:	outp	l		;; f6e8: ed 69       .i
Lf6ea:	mov	a,b		;; f6ea: 78          x
	ani	080h		;; f6eb: e6 80       ..
	lxi	h,Le82b		;; f6ed: 21 2b e8    .+.
	jrz	Lf6fa		;; f6f0: 28 08       (.
	mvi	a,035h		;; f6f2: 3e 35       >5
	sta	Lf783		;; f6f4: 32 83 f7    2..
	lxi	h,Le8cf		;; f6f7: 21 cf e8    ...
Lf6fa:	shld	Le77a		;; f6fa: 22 7a e7    "z.
	shld	Le78b		;; f6fd: 22 8b e7    "..
	mov	a,b		;; f700: 78          x
	ani	040h		;; f701: e6 40       .@
	lxi	h,Le82b		;; f703: 21 2b e8    .+.
	jrz	Lf710		;; f706: 28 08       (.
	mvi	a,035h		;; f708: 3e 35       >5
	sta	Lf79b		;; f70a: 32 9b f7    2..
	lxi	h,Le8cf		;; f70d: 21 cf e8    ...
Lf710:	shld	Le79c		;; f710: 22 9c e7    "..
	shld	Le7ad		;; f713: 22 ad e7    "..
	mov	a,b		;; f716: 78          x
	ani	080h		;; f717: e6 80       ..
	jz	Lf869		;; f719: ca 69 f8    .i.
	call	Le03a		;; f71c: cd 3a e0    .:.
Lf71f:	ei			;; f71f: fb          .
	lda	Lfd3b		;; f720: 3a 3b fd    :;.
	sta	00003h		;; f723: 32 03 00    2..
	xra	a		;; f726: af          .
	sta	00004h		;; f727: 32 04 00    2..
	call	Le667		;; f72a: cd 67 e6    .g.
	db	18h,0dh,0ah,'Tpd-80 DOS vers. 2.71 A  ** 57k CP/M 2.2 compat'
	db	'ible **',0dh,0ah,7,'$'
	call	Le667		;; f76a: cd 67 e6    .g.
	db	0dh,0ah,'Disk drives A & B : '
Lf783:	db	'8"',0dh,0ah,'Disk drives C & D : '
Lf79b:	db	'8"',0dh,0ah,'$'
	lda	Lf8f2		;; f7a0: 3a f2 f8    :..
	ora	a		;; f7a3: b7          .
	mvi	a,004h		;; f7a4: 3e 04       >.
	jz	Lf817		;; f7a6: ca 17 f8    ...
	call	Le667		;; f7a9: cd 67 e6    .g.
	db	'Virtual disk E: in configuration',0dh,0ah,'192 kbytes stora'
	db	'ge capacity',0dh,0ah,'Format Vdisk ? (y/*): $'
	call	Le958		;; f802: cd 58 e9    .X.
	push	psw		;; f805: f5          .
	mov	c,a		;; f806: 4f          O
	call	Le969		;; f807: cd 69 e9    .i.
	pop	psw		;; f80a: f1          .
	ani	0dfh		;; f80b: e6 df       ..
	cpi	059h		;; f80d: fe 59       .Y
	cz	Lf86f		;; f80f: cc 6f f8    .o.
	cnz	Lf88f		;; f812: c4 8f f8    ...
	mvi	a,005h		;; f815: 3e 05       >.
Lf817:	sta	Ldf6b		;; f817: 32 6b df    2k.
	in	02dh		;; f81a: db 2d       .-
	mov	b,a		;; f81c: 47          G
	ani	001h		;; f81d: e6 01       ..
	jnz	Ldec2		;; f81f: c2 c2 de    ...
	call	Le667		;; f822: cd 67 e6    .g.
	db	0dh,0ah,'Console input : $'
	mov	a,b		;; f838: 78          x
	ani	002h		;; f839: e6 02       ..
	jz	Lf85a		;; f83b: ca 5a f8    .Z.
	call	Le667		;; f83e: cd 67 e6    .g.
	db	'serial$'
Lf848:	call	Le667		;; f848: cd 67 e6    .g.
	db	' keyboard',0dh,0ah,'$'
	jmp	Ldec2		;; f857: c3 c2 de    ...

Lf85a:	call	Le667		;; f85a: cd 67 e6    .g.
	db	'parallel$'
	jmp	Lf848		;; f866: c3 48 f8    .H.

Lf869:	call	Le006		;; f869: cd 06 e0    ...
	jmp	Lf71f		;; f86c: c3 1f f7    ...

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

Lf8ae:	in	000h		;; f8ae: db 00       ..
	ani	0f8h		;; f8b0: e6 f8       ..
	ora	e		;; f8b2: b3          .
	out	000h		;; f8b3: d3 00       ..
	lxi	h,04000h	;; f8b5: 21 00 40    ..@
	lxi	b,07fffh	;; f8b8: 01 ff 7f    ...
	push	h		;; f8bb: e5          .
	pop	d		;; f8bc: d1          .
	mvi	m,0e5h		;; f8bd: 36 e5       6.
	inx	h		;; f8bf: 23          #
	xchg			;; f8c0: eb          .
	ldir			;; f8c1: ed b0       ..
Lf8c3:	in	000h		;; f8c3: db 00       ..
	ani	0f8h		;; f8c5: e6 f8       ..
	out	000h		;; f8c7: d3 00       ..
	ret			;; f8c9: c9          .

Lf8ca:	in	000h		;; f8ca: db 00       ..
	ani	0f8h		;; f8cc: e6 f8       ..
	ora	e		;; f8ce: b3          .
	out	000h		;; f8cf: d3 00       ..
	lxi	h,03fffh	;; f8d1: 21 ff 3f    ..?
Lf8d4:	inx	h		;; f8d4: 23          #
	mov	a,h		;; f8d5: 7c          |
	cpi	0c0h		;; f8d6: fe c0       ..
	jrz	Lf8c3		;; f8d8: 28 e9       (.
	mov	a,m		;; f8da: 7e          ~
	mov	m,a		;; f8db: 77          w
	jr	Lf8d4		;; f8dc: 18 f6       ..

Lf8de:	db	18h,12h,'p'
Lf8e1:	db	14h,'L',15h,0eah,3,0c1h,1,15h
Lf8e9:	db	0bh,'AUTOEXEC'
Lf8f2:	db	0,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h
	db	0e5h,0e5h
	ds	213
Lf9d5:	ds	0
	ds	128
Lfa55:	ds	0
	ds	64
Lfa95:	ds	0
	ds	64
Lfad5:	ds	0
	ds	64
Lfb15:	ds	0
	ds	64
Lfb55:	ds	0
	ds	64
Lfb95:	ds	0
	ds	64
Lfbd5:	ds	0
	ds	64
Lfc15:	ds	0
	ds	64
Lfc55:	ds	0
	ds	64
Lfc95:	ds	0
	ds	64
Lfcd5:	ds	0
	ds	1
Lfcd6:	ds	0
	ds	1
Lfcd7:	ds	0
	ds	1
Lfcd8:	ds	0
	ds	1
Lfcd9:	ds	0
	ds	2
Lfcdb:	ds	0
	ds	1
Lfcdc:	ds	0
	ds	2
Lfcde:	ds	0
	ds	2
Lfce0:	ds	0
	ds	1
Lfce1:	ds	0
	ds	1
Lfce2:	ds	0
	ds	1
Lfce3:	ds	0
	ds	1
Lfce4:	ds	0
	ds	1
Lfce5:	ds	0
	ds	1
Lfce6:	ds	0
	ds	1
Lfce7:	ds	0
	ds	2
Lfce9:	ds	0
	ds	1
Lfcea:	ds	0
	ds	1
Lfceb:	ds	0
	ds	2
Lfced:	ds	0
	ds	1
Lfcee:	ds	0
	ds	1
Lfcef:	ds	0
	ds	1
Lfcf0:	ds	0
	ds	1
Lfcf1:	ds	0
	ds	1
Lfcf2:	ds	0
	ds	1
Lfcf3:	ds	0
	ds	1
Lfcf4:	ds	0
	ds	3
Lfcf7:	ds	0
	ds	1
Lfcf8:	ds	0
	ds	4
Lfcfc:	ds	0
	ds	1
Lfcfd:	ds	0
	ds	1
Lfcfe:	ds	0
	ds	1
Lfcff:	ds	0
	ds	1
Lfd00:	ds	0
	ds	1
Lfd01:	ds	0
	ds	1
Lfd02:	ds	0
	ds	4
Lfd06:	ds	0
	ds	1
Lfd07:	ds	0
	ds	1
Lfd08:	ds	0
	ds	1
Lfd09:	ds	0
	ds	1
Lfd0a:	ds	0
	ds	1
Lfd0b:	ds	0
	ds	1
Lfd0c:	ds	0
	ds	1
Lfd0d:	ds	0
	ds	4
Lfd11:	ds	0
	ds	1
Lfd12:	ds	0
	ds	1
Lfd13:	ds	0
	ds	1
Lfd14:	ds	0
	ds	2
Lfd16:	ds	0
	ds	2
Lfd18:	ds	0
	ds	1
Lfd19:	ds	0
	ds	2
Lfd1b:	ds	0
	ds	2
Lfd1d:	ds	0
	ds	1
Lfd1e:	ds	0
	ds	3
Lfd21:	ds	0
	ds	1
Lfd22:	ds	0
	ds	3
Lfd25:	ds	0
	ds	1
Lfd26:	ds	0
	ds	1
Lfd27:	ds	0
	ds	1
Lfd28:	ds	0
	ds	1
Lfd29:	ds	0
	ds	1
Lfd2a:	ds	0
	ds	17
Lfd3b:	ds	0
	ds	51
Lfd6e:	ds	0
	ds	2
Lfd70:	ds	0
	ds	128
Lfdf0:	ds	0
	ds	2
Lfdf2:	ds	0
	ds	128
Lfe72:	ds	0
	ds	78
Lfec0:	ds	0
	end
