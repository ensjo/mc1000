# Variáveis do sistema

Divisão padrão da RAM (48 Kbytes) segundo o  [Manual do BASIC](manual_do_basic):

| Faixa (hex) | Faixa (dec) | Conteúdo                                   |
| :---------: | :---------: | :----------------------------------------- |
| $0000–$00FF |    0–255    | Buffer de execução do programa DEBUG.      |
| $0100–$01FF |   256–511   | Buffer de execução do Monitor.             |
| $0200–$02FF |   512–767   | Buffer de linha.                           |
| $0300–$03D4 |   768–980   | Buffer de execução do interpretador BASIC. |
| $03D5–$BCFF |  981–48383  | Programa fonte BASIC.                      |
| $BD00–$BFFF | 48384–49151 | Stack e matriz do interpretador BASIC.     |

* * *

## Buffer de execução do programa DEBUG

*   $0001 / 1

    Contém 0.

*   $0002 / 2 (**SNDSW**)

    ?

*   $0003 / 3 (**BYTE E/S**  ou  **IOBYTE**)

    Manual de Referência (p.24):

    > No MONITOR, se você usar o subcomando  `D`  para exibir alguns dados, esses serão mostrados na tela, no entanto, como listá-los na impressora? Use o subcomando  `S`  para examinar o endereço 3; seu valor é 41H. Agora mude o seu conteúdo para qualquer outro dado e use o subcomando  `D`  novamente. Os dados aparecem todos no papel.

*   $000F / 15 (**C40?80**)

    Flag de largura da tela:

    -   0 = 32 colunas
    -   ≠ 0 = 80 colunas

    Manual de Referência (p.12):
    > Chave de 32/80 colunas: quando o conteúdo deste buffer for zero, a tela mostrará 32 colunas, caso contrário o computador estará na modalidade de 80 colunas.

    Manual de Referência (p.24):
    > Eis aqui o buffer da chave de exibição do vídeo para 32/80 colunas. Quando o conteúdo do endereço 000FH for 0, então a saída do console será em 32 colunas; se o valor for 1, o cartão de 80 colunas está instalado.
    > 
    > Logicamente, você pode mudar o valor de 0 para 1 mas, depois você terá que chamar a sub-rotina ISCN (C021H), caso contrário, a tela apresentará informações incompreensíveis.

*   $0038 / 56 (3 bytes)

    *Hook*  da rotina de interrupção periódica do Z80. Na inicialização é configurada com um salto para a rotina  INTRUP  ($C55F), responsável pelo tratamento da instrução  `SOUND`  e da música de fundo dos jogos.

*   $00F5 / 245 (**MODBUF**)

    Número do  [modo de vídeo](modos_de_video)  atual, segundo o VDG. O valor contido aqui é lançado na porta  COL32  ($80) para habilitar a escrita na VRAM nos eventos de vídeo: limpeza de tela, intermitência do cursor, impressão de caracteres, plotagem de linhas, etc.

    -   $01 / 1 =  `TEXT`
    -   $88 / 136 =  `GR`
    -   $9F / 159 =  `HGR`

*   $00F6 / 246 (**CLR**)

    Valor de  `COLOR`  (0–3).

    Manual de Referência (p.24):

    > O código de cor de Baixa Resolução é armazenado aqui, com valores legais de 0 a 3.

*   $00F7 / 247 (2 bytes) (**UPDBM**)

    Endereço da rotina para acender e/ou apagar o cursor. Contém $CB1D em caso de 32 colunas (atribuído pela rotina $C841), que inverte o caracter sob o cursor; ou $CB3F no caso de 80 colunas (atribuído na rotina $C7EC), que apenas posiciona o cursor, pois o hardware de 80 colunas se ocupa do piscamento.

*   $00F9 / 249 (2 bytes) (**UPDBCM**)

    Endereço da rotina para apagar o cursor se ele estiver aceso. Contém $CB2D em caso de 32 colunas (atribuído pela rotina $C841), que chama a rotina apontada por UPDBM caso FSHCNT seja par; ou $CB3F em caso de 80 colunas (atribuído pela rotina $C7EC), que apenas posiciona o cursor, pois o hardware de 80 colunas se ocupa do piscamento.

*   $00FB / 251 (2 bytes) (**STAR**)

    Início do bloco de memória a salvar para a fita.

    Manual de Referência (p.25):

    > Este buffer tem dois bytes; quando você chamar a sub-rotina de entrada/saída por fita, coloque o endereço de início do bloco de dados salvo/carregado nesse buffer. O byte baixo em 00FBH e o byte alto em 00FCH.

*   $00FD / 253 (2 bytes) (**ENDT**)

    Byte seguinte ao fim do bloco de memória a salvar para a fita.

    Manual de Referência (p.25):

    > Ao salvar dados em fita cassete, coloque o endereço de fim do bloco de dados neste buffer antes de chamar a sub-rotina TAPOUT (C012H).

*   $00FF / 255 (**BORDER**)

    Média entre os comprimentos dos pulsos curtos (bits “1”) e longos (bits “0”) lidos da fita durante o tom piloto de um arquivo em [cassete](cassete). Esse valor serve como fronteira para diferenciar os dois bits.

* * *

## Buffer de execução do Monitor

*   $0103 / 259 (**PGM**  ou  **PGN**  ou  **MUSIC**)

    ?

*   $0104 / 260 (**PLAY**)

    "Tópico" de jogo atual.

    Manual de Referência (p.25):

    > Número da jogada atual no procedimento de disputa de jogo.

*   $0105 / 261 (**PLAYMX**)

    Quantidade de “tópicos” (modos, níveis, etc.) do jogo. Selecionam-se com \<CTRL>+\<H> e modificam o comportamento do jogo: cenário diferente, dificuldade diferente, um ou dois jogadores, etc. O ponto de entrada de execução de cada um dos tópicos é definido por uma sequência de instruções  `JP xxxx`  a partir do endereço $0200.

    Manual de Referência (p.25):

    > Número máximo da jogada no jogo atual.

*   $0106 / 262 (**HEAD**)

    -   $FF / 255 = Modo BASIC/MONITOR. A rotina de leitura de teclado KEY emite bip a cada tecla pressionada; a rotina SKEY? só reconhece uma tecla pressionada. A rotina TAPIN retorna após a leitura do nome do arquivo (para permitir a comparação com o nome de arquivo desejado) e a rotina GET1 *não*  inicia a execução do programa a partir de $0200 (comportamento do comando  `TLOAD`).
    -   ≠ $FF / 255 = [“Modo de jogo”](infraestrutura_para_jogos). A rotina de leitura de teclado KEY não emite bip a cada tecla pressionada; a rotina SKEY? reconhece até quatro teclas pressionadas simultaneamente. A combinação de teclas \<CTRL>+\<H> chama a rotina NEXTGM para alternar automaticamente entre “tópicos de jogo”. Os códigos retornados por algumas teclas e combinações são diferentes. Após a leitura do arquivo da fita, inicia-se a execução a partir do endereço $0200 (comportamento do comando  `TLOAD`). O valor é 1 durante o comando  `TLOAD`, e 0 depois.

    Manual de Referência (p.25):

    > Este é um buffer frequentemente usado. Na seção sobre o teclado, entrada/saída de fita, temos que verificar esse buffer. O buffer HEAD tem dois valores: 0FFH ou não. Quando você estiver em BASIC ou MONITOR, o valor desse buffer é 0FFH; se estiver jogando, o valor é diferente mas você não pode examiná-lo. Quando você chamar uma sub-rotina de E/S de fita como TAPIN/TAPOUT, certifique-se de que o valor é 0FFH.

*   $0107 / 263 (2 bytes) (**RANDOM**)

    Este valor é constantemente incrementado de $B2E7 (+45799 ou −19737) a cada leitura de teclado (SKEY?).

    Manual de Referência (p.25):

    > Buffer gerador de número randômico; cada vez que se chama a sub-rotina SKEY?, esse buffer de dois bytes muda uma vez.

*   $0109 / 265 (2 bytes) (**RCRDPT**)

    Endereço (+1) do último score armazenado na tabela de scores. Se RCRDPT = $011B (RECORD+16), a tabela está cheia.

*   $010B / 267 (16 bytes) (**RECORD**)

    8 pares de scores (jogadores 1 e 2). Os valores de SCOREA e SCOREB são transferidos para esta tabela pela rotina LSCORE.

*   $0113 / 275 (2 bytes) (**DLNG**)

    Largura da tela de texto. (Linha da tela, em bytes.)

    Manual de Referência (p.25):

    > A sub-rotina de saída do console tem muitos buffers; este aqui é usado para armazenar o comprimento da tela. O buffer conterá 32/80 quando você estiver usando 32/80 colunas.

*   $0115 / 277 (**YCORD**)

    Código ASCII do primeiro caracter impresso após uma sequência ESC + “=”. Indica a linha onde se vai posicionar o cursor.

*   $0116 / 278 (**XCORD**)

    Código ASCII do segundo caracter impresso após uma sequência ESC + “=”. Indica a coluna onde se vai posicionar o cursor.

