#ifndef __DECODER_H__
#define __DECODER_H__

#include <stdio.h>
#include <stdbool.h>

typedef struct {
    FILE * fin;
    FILE * fout;
    bool std_in;
    bool std_out;
}B64Decoder;

int decoder_create(B64Decoder * decoder, const char * finput, const char * foutput);
int open_file(FILE ** file, const char * path);

#endif