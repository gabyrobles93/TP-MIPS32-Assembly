#include <mips/regdef.h>
#include <sys/syscall.h>
#include "error.h"

#define STACK_FRAME_SIZE 60
#define ENCODER_BUFFER_SIZE 3
#define GLOBAL_POINTER 28
#define LF_ASCII 10
#define MAX_CHARS_PER_LINE 76
#define MASK_LAST_TWO 0x03
#define MASK_LAST_FOUR 0x0F
#define MASK_LAST_SIX 0x3F
#define DECODER_BUFFER_SIZE 4
#define PADDING_ASCII 61
#define UPPER_A_ASCII 65
#define UPPER_Z_ASCII 90
#define LOWER_A_ASCII 97
#define LOWER_Z_ASCII 122
#define ZERO_ASCII 48
#define NINE_ASCII 57
#define PLUS_ASCII 43
#define SLASH_ASCII 47
#define SLASH_DECODED_VALUE 63
#define PLUS_DECODED_VALUE 62
#define DECODE_CONST_1 26
#define DECODE_CONST_2 52
#define INVALID_CHAR 0xFF
#define ERROR_CODE 0xFF
#define INVALID_FILE 0xFE
#define ERROR_WRITING_STREAM 0xFD

	.text			# segmento de texto del programa

	.abicalls
	.align 2		# alineacion 2^2

	.globl	base64_encode
	.ent	base64_encode
base64_encode:
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
    la      a1, encoder_buffer          # Cargo la dirección del encoder_buffer
    li      a2, ENCODER_BUFFER_SIZE     # Cargo el largo del encoder_buffer
    syscall                     # Devuelve en v0 la cantidad leida

    # Si v0 tiene < 0 es que hubo error en la syscall
    bltz    v0, encoder_error_reading

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

    la   t1,     encoder_buffer                # Cargo la direccion del encoder_buffer en t1
  
    sw   t1,     12($fp)               # Cargamos la direccion de encoder_buffer[0] en 12($fp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sw   t1,     8($fp)                # Cargamos la direccion de encoder_buffer[1] en 8($fp)

    addi t1,     1                     # Cargamos la direccion del siguiente byte
    sw   t1,     4($fp)                # Cargamos la direccion de encoder_buffer[2] en 4($fp)

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

    la   t1,     encoder_buffer                 # Cargo la direccion del encoder_buffer en t1
  
    sw   t1,     12($fp)                # Cargamos la direccion de encoder_buffer[0] en 12($fp)

    addi t1,     1                      # Cargamos la direccion del siguiente byte
    sw   t1,     8($fp)                 # Cargamos la direccion de encoder_buffer[1] en 8($fp)

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

    la   t1,     encoder_buffer                 # Cargo la direccion del encoder_buffer en t1
  
    sw   t1,     12($fp)                # Cargamos la direccion de encoder_buffer[0] en 12($fp)

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
    li  a2, 1                   # Cargo el largo del encoder_buffer (1 byte)
    syscall

    # Si v0 tiene < 0 es que hubo error en la syscall
    bltz    v0, encoder_error_writing

    # Reseteamos el contador
    move a0, zero
    sw   a0, 16($fp)
  encode:
    lw  t0,   -4($fp)
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 20($fp)             # Cargo el ofd
    la  a1, base64              # Cargo el la direccion del principio del array
    add a1, a1, t0              # Sumo el indice a la direccion del ppio del array
    li  a2, 1                   # Cargo el largo del encoder_buffer (1 byte)
    syscall

    # Si v0 tiene < 0 es que hubo error en la syscall
    bltz    v0, encoder_error_writing

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
  li  a2, 1                   # Cargo el largo del encoder_buffer (1 byte)
  syscall

    # Si v0 tiene < 0 es que hubo error en la syscall
    bltz    v0, encoder_error_writing

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
    li  a2, 1                   # Cargo el largo del encoder_buffer (1 byte)
    syscall

    # Si v0 tiene < 0 es que hubo error en la syscall
    bltz    v0, encoder_error_writing

    # Reseteamos el contador
    move a0, zero
    sw   a0, 16($fp)

  padding:
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 20($fp)             # Cargo el ofd
    la  a1, 0($fp)              # Cargo el la direccion del principio del array
    li  a2, 1                   # Cargo el largo del encoder_buffer (1 byte)
    syscall

    # Si v0 tiene < 0 es que hubo error en la syscall
    bltz    v0, encoder_error_writing

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

encoder_error_writing:
    li  v0, INDEX_ERROR_WRITING_STREAM
    j end_reading

encoder_error_reading:
    li  v0, INDEX_ERROR_READING_STREAM
    j end_reading