*   $011B / 283 (4 bytes) (**KEY0**)

    Em modo BASIC/MONITOR (HEAD = $FF), a rotina SKEY? retorna em KEY0 o código ASCII da última tecla pressionada, e KEY? o copia para KEY0+1. Em “modo de jogo” (HEAD ≠ $FF), SKEY? retorna até 4 teclas pressionadas simultaneamente em KEY0—KEY0+3.

    Manual de Referência (p.26):

    > Buffer temporário do código de tecla. Quando o computador varre o teclado e algumas teclas forem pressionadas, o código ASCII será armazenado temporariamente neste buffer. Assim, você pode obter o código de tecla diretamente daqui; em especial, quando HEAD não for 0FFH, pode haver 4 teclas pressionadas simultaneamente (verifique o registrador A após chamar KEY? (C009H) para verificar quantas teclas foram pressionadas.) Nesse caso, você terá que obter os códigos de tecla em KEY0...KEY+3.

*   $0120 / 288 (3 bytes) (**JOB**)

    Primeiro *hook* chamado durante a leitura de teclado (SKEY?). Valor default: $C9 (`RET`) no primeiro byte.

    Manual de Referência (p.26):

    > Ponto de entrada de sub-rotina definida pelo usuário. Este buffer de três bytes normalmente contém um código de retorno (0C9H). Em muitos jogos, nós o usamos para fazer a entrada na sub-rotina do contador de tempo. Logicamente, você pode usá-lo para fazer outras coisas. Cada vez que o teclado é varrido (sub-rotina SKEY?), esse ponto de entrada será chamado uma vez.

*   $0123 / 291 (**SCOREA**)

    Placar atual do jogador 1.

*   $0124 / 292 (**SCOREB**)

    Placar atual do jogador 2.

*   $0125 / 293 (**SHAPE0**)

    Indica se foi detectada colisão durante a última execução da rotina SHAPOF.
    
    -   $00 = Não houve colisão.
    -   $01 = Houve colisão.

*   $0126 / 294 (**KTIME**)

    A rotina NEXTGM registra aqui o tempo durante o qual a combinação de teclas \<CTRL>+\<H> está sendo pressionada, para fazer uma pausa antes de mudar de tópico de jogo.

*   $0128 / 296 (**PNTR**)

    Direcionamento da impressão:
    -   $00 = Impressão na tela (default)
    -   $02 = impressora e tela?

*   $012D / 301 (**COSW**)

    Alguns flags de controle do modo texto:
    
    -   Bit 0 ligado = “Lead-in”. Estamos no meio de uma sequência de escape (ESC + “=” + dois outros caracteres) para  [posicionar o cursor](posicionamento_do_cursor). Este flag é ligado no momento da impressão do ESC e continua assim até a sequência terminar ou ser interrompida (se o segundo caracter não for “=”).
    -   Bit 7 ligado = Já foi impresso “=” após o ESC. Aguardando mais dois caracteres.
    -   Bit 6 ligado = Já foram impressos “=” e outro caracter (informando a linha na qual posicionar o cursor) após o ESC. Aguardando o último caracter (coluna do cursor).
    -   Bit 1 ligado = Existe monitor de 80 colunas presente.

    Manual de Referência (p.12):

    > Quando este buffer contiver o valor zero no bit 1, então o cartão de 80 colunas estará instalado.
    > 
    > NOTA: não mude os dados deste buffer.

    Manual de Referência (p.26):

    > Chave de funções de saída do console. Seu mapa de bits é:
    >
    > ```
    > ------------------
    >  ! ! ! ! ! ! ! ! !
    > ------------------
    >  ! !         ! !-----> LEAD-IN
    >  ! !         !-------> Cartão de 80 colunas existente
    >  ! !
    >  ! !-----------------> Coordenadas Y do endereço direto do cursor.
    >  !-------------------> endereço direto do cursor.
    > ```
    >
    > Nós estudaremos este buffer detalhadamente mais tarde.

*   $012E / 302 (**KEYSW**)

    Usado pelas rotina de leitura de teclado KEY e KEY?. Geralmente contém $00. Contém $FF enquanto uma tecla estiver sendo pressionada.

*   $012F / 303 (**FSHCNT**)

    Estado atual da intermitência do cursor. É constantemente incrementado. Um número par indica cursor aceso.

*   $0130 / 304 (3 bytes) (**JOBM**)

    Segundo *hook* chamado durante a leitura do teclado (SKEY?). Contém $C9 (`RET`) no primeiro byte durante os primeiros momentos da inicialização; depois $C3,$E9,$C0 (`JP $C0E9`).

    Manual de Referência (p.26):

    > Este é um outro ponto de entrada de sub-rotina programada, mas diferente de JOB; esta entrada é usada pelo MONITOR para fazer o cursor piscar. Você pode checar este buffer de 3 bits para ver se é uma instrução para pular. O único dado que você pode usar para recolocar o código (C3) é  `RETURN`  (C9), e o cursor não piscará mais.
    > 
    > Tenha cuidado para não trocar os conteúdos da JOBM+1 e JOBM+2.

*   $0133 / 307 (**FLASHB**)

    Contador para intermitência do cursor. Valor continuamente decrementado a cada leitura de teclado (rotina SKEY?). Quando atinge 0, soma-se 1 a FSHCNT ($012F).

*   $0135 / 309 (**TABLE**  ou  **NSA**)

    ?

*   $0137 / 311 (2 bytes) (**NAA**)

    Aponta para os dados de música no canal 1.

*   $0139 / 313 (**AVALUE**)

    2º parâmetro de  `TEMPO` no canal 1.

*   $013A / 314 (**VOICEA**)

    ?

*   $013B / 315 (**INTRPA**)

    Quantidade de interrupções para cada unidade de TEMPA.

*   $013C / 316 (**TEMPA**)

    Contador de duração da nota (decrementado cada vez que INTA atinge INTRPA).

*   $013D / 317 (**INTA**)

    Contador de interrupções (incrementado a cada interrupção até atingir o valor de INTRPA), quando é zerado de novo.

*   $013E / 318 (**NSB**)

    ?

*   $0140 / 320 (2 bytes) (**NBB**)

    Aponta para os dados de música no canal 2.

*   $0142 / 322 (**BVALUE**)

    2º parâmetro de  `TEMPO`  no canal 2.

*   $0143 / 323 (**VOICEB**)

   ?

*   $0144 / 324 (**INTRPB**)

    ?

*   $0145 / 325 (**TEMPB**)

    ?

*   $0146 / 326 (**INTB**)

    ?

*   $0147 / 327 (**NSC**)

    ?

*   $0149 / 329 (2 bytes) (**NCC**)

    Aponta para os dados de música no canal 3.

*   $014B / 331 (**CVALUE**)

    2º parâmetro de  `TEMPO`  no canal 3.

*   $014C / 332 (**VOICEC**)

    ?

*   $014D / 333 (**INTRPC**)

    ?

*   $014E / 334 (**TEMPC**)

    ?

*   $014F / 335 (**INTC**)

    ?

*   $0150 / 336 (**ENABLE**)

    Valor lançado ao registrador MIXER do AY-3-8910. Default = $7F (nenhum som).

*   $0151 / 337 (**AMPLIT**)

    Seleciona o registrador de amplitude do AY-3-8910 correspondente ao canal que será modificado. Pode conter $08 (canal A), $09 (canal B) ou $0A (canal C).

*   $0152 / 338 (2 bytes) (**REGIST**)

    Seleciona os registradores de tom do AY-3-8910 correspondentes ao canal que será modificado. Pode conter $00,$01 (canal A) ou $02,$03 (canal B) ou $04,$05 (canal C).

*   $0154 / 340 (**DEFIN**)

    Valor a ser  `AND`-ado com ENABLE para habilitar o tom do canal.

*   $0155 / 341 (2 bytes) (**ONAMP**)

    No byte mais significativo: valor para armazenar em AMPLIT; no byte menos significativo: valor par ser  `OR`-ado com ENABLE para desligar o tom e o ruído do canal.

*   $0157 / 343 (**LPLAY**)

    ?

*   $0158 / 344 (**MODEK**)

    Número do modo de vídeo segundo o MC6847 durante o acesso ao cassete: $01 = tela verde; $03 = tela vermelha.

*   $0159 / 345 (2 bytes) (**LNHD**)

    Endereço na VRAM do início da linha atual do cursor.

    Manual de Referência (p.28):

    > O LNHD guarda o endereço de início de cada linha.

*   $015B / 347 (2 bytes) (**SNPTR**)

    Endereço na VRAM da posição atual do cursor.

    Manual de Referência (p.28):

    > O SNPTR guarda a posição do cursor.

*   $015D / 349 (**LCNT**)

    Coluna atual do cursor na tela de texto.

    Manual de Referência (p.28):

    > O LCNT [guarda] o número da coluna.

*   $015E / 350 (**CHECK**)

    ?. Inicializado com $5A / 90.

*   $0163 / 355 (2 bytes) (**DSNAM**)

    Endereço na VRAM de início da tela de texto:

    -   $8000 em caso de 32 colunas
    -   $2000 em caso de 80 colunas

    Manual de Referência (p.28):

    > Buffer para guardar o endereço de início na VRAM 6847/6845 da janela atual da tela.

