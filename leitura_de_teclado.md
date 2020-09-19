# Leitura de teclado

O [BASIC](basic) do MC1000 não tinha a função `INKEY$`, existente em outros microcomputadores, que verifica se há alguma tecla pressionada no momento e retorna o caracter correspondente, ou uma cadeia vazia ("") se não houver nenhuma tecla pressionada. Essa função é imprescindível para jogos de ação.

Mas mesmo que tivesse, o MC1000 tem uma característica que é um grande obstáculo à programação de jogos de ação em BASIC:  **o interpretador BASIC fica paralisado enquanto alguma tecla estiver pressionada!** 😲

De todo modo, existe uma variável do sistema que armazena o código ASCII da última tecla pressionada: o endereço 283 (KEY0).

Não é a mesma coisa que um  `INKEY$`, já que, por exemplo, não se pode saber se a pessoa apertou a mesma tecla mais de uma vez... mas pelo menos é melhor que a instrução  `INPUT`! 😌

Programinha-brinde: Move um caracter “#” pela tela usando as teclas \<W> (cima), \<S> (baixo), \<A> (esquerda) e \<D> (direita).

```
10  HOME
20 C = 15:L = 7
30 T$ = CHR$ (PEEK (283))
40 CC = (C + ABS (T$ = "D") - ABS (T$ = "A")) AND 31
50 LL = (L + ABS (T$ = "S") - ABS (T$ = "W")) AND 15
60  PRINT  CHR$ (27);"="; CHR$ (L); CHR$ (C + 32);" ";
70  PRINT  CHR$ (27);"="; CHR$ (LL); CHR$ (CC + 32);"#"; CHR$ (8);
80  POKE 910,0
90 C = CC : L = LL
100  GOTO 30
```

## Solução para permitir que a execução do BASIC continue mesmo com uma tecla pressionada

_(Desenvolvida por Ensjo em 19 de outubro de 2011.)_

O MC1000 tem três rotinas na ROM relacionadas com a leitura do teclado: SKEY?, KEY? e KEY.

*   SKEY? verifica se alguma tecla está sendo pressionada no momento.
*   KEY? chama SKEY? para checar se uma mesma tecla está sendo pressionada durante 7ms.
*   KEY chama KEY? e, se uma tecla for pressionada, **espera até que ela seja liberada**.

A causa do MC1000 travar quando uma tecla é pressionada é um `CALL KEY` no endereço $DDDC, em meio à interpretação do programa BASIC:

```
...
DD5A call KEY?        ; Alguma tecla pressionada?
DD5D or a
DD5E call nz, $dddc   ; Sim: capturar e tratar.
DD61 ...
...
DDDC call KEY         ; Captura a tecla E ESPERA SER LIBERADA.
DDDF cp $13           ; É CTRL+S?
DDE1 jp nz, $de0b     ; (etc.)
...
```

A ideia é dar um jeito de impedir que essa chamada seja feita.

A rotina KEY? chama a rotina SKEY?, que por sua vez chama dois _hooks_ em RAM:

*   O primeiro _hook_ (JOB, no endereço $0120) está livre. Ele tem apenas uma instrução `RET` ($C9) do Z80.
*   O segundo _hook_ (JOBM, no endereço $0130) por padrão está associado à rotina de piscamento do cursor.

Vamos então usar o _hook_ JOB. Quando ele é atingido a partir da instrução `CALL KEY?` no endereço $DD5A, a pilha do Z80 contém:

| Endereço | Valor | Significado |
| :------: | :---: | ----------- |
| SP | $C385 | Endereço para retorno a SKEY? ao final da execução do _hook_. |
| SP+2 | ???? | Valor de BC salvo com `PUSH` em SKEY?. |
| SP+4 | ???? | Valor de DE salvo com `PUSH` em SKEY?. |
| SP+6 | ???? | Valor de HL salvo com `PUSH` em SKEY?. |
| SP+8 | $C353 | Endereço para retorno a KEY? ao final da execução de SKEY?. |
| SP+10 | ???? | Valor de BC salvo com `PUSH` em KEY?. |
| SP+12 | ???? | Valor de DE salvo com `PUSH` em KEY?. |
| SP+14 | $DD5D | Endereço para retorno ao interpretador BASIC ao final da execução de KEY?. |

O que vamos fazer é examinar o conteúdo de SP+14 e ver se temos lá o endereço $DD5D. Se for este o caso, sabemos que estamos no ponto “problemático” da ROM, perto da rotina que vai “congelar” o BASIC até a liberação da tecla pressionada. Então vamos modificar o endereço armazenado em SP+8 para que o controle não volte para KEY? ao final de SKEY?, mas vá para uma rotina própria que vai decidir o que fazer. Se o usuário não estiver pressionando tecla nenhuma, o controle deverá retornar para $DD61. Se o usuário estiver apertando alguma tecla, colocamos seu código no registrador A e chamamos a rotina $DDDF (pulando a famigerada instrução `CALL KEY`) antes de retornar o controle para $DD61.

