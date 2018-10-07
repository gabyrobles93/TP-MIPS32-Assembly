#include <mips/regdef.h>
#include <sys/syscall.h>

#define STACK_FRAME_SIZE 40
#define GLOBAL_POINTER 24

	.text			# segmento de texto del programa

	.abicalls
	.align 2		# alineacion 2^2

	.globl	asm_decode
	.ent	asm_decode
asm_decode:
    # Descripción del stack frame
    # STACK_FRAME_SIZE bytes de espacio
    # el return address se guarda en ra
    # fp sera el registro usado como frame pointer
    .frame	$fp, STACK_FRAME_SIZE, ra

    # Bloque para codigo PIC
	.set	noreorder	# apaga reordenamiento de instrucciones
	.cpload t9		# directiva usada para codigo PIC
	.set	reorder		# enciende reordenamiento de instrucciones

    # Crea el stack frame, que crece hacia abajo en direcciones.
    subu	sp, sp, STACK_FRAME_SIZE

    # Directiva para codigo PIC
    # Inserta aqui "sw gp, GLOBAL_POINTER(sp)"
    # gp es "pointer to global area"
    # Mas "lw gp, 24(sp)" luego de cada jal.
    .cprestore GLOBAL_POINTER

    # Guardamos en el stack frame estos registros que son callee saved
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

    addiu   $fp, sp, 36

    # Guardamos en el stack frame del padre los argumentos
    # Esto es, en el Argument Building Area
    sw	a0, 4($fp)
    sw	a1, 8($fp)
    
    # ACA VA EL CODIGO DEL ENCODER ---

    sw a0, -20($fp)
    sw a1, -24($fp)

    la a0, msg_ifd
    lw a1, 4($fp)
    jal printf

    la a0, msg_ofd
    lw a1, 8($fp)
    jal printf

    # FIN DEL CODIGO DEL ENCODER ---

    # Restauro el Stack Frame
    lw	gp, GLOBAL_POINTER(sp)
    lw	$fp, 28(sp)
    lw	ra, 32(sp)

    # Destruyo el stack frame
    addu	sp, sp, STACK_FRAME_SIZE

    # Vuelvo a la función que me invocó
    jr ra

	.end	asm_decode
	.size	asm_decode,.-asm_decode

	.rdata			# segmento read-only data

  .align 0
msg_ifd: .asciiz "ifd decoder en asm: %i \n"
msg_ofd: .asciiz "ofd decoder en asm: %i \n"

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
