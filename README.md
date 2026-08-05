# TP 1.1: Expresiones Regulares + Análisis Léxico

**Paradigmas y Lenguajes de Programación - UNPSJB**

---

## 1. Instalación

Se trabaja con **Flex** y **C**.

```bash
sudo apt install flex gcc make
```

Compilación sugerida (`Makefile`):

```makefile
lexer: mos6502_lexer.l
	flex -o lex.yy.c mos6502_lexer.l
	gcc -o lexer lex.yy.c

clean:
	rm -f lex.yy.c lexer
```
Para compilar: `make`

Para ejecutar: `./lexer ejemplos/test1.asm` o solo `./lexer` para evaluar desde la entrada estándar.

Manual: (https://westes.github.io/flex/manual)

## 1. Objetivo

El objetivo principal de este trabajo es que funcione como un repaso de la utilización de expresiones regulares (RegEx) y además como una introducción al análisis léxico de los lenguajes de programación.

Para poner en práctica estos conceptos se construirá un **ensablador** para assembler del MOS6502, al ser este un assembler sencillo y pequeño de fácil procesamiento.

Ejemplo 1:
```asm
; Programa principal en la página $06
.org $0600
  LDX #$00
  LDA $8000
loop:
  ADC #$A5
  STA $00,X
  INX
  BNE loop ; Verifica si finalizó
  BRK
; Datos almacenados ne la página $80
.org $8000
.byte $9F $8E $7D $6C
```
Se esperan dos salidas en archivos de texto.

Por un lado el pseudo-binario correspondiente al programa, según los opcodes y los operandos, incluyendo las direcciones para facilitar la lectura:

```
$0600 A200AD008069A58500E8D0F900
$8000 9F8E7D6C
```

Y por otro lado con el fin de verificar el ensamblado adecuado un archivo de tabla el siguiente formato:

```
$0600   A2 00       LDX #$00
$0602   AD 00 80    LDA $8000
$0605   69 A5       ADC #$A5
$0607   85 00       STA $00
$0609   E8          INX
$060A   D0 F9       BNE $0605
$060C   00          BRK
$8000   9F 8E 7D    .byte
$8003   6C          .byte
```
> Usar `\t` para separar las 3 columnas

## 2. Comentarios

Antes de reconocer instrucciones, ignorar los comentarios (inician con `;`):

- Línea completa de comentario.
- Comentario al final de una línea con instrucción.

```
; esto es un comentario de línea completa
LDA #$10   ; esto es un comentario al final de la línea
```

## 3. Mnemónicos y modos de direccionamiento

Implementar de forma incremental, un modo a la vez. Para cada paso, la especificación Lex debe reconocer el mnemónico junto con la sintaxis de su operando.

1. **Implícito** - sin operando. Ej: `NOP`, `TAX`, `INX`.
1. **Página cero (ZP)** - Ej: `LDA $10`.
1. **Absoluto** - Ej: `LDA $1000`.
1. **Inmediato** - Ej: `LDA #$10`.
1. **Hexa: `$10`, Binario: `%10101010` y Decimal: `10` 
1. **Indexados** de los anteriores:
   - Página cero indexado: `LDA $10,X` / `LDX $10,Y`
   - Absoluto indexado: `LDA $1000,X` / `LDA $1000,Y`
1. **Indirecto** / **indirecto indexado** - Ej: `JMP ($1000)`, `LDA ($10,X)`, `LDA ($10),Y`.
1. **Relativo** (saltos condicionales, operando es una etiqueta) - Ej: `BEQ loop`.

## 4. Etiquetas

- Reconocer la **definición** de una etiqueta (`loop:`).
- Reconocer la **referencia** a una etiqueta como operando (`JMP loop`, `BEQ loop`).
- Llevar un contador de dirección (program counter) y armar una **tabla de símbolos** (etiqueta → dirección).
- Resolver las referencias a etiquetas contra esa tabla.

## 5. Macros del ensamblador

Reconocer y procesar:

- `.define NOMBRE valor` - constante simbólica.
- `.byte valor1, valor2, ...` - datos crudos en memoria.
- `.org $direccion` - fija el contador de dirección.

## 6. Entrega final: el ensamblador

Programa que recibe un archivo fuente en assembly MOS6502 y genera un archivo de texto el hexdump como se indica al inicio correspondientes a cada instrucción, así como también la posibilidad de obtener el archivo binario puro como un archivo de texto en hexadecimal.

