#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "decoder.h"
#include <getopt.h>
#include <stdbool.h>
#include <unistd.h>
#include "options.h"
#include "encoder.h"

FILE * open_infile(const char * path) {
    FILE * file;
    if (!path || strcmp(path, "-") == 0) { //La entrada es la estándar
        return stdin;
    } else {
        file = fopen(path, "rb");
            if(!file) {
            return NULL;
        }
    }
    return file;
}

FILE * open_outfile(const char * path) {
    FILE * file;
    if (!path || strcmp(path, "-") == 0) { //La salida es la estándar
        return stdout;
    } else {
        file = fopen(path, "wt");
            if(!file) {
            return NULL;
        }
    }
    return file;
}

int main (int argc, char ** argv) {

    char* inputBuffer = NULL;
    bool encode64 = true; 
    bool stdinB = true;
    bool stdoutB = true;
    char* output = NULL;
    FILE * fin = NULL;
    FILE * fout = NULL;
    char* outputFileName = NULL;
    char* inputFileName = NULL;
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
                c = getopt_long (argc, argv, "Vhi:o:a:",
                long_options, &option_index);
                
                switch (c) {
                        case 'V':
                                version();
                                break;
                        case 'h':
                                help();
                                break;
                        case 'i':
                                stdinB = false;
                                strcpy(&inputFileName,optarg); 
                                break;
                        case 'o':
                                stdoutB = false;
                                strcpy(&outputFileName,optarg);
                                break;
                        case 'a':
				if(strcmp(optarg,"decode") == 0){
                                        encode64 = false;
                                }
				break;
                        default:
                                abort();
           }
       
    
    if (encode64){

	B64_encoder_t encoder;

	if (argc == 3) { // No se bien cuantos argumentos tienen que ser, pero es lo que creeria para cuando el input para el coder es por stdin y el resultado se muetra en pantalla
		B64_encoder_create(&encoder, stdin, stdout); 
	} else if (argc == 5) {
		fin = open_infile(inputFileName);
		if (!fin) {
	            fprintf(stderr, "Error al abrir el archivo de entrada.\n");
	            return -1;
	        }
	}else if (argc == 7) { // este es el unico caso que estuve probando, en teoria yo flasho que es el caso donde le pasasmos tanto el input file como el output file, se queda sin hacer nada
|		fin = open_infile(inputFileName);
		if (!fin) {
	            fprintf(stderr, "Error al abrir el archivo de entrada.\n");
	            return -1;
	        }
	        fout = open_outfile(outputFileName);
	        if (!fout) {
	            fprintf(stderr, "Error al abrir el archivo de salida.\n");
	            return -1;
 	       }        
	        B64_encoder_create(&encoder, fin, fout);
		} else {
	        fprintf(stderr, "Error de invocacion del programa.\n");
	        return -1;
	    }

	    if (B64_encoder_start(&encoder) < 0) {
	       fprintf(stderr, "El decoder finalizó con errores.\n");
	    }
    
	    if (fin != stdin) {
	        fclose(fin);
	    }

	    if (fout != stdout) {
	        fclose(fout);
	    }
	    return 0;
        }else{

	    B64Decoder decoder;

	    /* Validacion de argumentos y creación del decoder */
	    if (argc == 1) {
	        decoder_create(& decoder, stdin, stdout);
	    } else if (argc == 2) {
	        fin = open_infile(argv[1]);
	        if (!fin) {
	            fprintf(stderr, "Error al abrir el archivo de entrada.\n");
	            return -1;
	        }
	        decoder_create(&decoder, fin, stdout);
	    } else if (argc == 3) {
	        fin = open_infile(argv[1]);
	        if (!fin) {
	            fprintf(stderr, "Error al abrir el archivo de entrada.\n");
	            return -1;
	        }
	        fout = open_outfile(argv[2]);
	        if (!fout) {
	            fprintf(stderr, "Error al abrir el archivo de salida.\n");
	            return -1;
 	       }        
	        decoder_create(&decoder, fin, fout);
	    } else {
	        fprintf(stderr, "Error de invocacion del programa.\n");
	        return -1;
	    }

	    if (decoder_start(&decoder) < 0) {
	       fprintf(stderr, "El decoder finalizó con errores.\n");
	    }
    
	    decoder_destroy(&decoder);

	    if (fin != stdin) {
	        fclose(fin);
	    }

	    if (fout != stdout) {
	        fclose(fout);
	    }

	    return 0;
	}
}
