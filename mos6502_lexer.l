%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int linea = 1;

enum mne_type {
    LDA, LDX, LDY, ADC, AND, CMP, CPX, CPY, EOR, ORA, SBC,
    STA, STX, STY, ASL, LSR, ROL, ROR, INC, DEC, BIT, JMP, JSR,
    BCC, BCS, BEQ, BMI, BNE, BPL, BVC, BVS
};

enum modo_type {
    inmediato, pagina_cero, pagina_cero_x, pagina_cero_y,
    absoluto, absoluto_x, absoluto_y,
    indirecto, indirecto_x, indirecto_y,
    acumulador, relativo
};

int mne = -1;
char mne_txt[4];

int buscar_opcode(int mne, int modo) {
    switch (mne) {
        case LDA: switch (modo) {
            case inmediato: return 0xA9;   case pagina_cero: return 0xA5;
            case pagina_cero_x: return 0xB5; case absoluto: return 0xAD;
            case absoluto_x: return 0xBD;  case absoluto_y: return 0xB9;
            case indirecto_x: return 0xA1; case indirecto_y: return 0xB1;
        } break;
        case ADC: switch (modo) {
            case inmediato: return 0x69;   case pagina_cero: return 0x65;
            case pagina_cero_x: return 0x75; case absoluto: return 0x6D;
            case absoluto_x: return 0x7D;  case absoluto_y: return 0x79;
            case indirecto_x: return 0x61; case indirecto_y: return 0x71;
        } break;
        case AND: switch (modo) {
            case inmediato: return 0x29;   case pagina_cero: return 0x25;
            case pagina_cero_x: return 0x35; case absoluto: return 0x2D;
            case absoluto_x: return 0x3D;  case absoluto_y: return 0x39;
            case indirecto_x: return 0x21; case indirecto_y: return 0x31;
        } break;
        case CMP: switch (modo) {
            case inmediato: return 0xC9;   case pagina_cero: return 0xC5;
            case pagina_cero_x: return 0xD5; case absoluto: return 0xCD;
            case absoluto_x: return 0xDD;  case absoluto_y: return 0xD9;
            case indirecto_x: return 0xC1; case indirecto_y: return 0xD1;
        } break;
        case EOR: switch (modo) {
            case inmediato: return 0x49;   case pagina_cero: return 0x45;
            case pagina_cero_x: return 0x55; case absoluto: return 0x4D;
            case absoluto_x: return 0x5D;  case absoluto_y: return 0x59;
            case indirecto_x: return 0x41; case indirecto_y: return 0x51;
        } break;
        case ORA: switch (modo) {
            case inmediato: return 0x09;   case pagina_cero: return 0x05;
            case pagina_cero_x: return 0x15; case absoluto: return 0x0D;
            case absoluto_x: return 0x1D;  case absoluto_y: return 0x19;
            case indirecto_x: return 0x01; case indirecto_y: return 0x11;
        } break;
        case SBC: switch (modo) {
            case inmediato: return 0xE9;   case pagina_cero: return 0xE5;
            case pagina_cero_x: return 0xF5; case absoluto: return 0xED;
            case absoluto_x: return 0xFD;  case absoluto_y: return 0xF9;
            case indirecto_x: return 0xE1; case indirecto_y: return 0xF1;
        } break;
        case LDX: switch (modo) {
            case inmediato: return 0xA2; case pagina_cero: return 0xA6;
            case pagina_cero_y: return 0xB6;
            case absoluto: return 0xAE; case absoluto_y: return 0xBE;
        } break;
        case LDY: switch (modo) {
            case inmediato: return 0xA0; case pagina_cero: return 0xA4;
            case pagina_cero_x: return 0xB4;
            case absoluto: return 0xAC; case absoluto_x: return 0xBC;
        } break;
        case CPX: switch (modo) {
            case inmediato: return 0xE0; case pagina_cero: return 0xE4;
            case absoluto: return 0xEC;
        } break;
        case CPY: switch (modo) {
            case inmediato: return 0xC0; case pagina_cero: return 0xC4;
            case absoluto: return 0xCC;
        } break;
        case STA: switch (modo) {
            case pagina_cero: return 0x85; case pagina_cero_x: return 0x95;
            case absoluto: return 0x8D;    case absoluto_x: return 0x9D;
            case absoluto_y: return 0x99;
            case indirecto_x: return 0x81; case indirecto_y: return 0x91;
        } break;
        case STX: switch (modo) {
            case pagina_cero: return 0x86; case pagina_cero_y: return 0x96;
            case absoluto: return 0x8E;
        } break;
        case STY: switch (modo) {
            case pagina_cero: return 0x84; case pagina_cero_x: return 0x94;
            case absoluto: return 0x8C;
        } break;
        case ASL: switch (modo) {
            case acumulador: return 0x0A; case pagina_cero: return 0x06;
            case pagina_cero_x: return 0x16;
            case absoluto: return 0x0E;   case absoluto_x: return 0x1E;
        } break;
        case LSR: switch (modo) {
            case acumulador: return 0x4A; case pagina_cero: return 0x46;
            case pagina_cero_x: return 0x56;
            case absoluto: return 0x4E;   case absoluto_x: return 0x5E;
        } break;
        case ROL: switch (modo) {
            case acumulador: return 0x2A; case pagina_cero: return 0x26;
            case pagina_cero_x: return 0x36;
            case absoluto: return 0x2E;   case absoluto_x: return 0x3E;
        } break;
        case ROR: switch (modo) {
            case acumulador: return 0x6A; case pagina_cero: return 0x66;
            case pagina_cero_x: return 0x76;
            case absoluto: return 0x6E;   case absoluto_x: return 0x7E;
        } break;
        case INC: switch (modo) {
            case pagina_cero: return 0xE6; case pagina_cero_x: return 0xF6;
            case absoluto: return 0xEE;    case absoluto_x: return 0xFE;
        } break;
        case DEC: switch (modo) {
            case pagina_cero: return 0xC6; case pagina_cero_x: return 0xD6;
            case absoluto: return 0xCE;    case absoluto_x: return 0xDE;
        } break;
        case BIT: switch (modo) {
            case pagina_cero: return 0x24; case absoluto: return 0x2C;
        } break;
        case JMP: switch (modo) {
            case absoluto: return 0x4C; case indirecto: return 0x6C;
        } break;
        case JSR: switch (modo) {
            case absoluto: return 0x20;
        } break;
        case BCC: return 0x90; case BCS: return 0xB0;
        case BEQ: return 0xF0; case BMI: return 0x30;
        case BNE: return 0xD0; case BPL: return 0x10;
        case BVC: return 0x50; case BVS: return 0x70;
    }
    return -1;
}

