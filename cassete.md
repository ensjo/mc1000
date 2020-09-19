
# Cassete

Para representar informação em fita cassete, o MC1000 converte informação digital em som usando as convenções abaixo.

## Bits

    |1|
    ┌┐
     └┘

Um “período curto” para representar bits “1”. A parte alta e a parte baixa da onda sonora duram cerca de 3,628118×10<sup>−4</sup> segundos cada uma (16 amostras em um arquivo .wav com 44.100 quadros por segundo).

    | 0 |
    ┌─┐
      └─┘

Um “período longo”, com o dobro da duração do período curto, para representar bits “0”.

## Bytes

Para armazenar um byte, a convenção é a seguinte:

1.  Um período curto para marcar o início do byte.
2.  Os oito bits do byte, do menos ao mais significativo (em outras palavras, lido da direita para a esquerda).
3.  Um bit de paridade (“1” se o byte tem uma quantidade par de bits “1”; "0" se a quantidade for ímpar).

Por exemplo, o byte 209 (em hexadecimal $D1, em binário %11010001), que tem quatro bits “1” (paridade par), seria representado da seguinte forma:

    | |1| 0 | 0 | 0 |1| 0 |1|1|1|
    ┌┐┌┐┌─┐ ┌─┐ ┌─┐ ┌┐┌─┐ ┌┐┌┐┌┐
     └┘└┘ └─┘ └─┘ └─┘└┘ └─┘└┘└┘└┘
     ↑ marca de início         ↑ bit de paridade

## Arquivo

Isto posto, um “arquivo” em fita cassete é armazenado da seguinte forma:

1.  Um sinal piloto composto de 4096 períodos curtos seguidos de 256 períodos longos. O MC1000 usará estes períodos para tentar se ajustar à velocidade do toca-fitas no momento da leitura.
2.  Cabeçalho:
    1.  Até 14 bytes contendo o “nome” do arquivo. Se o nome tiver menos de 14 bytes, é finalizado com o caracter de controle CR (*carriage return*, `CHR$(13)`).
    2.  Dois bytes contendo o endereço de memória do primeiro byte do bloco de dados salvo.
    3.  Dois bytes contendo o endereço de memória seguinte ao último byte do bloco de dados salvo.
3.  O bloco de dados propriamente dito, cuja quantidade de bytes é determinada pela diferença entre os dois endereços acima.

Por exemplo, o programa BASIC:

    10  HOME 
    20  PRINT "OLA, MUNDO!"

é armazenado na memória do endereço $03D5 ao endereço $03EF:

    03D5 DB 03 0A
    03D8 00 93 00 EE 03 14 00 97
    03E0 22 4F 4C 41 2C 20 4D 55
    03E8 4E 44 4F 21 22 00 00 00

Ao se emitir um comando `SAVE OLA`, o MC1000 produz:

Sinal piloto:

    ┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐ ... (4096 períodos curtos)
     └┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘

    ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐  ... (256 períodos longos)
      └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘

