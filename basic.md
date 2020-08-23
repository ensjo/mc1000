# BASIC

Externamente, o BASIC do MC1000 é bem parecido com [BASIC Applesoft][applesoft], programado pela Microsoft para o Apple II (com instruções como ``HOME``, ``GR``, ``INVERSE``, etc.; ausência de ``INKEY$``, ``INSTR``, etc.) Mas quando o BASIC Applesoft foi criado [já existiam versões do Microsoft BASIC][msbasic_antigo] rodando em máquinas baseadas no [Intel 8080][intel8080], o precursor do Z80. O BASIC do MC1000 parece ser um descendente de uma dessas versões antigas cujos números de ponto flutuante eram armazenados em 4 bytes, resultando em uma precisão de aproximadamente 6 dígitos, em vez dos aproximadamente 9 dígitos de versões posteriores.

[applesoft]: http://www.landsnail.com/a2ref.htm "Apple II Programmer's Reference"
[msbasic_antigo]: https://www.pagetable.com/?p=43 "Bill Gates’ Personal Easter Eggs in 8 Bit BASIC"
[intel8080]: https://pt.wikipedia.org/wiki/Intel_8080 "Artigo sobre o Intel 8080 na Wikipédia"

Segue-se um resumo do BASIC do MC1000. Para maiores detalhes, consulta o Manual do BASIC.

## Instruções e linhas

Uma linha digitada sem um número de linha é executada imediatamente (modo direto); linhas digitadas iniciando com um número são armazenadas na memória RAM, componto um programa para execução posterior (modo programado). Uma linha pode conter mais de um comando, separados por ``:``.


## Instruções que atuam sobre o programa BASIC na memória

* ``NEW`` — Apaga o programa atual e todas as variáveis.
* ``AUTO`` [ *numlin1* [ ``-`` *numlin2* ] ] — Inicia um modo de digitação de linhas em que a numeração é fornecida automaticamente, iniciando em *numlin1* e aumentando de 10 em 10 até *numlin2* . Na ausência de parâmetros, a numeração se inicia em 10. Na ausência de *numlin2*, a sequência continua até que o usuário pressione \<CTRL>+\<C>.
* ``LIST`` [ [ *numlin1* ] ``-`` [ *numlin2* ] ] — Exibe a porção do programa entre as linhas de número *numlin1* e *numlin2*, inclusive. Na ausência de *numlin1* a listagem inicia na primeira linha do programa. Na ausência de *numlin2* a listagem segue até a última linha do programa.
* ``EDIT`` *numlin* — Executa uma rotina para edição da linha *numlin*. (Ver Manual do BASIC.)

## Tipos de dados

Os tipos de dados manipulados pelos programas são:

* **Números** de ponto flutuante na faixa de ±1,70141×10<sup>38</sup>.
* **Cadeias de caracteres** ("*strings*") contendo de 0 a 255 caracteres. Uma cadeia de caracteres no programa é delimitada por aspas.

### Variáveis

Os nomes de variáveis podem ter um ou dois caracteres. O primeiro caracter deve ser uma letra. O segundo, se houver, pode ser uma letra ou um algarismo. Outros caracteres, se houver, são ignorados. (Os nomes "PRECO", "PRAIA", "PRESIDENCIALISMO" todos se referem a uma mesma variável "PR".)

Variáveis com nome seguido do caracter "$" são do tipo cadeia de caracteres.

### Matrizes

Matrizes podem armazenar vários valores do mesmo tipo.

Os nomes das matrizes seguem as mesmas regras dos nomes de variáveis.

Antes de serem usadas, as matrizes devem ser dimensionadas.

## Instruções que atuam sobre variáveis e matrizes

* ``DIM`` *mat* ``(`` *exprN* [ ``,`` ... ] ``)`` — Cria a matriz *mat* com as dimensões especificadas. Cada índice varia de 0–*exprN*.
* [ ``LET`` ] *var* ``=`` *expr* — Atribui um valor a uma variável.
* [ ``LET`` ] *mat* ``(`` *exprN* [ ``,`` ... ] ``) =`` *expr* — Atribui um valor a um elemento de uma matriz.

## Operadores

### Aritméticos

