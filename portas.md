# Portas

*   $00 / 0

    Manual de Referência (p.50):
    >   Quando você instala a interface da unidade de disco, o cartão da interface lhe oferecerá essa porta. Sua função com relação aos dados que passaram pelo "latch" é:
    >   *   bit 0=0, ativa a ROM do drive de inicialização.
    >   *   bit 0=1, desativa a ROM do drive de inicialização.
    >   *   bit 1=0, desativa o MONITOR e o interpretador BASIC (residente).
    >   *   bit 1=1, ativa o MONITOR e o interpretador.

*   $02 / 2

    Manual de Referência (p.50):
    >   Porta de acionamento liga/desliga dos motores da unidade de disco.
    >   Um outro manual sobre CP/M dará uma descrição mais detalhada sobre a unidade de disco.

*   $04 / 4 (**SPORT**/**STROB**)

    Status da impressora (bit 0 = 1: ocupada).

    Manual de Referência (p.48):
    >   Porta de entrada do estado da impressora. Na tabela de jump, apresentamos LPSTS para verificar o estado de prontidão; você também pode fazer a entrada a partir dessa porta para verificar o bit 0. Se este for 1, a impressora está ocupada.

    Manual de Referência (p.49):
    >   Porta de saída de “strob” da impressora. A porta 04H é uma E/S de duas vias; quando usada como entrada, ela ecoa o estado da impressora; se for usada como saída, ela faz o “strob” da impressora chamar a prontidão novamente.
    >   Toda vez que você faz sair um dado para a impressora, ocorre um “strob” da mesma.

*   $05 / 5 (**DPORT**)

    Envio de caracter à impressora.

    Manual de Referência (p.49):
    >   Porta de saída dos dados para a impressora. Quando a impressora estiver pronta, faça a saída do código ASCII para essa porta, e a impressora pegará esse dado automaticamente.

*   $0D / 13

    Manual de Referência (p.50):
    >   Porta de comando do controlador de disquete (FDC).

*   $10 / 16 (**RPORT1**)

    Seleciona registrador do monitor de 80 colunas ($0E = linha do cursor; $0F = coluna do cursor).

    Manual de Referência (p.12):
    >   Porta de seleção de registro do VDG MC6845: o 6845 tem 16 registros, cada um com seu próprio significado; você tem que usar esta porta para selecionar o registro em que você deseja colocar um dado.

    Manual de Referência (p.49):

    >   “Latch” de seleção dos registradores do 6845, semelhante ao 20H do 8910.

*   $11 / 17 (**DPORT1**)

    Escreve no registrador do monitor de 80 colunas selecionado pela porta $10 (RPORT1).

    Manual de Referência (p.12):
    >   Após selecionar um dos 16 registros do 6845, use este protocolo para estabelecer o dado apropriado no registro.

    Manual de Referência (p.49):
    >   “Latch” de E/S de dados do 6845 após haver selecionado o registrador.


*   $12 / 18 (**COL80**)

    Define status da VRAM (texto de 80 colunas). Se o bit 0 for 1, os endereços $2000–$27FF são mapeados para a VRAM, e ela fica disponível para leitura/escrita. Senão, lê-se a RAM normal.

    Manual de Referência (p.13):
    >   Bit 0=1: Banco da VRAM 6845 ligado, memória principal se superpõe ao cartão de 80 colunas; banco da VRAM desligado, endereço da VRAM: 2000H–27FFH

    Manual de Referência (p.49):
    >   Porta do banco da VRAM do cartão de 80 colunas. A saída de um dado com bit 0=1 fará a habilitação VRAM 6845 (2000H–27FFH).

*   $20 / 32 (**REG**)

    **Nota**: O circuito que faz a distinção entre as portas $20, $40, $60 e $80 considera apenas os três primeiros bits do endereço da porta. Por isso, na verdade, todos os endereços na faixa de $20 a $3F (%001XXXXX) apontam para a mesma porta REG; todos os endereços de $40 a $5F (%010XXXXX) apontam para a mesma porta RD; todos os endereços de $60 a $7F (%011XXXXX) apontam para a mesma porta WR; e todos os endereços de $80 a $9F (%100XXXXX) apontam para a mesma porta COL32.

    Seleciona um registrador do PSG AY-3-8910. Os registradores $00 a $0D são dedicados à geração de som. Os “registradores” $0E (IOA) e $0F (IOB) são portas de E/S do PSG que, no MC1000, estão ligadas ao circuito (matriz) do teclado (conforme tabela abaixo). Por meio do registrador $0E (IOA), configurado para saída, se seleciona uma das 8 “linhas” da matriz do teclado, devendo-se para isso zerar o bit correspondente à linha desejada. Uma vez selecionada a linha, por meio do registrador $0F (IOB), configurado para entrada, se lê um byte cujos bits correspondem ao estado das 8 teclas daquela linha. Teclas pressionadas são representadas por bits 0, teclas soltas por bits 1. Os estados das teclas \<CTRL> e \<SHIFT> são visíveis em todas as linhas. O bit 3 da 7ª linha não está associado a nenhuma tecla, seu valor é sempre 1.

    <table>
    <thead>
    <tr>
    <th rowspan="2">Linha da matriz do teclado</th>
    <th rowspan="2">Valor para o registrador IOA ($0E / 14)</th>
    <th colspan="8">Bit do registrador IOB ($0F / 15)</th>
    </tr>
    <tr>
    <th>7</th>
    <th>6</th>
    <th>5</th>
    <th>4</th>
    <th>3</th>
    <th>2</th>
    <th>1</th>
    <th>0</th>
    </tr>
    </thead>
    <tbody>
    <tr>
    <td>0</td>
    <td>%11111110 ($FE)</td>
    <td rowspan="8"><small>C<br>T<br>R<br>L</small></td>
    <td rowspan="8"><small>S<br>H<br>I<br>F<br>T</small></td>
    <td>8</td>
    <td>0</td>
    <td>X</td>
    <td>P</td>
    <td>H</td>
    <td>@</td>
    </tr>
    <tr>
    <td>1</td>
    <td>%11111101 ($FD)</td>
    <td>9</td>
    <td>1</td>
    <td>Y</td>
    <td>Q</td>
    <td>I</td>
    <td>A</td>
    </tr>
    <tr>
    <td>2</td>
    <td>%11111011 ($FB)</td>
    <td>:</td>
    <td>2</td>
    <td>Z</td>
    <td>R</td>
    <td>J</td>
    <td>B</td>
    </tr>
    <tr>
    <td>3</td>
    <td>%11110111 ($F7)</td>
    <td>;</td>
    <td>3</td>
    <td><small>RETURN</small></td>
    <td>S</td>
    <td>K</td>
    <td>C</td>
    </tr>
    <tr>
    <td>4</td>
    <td>%11101111 ($EF)</td>
    <td>,</td>
    <td>4</td>
    <td><small>SPACE</small></td>
    <td>T</td>
    <td>L</td>
    <td>D</td>
    </tr>
    <tr>
    <td>5</td>
    <td>%11011111 ($DF)</td>
    <td>−</td>
    <td>5</td>
    <td><small>RUBOUT</small></td>
    <td>U</td>
    <td>M</td>
    <td>E</td>
    </tr>
    <tr>
    <td>6</td>
    <td>%10111111 ($BF)</td>
    <td>.</td>
    <td>6</td>
    <td>↑</td>
    <td>V</td>
    <td>N</td>
    <td>F</td>
    </tr>
    <tr>
    <td>7</td>
    <td>%01111111 ($7F)</td>
    <td>/</td>
    <td>7</td>
    <td><small>N/A</small></td>
    <td>W</td>
    <td>O</td>
    <td>G</td>
    </tr>
    </tbody>
    </table>

    Manual de Referência(p.48):
    >   Porta de seleção de registradores do 8910. Há 16 registradores no 8910; antes de fazer a entrada/saída em/de qualquer registrador, você deve primeiramente selecionar esse registrador.

*   $40 / 64 (**RD**)

    (Vide nota no texto referente à porta REG ($20).)

    Lê o registrador do PSG selecionado pela porta REG ($20).

    Manual de Referência (p.48):
    >   “Latch” de entrada do 8910.

*   $60 / 96 (**WR**)

    (Vide nota no texto referente à porta REG ($20).)

    Escreve no registrador do PSG selecionado pela porta REG ($20).

    Manual de Referência (p.48):
    >   “Latch” de saída do 8910. Tudo referente a som, E/S de fita, varredura de teclado, tem que utilizar as três E/S acima.

*   $80 / 128 (**COL32**)

    (Vide nota no texto referente à porta REG ($20).)

    Configura o status da VRAM (texto de 32 colunas e modos gráficos). Se o bit 0 for 0, os endereços $8000–$9FFF são mapeados para a VRAM, e ela fica disponível para leitura/escrita. Senão, lê-se a RAM normal.

    Manual de Referência (p.12) (aqui a porta está erroneamente identificada como “00H”):
    >   Porta de seleção de formato do VDG MC6847P: use esta porta para escolher a resolução do 6847.

    Manual de Referência (p.13):
    >   Bit 0=0: Banco da VRAM 6847 ligado. Caso contrário, banco da VRAM 6847 desligado superposto com banco da memória principal.
    >   Endereço da VRAM: 8000H–97FFH

    Manual de Referência (p.49):
    >   Porta do banco da VRAM 6847. A saída de um dado com bit 0=0 habilitará a VRAM 6847 (8000H–97FFH).
    >   Se você quiser fazer um POKE dos dados na VRAM, certifique-se de habilitar a VRAM.