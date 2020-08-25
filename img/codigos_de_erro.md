# Códigos de erro

*   **CC** — *Cadeia complexa*  
    Dividir uma cadeia muito complexa em duas ou mais cadeias.
    
    (Essa explicação do Manual do BASIC não é bastante clara. Eis o problema: Durante a avaliação de uma expressão, o interpretador BASIC só tem espaço para *três* cadeias temporárias. Se a expressão exigir mais do que isso, o erro ocorrerá. A descrição acima é na verdade uma sugestão de dividir a expressão em duas ou mais expressões, guardando os resultados temporários em váriáveis, para que o limite não seja atingido.)

    Exemplo: `X$ = "A" + ("B" + ("C" + ("D")))`.

*   **CL** — *Cadeia longa demais*  
    Tentativa de criar uma cadeia de mais de 255 caracteres.

*   **DI** — *Direto ilegal*  
    O usuário tentou executar em modo direto uma instrução que só pode ser executada em modo programado (`INPUT` e `DEF`).

*   **DZ** — *Divisão por zero*  
    Um número foi dividido por zero, ou zero foi elevado a uma potência negativa.

*   **FC** — *Fora da cadeia*  
    Não há mais espaço disponível para criação de variáveis do tipo cadeia.

*   **FD** — *Fim de dados*  
    O programa atingiu uma instrução `READ` mas não há mais linhas `DATA` de onde ler dados.

*   **FI** — *Função indefinida*  
    Tentativa de usar uma função que não foi definida com `DEF`.

*   **FM** — *Fora da memória*  
    Programa ou matrizes muito grandes. Toda a memória disponível está sendo utilizada.

*   **FO** — *Falta operando*  
    O usuário não colocou todos os operandos exigidos por uma instrução.

    Exemplo: `POKE 2983`.

*   **II** — *Índice ilegal*  
    Valor de índice não aceitável.

    Exemplo: `DIM X(100000)`.

*   **LI** — *Linha indefinida*  
    Uma instrução `GOTO` ou `GOSUB` tentou enviar a execução para um número linha inexistente.

*   **MR** — *Matriz redimensionada*  
    Tentativa de dimensionar uma matriz já dimensionada.

    Exemplo: `DIM X(10): DIM X(6)`.

*   **NC** — *Não pode continuar*  
    O usuário executou a instrução `CONT`, mas o programa não pode continuar: Não há programa, ou o programa parou por erro.

*   **NF** — *`NEXT` sem `FOR`*  
    O programa atingiu uma instrução `NEXT` sem que tenha havido um `FOR` correspondente.

*   **PI** — *Parâmetro ilegal*  
    Foi fornecido um valor inaceitável para algum parâmetro.

    Exemplo: `COLOR = 4`.

*   **RG** — *`RETURN` sem `GOSUB`*  
    O programa atingiu uma instrução `RETURN` sem que tenha havido um `GOSUB` correspondente.

*   **SE** — *Sem espaço*  
    Utilização de valor numérico acima de 3,4×10<sup>38</sup>.

*   **SN** — *Erro de sintaxe*  
    Erro na formação do comando.

*   **TI** — *Tipo incompatível*  
    Uso de valor numérico em lugar de valor texto ou vice-versa.

    Exemplo: `ASC(10)`.