Nome do arquivo: “OLA”. Nomes de programas BASIC são salvos com 5 caracteres, sendo as posições não usadas preenchidas com espaços. Como tem menos de 14 caracteres, é terminado por um caracter CR.

    | |1|1|1|1| 0 | 0 |1| 0 | 0 |
    ┌┐┌┐┌┐┌┐┌┐┌─┐ ┌─┐ ┌┐┌─┐ ┌─┐          (byte %01001111 = $4F = “O”)
     └┘└┘└┘└┘└┘ └─┘ └─┘└┘ └─┘ └─┘
    | | 0 | 0 |1|1| 0 | 0 |1| 0 | 0 |
    ┌┐┌─┐ ┌─┐ ┌┐┌┐┌─┐ ┌─┐ ┌┐┌─┐ ┌─┐      (byte %01001100 = $4C = “L”)
     └┘ └─┘ └─┘└┘└┘ └─┘ └─┘└┘ └─┘ └─┘
    | |1| 0 | 0 | 0 | 0 | 0 |1| 0 |1|
    ┌┐┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐┌─┐ ┌┐     (byte %01000001 = $41 = “A”)
     └┘└┘ └─┘ └─┘ └─┘ └─┘ └─┘└┘ └─┘└┘
    | | 0 | 0 | 0 | 0 | 0 |1| 0 | 0 | 0 |
    ┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐┌─┐ ┌─┐ ┌─┐  (byte %00100000 = $20 = “ ”)
     └┘ └─┘ └─┘ └─┘ └─┘ └─┘└┘ └─┘ └─┘ └─┘
    | | 0 | 0 | 0 | 0 | 0 |1| 0 | 0 | 0 |
    ┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐┌─┐ ┌─┐ ┌─┐  (byte %00100000 = $20 = “ ”)
     └┘ └─┘ └─┘ └─┘ └─┘ └─┘└┘ └─┘ └─┘ └─┘
    | |1| 0 |1|1| 0 | 0 | 0 | 0 | 0 |
    ┌┐┌┐┌─┐ ┌┐┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐      (byte %00001101 = $0D = CR)
     └┘└┘ └─┘└┘└┘ └─┘ └─┘ └─┘ └─┘ └─┘

Endereço de início do bloco de dados salvo: $03D5.

    | |1| 0 |1| 0 |1| 0 |1|1| 0 |
    ┌┐┌┐┌─┐ ┌┐┌─┐ ┌┐┌─┐ ┌┐┌┐┌─┐          (byte %11010101 = $D5)
     └┘└┘ └─┘└┘ └─┘└┘ └─┘└┘└┘ └─┘
    | |1|1| 0 | 0 | 0 | 0 | 0 | 0 |1|
    ┌┐┌┐┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐     (byte %00000011 = $03)
     └┘└┘└┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘└┘

Endereço de fim do bloco de dados salvo: $03F0 (= $03EF + 1). (Programas em BASIC trazem um byte adicional além da área do BASIC.)

    | | 0 | 0 | 0 | 0 |1|1|1|1|1|
    ┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐┌┐┌┐┌┐┌┐         (byte %11110000 = $F0)
     └┘ └─┘ └─┘ └─┘ └─┘└┘└┘└┘└┘└┘
    | |1|1| 0 | 0 | 0 | 0 | 0 | 0 |1|
    ┌┐┌┐┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐     (byte %00000011 = $03)
     └┘└┘└┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘└┘

Bloco de dados propriamente dito, contendo 28 (= $03F0 − $03D5 + 1) bytes. (Assumimos aqui que o endereço $03F0 contivesse o byte $00.)

    | |1|1| 0 |1|1| 0 |1|1|1|
    ┌┐┌┐┌┐┌─┐ ┌┐┌┐┌─┐ ┌┐┌┐┌┐             (byte $DB)
     └┘└┘└┘ └─┘└┘└┘ └─┘└┘└┘└┘
    ...                                  (...)
    | | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |1|
    ┌┐┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌┐ (byte $00)
     └┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘└┘

## Utilitários em Java

Com base nestas informações, foi criado um conjunto de aplicativos em Java para extrair o conteúdo de arquivos .wav, e vice-versa:

Uso:

*   `java MC1000CasTools <opções> <arq_origem> -<formato>`
*   `java MC1000CasTools <opções> <arq_origem> -list`
*   `java MC1000CasTools <opções> <arq_origem> <arq_destino>`

Converte arquivos entre formatos diferentes:

*   **.bas** — Arquivo contendo código-fonte de programa BASIC do MC1000.
*   **.bin** — Arquivo contendo dados brutos de um bloco de memória (no caso de um programa BASIC, é o programa em formato tokenizado).
*   **.cas** — Arquivo contendo dados tal como gerados/lidos pelos comandos `SAVE`, `LOAD` e `TLOAD` do MC1000: cabeçalho (nome de arquivo em cassete, endereço de início, endereço de fim) + dados brutos.
*   **.wav** — Som produzido pelo MC1000 correspondente aos dados de cassete.

Opções:

