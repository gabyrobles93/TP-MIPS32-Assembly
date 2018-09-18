	.file	1 "options.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"Usage:\n"
	.ascii	" tp0 -h\n"
	.ascii	" tp0 -V\n"
	.ascii	" tp0 [options]\n"
	.ascii	"Options:\n"
	.ascii	" -V, --version\t\tPrint version and quit.\n"
	.ascii	" -h, --help\t\tPrint this information.\n"
	.ascii	" -i, --input\t\tLocation of the input file.\n"
	.ascii	" -o, --output\t\tLocation of the output file.\n"
	.ascii	" -a, --action\t\tProgram action: encode (default) or dec"
	.ascii	"ode.\n"
	.ascii	"Examples:\n"
	.ascii	" tp0 -a encode -i ~/input -o ~/output\n"
	.ascii	" tp0 -a decode\n\000"
	.text
	.align	2
	.globl	help
	.ent	help
help:
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
	la	$a0,$LC0
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	help
	.size	help, .-help
	.rdata
	.align	2
$LC1:
	.ascii	"Encoder/Decoder Base64\n"
	.ascii	"66.20 Organizacion de Computadoras FIUBA\n\000"
	.text
	.align	2
	.globl	version
	.ent	version
version:
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
	la	$a0,$LC1
	la	$t9,printf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	version
	.size	version, .-version
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