*   $0165 / 357 (2 bytes) (**DENAM**)

    Endereço na VRAM do fim da tela de texto, somado de 1:

    -   $8200 em caso de 32 colunas
    -   $2780 em caso de 80 colunas

    Manual de Referência (p.28):

    > Buffer para guardar o endereço de término na VRAM 6847/6845 da janela atual da tela. Você pode usar esse buffer para dividir a tela.

*   $0167 / 359 (**HISCOR**)

    ?

*   $0169 / 361 (**TEMP**)

    ?

*   $016C / 364 (**RIGHTJ**)

    ?

*   $016D / 365 (**CHANA**)

    ?

*   $016F / 367

    1º parâmetro de  `TEMPO`  no canal 1.

*   $0171 / 369

    Nota no canal 1.

*   $0172 / 370 (**TONEA**)

    Duração da nota no canal 1.

*   $0173 / 371 (**CHANB**)

    ?

*   $0175 / 373

    1º parâmetro de  `TEMPO`  no canal 2.

*   $0177 / 375

    Nota no canal 2.

*   $0178 / 376 (**TONEB**)

    Duração da nota no canal 2.

*   $0179 / 377 (**CHANC**)

    ?

*   $017B / 389

    1º parâmetro de  `TEMPO`  no canal 3.

*   $017D / 381

    Nota no canal 3.

*   $017E / 382 (**TONEC**)

    Duração da nota no canal 3.

*   $017F / 383 (14 bytes) (**OBUF**)

    Nome do arquivo sendo lido da fita. Se o nome tiver menos de 14 bytes, um $0D segue o último caracter.

    Manual de Referência (p.28):

    > Se você chamar TAPIN (0C00FH), essa sub-rotina lerá o nome-de-arquivo da fita cassete e armazenará o mesmo neste buffer, sendo o comprimento máximo do mesmo 14 bytes (incluindo o \<RETURN>).
    > 
    > Suponha que você queira ler um arquivo da fita cassete onde foram guardados muitos arquivos. Você tem que comparar o nome-de-arquivo que você quer ler com este buffer. Se eles forem iguais, então chame o GET1 em seguida.

*   $018D / 397 (14 bytes) (**FILNAM**)

    Nome do arquivo sendo salvo na fita. Se o nome tiver menos de 14 bytes, um $0D segue o último caracter.

    Manual de Referência (p.28):

    > Ao contrário de OBUF, usa-se este buffer de 14 bytes para armazenar o nome-de-arquivo cujo bloco de dados você quer guardar na fita cassete. O nome-de-arquivo deve terminar com \<RETURN> ou ter 14 bytes de comprimento.

* * *

## Buffer de linha

*   $0200 / 512 (256 bytes) (**{INPBUF}**,  **\<LINE_BUFFER>**)

    Espaço onde se armazena uma linha de comando ou dados digitada pelo usuário.

* * *

## Buffer de execução do interpretador BASIC

*   $0300 / 768 (77 bytes) (**{WSP}**, **[WRKSPC]**)

    O bloco $0300–$034D é copiado a partir de um bloco da ROM ($D792–$D7DF) no momento da inicialização.  

    ```
    ; {WSP} [WRKSPC]
    0300  C32DCF    JP      #CF2D
    ; BUSR:
    ; {USRLOC} [USR]
    ; Ponto de entrada da função USR.
    0303  C3F6DE    JP      #DEF6 ; PIERRO
    ; OUTAUX:
    ; {PORTAD} [OUTSUB]
    ; Rotina auxiliar para OUT.
    0306  D300      OUT     (#00),A; #0307:{PORTAD+1} [OTPORT]
    0308  C9        RET
    ; {DIVVAR} [DIVSUP]
    ; Rotina auxiliar para DIV.
    ; Os valores #00 serão substituídos.
    0309  D600      SUB     #00 ; #030A:{DVAR1} [DIV1]
    030B  6F        LD      L,A
    030C  7C        LD      A,H
    030D  DE00      SBC     A,#00 ; #030E:{DVAR2} [DIV2]
    030F  67        LD      H,A
    0310  78        LD      A,B
    0311  DE00      SBC     A,#00 ; #0312:{DVAR3} [DIV3]
    0313  47        LD      B,A
    0314  3E00      LD      A,#00 ; #0315:{DVAR4} [DIV4]
    0316  C9        RET
    ; Dados auxiliares para RND().
    ; {RNDVR1} [SEED]
    0317  00        DB      #00
    ; {RNDVR2}
    0318  00        DB      #00
    ; {RNDVR3}
    0319  00        DB      #00
    031A  354ACA99  DB      #35,#4A,#CA,#99 ; -2.65145E+7
    031E  391C7698  DB      #39,#1C,#76,#98 ; +1.61291E+7
    0322  2295B398  DB      #22,#95,#B3,#98 ; -1.17691E+7
    0326  0ADD4798  DB      #0A,#DD,#47,#98 ; +1.30983E+7
    032A  53D19999  DB      #53,#D1,#99,#99 ; -2.01612E+7
    032E  0A1A9F98  DB      #0A,#1A,#9F,#98 ; -1.04269E+7
    0332  65BCCD98  DB      #65,#BC,#CD,#98 ; -1.34831E+7
    0336  D6773E98  DB      #D6,#77,#3E,#98 ; +1.24825E+7
    ; {RNDV4} [LSTRND]
    033A  52C74F80  DB      #52,#C7,#4F,#80 ; .811653
    ; INPAUX:
    ; [INPSUB]
    ; Rotina auxiliar para INP().
    033E  DB00      IN      A,(#00) ; #033F:[INPORT]
    0340  C9        RET
    ; {DUMMY} <TERMINAL_Y> [NULLS]
    ; Quantidade de caracteres ASCII NULL a serem impressos
    ; após um CR+LF.
    ; (O Altair BASIC tinha um comando "NULL" para definir este valor.)
    0341  01        DB      #01
    ; {LINLEN} [LWIDTH]
    ; Limite máximo de POS(). Também recebe o valor de WIDTH.
    0342  FF        DB      #FF
    ; Valor de WIDTH para "PRINT ,".
    ; {PRLISI} [COMMAN]
    0343  FF        DB      #FF
    ; {OUTFLG} [CTLOFG]
    ; Suprime a impressão de caracteres quando <> 0.
    0344  00        DB      #00
    ; {STDPTR} <STACK_TOP> [STRSPC]
    ; Base da pilha do Z80; Último endereço disponível
    ; para o BASIC antes da área de strings.
    0345  3804      DB      #0438
    ; {CULINO} <CURRENT_LINE> [LINEAT]
    ; Número de linha BASIC em execução. #FFFF após execução.
    0346  FEFF      DB      #FFFE
    ; {PSTBEG} <PROGRAM_BASE> [BASTXT]
    ; Endereço de início do programa BASIC.
    0348  D503      DB      #03D5 ; {PRAM}
    ```

*   $033A / 826 (4 bytes) (**{RNDV4}**, **[LSTRND]**)

    Último número de ponto flutuante gerado pela função  `RND()`. É o valor retornado por  `RND(0)`. Contém inicialmente $52,$C7,$4F,$80 (0,811635).

*   $0341 / 833 (**{DUMMY}**,  **\<TERMINAL_Y>**,  **[NULLS]**)

    Quantidade (+1) de caracteres ASCII NULL ($00) a serem impressos após um CR+LF, provavelmente devido a alguma peculiaridade dos equipamentos de teletipo da época do Altair BASIC. O Altair BASIC tinha um comando  `NULL`  para definir o valor desta variável. Valor inicial = $01 (i.e., nenhum NULL).

*   $0342 / 834 (**{LINLEN}**,  **[LWIDTH]**)

    Limite máximo do valor da função  `POS()`. O default é $FF (255). (Recebe valor do comando `WIDTH`, assim como $0343.)

*   $0343 / 835 (**{PRLISI}**,  **[COMMAN]**)

    Valor do comando `WIDTH`. [Width for commas.]

*   $0344 / 836 (**{OUTFLG}**,  **[CTLOFG]**)

    Suprime impressão de caracteres se diferente de zero. Valor inicial = $00. Após um  `LOAD`  sem nome de arquivo (o programa executa automaticamente), contém $01. É preciso inclui um  `POKE 836,0`  no início dos programas BASIC carregados sem nome de arquivo para garantir que os comandos  `PRINT`  funcionem.

*   $0345 / 837 (2 bytes) (**{STDPTR}**,  **\<STACK_TOP>**,  **[STRSPC]**)

    Durante a inicialização, armazena $0438: endereço temporário para a base da pilha do Z80. Depois da inicialização, armazena o endereço do topo da RAM subtraído de $0300: O topo da área disponível para o programa BASIC e suas variáveis. ($3CFF em 16KB, $BCFF em 48KB.)

*   $0347 / 839 (2 bytes) (**{CULINO}**,  **\<CURRENT_LINE>**,  **[LINEAT]**)

    Número de linha do programa BASIC em execução. Valor inicial = $FFFE.

