#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "decoder.h"

FILE * open_infile(const char * path) {
    FILE * file;
    if (!path || strcmp(path, "-") == 0) { //La entrada es la estándar
        return stdin;
    } else {
        file = fopen(path, "rb");
            if(!file) {
            return NULL;
        }
    }
    return file;
}

FILE * open_outfile(const char * path) {
    FILE * file;
    if (!path || strcmp(path, "-") == 0) { //La salida es la estándar
        return stdout;
    } else {
        file = fopen(path, "wt");
            if(!file) {
            return NULL;
        }
    }
    return file;
}

int main (int argc, char ** argv) {

    B64Decoder decoder;
    FILE * fin = NULL;
    FILE * fout = NULL;

    /* Validacion de argumentos y creación del decoder */
    if (argc == 1) {
        decoder_create(&decoder, stdin, stdout);
    } else if (argc == 2) {
        fin = open_infile(argv[1]);
        if (!fin) {
            fprintf(stderr, "Error al abrir el archivo de entrada.\n");
            return -1;
        }
        decoder_create(&decoder, fin, stdout);
    } else if (argc == 3) {
        fin = open_infile(argv[1]);
        if (!fin) {
            fprintf(stderr, "Error al abrir el archivo de entrada.\n");
            return -1;
        }
        fout = open_outfile(argv[2]);
        if (!fout) {
            fprintf(stderr, "Error al abrir el archivo de salida.\n");
            return -1;
        }        
        decoder_create(&decoder, fin, fout);
    } else {
        fprintf(stderr, "Error de invocacion del programa");
    }

    if (decoder_start(&decoder) < 0) {
        fprintf(stderr, "El decoder finalizó con errores.\n");
    }
    
    decoder_destroy(&decoder);

    if (fin != stdin) {
        fclose(fin);
    }

    if (fout != stdout) {
        fclose(fout);
    }

    return 0;
}
