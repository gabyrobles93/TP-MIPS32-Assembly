#include <mips/regdef.h>
#include <sys/syscall.h>

#define BUFFER_SIZE 4

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

    # Igualo fp con sp y de ahora en mas utilizo fp
    move    $fp, sp

    # Salvo los argumentos en mi región de caller-saved registers
    sw  a0, 24($fp)
    sw  a1, 20($fp)

    # FIN DE INICIALIZACIÓN | INICIO DEL PROGRAMA 

decode_loop:

    # Invoco a la funcion que lee 4 bytes en el buffer
    # Se ignoran espacios (!isspace(char))
    # Antes guardo registros caller-saved
    sw  t0, 16($fp)
    sw  t1, 12($fp)
    # Paso el argumento: ifd (a0)
    lw  a0, 24($fp)
    sw  a0, 0($fp)
    jal	read_bytes
    # Restauro los registros caller-saved
    lw  t0, 16($fp)
    lw  t1, 12($fp)
    lw  a0, 24($fp)
    lw  a1, 20($fp)

    # Si read_bytes devolvio < 0 es que hubo error (caracter invalido)
    bltz    v0, end_decode

    # Si read_bytes devolvio < 4 es que se llego a eof (archivo invalido)
    li  t9, 4
    blt v0, t9,  end_decode

    # Si read_bytes devolvio = 0 es que se llego al fin del archivo
    beqz    v0, end_decode

    # Imprimo por pantalla los 4 bytes leidos (DEBUG)
    li  v0, SYS_write           # Cargo la syscall
    li  a0, 1                   # Cargo el ofd
    la  a1, buffer              # Cargo el buffer
    li  a2, BUFFER_SIZE         # Cargo el largo del buffer
    syscall  

    j decode_loop


    # FIN DE PROGRAMA | DESTRUYO STACK FRAME
end_decode:

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

    # FIN DE INICIALIZACIÓN | INICIO DEL PROGRAMA 

    la  t0, buffer
    li  t1, 0
read_bytes_loop:

    # Guardo registros caller-saved
    sw  t0, 16($fp)
    sw  t1, 12($fp)
    sw  a0, 8($fp)

    li      v0, SYS_read        # Cargo la syscall
#    lw      a0, 32($fp)         # Cargo el ifd
    move    a1, t0              # Cargo la dirección del buffer
    li      a2, 1               # Cargo el largo del buffer
    syscall                     # Devuelve en v0 la cantidad leida

    # Restauro registros caller-saved
    lw  t0, 16($fp)
    lw  t1, 12($fp)
    lw  a0, 8($fp)

    # Si la cantidad de bytes leidos fue cero se llego a EOF
    beq     v0, zero, eof_read_bytes
    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_read_bytes

    # Cargo en t9 el byte leido y alojado en el buffer
    lbu  t9, 0(t0)  

    # Si el byte leido es un espacio, hay que ignorarlo y seguir leyendo
    li    t8, 0x20
    beq t9, t8, read_bytes_loop
    li    t8, 0x09
    beq t9, t8, read_bytes_loop
    li    t8, 0x0a
    beq t9, t8, read_bytes_loop
    li    t8, 0x0b
    beq t9, t8, read_bytes_loop
    li    t8, 0x0c
    beq t9, t8, read_bytes_loop
    li    t8, 0x0d
    beq t9, t8, read_bytes_loop

    # Si llegamos aca es porque el byte leido es valido
    # Entonces corresponde aumentar el contador
    addi    t0, 1
    addi    t1, 1

    # Chequeo si el contador de bytes llego a 4, en ese caso salimos
    li    t8, 4
    beq t1, t8, end_read_bytes_loop
    j read_bytes_loop

eof_read_bytes:
    move  v0, t1
    j end_read_bytes

error_read_bytes:
    li  v0, -1
    j end_read_bytes

    # FIN DE PROGRAMA | DESTRUYO STACK FRAME
end_read_bytes_loop:
    li  v0, 4

end_read_bytes:

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

buffer: .space BUFFER_SIZE
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
