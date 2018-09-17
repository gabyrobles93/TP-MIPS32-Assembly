#ifndef __BASE_64_H__
#define __BASE_64_H__

#include <stdint.h>

#define MAX_CHARS_PER_LINE 76

uint8_t base64[] = {
  'A', 'B', 'C', 'D', 'E', // 0 a 4
  'F', 'G', 'H', 'I', 'J', // 5 a 9
  'K', 'L', 'M', 'N', 'O', // 10 a 14
  'P', 'Q', 'R', 'S', 'T', // 15 a 19
  'U', 'V', 'W', 'X', 'Y', // 20 a 24
  'Z', 'a', 'b', 'c', 'd', // 25 a 29
  'e', 'f', 'g', 'h', 'i', // 30 a 34
  'j', 'k', 'l', 'm', 'n', // 35 a 39
  'o', 'p', 'q', 'r', 's', // 40 a 44
  't', 'u', 'v', 'w', 'x', // 45 a 49
  'y', 'z', '0', '1', '2', // 50 a 54
  '3', '4', '5', '6', '7', // 55 a 59
  '8', '9', '+', '/'       // 60 a 63 
};

#endif