* *exprN1* ``+`` *exprN2* — Adição.
* *exprN1* ``−`` *exprN2* — Subtração.
* *exprN1* ``*`` *exprN2* — Multiplicação (*exprN1* × *exprN2*).
* *exprN1* ``/`` *exprN2* — Divisão (*exprN1* ÷ *exprN2*).
* *exprN1* ``↑`` *exprN2* — Exponenciação (*exprN1*<sup>*exprN2*</sup>).

### Relacionais

Comparam números ou cadeias de caracteres. Retornam −1 para expressões verdadeiras e 0 para expressões falsas.

* *expr1* ``=`` *expr2* — É igual a.
* *expr1* ``<`` *expr2* — É menor do que.
* *expr1* ``>`` *expr2* — É maior do que.
* *expr1* ``<=`` *expr2* ou *expr1* ``=<`` *expr2* — É menor ou igual a (*expr1* ≤ *expr2*).
* *expr1* ``>=`` *expr2* ou *expr1* ``=>`` *expr2* — É maior ou igual a (*expr1* ≥ *expr2*).
* *expr1* ``<>`` *expr2* ou *expr1* ``><`` *expr2* — É diferente de (*expr1* ≠ *expr2*).

### Lógicos

Atuam a nível de bit em operandos numéricos, convertidos a inteiros de 16 bits com sinal.

* *exprN1* ``AND`` *exprN2* — Para cada par correspondente de bits dos operandos:
    * 0 ``AND`` 0 = 0.
    * 0 ``AND`` 1 = 0.
    * 1 ``AND`` 0 = 0.
    * 1 ``AND`` 1 = 1.
* *exprN1* ``OR`` *exprN2* — Para cada par correspondente de bits dos operandos:
    * 0 ``OR`` 0 = 0.
    * 0 ``OR`` 1 = 1.
    * 1 ``OR`` 0 = 1.
    * 1 ``OR`` 1 = 1.
* ``NOT`` *exprN* — Para cada bit do operando:
     * ``NOT`` 0 = 1.
     * ``NOT`` 1 = 0.

### Sobre cadeias de caracteres.

* *exprC1* ``+`` *exprC2* — Concatena cadeias de caracteres.

## Funções aritméticas

* ``ABS(`` *exprN* ``)`` — Módulo de *exprN* (isto é, o valor de *exprN* sem o sinal).
* ``SGN(`` *exprN* ``)`` — Sinal de exprN: −1 (negativo), 0 (zero) ou 1 (positivo).
* ``INT(`` *exprN* ``)`` — Número inteiro mais próximo menor ou igual a *exprN*.
* ``SQR(`` *exprN* ``)`` — Raiz quadrada de *exprN*.
* ``SIN(`` *exprN* ``)`` — Seno de *exprN* radianos.
* ``COS(`` *exprN* ``)`` — Cosseno de *exprN* radianos.
* ``TAN(`` *exprN* ``)`` — Tangente de *exprN* radianos.
* ``ATN(`` *exprN* ``)`` — Arco-tangente de *exprN* radianos.
* ``EXP(`` *exprN* ``)`` — e<sup>*exprN*</sup>, onde e = 2,71828.
* ``LOG(`` *exprN* ``)`` — Logaritmo natural de *exprN* (log <sub>e</sub> <sup>*exprN*</sup>, ln *exprN*).
* ``RND(`` *exprN* ``)``
    * Se *exprN* > 0, um número pseudoaleatório entre 0 (inclusive) e 1 (exclusive).
    * Se *exprN* = 0, repete o último número gerado.
    * Se *exprN* < 0, usa o parâmetro para inicializar a semente do gerador de números pseudoaleatórios.
* ``DEF FN`` *func* ``(`` *varN* ``)`` = *exprN* — Define uma função. O nome da função segue as mesmas regras que o nome de uma variável numérica.
* ``FN`` *func* ``(`` *exprN* ) — Calcula o valor da função *func* para o valor *exprN*.

Algumas funções matemáticas ausentes no BASIC do MC1000 podem ser definidas assim:

* ``DEF FN AS(X) = ATN(X / SQR (1 - X * X))`` — Arco-seno (sen<sup>−1</sup> x).
* ``DEF FN AC(X) = 1.5707963 - ATN(X / SQR(1 - X * X))`` — Arco-cosseno (cos<sup>−1</sup> x).
* ``DEF FN LD(X) = LOG(X) / 2.3025851`` — Logaritmo na base 10 (log <sub>10</sub> x).

## Funções referentes a cadeias de caracteres

