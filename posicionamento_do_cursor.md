
# Posicionamento do cursor

Para grande frustração dos proprietários do MC1000, seu [BASIC](basic) não fornecia um comando para posicionamento de cursor, como os que existem em outras linhas de microcomputadores. Exemplos:

| Linha | Comando |
| ----: | :------ |
| MSX | `LOCATE <linha>,<coluna>` |
| Sinclair | `PRINT AT <linha>,<coluna>;` … |
| TRS | `PRINT @<posição>,` … |
| Apple II | `VTAB <linha> : HTAB <coluna>` |

Mas há uma forma de fazê-lo, usando uma sequência de quatro caracteres iniciada pelo [caracter de controle](caracteres_de_controle) ESC, documentada (de maneira não muito compreensível) no Manual de Referência, ao tratar da rotina CO da ROM, que serve para imprimir caracteres (e é usada pelo comando `PRINT` do BASIC):

1.  Caracter ESC ($1B / 27);
2.  Caracter “=” ($3D / 61);
3.  Caracter com código ASCII correspondente à linha;
4.  Caracter com código ASCII correspondente à coluna*.

\* A rotina CO contém uma distinção para os modos de 32 e 80 colunas. Em modo de 80 colunas, acrescenta-se 32 ao valor da coluna.

Assim, em BASIC temos, para o modo de 32 colunas:

`PRINT CHR$ (27);"="; CHR$ (<linha>); CHR$ (<coluna>);` …

Onde 0 ≤ linha ≤ 15 e 0 ≤ coluna ≤ 31.

E para o modo de 80 colunas:

`PRINT CHR$ (27);"="; CHR$ (<linha>); CHR$ (<coluna> + 32);` …

Onde 0 ≤ linha ≤ 23 e 0 ≤ coluna ≤ 79.

Infelizmente há um [bug](bugs) no posicionamento para 32 colunas que faz com que o cursor seja posicionado uma linha abaixo do lugar correto.

Por sorte, a sintaxe para 80 colunas (somando 32 ao número da coluna) também funciona no modo de 32 colunas, e aí sim o cursor cai no lugar certo.

