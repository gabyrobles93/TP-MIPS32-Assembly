#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <stdint.h>
#include "decoder.h"

extern const char* errmsg[];

static int base64_decode(unsigned int, unsigned int);

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
    //fprintf(stderr, "ifd decoder en C: %i\n", ifd);
    int ofd = fileno(decoder->fout);
    //fprintf(stderr, "ofd decoder en C: %i\n", ofd);

    int errcode = 0;
    errcode = base64_decode(ifd, ofd);
    if  (errcode) {
        fprintf(stderr, errmsg[errcode]);
    }

    return errcode;
}