* ``LEN(`` *exprC* ``)`` — Comprimento da cadeia *exprC*.
* ``LEFT$(`` *exprC* , *exprN* ``)`` — Os *exprN* caracteres mais à esquerda da cadeia *exprC*.
* ``MID$(`` *exprC* ``,`` *exprN1* [ ``,`` *exprN2* ] ``)`` — *exprN2* caracteres de *exprC*, começando da posição *exprN1*. Na ausência de *exprN2*, considera-se até o final da cadeia.
* ``RIGHT$(`` *exprC* , *exprN* ``)`` — Os *exprN* caracteres mais à esquerda da cadeia *exprC*.
* ``STR$(`` *exprN* ``)`` — A cadeia representando o valor numérico *exprN*.
* ``VAL(`` *exprC* ``)`` — O valor numérico da cadeia *exprC*.
* ``CHR$(`` *exprN* ``)`` — O caracter de código ASCII *exprN*.
* ``ASC(`` *exprC* ``)`` — O código ASCII do primeiro caracter da cadeia *exprC*.

## Instruções de controle

* ``RUN`` [ *numlin* ] — Apaga todas as variáveis e executa o programa atual a partir da linha *numlin*. Na ausência de *numlin* a execução inicia na primeira linha do programa. Em execução, o programa pode ser pausado com \<CTRL>+\<S> e interrompido com \<CTRL>+\<C>.
* ``STOP`` — Para a execução do programa e imprime o número da linha.
* ``CONT`` — Retoma a execução do programa.
* ``END`` — Para a execução do programa.
* ``GOTO`` *numlin* — Salta para a linha de número *numlin*.
* ``ON`` *exprN* ``GOTO`` *numlin* [ ``,`` ... ] — Salta para um dos números de linha especificados segundo o valor de *exprN* (1, 2, … n). Se *exprN* = 0 ou maior que a quantidade de números de linha especificados, ignora e passa à instrução seguinte. Se *exprN* < 0, ocorre erro de parâmetro ilegal.
* ``IF`` *exprN* ``THEN`` *instr* [ ``:`` ... ] — Se *exprN* for falsa (=0), ignora o restante da linha atual e passa à próxima linha. Se *exprN* for verdadeira (≠0), continua a execução das instruções seguintes na linha.
* ``IF`` *exprN* ``THEN`` *numlin* ou ``IF`` *exprN* ``GOTO`` *numlin* — Sintaxes abreviadas alternativas para ``IF`` *exprN* ``THEN GOTO`` *numlin*.
* ``FOR`` *varN* ``=`` *exprN1* ``TO`` *exprN2* [ ``STEP`` *exprN3* ] — Inicia um laço para todos os valores de *varN* de *exprN1* até *exprN2*, saltando de *exprN3* em *exprN3*. Se a cláusula STEP for omitida, subentende-se 1.
* ``NEXT`` [ *varN* [ ``,`` ... ] ] — Repete o laço ``FOR`` para os próximos valores de *varN1*, *varN2*, ... *varNn*. Se nenhuma variável for especificada, repete o laço mais recente.
* ``GOSUB`` *numlin* — Salta para a subrotina na linha *numlin*.
* ``RETURN`` — Retorna de uma subrotina para a instrução seguinte à instrução ``GOSUB``.
* ``ON`` *exprN* ``GOSUB`` *numlin* [ ``,`` ... ] — Salta para a subrotina em um dos números de linha especificados segundo o valor de *exprN* (1, 2, ... n). Se *exprN* = 0 ou maior que a quantidade de números de linha especificados, ignora e passa à instrução seguinte. Se *exprN* < 0, ocorre erro de parâmetro ilegal.

## Instruções de entrada e saída