end_reading:

    # Restauro el Stack Frame
    lw	ra,  36(sp)
    lw	$fp, 32(sp)
    lw	gp,  GLOBAL_POINTER(sp)

    # Destruyo el stack frame
    addu	sp, sp, STACK_FRAME_SIZE

    # Vuelvo a la función que me invocó
    jr ra
    
	.end	base64_encode
	.size	base64_encode,.-base64_encode


# ############# D E C O D E R ################

	.globl	base64_decode
	.ent	base64_decode
base64_decode:
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

    # Invoco a la funcion que lee 4 bytes en el decoder_buffer
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

    # Si read_bytes devolvio < 0 es que hubo error en la syscall
    bltz    v0, decoder_error_reading_stream

    # Si read_bytes devolvio = 0 es que se llego al fin del archivo
    beqz    v0, end_decode

    # Si read_bytes devolvio < 4 es que se llego a eof (archivo invalido)
    li  t9, 4
    blt v0, t9,  decoder_error_invalid_file_format

    # Imprimo por pantalla los 4 bytes leidos (DEBUG)
    # li  v0, SYS_write           # Cargo la syscall
    # li  a0, 1                   # Cargo el ofd
    # la  a1, decoder_buffer              # Cargo el decoder_buffer
    # li  a2, DECODER_BUFFER_SIZE         # Cargo el largo del decoder_buffer
    # syscall  

    # Si llegamos acá es porque tenemos 4 bytes en el decoder_buffer 
    # que pueden ser decodificados

    # Invoco a la funcion que decodifica 4 bytes en el decoder_buffer
    # Antes guardo registros caller-saved
    sw  t0, 16($fp)
    sw  t1, 12($fp)
    # Paso el parametro de ofd
    lw  a0, 20($fp)
    jal	decode_4bytes
    # Restauro los registros caller-saved
    lw  t0, 16($fp)
    lw  t1, 12($fp)
    lw  a0, 24($fp)
    lw  a1, 20($fp)

    # Verifico errores de decode_4bytes: -1 es char invalido y -2 es fallo syscall de write
    sw  t0, 16($fp)
    li  t0, -1
    beq v0, t0, decoder_error_invalid_char
    li  t0, -2
    beq v0, t0, decoder_error_writing_stream
    lw  t0, 16($fp)

    j decode_loop

decoder_error_reading_stream:

    li  v0, INDEX_ERROR_READING_STREAM
    j end_decode

decoder_error_writing_stream:

    li  v0, INDEX_ERROR_WRITING_STREAM
    j end_decode

decoder_error_invalid_char:

    li  v0, INDEX_ERROR_INVALID_CHAR
    j end_decode

decoder_error_invalid_file_format:

    li  v0, INDEX_ERROR_INVALID_FILE_DECODER
    j end_decode

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

	.end	base64_decode
	.size	base64_decode,.-base64_decode

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

    la  t0, decoder_buffer
    li  t1, 0
read_bytes_loop:

    # Guardo registros caller-saved
    sw  t0, 16($fp)
    sw  t1, 12($fp)
    sw  a0, 8($fp)

    li      v0, SYS_read        # Cargo la syscall
    lw      a0, 32($fp)         # Cargo el ifd
    move    a1, t0              # Cargo la dirección del decoder_buffer
    li      a2, 1               # Cargo el largo del decoder_buffer
    syscall                     # Devuelve en v0 la cantidad leida

    # Restauro registros caller-saved
    lw  t0, 16($fp)
    lw  t1, 12($fp)
    lw  a0, 8($fp)

    # Si la cantidad de bytes leidos fue cero se llego a EOF
    beq     v0, zero, eof_read_bytes
    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_read_bytes

    # Cargo en t9 el byte leido y alojado en el decoder_buffer
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

    # Igualo fp con sp y de ahora en mas utilizo fp
    move    $fp, sp

    # FIN DE INICIALIZACIÓN DEL STACK FRAME | COMIENZO DE LA RUTINA

    la  t0, decoder_buffer
    li  t9, PADDING_ASCII
    lbu  t1, 0(t0)  # Cargo decoder_buffer[0]
    lbu  t2, 1(t0)  # Cargo decoder_buffer[1]
    lbu  t3, 2(t0)  # Cargo decoder_buffer[2]
    lbu  t4, 3(t0)  # Cargo decoder_buffer[3]

    li  t5, 0       # b0 = 0
    li  t6, 0       # b1 = 0
    li  t7, 0       # b2 = 0
    li  t8, 0       # b3 = 0

    beq t1, t9, decoder_buffer_1
    # Si t1 no es igual a '=' entonces hay que decodificarlo
    # Para ello llamamos a decode_value
    # Guardamos los registros caller-saved
    sw  t0, 36($fp)
    sw  t1, 32($fp)
    sw  t2, 28($fp)
    sw  t3, 24($fp)
    sw  a0, 8($fp)
    # Le pasamos su argumento (el byte a decodificar)
    move a0, t1
    sw  a0, 0($fp)
    #
    jal decode_value
    # Recuperamos el byte decodificado
    move t5, v0
    # Recuperamos registros caller saved
    lw  t0, 36($fp)
    lw  t1, 32($fp)
    lw  t2, 28($fp)
    lw  t3, 24($fp)
    lw  a0, 8($fp)

