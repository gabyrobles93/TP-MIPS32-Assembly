/*
 * $Id: print_dnames.c,v 1.1 2008/04/22 03:11:50 hmasci Exp $
 *
 * 66.20 - Ejercicio A.8 (Patterson - Hennessy)
 */

#include <unistd.h>
#include "print_dnames.h"

static size_t mystrlen(const char* s);

static const char * name[10] = {
	"cero", "uno", "dos", "tres", "cuatro",
	"cinco", "seis", "siete", "ocho", "nueve"
};

void print_dnames(unsigned int n)
{
	int r;
	
	r = n % 10;
	n /= 10;

	if (n > 0) {
		print_dnames(n);
		write(1, " ", 1); /* separador */
	}

	/* escribimos el nombre a stdout (ojo: no chequeamos error) */
	write(1, name[r], mystrlen(name[r]));

	return;
}

static size_t mystrlen(const char* s)
{
	size_t i;
	for (i=0; s[i] != 0; i++);
	return i;
}
