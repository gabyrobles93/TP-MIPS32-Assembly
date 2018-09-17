#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "decoder.h"

static int decode_4bytes(B64Decoder * decoder, uint8_t * buffer);
static int decode_value(uint8_t encoded_value);

int decoder_create(B64Decoder * decoder, FILE * finput, FILE * foutput) {
    if (!decoder || !finput || !foutput) return -1;

    decoder->fin = finput;
    decoder->fout = foutput;
    
    return 0;
}

int decoder_start(B64Decoder * decoder) {
    if (!decoder) return -1;

    uint8_t buffer[4];
    size_t bytes_readed;

    bytes_readed = fread(buffer, sizeof(uint8_t), 4, decoder->fin);
    while (bytes_readed > 0) {
        if (bytes_readed < 4) {
            fprintf(stderr, "Lectura inválida en el archivo de entrada.");
            return -1;
        }

        if (decode_4bytes(decoder, buffer) < 0) {
            fprintf(stderr, "Error en la decodificación: se dectó un caracter inválido.\n");
            return -1;
        }

        bytes_readed = fread(buffer, sizeof(uint8_t), 4, decoder->fin);
    }

    return 0;
}

int decode_4bytes(B64Decoder * decoder, uint8_t * buffer) {
    if(!decoder || !buffer) return -1;

    uint8_t b0 = (buffer[0] == '=' ? 0 : (uint8_t) decode_value(buffer[0]));
    uint8_t b1 = (buffer[1] == '=' ? 0 : (uint8_t) decode_value(buffer[1]));
    uint8_t b2 = (buffer[2] == '=' ? 0 : (uint8_t) decode_value(buffer[2]));
    uint8_t b3 = (buffer[3] == '=' ? 0 : (uint8_t) decode_value(buffer[3]));

    if (b0 < 0 || b1 < 0 || b2 < 0 || b3 < 0) {
        return -1;  //decode_value detecto un caracter inválido (no presente en la tabla)
    }

    uint8_t c1 = (b0 << 2) | (b1 >> 4);
    uint8_t c2 = (b1 << 4) | (b2 >> 2);
    uint8_t c3 = (((b2 << 6) & 0xc0) | b3);

    putc(c1, decoder->fout);
    putc(c2, decoder->fout);
    putc(c3, decoder->fout);

    return 0;
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
            return -1;
        }
    //printf("valor entero decodificado: %i \n", c);
    return c;
}

int decoder_destroy(B64Decoder * decoder) {
    if (!decoder) return -1;

    decoder->fin = NULL;
    decoder->fout = NULL;

    return 0;
}