int es_branch(int mne) {
    return mne == BCC || mne == BCS || mne == BEQ || mne == BMI ||
           mne == BNE || mne == BPL || mne == BVC || mne == BVS;
}

// Tabla de simbolos: etiquetas (direcciones) y .define (valores)
struct simbolo { char nombre[32]; unsigned int valor; };
struct simbolo etiquetas[128];
int n_etiquetas = 0;
struct simbolo defines[64];
int n_defines = 0;

void definir_etiqueta(char *nombre, unsigned int direccion) {
    strncpy(etiquetas[n_etiquetas].nombre, nombre, 31);
    etiquetas[n_etiquetas].nombre[31] = '\0';
    etiquetas[n_etiquetas].valor = direccion;
    n_etiquetas++;
}

unsigned int buscar_etiqueta(char *nombre) {
    int i;
    for (i = 0; i < n_etiquetas; i++)
        if (strcmp(etiquetas[i].nombre, nombre) == 0) return etiquetas[i].valor;
    return 0;
}

void definir_valor(char *nombre, unsigned int valor) {
    strncpy(defines[n_defines].nombre, nombre, 31);
    defines[n_defines].nombre[31] = '\0';
    defines[n_defines].valor = valor;
    n_defines++;
}

unsigned int buscar_valor(char *nombre) {
    int i;
    for (i = 0; i < n_defines; i++)
        if (strcmp(defines[i].nombre, nombre) == 0) return defines[i].valor;
    return 0;
}