*   $0349 / 841 (2 bytes) (**{PSTBEG}**,  **\<PROGRAM_BASE>**,  **[BASTXT]**)

    Aponta a base da área disponível para o programa BASIC e suas variáveis. Valor inicial = $03D5.

*   $034E / 846 (2 bytes)

    Durante a inicialização, armazena um endereço temporário para a base da pilha do Z80.

*   $0351 / 849 (**{INPBUF+6}**,  **[STACK]**)

    Quantidade de caracteres no buffer de linha, + 1.

*   $0352 / 850

    Flag  `NORMAL`/`INVERSE`:

    -   $00 =  `NORMAL`  (default)
    -   ≠ $00 =  `INVERSE`

*   $0353 / 851

    ?. Inicializado com $FF.

*   $0354 / 852

    Flag de  `PLOT`/`UNPLOT`  (usado internamente pelos comandos):

    -   $00 =  `UNPLOT`
    -   $01 =  `PLOT`

*   $0357 / 855

    Flag de trace:

    -   $00 =  `TROF`  (default)
    -   $01 =  `TRON`

*   $0358 / 856

    Modo de vídeo:

    -   $00 =  `TEXT`  (default)
    -   $01 =  `GR`
    -   $02 =  `HGR`

*   $0359 / 857

    Coordenada Y do último ponto plotado. Valor inicial: $00.

*   $035A / 858

    Coordenada X do último ponto plotado. Valor inicial: $00.

*   $035B / 859 (2 bytes)

    Número de linha atual gerada pelo comando  `AUTO`.

*   $035D / 861 (**{AUTOFG}**)

    Flag de  `AUTO`.

*   $035E / 862 (2 bytes)

    Última linha a ser gerada pelo comando  `AUTO`.

*   $0360 / 864

    Flag de  `FAST`/`SLOW`:

    -   $00 =  `FAST`  (default)
    -   $01 =  `SLOW`

*   $0361 / 865

    ≠ 0 indica que o programa foi carregado sem nome e que deve ser automaticamente executado. Valor inicial: $00.

*   $038D / 909 (**{EOINPB}**,  **[BUFFER+72+1]**)

    Fim do buffer de linha em outros BASICs. Inicializado ("marcado") com $00.

*   $038E / 910 (**{CURPOS}**,  **[CURPOS]**)

    Valor da função  `POS()`.

*   $038F / 911 (**{LOCCRE}**,  **\<DIM_OR_EVAL>**, **[LCRFLG]**)

    ≠ 0 indica  `DIM`ensionamento de matriz; = 0 indica apenas acesso. [Locate/Create flag.]

*   $0390 / 912 (**{DATYPE}**,  **[TYPE]**)

    Usado para determinar o tipo de uma variável: 0 = numérico; 1 = string.

*   $0391 / 913 (**{DSTMNT}**,  **[DATFLG]**)

    Durante a tokenização das palavras reservadas de uma linha, 0 indica que as palavras devem ser tokenizadas; assume o valor 1 para evitar a tokenização de strings não delimitadas por aspas após uma instrução DATA.

*   $0392 / 914 (2 bytes) (**{MEMSIZ}**,  **[LSTRAM]**)

    Topo da área para alocação de strings. Valor inicial: Endereço do topo da RAM subtraído de $0100 ($3EFF em 16KB, $BEFF em 48KB.)

*   $0394 / 916 (2 bytes) (**{SPTPTR}**,  **[TMSTPT]**)

    Aponta a próxima posição livre na pilha para registros de strings temporários. Valor inicial = $0396.

*   $0396 / 918 (12 bytes) (**{LSPTBG}**,  **[TMSTPL]**)

    Base da pilha para registros de strings temporários (cabem 3 registros, 4 bytes cada). Uma expressão do tipo  `"A"+("B"+("C"+("D")))`, que precisaria gerar quatro registros, produz erro "CC" (cadeia complexa).

*   $03A2 / 930 (4 bytes) (**{STRDAT}**,  **[TMPSTR]**)

    Área para montagem de registro de string temporário:

    -   $03A2 armazena o tamanho da string.
    -   $03A4 (2 bytes) armazena o endereço de início da string.

*   $03A6 / 934 (2 bytes) (**{SWAPTR}**,  **[STRBOT]**)

    Aponta o primeiro byte livre antes a área de alocação para strings. Quando uma nova string é alocada, seu valor é decrementado no tamanho da string. Valor inicial é o endereço do top da área (armazenado em $0392).

*   $03A8 / 936 (2 bytes) (**{LBYTEX}**,  **[CUROPR]**)

    ? {Index des zulletzt abge-arbeiteten bytes} [Current operator in EVAL]

*   $03AA / 938 (**{DATPTR}**),  **[DATLIN]**)

    ? {Zeilennummer des zuletzt gelesenen DATAstatements.} [Line of current DATA item.]

*   $03AC / 940 (**{FORFLG}**,  **[FORFLG]**)

    Tipo do identificador:

    -   $00 = variável.
    -   $01 = matriz.
    -   $64 = variável de controle de laço  `FOR`. (?)
    -   $80 = função do usuário (`FN XX`).

*   $03AD / 941 (**{IPHFLG}**,  **[LSTBIN]**)

    Último byte inserido no buffer de linha.

*   $03AE / 942 (**{RDFLAG}**,  **\<INPUT_OR_READ>**, **[READFG]**)

    Instrução de leitura sendo executada:

    -   $00 =  `INPUT`
    -   ≠ $00 =  `READ`

*   $03AF / 943 (2 bytes) (**{CUSTMT}**,  **\<PROG_PTR_TEMP>**,  **[BRKLIN]**)

    Aponta para o último byte antes da área de BASIC ($03D4). {Zeilennummer/Addresse des aktuellen statements} [Line of break].

    No primeiro byte se armazena $FF para o comando  `LOAD*`  e $01 para o comando  `SAVE*`.

*   $03B1 / 945 (2 bytes) (**{NTOKPT}**,  **[NXTOPR]**)

    Eventualmente(?) guarda o ponto atual da interpretação do programa BASIC. [Next operator in EVAL.]

*   $03B3 / 947 (2 bytes) (**{LLNOEX}**,  **[ERRLIN]**)

    Usado pelo comando  `CONT`  para retomar a execução do programa: Se ($03B5) = $00 então emite "NC ERRO" senão ($0347) ← ($03B3).

*   $03B5 / 949 (2 bytes) (**{LBYTER}**,  **[CONTAD]**)

    ? ($00 no primeiro byte)

*   $03B7 / 951 (2 bytes) (**{SVARPT}**,  **\<VAR_BASE>**,  **[PROGND]**)

    Aponta o início da área de variáveis (após o programa BASIC).

*   $03B9 / 953 (2 bytes) (**{DVARPT}**,  **\<VAR_ARRAY_BASE>**,  **[VAREND]**)

    Aponta o início da área de matrizes (após a área de variáveis).

*   $03BB / 955 (2 bytes) (**{FSLPTR}**,  **\<VAR_TOP>**,  **[ARREND]**)

    Aponta a área livre após a área de matrizes.

*   $03BD / 957 (2 bytes) (**{RDPTR}**,  **\<DATA_PROG_PTR>**, **[NXTDAT]**)

    Ponteiro de leitura das linhas  `DATA`. Valor inicial: Último byte antes da área de BASIC ($03D4).

*   $03BF / 959 (2 bytes)

    Aponta o registro no topo da pilha de registros de strings temporários, OU...

*   $03BF / 959 (4 bytes) (**{WRA1}**,  **\<FACCUM>**,  **[FPREG]**)

    Registro de número de ponto flutuante:

    -   $03BF armazena o byte menos significativo da mantissa.
    -   $03C0 armazena o byte intermediário da mantissa.
    -   $03C1 armazena byte mais significativo da mantissa (o 7º bit indica o sinal, 0 = positivo).
    -   $03C2 armazena o expoente somado de 129. Se este byte for zero, os outros bytes são desconsiderados e o valor de ponto flutuante é tido como zero. (**{WRA1+3}**, **[FPEXP]**)

    Registro de string:

    -   $03BF armazena o comprimento da string.
    -   $03C0 não armazena nenhuma informação significativa (lixo).
    -   $03C1 armazena o byte menos significativo do endereço do conteúdo da string.
    -   $03C2 armazena o byte mais significativo do endereço do conteúdo da string.

*   $03C3 / 963 (**{SGNORS}**,  **\<FTEMP_SIGN>**,  **[SGNRES]**)

    Usado para cálculo do sinal durante a montagem de registro de número de ponto flutuante. {Vorzeichen der operation} [Sign of result.]

*   $03C4 / 964 (? bytes) (**{INTPRB}**,  **[PBUFF]**)

    Usado para montar a string baseada no número de ponto flutuante armazenado em $03BF.

*   $03D4 / 980 (**{PRAM-1}**,  **[PROGST]**)

    Fim da área de variáveis do BASIC. Inicializado ("marcado") com $00.

*   $03D5 / 981 (**{PRAM}**)

    Posição padrão de início do programa BASIC.
