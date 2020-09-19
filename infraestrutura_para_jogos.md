
# Infraestrutura para jogos

Quem já jogou os [jogos originais](software) do MC1000 percebe funcionalidades comuns a eles: usam o [modo gráfico](modos-de-video) `GR` (*Color Graphics 2*: 128×64 pixels, 4 cores), a tela de placar é idêntica, usam a combinação de teclas \<CTRL>+\<H> para alternar entre níveis de jogo, etc. Mais do que uma simples padronização seguida pelos programadores de cada jogo, isso faz parte de uma infraestrutura para jogos embutida na ROM do micro.

## O que o `TLOAD` faz

O comando `TLOAD` é específico para carregar e disparar os jogos em linguagem de máquina. Carrega os dados da fita a partir do endereço $0100. Os primeiros 256 bytes lidos não são o programa em si, mas sim valores iniciais para as [variáveis do sistema](variaveis_do_sistema) que ficam entre $0100 e $01FF. O código executável é carregado a partir de $0200. Depois da carga, os registradores SP (*Stack Pointer*) e PC (*Program Counter*) do Z80 são também inicializados em $0200, dando início à execução do programa em si. (Note-se que com isso a pilha usa a parte final dessa área de variáveis carregadas. Deve-se tomar cuidado para ela não crescer demais e colidir com alguma variável do sistema que esteja efetivamente sendo usada. Se o programa exigir uma pilha com maior capacidade, o programador deve alterar o SP e usar a pilha em outro lugar.)

Certas variáveis devem ser inicializadas com atenção para que o computador não trave. O valor lido da fita para a variável HEAD precisa ser zero, senão o comando `TLOAD` não consegue terminar. Se for usar as rotinas de leitura do teclado (KEY, KEY? e SKEY?), é preciso dar valores adequados para as variáveis PLAY e PLAYMX (veja abaixo) e JOB e JOBM (*hooks* executados durante leitura do teclado; cada *hook* ocupa 3 bytes e podem conter uma instrução `JP` do Z80; se não interessar, coloque-se uma instrução `RET` no 1º byte). Se não houver fundo musical no jogo, as variáveis AVALUE, BVALUE e CVALUE (e CHECK também?) devem estar zeradas.

## A variável HEAD e o modo de jogo

Uma das variáveis cujo valor o `TLOAD` traz da fita é a variável HEAD ($0106). Durante a execução do interpretador BASIC ou do MONITOR, seu valor é $FF / 255. Os jogos carregam nessa variável o valor zero, e aí o computador funciona no que se pode chamar de “modo de jogo”.
Em modo de jogo a rotina de leitura do teclado SKEY? (que é chamada também por KEY e KEY?) identifica não apenas uma tecla pressionada, mas até quatro. Supostamente essa quantidade foi estabelecida para permitir capturar a pressão simultânea de direção + botão de tiro nos dois joysticks.

## A alternância automática entre tópicos de jogo com \<CTRL>+\<H>

