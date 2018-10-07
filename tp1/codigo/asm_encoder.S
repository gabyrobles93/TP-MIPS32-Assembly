#include <mips/regdef.h>
#include <sys/syscall.h>

	.text			# segmento de texto del programa

	.abicalls
	.align 2		# alineacion 2^2

	.globl	asm_encoder
	.ent	asm_encoder
asm_encoder:



	.end	asm_encoder
	.size	asm_encoder,.-asm_encoder



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