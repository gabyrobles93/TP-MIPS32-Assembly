#include <mips/regdef.h>
#include <sys/syscall.h>

#define STACK_FRAME_SIZE 40
#define BUFFER_SIZE 3
#define GLOBAL_POINTER 24
#define PADDING_ASCII 61
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

    # Guardamos en el stack frame estos registros que son callee saved
    sw	$fp, 28(sp)
    sw	ra, 32(sp)
    # Estos registros son callee saved, los guardo porque los voy a usar en esta rutina:
    sw  s0,  24(sp)
    sw  s1,  20(sp)

    addiu   $fp, sp, 36

    # Guardamos en el stack frame del padre los argumentos
    # Esto es, en el Argument Building Area
    sw	a0, 4($fp)
    sw	a1, 8($fp)
    
    # ACA VA EL CODIGO DEL ENCODER ---

read_loop:
    la	t9, test_label
    jal ra, t9
    nop

    la	t9, test_label
    jal ra, t9
    nop

    la	t9, test_label
    jal ra, t9
    nop

    li      v0, SYS_read        # Cargo la syscall
    lw      a0, 4($fp)          # Cargo el ifd
    la      a1, buffer          # Cargo la dirección del buffer
    li      a2, BUFFER_SIZE     # Cargo el largo del buffer
    syscall                     # Devuelve en v0 la cantidad leida

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

test_label:
  jr ra
  nop

bytes_readed_3:

    # li  v0, SYS_write           # Cargo la syscall
    # lw  a0, 8($fp)              # Cargo el ofd
    # la  a1, msg_bytes_readed_3  # Cargo el buffer
    # li  a2, 18                  # Cargo el largo del buffer
    # syscall

    la   t1,     buffer                # Cargo la direccion del buffer en t1
  
    sb   t1,     12(sp)                # Cargamos el byte de buffer[0] en 12(sp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sb   t1,     8(sp)                 # Cargamos el byte de buffer[1] en 8(sp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sb   t1,     4(sp)                 # Cargamos el byte de buffer[2] en 4(sp)

    move t0, zero        # uso t0 como la variable index primero la incializo en 0
    lbu  t0, 12(sp)      # cargo el byte 0 en el index
    sra  t0, t0, 2       # t0 = t0 >> 2
    jal write_encode     # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lbu  t0, 8(sp)                # cargo el byte 1 en el index
    sra  t0, t0, 4                # t0 = t0 >> 4
    lbu  t1, 12(sp)               # cargo el byte 0 en t1
    andi t1, t1, MASK_LAST_TWO    # t1 = t1 & MASK_LAST_TWO
    sll  t1, t1, 4                # t1 = t1 << 4
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode     # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lbu  t0, 4(sp)                # cargo el byte 2 en el index
    sra  t0, t0, 6                # t0 = t0 >> 4
    lbu  t1, 8(sp)                # cargo el byte 1 en t1
    andi t1, t1, MASK_LAST_FOUR   # t1 = t1 & MASK_LAST_FOUR
    sll  t1, t1, 2                # t1 = t1 << 2
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode     # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lbu  t0, 4(sp)                # cargo el byte 2 en el index
    andi t0, t0, MASK_LAST_SIX    # t0 = t0 & MASK_LAST_SIX
    jal write_encode     # Escribimos segun el codigo segun el index t0

    j read_loop

bytes_readed_2:

    la   t1,     buffer                # Cargo la direccion del buffer en t1
  
    sb   t1,     12(sp)                # Cargamos el byte de buffer[0] en 12(sp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sb   t1,     8(sp)                 # Cargamos el byte de buffer[1] en 8(sp)

    move t1,     zero                  # Ponemos 0 en t1 para escribir byte 2 como 0
    sb   t1,     4(sp)                 # Cargamos 0 en 4(sp)

    move t0, zero        # uso t0 como la variable index primero la incializo en 0
    lbu  t0, 12(sp)      # cargo el byte 0 en el index
    sra  t0, t0, 2       # t0 = t0 >> 2
    jal write_encode     # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lbu  t0, 8(sp)                # cargo el byte 1 en el index
    sra  t0, t0, 4                # t0 = t0 >> 4
    lbu  t1, 12(sp)               # cargo el byte 0 en t1
    andi t1, t1, MASK_LAST_TWO    # t1 = t1 & MASK_LAST_TWO
    sll  t1, t1, 4                # t1 = t1 << 4
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode     # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lbu  t0, 4(sp)                # cargo el byte 2 en el index
    sra  t0, t0, 6                # t0 = t0 >> 4
    lbu  t1, 8(sp)                # cargo el byte 1 en t1
    andi t1, t1, MASK_LAST_FOUR   # t1 = t1 & MASK_LAST_FOUR
    sll  t1, t1, 2                # t1 = t1 << 2
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode     # Escribimos segun el codigo segun el index t0

    # Aca deberia escribir un padding
    j read_loop

bytes_readed_1:

    la   t1,     buffer                # Cargo la direccion del buffer en t1
  
    sb   t1,     12(sp)                # Cargamos el byte de buffer[0] en 12(sp)

    move t1,     zero                  # Ponemos 0 en t1 para escribir byte 1 como 0
    sb   t1,     8(sp)                 # Cargamos 0 en 8(sp)

    move t1,     zero                  # Ponemos 0 en t1 para escribir byte 2 como 0 (redundante)
    sb   t1,     4(sp)                 # Cargamos 0 en 4(sp)

    move t0, zero        # uso t0 como la variable index primero la incializo en 0
    lbu  t0, 12(sp)      # cargo el byte 0 en el index
    sra  t0, t0, 2       # t0 = t0 >> 2
    jal write_encode     # Escribimos segun el codigo segun el index t0

    move t0, zero                 # Pongo index (t0 en 0)
    lbu  t0, 8(sp)                # cargo el byte 1 en el index
    sra  t0, t0, 4                # t0 = t0 >> 4
    lbu  t1, 12(sp)               # cargo el byte 0 en t1
    andi t1, t1, MASK_LAST_TWO    # t1 = t1 & MASK_LAST_TWO
    sll  t1, t1, 4                # t1 = t1 << 4
    or   t0, t0, t1               # t0 (index) = t0 | t1
    jal write_encode     # Escribimos segun el codigo segun el index t0

    # Aca deberia escribir un padding

    # Aca deberia escribir un padding
    j read_loop

# This routine writes the encode value in
# base 64. The corresponding index should 
# be stored on t0 register.
write_encode:
  li  v0, SYS_write           # Cargo la syscall
  lw  a0, 8($fp)              # Cargo el ofd
  la  a1, base64              # Cargo el la direccion del principio del array
  add a1, a1, t0              # Sumo el indice a la direccion del ppio del array

  li  a2, 1                   # Cargo el largo del buffer (1 byte)
  syscall

  jr ra                       # Volvemos del llamado a subrutina


end_reading:

    # FIN DEL CODIGO DEL ENCODER ---

    # Restauro el Stack Frame
    lw	gp,  GLOBAL_POINTER(sp)
    lw	$fp, 28(sp)
    lw	ra,  32(sp)
    lw  s0,  24(sp)
    lw  s1,  20(sp)


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
