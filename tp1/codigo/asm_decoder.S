#include <mips/regdef.h>
#include <sys/syscall.h>

	.text			# segmento de texto del programa

	.abicalls
	.align 2		# alineacion 2^2

	.globl	asm_decode
	.ent	asm_decode
asm_decode:
    # Descripción del stack frame
    # Ocupará 40 bytes, ra guardará el return address
    # fp sera el registro usado como frame pointer
    .frame	$fp, 40, ra

    # Bloque de código PIC
 	.set	noreorder   # Apaga reordenamiento de instrucciones
	.cpload t9		    # Directiva usada para codigo PIC
	.set	reorder		# Enciende reordenamiento de instrucciones   

	# Creo stack frame
	subu	sp, sp, 40	# 3 SRA, 5 LA, 2 ABA

	# Directiva para codigo PIC
	.cprestore 28		# inserta aqui "sw gp, 28(sp)" y "lw gp, 28(sp)" luego de cada jal.

    # Guardo registros callee-saved en SRA
    sw  ra, 36(sp)
    sw  $fp, 32(sp)

    # Igualo fp con sp y de ahora en mas utilizo sp
    move    $fp, sp

    # Salvo los argumentos en mi región de caller-saved registers
    sw  a0, 24($fp)
    sw  a1, 20($fp)

    # FIN DE INICIALIZACIÓN | INICIO DEL PROGRAMA 


	la	t9, read_bytes	
	jal	ra, t9

	la	t9, read_bytes	
	jal	ra, t9

	la	t9, decode_4bytes	
	jal	ra, t9

	la	t9, decode_4bytes	
	jal	ra, t9

	la	t9, decode_value	
	jal	ra, t9

	la	t9, decode_value	
	jal	ra, t9


    # FIN DE PROGRAMA | DESTRUYO STACK FRAME

    # Restauro registros callee saved
    lw  ra, 36(sp)
    lw  $fp, 32(sp)
    lw  gp, 28(sp)

    # Destruyo el stack frame de esta función
    addu    sp, sp, 40

    # Retorno a la función que invocó a esta
    jr ra

	.end	asm_decode
	.size	asm_decode,.-asm_decode

	.ent	read_bytes
read_bytes:
    .frame	$fp, 32, ra
	.set	noreorder
	.cpload t9
	.set	reorder

	# Creo stack frame
	subu	sp, sp, 32	# 3 SRA, 2 LA, 3 ABA

    .cprestore 20		# inserta aqui "sw gp, 20(sp)" y "lw gp, 20(sp)" luego de cada jal.

    # Guardo registros callee-saved en SRA
    sw  ra, 28(sp)
    sw  $fp, 24(sp)

    # Igualo fp con sp y de ahora en mas utilizo sp
    move    $fp, sp






    # Restauro registros callee saved
    lw  ra, 28(sp)
    lw  $fp, 24(sp)
    lw  gp, 20(sp)

    # Destruyo el stack frame de esta función
    addu    sp, sp, 32

    # Retorno a la función que invocó a esta
    jr ra

	.end	read_bytes
	.size	read_bytes,.-read_bytes

	.ent	decode_4bytes
decode_4bytes:
    .frame	$fp, 52, ra
	.set	noreorder
	.cpload t9
	.set	reorder

	# Creo stack frame
	subu	sp, sp, 52	# 3 SRA, 2 LA, 3 ABA

    .cprestore 40		# inserta aqui "sw gp, 20(sp)" y "lw gp, 20(sp)" luego de cada jal.

    # Guardo registros callee-saved en SRA
    sw  ra, 48(sp)
    sw  $fp, 44(sp)

    # Igualo fp con sp y de ahora en mas utilizo sp
    move    $fp, sp


    



    # Restauro registros callee saved
    lw  ra, 48(sp)
    lw  $fp, 44(sp)
    lw  gp, 40(sp)

    # Destruyo el stack frame de esta función
    addu    sp, sp, 52

    # Retorno a la función que invocó a esta
    jr ra

	.end	decode_4bytes
	.size	decode_4bytes,.-decode_4bytes


	.ent	decode_value
decode_value:
    .frame	$fp, 20, ra
	.set	noreorder
	.cpload t9
	.set	reorder

	# Creo stack frame
	subu	sp, sp, 20	# 3 SRA, 2 LA, 3 ABA

    .cprestore 8		# inserta aqui "sw gp, 20(sp)" y "lw gp, 20(sp)" luego de cada jal.

    # Guardo registros callee-saved en SRA
    sw  ra, 16(sp)
    sw  $fp, 12(sp)

    # Igualo fp con sp y de ahora en mas utilizo sp
    move    $fp, sp


    



    # Restauro registros callee saved
    lw  ra, 16(sp)
    lw  $fp, 12(sp)
    lw  gp, 8(sp)

    # Destruyo el stack frame de esta función
    addu    sp, sp, 20

    # Retorno a la función que invocó a esta
    jr ra

	.end	decode_value
	.size	decode_value,.-decode_value



   .data

buffer: .space 4
debug_msg: .asciiz "Mensaje\n"

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