* ``INPUT`` [ *literalC* ``;`` ] *var* [ ``,`` ... ] — Imprime a mensagem contida em *literalC*, se for especificada; em seguida imprime um ponto de interrogação ("?"), espera que o usuário digite dados separados por vírgulas e os armazena nas variáveis especificadas.
* ``READ`` *var* [ ``,`` ... ] — Lê valores das listas ``DATA`` e os armazena nas variáveis especificadas.
* ``DATA`` *literal* [ ``,`` ... ] — Lista de valores de dados a serem lidos com ``READ``.
* ``RESTORE`` [ *numlin* ] — Posiciona o ponto de leitura da lista ``DATA`` no início da linha *numlin*. Ou na primeira linha do programa se *numlin* estiver ausente.
* ``PR#`` *exprN* — Determina se as instruções de impressão (``PRINT``, ``LIST``) serão exibidos na tela (*exprN* = 0), na impressora (*exprN* = 1) ou em ambos (*exprN* = 2).
* ``PRINT`` [ *expr* [ *sep* ...] ] [ *sep* ] — Imprime os valores de diversas expressões em sequência. Quando um ponto-e-vírgula (``;``) for usado como separador, o valor seguinte é impresso na posição atual do cursor. Uma vírgula (``,``) avança o cursor para o próximo "ponto de tabulação" (até 13 espaços adiante). Se a instrução terminar com um separador, o cursor fica posicionado no lugar correspondente aguardando a próxima instrução de impressão. Caso contrário, o cursor cai para o início da linha seguinte. No lugar de uma expressão pode-se usar uma das cláusulas:
    * ``SPC(`` *exprN* ``)`` — Imprime exprN espaços.
    * ``TAB(`` *exprN* ``)`` — Imprime espaços até o cursor chegar à *exprN*-ésima posição de caracter a partir do início da linha.
    * ``VTAB(`` *exprN* ``)`` — Posiciona o cursor verticalmente. (Não funciona. Ver bugs.)
* ``TEXT`` — Entra o modo de texto e limpa a tela.
* ``HOME`` — Limpa a tela de texto e posiciona o cursor no canto superior esquerdo.
* ``NORMAL`` — Determina impressão em modo normal (letras claras sobre fundo escuro).
* ``INVERSE`` — Determina impressão em modo invertido (letras escuras sobre fundo claro).
* ``WIDTH`` *exprN* — Introduz uma quebra de linha automática após cada *exprN* caracteres impressos em sequência. O valor padrão é 255.
* ``POS( exprN )`` — (Função.) Retorna o deslocamento do cursor desde a última quebra de linha.
* ``COLUMN`` *exprN* — Só admite os valores abaixo. Outros valores produzem erro "parâmetro ilegal".
    * 32 — Direciona a impressão de texto para o VDG MC6847, de 32 colunas, e limpa a tela.
    * 80 — Se houver cartão de 80 colunas, direciona a impressão de texto para ele e limpa a tela. Caso contrário, produz erro "tipo incompatível".
* ``INP(`` *exprN* ``)`` — (Função.) Lê um valor da porta de entrada *exprN*.
* ``OUT`` *exprN1* ``,`` *exprN2* — Envia o valor *exprN2* para a porta de saída *exprN1*.
* ``WAIT`` *exprN1* ``,`` *exprN2* [ ``,`` *exprN3* ] — Espera até que a expressão ``(INP(`` *exprN1* ``) XOR`` *exprN3* ``) AND`` *exprN2* resulte diferente de 0. Na ausência de *exprN3*, assume-se 0.

## Operações com a fita cassete

SAVE [ nome ]
Salva o programa em BASIC atual na fita. O nome é uma sequência de 1 a 5 caracteres alfanuméricos (sem aspas). ATENÇÃO: Se o programa for salvo com nome, será NECESSÁRIO informar o nome no comando LOAD, então é importante anotar o nome do programa em algum lugar. Um programa sem nome executa automaticamente após a carga, com impressões desativadas (vide a variável do sistema $0344 / 836).
LOAD [ nome ]
Carrega um programa em BASIC da fita. O nome é uma sequência de 1 a 5 caracteres alfanuméricos (sem aspas). ATENÇÃO: Se o programa foi salvo com nome, é NECESSÁRIO informar o nome no comando LOAD. Um programa sem nome executa automaticamente após a carga, com impressões desativadas (vide a variável do sistema $0344 / 836).
SAVE * matN
Salva o conteúdo de uma matriz numérica na fita. Atenção: Deve haver um espaço entre o asterisco e o nome da matriz.
LOAD * matN
Carrega o conteúdo de uma matriz numérica da fita. A matriz deve ser criada com DIM antes da carga. Atenção: Deve haver um espaço entre o asterisco e o nome da matriz.
TLOAD
Carrega um programa em código de máquina da fita e o executa em "modo de jogo".
Gráficos
GR
Passa ao modo gráfico de baixa resolução (128×64 pixels, 4 cores) e limpa a tela.
COLOR = exprN
Define a cor de desenho do modo de baixa resolução como exprN (0–3).
HGR
Passa ao modo gráfico de alta resolução (256×192 pixels, preto e branco) e limpa a tela.
PLOT exprNx , exprNy
Faz um ponto nas coordenadas exprNx, exprNy.
PLOT [ exprNx1 , exprNy1 ] TO exprNx2 , exprNy2 [ TO ... ]
Desenha uma ou mais linhas conectadas na tela gráfica. Se uma primeira coordenada não for especificada antes da palavra TO, o desenho parte do último ponto desenhado.
DRAW [ - ] exprNx , [ - ] exprNy
Desenha uma linha do último ponto desenhado (x, y) até novas coordenadas x + exprNx, y + exprNy etc.