decoder_buffer_1:
    beq t2, t9, decoder_buffer_2

    # Si t2 no es igual a '=' entonces hay que decodificarlo
    # Para ello llamamos a decode_value
    # Guardamos los registros caller-saved
    sw  t0, 36($fp)
    sw  t1, 32($fp)
    sw  t2, 28($fp)
    sw  t3, 24($fp)
    sw  a0, 8($fp)
    # Le pasamos su argumento (el byte a decodificar)
    move a0, t2
    sw  a0, 0($fp)
    #
    jal decode_value
    # Recuperamos el byte decodificado
    move t6, v0
    # Recuperamos registros caller saved
    lw  t0, 36($fp)
    lw  t1, 32($fp)
    lw  t2, 28($fp)
    lw  t3, 24($fp)
    lw  a0, 8($fp)

decoder_buffer_2:
    beq t3, t9, decoder_buffer_3

    # Si t2 no es igual a '=' entonces hay que decodificarlo
    # Para ello llamamos a decode_value
    # Guardamos los registros caller-saved
    sw  t0, 36($fp)
    sw  t1, 32($fp)
    sw  t2, 28($fp)
    sw  t3, 24($fp)
    sw  a0, 8($fp)
    # Le pasamos su argumento (el byte a decodificar)
    move a0, t3
    sw  a0, 0($fp)
    #
    jal decode_value
    # Recuperamos el byte decodificado
    move t7, v0
    # Recuperamos registros caller saved
    lw  t0, 36($fp)
    lw  t1, 32($fp)
    lw  t2, 28($fp)
    lw  t3, 24($fp)
    lw  a0, 8($fp)

decoder_buffer_3:
    beq t4, t9, end_decoder_buffer

    # Si t2 no es igual a '=' entonces hay que decodificarlo
    # Para ello llamamos a decode_value
    # Guardamos los registros caller-saved
    sw  t0, 36($fp)
    sw  t1, 32($fp)
    sw  t2, 28($fp)
    sw  t3, 24($fp)
    sw  a0, 8($fp)
    # Le pasamos su argumento (el byte a decodificar)
    move a0, t4
    sw  a0, 0($fp)
    #
    jal decode_value
    # Recuperamos el byte decodificado
    move t8, v0
    # Recuperamos registros caller saved
    lw  t0, 36($fp)
    lw  t1, 32($fp)
    lw  t2, 28($fp)
    lw  t3, 24($fp)
    lw  a0, 8($fp)

end_decoder_buffer:

    li  t0, INVALID_CHAR
    beq t5, t0, error_invalid_char
    beq t6, t0, error_invalid_char
    beq t7, t0, error_invalid_char
    beq t8, t0, error_invalid_char

    move    s0, t5
    sll s0, s0, 2
    
    move    s1, t6
    srl s1, s1, 4
    
    or  s2,  s0, s1

    move    s0, t6
    sll s0, s0, 4
    
    move    s1, t7
    srl s1, s1, 2

    or  s3,  s0, s1

    move    s0, t7
    sll s0, s0, 6
    
    move    s1, t8

    or  s4,  s0, s1


     # Imprimo por pantalla (DEBUG)
     # li  v0, SYS_write           # Cargo la syscall
     # li  a0, 1                   # Cargo el ofd
     # la  a1, debug_msg           # Cargo el decoder_buffer
     # li  a2, 15                  # Cargo el largo del decoder_buffer
     # syscall  


    li  t0, PADDING_ASCII
    bne t4, t0, write_no_padding

    bne t3, PADDING_ASCII, write_one_padding
    # Si llegamos aca termina con dos =

    sw  s2, 12($fp)
    # Imprimo por pantalla el caracter decodificado
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, 12($fp)             # Cargo el decoder_buffer
    li  a2, 1                   # Cargo el largo del decoder_buffer
    syscall  

    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_decoder_writing

    j end_decode_4bytes

write_one_padding:
    # Si llegamos aca termina con un =

    sw  s2, 12($fp)
    # Imprimo por pantalla el caracter decodificado
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, 12($fp)             # Cargo el decoder_buffer
    li  a2, 1                   # Cargo el largo del decoder_buffer
    syscall  

    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_decoder_writing

    sw  s3, 12($fp)
    # Imprimo por pantalla el caracter decodificado
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, 12($fp)             # Cargo el decoder_buffer
    li  a2, 1                   # Cargo el largo del decoder_buffer
    syscall  

    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_decoder_writing

    j end_decode_4bytes

