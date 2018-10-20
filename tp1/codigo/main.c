#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <getopt.h>
#include <stdbool.h>
#include <unistd.h>
#include "options.h"
#include "encoder.h"
#include "decoder.h"

typedef enum {
  EXEC_MODE_ENCODE,
  EXEC_MODE_DECODE,
} exec_mode_t;

FILE * open_infile(const char * path) {
	//fprintf(stderr, "Opening input file %s\n", path);
    return fopen(path, "rb");
}

FILE * open_outfile(const char * path) {
	//fprintf(stderr, "Opening output file %s\n", path);
    return fopen(path, "wt");
}

int main (int argc, char ** argv) {
    FILE * fin = NULL; 						// Default is stdin
    FILE * fout = NULL; 					// Default is stdout
	exec_mode_t mode = EXEC_MODE_ENCODE; 	// Default is encode
    int c;

    static struct option long_options[] = {
		{"version", no_argument, 0, 'V'},
		{"help", no_argument, 0, 'h'},
		{"input", required_argument, 0, 'i'},
		{"output", required_argument, 0, 'o'},
		{"action", optional_argument, 0, 'a'},
		{0, 0, 0, 0}
	};

    int option_index = 0;
	while ((c = getopt_long(argc, argv, "Vhi:o:a:", long_options, &option_index)) != -1) {
		switch (c) {
			case 'V':
				version();
				return EXIT_SUCCESS;

			case 'h':
				help();
				return EXIT_SUCCESS;

			case 'i':
				if (strcmp(optarg, "-") != 0) {
					fin = open_infile(optarg);
					if (!fin) {
						fprintf(stderr, "Can not open input file '%s'\n", optarg);
						return EXIT_FAILURE;
					}
				}
				
				break;

			case 'o':
				if (strcmp(optarg, "-") != 0) {
					fout = open_outfile(optarg);
					if (!fout) {
						fprintf(stderr, "Can not open output file '%s'\n", optarg);
						return EXIT_FAILURE;
					}
				}
				break;

			case 'a':
				if (optarg) {
					if (strcmp(optarg,"decode") == 0) {
						mode = EXEC_MODE_DECODE;
						break;
					}

					if (strcmp(optarg,"encode") == 0) {
						mode = EXEC_MODE_ENCODE;
						break;
					}

					fprintf(stderr, "Unknown action '%s'\n", optarg);
					fprintf(stderr, "Execute tp0 -h for help\n");
					return EXIT_FAILURE;
				}

			default:
				fprintf(stderr, "Unknown option '%c'\n", c);
				fprintf(stderr, "Execute tp0 -h for help\n");
				return EXIT_FAILURE;
		}
	}
	
	
       
    
	if (mode == EXEC_MODE_ENCODE) {
		//fprintf(stderr, "Encode mode\n");
		B64_encoder_t encoder;
		B64_encoder_create(&encoder, fin, fout);
		// fprintf(stderr, "Encode created\n");
		B64_encoder_start(&encoder);
		// fprintf(stderr, "Finish encoding\n");

		if (fin) {
			fclose(fin);
		}
		
		if (fout) {
			fclose(fout);
		}	
	} 
	
	if (mode == EXEC_MODE_DECODE) {
		//fprintf(stderr, "Decode mode\n");
		B64Decoder decoder;
		if (decoder_create(& decoder, fin, fout)) {
			fprintf(stderr, "Fail creating decoder\n");
			return EXIT_FAILURE;
		}

		if (decoder_start(&decoder)) {
			return EXIT_FAILURE;
		}

		if (fin) {
			fclose(fin);
		}
		
		if (fout) {
			fclose(fout);
		}
	}

	if (!fout) {
		// Si la salida es estandar
		// imprimimos un \n final
		// puts("");
	}

	return EXIT_SUCCESS;
}
