# $Id: print_dnames.S,v 1.1 2008/04/22 03:11:50 hmasci Exp $

#include <mips/regdef.h>
#include <sys/syscall.h>

	.text			# segmento de texto del programa

	.abicalls
	.align 2		# alineacion 2^2

	.globl	print_dnames
	.ent	print_dnames
print_dnames:
	# debugging info: descripcion del stack frame
	.frame	$fp, 40, ra	# $fp: registro usado como frame pointer
				# 40: tamañodel stack frame
				# ra: registro que almacena el return address
	# bloque para codigo PIC
	.set	noreorder	# apaga reordenamiento de instrucciones
	.cpload t9		# directiva usada para codigo PIC
	.set	reorder		# enciende reordenamiento de instrucciones

	# creo stack frame
	subu	sp, sp, 40	# 4 (SRA) + 2 (LTA) + 4 (ABA)

	# directiva para codigo PIC
	.cprestore 24		# inserta aqui "sw gp, 24(sp)",
				# mas "lw gp, 24(sp)" luego de cada jal.
	# salvado de callee-saved regs en SRA	
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp, sp
	
	# salvo 1er arg (siempre)
	sw	a0, 40($fp)	# n: a0, sp+40

	# r = n % 10;
	remu	t0, a0, 10	# r: t0, sp+16	## remU
	sw	t0, 16($fp)

	# n /= 10;
	lw	a0, 40($fp)			## redundante
	divu	a0, a0, 10			## divU!
	sw	a0, 40($fp)

	## if (n > 0) 
	lw	a0, 40($fp)			## redundante
	beq	a0, zero, _write_name # n>0 equivale a n!=0 (n unsigned)
	
	#	print_dnames(n);
	lw	a0, 40($fp)			## redundante
	la	t9, print_dnames
	jal	ra, t9

	#	write(1, " ", 1);
	li	a0, 1		# fd=1: a0
	la	a1, sep		# buf=" ": a1	## la, NO lw
	li	a2, 1		# count=1: a2
	li	v0, SYS_write
	syscall

_write_name:
	# write(1, name[r], mystrlen(name[r]));
	# calculo auxiliar: obtengo name[r]
	lw	a0, 16($fp)	# r: a0, sp+16
	sll	a0, a0, 2	# escalo r con tam de ptr (r*=4)
	lw	a0, name(a0)	# name[r]: a0
	sw	a0, 20($fp)	# almaceno name[r] en LTA
	# obtengo mystrlen(name[r])
	la	t9, mystrlen	# mystrlen(name[r])
	jal	ra, t9
	# cargo argumentos y nro de syscall
	move	a2, v0
	lw	a1, 20($fp)	# name[r] ## (por que no hago move a1, a0?)
	li	a0, 1	
	li	v0, SYS_write
	syscall

	# return;
	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end	print_dnames
	.size	print_dnames,.-print_dnames

	.ent	mystrlen
mystrlen:
	.frame	$fp, 16, ra
	.set	noreorder
	.cpload t9
	.set	reorder

	# creo stack frame
	subu	sp, sp, 16	# 2 (SRA) + 2 (LTA)
	.cprestore 8		# sw gp, 8(sp)
	sw	$fp, 12(sp)
	move	$fp, sp

	# salvo 1er arg (siempre)
	sw	a0, 16($fp)			## redundante

	# for (i=0; s[i] != 0; i++)
	move	t0, zero	# i=0: t0, fp+0
	sw	t0, 0($fp)	# i: t0
_for_loop:
	# condicion de corte: s[i] != 0
	lw	a0, 16($fp)			## redundante
	lw	t0, 0($fp)			## redundante
	addu	t1, a0, t0	# s[i]: t1
	lb	t1, 0(t1)			## lb, NO lw!
	beq	t1, zero, _end_for
	
	lw	t0, 0($fp)	# i++		## redundante
	addu	t0, t0, 1
	sw	t0, 0($fp)			## redundante
	j	_for_loop

_end_for:
	lw	v0, 0($fp)			## podria ser un move v0, t0
	lw	gp, 8(sp)
	lw	$fp, 12(sp)
	addu	sp, sp, 16
	jr	ra

	.end	mystrlen
	.size	mystrlen,.-mystrlen

	.rdata			# segmento read-only data

	.align 2
name:	.word name_0, name_1, name_2, name_3, name_4, \
	      name_5, name_6, name_7, name_8, name_9
	.size name, 40

	.align 0		# alineacion 2^0

name_0: .asciiz "cero"
name_1: .asciiz "uno"
name_2: .asciiz "dos"
name_3: .asciiz "tres"
name_4: .asciiz "cuatro"
name_5: .asciiz "cinco"
name_6: .asciiz "seis"
name_7: .asciiz "siete"
name_8: .asciiz "ocho"
name_9: .asciiz "nueve"

sep:	.ascii " "