// pasada 1: solo arma la tabla de simbolos. pasada 2: genera los archivos de salida.
int pasada = 1;
unsigned int pc = 0;

FILE *f_hex;
FILE *f_lst;
int bloque_activo = 0;

int byte_n = 0;
unsigned char byte_buf[64];

void cerrar_bloque(void) {
    if (bloque_activo) { fprintf(f_hex, "\n"); bloque_activo = 0; }
}

void emitir(char *texto, unsigned char *bytes, int n) {
    int i;
    if (pasada == 2) {
        if (!bloque_activo) { fprintf(f_hex, "$%04X ", pc); bloque_activo = 1; }
        char hex[16] = "";
        char tmp[4];
        for (i = 0; i < n; i++) {
            fprintf(f_hex, "%02X", bytes[i]);
            sprintf(tmp, i == 0 ? "%02X" : " %02X", bytes[i]);
            strcat(hex, tmp);
        }
        fprintf(f_lst, "$%04X\t%s\t%s\n", pc, hex, texto);
    }
    pc += n;
}

void emitir_implicito(char *texto, unsigned char opcode) {
    unsigned char b[1] = { opcode };
    emitir(texto, b, 1);
}

%}

/* Opciones para que no generes funciones no utilizadas y evitar warnings */
%option noinput nounput yylineno
%x OPERANDO
%x BYTES

DIGITO	[0-9]

%%

[ \t]+                  { }
\n                       { linea++; }
;.*                      { }

\.org[ \t]+\$[0-9A-Fa-f]+[ \t\n;]   {
    yytext[yyleng-1] = '\0';
    unsigned int val;
    sscanf(strchr(yytext, '$') + 1, "%x", &val);
    if (pasada == 2) cerrar_bloque();
    pc = val;
}

\.define[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]+\$[0-9A-Fa-f]+[ \t\n;]   {
    yytext[yyleng-1] = '\0';
    char nombre[32], valtxt[16];
    unsigned int val;
    sscanf(yytext, ".define %31s %15s", nombre, valtxt);
    sscanf(valtxt + 1, "%x", &val);
    if (pasada == 1) definir_valor(nombre, val);
}

\.byte[ \t]+             { BEGIN(BYTES); byte_n = 0; }

<BYTES>\$[0-9A-Fa-f]{1,2}   {
    unsigned int val;
    sscanf(yytext + 1, "%x", &val);
    byte_buf[byte_n++] = (unsigned char) val;
    if (byte_n == 3) { emitir(".byte", byte_buf, 3); byte_n = 0; }
}
<BYTES>[ \t,]+           { }
<BYTES>;.*               {
    if (byte_n > 0) { emitir(".byte", byte_buf, byte_n); byte_n = 0; }
    BEGIN(INITIAL);
}
<BYTES>\n                {
    if (byte_n > 0) { emitir(".byte", byte_buf, byte_n); byte_n = 0; }
    linea++;
    BEGIN(INITIAL);
}

[A-Za-z_][A-Za-z0-9_]*:   {
    yytext[yyleng-1] = '\0';
    if (pasada == 1) definir_etiqueta(yytext, pc);
}