# Variáveis do sistema

Divisão padrão da RAM (48 Kbytes) segundo o  [Manual do BASIC](manual_do_basic):

| Faixa (hex) | Faixa (dec) | Conteúdo |
| :---------: | :---------: | :------- |
| $0000–$00FF |    0–255    | Buffer de execução do programa DEBUG. |
| $0100–$01FF |   256–511   | Buffer de execução do Monitor. |
| $0200–$02FF |   512–767   | Buffer de linha. |
| $0300–$03D4 |   768–980   | Buffer de execução do interpretador BASIC. |
| $03D5–$BCFF |  981–48383  | Programa fonte BASIC. |
| $BD00–$BFFF | 48384–49151 | Stack e matriz do interpretador BASIC. |

* * *

## Buffer de execução do programa DEBUG

*   $0001 / 1

    Contém 0.

*   $0002 / 2 (**SNDSW**)

    ?

*   $0003 / 3 (**BYTE E/S**  ou  **IOBYTE**)

    Manual de Referência (p.24):

    > No MONITOR, se você usar o subcomando  `D`  para exibir alguns dados, esses serão mostrados na tela, no entanto, como listá-los na impressora? Use o subcomando  `S`  para examinar o endereço 3; seu valor é 41H. Agora mude o seu conteúdo para qualquer outro dado e use o subcomando  `D`  novamente. Os dados aparecem todos no papel.

*   $000F / 15 (**C40?80**)

    Flag de largura da tela:

    -   0 = 32 colunas
    -   ≠ 0 = 80 colunas

    Manual de Referência (p.12):
    > Chave de 32/80 colunas: quando o conteúdo deste buffer for zero, a tela mostrará 32 colunas, caso contrário o computador estará na modalidade de 80 colunas.

    Manual de Referência (p.24):
    > Eis aqui o buffer da chave de exibição do vídeo para 32/80 colunas. Quando o conteúdo do endereço 000FH for 0, então a saída do console será em 32 colunas; se o valor for 1, o cartão de 80 colunas está instalado.
    > 
    > Logicamente, você pode mudar o valor de 0 para 1 mas, depois você terá que chamar a sub-rotina ISCN (C021H), caso contrário, a tela apresentará informações incompreensíveis.

*   $0038 / 56 (3 bytes)

    *Hook*  da rotina de interrupção periódica do Z80. Na inicialização é configurada com um salto para a rotina  INTRUP  ($C55F), responsável pelo tratamento da instrução  `SOUND`  e da música de fundo dos jogos.

*   $00F5 / 245 (**MODBUF**)

    Número do  [modo de vídeo](modos_de_video)  atual, segundo o VDG. O valor contido aqui é lançado na porta  COL32  ($80) para habilitar a escrita na VRAM nos eventos de vídeo: limpeza de tela, intermitência do cursor, impressão de caracteres, plotagem de linhas, etc.

    -   $01 / 1 =  `TEXT`
    -   $88 / 136 =  `GR`
    -   $9F / 159 =  `HGR`

*   $00F6 / 246 (**CLR**)

    Valor de  `COLOR`  (0–3).

    Manual de Referência (p.24):

    > O código de cor de Baixa Resolução é armazenado aqui, com valores legais de 0 a 3.

*   $00F7 / 247 (2 bytes) (**UPDBM**)

    Endereço da rotina para acender e/ou apagar o cursor. Contém $CB1D em caso de 32 colunas (atribuído pela rotina $C841), que inverte o caracter sob o cursor; ou $CB3F no caso de 80 colunas (atribuído na rotina $C7EC), que apenas posiciona o cursor, pois o hardware de 80 colunas se ocupa do piscamento.

*   $00F9 / 249 (2 bytes) (**UPDBCM**)

    Endereço da rotina para apagar o cursor se ele estiver aceso. Contém $CB2D em caso de 32 colunas (atribuído pela rotina $C841), que chama a rotina apontada por UPDBM caso FSHCNT seja par; ou $CB3F em caso de 80 colunas (atribuído pela rotina $C7EC), que apenas posiciona o cursor, pois o hardware de 80 colunas se ocupa do piscamento.

*   $00FB / 251 (2 bytes) (**STAR**)

    Início do bloco de memória a salvar para a fita.

    Manual de Referência (p.25):

    > Este buffer tem dois bytes; quando você chamar a sub-rotina de entrada/saída por fita, coloque o endereço de início do bloco de dados salvo/carregado nesse buffer. O byte baixo em 00FBH e o byte alto em 00FCH.

*   $00FD / 253 (2 bytes) (**ENDT**)

    Byte seguinte ao fim do bloco de memória a salvar para a fita.

    Manual de Referência (p.25):

    > Ao salvar dados em fita cassete, coloque o endereço de fim do bloco de dados neste buffer antes de chamar a sub-rotina TAPOUT (C012H).

*   $00FF / 255 (**BORDER**)

    Média entre os comprimentos dos pulsos curtos (bits “1”) e longos (bits “0”) lidos da fita durante o tom piloto de um arquivo em [cassete](cassete). Esse valor serve como fronteira para diferenciar os dois bits.

* * *

## Buffer de execução do Monitor

*   $0103 / 259 (**PGM**  ou  **PGN**  ou  **MUSIC**)

    ?

*   $0104 / 260 (**PLAY**)

    "Tópico" de jogo atual.

    Manual de Referência (p.25):

    > Número da jogada atual no procedimento de disputa de jogo.

*   $0105 / 261 (**PLAYMX**)

    Quantidade de “tópicos” (modos, níveis, etc.) do jogo. Selecionam-se com \<CTRL>+\<H> e modificam o comportamento do jogo: cenário diferente, dificuldade diferente, um ou dois jogadores, etc. O ponto de entrada de execução de cada um dos tópicos é definido por uma sequência de instruções  `JP xxxx`  a partir do endereço $0200.

    Manual de Referência (p.25):

    > Número máximo da jogada no jogo atual.

*   $0106 / 262 (**HEAD**)

    -   $FF / 255 = Modo BASIC/MONITOR. A rotina de leitura de teclado KEY emite bip a cada tecla pressionada; a rotina SKEY? só reconhece uma tecla pressionada. A rotina TAPIN retorna após a leitura do nome do arquivo (para permitir a comparação com o nome de arquivo desejado) e a rotina GET1 *não*  inicia a execução do programa a partir de $0200 (comportamento do comando  `TLOAD`).
    -   ≠ $FF / 255 = [“Modo de jogo”](infraestrutura_para_jogos). A rotina de leitura de teclado KEY não emite bip a cada tecla pressionada; a rotina SKEY? reconhece até quatro teclas pressionadas simultaneamente. A combinação de teclas \<CTRL>+\<H> chama a rotina NEXTGM para alternar automaticamente entre “tópicos de jogo”. Os códigos retornados por algumas teclas e combinações são diferentes. Após a leitura do arquivo da fita, inicia-se a execução a partir do endereço $0200 (comportamento do comando  `TLOAD`). O valor é 1 durante o comando  `TLOAD`, e 0 depois.

    Manual de Referência (p.25):

    > Este é um buffer frequentemente usado. Na seção sobre o teclado, entrada/saída de fita, temos que verificar esse buffer. O buffer HEAD tem dois valores: 0FFH ou não. Quando você estiver em BASIC ou MONITOR, o valor desse buffer é 0FFH; se estiver jogando, o valor é diferente mas você não pode examiná-lo. Quando você chamar uma sub-rotina de E/S de fita como TAPIN/TAPOUT, certifique-se de que o valor é 0FFH.

*   $0107 / 263 (2 bytes) (**RANDOM**)

    Este valor é constantemente incrementado de $B2E7 (+45799 ou −19737) a cada leitura de teclado (SKEY?).

    Manual de Referência (p.25):

    > Buffer gerador de número randômico; cada vez que se chama a sub-rotina SKEY?, esse buffer de dois bytes muda uma vez.

*   $0109 / 265 (2 bytes) (**RCRDPT**)

    Endereço (+1) do último score armazenado na tabela de scores. Se RCRDPT = $011B (RECORD+16), a tabela está cheia.

*   $010B / 267 (16 bytes) (**RECORD**)

    8 pares de scores (jogadores 1 e 2). Os valores de SCOREA e SCOREB são transferidos para esta tabela pela rotina LSCORE.

*   $0113 / 275 (2 bytes) (**DLNG**)

    Largura da tela de texto. (Linha da tela, em bytes.)

    Manual de Referência (p.25):

    > A sub-rotina de saída do console tem muitos buffers; este aqui é usado para armazenar o comprimento da tela. O buffer conterá 32/80 quando você estiver usando 32/80 colunas.

*   $0115 / 277 (**YCORD**)

    Código ASCII do primeiro caracter impresso após uma sequência ESC + “=”. Indica a linha onde se vai posicionar o cursor.

*   $0116 / 278 (**XCORD**)

    Código ASCII do segundo caracter impresso após uma sequência ESC + “=”. Indica a coluna onde se vai posicionar o cursor.

