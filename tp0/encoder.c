#include <string.h>
#include <arpa/inet.h>
#include "encoder.h"
#include "base64.h"

#define MASK_LAST_TWO 0x03
#define MASK_LAST_FOUR 0x0F
#define MASK_LAST_SIX 0x3F

int B64_encoder_create(B64_encoder_t * enc, FILE * input, FILE * output) {
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
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      memcpy(&index, &c2, 1);
      index = (index >> 4) | ((c1 & MASK_LAST_TWO) << 4);
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      memcpy(&index, &c3, 1);
      index = (index >> 6) | ((c2 & MASK_LAST_FOUR) << 2);
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      memcpy(&index, &c3, 1);
      index = (index & MASK_LAST_SIX);
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);
    }

    // 16 bits read
    if (read == BUFF_LEN - 1) {
      c1 = enc->_buff[0];
      c2 = enc->_buff[1];
      c3 = 0x00;

      memcpy(&index, &c1, 1);
      index = index >> 2;
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      memcpy(&index, &c2, 1);
      index = (index >> 4) | ((c1 & MASK_LAST_TWO) << 4);
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      memcpy(&index, &c3, 1);
      index = (index >> 6) | ((c2 & MASK_LAST_FOUR) << 2);
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      fwrite(&padding, sizeof(uint8_t), 1, enc->_fout);
    }

    // 8 bits read
    if (read == BUFF_LEN - 2) {
      c1 = enc->_buff[0];
      c2 = 0x00;
      c3 = 0x00;

      memcpy(&index, &c1, 1);
      index = index >> 2;
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      memcpy(&index, &c2, 1);
      index = (index >> 4) | ((c1 & MASK_LAST_TWO) << 4);
      fwrite(&base64[index], sizeof(uint8_t), 1, enc->_fout);

      fwrite(&padding, sizeof(uint8_t), 1, enc->_fout);
      fwrite(&padding, sizeof(uint8_t), 1, enc->_fout);
    }

    read = fread(enc->_buff, sizeof(unsigned char), BUFF_LEN, enc->_fin);
  }

  return 0;
}