(?i:NOP)                 { emitir_implicito("NOP", 0xEA); }
(?i:BRK)                 { emitir_implicito("BRK", 0x00); }
(?i:INX)                 { emitir_implicito("INX", 0xE8); }
(?i:INY)                 { emitir_implicito("INY", 0xC8); }
(?i:CLC)                 { emitir_implicito("CLC", 0x18); }
(?i:CLD)                 { emitir_implicito("CLD", 0xD8); }
(?i:CLI)                 { emitir_implicito("CLI", 0x58); }
(?i:CLV)                 { emitir_implicito("CLV", 0xB8); }
(?i:DEX)                 { emitir_implicito("DEX", 0xCA); }
(?i:DEY)                 { emitir_implicito("DEY", 0x88); }
(?i:PHA)                 { emitir_implicito("PHA", 0x48); }
(?i:PHP)                 { emitir_implicito("PHP", 0x08); }
(?i:PLA)                 { emitir_implicito("PLA", 0x68); }
(?i:PLP)                 { emitir_implicito("PLP", 0x28); }
(?i:RTI)                 { emitir_implicito("RTI", 0x40); }
(?i:RTS)                 { emitir_implicito("RTS", 0x60); }
(?i:SEC)                 { emitir_implicito("SEC", 0x38); }
(?i:SED)                 { emitir_implicito("SED", 0xF8); }
(?i:SEI)                 { emitir_implicito("SEI", 0x78); }
(?i:TAX)                 { emitir_implicito("TAX", 0xAA); }
(?i:TAY)                 { emitir_implicito("TAY", 0xA8); }
(?i:TSX)                 { emitir_implicito("TSX", 0xBA); }
(?i:TXA)                 { emitir_implicito("TXA", 0x8A); }
(?i:TXS)                 { emitir_implicito("TXS", 0x9A); }
(?i:TYA)                 { emitir_implicito("TYA", 0x98); }

(?i:LDA)                 { strcpy(mne_txt, yytext); mne = LDA; BEGIN(OPERANDO); }
(?i:LDX)                 { strcpy(mne_txt, yytext); mne = LDX; BEGIN(OPERANDO); }
(?i:LDY)                 { strcpy(mne_txt, yytext); mne = LDY; BEGIN(OPERANDO); }
(?i:ADC)                 { strcpy(mne_txt, yytext); mne = ADC; BEGIN(OPERANDO); }
(?i:AND)                 { strcpy(mne_txt, yytext); mne = AND; BEGIN(OPERANDO); }
(?i:CMP)                 { strcpy(mne_txt, yytext); mne = CMP; BEGIN(OPERANDO); }
(?i:CPX)                 { strcpy(mne_txt, yytext); mne = CPX; BEGIN(OPERANDO); }
(?i:CPY)                 { strcpy(mne_txt, yytext); mne = CPY; BEGIN(OPERANDO); }
(?i:EOR)                 { strcpy(mne_txt, yytext); mne = EOR; BEGIN(OPERANDO); }
(?i:ORA)                 { strcpy(mne_txt, yytext); mne = ORA; BEGIN(OPERANDO); }
(?i:SBC)                 { strcpy(mne_txt, yytext); mne = SBC; BEGIN(OPERANDO); }
(?i:STA)                 { strcpy(mne_txt, yytext); mne = STA; BEGIN(OPERANDO); }
(?i:STX)                 { strcpy(mne_txt, yytext); mne = STX; BEGIN(OPERANDO); }
(?i:STY)                 { strcpy(mne_txt, yytext); mne = STY; BEGIN(OPERANDO); }
(?i:ASL)                 { strcpy(mne_txt, yytext); mne = ASL; BEGIN(OPERANDO); }
(?i:LSR)                 { strcpy(mne_txt, yytext); mne = LSR; BEGIN(OPERANDO); }
(?i:ROL)                 { strcpy(mne_txt, yytext); mne = ROL; BEGIN(OPERANDO); }
(?i:ROR)                 { strcpy(mne_txt, yytext); mne = ROR; BEGIN(OPERANDO); }
(?i:INC)                 { strcpy(mne_txt, yytext); mne = INC; BEGIN(OPERANDO); }
(?i:DEC)                 { strcpy(mne_txt, yytext); mne = DEC; BEGIN(OPERANDO); }
(?i:BIT)                 { strcpy(mne_txt, yytext); mne = BIT; BEGIN(OPERANDO); }
(?i:JMP)                 { strcpy(mne_txt, yytext); mne = JMP; BEGIN(OPERANDO); }
(?i:JSR)                 { strcpy(mne_txt, yytext); mne = JSR; BEGIN(OPERANDO); }
(?i:BCC)                 { strcpy(mne_txt, yytext); mne = BCC; BEGIN(OPERANDO); }
(?i:BCS)                 { strcpy(mne_txt, yytext); mne = BCS; BEGIN(OPERANDO); }
(?i:BEQ)                 { strcpy(mne_txt, yytext); mne = BEQ; BEGIN(OPERANDO); }
(?i:BMI)                 { strcpy(mne_txt, yytext); mne = BMI; BEGIN(OPERANDO); }
(?i:BNE)                 { strcpy(mne_txt, yytext); mne = BNE; BEGIN(OPERANDO); }
(?i:BPL)                 { strcpy(mne_txt, yytext); mne = BPL; BEGIN(OPERANDO); }
(?i:BVC)                 { strcpy(mne_txt, yytext); mne = BVC; BEGIN(OPERANDO); }
(?i:BVS)                 { strcpy(mne_txt, yytext); mne = BVS; BEGIN(OPERANDO); }

