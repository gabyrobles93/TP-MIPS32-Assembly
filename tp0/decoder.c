#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "decoder.h"

int decoder_create(B64Decoder * decoder, const char * finput, const char * foutput) {
    decoder->fin = NULL;
    decoder->fout = NULL;
    decoder->std_in = false;
    decoder->std_out = false;

    int code = 0;

    code = open_file(&(decoder->fin), finput);
    if (code == -1) {
        printf("Error al abrir el archivo %s. \n", finput);
    } else if (code == 1) {
        puts("El archivo de entrada sera la entrada estandar \n");
        decoder->std_in = true;
    } else {
        printf("El archivo de entrada será %s \n", finput);
    }

    code = open_file(&(decoder->fout), foutput);
    if (code == -1) {
        printf("Error al abrir el archivo %s. \n", finput);
    } else if (code == 1) {
        puts("El archivo de salida sera la salida estandar \n");
        decoder->std_out = true;
    } else {
        printf("El archivo de entrada será %s \n", foutput);
    }

    return 0;
}

int open_file(FILE ** file, const char * path) {
    if (!path || strcmp(path, "-") == 0) { //La entrada es la estándar
        return 1;
    } else {
        *file = fopen(path, "rb");
            if(!(*file)) {
            return -1;
        }
    }
    return 0;
}