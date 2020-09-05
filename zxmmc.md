# ZXMCC

A [interface ZXMMC](http://www.probosci.de/zxbada/zxmmc/) é uma placa para alguns computadores da linha ZX Spectrum. Inserida no slot do Z80, e o Z80 sobre ela, permite acesso a cartões de memória SD/MMC.

Segundo o sítio (em inglês):

>   Na verdade, esta interface pode ser usada em QUALQUER projeto baseado em Z80 com um soquete DIL de 40 pinos, desde que as portas $1F e $3F não estejam em uso.

Como a ZXMMC não faz nenhuma tradução de sinais entre a placa e o Z80, funcionando em paralelo com o barramento, me parece que ela poderia ser encaixada (sem o Z80) em uma outra placa, fora do MC1000, desde que os mesmos sinais lhe sejam fornecidos.

Infelizmente a porta $3F não está livre no MC1000. O circuito interno do MC1000 que faz a distinção entre as [portas](portas) $20, $40, $60 e $80 só considera os três primeiros bits do número da porta, de modo que o endereço $3F (%001~~11111~~) coincide com $20 (%001~~00000~~).

Devemos então escolher um número de porta não problemático e nossa placa adaptadora deve traduzi-lo para $3F. Optei por um endereço vizinho ao $1F, o $1E (%00011110). Se ele for identificado, nossa placa deve ativar os bits 0 e 5 do endereço (produzindo $3F) antes de passá-lo à ZXMMC.

    Conectar à                                Conectar
    EXPANSION PORT                            a outros
    do MC1000                             dispositivos
    <=:===:==========:=======:=====:====:============>
      |   |A0,A5-A7  |A1-A4  |A0   |A5  |A1-A4,A6-A7
      |  [NOR]       |       |     |    |
      |   '--------. |       |     |    |
      |           [AND]      |     |    |
      |             '------*-|---. |    |
      |                    | |   | |    |
      |   .-----------.   [OR ] [OR ]   |
      |   |   ZXMMC   |     |A0'  |A5'  |
      |`--|+5V      A0|-----'     |     |
      |`--|GND      A5|-----------'     |
      |`--|CLK      A1|----------------´|
      |`==|D0-D7    A2|----------------´|
      |`--|~IORQ    A3|----------------´|
      |`--|~WR      A4|----------------´|
      |`--|~RD      A6|----------------´|
       `--|~NMI     A7|----------------´
          '-----------'

| Sinal | Pino na porta de expansão do MC1000 | Pino na ZXMMC (igual ao Z80) |
| :---: | :---------------------------------: | :--------------------------: |
| A0–A7 | 37–44 | 30–37 |
|  +5V  |   1   |  11   |
|  GND  | 46,50 |  29   |
|  D0   |  19   |  14   |
|  D1   |  20   |  15   |
|  D2   |  14   |  12   |
|  D3   |  11   |   8   |
|  D4   |  10   |   7   |
|  D5   |  12   |   9   |
|  D6   |  13   |  10   |
|  D7   |  15   |  13   |
| ~IORQ |  25   |  20   |
|  ~WR  |  27   |  22   |
|  ~RD  |  26   |  21   |
| ~NMI  |  22   |  17   |
|  CLK  |   9   |   6   |
