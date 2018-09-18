	.file	1 "encoder.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	base64
	.data
	.align	2
	.type	base64, @object
	.size	base64, 64
base64:
	.byte	65
	.byte	66
	.byte	67
	.byte	68
	.byte	69
	.byte	70
	.byte	71
	.byte	72
	.byte	73
	.byte	74
	.byte	75
	.byte	76
	.byte	77
	.byte	78
	.byte	79
	.byte	80
	.byte	81
	.byte	82
	.byte	83
	.byte	84
	.byte	85
	.byte	86
	.byte	87
	.byte	88
	.byte	89
	.byte	90
	.byte	97
	.byte	98
	.byte	99
	.byte	100
	.byte	101
	.byte	102
	.byte	103
	.byte	104
	.byte	105
	.byte	106
	.byte	107
	.byte	108
	.byte	109
	.byte	110
	.byte	111
	.byte	112
	.byte	113
	.byte	114
	.byte	115
	.byte	116
	.byte	117
	.byte	118
	.byte	119
	.byte	120
	.byte	121
	.byte	122
	.byte	48
	.byte	49
	.byte	50
	.byte	51
	.byte	52
	.byte	53
	.byte	54
	.byte	55
	.byte	56
	.byte	57
	.byte	43
	.byte	47
	.text
	.align	2
	.globl	B64_encoder_create
	.ent	B64_encoder_create
B64_encoder_create:
	.frame	$fp,16,$ra		# vars= 0, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,16
	.cprestore 0
	sw	$fp,12($sp)
	sw	$gp,8($sp)
	move	$fp,$sp
	sw	$a0,16($fp)
	sw	$a1,20($fp)
	sw	$a2,24($fp)
	lw	$v0,16($fp)
	sw	$zero,12($v0)
	lw	$v0,20($fp)
	beq	$v0,$zero,$L18
	lw	$v1,16($fp)
	lw	$v0,20($fp)
	sw	$v0,0($v1)
	b	$L19
$L18:
	lw	$v1,16($fp)
	la	$v0,__sF
	sw	$v0,0($v1)
$L19:
	lw	$v0,24($fp)
	beq	$v0,$zero,$L20
	lw	$v1,16($fp)
	lw	$v0,24($fp)
	sw	$v0,4($v1)
	b	$L21
$L20:
	lw	$v1,16($fp)
	la	$v0,__sF+88
	sw	$v0,4($v1)
$L21:
	move	$v0,$zero
	move	$sp,$fp
	lw	$fp,12($sp)
	addu	$sp,$sp,16
	j	$ra
	.end	B64_encoder_create
	.size	B64_encoder_create, .-B64_encoder_create
	.align	2
	.globl	B64_encoder_start
	.ent	B64_encoder_start
B64_encoder_start:
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
	sb	$zero,24($fp)
	li	$v0,61			# 0x3d
	sb	$v0,28($fp)
	lw	$v0,56($fp)
	addu	$v0,$v0,8
	lw	$v1,56($fp)
	move	$a0,$v0
	li	$a1,1			# 0x1
	li	$a2,3			# 0x3
	lw	$a3,0($v1)
	la	$t9,fread
	jal	$ra,$t9
	sw	$v0,32($fp)
$L23:
	lw	$v0,32($fp)
	bne	$v0,$zero,$L25
	b	$L24