Atenção: Os sinais de menos, quando presentes, fazem parte da sintaxe do comando, e não das expressões numéricas. A instrução DRAW -4-3,0 equivale a DRAW -(4-3),0 ou DRAW -1,0, e não a DRAW -7,0 como se esperaria. De fato, a instrução não aceita parâmetros negativos. Instruções como DRAW (-1),0 (o sinal de menos não é reconhecido como parte da sintaxe porque não vem imediatamente após a palavra DRAW) ou DY = -5 : DRAW 0,DY causam erro de parâmetro ilegal.

UNPLOT, UNDRAW
Como PLOT e DRAW, mas apagam ao invés de desenhar.
SET exprNx , exprNy
Muda a coordenada armazenada do último ponto desenhado, sem desenhar nada.
Som
TEMPO exprN1 , exprN2 , exprN3
exprN1 (0‒255) define o período do envelope do canal; exprN2 (0‒3) define o compasso do canal; exprN3(1‒3) informa qual canal está sendo configurado.
SOUND exprN1 , exprN2 , exprN3
Toca uma nota; exprN1 (0‒255) seleciona a nota (ver valores válidos no Manual do BASIC); exprN2 (0‒255) indica a duração da nota; exprN3 (1‒3) informa o canal em que a nota soará.

Atenção: Se se emitir uma instrução SOUND sem ter configurado o canal com TEMPO, o computador travará.

Instruções utilitárias
CLEAR [ exprN1 [ , exprN2 ] ]
Apaga todas as variáveis. Se exprN1 for especificado, define o tamanho da área de armazenamento de cadeias. Se exprN2 for especificado, define o limite superior dessa área. A RAM depois desse endereço fica livre para ser usada pelo usuário para POKEs e programas em linguagem de máquina, sem risco de ser invadido pelo crescimento do programa BASIC, suas variáveis ou pilha do Z80. Quando o computador com 16KiB de RAM é ligado, a situação é tal como se tivesse sido emitido o comando CLEAR 512,16127: Há 512 bytes de área para cadeias ($3D00–$3EFF, 15616–16127); e depois 256 bytes até o fim da RAM ($3F00–$3FFF, 16128–16383) livres para o usuário.
PEEK( exprN )
(Função.) Valor do endereço de memória exprN (0–65535).
POKE exprN1 , exprN2
Armazena o valor exprN2 (0–255) no endereço de memória exprN1 (0–65535).
CALL end
Executa a rotina em linguagem de máquina começando no endereço de memória end (0–65535).
USR( exprN )
(Função.) Passa um argumento a uma rotina do usuário em linguagem de máquina. Antes é preciso colocar o endereço do início da rotina nos endereços $0304 e $0305 (772 e 773), o que deve ser feito com POKEs já que o MC1000 não tem uma instrução DEFUSR. O parâmetro exprN estará disponível em $03BF–$03C2 (4 bytes), e o valor colocado aí será o valor de retorno da função.
FRE( exprN )
(Função.) Quantidade de memória livre para crescimento do programa BASIC, variáveis e matrizes. O valor da expressão exprN é irrelevante.
FRE( exprC )
(Função.) Compacta a área de cadeias de caracteres e retorna a quantidade de memória livre para cadeias de caracteres. O valor da expressão exprC é irrelevante.
TRO N
Ativa a exibição dos números de linha de cada instrução executada, para depuração do programa.
TRO F
Desliga a exibição dos números de linhas.
DEBUG
Executa um programa monitor para criação e depuração de programas em linguagem de máquina. (Ver Manual do BASIC.)
EXIT
Reinicia o interpretador BASIC.
> ``REM`` ...

Faz com que o resto da linha seja ignorada pelo interpretador, permitindo que o programador inclua no programa comentários para serem lidos por outras pessoas.