A rotina foi projetada para ser inserida com `POKE`s em uma linha `REM`, que deve ser a primeira do programa (vide abaixo).

```
key0:   equ $011b
job:    equ $0120
resto:  equ $dd61
teclap: equ $dddf
 
        org $03da
 
init:
; Direciona o hook JOB (chamado em SKEY?) para a rotina "checa".
        ld hl,checa
        ld (job+1),hl
        ld a,$c3
        ld (job),a
        ret
 
checa:
; Verifica se estamos em meio ao CALL KEY? feito em #DD5A.
        push ix
        ld ix,$ffff ; Estas duas linhas substituem ld ix,$0000.
        inc ix      ; Não pode haver byte $00 na linha REM.
        add ix,sp
        ld a,$5d
        cp (ix+16)
        jr nz,sai
        ld a,$dd
        cp (ix+17)
        jr nz,sai
; Sim: Modifica a pilha do Z80 para que, ao final da
; rotina SKEY?, o controle não volte para KEY?, mas
; para nossa rotina personalizada "desvia".
        push hl
        ld hl,desvia
        ld (ix+10),l
        ld (ix+11),h
        pop hl
sai:
        pop ix
        ret
 
desvia:
; Restaura pilha e registradores como estariam
; ao final da execução de KEY?, e desvia
; para os pontos apropriados do interpretador
; BASIC, evitando o CALL KEY em #DDDC.
        pop bc ; Desempilha valores empilhados por KEY?
        pop de
 
        inc sp ; Descarta o ponto de retorno original.
        inc sp
 
        ld (key0+2),a ; FUNCIONALIDADE ADICIONAL:
                      ; Salva em KEY0 + 2 a informação sobre se
                      ; uma tecla foi pressionada (#FF) ou não (#00).
        or a
 
        ld a,(key0)   ; Copia código da tecla em KEY0 + 1.
        ld (key0+1),a ; (É algo que a rotina KEY? faz.)
 
        call nz,teclap ; Se tecla pressionada, chama rotina
                       ; de tratamento situada logo depois a problemática
                       ; instrução CALL KEY.
        jp resto       ; Retorna para o interpretador BASIC.
```

Eis abaixo o início de um programa em BASIC. As linhas de 1 a 6 “instalam” o código acima em uma linha `REM`, que deve ser a primeira do programa e ter 70 caracteres. A linha 7 ativa o programa.

```
0  REM --------10--------20--------30--------40--------50--------60--------70
1  DATA 33,230,3,34,33,1
2  DATA 62,195,50,32,1,201,221,229,221,33,255,255,221,35,221,57
3  DATA 62,93,221,190,16,32,18,62,221,221,190,17,32,11,229,33
4  DATA 12,4,221,117,10,221,116,11,225,221,225,201,193,209,51,51
5  DATA 50,29,1,183,58,27,1,50,28,1,196,223,221,195,97,221
6  FOR I = 0 TO 69: READ B: POKE 986 + I,B: NEXT I
7  CALL 986
```

As linhas de 1 a 6 podem até ser apagadas depois da primeira execução, pois então o programa em código de máquina já estará instalado na linha `REM`.

Pode-se também apenas digitar a linha 0 com 70 caracteres e a instrução `CALL 986`, e adicionar o programa em código de máquina manualmente via `DEBUG`:

```
03DA 21 E6 03 22 21 01
03E0 3E C3 32 20 01 C9 DD E5 DD 21 FF FF DD 23 DD 39
03F0 3E 5D DD BE 10 20 12 3E DD DD BE 11 20 0B E5 21
0400 0C 04 DD 75 0A DD 74 0B E1 DD E1 C9 C1 D1 33 33
0410 32 1D 01 B7 3A 1B 01 32 1C 01 C4 DF DD C3 61 DD
```

Uma funcionalidade adicional desta rotina é salvar na posição de memória KEY0+2 ($011D / 285) a indicação sobre se uma tecla está sendo pressionada ou não. Se não estiver, `PEEK(285)` retorna 0; se estiver, retorna 255.

Agora a função  `INKEY$`  dos outros micros pode ser implementada assim:

```
I$ = "": IF PEEK (285) THEN I$ =  CHR$ ( PEEK (283))
```

Vamos reescrever o programa no início desta página. Digita as linhas 0 a 7 e acrescenta:

```
...
10  HOME
20 C = 15:L = 7
30 T$ = "": IF  PEEK (285) THEN T$ =  CHR$ ( PEEK (283))
40 CC = (C + ABS (T$ = "D") - ABS (T$ = "A")) AND 31
50 LL = (L + ABS (T$ = "S") - ABS (T$ = "W")) AND 15
60  PRINT  CHR$ (27);"="; CHR$ (L); CHR$ (C + 32);" ";
70  PRINT  CHR$ (27);"="; CHR$ (LL); CHR$ (CC + 32);"#"; CHR$ (8);
80  POKE 910,0
90 C = CC : L = LL
100  GOTO 30
```