$L25:
	lw	$v1,32($fp)
	li	$v0,3			# 0x3
	bne	$v1,$v0,$L26
	lw	$v0,56($fp)
	lbu	$v0,8($v0)
	sb	$v0,25($fp)
	lw	$v0,56($fp)
	lbu	$v0,9($v0)
	sb	$v0,26($fp)
	lw	$v0,56($fp)
	lbu	$v0,10($v0)
	sb	$v0,27($fp)
	addu	$v0,$fp,25
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v0,$v0,2
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,26
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v1,$v0,4
	lbu	$v0,25($fp)
	andi	$v0,$v0,0x3
	sll	$v0,$v0,4
	or	$v0,$v1,$v0
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,27
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v1,$v0,6
	lbu	$v0,26($fp)
	andi	$v0,$v0,0xf
	sll	$v0,$v0,2
	or	$v0,$v1,$v0
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,27
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	andi	$v0,$v0,0x3f
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
$L26:
	lw	$v1,32($fp)
	li	$v0,2			# 0x2
	bne	$v1,$v0,$L27
	lw	$v0,56($fp)
	lbu	$v0,8($v0)
	sb	$v0,25($fp)
	lw	$v0,56($fp)
	lbu	$v0,9($v0)
	sb	$v0,26($fp)
	sb	$zero,27($fp)
	addu	$v0,$fp,25
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v0,$v0,2
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,26
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v1,$v0,4
	lbu	$v0,25($fp)
	andi	$v0,$v0,0x3
	sll	$v0,$v0,4
	or	$v0,$v1,$v0
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,27
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v1,$v0,6
	lbu	$v0,26($fp)
	andi	$v0,$v0,0xf
	sll	$v0,$v0,2
	or	$v0,$v1,$v0
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,28
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
$L27:
	lw	$v1,32($fp)
	li	$v0,1			# 0x1
	bne	$v1,$v0,$L28
	lw	$v0,56($fp)
	lbu	$v0,8($v0)
	sb	$v0,25($fp)
	sb	$zero,26($fp)
	sb	$zero,27($fp)
	addu	$v0,$fp,25
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v0,$v0,2
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,26
	addu	$a0,$fp,24
	move	$a1,$v0
	li	$a2,1			# 0x1
	la	$t9,memcpy
	jal	$ra,$t9
	lbu	$v0,24($fp)
	srl	$v1,$v0,4
	lbu	$v0,25($fp)
	andi	$v0,$v0,0x3
	sll	$v0,$v0,4
	or	$v0,$v1,$v0
	sb	$v0,24($fp)
	lbu	$v1,24($fp)
	la	$v0,base64
	addu	$v0,$v1,$v0
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,28
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
	addu	$v0,$fp,28
	lw	$a0,56($fp)
	move	$a1,$v0
	la	$t9,_B64_encoder_write
	jal	$ra,$t9
$L28:
	lw	$v0,56($fp)
	addu	$v0,$v0,8
	lw	$v1,56($fp)
	move	$a0,$v0
	li	$a1,1			# 0x1
	li	$a2,3			# 0x3
	lw	$a3,0($v1)
	la	$t9,fread
	jal	$ra,$t9
	sw	$v0,32($fp)
	b	$L23
$L24:
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	B64_encoder_start
	.size	B64_encoder_start, .-B64_encoder_start
	.align	2
	.globl	_B64_encoder_write
	.ent	_B64_encoder_write
_B64_encoder_write:
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
	lw	$v0,48($fp)
	lw	$v1,12($v0)
	li	$v0,76			# 0x4c
	bne	$v1,$v0,$L30
	li	$v0,10			# 0xa
	sb	$v0,24($fp)
	lw	$v0,48($fp)
	sw	$zero,12($v0)
	lw	$v0,48($fp)
	addu	$a0,$fp,24
	li	$a1,1			# 0x1
	li	$a2,1			# 0x1
	lw	$a3,4($v0)
	la	$t9,fwrite
	jal	$ra,$t9
$L30:
	lw	$v0,48($fp)
	lw	$a0,52($fp)
	li	$a1,1			# 0x1
	li	$a2,1			# 0x1
	lw	$a3,4($v0)
	la	$t9,fwrite
	jal	$ra,$t9
	lw	$v1,48($fp)
	lw	$v0,48($fp)
	lw	$v0,12($v0)
	addu	$v0,$v0,1
	sw	$v0,12($v1)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	_B64_encoder_write
	.size	_B64_encoder_write, .-_B64_encoder_write
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
