#include <string.h>
#include <arpa/inet.h>
#include "base64.h"
#include "encoder.h"

#define MASK_LAST_TWO 0x03
#define MASK_LAST_FOUR 0x0F
#define MASK_LAST_SIX 0x3F

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
  
  uint8_t index = 0;
  unsigned char c1, c2, c3;
  char padding = '=';

  size_t read = fread(enc->_buff, sizeof(unsigned char), BUFF_LEN, enc->_fin);
  while (read) {
    // 24 bits read
    if (read == BUFF_LEN) {
      c1 = enc->_buff[0];
      c2 = enc->_buff[1];
      c3 = enc->_buff[2];

      memcpy(&index, &c1, 1);
      index = index >> 2;
      _B64_encoder_write(enc, &base64[index]);

      memcpy(&index, &c2, 1);
      index = (index >> 4) | ((c1 & MASK_LAST_TWO) << 4);
      _B64_encoder_write(enc, &base64[index]);

      memcpy(&index, &c3, 1);
      index = (index >> 6) | ((c2 & MASK_LAST_FOUR) << 2);
      _B64_encoder_write(enc, &base64[index]);

      memcpy(&index, &c3, 1);
      index = (index & MASK_LAST_SIX);
      _B64_encoder_write(enc, &base64[index]);
    }

    // 16 bits read
    if (read == BUFF_LEN - 1) {
      c1 = enc->_buff[0];
      c2 = enc->_buff[1];
      c3 = 0x00;

      memcpy(&index, &c1, 1);
      index = index >> 2;
      _B64_encoder_write(enc, &base64[index]);

      memcpy(&index, &c2, 1);
      index = (index >> 4) | ((c1 & MASK_LAST_TWO) << 4);
      _B64_encoder_write(enc, &base64[index]);

      memcpy(&index, &c3, 1);
      index = (index >> 6) | ((c2 & MASK_LAST_FOUR) << 2);
      _B64_encoder_write(enc, &base64[index]);

      _B64_encoder_write(enc, &padding);
    }

    // 8 bits read
    if (read == BUFF_LEN - 2) {
      c1 = enc->_buff[0];
      c2 = 0x00;
      c3 = 0x00;

      memcpy(&index, &c1, 1);
      index = index >> 2;
      _B64_encoder_write(enc, &base64[index]);

      memcpy(&index, &c2, 1);
      index = (index >> 4) | ((c1 & MASK_LAST_TWO) << 4);
      _B64_encoder_write(enc, &base64[index]);

      _B64_encoder_write(enc, &padding);
      _B64_encoder_write(enc, &padding);
    }

    read = fread(enc->_buff, sizeof(unsigned char), BUFF_LEN, enc->_fin);
  }

  return 0;
}

void _B64_encoder_write(B64_encoder_t * enc, const void * buff) {
  if (enc->n_written == MAX_CHARS_PER_LINE) {
    char endl = '\n';
    enc->n_written = 0;
    fwrite(&endl, sizeof(char), 1, enc->_fout);
  }

  fwrite(buff, sizeof(*buff), 1, enc->_fout);
  enc->n_written++;

  return;
}