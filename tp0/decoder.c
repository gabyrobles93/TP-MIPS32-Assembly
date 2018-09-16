#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "decoder.h"

static int open_file(FILE ** file, const char * path);

int decoder_create(B64Decoder * decoder, const char * finput, const char * foutput) {
    if (!decoder) return -1;

    decoder->fin = NULL;
    decoder->fout = NULL;

    int code = 0;

    code = open_file(&(decoder->fin), finput);
    if (code == -1) {
        printf("Error al abrir el archivo %s. \n", finput);
    } else if (code == 1) {
        puts("El archivo de entrada sera la entrada estandar \n");
        decoder->fin = stdin;
    } else {
        printf("El archivo de entrada será %s \n", finput);
    }

    code = open_file(&(decoder->fout), foutput);
    if (code == -1) {
        printf("Error al abrir el archivo %s. \n", finput);
    } else if (code == 1) {
        puts("El archivo de salida sera la salida estandar \n");
        decoder->fout = stdout;
    } else {
        printf("El archivo de entrada será %s \n", foutput);
    }

    return 0;
}

int decoder_start(B64Decoder * decoder) {
    if (!decoder) return -1;

    uint8_t c = 0;

    while ((c = (uint8_t) fgetc(decoder->fin)) != (uint8_t) EOF) {
        printf("Caracter leído: %c \n", c);
        if (c >= 'A' && c <= 'Z') {
            c -= 'A';               // Obtengo el valor entero decodificado para el rango A-Z
        } else if (c >= 'a' && c<= 'z') {
            printf("el valor de c es %i \n", c);
            c = ((c - 'a') + 26);   // Obtengo el valor entero decodificado para el rango a-z
        } else if (c >= '0' && c <= '9') {
            c = ((c - '0') +  52);  // Obtengo el valor entero decofificado para el rango 0-9
        } else if (c == '+') {
            c = 62;                 // Obtengo el valor entero decodificado para el caracter +
        } else if (c == '/') {
            c = 63;                 // Obtengo el valor entero decodificado para el caracter /
        } else {
            puts("Error al decodificar: caracter fuera del código base 64.");
        }
        printf("Su valor entero decodificado es %i \n", c);
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