*   $011B / 283 (4 bytes) (**KEY0**)

    Em modo BASIC/MONITOR (HEAD = $FF), a rotina SKEY? retorna em KEY0 o código ASCII da última tecla pressionada, e KEY? o copia para KEY0+1. Em “modo de jogo” (HEAD ≠ $FF), SKEY? retorna até 4 teclas pressionadas simultaneamente em KEY0—KEY0+3.

    Manual de Referência (p.26):

    > Buffer temporário do código de tecla. Quando o computador varre o teclado e algumas teclas forem pressionadas, o código ASCII será armazenado temporariamente neste buffer. Assim, você pode obter o código de tecla diretamente daqui; em especial, quando HEAD não for 0FFH, pode haver 4 teclas pressionadas simultaneamente (verifique o registrador A após chamar KEY? (C009H) para verificar quantas teclas foram pressionadas.) Nesse caso, você terá que obter os códigos de tecla em KEY0...KEY+3.

*   $0120 / 288 (3 bytes) (**JOB**)

    Primeiro *hook* chamado durante a leitura de teclado (SKEY?). Valor default: $C9 (`RET`) no primeiro byte.

    Manual de Referência (p.26):

    > Ponto de entrada de sub-rotina definida pelo usuário. Este buffer de três bytes normalmente contém um código de retorno (0C9H). Em muitos jogos, nós o usamos para fazer a entrada na sub-rotina do contador de tempo. Logicamente, você pode usá-lo para fazer outras coisas. Cada vez que o teclado é varrido (sub-rotina SKEY?), esse ponto de entrada será chamado uma vez.

*   $0123 / 291 (**SCOREA**)

    Placar atual do jogador 1.

*   $0124 / 292 (**SCOREB**)

    Placar atual do jogador 2.

*   $0125 / 293 (**SHAPE0**)

    Indica se foi detectada colisão durante a última execução da rotina SHAPOF.
    
    -   $00 = Não houve colisão.
    -   $01 = Houve colisão.

*   $0126 / 294 (**KTIME**)

    A rotina NEXTGM registra aqui o tempo durante o qual a combinação de teclas \<CTRL>+\<H> está sendo pressionada, para fazer uma pausa antes de mudar de tópico de jogo.

*   $0128 / 296 (**PNTR**)

    Direcionamento da impressão:
    -   $00 = Impressão na tela (default)
    -   $02 = impressora e tela?

*   $012D / 301 (**COSW**)

    Alguns flags de controle do modo texto:
    
    -   Bit 0 ligado = “Lead-in”. Estamos no meio de uma sequência de escape (ESC + “=” + dois outros caracteres) para  [posicionar o cursor](posicionamento_do_cursor). Este flag é ligado no momento da impressão do ESC e continua assim até a sequência terminar ou ser interrompida (se o segundo caracter não for “=”).
    -   Bit 7 ligado = Já foi impresso “=” após o ESC. Aguardando mais dois caracteres.
    -   Bit 6 ligado = Já foram impressos “=” e outro caracter (informando a linha na qual posicionar o cursor) após o ESC. Aguardando o último caracter (coluna do cursor).
    -   Bit 1 ligado = Existe monitor de 80 colunas presente.

    Manual de Referência (p.12):

    > Quando este buffer contiver o valor zero no bit 1, então o cartão de 80 colunas estará instalado.
    > 
    > NOTA: não mude os dados deste buffer.

    Manual de Referência (p.26):

    > Chave de funções de saída do console. Seu mapa de bits é:
    >
    > ```
    > ------------------
    >  ! ! ! ! ! ! ! ! !
    > ------------------
    >  ! !         ! !-----> LEAD-IN
    >  ! !         !-------> Cartão de 80 colunas existente
    >  ! !
    >  ! !-----------------> Coordenadas Y do endereço direto do cursor.
    >  !-------------------> endereço direto do cursor.
    > ```
    >
    > Nós estudaremos este buffer detalhadamente mais tarde.

*   $012E / 302 (**KEYSW**)

    Usado pelas rotina de leitura de teclado KEY e KEY?. Geralmente contém $00. Contém $FF enquanto uma tecla estiver sendo pressionada.

*   $012F / 303 (**FSHCNT**)

    Estado atual da intermitência do cursor. É constantemente incrementado. Um número par indica cursor aceso.

*   $0130 / 304 (3 bytes) (**JOBM**)

    Segundo *hook* chamado durante a leitura do teclado (SKEY?). Contém $C9 (`RET`) no primeiro byte durante os primeiros momentos da inicialização; depois $C3,$E9,$C0 (`JP $C0E9`).

    Manual de Referência (p.26):

    > Este é um outro ponto de entrada de sub-rotina programada, mas diferente de JOB; esta entrada é usada pelo MONITOR para fazer o cursor piscar. Você pode checar este buffer de 3 bits para ver se é uma instrução para pular. O único dado que você pode usar para recolocar o código (C3) é  `RETURN`  (C9), e o cursor não piscará mais.
    > 
    > Tenha cuidado para não trocar os conteúdos da JOBM+1 e JOBM+2.

*   $0133 / 307 (**FLASHB**)

    Contador para intermitência do cursor. Valor continuamente decrementado a cada leitura de teclado (rotina SKEY?). Quando atinge 0, soma-se 1 a FSHCNT ($012F).

*   $0135 / 309 (**TABLE**  ou  **NSA**)

    ?

*   $0137 / 311 (2 bytes) (**NAA**)

    Aponta para os dados de música no canal 1.

*   $0139 / 313 (**AVALUE**)

    2º parâmetro de  `TEMPO` no canal 1.

*   $013A / 314 (**VOICEA**)

    ?

*   $013B / 315 (**INTRPA**)

    Quantidade de interrupções para cada unidade de TEMPA.

*   $013C / 316 (**TEMPA**)

    Contador de duração da nota (decrementado cada vez que INTA atinge INTRPA).

*   $013D / 317 (**INTA**)

    Contador de interrupções (incrementado a cada interrupção até atingir o valor de INTRPA), quando é zerado de novo.

*   $013E / 318 (**NSB**)

    ?

*   $0140 / 320 (2 bytes) (**NBB**)

    Aponta para os dados de música no canal 2.

*   $0142 / 322 (**BVALUE**)

    2º parâmetro de  `TEMPO`  no canal 2.

*   $0143 / 323 (**VOICEB**)

   ?

*   $0144 / 324 (**INTRPB**)

    ?

*   $0145 / 325 (**TEMPB**)

    ?

*   $0146 / 326 (**INTB**)

    ?

*   $0147 / 327 (**NSC**)

    ?

*   $0149 / 329 (2 bytes) (**NCC**)

    Aponta para os dados de música no canal 3.

*   $014B / 331 (**CVALUE**)

    2º parâmetro de  `TEMPO`  no canal 3.

*   $014C / 332 (**VOICEC**)

    ?

*   $014D / 333 (**INTRPC**)

    ?

*   $014E / 334 (**TEMPC**)

    ?

*   $014F / 335 (**INTC**)

    ?

*   $0150 / 336 (**ENABLE**)

    Valor lançado ao registrador MIXER do AY-3-8910. Default = $7F (nenhum som).

*   $0151 / 337 (**AMPLIT**)

    Seleciona o registrador de amplitude do AY-3-8910 correspondente ao canal que será modificado. Pode conter $08 (canal A), $09 (canal B) ou $0A (canal C).

*   $0152 / 338 (2 bytes) (**REGIST**)

    Seleciona os registradores de tom do AY-3-8910 correspondentes ao canal que será modificado. Pode conter $00,$01 (canal A) ou $02,$03 (canal B) ou $04,$05 (canal C).

*   $0154 / 340 (**DEFIN**)

    Valor a ser  `AND`-ado com ENABLE para habilitar o tom do canal.

*   $0155 / 341 (2 bytes) (**ONAMP**)

    No byte mais significativo: valor para armazenar em AMPLIT; no byte menos significativo: valor par ser  `OR`-ado com ENABLE para desligar o tom e o ruído do canal.

*   $0157 / 343 (**LPLAY**)

    ?

*   $0158 / 344 (**MODEK**)

    Número do modo de vídeo segundo o MC6847 durante o acesso ao cassete: $01 = tela verde; $03 = tela vermelha.

*   $0159 / 345 (2 bytes) (**LNHD**)

    Endereço na VRAM do início da linha atual do cursor.

    Manual de Referência (p.28):

    > O LNHD guarda o endereço de início de cada linha.

*   $015B / 347 (2 bytes) (**SNPTR**)

    Endereço na VRAM da posição atual do cursor.

    Manual de Referência (p.28):

    > O SNPTR guarda a posição do cursor.

*   $015D / 349 (**LCNT**)

    Coluna atual do cursor na tela de texto.

    Manual de Referência (p.28):

    > O LCNT [guarda] o número da coluna.

*   $015E / 350 (**CHECK**)

    ?. Inicializado com $5A / 90.

*   $0163 / 355 (2 bytes) (**DSNAM**)

    Endereço na VRAM de início da tela de texto:

    -   $8000 em caso de 32 colunas
    -   $2000 em caso de 80 colunas

    Manual de Referência (p.28):

    > Buffer para guardar o endereço de início na VRAM 6847/6845 da janela atual da tela.