*   `-b` — Na conversão de .bin para .cas ou .wav, indica que o conteúdo do arquivo é um programa BASIC, para que o nome de arquivo em cassete seja adequadamente formatado (até 5 caracteres, completados com espaços).
*   `-n <nome>` — Na conversão de .bas ou .bin para .cas ou .wav, especifica o nome de arquivo em cassete (até 14 caracteres). O valor predefinido é vazio.
*   `-i <número>` — Se um arquivo .wav contiver mais de um arquivo de cassete, indica qual deles converter. O valor predefinido é 1.
*   `-v` — Modo verboso. Exibe diversas informações sobre o processo de conversão.

Outros parâmetros:

*   `<arq_origem>` — O arquivo a ser convertido. O formato será reconhecido pela extensão.
*   `-<formato>` — O formato final da conversão: `-bas`, `-bin`, `-cas` ou `-wav`. Se esta opção for usada, o nome do arquivo de destino será o mesmo do arquivo de origem com a extensão devidamente modificada.
*   `-list` — Converte para formato BASIC e exibe na tela, sem gerar arquivo.
*   `<arq_destino>` — Se não for especificado um formato de conversão, deve-se fornecer o nome do arquivo de destino. O formato da conversão será detectado pela extensão.

Exemplos de uso:

*   `java MC1000CasTools -n prog programa.bas -wav`

    Converte o arquivo “programa.bas” (código fonte de programa BASIC) para .wav (o nome de arquivo, calculado automaticamente, será “programa.bas.wav”). O nome de arquivo em cassete será “PROG” (ou seja, para carregar o programa no MC1000 pela porta EAR usar-se-á `LOAD PROG`.

*   `java MC1000CasTools -b -n prog programa.bin -cas`

    Converte o arquivo “programa.bin” (contendo um programa BASIC em forma tokenizada) em formato de cassete, acrescentando o cabeçalho de informações que o MC1000 salva em cassete antes dos dados. O nome do arquivo em cassete será “PROG”. Como a extensão do arquivo original é .bin, a ferramenta não sabe que o conteúdo é um programa BASIC; é preciso acrescentar a opção `-b` para que o nome do arquivo seja inserido no cabeçalho num formato próprio para nomes de cassete de programas BASIC (até 5 caracteres completados com espaços). O nome do arquivo resultante, calculado automaticamente, será “programa.cas”.

*   `java MC1000CasTools -i 4 -v fita_digitalizada.wav -bin`

    Dado um arquivo .wav contendo mais de um arquivo de cassete, por padrão apenas o primeiro arquivo de cassete é extraído. Aqui a opção `-i 4` está selecionando o quarto arquivo de cassete contido no arquivo .wav. A opção `-v` indica que o processo será “verboso”, exibindo na tela informações durante o processo de conversão. O nome do arquivo resultante, calculado automaticamente, será “fita_digitalizada(4).bin”.

*   `java MC1000CasTools batnav.cas BatalhaNaval.bin`

    Aqui foi especificado o nome do arquivo de destino. Converte o arquivo em formato de cassete “batnav.cas” para o formato de dados brutos, com o nome “BatalhaNaval.bin”. As extensões dos nomes de arquivos definem o tipo de conversão.

*   `java MC1000CasTools calculo.wav -list`

    Converte o arquivo .wav para código-fonte BASIC e o lista na tela, sem gerar nenhum arquivo novo.

### Download e desenvolvimento
Quem quiser baixar e/ou contribuir com o desenvolvimento destes utilitários pode encontrá-los no GitHub:

*   Versão "2" (atual, desde 2016): <https://github.com/ensjo/MC1000CasTools/tree/cas_ext">

*   Versão "1": <https://github.com/ensjo/MC1000CasTools/tree/master>

    Nesta primeira versão, só havia os formatos .bas, .bin e .wav, sendo que o .bin continha o cabeçalho de cassete, correspondendo ao .cas da versão atual. Havia quatro programas, um para cada passo da conversão (Bas2Bin, Bin2Wav, Wav2Bin, ListBin), não sendo possível converter de .bas para .wav, por exemplo, com apenas uma chamada.