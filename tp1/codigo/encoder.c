#include <string.h>
#include <arpa/inet.h>
#include <stdio.h>
#include "base64.h"
#include "encoder.h"

#define MASK_LAST_TWO 0x03
#define MASK_LAST_FOUR 0x0F
#define MASK_LAST_SIX 0x3F

static void base64_encode(unsigned int, unsigned int);

int B64_encoder_create(B64_encoder_t * enc, FILE * input, FILE * output) {
  enc->n_written = 0;

  if (input) {
    enc->_fin = input;
  } else {
    enc->_fin = stdin;
  }

  if (output) {
    enc->_fout = output;
  } else {
    enc->_fout = stdout;
  }

  return 0;
}

int B64_encoder_start(B64_encoder_t * enc) {
  
  int ifd = fileno(enc->_fin);
  //fprintf(stderr, "ifd en C: %i\n", ifd);
  int ofd = fileno(enc->_fout);
  //fprintf(stderr, "ofd en C: %i\n", ofd);

  base64_encode(ifd, ofd);
  return 0;

}