*   $0165 / 357 (2 bytes) (**DENAM**)

    Endereço na VRAM do fim da tela de texto, somado de 1:

    -   $8200 em caso de 32 colunas
    -   $2780 em caso de 80 colunas

    Manual de Referência (p.28):

    > Buffer para guardar o endereço de término na VRAM 6847/6845 da janela atual da tela. Você pode usar esse buffer para dividir a tela.

*   $0167 / 359 (**HISCOR**)

    ?

*   $0169 / 361 (**TEMP**)

    ?

*   $016C / 364 (**RIGHTJ**)

    ?

*   $016D / 365 (**CHANA**)

    ?

*   $016F / 367

    1º parâmetro de  `TEMPO`  no canal 1.

*   $0171 / 369

    Nota no canal 1.

*   $0172 / 370 (**TONEA**)

    Duração da nota no canal 1.

*   $0173 / 371 (**CHANB**)

    ?

*   $0175 / 373

    1º parâmetro de  `TEMPO`  no canal 2.

*   $0177 / 375

    Nota no canal 2.

*   $0178 / 376 (**TONEB**)

    Duração da nota no canal 2.

*   $0179 / 377 (**CHANC**)

    ?

*   $017B / 389

    1º parâmetro de  `TEMPO`  no canal 3.

*   $017D / 381

    Nota no canal 3.

*   $017E / 382 (**TONEC**)

    Duração da nota no canal 3.

*   $017F / 383 (14 bytes) (**OBUF**)

    Nome do arquivo sendo lido da fita. Se o nome tiver menos de 14 bytes, um $0D segue o último caracter.

    Manual de Referência (p.28):

    > Se você chamar TAPIN (0C00FH), essa sub-rotina lerá o nome-de-arquivo da fita cassete e armazenará o mesmo neste buffer, sendo o comprimento máximo do mesmo 14 bytes (incluindo o \<RETURN>).
    > 
    > Suponha que você queira ler um arquivo da fita cassete onde foram guardados muitos arquivos. Você tem que comparar o nome-de-arquivo que você quer ler com este buffer. Se eles forem iguais, então chame o GET1 em seguida.

*   $018D / 397 (14 bytes) (**FILNAM**)

    Nome do arquivo sendo salvo na fita. Se o nome tiver menos de 14 bytes, um $0D segue o último caracter.

    Manual de Referência (p.28):

    > Ao contrário de OBUF, usa-se este buffer de 14 bytes para armazenar o nome-de-arquivo cujo bloco de dados você quer guardar na fita cassete. O nome-de-arquivo deve terminar com \<RETURN> ou ter 14 bytes de comprimento.

* * *

## Buffer de linha

*   $0200 / 512 (256 bytes) (**{INPBUF}**,  **\<LINE_BUFFER>**)

    Espaço onde se armazena uma linha de comando ou dados digitada pelo usuário.

* * *

## Buffer de execução do interpretador BASIC

*   $0300 / 768 (77 bytes) (**{WSP}**, **[WRKSPC]**)

    O bloco $0300–$034D é copiado a partir de um bloco da ROM ($D792–$D7DF) no momento da inicialização.  

    ```
    ; {WSP} [WRKSPC]
    0300  C32DCF    JP      #CF2D
    ; BUSR:
    ; {USRLOC} [USR]
    ; Ponto de entrada da função USR.
    0303  C3F6DE    JP      #DEF6 ; PIERRO
    ; OUTAUX:
    ; {PORTAD} [OUTSUB]
    ; Rotina auxiliar para OUT.
    0306  D300      OUT     (#00),A; #0307:{PORTAD+1} [OTPORT]
    0308  C9        RET
    ; {DIVVAR} [DIVSUP]
    ; Rotina auxiliar para DIV.
    ; Os valores #00 serão substituídos.
    0309  D600      SUB     #00 ; #030A:{DVAR1} [DIV1]
    030B  6F        LD      L,A
    030C  7C        LD      A,H
    030D  DE00      SBC     A,#00 ; #030E:{DVAR2} [DIV2]
    030F  67        LD      H,A
    0310  78        LD      A,B
    0311  DE00      SBC     A,#00 ; #0312:{DVAR3} [DIV3]
    0313  47        LD      B,A
    0314  3E00      LD      A,#00 ; #0315:{DVAR4} [DIV4]
    0316  C9        RET
    ; Dados auxiliares para RND().
    ; {RNDVR1} [SEED]
    0317  00        DB      #00
    ; {RNDVR2}
    0318  00        DB      #00
    ; {RNDVR3}
    0319  00        DB      #00
    031A  354ACA99  DB      #35,#4A,#CA,#99 ; -2.65145E+7
    031E  391C7698  DB      #39,#1C,#76,#98 ; +1.61291E+7
    0322  2295B398  DB      #22,#95,#B3,#98 ; -1.17691E+7
    0326  0ADD4798  DB      #0A,#DD,#47,#98 ; +1.30983E+7
    032A  53D19999  DB      #53,#D1,#99,#99 ; -2.01612E+7
    032E  0A1A9F98  DB      #0A,#1A,#9F,#98 ; -1.04269E+7
    0332  65BCCD98  DB      #65,#BC,#CD,#98 ; -1.34831E+7
    0336  D6773E98  DB      #D6,#77,#3E,#98 ; +1.24825E+7
    ; {RNDV4} [LSTRND]
    033A  52C74F80  DB      #52,#C7,#4F,#80 ; .811653
    ; INPAUX:
    ; [INPSUB]
    ; Rotina auxiliar para INP().
    033E  DB00      IN      A,(#00) ; #033F:[INPORT]
    0340  C9        RET
    ; {DUMMY} <TERMINAL_Y> [NULLS]
    ; Quantidade de caracteres ASCII NULL a serem impressos
    ; após um CR+LF.
    ; (O Altair BASIC tinha um comando "NULL" para definir este valor.)
    0341  01        DB      #01
    ; {LINLEN} [LWIDTH]
    ; Limite máximo de POS(). Também recebe o valor de WIDTH.
    0342  FF        DB      #FF
    ; Valor de WIDTH para "PRINT ,".
    ; {PRLISI} [COMMAN]
    0343  FF        DB      #FF
    ; {OUTFLG} [CTLOFG]
    ; Suprime a impressão de caracteres quando <> 0.
    0344  00        DB      #00
    ; {STDPTR} <STACK_TOP> [STRSPC]
    ; Base da pilha do Z80; Último endereço disponível
    ; para o BASIC antes da área de strings.
    0345  3804      DB      #0438
    ; {CULINO} <CURRENT_LINE> [LINEAT]
    ; Número de linha BASIC em execução. #FFFF após execução.
    0346  FEFF      DB      #FFFE
    ; {PSTBEG} <PROGRAM_BASE> [BASTXT]
    ; Endereço de início do programa BASIC.
    0348  D503      DB      #03D5 ; {PRAM}
    ```

*   $033A / 826 (4 bytes) (**{RNDV4}**, **[LSTRND]**)

    Último número de ponto flutuante gerado pela função  `RND()`. É o valor retornado por  `RND(0)`. Contém inicialmente $52,$C7,$4F,$80 (0,811635).

*   $0341 / 833 (**{DUMMY}**,  **\<TERMINAL_Y>**,  **[NULLS]**)

    Quantidade (+1) de caracteres ASCII NULL ($00) a serem impressos após um CR+LF, provavelmente devido a alguma peculiaridade dos equipamentos de teletipo da época do Altair BASIC. O Altair BASIC tinha um comando  `NULL`  para definir o valor desta variável. Valor inicial = $01 (i.e., nenhum NULL).

*   $0342 / 834 (**{LINLEN}**,  **[LWIDTH]**)

    Limite máximo do valor da função  `POS()`. O default é $FF (255). (Recebe valor do comando `WIDTH`, assim como $0343.)

*   $0343 / 835 (**{PRLISI}**,  **[COMMAN]**)

    Valor do comando `WIDTH`. [Width for commas.]

*   $0344 / 836 (**{OUTFLG}**,  **[CTLOFG]**)

    Suprime impressão de caracteres se diferente de zero. Valor inicial = $00. Após um  `LOAD`  sem nome de arquivo (o programa executa automaticamente), contém $01. É preciso inclui um  `POKE 836,0`  no início dos programas BASIC carregados sem nome de arquivo para garantir que os comandos  `PRINT`  funcionem.

*   $0345 / 837 (2 bytes) (**{STDPTR}**,  **\<STACK_TOP>**,  **[STRSPC]**)

    Durante a inicialização, armazena $0438: endereço temporário para a base da pilha do Z80. Depois da inicialização, armazena o endereço do topo da RAM subtraído de $0300: O topo da área disponível para o programa BASIC e suas variáveis. ($3CFF em 16KB, $BCFF em 48KB.)

*   $0347 / 839 (2 bytes) (**{CULINO}**,  **\<CURRENT_LINE>**,  **[LINEAT]**)

    Número de linha do programa BASIC em execução. Valor inicial = $FFFE.

