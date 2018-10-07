.text
.align 2
.globl strlen
.ent strlen

strlen:
    subu sp, sp, 4          # Reservo una palabra en el stack (32 bits)
    addu t0, zero, zero     # Guardamos 0 (cero) en el registro general t0
    sw t0, 0(sp)            # Guarda 0 en esa palabra del stack (inicializa la variable n que cuenta el largo)
while:    
    lbu t1, 0(a0)           # Carga un byte sin signo (el primer byte apuntado por a0, a0 apunta al primer parámetro de la función)
    beq t1, zero, return    # Salta a return si el byte es 0 (fin de cadena)
    addu a0, a0, 1          # Avanza el puntero del primer argumento a otro caracter
    lw t0, 0(sp)            # Carga el valor de n en t0
    addu t0, t0, 1          # Escribe en t0 el valor de t0 + q
    sw t0, 0(sp)            # guarda en n el nuevo valor de t0
    b while
return:
    lw b0, 0(sp)            # cargo en b0 el valor de n
    addu sp, sp, 4          # sumo sin alarma de carry para restaurar el stack frame

    jr ra