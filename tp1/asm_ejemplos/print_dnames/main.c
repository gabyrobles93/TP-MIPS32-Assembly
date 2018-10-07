/*
 * $Id: main.c,v 1.1 2008/04/22 03:11:50 hmasci Exp $
 *
 * 66.20 - Ejercicio A.8 (Patterson - Hennessy)
 */

#include <stdio.h>
#include "print_dnames.h"

int main(void)
{
	int n;

	printf("Ingrese entero positivo: ");
	scanf("%d", &n);

	if (n < 0) {
		printf("Error: el entero es negativo\n");
	}
	else {
		print_dnames(n);
		printf(".\n");
	}

	return 0;
}

