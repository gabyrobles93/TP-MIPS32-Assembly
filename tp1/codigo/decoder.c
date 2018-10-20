#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <stdint.h>
#include "decoder.h"

#define INVALID_CHAR 0xFF

//static int decode_4bytes(B64Decoder * decoder, uint8_t * buffer);
//static uint8_t decode_value(uint8_t encoded_value);
//static int read_bytes(B64Decoder *, uint8_t *);
static void asm_decode(unsigned int, unsigned int);

int decoder_create(B64Decoder * decoder, FILE * finput, FILE * foutput) {
    if (!decoder) return -1;

    if (finput) {
        decoder->fin = finput;
    } else {
        decoder->fin = stdin;
    }

    if (foutput) {
        decoder->fout = foutput;
    } else {
        decoder->fout = stdout;
    }
    
    return 0;
}

int decoder_start(B64Decoder * decoder) {
    if (!decoder) return -1;

    int ifd = fileno(decoder->fin);
    fprintf(stderr, "ifd decoder en C: %i\n", ifd);
    int ofd = fileno(decoder->fout);
    fprintf(stderr, "ofd decoder en C: %i\n", ofd);

    asm_decode(ifd, ofd);

/*
    uint8_t buffer[4];
    int bytes_readed;

    bytes_readed = read_bytes(decoder, buffer);
    while (bytes_readed > 0) {
        if (bytes_readed < 4) {
            fprintf(stderr, "Lectura inválida en el archivo de entrada.\n");
            return -1;
        }

        if (decode_4bytes(decoder, buffer) < 0) {
            fprintf(stderr, "Error en la decodificación: se dectó un caracter inválido.\n");
            return -1;
        }

        bytes_readed = read_bytes(decoder, buffer);
    }
*/
    return 0;
}

/*
int decode_4bytes(B64Decoder * decoder, uint8_t * buffer) {
    if(!decoder || !buffer) return -1;

    uint8_t b0 = (buffer[0] == '=' ? 0 : decode_value(buffer[0]));
    uint8_t b1 = (buffer[1] == '=' ? 0 : decode_value(buffer[1]));
    uint8_t b2 = (buffer[2] == '=' ? 0 : decode_value(buffer[2]));
    uint8_t b3 = (buffer[3] == '=' ? 0 : decode_value(buffer[3]));

    if (b0 == INVALID_CHAR || b1 == INVALID_CHAR || b2 == INVALID_CHAR || b3 == INVALID_CHAR) {
        return -1;  //decode_value detecto un caracter inválido (no presente en la tabla)
    }

    uint8_t c1 = (b0 << 2) | (b1 >> 4);
    uint8_t c2 = (b1 << 4) | (b2 >> 2);
    uint8_t c3 = (((b2 << 6)) | b3);

    if (buffer[3] == '=' && buffer[2] != '=') { // Termina con un =
        putc(c1, decoder->fout);
        putc(c2, decoder->fout);
    } else if (buffer[3] == '=' && buffer[2] == '=') { // Termina con dos =
        putc(c1, decoder->fout);
    } else {
        putc(c1, decoder->fout);
        putc(c2, decoder->fout);
        putc(c3, decoder->fout);       
    }
    
    return 0;
}

uint8_t decode_value(uint8_t c) {
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
            return INVALID_CHAR;
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

int read_bytes(B64Decoder * decoder, uint8_t * buffer) {
    int i = 0;
    while (i < 4) {
        unsigned char n;
        size_t read;
        read = fread(&n, sizeof(unsigned char), 1, decoder->fin);
        if (read) {
            if (isspace(n)) {
                continue;
            } else {
                buffer[i] = n;
                i++;
            }
        } else {
            return -1;
        }
    }

    return i;
}

*/