Em modo de jogo, quando a rotina de leitura do teclado SKEY? identifica a combinação \<CTRL>+\<H>, ela chama uma rotina NEXTGM ($C045→$CBD5) para fazer automaticamente a mudança do que o Manual de Referência chama de “tópico de jogo”. É o equivalente à tecla SELECT existente no antigo vídeo-game [Atari 2600](https://pt.wikipedia.org/wiki/Atari_2600). NEXTGM incrementa o valor da variável PLAY ($0104), onde fica armazenado o número do tópico de jogo atual (≥1). Na variável PLAYMX ($0105) fica armazenado o número do tópico máximo, depois do qual PLAY volta para 1.

A partir do endereço $0200 há uma “tabela de saltos”, uma sequência de comandos `JP` que transferem o controle à rotina correspondente a cada tópico de jogo. Depois de atualizar PLAY para o próximo número de tópico de jogo, o salto correspondente ao novo valor é executado.

Por exemplo, o jogo “Othello (Go)” tem 5 tópicos. Os quatro primeiros correspondem a diferentes formas de jogar, e o quinto exibe o placar. Neste jogo, PLAY é inicializado com 1, PLAYMX com 5, e a partir do endereço $0200 temos os 5 saltos para cada tópico:

    0200  c3560c    jp      #0c56
    0203  c3840c    jp      #0c84
    0206  c3920c    jp      #0c92
    0209  c3a00c    jp      #0ca0
    020c  c34bc0    jp      #c04b ; SCORE

Já o jogo “Batalha com Tanques” tem 17 tópicos (PLAYMX = 17), e a tabela de saltos é assim:

    0200  c37904    jp      #0479
    0203  c37904    jp      #0479
    0206  c37904    jp      #0479
    0209  c37904    jp      #0479
    020c  c37904    jp      #0479
    020f  c37904    jp      #0479
    0212  c37904    jp      #0479
    0215  c37904    jp      #0479
    0218  c37904    jp      #0479
    021b  c37904    jp      #0479
    021e  c37904    jp      #0479
    0221  c37904    jp      #0479
    0224  c37904    jp      #0479
    0227  c37904    jp      #0479
    022a  c37904    jp      #0479
    022d  c37904    jp      #0479
    0230  c34bc0    jp      #c04b ; SCORE

Aqui todos os 16 tópicos de jogo saltam para a mesma rotina. A diferença entre os tópicos de jogo (tipo de labirinto, número de jogadores, velocidade dos tanques) é decidida por essa única rotina, com base no valor da variável PLAY.

Se um programa não tiver múltiplos tópicos de jogo, a tabela de saltos é dispensável. Basta inicializar PLAY e PLAYMX com 1, e o programa pode efetivamente começar a partir de $0200.

## Sistema de música

O ponto de entrada da interrupção periódica do Z80 ($0038) é configurado na inicialização da máquina com um salto para a rotina INTRUP ($C55F). Além de cuidar da temporização da instrução `SOUND` em BASIC, em modo de jogo ela executa música de fundo a partir de uma estrutura de dados específica para esse fim. (Ainda é preciso decifrar o funcionamento de INTRUP para documentar essa estrutura de dados.)

* * *

A ROM do MC1000 começa com uma “tabela de saltos” para rotinas localizadas mais adiante. Os pontos de entrada fixos são uma provisão para a eventualidade de mudanças na programação da ROM (uma nova versão, por exemplo) implicarem em mudanças nas posições das rotinas, o que “quebraria” programas preexistentes que contenham chamadas a essas rotinas.
Algumas dessas rotinas constantes na tabela de pontos de entrada pertencem à infraestrutura para jogos do MC1000. Note-se o uso consistente do modo gráfico `GR`.

*   XCLEAR ($C030→$CB61) — Preenche os primeiros 2KB de VRAM com um mesmo byte. (2KB é a memória ocupada pelo modo gráfico `GR`.)
*   D4X5 ($C036→$CB6D) — Copia para a VRAM um padrão de 5 bytes em linhas sucessivas (isto é, uma figura de 4×5 pixels nos modos gráficos coloridos).
*   TOP ($C039→$CB7D) — Limpa a tela em modo `GR` e exibe o número do tópico de jogo atual no canto superior esquerdo da tela.
*   DISPY2 ($C03F→$CB8D) — Exibe o valor decimal de um byte com até 2 dígitos.
*   SHOWNO ($C042→$CBAD) — Exibe um dígito de 0 a 9 (ou “←”, “→”, “✓”, “✗” ou espaço para valores de 10 a 14).
*   SCORE ($C04B→$CD95) — Entra em modo `GR` e exibe o registro de placares dos dois jogadores.
*   LSCORE ($C04E→$CE6E) — Transfere os últimos placares dos dois jogadores para a tabela de placares.
*   SHAPON ($C051→$CCBA) — Desenha uma figura na tela codificada como uma sequência de pares de bytes: deslocamento para a próxima posição na VRAM, byte a armazenar.
*   SHAPOF ($C054→$CCD7) — Apaga a figura previamente desenhada com SHAPON. Se algum byte na VRAM for diferente do byte do padrão colocado anteriormente, é possível que tenha ocorrido alguma colisão de figuras. O fato é sinalizado pela rotina colocando um valor diferente de zero na variável SHAPE0 ($0125).

(A continuar…)