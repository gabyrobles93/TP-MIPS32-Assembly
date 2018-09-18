	.file	1 "decoder.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	decoder_create
	.ent	decoder_create
decoder_create:
	.frame	$fp,24,$ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$gp,16($sp)
	move	$fp,$sp
	sw	$a0,24($fp)
	sw	$a1,28($fp)
	sw	$a2,32($fp)
	lw	$v0,24($fp)
	bne	$v0,$zero,$L18
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,8($fp)
	b	$L17
$L18:
	lw	$v0,28($fp)
	beq	$v0,$zero,$L19
	lw	$v1,24($fp)
	lw	$v0,28($fp)
	sw	$v0,0($v1)
	b	$L20
$L19:
	lw	$v1,24($fp)
	la	$v0,__sF
	sw	$v0,0($v1)
$L20:
	lw	$v0,32($fp)
	beq	$v0,$zero,$L21
	lw	$v1,24($fp)
	lw	$v0,32($fp)
	sw	$v0,4($v1)
	b	$L22
$L21:
	lw	$v1,24($fp)
	la	$v0,__sF+88
	sw	$v0,4($v1)
$L22:
	sw	$zero,8($fp)
$L17:
	lw	$v0,8($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$ra
	.end	decoder_create
	.size	decoder_create, .-decoder_create
	.rdata
	.align	2
$LC0:
	.ascii	"Lectura inv\303\241lida en el archivo de entrada.\n\000"
	.align	2
$LC1:
	.ascii	"Error en la decodificaci\303\263n: se dect\303\263 un ca"
	.ascii	"racter inv\303\241lido.\n\000"
	.text
	.align	2
	.globl	decoder_start
	.ent	decoder_start
decoder_start:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	lw	$v0,56($fp)
	bne	$v0,$zero,$L24
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,36($fp)
	b	$L23
$L24:
	lw	$a0,56($fp)
	addu	$a1,$fp,24
	la	$t9,read_bytes
	jal	$ra,$t9
	sw	$v0,32($fp)
$L25:
	lw	$v0,32($fp)
	bgtz	$v0,$L27
	b	$L26
$L27:
	lw	$v0,32($fp)
	slt	$v0,$v0,4
	beq	$v0,$zero,$L28
	la	$a0,__sF+176
	la	$a1,$LC0
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,36($fp)
	b	$L23
$L28:
	lw	$a0,56($fp)
	addu	$a1,$fp,24
	la	$t9,decode_4bytes
	jal	$ra,$t9
	bgez	$v0,$L29
	la	$a0,__sF+176
	la	$a1,$LC1
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,36($fp)
	b	$L23
$L29:
	lw	$a0,56($fp)
	addu	$a1,$fp,24
	la	$t9,read_bytes
	jal	$ra,$t9
	sw	$v0,32($fp)
	b	$L25
$L26:
	sw	$zero,36($fp)
$L23:
	lw	$v0,36($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	decoder_start
	.size	decoder_start, .-decoder_start
	.align	2
	.ent	decode_4bytes
decode_4bytes:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	lw	$v0,56($fp)
	beq	$v0,$zero,$L32
	lw	$v0,60($fp)
	bne	$v0,$zero,$L31
$L32:
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,32($fp)
	b	$L30
$L31:
	lw	$v0,60($fp)
	lbu	$v1,0($v0)
	li	$v0,61			# 0x3d
	beq	$v1,$v0,$L33
	lw	$v0,60($fp)
	lbu	$v0,0($v0)
	move	$a0,$v0
	la	$t9,decode_value
	jal	$ra,$t9
	sb	$v0,36($fp)
	b	$L34
$L33:
	sb	$zero,36($fp)
$L34:
	lbu	$v0,36($fp)
	sb	$v0,24($fp)
	lw	$v0,60($fp)
	addu	$v0,$v0,1
	lbu	$v1,0($v0)
	li	$v0,61			# 0x3d
	beq	$v1,$v0,$L35
	lw	$v0,60($fp)
	addu	$v0,$v0,1
	lbu	$v0,0($v0)
	move	$a0,$v0
	la	$t9,decode_value
	jal	$ra,$t9
	sb	$v0,37($fp)
	b	$L36
$L35:
	sb	$zero,37($fp)
$L36:
	lbu	$v0,37($fp)
	sb	$v0,25($fp)
	lw	$v0,60($fp)
	addu	$v0,$v0,2
	lbu	$v1,0($v0)
	li	$v0,61			# 0x3d
	beq	$v1,$v0,$L37
	lw	$v0,60($fp)
	addu	$v0,$v0,2
	lbu	$v0,0($v0)
	move	$a0,$v0
	la	$t9,decode_value
	jal	$ra,$t9
	sb	$v0,38($fp)
	b	$L38
$L37:
	sb	$zero,38($fp)
$L38:
	lbu	$v0,38($fp)
	sb	$v0,26($fp)
	lw	$v0,60($fp)
	addu	$v0,$v0,3
	lbu	$v1,0($v0)
	li	$v0,61			# 0x3d
	beq	$v1,$v0,$L39
	lw	$v0,60($fp)
	addu	$v0,$v0,3
	lbu	$v0,0($v0)
	move	$a0,$v0
	la	$t9,decode_value
	jal	$ra,$t9
	sb	$v0,39($fp)
	b	$L40
$L39:
	sb	$zero,39($fp)
$L40:
	lbu	$v0,39($fp)
	sb	$v0,27($fp)
	lbu	$v1,24($fp)
	li	$v0,255			# 0xff
	beq	$v1,$v0,$L42
	lbu	$v1,25($fp)
	li	$v0,255			# 0xff
	beq	$v1,$v0,$L42
	lbu	$v1,26($fp)
	li	$v0,255			# 0xff
	beq	$v1,$v0,$L42
	lbu	$v1,27($fp)
	li	$v0,255			# 0xff
	beq	$v1,$v0,$L42
	b	$L41
$L42:
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,32($fp)
	b	$L30
$L41:
	lbu	$v0,24($fp)
	sll	$v1,$v0,2
	lbu	$v0,25($fp)
	srl	$v0,$v0,4
	or	$v0,$v1,$v0
	sb	$v0,28($fp)
	lbu	$v0,25($fp)
	sll	$v1,$v0,4
	lbu	$v0,26($fp)
	srl	$v0,$v0,2
	or	$v0,$v1,$v0
	sb	$v0,29($fp)
	lbu	$v0,26($fp)
	sll	$v0,$v0,6
	move	$v1,$v0
	lbu	$v0,27($fp)
	or	$v0,$v1,$v0
	sb	$v0,30($fp)
	lbu	$v0,28($fp)
	beq	$v0,$zero,$L43
	lbu	$v0,28($fp)
	lw	$v1,56($fp)
	move	$a0,$v0
	lw	$a1,4($v1)
	la	$t9,__sputc
	jal	$ra,$t9
$L43:
	lbu	$v0,29($fp)
	beq	$v0,$zero,$L44
	lbu	$v0,29($fp)
	lw	$v1,56($fp)
	move	$a0,$v0
	lw	$a1,4($v1)
	la	$t9,__sputc
	jal	$ra,$t9
$L44:
	lbu	$v0,30($fp)
	beq	$v0,$zero,$L45
	lbu	$v0,30($fp)
	lw	$v1,56($fp)
	move	$a0,$v0
	lw	$a1,4($v1)
	la	$t9,__sputc
	jal	$ra,$t9
$L45:
	sw	$zero,32($fp)
$L30:
	lw	$v0,32($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	decode_4bytes
	.size	decode_4bytes, .-decode_4bytes
	.align	2
	.ent	decode_value
decode_value:
	.frame	$fp,24,$ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$gp,16($sp)
	move	$fp,$sp
	move	$v0,$a0
	sb	$v0,8($fp)
	lbu	$v0,8($fp)
	sltu	$v0,$v0,65
	bne	$v0,$zero,$L47
	lbu	$v0,8($fp)
	sltu	$v0,$v0,91
	beq	$v0,$zero,$L47
	lbu	$v0,8($fp)
	addu	$v0,$v0,-65
	sb	$v0,8($fp)
	b	$L48
$L47:
	lbu	$v0,8($fp)
	sltu	$v0,$v0,97
	bne	$v0,$zero,$L49
	lbu	$v0,8($fp)
	sltu	$v0,$v0,123
	beq	$v0,$zero,$L49
	lbu	$v0,8($fp)
	addu	$v0,$v0,-71
	sb	$v0,8($fp)
	b	$L48
$L49:
	lbu	$v0,8($fp)
	sltu	$v0,$v0,48
	bne	$v0,$zero,$L51
	lbu	$v0,8($fp)
	sltu	$v0,$v0,58
	beq	$v0,$zero,$L51
	lbu	$v0,8($fp)
	addu	$v0,$v0,4
	sb	$v0,8($fp)
	b	$L48
$L51:
	lbu	$v1,8($fp)
	li	$v0,43			# 0x2b
	bne	$v1,$v0,$L53
	li	$v0,62			# 0x3e
	sb	$v0,8($fp)
	b	$L48
$L53:
	lbu	$v1,8($fp)
	li	$v0,47			# 0x2f
	bne	$v1,$v0,$L55
	li	$v0,63			# 0x3f
	sb	$v0,8($fp)
	b	$L48
$L55:
	li	$v0,255			# 0xff
	sw	$v0,12($fp)
	b	$L46
$L48:
	lbu	$v0,8($fp)
	sw	$v0,12($fp)
$L46:
	lw	$v0,12($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$ra
	.end	decode_value
	.size	decode_value, .-decode_value
	.align	2
	.globl	decoder_destroy
	.ent	decoder_destroy
decoder_destroy:
	.frame	$fp,24,$ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$gp,16($sp)
	move	$fp,$sp
	sw	$a0,24($fp)
	lw	$v0,24($fp)
	bne	$v0,$zero,$L58
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,8($fp)
	b	$L57
$L58:
	lw	$v0,24($fp)
	sw	$zero,0($v0)
	lw	$v0,24($fp)
	sw	$zero,4($v0)
	sw	$zero,8($fp)
$L57:
	lw	$v0,8($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$ra
	.end	decoder_destroy
	.size	decoder_destroy, .-decoder_destroy
	.align	2
	.ent	read_bytes
read_bytes:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	sw	$zero,24($fp)
$L60:
	lw	$v0,24($fp)
	slt	$v0,$v0,4
	bne	$v0,$zero,$L62
	b	$L61
$L62:
	addu	$v0,$fp,28
	lw	$v1,56($fp)
	move	$a0,$v0
	li	$a1,1			# 0x1
	li	$a2,1			# 0x1
	lw	$a3,0($v1)
	la	$t9,fread
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	beq	$v0,$zero,$L63
	lbu	$v1,28($fp)
	lw	$v0,_ctype_
	addu	$v0,$v1,$v0
	addu	$v0,$v0,1
	lbu	$v0,0($v0)
	srl	$v0,$v0,3
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L64
	b	$L60
$L64:
	lw	$v1,60($fp)
	lw	$v0,24($fp)
	addu	$v1,$v1,$v0
	lbu	$v0,28($fp)
	sb	$v0,0($v1)
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	b	$L60
$L63:
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,36($fp)
	b	$L59
$L61:
	lw	$v0,24($fp)
	sw	$v0,36($fp)
$L59:
	lw	$v0,36($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	read_bytes
	.size	read_bytes, .-read_bytes
	.align	2
	.ent	__sputc
__sputc:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$v1,52($fp)
	lw	$v0,52($fp)
	lw	$v0,8($v0)
	addu	$v0,$v0,-1
	sw	$v0,8($v1)
	bgez	$v0,$L15
	lw	$v0,52($fp)
	lw	$v1,52($fp)
	lw	$a0,8($v0)
	lw	$v0,24($v1)
	slt	$v0,$a0,$v0
	bne	$v0,$zero,$L14
	lb	$v1,48($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L15
	b	$L14
$L15:
	lw	$a1,52($fp)
	lw	$v1,0($a1)
	lbu	$a0,48($fp)
	move	$v0,$v1
	sb	$a0,0($v0)
	andi	$v0,$a0,0x00ff
	addu	$v1,$v1,1
	sw	$v1,0($a1)
	sw	$v0,24($fp)
	b	$L13
$L14:
	lw	$a0,48($fp)
	lw	$a1,52($fp)
	la	$t9,__swbuf
	jal	$ra,$t9
	sw	$v0,24($fp)
$L13:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	__sputc
	.size	__sputc, .-__sputc
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
