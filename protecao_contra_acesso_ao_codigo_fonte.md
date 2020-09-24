# Proteção contra acesso ao código-fonte

Os programas em BASIC das [fitas cassete](software) numeradas da CCESOFT (F-18~F-30) são autoexecutáveis (salvos sem nome) e trazem uma proteção para impedir que o usuário possa visualizar o código fonte. Os programas começam com as instruções:

```
1  REM ~3E~C3~32~20~01~3E~E9~32~21~01~3E~03~32~22~01~3A~1B~01~FE~03~C0~3E~F4~32~21~01~3E~01~32~44~03~C9
2  CALL 986
...
```

(Nesta listagem, cada sequência hexadecimal `~XX` corresponde a um byte/caracter.)

A rotina em código de máquina do Z80 codificada na linha `REM` é:

```
        ; Variáveis do sistema:
KEY0:   equ $011b ; Última tecla pressionada.
JOB:    equ $0120 ; Hook chamado durante a leitura do teclado.
OUTFLG: equ $0344 ; Desabilita impressão se diferente de zero.
 
        ; Programa começa no primeiro byte
        ; após o token da instrução REM da linha 1.
        org $03da ; =986.
init:
        ; Inicialmente JOB contém uma instrução RET.
        ; Coloca em JOB um JP para a rotina "checa".
        ld  a,$c3 ; Opcode de JP.
        ld  (JOB),a
        ld  a,$e9 ; LSB de "checa".
        ld  (JOB+1),a
        ld  a,$03 ; MSB de "checa".
        ld  (JOB+2),a
checa:
        ; Retorna se a última tecla pressionada
        ; não for CTRL+C.
        ld  a,(KEY0)
        cp  $03 ; CTRL+C
        ret nz
desvia:
        ; O usuário pressionou CTRL+C.
        ; Desvia JOB para a rotina "oculta".
        ld  a,$f4 ; LSB de "oculta".
        ld  (JOB+1),a
oculta:
        ; Desabilita a impressão de caracteres.
        ld  a,$01
        ld  (OUTFLG),a
        ret
```

A parte inicial da rotina (*init*), chamada logo no início do programa em BASIC pelo `CALL` na linha 2, configura o *hook* JOB ($0120 / 288) (vide [variáveis do sistema](variaveis_do_sistema)). A partir daí, continuamente, a cada leitura de teclado, é chamada a segunda parte da rotina (*checa*), que checa se o usuário pressionou \<CTRL>+\<C>. Se isso acontecer, a terceira parte (*desvia*) reconfigura JOB para chamar a parte final da rotina (*oculta*), de modo que, continuamente, a cada leitura de teclado, seja colocado o valor 1 na variável OUTFLG ($0344 / 836), o que desabilita a impressão de caracteres.

O efeito disso é que, depois que se interrompe o programa em BASIC com \<CTRL>+\<C>, não se veem na tela *nem os caracteres sendo digitados*, nem os resultados das instruções `PRINT` e `LIST` (o que é o objetivo da rotina). Veem-se apenas o “OK” que aparece ao final da execução das instruções e as mensagens de erro. No modo `DEBUG`, porém, tudo continua visível.

## Como contornar

Simplesmente mudar o valor de OUTFLG para zero (`POKE 836,0`) não adianta, pois a rotina *oculta* que muda OUTFLAG para 1 está atrelada ao *hook* JOB e é chamada a cada leitura de teclado, frustrando essa tentativa.

A solução é *primeiro* desabilitar o *hook* JOB (colocando aí uma instrução `RET` do Z80) e, *então*, zerar OUTFLAG.

```
POKE 288,201: POKE 836,0
```

Ou, alternativamente, via `DEBUG` (onde se pode ver o que se está digitando):

```
DEBUG
>S120
0120 C3 C9
0121 F4 
>S344
0344 01 0
0345 FF
>Q
```

Depois disso podem-se apagar as linhas 1 e 2 do programa em BASIC para rodá-lo novamente sem reativar a proteção.