<OPERANDO>[ \t]+         { }

<OPERANDO>\(\$[0-9A-Fa-f]{1,2},[Xx]\)[ \t\n;]   { //indirecto,X
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext, "($%x", &val);
    unsigned char b[2] = { buscar_opcode(mne, indirecto_x), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s ($%02X,X)", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>\(\$[0-9A-Fa-f]{1,2}\),[Yy][ \t\n;]   { //indirecto,Y
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext, "($%x", &val);
    unsigned char b[2] = { buscar_opcode(mne, indirecto_y), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s ($%02X),Y", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>\(\$[0-9A-Fa-f]{4}\)[ \t\n;]   { //indirecto
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext, "($%x", &val);
    unsigned char b[3] = { buscar_opcode(mne, indirecto), val & 0xFF, (val >> 8) & 0xFF };
    char texto[32]; sprintf(texto, "%s ($%04X)", mne_txt, val);
    emitir(texto, b, 3);
    BEGIN(INITIAL);
}

<OPERANDO>\$[0-9A-Fa-f]{1,2},[Xx][ \t\n;]   { //pagina cero,X
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 1, "%x", &val);
    unsigned char b[2] = { buscar_opcode(mne, pagina_cero_x), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s $%02X,X", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>\$[0-9A-Fa-f]{1,2},[Yy][ \t\n;]   { //pagina cero,Y
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 1, "%x", &val);
    unsigned char b[2] = { buscar_opcode(mne, pagina_cero_y), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s $%02X,Y", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>\$[0-9A-Fa-f]{4},[Xx][ \t\n;]   { //absoluto,X
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 1, "%x", &val);
    unsigned char b[3] = { buscar_opcode(mne, absoluto_x), val & 0xFF, (val >> 8) & 0xFF };
    char texto[32]; sprintf(texto, "%s $%04X,X", mne_txt, val);
    emitir(texto, b, 3);
    BEGIN(INITIAL);
}

<OPERANDO>\$[0-9A-Fa-f]{4},[Yy][ \t\n;]   { //absoluto,Y
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 1, "%x", &val);
    unsigned char b[3] = { buscar_opcode(mne, absoluto_y), val & 0xFF, (val >> 8) & 0xFF };
    char texto[32]; sprintf(texto, "%s $%04X,Y", mne_txt, val);
    emitir(texto, b, 3);
    BEGIN(INITIAL);
}

