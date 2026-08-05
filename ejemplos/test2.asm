; test2.asm - Programa de prueba CON etiquetas y saltos
; Un pequeno loop que cuenta de 0 a 9

inicio:
        LDA #$00
        TAX

loop:
        INX
        CPX #$0A
        BNE loop

        JMP inicio
