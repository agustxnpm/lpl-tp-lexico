%{
#include <stdio.h>


int linea = 1;

%}

/* Opciones para que no generes funciones no utilizadas y evitar warnings */
%option noinput nounput

DIGITO	[0-9]

%%

{DIGITO}+		{ printf("\n<%s> Parece que es un número con muchos dígitos\n", yytext); }
.|\n    		{ ECHO; }

%%

int yywrap(void) { return 1; }

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("No se pudo abrir el archivo"); return 1; }
        yyin = f;
    }
    /* Si no se pasa el archivo lee de la entrada estandar (stdin) */
    
    yylex();
    return 0;
}
