# Assembly

Giovanni Nunes escreveu um artigo introdutório sobre o desenvolvimento em assembly para o MC1000. Para o exemplo ("Hello World") ele usou o assembler **[Pasmo](http://pasmo.speccy.org/)**: <https://giovannireisnunes.wordpress.com/2017/05/19/desenvolvimento-cruzado-no-mc-1000>

Para aqueles que optarem por [usar o SDCC (*Small Device C Compiler*) para programar em C para o MC1000](sdcc), há a opção de usar o assembler **sdasz80** e o linkador **sdldz80** que fazem parte do pacote do SDCC.

Eis um modelo de arquivo a usar:

```
        ; ==================================

        ; MODELO PARA PROGRAMA EM CÓDIGO DE MÁQUINA
        ; CARREGÁVEL NO MC-1000 VIA COMANDO LOAD.

        ; ==================================

        ; (1) Programa em BASIC que chama a porção em linguagem
        ; de máquina residente nos bytes após o fim do programa:

        ; 1  CALL 992

        .area   BASIC_CALL (ABS)

        .org    0x03d5

        .dw     endlinha2 ; Endereço do próximo registro de linha do programa em BASIC.
        .dw     0x0001 ; Número da linha do programa em BASIC.
        .db     0xa2 ; Token da palavra reservada "CALL".
        .ascii  "992" ; =0x03e0.
        .db     0x00 ; Fim da linha.
endlinha2:
        .dw     0x0000 ; Endereço do próximo registro de linha = 0, indicando fim do programa.

        ; ==================================

        ; (2) Programa em linguagem de máquina.

        ; Neste ponto estamos no endereço 0x3e0.

        .area   CODE (ABS)

        .org    0x03e0 ; =992.

        ; Reativa a impressão de caracteres que é desativada
        ; quando um programa BASIC sem nome (autoexecutável)
        ; é carregado.
        xor     a
        ld      (0x0344),a

        ; A partir daqui começa o programa propriamente dito.
        ld      hl,#ola_msg
        call    0xc018 ; MSG: Rotina da ROM que imprime uma string terminada em NUL.
        ret	; Retorna ao interpretador BASIC.
	
ola_msg:
        .ascii  "OLA MUNDO!"
        .db     0x0d,0x0a,0x00
```

Uma vez tendo composto o arquivo (como exemplo.z80, digamos), os passos são:

1.  [Compilar](https://manned.org/sdasz80) .Z80 gerando .REL:

    `sdasz80 -o exemplo.z80`

2.  [Linkar](https://manned.org/sdldz80.1) .REL gerando .IHX ([Intel HEX](https://en.wikipedia.org/wiki/Intel_HEX)):

    `sdldz80 -i exemplo.rel`

3.  [Converter](http://sourceforge.net/projects/hex2bin) .IHX em .BIN:

    `hex2bin exemplo.ihx`

4.  [Converter](cassete) .BIN em .WAV:

    `java MC1000CasTools -b exemplo.bin -wav`
