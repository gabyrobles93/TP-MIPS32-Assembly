# WARNING! EN ESTE EJERCICIO SE HICIERON ALGUNAS CHANCHADAS
# DADO QUE TODAVIA NO HABIAN INTRODUCIDO ALGUN TEMA EN LA MATERIA
# TOMAR CON PINZAS

# Tengo que reservar 20 bytes en el stack frame para esta función
# 4 y 4 de el size_t y el puntero
# 4 mas para el return address antes de llamar a strlen()
# 8 bytes mas para guardar los argumentos que me pasen en el stack (que son strv y len)
.text
.align 2
.ent count
.globl count

count:
    subu sp, sp, 20     # Reservo 20 bytes en el stack frame
    move t0, zero       # pseudo instrucción que carga 0 en t0
    sw t0, 0(sp)        # Almacenamos el primer valor en el stack (size_t c)
    sw ra, 8(sp)        # Guardamos el return address en el stack
while:
    bez a1, return      # Si el segundo argumento (len) es cero, salto a return
    lw t0, 0(a0)        # Guardo en t0 el char ** strv
    sw t0, 4(sp)        # Guardo en 4(sp) el valor de t0 (guardo en char * c el valor de char ** strv)
    addu a0, a0, 4      # Voy a la segunda posición del arreglo de punteros
    sw a0, 12(sp)       # Guardo en el stack el primer argumento de la función (strv)
    sw a1, 16(sp)       # Guardo en el stack el segundo argumento (len)
    lw a0, 4(sp)        # Guardo en a0 el valor de la variable local s, para que strlen tenga en a0 lo que tiene que tener
    jal strlen          # Invoco a strlen
    lw t0, 0(sp)        # Recupero del stack la variable C
    add t0, t0, v0      # Sumo lo que retorno strlen (Que por convención viene en v0)
    sw t0, 0(sp)
    lw a1, 16(sp)       # Traigo del stack a len
    lw a0, 12(sp)       # Traigo del stack a strv
    subu a1, a1, 1      # Le resto 1 a len
    sw a1, 16(sp)       # Guardo el nuevo valor de len en el stack
    b while
return:
    lw v0, 0(sp)        # Cargamos v0 con el valor de retorno, que es c (Está en 0(sp))
    lw ra, 8(sp)        # Recupero el return address que se hizo pelota en el medio de todo
    addu sp, sp, 20     # Restauro el stack
    end count

# Diagrama de stack:

# 16 | len      (size_t len)
# 12 | strv     (char ** strv)
# 8  | ra       (return address)
# 4  | s        (char * s)
# 0  | c        (size_t c)

# Obs, a diferencia de x86, MIPS tiene muchos mas registros, por lo tanto se aprovechan
# Para pasar parametros entre llamados de función, cosa que en x86 se hace por stack
