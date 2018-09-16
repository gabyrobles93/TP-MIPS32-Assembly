#ifndef __DECODER_H__
#define __DECODER_H__

#include <stdio.h>
#include <stdbool.h>

typedef struct {
    FILE * fin;
    FILE * fout;
}B64Decoder;

int decoder_create(B64Decoder * decoder, const char * finput, const char * foutput);
int decoder_start(B64Decoder * decoder);

#endif