Esse recurso foi utilizado numa dica de Edmundo Tojal Donato Júnior, de Alagoas, publicada na [Revista Micro Sistemas](http://pt.wikipedia.org/wiki/Revista_Micro_Sistemas) nº 51 de dezembro de 1985:

```
10  HOME
20  INPUT "LINHA,COLUNA";L,C: HOME
30  GOSUB 100
40  PRINT "MC-1000";
50  POKE 283,0
60  IF  PEEK (283) <  >  ASC ("C") THEN 60
70  GOTO 10
100  PRINT  CHR$ (27); CHR$ (61); CHR$ (L); CHR$ (C + 32);: RETURN
```

Para reduzir o tamanho de bytes utilizados no comando  `PRINT` e a poluição visual causada por tantos  `CHR$`, uma sugestão é guardar os dois primeiros bytes da sequência de escape em uma variável. Uma dica é usar uma variável chamada `AT$`  de uma forma que lembra a sintaxe usada nos micros da Sinclair:

```
10 AT$ =  CHR$ (27) + "="
20  TEXT : HOME
30  PRINT AT$; CHR$ (10); CHR$ (12 + 32);"MC-1000";
40  PRINT AT$; CHR$ (12); CHR$ (6 + 32);"CCE COLOR COMPUTER";
50  PRINT  CHR$ (30);
```

Essa solução ainda é um pouco visualmente poluída. Pode-se fazer como na dica do Edmundo Tojal e esconder toda a sequência de escape em uma sub-rotina, passando-se as coordenadas em variáveis:

```
10  TEXT : HOME
20 L = 10:C = 12: GOSUB 100: PRINT "MC-1000";
30 L = 12:C = 6: GOSUB 100: PRINT "CCE COLOR COMPUTER";
40  PRINT CHR$ (30);
50  END
100  PRINT  CHR$ (27);"="; CHR$ (L); CHR$ (C + 32);: RETURN
```

Uma outra dica é usar o comando  `SET <x>,<y>`  para passar as coordenadas para a subrotina, dispensando as variáveis adicionais. A subrotina obtém com  `PEEK`  os valores das  [variáveis do sistema](variaveis_do_sistema)  onde o comando  `SET`  armazena os valores das coordenadas. Mas há um porém: o comando  `SET`  emite erro de tipo incompatível se verificar que está em modo  `TEXT`. Para ludibriar essa verificação, basta um  `POKE`  na variável do sistema verificada pelo comando  `SET`, para ele achar que estamos em modo  `GR`  ou  `HGR`:

```
10  TEXT : POKE 856,2: HOME
20  SET 12,10: GOSUB 100: PRINT "MC-1000";
30  SET 6,12: GOSUB 100: PRINT "CCE COLOR COMPUTER";
40  PRINT  CHR$ (30);
50  END
100  PRINT  CHR$ (27);"="; CHR$ ( PEEK (857)); CHR$ ( PEEK (858) + 32);: RETURN
```

Onde se usam os endereços:

-   856 = Anotação sobre o modo de vídeo atual: 0 =  `TEXT`, 1 =  `GR`, 2 =  `HGR`.
-   857 = Coordenada vertical definida por  `SET`.
-   858 = Coordenada horizontal definida por  `SET`.

* * *

## Outras dicas rápidas referentes ao cursor:

Estas dicas só se aplicam ao modo de 32 colunas.

### Cursor sem piscar (1):

`POKE 304,201`

A cada leitura do teclado (rotina SKEY?) são chamados dois  _hooks_ na área de  [variáveis do sistema](variaveis_do_sistema)  na RAM. O segundo deles é  JOBM  ($0103 / 304), que originalmente contém uma instrução  `JP`  para a rotina da ROM que conta ciclos para o piscamento do cursor. O  `POKE`  acima coloca uma instrução  `RET`  em  JOBM, desativando o piscamento.

### Cursor sem piscar (2):

`GR : HOME`

Os comandos de seleção de modo gráfico (`GR`  ou  `HGR`) realizam automaticamente o procedimento de colocar um  `RET`  em  JOBM, desativando o piscamento do cursor. O comando  `HOME`  até faz o MC6847 entrar no modo alfanumérico, mas, diferentemente do comando  `TEXT`, não restabelece todas as variáveis aos valores usuais do modo de texto. Por exemplo, após um  `GR : HOME`  o MC1000 continua aceitando comandos de desenho (`SET`,  `PLOT`  etc.) sem emitir  erro de tipo incompatível.

Esta solução é visualmente poluída, pois o usuário vai enxergar a tela piscando em modo  `GR`.

### Para voltar a piscar (1):

`POKE 304,195`

Restabelece a instrução  `JP`  em  JOBM.

### Para voltar a piscar (2):

`TEXT`

### Cursor invisível:

`POKE 247,202: POKE 248,192: POKE 249,202: POKE 250,192: CALL 52013`

Coloca o endereço $C0CA (onde há uma instrução  `RET`) nas variáveis de 2 bytes UPDBM ($00F7 / 247) e UPDBCM ($00F9 / 249), que originalmente contêm endereços de rotinas da ROM responsáveis pela inversão do caracter na posição do cursor.

O  `CALL`  do final apaga o cursor se ele ainda estiver aceso.

Atenção: O comando  `HOME`  e a impressão de  `CHR$(30)`  desfazem esta configuração.

### Para voltar a aparecer (1):

`POKE 247,29: POKE 248,203: POKE 249,45: POKE 250,203`

Restaura os valores originais de UPDBM e UPDBCM.

### Para voltar a aparecer (2):

`HOME`  
ou  
`PRINT CHR$ (30);`
