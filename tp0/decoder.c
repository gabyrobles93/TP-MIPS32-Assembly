#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "decoder.h"

static int open_file(FILE ** file, const char * path);
static void decode_4byte(B64Decoder * decoder, uint8_t * buffer);
static void decode_3byte(B64Decoder * decoder, uint8_t * buffer);
static void decode_2byte(B64Decoder * decoder, uint8_t * buffer);
static void decode_1byte(B64Decoder * decoder, uint8_t * buffer);
static int decode_value(uint8_t encoded_value);

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

    uint8_t buffer[4];
    size_t bytes_readed;
    bytes_readed = fread(buffer, sizeof(uint8_t), 4, decoder->fin);
    if (bytes_readed < 0) {
        puts("Eror en la lectura del archivo.\n");
    }
    while (bytes_readed > 0) {
        if (bytes_readed == 4) {
            decode_4byte(decoder, buffer);
        } else if (bytes_readed == 3) {
            decode_3byte(decoder, buffer);
            return 0;
        } else if (bytes_readed == 2) {
            decode_2byte(decoder, buffer);
            return 0;
        } else if (bytes_readed == 1) {
            decode_1byte(decoder, buffer);
            return 0;
        } 
        bytes_readed = fread(buffer, sizeof(uint8_t), 4, decoder->fin);
        if (bytes_readed < 0) {
            puts("Error en la lectura del archivo.\n");
            return -1;
        }
    }

    return 0;
}

void decode_4byte(B64Decoder * decoder, uint8_t * buffer) {
    if(!decoder || !buffer) return;

    uint8_t b1 = (uint8_t) decode_value(buffer[0]);
    uint8_t b2 = (uint8_t) decode_value(buffer[1]);
    uint8_t b3 = (uint8_t) decode_value(buffer[2]);
    uint8_t b4 = (uint8_t) decode_value(buffer[3]);

    uint8_t c1 = (b1 << 2) | (b2 >> 4);
    uint8_t c2 = (b2 << 4) | (b3 >> 2);
    uint8_t c3 = (b3 << 6) | b4;

    putc(c1, decoder->fout);
    putc(c2, decoder->fout);
    putc(c3, decoder->fout);
}

void decode_3byte(B64Decoder * decoder, uint8_t * buffer) {

}

void decode_2byte(B64Decoder * decoder, uint8_t * buffer) {

}

void decode_1byte(B64Decoder * decoder, uint8_t * buffer) {

}


int decode_value(uint8_t c) {
        if (c >= 'A' && c <= 'Z') {
            c -= 'A';               // Obtengo el valor entero decodificado para el rango A-Z
        } else if (c >= 'a' && c<= 'z') {
            c = ((c - 'a') + 26);   // Obtengo el valor entero decodificado para el rango a-z
        } else if (c >= '0' && c <= '9') {
            c = ((c - '0') +  52);  // Obtengo el valor entero decofificado para el rango 0-9
        } else if (c == '+') {
            c = 62;                 // Obtengo el valor entero decodificado para el caracter +
        } else if (c == '/') {
            c = 63;                 // Obtengo el valor entero decodificado para el caracter /
        } else {
            puts("Error al decodificar: caracter fuera del código base 64.");
            return -1;
        }
    printf("valor entero decodificado: %i \n", c);
    return c;
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