Executa ambos os programas e sente a diferença.

* * *

_(Nova versão desenvolvida em 2 de julho de 2015.)_

Esta é uma versão da rotina para se localizar na parte alta da VRAM, na área de 256 bytes que o MC1000 reserva para o usuário no final da RAM.

```
key0:   equ $011b
keysw:  equ $012e
resto:  equ $dd61
teclap: equ $dddf

; Para ativar: Configurar hook JOB ($0120) com um jump para "checa".

        .org $3f00
 
checa:
; Verifica se estamos em meio ao CALL KEY? feito em #DD5A.
        ld hl,+14
        add hl,sp
        ld a,(hl)
        cp $5d
        ret nz
        inc hl
        ld a,(hl)
        cp $dd
        ret nz
; Sim: Modifica a pilha do Z80 para que, ao final da
; rotina SKEY?, o controle não volte para KEY?, mas
; para nossa rotina personalizada "desvia".
		ld hl,+8
        add hl,sp
        ld de,desvia
        ld (hl),e
        inc hl
        ld (hl),d
        ret

desvia:
; Restaura pilha e registradores como estariam
; ao final da execução de KEY?, e desvia
; para os pontos apropriados do interpretador
; BASIC, evitando o CALL KEY em #DDDC.
        pop bc ; Desempilha valores empilhados por KEY?
        pop de

        inc sp ; Descarta o ponto de retorno original.
        inc sp
 
        ld (key0+2),a ; FUNCIONALIDADE ADICIONAL:
                      ; Registra em KEY0+2 a informação sobre se
                      ; uma tecla foi pressionada (#FF) ou não (#00).
        or a
 
        ld a,(key0)   ; Copia código da tecla em KEY0 + 1.
        ld (key0+1),a ; (É algo que a rotina KEY? faz.)
 
        call nz,teclap ; Se tecla pressionada, chama rotina
                       ; de tratamento situada logo depois a problemática
                       ; instrução CALL KEY.
        jp resto       ; Retorna para o interpretador BASIC.
```

Eis um programa BASIC que insere a rotina na memória e o ativa:

```
1  RESTORE 2:A0 =  PEEK (914) + 256 *  PEEK (915) + 1:A1 = A0 + 18:A2 = A0 + 24: POKE 288,201: FOR A = A0 TO A0 + 43: READ B: POKE A,B: NEXT : POKE A1,A2 AND 255: POKE A1 + 1,A2 / 256: POKE 289,A0 AND 255: POKE 290,A0 / 256: POKE 288,195
2  DATA 33,14,,57,126,254,93,192,35,126,254,221,192,33,8,,57,17,24,63,115,35,114,201,193,209,51,51,50,29,1,183,58,27,1,50,28,1,196,223,221,195,97,221
```

A variável A0 calcula o início da área do usuário no topo da RAM, que varia conforme a memória do micro (por padrão, $3F00 / 16128 nas máquinas com 16KiB, e $BF00 / 48896 nas máquinas com 64KiB) e também pode ser redefinido pela instrução CLEAR.

Alternativamente, pode-se inserir a rotina em uma primeira linha  `REM`  do programa BASIC com 44 caracteres, substituindo o cálculo de A0 por  `A0 = PEEK (841) + 256 * PEEK (842) + 5`:

```
0  REM --------10--------20--------30--------40--44
1  RESTORE 2:A0 =  PEEK (841) + 256 *  PEEK (842) + 5:A1 = A0 + 18:A2 = A0 + 24: POKE 288,201: FOR A = A0 TO A0 + 43: READ B: POKE A,B: NEXT : POKE A1,A2 AND 255: POKE A1 + 1,A2 / 256: POKE 289,A0 AND 255: POKE 290,A0 / 256: POKE 288,195
2  DATA 33,14,,57,126,254,93,192,35,126,254,221,192,33,8,,57,17,24,63,115,35,114,201,193,209,51,51,50,29,1,183,58,27,1,50,28,1,196,223,221,195,97,221
```

Ainda outra possibilidade é colocá-la num espaço no início da RAM (a partir de $003b / 59).

```
1  RESTORE 2:A0 = 59:A1 = A0 + 18:A2 = A0 + 24: POKE 288,201: FOR A = A0 TO A0 + 43: READ B: POKE A,B: NEXT : POKE A1,A2 AND 255: POKE A1 + 1,A2 / 256: POKE 289,A0 AND 255: POKE 290,A0 / 256: POKE 288,195
2  DATA 33,14,,57,126,254,93,192,35,126,254,221,192,33,8,,57,17,24,63,115,35,114,201,193,209,51,51,50,29,1,183,58,27,1,50,28,1,196,223,221,195,97,221
```