<OPERANDO>[Aa][ \t\n;]   { //acumulador
    unsigned char b[1] = { buscar_opcode(mne, acumulador) };
    char texto[32]; sprintf(texto, "%s A", mne_txt);
    emitir(texto, b, 1);
    BEGIN(INITIAL);
}

<OPERANDO>#\$[0-9A-Fa-f]+[ \t\n,;]   { //inmediato
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 2, "%x", &val);
    unsigned char b[2] = { buscar_opcode(mne, inmediato), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s #$%02X", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>#[A-Za-z_][A-Za-z0-9_]*[ \t\n,;]   { //inmediato via .define
    yytext[yyleng-1] = '\0';
    unsigned int val = buscar_valor(yytext + 1);
    unsigned char b[2] = { buscar_opcode(mne, inmediato), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s #$%02X", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>\$[0-9A-Fa-f]{1,2}[ \t\n,;]   { //pagina cero
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 1, "%x", &val);
    unsigned char b[2] = { buscar_opcode(mne, pagina_cero), (unsigned char) val };
    char texto[32]; sprintf(texto, "%s $%02X", mne_txt, val);
    emitir(texto, b, 2);
    BEGIN(INITIAL);
}

<OPERANDO>\$[0-9A-Fa-f]{4}[ \t\n,;]   { //absoluto
    yytext[yyleng-1] = '\0';
    unsigned int val; sscanf(yytext + 1, "%x", &val);
    unsigned char b[3] = { buscar_opcode(mne, absoluto), val & 0xFF, (val >> 8) & 0xFF };
    char texto[32]; sprintf(texto, "%s $%04X", mne_txt, val);
    emitir(texto, b, 3);
    BEGIN(INITIAL);
}

<OPERANDO>[A-Za-z_][A-Za-z0-9_]*[ \t\n,;]   { //etiqueta (relativo o absoluto)
    yytext[yyleng-1] = '\0';
    unsigned int destino = buscar_etiqueta(yytext);
    char texto[32];
    if (es_branch(mne)) {
        unsigned char rel = (unsigned char) (destino - (pc + 2));
        unsigned char b[2] = { buscar_opcode(mne, relativo), rel };
        sprintf(texto, "%s $%04X", mne_txt, destino);
        emitir(texto, b, 2);
    } else {
        unsigned char b[3] = { buscar_opcode(mne, absoluto), destino & 0xFF, (destino >> 8) & 0xFF };
        sprintf(texto, "%s $%04X", mne_txt, destino);
        emitir(texto, b, 3);
    }
    BEGIN(INITIAL);
}

.                        { }

%%

int yywrap(void) { return 1; }

int main(int argc, char **argv) {
    char *fuente;
    long tam;

    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror("No se pudo abrir el archivo"); return 1; }
        fseek(f, 0, SEEK_END);
        tam = ftell(f);
        fseek(f, 0, SEEK_SET);
        fuente = malloc(tam + 1);
        tam = fread(fuente, 1, tam, f);
        fuente[tam] = '\0';
        fclose(f);
    } else {
        /* Si no se pasa el archivo lee de la entrada estandar (stdin) */
        size_t cap = 4096;
        int c;
        fuente = malloc(cap);
        tam = 0;
        while ((c = getchar()) != EOF) {
            if ((size_t) tam + 1 >= cap) { cap *= 2; fuente = realloc(fuente, cap); }
            fuente[tam++] = (char) c;
        }
        fuente[tam] = '\0';
    }

    f_hex = fopen("salida.hex", "w");
    f_lst = fopen("salida.lst", "w");

    pc = 0;
    yy_scan_string(fuente);
    yylex();

    pc = 0;
    yy_scan_string(fuente);
    yylex();
    cerrar_bloque();

    fclose(f_hex);
    fclose(f_lst);
    free(fuente);

    printf("Archivos generados: salida.hex, salida.lst\n");
    return 0;
}
