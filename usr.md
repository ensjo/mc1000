# `USR`

`USR` consta entre as palavras reservadas do MC1000, mas o Manual do BASIC não dá qualquer explicação sobre como usar essa função.

Assim como a instrução `CALL`, a função `USR` chama uma rotina em linguagem de máquina, com a diferença de que o BASIC passa para a rotina um parâmetro (numérico ou string), e dela recebe um valor numérico.

## Ponto de início

Para usar a função `USR` é preciso antes atribuir a uma variável do sistema o endereço de início da rotina em linguagem de máquina que será executada (USRLOC). Em alguns dialetos de BASIC, isso é feito com a instrução `DEF USR =` *endereço*. O MC1000 não tem essa instrução. Esse endereço deve ser colocado por meio de instruções `POKE` nos endereços 772 e 773 (em hexadecimal, $0304 e $0305), assim:

    POKE 772, endereço AND 255
    POKE 773, INT(endereço / 256)

Chamar a função `USR` sem definir um endereço de início gera erro de parâmetro ilegal ("PI ERRO").

## Parâmetro e valor de retorno

O parâmetro recebido do BASIC vem armazenado em quatro bytes a partir do endereço 959 ($03BF). O tipo do parâmetro é indicado no endereço 912 ($390) (0: numérico; ≠0: string).

O valor de retorno deve ser armazenado na mesma posição (quatro bytes a partir de $03BF), e deve ser numérico.

Utilize as rotinas para [números de ponto flutuante](numeros_de_ponto_flutuante) para tratar o parâmetro e gerar o valor de retorno.

## Hacks

Quando o controle passa para a rotina em linguagem de máquina, a pilha do Z80 (apontada pelo registrador SP) contém:

| Endereço | Valor | Significado |
| -------- | ----- | ----------- |
| SP       | $E38D | O ponto de retorno da rotina `USR`. Vai checar se a função `USR` foi chamada em um contexto que esperava valor numérico (gerando erro de tipo incompatível se o caso), e recuperar da pilha o valor seguinte no registrador HL e passar ao próximo ponto de retorno. |
| SP+2     | ????  | O ponto de interpretação da instrução BASIC no momento da chamada do `USR`. Aponta para o byte seguinte ao fecha-parêntese. Em uma linha como `X = USR (0): GOTO 40`, estaria apontando para o caracter dois-pontos. |
| SP+4     | $E2DC | Continuação da avaliação da expressão que contém a chamada à função `USR`. |

Modificando o conteúdo da pilha do Z80 deve ser possível:

*   evitar a rotina de checagem de tipo numérico, fazendo o interpretador BASIC aceitar que a função `USR` produza strings.
*   consultar ou avançar o ponto de execução do BASIC, permitindo passar dados adicionais para a rotina `USR` após os parênteses, numa sintaxe independente da sintaxe do BASIC do MC1000. Imagine, por exemplo, que se tenha criado um conjunto de rotinas utilitárias em código de máquina, entre elas uma que desenha texto no modo gráfico. Uma chamada como `X = USR(0) DRAW TEXT "SEU NOME E " + X$` poderia detectar os tokens de `DRAW` e `TEXT`, executar o interpretador de expressões de cadeia de caracteres para obter o parâmetro, e finalmente desenhar o texto na tela.