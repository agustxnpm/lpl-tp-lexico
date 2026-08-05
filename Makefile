lexer: mos6502_lexer.l
	flex -o lex.yy.c mos6502_lexer.l
	gcc -Wall -o lexer lex.yy.c

.PHONY: run clean

run: lexer
	./lexer test1.asm

clean:
	rm -f lex.yy.c lexer
