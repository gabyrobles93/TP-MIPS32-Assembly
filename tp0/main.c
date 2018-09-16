#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "decoder.h"

int main (int argc, char ** argv) {

    B64Decoder decoder;

    /* Validacion de argumentos y creación del decoder */
    if (argc == 1) {
        decoder_create(&decoder, NULL, NULL);
    } else if (argc == 2) {
        decoder_create(&decoder, argv[1], NULL);
    } else if (argc == 3) {
        decoder_create(&decoder, argv[1], argv[2]);
    } else {
        puts("Error de invocacion del programa");
    }

    decoder_start(&decoder);
    

    return 0;
}