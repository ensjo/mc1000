# Bugs

O exame da ROM do MC1000 revela algumas características que foram programadas, mas que não funcionam devido a erros de lógica.

Para cada erro apresenta-se um “patch”, um “remendo”, que poderia consertar o erro numa versão melhorada da ROM.

## Caracter de controle FF (`CHR$(12)`)

Pela programação na ROM, o caracter de controle FF deveria avançar o cursor, isto é, movê-lo uma coluna à direita; se estivesse no fim de uma linha, iria para o início da linha seguinte; e se estivesse no fim da tela, continuaria no mesmo lugar e um bip soaria para avisar da impossibilidade do cursor avançar.

Mas há um erro na rotina de verificação de fim de tela. A posição do cursor é subtraída em um (equivalendo a um movimento para a esquerda), e quando finalmente se soma um para fazê-lo mover-se à direita... o resultado é que o cursor não sai do lugar!

```
pc ← POSIÇÃO_DO_CURSOR
ft ← FIM_DA_TELA + 1
pc ← pc - 1
(deveria ser: ft ← ft - 1)
se pc = ft então
   produz bip
senão
   pc ← pc + 1
   POSIÇÃO_DO_CURSOR ← pc
fim se
```

Como efeito colateral, este bug inutilizou o uso das teclas \<H>, \<J>, \<K> e \<L> associadas a \<CTRL> para mover o cursor enquanto se digita uma linha. A lógica está toda implementada, e quando se pressiona \<CTRL>+\<L> a posição do cursor é até avançada no buffer de linha, mas não se move na tela.

### Patch

```
CA69  2B        DEC HL
```
- - -
```
CA69  1B        DEC DE
```

## Caracter de controle DEL (`CHR$(127)`)

DEL deveria mover o cursor para a esquerda, apagando (isto é, substituindo por espaço) o caracter que estivesse na posição do cursor. Mas uma verificação mal feita faz com que a porção de código que interpreta DEL como um caracter de controle nunca seja executada. Por isso ele acaba sendo interpretado como um caracter comum.

```
c ← CARACTER_A_IMPRIMIR
se c < 32 então
(deveria ser: se c < 32 ou c = 127 então)
   (interpreta caracteres de controle)
   se c = 7 então
      produz bip
   fim se
   (...)
   se c = 127 então
      (...)
   fim se
senão
   imprime c como um caracter comum
fim se
```

### Patch


```
C8BE  C2F9C8    JP      NZ,$C8F9
```
- - -
```
C8BE  C2F4C8    JP      NZ,$C8F4
```

## Posicionamento de cursor (`CHR$(27)`)

Usando `CHR$(27)` (ESC) é possível posicionar o cursor no MC1000. Para programar o cursor em modo de 32 colunas, dever-se-ia usar `CHR$(27);"=";CHR$(`*linha*`);CHR$(`*coluna*`)`. E em modo de 80 colunas, `CHR$(27);"=";CHR$(`*linha*`);CHR$(32+`*coluna*`)`.

Um erro faz com que o posicionamento de cursor para 32 colunas não funcione corretamente: o cursor é posicionado uma linha abaixo de onde deveria ficar.


```
li ← NÚMERO_DA_LINHA
co ← NÚMERO_DA_COLUNA
se co < 32 então
   (para 32 colunas)
   co ← co + 32
   (esta soma não deveria ser feita!)
senão
   (para 80 colunas)
   co ← co - 32
fim se
posiciona o cursor nas coordenadas (li,co)
```

### Como contornar

Use o posicionamento para 80 colunas (`CHR$(27);"=";CHR$(`*linha*`);CHR$(32+`*coluna*`)`). Ele funciona mesmo quando o vídeo está em 32 colunas.

### Patch

```
C994  C620      ADD     A,$20
```
- - -
```
C994  00        NOP
C995  00        NOP
```

## Instrução `SLOW`