*   $0349 / 841 (2 bytes) (**{PSTBEG}**,  **\<PROGRAM_BASE>**,  **[BASTXT]**)

    Aponta a base da área disponível para o programa BASIC e suas variáveis. Valor inicial = $03D5.

*   $034E / 846 (2 bytes)

    Durante a inicialização, armazena um endereço temporário para a base da pilha do Z80.

*   $0351 / 849 (**{INPBUF+6}**,  **[STACK]**)

    Quantidade de caracteres no buffer de linha, + 1.

*   $0352 / 850

    Flag  `NORMAL`/`INVERSE`:

    -   $00 =  `NORMAL`  (default)
    -   ≠ $00 =  `INVERSE`

*   $0353 / 851

    ?. Inicializado com $FF.

*   $0354 / 852

    Flag de  `PLOT`/`UNPLOT`  (usado internamente pelos comandos):

    -   $00 =  `UNPLOT`
    -   $01 =  `PLOT`

*   $0357 / 855

    Flag de trace:

    -   $00 =  `TROF`  (default)
    -   $01 =  `TRON`

*   $0358 / 856

    Modo de vídeo:

    -   $00 =  `TEXT`  (default)
    -   $01 =  `GR`
    -   $02 =  `HGR`

*   $0359 / 857

    Coordenada Y do último ponto plotado. Valor inicial: $00.

*   $035A / 858

    Coordenada X do último ponto plotado. Valor inicial: $00.

*   $035B / 859 (2 bytes)

    Número de linha atual gerada pelo comando  `AUTO`.

*   $035D / 861 (**{AUTOFG}**)

    Flag de  `AUTO`.

*   $035E / 862 (2 bytes)

    Última linha a ser gerada pelo comando  `AUTO`.

*   $0360 / 864

    Flag de  `FAST`/`SLOW`:

    -   $00 =  `FAST`  (default)
    -   $01 =  `SLOW`

*   $0361 / 865

    ≠ 0 indica que o programa foi carregado sem nome e que deve ser automaticamente executado. Valor inicial: $00.

*   $038D / 909 (**{EOINPB}**,  **[BUFFER+72+1]**)

    Fim do buffer de linha em outros BASICs. Inicializado ("marcado") com $00.

*   $038E / 910 (**{CURPOS}**,  **[CURPOS]**)

    Valor da função  `POS()`.

*   $038F / 911 (**{LOCCRE}**,  **\<DIM_OR_EVAL>**, **[LCRFLG]**)

    ≠ 0 indica  `DIM`ensionamento de matriz; = 0 indica apenas acesso. [Locate/Create flag.]

*   $0390 / 912 (**{DATYPE}**,  **[TYPE]**)

    Usado para determinar o tipo de uma variável: 0 = numérico; 1 = string.

*   $0391 / 913 (**{DSTMNT}**,  **[DATFLG]**)

    Durante a tokenização das palavras reservadas de uma linha, 0 indica que as palavras devem ser tokenizadas; assume o valor 1 para evitar a tokenização de strings não delimitadas por aspas após uma instrução DATA.

*   $0392 / 914 (2 bytes) (**{MEMSIZ}**,  **[LSTRAM]**)

    Topo da área para alocação de strings. Valor inicial: Endereço do topo da RAM subtraído de $0100 ($3EFF em 16KB, $BEFF em 48KB.)

*   $0394 / 916 (2 bytes) (**{SPTPTR}**,  **[TMSTPT]**)

    Aponta a próxima posição livre na pilha para registros de strings temporários. Valor inicial = $0396.

*   $0396 / 918 (12 bytes) (**{LSPTBG}**,  **[TMSTPL]**)

    Base da pilha para registros de strings temporários (cabem 3 registros, 4 bytes cada). Uma expressão do tipo  `"A"+("B"+("C"+("D")))`, que precisaria gerar quatro registros, produz erro "CC" (cadeia complexa).

*   $03A2 / 930 (4 bytes) (**{STRDAT}**,  **[TMPSTR]**)

    Área para montagem de registro de string temporário:

    -   $03A2 armazena o tamanho da string.
    -   $03A4 (2 bytes) armazena o endereço de início da string.

*   $03A6 / 934 (2 bytes) (**{SWAPTR}**,  **[STRBOT]**)

    Aponta o primeiro byte livre antes a área de alocação para strings. Quando uma nova string é alocada, seu valor é decrementado no tamanho da string. Valor inicial é o endereço do top da área (armazenado em $0392).

*   $03A8 / 936 (2 bytes) (**{LBYTEX}**,  **[CUROPR]**)

    ? {Index des zulletzt abge-arbeiteten bytes} [Current operator in EVAL]

*   $03AA / 938 (**{DATPTR}**),  **[DATLIN]**)

    ? {Zeilennummer des zuletzt gelesenen DATAstatements.} [Line of current DATA item.]

*   $03AC / 940 (**{FORFLG}**,  **[FORFLG]**)

    Tipo do identificador:

    -   $00 = variável.
    -   $01 = matriz.
    -   $64 = variável de controle de laço  `FOR`. (?)
    -   $80 = função do usuário (`FN XX`).

*   $03AD / 941 (**{IPHFLG}**,  **[LSTBIN]**)

    Último byte inserido no buffer de linha.

*   $03AE / 942 (**{RDFLAG}**,  **\<INPUT_OR_READ>**, **[READFG]**)

    Instrução de leitura sendo executada:

    -   $00 =  `INPUT`
    -   ≠ $00 =  `READ`

*   $03AF / 943 (2 bytes) (**{CUSTMT}**,  **\<PROG_PTR_TEMP>**,  **[BRKLIN]**)

    Aponta para o último byte antes da área de BASIC ($03D4). {Zeilennummer/Addresse des aktuellen statements} [Line of break].

    No primeiro byte se armazena $FF para o comando  `LOAD*`  e $01 para o comando  `SAVE*`.

*   $03B1 / 945 (2 bytes) (**{NTOKPT}**,  **[NXTOPR]**)

    Eventualmente(?) guarda o ponto atual da interpretação do programa BASIC. [Next operator in EVAL.]

*   $03B3 / 947 (2 bytes) (**{LLNOEX}**,  **[ERRLIN]**)

    Usado pelo comando  `CONT`  para retomar a execução do programa: Se ($03B5) = $00 então emite "NC ERRO" senão ($0347) ← ($03B3).

*   $03B5 / 949 (2 bytes) (**{LBYTER}**,  **[CONTAD]**)

    ? ($00 no primeiro byte)

*   $03B7 / 951 (2 bytes) (**{SVARPT}**,  **\<VAR_BASE>**,  **[PROGND]**)

    Aponta o início da área de variáveis (após o programa BASIC).

*   $03B9 / 953 (2 bytes) (**{DVARPT}**,  **\<VAR_ARRAY_BASE>**,  **[VAREND]**)

    Aponta o início da área de matrizes (após a área de variáveis).

*   $03BB / 955 (2 bytes) (**{FSLPTR}**,  **\<VAR_TOP>**,  **[ARREND]**)

    Aponta a área livre após a área de matrizes.

*   $03BD / 957 (2 bytes) (**{RDPTR}**,  **\<DATA_PROG_PTR>**, **[NXTDAT]**)

    Ponteiro de leitura das linhas  `DATA`. Valor inicial: Último byte antes da área de BASIC ($03D4).

*   $03BF / 959 (2 bytes)

    Aponta o registro no topo da pilha de registros de strings temporários, OU...

*   $03BF / 959 (4 bytes) (**{WRA1}**,  **\<FACCUM>**,  **[FPREG]**)

    Registro de número de ponto flutuante:

    -   $03BF armazena o byte menos significativo da mantissa.
    -   $03C0 armazena o byte intermediário da mantissa.
    -   $03C1 armazena byte mais significativo da mantissa (o 7º bit indica o sinal, 0 = positivo).
    -   $03C2 armazena o expoente somado de 129. Se este byte for zero, os outros bytes são desconsiderados e o valor de ponto flutuante é tido como zero. (**{WRA1+3}**, **[FPEXP]**)

    Registro de string:

    -   $03BF armazena o comprimento da string.
    -   $03C0 não armazena nenhuma informação significativa (lixo).
    -   $03C1 armazena o byte menos significativo do endereço do conteúdo da string.
    -   $03C2 armazena o byte mais significativo do endereço do conteúdo da string.

*   $03C3 / 963 (**{SGNORS}**,  **\<FTEMP_SIGN>**,  **[SGNRES]**)

    Usado para cálculo do sinal durante a montagem de registro de número de ponto flutuante. {Vorzeichen der operation} [Sign of result.]

*   $03C4 / 964 (? bytes) (**{INTPRB}**,  **[PBUFF]**)

    Usado para montar a string baseada no número de ponto flutuante armazenado em $03BF.

*   $03D4 / 980 (**{PRAM-1}**,  **[PROGST]**)

    Fim da área de variáveis do BASIC. Inicializado ("marcado") com $00.

*   $03D5 / 981 (**{PRAM}**)

    Posição padrão de início do programa BASIC.
