#include <mips/regdef.h>
#include <sys/syscall.h>

#define STACK_FRAME_SIZE 60
#define BUFFER_SIZE 3
#define GLOBAL_POINTER 28
#define PADDING_ASCII 61
#define LF_ASCII 10
#define MAX_CHARS_PER_LINE 76
#define MASK_LAST_TWO 0x03
#define MASK_LAST_FOUR 0x0F
#define MASK_LAST_SIX 0x3F

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

    # Guardamos en el stack frame estos registros que son callee saved en SRA
    sw	ra, 36(sp)
    sw	$fp, 32(sp)
    

    # Igualo fp con sp y de ahora en mas utilizo fp
    move    $fp, sp

    # Salvo los argumentos en mi región de caller-saved registers
    sw  a0, 24($fp) # ifd
    sw  a1, 20($fp) # ofd

    # Guardo la variable de padding
    move a0, zero
    li   a0, PADDING_ASCII
    sw   a0, 0($fp)

    # Guardo la variable de endl
    move a0, zero
    li   a0, LF_ASCII
    sw   a0, -8($fp)

    # Guardo la variable de contador de caracteres escritos
    move a0, zero
    sw   a0, 16($fp)

    # FIN DE INICIALIZACIÓN | INICIO DEL PROGRAMA 

read_loop:
    li      v0, SYS_read        # Cargo la syscall
    lw      a0, 24($fp)         # Cargo el ifd
    la      a1, buffer          # Cargo la dirección del buffer
    li      a2, BUFFER_SIZE     # Cargo el largo del buffer
    syscall                     # Devuelve en v0 la cantidad leida

    # Si se leen 24 bits...
    li      t9, 3
    beq     v0, t9, bytes_readed_3

    # Si se leen 16 bits...
    li      t9, 2
    beq     v0, t9, bytes_readed_2

    # Si se leen 8 bits...
    li      t9, 1
    beq     v0, t9, bytes_readed_1

    # Si se llego a EOF
    beq     v0, zero, end_reading           

    j read_loop

bytes_readed_3:

    la   t1,     buffer                # Cargo la direccion del buffer en t1
  
    sw   t1,     12($fp)               # Cargamos la direccion de buffer[0] en 12($fp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sw   t1,     8($fp)                # Cargamos la direccion de buffer[1] en 8($fp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sw   t1,     4($fp)                # Cargamos la direccion de buffer[2] en 4($fp)

    move t0, zero                 # uso t0 como la variable index primero la incializo en 0
    lw   t9, 12($fp)              # recuperamos la direccion del byte 0
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 0)
    sra  t0, t0, 2                # t0 = t0 >> 2
    jal write_encode              # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lw   t9, 8($fp)               # recuperamos la direccion del byte 1
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 1)
    sra  t0, t0, 4                # t0 = t0 >> 4

    move t1, zero                 # cargo 0 en t1 que es donde pondremos el byte 0
    lw   t9, 12($fp)              # recuperamos la direccion del byte 0
    lbu  t1, 0(t9)                # cargo el el contenido de la direccion (el byte 0) en t1
    andi t1, t1, MASK_LAST_TWO    # t1 = t1 & MASK_LAST_TWO
    sll  t1, t1, 4                # t1 = t1 << 4
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode              # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lw   t9, 4($fp)               # recuperamos la direccion del byte 2
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 2)
    sra  t0, t0, 6                # t0 = t0 >> 6
    lw   t9, 8($fp)               # recuperamos la direccion del byte 1
    lbu  t1, 0(t9)                # cargo el el contenido de la direccion (el byte 1) en t1
    andi t1, t1, MASK_LAST_FOUR   # t1 = t1 & MASK_LAST_FOUR
    sll  t1, t1, 2                # t1 = t1 << 2
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode              # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lw   t9, 4($fp)               # recuperamos la direccion del byte 2
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 2)
    andi t0, t0, MASK_LAST_SIX    # t0 = t0 & MASK_LAST_SIX
    jal write_encode              # Escribimos segun el codigo segun el index t0

    j read_loop

bytes_readed_2:

    la   t1,     buffer                 # Cargo la direccion del buffer en t1
  
    sw   t1,     12($fp)                # Cargamos la direccion de buffer[0] en 12($fp)

    addi t1,     1                      # Cargamos la direccion del siguiente byte
    sw   t1,     8($fp)                 # Cargamos la direccion de buffer[1] en 8($fp)

    move t1,     zero                   # Ponemos 0 en t1 para escribir byte 2 como 0
    sw   t1,     4($fp)                 # Cargamos 0 en 4($fp)

    move t0, zero                 # uso t0 como la variable index primero la incializo en 0
    lw   t9, 12($fp)              # recuperamos la direccion del byte 0
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 0)
    sra  t0, t0, 2                # t0 = t0 >> 2
    jal  write_encode             # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lw   t9, 8($fp)               # recuperamos la direccion del byte 1
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 1)
    sra  t0, t0, 4                # t0 = t0 >> 4

    move t1, zero                 # cargo 0 en t1 que es donde pondremos el byte 0  
    lw   t9, 12($fp)              # recuperamos la direccion del byte 0
    lbu  t1, 0(t9)                # cargo el el contenido de la direccion (el byte 0) en t1
    andi t1, t1, MASK_LAST_TWO    # t1 = t1 & MASK_LAST_TWO
    sll  t1, t1, 4                # t1 = t1 << 4
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode              # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0, pues el byte 2 es 0 por padding)
    sra  t0, t0, 6                # t0 = t0 >> 6
    lw   t9, 8($fp)               # recuperamos la direccion del byte 1
    lbu  t1, 0(t9)                # cargo el contenido de la direccion (el byte 1)
    andi t1, t1, MASK_LAST_FOUR   # t1 = t1 & MASK_LAST_FOUR
    sll  t1, t1, 2                # t1 = t1 << 2
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode              # Escribimos segun el codigo segun el index t0

    jal write_padding
    j read_loop

