; test1.asm - Programa de prueba SIN etiquetas
; Ejercita distintos modos de direccionamiento

        LDA #$10        ; inmediato
        STA $20         ; pagina cero
        LDA $1000       ; absoluto
        LDA $1000,X     ; absoluto,X
        LDA $10,X       ; pagina cero,X
        LDX $10,Y       ; pagina cero,Y
        LDA ($10,X)     ; indirecto indexado,X
        LDA ($10),Y     ; indirecto indexado,Y
        JMP ($1000)     ; indirecto
        ASL A           ; acumulador
        NOP             ; implicito
