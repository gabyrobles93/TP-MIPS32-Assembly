#include <mips/regdef.h>
#include <sys/syscall.h>

#define STACK_FRAME_SIZE 40
#define BUFFER_SIZE 3
#define GLOBAL_POINTER 24

	.text			# segmento de texto del programa

	.abicalls
	.align 2		# alineacion 2^2

	.globl	asm_encode
	.ent	asm_encode
asm_encode:
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

read_loop:

    li      v0, SYS_read        # Cargo la syscall
    lw      a0, 4($fp)          # Cargo el ifd
    la      a1, buffer          # Cargo la dirección del buffer
    li      a2, BUFFER_SIZE     # Cargo el largo del buffer
    syscall                

    # Si se leen 24 bits...
    li      a0, 3
    beq     v0, a0, bytes_readed_3

    # Si se leen 16 bits...
    li      a0, 2
    beq     v0, a0, bytes_readed_2

    # Si se leen 8 bits...
    li      a0, 1
    beq     v0, a0, bytes_readed_1

    # Si se llego a EOF
    beq     v0, zero, end_reading

#    li  v0, SYS_write           # Cargo la syscall
#    lw  a0, 8($fp)              # Cargo el ofd
#    la  a1, buffer              # Cargo el buffer
#    li  a2, BUFFER_SIZE         # Cargi el largo del buffer
#    syscall            

    j read_loop

bytes_readed_3:

    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, msg_bytes_readed_3      # Cargo el buffer
    li  a2, 18                  # Cargo el largo del buffer
    syscall

    j read_loop

bytes_readed_2:

    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, msg_bytes_readed_2      # Cargo el buffer
    li  a2, 18                  # Cargo el largo del buffer
    syscall

    j read_loop

bytes_readed_1:

    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, msg_bytes_readed_1      # Cargo el buffer
    li  a2, 18                  # Cargo el largo del buffer
    syscall

    j read_loop

end_reading:

    # FIN DEL CODIGO DEL ENCODER ---

    # Restauro el Stack Frame
	lw	gp, GLOBAL_POINTER(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)

    # Destruyo el stack frame
    addu	sp, sp, STACK_FRAME_SIZE

    # Vuelvo a la función que me invocó
    jr ra

	.end	asm_encode
	.size	asm_encode,.-asm_encode

    .data
buffer: .space BUFFER_SIZE
msg_bytes_readed_3: .asciiz "tres bytes readed\n"
msg_bytes_readed_2: .asciiz "dos bytes readed\n"
msg_bytes_readed_1: .asciiz "uno bytes readed\n"

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