bytes_readed_1:

    la   t1,     buffer                 # Cargo la direccion del buffer en t1
  
    sw   t1,     12($fp)                # Cargamos la direccion de buffer[0] en 12($fp)

    move t1,     zero                   # Ponemos 0 en t1 para escribir byte 1 como 0
    sw   t1,     8($fp)                 # Cargamos 0 en 8($fp)

    move t1,     zero                   # Ponemos 0 en t1 para escribir byte 2 como 0 (redundante)
    sw   t1,     4($fp)                 # Cargamos 0 en 4($fp)

    move t0, zero                 # uso t0 como la variable index primero la incializo en 0
    lw   t9, 12($fp)              # recuperamos la direccion del byte 0
    lbu  t0, 0(t9)                # cargo el contenido de la direccion (el byte 0)
    sra  t0, t0, 2                # t0 = t0 >> 2
    jal  write_encode             # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0, pues el byte 1 es 0 por padding)
    sra  t0, t0, 4                # t0 = t0 >> 4

    move t1, zero                 # cargo 0 en t1 que es donde pondremos el byte 0
    lw   t9, 12($fp)              # recuperamos la direccion del byte 0
    lbu  t1, 0(t9)                # cargo el el contenido de la direccion (el byte 0) en t1
    andi t1, t1, MASK_LAST_TWO    # t1 = t1 & MASK_LAST_TWO
    sll  t1, t1, 4                # t1 = t1 << 4
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode              # Escribimos segun el codigo segun el index t0

    jal write_padding
    jal write_padding
    j read_loop

# This routine writes the encode value in
# base 64. The corresponding index should 
# be stored on t0 register.
write_encode:
  sw     t0, -4($fp)
  lw     t8, 16($fp)                           # Cargo la cantidad de caracteres escritos hasta el momento
  bne    t8, MAX_CHARS_PER_LINE, encode
    # jal write_endl
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 20($fp)             # Cargo el ofd
    la  a1, -8($fp)              # Cargo el la direccion del principio del array
    li  a2, 1                   # Cargo el largo del buffer (1 byte)
    syscall
    # Reseteamos el contador
    move a0, zero
    sw   a0, 16($fp)
  encode:
    lw  t0,   -4($fp)
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 20($fp)             # Cargo el ofd
    la  a1, base64              # Cargo el la direccion del principio del array
    add a1, a1, t0              # Sumo el indice a la direccion del ppio del array
    li  a2, 1                   # Cargo el largo del buffer (1 byte)
    syscall

    # jal inc_char_written
    lw  t5, 16($fp) # Cargo la cantidad de caracteres escritos hasta el momento
    addi t5, t5, 1 # incrementamos en 1
    sw t5, 16($fp)  # guardamos en stack

    jr ra                       # Volvemos del llamado a subrutina


# Not used
write_endl:
  li  v0, SYS_write           # Cargo la syscall
  lw  a0, 20($fp)             # Cargo el ofd
  la  a1, -8($fp)              # Cargo el la direccion del principio del array
  li  a2, 1                   # Cargo el largo del buffer (1 byte)
  syscall

  # Reseteamos el contador
  move a0, zero
  sw   a0, 16($fp)
  jr ra                       # Volvemos del llamado a subrutina

write_padding:
  lw     t8, 16($fp)           # Cargo la cantidad de caracteres escritos hasta el momento
  bne    t8, MAX_CHARS_PER_LINE, padding
    # jal write_endl
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 20($fp)             # Cargo el ofd
    la  a1, 0($fp)              # Cargo el la direccion del principio del array
    li  a2, 1                   # Cargo el largo del buffer (1 byte)
    syscall
    # Reseteamos el contador
    move a0, zero
    sw   a0, 16($fp)

  padding:
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 20($fp)             # Cargo el ofd
    la  a1, 0($fp)              # Cargo el la direccion del principio del array
    li  a2, 1                   # Cargo el largo del buffer (1 byte)
    syscall
    # jal inc_char_written
    lw  t5, 16($fp) # Cargo la cantidad de caracteres escritos hasta el momento
    addi t5, t5, 1 # incrementamos en 1
    sw t5, 16($fp)  # guardamos en stack

    jr ra                       # Volvemos del llamado a subrutina

# Not used
inc_char_written:
  lw  t5, 16($fp) # Cargo la cantidad de caracteres escritos hasta el momento
  addi t5, t5, 1 # incrementamos en 1
  sw t5, 16($fp)  # guardamos en stack
  jr ra

end_reading:

    # Restauro el Stack Frame
    lw	ra,  36(sp)
    lw	$fp, 32(sp)
    lw	gp,  GLOBAL_POINTER(sp)

    # Destruyo el stack frame
    addu	sp, sp, STACK_FRAME_SIZE

    # Vuelvo a la función que me invocó
    jr ra

	.end	asm_encode
	.size	asm_encode,.-asm_encode

  .data
buffer: .space BUFFER_SIZE

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
