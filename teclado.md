# Teclado

![](https://sites.google.com/site/ccemc1000/_/rsrc/1411647826386/manual-do-basic/mc1000-teclado.png)

## No hardware

\<SHIFT>+\<RESET>

Emite o sinal /RESET ao Z80, reiniciando o MC1000. Isto é implementado diretamente em hardware. A tecla \<RESET>, sozinha ou em combinação, é visível na malha do teclado que o MC1000 lê pelo PSG AY-3-8910.

## Na rotina SKEY? da ROM

Esta é a rotina padrão de leitura do teclado. Ela tem um comportamento durante o modo BASIC ([variável do sistema](variaveis_do_sistema) HEAD = $FF/255) e outro no  [modo de jogo](infraestrutura_para_jogos) (HEAD  ≠ $FF/255).

### Modo BASIC

No teclado do MC1000 nota-se que as teclas \<0>, \<@>, \<↑>, \<RETURN>, \<SPACE> e \<RUBOUT> não têm uso previsto com a tecla \<SHIFT>. E \<CTRL> provavelmente só deveria ser combinada com letras, \<@> e \<↑>. Combinações com \<SHIFT>+\<CTRL> são completamente imprevistas. Os valores retornados nos casos imprevistos são meros efeitos colaterais do cálculo para os casos previstos.

<table>
<thead>
<tr>
<th style="text-align:center;width:60px">Tecla</th>
<th style="text-align:center;width:60px">Código</th>
<th style="text-align:center;width:60px">+SHIFT</th>
<th style="text-align:center;width:60px">+CTRL</th>
<th style="text-align:center;width:60px">+SHIFT +CTRL</th>
<th style="text-align:center;width:60px">Tecla</th>
<th style="text-align:center;width:60px">Código</th>
<th style="text-align:center;width:60px">+SHIFT</th>
<th style="text-align:center;width:60px">+CTRL</th>
<th style="text-align:center;width:60px">+SHIFT +CTRL</th>
<th style="text-align:center;width:60px">Tecla</th>
<th style="text-align:center;width:60px">Código</th>
<th style="text-align:center;width:60px">+SHIFT</th>
<th style="text-align:center;width:60px">+CTRL</th>
<th style="text-align:center;width:60px">+SHIFT +CTRL</th>
</tr>
</thead>
<tbody>
<tr>
<td>@</td>
<td>$40/64:<b>@</b></td>
<td>$60/96:<b>`</b></td>
<td>$00/0:<b>nul</b></td>
<td>$20/32:<b>&nbsp;</b></td>
<td>P</td>
<td>$50/80:<b>P</b></td>
<td>$70/112:<b>p</b></td>
<td>$10/16:<b>dle</b></td>
<td>$30/48:<b>0</b></td>
<td>0</td>
<td>$30/48:<b>0</b></td>
<td>$20/32:<b>&nbsp;</b></td>
<td>$60/96:<b>`</b></td>
<td>$50/80:<b>P</b></td>
</tr>
<tr>
<td>A</td>
<td>$41/65:<b>A</b></td>
<td>$61/97:<b>a</b></td>
<td>$01/1:<b>soh</b></td>
<td>$21/33:<b>!</b></td>
<td>Q</td>
<td>$51/81:<b>Q</b></td>
<td>$71/113:<b>q</b></td>
<td>$11/17:<b>dc1</b></td>
<td>$31/49:<b>1</b></td>
<td>1</td>
<td>$31/49:<b>1</b></td>
<td>$21/33:<b>!</b></td>
<td>$61/97:<b>a</b></td>
<td>$51/81:<b>Q</b></td>
</tr>
<tr>
<td>B</td>
<td>$42/66:<b>B</b></td>
<td>$62/98:<b>b</b></td>
<td>$02/2:<b>stx</b></td>
<td>$22/34:<b>"</b></td>
<td>R</td>
<td>$52/82:<b>R</b></td>
<td>$72/114:<b>r</b></td>
<td>$12/18:<b>dc2</b></td>
<td>$32/50:<b>2</b></td>
<td>2</td>
<td>$32/50:<b>2</b></td>
<td>$22/34:<b>"</b></td>
<td>$62/98:<b>b</b></td>
<td>$52/82:<b>R</b></td>
</tr>
<tr>
<td>C</td>
<td>$43/67:<b>C</b></td>
<td>$63/99:<b>c</b></td>
<td>$03/3:<b>etx</b></td>
<td>$23/35:<b>#</b></td>
<td>S</td>
<td>$53/83:<b>S</b></td>
<td>$73/115:<b>s</b></td>
<td>$13/19:<b>dc3</b></td>
<td>$33/51:<b>3</b></td>
<td>3</td>
<td>$33/51:<b>3</b></td>
<td>$23/35:<b>#</b></td>
<td>$63/99:<b>c</b></td>
<td>$53/83:<b>S</b></td>
</tr>
<tr>
<td>D</td>
<td>$44/68:<b>D</b></td>
<td>$64/100:<b>d</b></td>
<td>$04/4:<b>eot</b></td>
<td>$24/36:<b>$</b></td>
<td>T</td>
<td>$54/84:<b>T</b></td>
<td>$74/116:<b>t</b></td>
<td>$14/20:<b>dc4</b></td>
<td>$34/52:<b>4</b></td>
<td>4</td>
<td>$34/52:<b>4</b></td>
<td>$24/36:<b>$</b></td>
<td>$64/100:<b>d</b></td>
<td>$54/84:<b>T</b></td>
</tr>
<tr>
<td>E</td>
<td>$45/69:<b>E</b></td>
<td>$65/101:<b>e</b></td>
<td>$05/5:<b>enq</b></td>
<td>$25/37:<b>%</b></td>
<td>U</td>
<td>$55/85:<b>U</b></td>
<td>$75/117:<b>u</b></td>
<td>$15/21:<b>nak</b></td>
<td>$35/53:<b>5</b></td>
<td>5</td>
<td>$35/53:<b>5</b></td>
<td>$25/37:<b>%</b></td>
<td>$65/101:<b>e</b></td>
<td>$55/85:<b>U</b></td>
</tr>
<tr>
<td>F</td>
<td>$46/70:<b>F</b></td>
<td>$66/102:<b>f</b></td>
<td>$06/6:<b>ack</b></td>
<td>$26/38:<b>&amp;</b></td>
<td>V</td>
<td>$56/86:<b>V</b></td>
<td>$76/118:<b>v</b></td>
<td>$16/22:<b>syn</b></td>
<td>$36/54:<b>6</b></td>
<td>6</td>
<td>$36/54:<b>6</b></td>
<td>$26/38:<b>&amp;</b></td>
<td>$66/102:<b>f</b></td>
<td>$56/86:<b>V</b></td>
</tr>
<tr>
<td>G</td>
<td>$47/71:<b>G</b></td>
<td>$67/103:<b>g</b></td>
<td>$07/7:<b>bel</b></td>
<td>$27/39:<b>'</b></td>
<td>W</td>
<td>$57/87:<b>W</b></td>
<td>$77/119:<b>w</b></td>
<td>$17/23:<b>etb</b></td>
<td>$37/55:<b>7</b></td>
<td>7</td>
<td>$37/55:<b>7</b></td>
<td>$27/39:<b>'</b></td>
<td>$67/103:<b>g</b></td>
<td>$57/87:<b>W</b></td>
</tr>
<tr>
<td>H</td>
<td>$48/72:<b>H</b></td>
<td>$68/104:<b>h</b></td>
<td>$08/8:<b>bs</b></td>
<td>$28/40:<b>(</b></td>
<td>X</td>
<td>$58/88:<b>X</b></td>
<td>$78/120:<b>x</b></td>
<td>$18/24:<b>can</b></td>
<td>$38/56:<b>8</b></td>
<td>8</td>
<td>$38/56:<b>8</b></td>
<td>$28/40:<b>(</b></td>
<td>$68/104:<b>h</b></td>
<td>$58/88:<b>X</b></td>
</tr>
<tr>
<td>I</td>
<td>$49/73:<b>I</b></td>
<td>$69/105:<b>i</b></td>
<td>$09/9:<b>tab</b></td>
<td>$29/41:<b>)</b></td>
<td>Y</td>
<td>$59/89:<b>Y</b></td>
<td>$79/121:<b>y</b></td>
<td>$19/25:<b>em</b></td>
<td>$39/57:<b>9</b></td>
<td>9</td>
<td>$39/57:<b>9</b></td>
<td>$29/41:<b>)</b></td>
<td>$69/105:<b>i</b></td>
<td>$59/89:<b>Y</b></td>
</tr>
<tr>
<td>J</td>
<td>$4A/74:<b>J</b></td>
<td>$6A/106:<b>j</b></td>
<td>$0A/10:<b>lf</b></td>
<td>$2A/42:<b>*</b></td>
<td>Z</td>
<td>$5A/90:<b>Z</b></td>
<td>$7A/122:<b>z</b></td>
<td>$1A/26:<b>sub</b></td>
<td>$3A/58:<b>:</b></td>
<td>:</td>
<td>$3A/58:<b>:</b></td>
<td>$2A/42:<b>*</b></td>
<td>$6A/106:<b>j</b></td>
<td>$5A/90:<b>Z</b></td>
</tr>
<tr>
<td>K</td>
<td>$4B/75:<b>K</b></td>
<td>$6B/107:<b>k</b></td>
<td>$0B/11:<b>vt</b></td>
<td>$2B/43:<b>+</b></td>
<td>RETURN</td>
<td>$0D/13:<b>cr</b></td>
<td>$7B/123:<b>{</b></td>
<td>$1B/27:<b>esc</b></td>
<td>$3B/59:<b>;</b></td>
<td>;</td>
<td>$3B/59:<b>;</b></td>
<td>$2B/43:<b>+</b></td>
<td>$6B/107:<b>k</b></td>
<td>$0D/13:<b>cr</b></td>
</tr>
<tr>
<td>L</td>
<td>$4C/76:<b>L</b></td>
<td>$6C/108:<b>l</b></td>
<td>$0C/12:<b>ff</b></td>
<td>$3C/60:<b>&lt;</b></td>
<td>SPACE</td>
<td>$20/32:<b>&nbsp;</b></td>
<td>$7C/124:<b>|</b></td>
<td>$1C/28:<b>fs</b></td>
<td>$2C/44:<b>,</b></td>
<td>,</td>
<td>$2C/44:<b>,</b></td>
<td>$3C/60:<b>&lt;</b></td>
<td>$6C/108:<b>l</b></td>
<td>$20/32:<b>&nbsp;</b></td>
</tr>
<tr>
<td>M</td>
<td>$4D/77:<b>M</b></td>
<td>$6D/109:<b>m</b></td>
<td>$0D/13:<b>cr</b></td>
<td>$3D/61:<b>=</b></td>
<td>RUBOUT</td>
<td>$7F/127:<b>del</b></td>
<td>$7D/125:<b>}</b></td>
<td>$1D/29:<b>gs</b></td>
<td>$2D/45:<b>-</b></td>
<td>-</td>
<td>$2D/45:<b>-</b></td>
<td>$3D/61:<b>=</b></td>
<td>$6D/109:<b>m</b></td>
<td>$7F/127:<b>del</b></td>
</tr>
<tr>
<td>N</td>
<td>$4E/78:<b>N</b></td>
<td>$6E/110:<b>n</b></td>
<td>$0E/14:<b>so</b></td>
<td>$3E/62:<b>&gt;</b></td>
<td>↑</td>
<td>$5E/94:<b>↑</b></td>
<td>$7E/126:<b>~</b></td>
<td>$1E/30:<b>rs</b></td>
<td>$2E/46:<b>.</b></td>
<td>.</td>
<td>$2E/46:<b>.</b></td>
<td>$3E/62:<b>&gt;</b></td>
<td>$6E/110:<b>n</b></td>
<td>$5E/94:<b>↑</b></td>
</tr>
<tr>
<td>O</td>
<td>$4F/79:<b>O</b></td>
<td>$6F/111:<b>o</b></td>
<td>$0F/15:<b>si</b></td>
<td>$3F/63:<b>?</b></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>/</td>
<td>$2F/47:<b>/</b></td>
<td>$3F/63:<b>?</b></td>
<td>$6F/111:<b>o</b></td>
<td>$5F/95:<b>←</b></td>
</tr>
</tbody>
</table>


### Modo de jogo

As seguintes teclas e combinações retornam valores diferentes:

<table>
<thead>
<tr>
<th style="text-align:center;width:60px">Tecla</th>
<th style="text-align:center;width:60px">Código</th>
<th style="text-align:center;width:60px">+SHIFT</th>
<th style="text-align:center;width:60px">+CTRL</th>
<th style="text-align:center;width:60px">+SHIFT +CTRL</th>
<th style="text-align:center;width:60px">Tecla</th>
<th style="text-align:center;width:60px">Código</th>
<th style="text-align:center;width:60px">+SHIFT</th>
<th style="text-align:center;width:60px">+CTRL</th>
<th style="text-align:center;width:60px">+SHIFT +CTRL</th>
<th style="text-align:center;width:60px">Tecla</th>
<th style="text-align:center;width:60px">Código</th>
<th style="text-align:center;width:60px">+SHIFT</th>
<th style="text-align:center;width:60px">+CTRL</th>
<th style="text-align:center;width:60px">+SHIFT +CTRL</th>
</tr>
</thead>
<tbody>
<tr>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>RETURN</td>
<td>$5B/91:<b>[</b>&nbsp;</td>
<td></td>
<td></td>
<td></td>
<td>;</td>
<td></td>
<td></td>
<td></td>
<td>$5B/91:<b>[</b></td>
</tr>
<tr>
<td>L</td>
<td></td>
<td></td>
<td></td>
<td>$2C/44:<b>,</b></td>
<td>SPACE</td>
<td>$5C/92:<b>\</b>&nbsp;</td>
<td></td>
<td></td>
<td>$3C/60:<b>&lt;</b></td>
<td>,</td>
<td>$3C/60:<b>&lt;</b></td>
<td>$2C/44:<b>,</b></td>
<td></td>
<td>$5C/92:<b>\</b></td>
</tr>
<tr>
<td>M</td>
<td></td>
<td></td>
<td></td>
<td>$2D/45:<b>-</b></td>
<td>RUBOUT</td>
<td>$5D/93:<b>]</b>&nbsp;</td>
<td></td>
<td></td>
<td>$3D/61:<b>=</b></td>
<td>-</td>
<td>$3D/61:=</td>
<td>$2D/45:<b>-</b></td>
<td></td>
<td>$5D/93:<b>]</b></td>
</tr>
<tr>
<td>N</td>
<td></td>
<td></td>
<td></td>
<td>$2E/46:.</td>
<td>↑</td>
<td></td>
<td></td>
<td></td>
<td>$3E/62:<b>&gt;</b></td>
<td>.</td>
<td>$3E/62:<b>&gt;</b></td>
<td>$2E/46:<b>.</b></td>
<td></td>
<td></td>
</tr>
<tr>
<td>O</td>
<td></td>
<td></td>
<td></td>
<td>$2F/47:<b>/</b></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td>/</td>
<td>$3F/63:<b>?</b></td>
<td>$2F/47:<b>/</b></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

(Onde não houver valor indicado, o valor é o mesmo da tabela anterior.)

Note-se que em modo de jogo a combinação \<CTRL>+\<H> é automaticamente capturada por SKEY?, disparando a rotina de alteração do “tópico do jogo”.

## Na rotina GETL da ROM

Esta rotina é usada pelo interpretador BASIC para ler uma linha de comando e para obter resposta a comando  `INPUT`.

Internamente os caracteres vão sendo armazenados no buffer de linha ($0100–$01FF).

A teclas e combinações de teclas abaixo são “consumidas” pela rotina e acabam não fazendo parte da linha digitada.

*   \<RETURN> ou \<CTRL>+\<M>

    Insere um caracter  `CHR$(0)`  no buffer de linha na posição do cursor, emite uma quebra de linha e termina a rotina GETL. O caracter  `CHR$(0)`  marca o fim da linha digitada, portanto, se o cursor foi movido com as teclas de movimento abaixo, tudo o que foi digitado e que ficou da posição do cursor até o fim da linha será descartado.

*   \<CTRL>+\<H>, \<CTRL>+\<J>, \<CTRL>+\<K> e \<CTRL>+\<L>

    Durante a digitação de uma linha no modo direto ou resposta a um comando  `INPUT`, movimentam o cursor dentro do espaço dos caracteres já digitados, respectivamente para a esquerda, para baixo, para cima e para a direita. Devido ao  [bug](bugs)  na impressão do caracter de controle  `CHR$(12)`, o cursor não anda para a direita, consequentemente este recurso para a digitação da linha não funciona a contento e nem é mencionado no  [manual do BASIC](manual-do-basic).

*   \<RUBOUT>

    Embora a tecla gere um código diferente, seu comportamento aqui é igual à combinação \<CTRL>+\<H>: movimenta o cursor para a esquerda sem apagar os caracteres na tela.

*   \<CTRL>+\<C>

    Emite uma quebra de linha, desativa a geração automática de número de linhas (instrução  `AUTO`  do BASIC), ativa o flag de carry do Z80 (para sinalizar o cancelamento da digitação) e termina a rotina GETL e emite uma quebra de linha. Diferentemente de \<RETURN>, devolve o flag de carry do Z80 ligado para indicar que foi pressionado \<CTRL>+\<C>. Também desliga a geração automática de número de linhas do comando  `AUTO`.

*   \<@> ou \<CTRL>+\<U>

    Durante a digitação de uma linha em modo direto ou resposta a um comando  `INPUT`, descarta o que já foi digitado, emite uma quebra de linha e aguarda nova digitação.

    Esse uso da tecla \<@> remonta ao BASIC da Microsoft para Altair 8800. Vide  <http://www.altair32.com/pdf/Altair_8800_BASIC_Reference_Manual_1975.PDF>, página 41.

*   \<CTRL>+\<↑>

    Limpa a tela e move o cursor para o canto superior esquerdo da tela.

*   \<CTRL>+\<@>

    Esta combinação de teclas gera  `CHR$(0)`. Como GETL usa `CHR$(0)` para marcar o fim da linha digitada, a rotina substitui o \<CTRL>+\<@> digitado pelo usuário pelo caracter “8” (aparentemente, uma escolha arbitrária).

## No interpretador BASIC

Note-se que ao ler uma linha do teclado (linha entrada em modo direto, resposta a comando  `INPUT`) o interpretador BASIC usa a rotina GETL, então as combinações de tecla acima valem nessas situações. Além disso:

*   \<CTRL>+\<C>

    -   Durante a execução de um programa, interrompe a execução com a mensagem “PAUSA EM  <número de linha>” e volta ao modo direto. A execução do programa pode ser retomada de onde parou com o comando  `CONT`.
    -   Durante a execução de uma linha de comandos em modo direto, interrompe a execução com a mensagem “PAUSA”.
    -   Durante a execução de um comando  `LIST`, interrompe a listagem com a mensagem “PAUSA”.

*   \<CTRL>+\<S>

    Durante a execução de um programa, execução de uma linha de comandos em modo direto ou execução de um comando `LIST`, inicia uma pausa até que outra tecla seja pressionada.