O MC1000 tem um par de instruções não documentadas no manual de BASIC: `FAST` e `SLOW`. `FAST` (“rápido”) é o modo normal de execução do MC1000. O `SLOW` (“lento”) faz com que o computador adicione uma brevíssima pausa entre os comandos. Mas, por um erro de lógica, o comando não funciona. Primeiro ele verifica (corretamente) se não há nenhum parâmetro a seguir (se houver, ele produz erro de sintaxe, “?SN ERRO”); depois disso, ele “invade” a programação do comando SET, produzindo um erro de acordo com o modo de vídeo. Em modo TEXT ele produz erro de tipo incompatível (“?TI ERRO”); em modo gráfico (GR ou HGR) ele produz erro de falta de operando (“?FO ERRO”).

```
     FAST: x ← 0
FAST_SLOW: endereço de memória(864) ← x
           retorna
     SLOW: x ← 1
           (faltou: desvia para FAST_SLOW)
      SET: (...)
```

### Como contornar

É possível entrar em modo `SLOW` por meio da instrução `POKE 864,1`.

### Patch

Este patch exige alguns bytes do espaço não utilizado no fim da ROM.

```
D74D  22D2      DB      $D222

F563  FFFFFF    DB      $FF,$FF,$FF ; (Lixo no fim da ROM)
F566  FFFFFF    DB      $FF,$FF,$FF
```
- - -
```
D74D  63F5      DB      $F563

F563  C0        RET     NZ
F564  3E01      LD      A,$01
F566  C31ED2    JP      $D21E
```

## Cláusula `VTAB`

`VTAB` é uma cláusula da instrução `PRINT` não documentada no Manual do BASIC.

Deveria servir para posicionar o cursor verticalmente, mas não funciona por uma sucessão de erros na lógica que calcula a nova posição do cursor.

Tenta isto e vê o cursor desaparecer... 🙁

```
PRINT VTAB(12);
```

Para recuperar o cursor, digita (às cegas mesmo) o comando `HOME` seguido da tecla \<RETURN>, ou então pressiona \<CTRL>+\<↑>.

### Como contornar

Pode-se usar a sequência de escape para posicionamento do cursor, obtendo-se a coluna atual do cursor da variável de sistema *LCNT*: `PRINT CHR$(27);"=";CHR$(`*linha*`);CHR$(32+PEEK(349));`

### Patch

```
E141  210080    LD      HL,$8000
E144  ED52      SBC     HL,DE
E146  13        INC     DE
E147  01        DB      $01 ; "LD BC,..." (oculta as duas instruções seguintes)
E148  7B        LD      A,E
E149  3D        DEC     A
E14A  2803      JR      Z,$E14F
E14C  09        ADD     HL,BC
E14D  18FA      JR      $E149
```
- - -
```
E141  2A6301    LD      HL,($0163) ; SNAM = início da VRAM.
E144  ED5B1301  LD      DE,($0113) ; DLNG = largura da linha.
E148  04        INC     B ; parâmetro de VTAB() + 1.
E149  1801      JR      $E14C
E14B  19        ADD     HL,DE
E14C  10FD      DJNZ    $E14B
E14E  00        NOP
```

## Rotina *JSTICK*

Esta é uma rotina da ROM do MC1000 (no endereço $CC2C) voltada a permitir que um ou dois jogadores joguem compartilhando o teclado.

| Jogador  |  🡄   |  🡅   |  🡇   |  🡆   | Ação                          |
| :------: | :--: | :--: | :--: | :--: | :---------------------------- |
| Esquerda | \<A> | \<S> | \<D> | \<F> | \<Q> \<W> \<E> \<R> \<T>      |
| Direita  | \<K> | \<L> | \<;> | \<:> | \<I> \<O> \<P> \<↑> \<RETURN> |

A rotina traduz um código de tecla para um byte cujos bits indicam a qual dos controles ela corresponde, se algum.

A listagem desta rotina na ROM está no Manual de Referência, e vemos claramente que o erro surgiu por erro de digitação de um dos rótulos de desvio internos da rotina. Foi digitado “K6” em vez de “J6”, e por azar o rótulo “K6” existia em outro lugar da listagem, então o erro não foi detectado durante a compilação. O resultado foi um desvio para fora da rotina (para o endereço $C3FB em vez de $CC83), inutilizando-a. Eis a listagem original (em assembly 8080) na página 96:

```
LOC  OBJ      LINE         SOURCE  STATEMENT
[...]
CC59 FE41     2175         CPI     'A'
CC5B C260CC   2176         JNZ     J1
CC5E 0604     2177         MVI     B,4
              2178 J1:
CC60 FE46     2179         CPI     'F'
CC62 C267CC   2180         JNZ     J2
CC65 0608     2181         MVI     B,8
              2182 J2:
CC67 FE53     2183         CPI     'S'
CC69 C26ECC   2184         JNZ     J3
CC6C 0610     2185         MVI     B,10H
              2186 J3:
CC6E FE43     2187         CPI     'C'
CC70 C275CC   2188         JNZ     J4
CC73 0610     2189         MVI     B,10H
              2190 J4:
CC75 FE44     2191         CPI     'D'
CC77 C27CCC   2192         JNZ     J5
CC7A 0620     2193         MVI     B,20H
              2194 J5:
CC7C FE4B     2195         CPI     'K'
CC7E C2FBC3   2196         JNZ     K6   (rótulo errado, seria J6!)
CC81 0605     2197         MVI     B,5
              2198 J6:
CC83 FE3A     2199         CPI     ':'
[...]
```

(No assembly do Z80, `CPI` é `CP`, `JNZ` é `JP NZ` e `MVI` é `LD`.)

### Patch

```
CC7E  C2FBC3    JP      NZ,$C3FB
```
- - -
```
CC7E  C283CC    JP      NZ,$CC83
```

## Instruções `PLOT`, `UNPLOT`, `DRAW`, `UNDRAW`

No modo `HGR`, quando as instruções de desenho tentam desenhar/apagar uma linha em 45° com uma extremidade na coordenada horizontal 255, as instruções não conseguem terminar de desenhar a linha e o computador trava.

Por exemplo, executar `HGR : PLOT 255-7,0 TO 255,7` deveria produzir apenas um pequeno traço diagonal no canto superior direito da tela, mas a linha continua sendo desenhada tela abaixo:

![](img/mc1000-bug-plot.png)

O problema ocorre porque nas rotinas específicas que tratam as linhas em 45°, identifica-se a chegada ao fim da linha quando, após somar 1 ao registrador contendo a coordenada horizontal do pixel recém desenhado, seu valor é superior ao da coordenada final. Mas como o em 8 bits 255 + 1 = 0, seu valor NUNCA é maior do que 255!

```
x ← MENOR_COORDENADA_X
y ← COORDENADA_Y_CORRESPONDENTE
faça
   desenha ponto nas coordenadas (x,y)
   x ← x + 1 (em 8 bits, 256 é automaticamente transformado em 0)
   y ← y + 1
   se LINHA_ASCENDENTE
      y ← y - 2
   fim se
até que x > MAIOR_COORDENADA_X
(esta condição nunca é satisfeita quando a MAIOR_COORDENADA_X é 255!)
```

### Patch

A solução é comparar a coordenada atual com a coordenada final antes de somar 1.

```
D2B6  7C        LD      A,H
D2B7  24        INC     H
D2B8  45        LD      B,L
D2B9  2C        INC     L
D2BA  CDDAD3    CALL    $D3DA ; PLOTAB
D2BD  F1        POP     AF
D2BE  F5        PUSH    AF
D2BF  3802      JR      C,$D2C3
D2C1  2D        DEC     L
D2C2  2D        DEC     L
D2C3  7C        LD      A,H
D2C4  B9        CP      C
D2C5  28EF      JR      Z,$D2B6
D2C7  38ED      JR      C,$D2B6
```
- - -
```
D2B6  7C        LD      A,H
D2B7  45        LD      B,L
D2B8  CDDAD3    CALL    $D3DA ; PLOTAB
D2BB  7C        LD      A,H
D2BC  B9        CP      C
D2BD  280A      JR      Z,$D2C9
D2BF  24        INC     H
D2C0  2C        INC     L
D2C1  F1        POP     AF
D2C2  F5        PUSH    AF
D2C3  38F1      JR      C,$D2B6
D2C5  2D        DEC     L
D2C6  2D        DEC     L
D2C7  18ED      JR      $D2B6
```