write_no_padding:
    # Si llegamos aca termina sin =

    sw  s2, 12($fp)
    # Imprimo por pantalla el caracter decodificado
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, 12($fp)             # Cargo el decoder_buffer
    li  a2, 1                   # Cargo el largo del decoder_buffer
    syscall  

    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_decoder_writing

    sw  s3, 12($fp)
    # Imprimo por pantalla el caracter decodificado
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, 12($fp)             # Cargo el decoder_buffer
    li  a2, 1                   # Cargo el largo del decoder_buffer
    syscall  

    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_decoder_writing

    sw  s4, 12($fp)
    # Imprimo por pantalla el caracter decodificado
    li  v0, SYS_write           # Cargo la syscall
    lw  a0, 8($fp)              # Cargo el ofd
    la  a1, 12($fp)             # Cargo el decoder_buffer
    li  a2, 1                   # Cargo el largo del decoder_buffer
    syscall 

    # Si la syscall devolvio un numero negativo hubo error
    bltz    v0, error_decoder_writing

    j end_decode_4bytes

error_invalid_char:
    # Se detecto un caracter no perteneciente a base 64 en el decoder
    li v0, -1
    j end_decode_4bytes

error_decoder_writing:
    li  v0, -2
    j end_decode_4bytes

end_decode_4bytes:

    # FIN DE LA RUTINA | DESTRUCCIÓN DEL STACK FRAME

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


# FIN DE INICIALIZACIÓN DEL STACK FRAME | COMIENZO DE LA RUTINA

    li  t0, SLASH_ASCII
    beq a0, t0, decode_slash
    
    li  t0, PLUS_ASCII
    beq a0, t0, decode_plus

    li  t0, PADDING_ASCII
    beq a0, t0, decode_padding

    li t1, ZERO_ASCII  
    bltu a0, t1, invalid_byte # Si el byte a decodificar es < a '0' error.

    li t1, NINE_ASCII
    bleu a0, t1, deode_zero_nine # Si el byte a decodificar es >= 0 y <= 9

    li t1, UPPER_A_ASCII
    bltu a0, t1, invalid_byte # Si el byte a decodificar es < a 'A' error
    
    li t1, UPPER_Z_ASCII
    bleu a0, t1, decode_upper_a_z # Si el byte a decodificar es >= A y <= Z
    
    li t1, LOWER_A_ASCII
    bltu a0, t1, invalid_byte # Si el byte a decodificar es < a 'a' error

    li t1, LOWER_Z_ASCII
    bleu a0, t1, decode_lower_a_z # Si el byte a decodificar es >= a y <= z

    bgtu a0, t1, invalid_byte # Si el byte a decodificar es > z

decode_padding:
    li  v0, 0
    j end_decode_value

invalid_byte:
    li  v0, INVALID_CHAR
    j end_decode_value

decode_lower_a_z:
    li  t0, LOWER_A_ASCII
    subu a0, a0, t0         # byte = byte - 'a'
    li t0, DECODE_CONST_1
    addu a0, a0, t0         # byte = byte + 26
    move    v0, a0

    j end_decode_value

decode_upper_a_z:
    li  t0, UPPER_A_ASCII
    subu a0, a0, t0         # byte = byte - 'A'
    move    v0, a0
    j end_decode_value

deode_zero_nine:
    li  t0, ZERO_ASCII
    subu a0, a0, t0         # byte = byte - '0'
    li t0, DECODE_CONST_2
    addu a0, a0, t0         # byte = byte + 52
    move    v0, a0
    j end_decode_value

decode_plus:

    li  v0, PLUS_DECODED_VALUE
    j end_decode_value

decode_slash:

    li v0, SLASH_DECODED_VALUE
    j end_decode_value

end_decode_value:
# FIN DE LA RUTINA | DESTRUCCIÓN DEL STACK FRAME

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
encoder_buffer: .space ENCODER_BUFFER_SIZE
decoder_buffer: .space DECODER_BUFFER_SIZE

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

	.rdata			# segmento read-only data para los mensajes de error
	.globl errmsg
    .align 2
errmsg:	.word errmsg_0, errmsg_1, errmsg_2, errmsg_3, errmsg_4
	.size errmsg, 20

	.align 0		# alineacion 2^0

errmsg_0: .asciiz "No Error\n"
errmsg_1: .asciiz "Character not in Base64 Table.\n"
errmsg_2: .asciiz "Input stream for decoding is invalid.\n"
errmsg_3: .asciiz "Output error when writing stream.\n"
errmsg_4: .asciiz "Input error when reading stream.\n"
