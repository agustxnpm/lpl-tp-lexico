%{
#include <stdio.h>


int linea = 1;

enum mne_type {
    LDA = 0,
    LDX = 1,
    LDY = 2
};

enum modo_type {
    inmediato = 0,
    pagina_cero = 1,
    absoluto = 2
};

int mne = -1;  

// Matriz de opcodes: [mnemónico][modo] = opcode hexadecimal
int opcodes[3][3] = {
    // LDA
    {0xA9, 0xA5, 0xAD},
    // LDX
    {0xA2, 0xA6, 0xAE},
    // LDY
    {0xA0, 0xA4, 0xAC}
};

int buscar_opcode(enum mne_type mne, enum modo_type modo) {
    return opcodes[mne][modo];
}

%}

/* Opciones para que no generes funciones no utilizadas y evitar warnings */
%option noinput nounput yylineno

DIGITO	[0-9]




%%

{DIGITO}+		    {printf("%02X", atoi(yytext));}

\$[0-9A-Fa-f]+      {printf("HOLA SOY HEXA %s", yytext+1);}
%[01]+              {printf("hola soy binario %lX", strtol(yytext+1,NULL, 2));}


(?i:NOP)             {printf("EA\tNOP");}
(?i:BRK)             {printf("00\tBRK");}
(?i:INX)             {printf("E8\tINX");}
(?i:INY)             {printf("C8\tINY");}
 
(?i:LDA)             {mne = LDA;}
(?i:LDX)             {mne = LDX;}
(?i:LDY)             {mne = LDY;}


#\$[0-9A-Fa-f]+ {  //inmediato
    char *valor = yytext+2;
    int opcode = buscar_opcode(mne, inmediato);
    printf("%02X %s\n", opcode, valor);
}

\$[0-9A-Fa-f]{1,2}[ \t\n,;] { //zeropage
    char *valor = yytext + 1;
    int opcode = buscar_opcode(mne, pagina_cero);
    printf("%02X %s\n", opcode, valor);
}

\$[0-9A-Fa-f]{4}[ \t\n,;] { //absoluto
    char *valor = yytext + 1;
    int opcode = buscar_opcode(mne, absoluto);
    printf("%02X %s\n", opcode, valor);
}



;.*              { }

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
