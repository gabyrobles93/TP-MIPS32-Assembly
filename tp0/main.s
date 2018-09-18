	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"Opening input file %s\n\000"
	.align	2
$LC1:
	.ascii	"rb\000"
	.text
	.align	2
	.globl	open_infile
	.ent	open_infile
open_infile:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	la	$a0,__sF+176
	la	$a1,$LC0
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	lw	$a0,40($fp)
	la	$a1,$LC1
	la	$t9,fopen
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	open_infile
	.size	open_infile, .-open_infile
	.rdata
	.align	2
$LC2:
	.ascii	"Opening output file %s\n\000"
	.align	2
$LC3:
	.ascii	"wt\000"
	.text
	.align	2
	.globl	open_outfile
	.ent	open_outfile
open_outfile:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	la	$a0,__sF+176
	la	$a1,$LC2
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	lw	$a0,40($fp)
	la	$a1,$LC3
	la	$t9,fopen
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	open_outfile
	.size	open_outfile, .-open_outfile
	.rdata
	.align	2
$LC4:
	.ascii	"version\000"
	.align	2
$LC5:
	.ascii	"help\000"
	.align	2
$LC6:
	.ascii	"input\000"
	.align	2
$LC7:
	.ascii	"output\000"
	.align	2
$LC8:
	.ascii	"action\000"
	.data
	.align	2
	.type	long_options.0, @object
	.size	long_options.0, 96
long_options.0:
	.word	$LC4
	.word	0
	.word	0
	.word	86
	.word	$LC5
	.word	0
	.word	0
	.word	104
	.word	$LC6
	.word	1
	.word	0
	.word	105
	.word	$LC7
	.word	1
	.word	0
	.word	111
	.word	$LC8
	.word	2
	.word	0
	.word	97
	.word	0
	.word	0
	.word	0
	.word	0
	.rdata
	.align	2
$LC9:
	.ascii	"Vhi:o:a:\000"
	.align	2
$LC10:
	.ascii	"-\000"
	.align	2
$LC11:
	.ascii	"Can not open input file '%s'\n\000"
	.align	2
$LC12:
	.ascii	"Can not open output file '%s'\n\000"
	.align	2
$LC13:
	.ascii	"decode\000"
	.align	2
$LC14:
	.ascii	"encode\000"
	.align	2
$LC15:
	.ascii	"Unknown action '%s'\n\000"
	.align	2
$LC16:
	.ascii	"Execute tp0 -h for help\n\000"
	.align	2
$LC17:
	.ascii	"Unknown option '%c'\n\000"
	.align	2
$LC18:
	.ascii	"Encode mode\n\000"
	.align	2
$LC19:
	.ascii	"Decode mode\n\000"
	.align	2
$LC20:
	.ascii	"Fail creating decoder\n\000"
	.align	2
$LC21:
	.ascii	"\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,104,$ra		# vars= 56, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,104
	.cprestore 24
	sw	$ra,96($sp)
	sw	$fp,92($sp)
	sw	$gp,88($sp)
	move	$fp,$sp
	sw	$a0,104($fp)
	sw	$a1,108($fp)
	sw	$zero,32($fp)
	sw	$zero,36($fp)
	sw	$zero,40($fp)
	sw	$zero,48($fp)
