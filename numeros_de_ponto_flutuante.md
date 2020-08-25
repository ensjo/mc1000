# Números de ponto flutuante

[Números de ponto flutuante](http://pt.wikipedia.org/wiki/V%C3%ADrgula_flutuante) são uma forma de armazenar números reais em uma quantidade fixa de bits. Esses bits se dividem em:

*   bit de sinal
*   valor do expoente
*   valor da mantissa

O número resultante é calculado pela fórmula *sinal* × 1,*mantissa* × 2 <sup>*expoente*</sup>.

[https://en.m.wikipedia.org/wiki/Microsoft_Binary_Format](https://en.m.wikipedia.org/wiki/Microsoft_Binary_Format)

No MC1000 usam-se quatro bytes para os números, sendo que:

*   Os dois primeiros bytes e os 7 bits menos significativos do terceiro compõem a parte decimal da mantissa. (O primeiro byte é o menos significativo, o terceiro o mais.)
*   O bit mais significativo do terceiro byte indica o sinal (0 = positivo, 1 = negativo).
*   Se o quarto byte for zero, o número é zero. Senão, subtrai-se 129 para obter o expoente.


| byte / bit |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
| :--------: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|      1     |  m  |  m  |  m  |  m  |  m  |  m  |  m  |  m  |
|      2     |  m  |  m  |  m  |  m  |  m  |  m  |  m  |  m  |
|      3     |  s  |  m  |  m  |  m  |  m  |  m  |  m  |  m  |
|      4     |  e  |  e  |  e  |  e  |  e  |  e  |  e  |  e  |

Por conta disso, o maior número inteiro que pode ser atingido a partir de zero somando-se 1 sucessivas vezes é 16.777.216. A partir daí a unidade fica fora da "janela" da mantissa do número e não consegue ser somada.


| ---------------------------------: | ---------- |
|   %1111.1111.1111.1111.1111.1110 = | 16.777.214 |
|                               %1 + |            |
|   %1111.1111.1111.1111.1111.1111 = | 16.777.215 |
|                               %1 + |            |
| %1.0000.0000.0000.0000.0000.000? = | 16.777.216.  
                                       O último bit não cabe na mantissa, assume-se 0. |
|                               %1 + |            |
| %1.0000.0000.0000.0000.0000.000? = | 16.777.216.  
                                       O último bit não cabe na mantissa, assume-se 0. |

Outros computadores que usam quatro bytes para a mantissa, como o TRS-80 Color Computer e o ZX Spectrum, chegam a 256 vezes esse valor: 4.294.967.296.

## Rotinas da ROM para tratar números de ponto flutuante

Nas descrições abaixo,

*   FLOAT: É o "acumulador de ponto flutuante", uma variável do sistema de 4 bytes localizada em $03BF–$03C2 / 959–962 onde se armazena o número de ponto flutuante sendo interpretado/calculado/etc. Aqui também se armazenam ponteiros para strings. O endereço $0390 / 912: Indica se o valor armazenado em FLOAT é numérico (0) ou string (≠0).
*   BCDE: Designamos assim o armazenamento de um número de ponto flutuante nos registradores. B = byte 4, C = byte 3, D = byte 2, E = byte 1.
*   @HL, @DE: Um número de ponto flutuante (4 bytes) na memória, apontado pelo par de registradores HL ou DE.

| Endereço | Operação |
| :------: | -------- |
|  $DEF0   | DE ← FLOAT. (Converte FLOAT a um inteiro de 16 bits.) |
|  $E51D   | FLOAT ← 0. |
|  $E620   | FLOAT ← HL − DE. |
|  $E62F   | FLOAT ← AC (um número inteiro de 16 bits formado pelos registradores A e C). |
|  $E630   | FLOAT ← AB (um número inteiro de 16 bits formado pelos registradores A e B). |
|  $E63F   | FLOAT ← A (um número inteiro de 8 bits contido no registrador A). |
|  $EA89   | FLOAT ← FLOAT + 1/2. |
|  $EA8C   | FLOAT ← @HL + FLOAT. (Soma a FLOAT o valor de ponto flutuante apontado por HL.) |
|  $EA91   | FLOAT ← @HL − FLOAT. (Subtrai FLOAT do valor de ponto flutuante apontado por HL.) |
|  $EA97   | FLOAT ← BCDE − FLOAT. |
|  $EA9A   | FLOAT ← BCDE + FLOAT. |
|  $EAFD   | FLOAT ← 0. |
|  $EB8E   | FLOAT ← LOG(FLOAT). |
|  $EBD3   | FLOAT ← BCDE * FLOAT. |
|  $EC1F   | FLOAT ← FLOAT / 10. |
|  $EC2D   | FLOAT ← BCDE / FLOAT. |
|  $ECD3   | A ← SGN(FLOAT). ($01, $00 ou $FF / −1.) |
|  $ECE2   | FLOAT ← SGN(FLOAT). |
|  $ECF8   | FLOAT ← ABS(FLOAT). |
|  $ECFC   | FLOAT ← −FLOAT. |
|  $ED04   | PUSH FLOAT. (Carrega os 4 bytes de FLOAT na pilha do Z80.) |
|  $ED11   | FLOAT ← @HL.

             Algumas constantes numéricas disponíveis na ROM de potencial interesse:

             *  $EF66: 1/2 (0,5)
             * $F027: −1
             * $F02B: 1
             * $F11C: π/2 (1,5708)
             * $F120: 1/4 (0,25)
             * $F135: 2π (6,28319) |
|  $ED14   | FLOAT ← BCDE. |
|  $ED1F   | BCDE ← FLOAT. |
|  $ED22   | BCDE ← @HL. |
|  $ED2B   | @HL ← FLOAT. |
|  $ED2E   | @HL ← @DE. |
|  $ED4D   | A ← SGN(FLOAT − BCDE) ($01 se FLOAT > BCDE; $00 se FLOAT = BCDE; ou $FF / −1 se FLOAT < BCDE.) |
|  $EDA5   | FLOAT ← INT(FLOAT). |
|  $EF81   | FLOAT ← SQR(FLOAT). |
|  $EFCE   | FLOAT ← EXP(FLOAT). |
|  $F05E   | FLOAT ← RND(FLOAT). |
|  $F0D2   | FLOAT ← COS(FLOAT). |
|  $F0D8   | FLOAT ← SIN(FLOAT). |
|  $F139   | FLOAT ← TAN(FLOAT). |
|  $F14E   | FLOAT ← ATN(FLOAT). |
