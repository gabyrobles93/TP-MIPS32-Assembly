#ifndef __ENCODER_H__
#define __ENCODER_H__

#include <stdio.h>
#include <stdint.h>

#define BUFF_LEN 3

typedef struct {
  FILE * _fin;
  FILE * _fout;
  uint8_t _buff[BUFF_LEN];
} B64_encoder_t;

int B64_encoder_create(B64_encoder_t *, FILE *, FILE *);

int B64_encoder_start(B64_encoder_t *);

#endif