$L20:
	addu	$v0,$fp,48
	sw	$v0,16($sp)
	lw	$a0,104($fp)
	lw	$a1,108($fp)
	la	$a2,$LC9
	la	$a3,long_options.0
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,44($fp)
	lw	$v1,44($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L22
	b	$L21
$L22:
	lw	$v0,44($fp)
	addu	$v0,$v0,-86
	sw	$v0,84($fp)
	lw	$v1,84($fp)
	sltu	$v0,$v1,26
	beq	$v0,$zero,$L36
	lw	$v0,84($fp)
	sll	$v1,$v0,2
	la	$v0,$L37
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L37:
	.gpword	$L24
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L32
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L25
	.gpword	$L26
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L36
	.gpword	$L29
	.text
$L24:
	la	$t9,version
	jal	$ra,$t9
	sw	$zero,80($fp)
	b	$L19
$L25:
	la	$t9,help
	jal	$ra,$t9
	sw	$zero,80($fp)
	b	$L19
$L26:
	lw	$a0,optarg
	la	$a1,$LC10
	la	$t9,strcmp
	jal	$ra,$t9
	beq	$v0,$zero,$L20
	lw	$a0,optarg
	la	$t9,open_infile
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	bne	$v0,$zero,$L20
	la	$a0,__sF+176
	la	$a1,$LC11
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,80($fp)
	b	$L19
$L29:
	lw	$a0,optarg
	la	$a1,$LC10
	la	$t9,strcmp
	jal	$ra,$t9
	beq	$v0,$zero,$L20
	lw	$a0,optarg
	la	$t9,open_outfile
	jal	$ra,$t9
	sw	$v0,36($fp)
	lw	$v0,36($fp)
	bne	$v0,$zero,$L20
	la	$a0,__sF+176
	la	$a1,$LC12
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v1,1			# 0x1
	sw	$v1,80($fp)
	b	$L19
$L32:
	lw	$v0,optarg
	beq	$v0,$zero,$L36
	lw	$a0,optarg
	la	$a1,$LC13
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L34
	li	$v0,1			# 0x1
	sw	$v0,40($fp)
	b	$L20
$L34:
	lw	$a0,optarg
	la	$a1,$LC14
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L35
	sw	$zero,40($fp)
	b	$L20
$L35:
	la	$a0,__sF+176
	la	$a1,$LC15
	lw	$a2,optarg
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC16
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,80($fp)
	b	$L19
$L36:
	la	$a0,__sF+176
	la	$a1,$LC17
	lw	$a2,44($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC16
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v1,1			# 0x1
	sw	$v1,80($fp)
	b	$L19
$L21:
	lw	$v0,40($fp)
	bne	$v0,$zero,$L38
	la	$a0,__sF+176
	la	$a1,$LC18
	la	$t9,fprintf
	jal	$ra,$t9
	addu	$v0,$fp,56
	move	$a0,$v0
	lw	$a1,32($fp)
	lw	$a2,36($fp)
	la	$t9,B64_encoder_create
	jal	$ra,$t9
	addu	$v0,$fp,56
	move	$a0,$v0
	la	$t9,B64_encoder_start
	jal	$ra,$t9
	lw	$v0,32($fp)
	beq	$v0,$zero,$L39
	lw	$a0,32($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L39:
	lw	$v0,36($fp)
	beq	$v0,$zero,$L38
	lw	$a0,36($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L38:
	lw	$v1,40($fp)
	li	$v0,1			# 0x1
	bne	$v1,$v0,$L41
	la	$a0,__sF+176
	la	$a1,$LC19
	la	$t9,fprintf
	jal	$ra,$t9
	addu	$v0,$fp,72
	move	$a0,$v0
	lw	$a1,32($fp)
	lw	$a2,36($fp)
	la	$t9,decoder_create
	jal	$ra,$t9
	beq	$v0,$zero,$L42
	la	$a0,__sF+176
	la	$a1,$LC20
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,80($fp)
	b	$L19
$L42:
	addu	$v0,$fp,72
	move	$a0,$v0
	la	$t9,decoder_start
	jal	$ra,$t9
	beq	$v0,$zero,$L43
	li	$v1,1			# 0x1
	sw	$v1,80($fp)
	b	$L19
$L43:
	lw	$v0,32($fp)
	beq	$v0,$zero,$L44
	lw	$a0,32($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L44:
	lw	$v0,36($fp)
	beq	$v0,$zero,$L41
	lw	$a0,36($fp)
	la	$t9,fclose
	jal	$ra,$t9
$L41:
	lw	$v0,36($fp)
	bne	$v0,$zero,$L46
	la	$a0,$LC21
	la	$t9,puts
	jal	$ra,$t9
$L46:
	sw	$zero,80($fp)
$L19:
	lw	$v0,80($fp)
	move	$sp,$fp
	lw	$ra,96($sp)
	lw	$fp,92($sp)
	addu	$sp,$sp,104
	j	$ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
