
# Códigos de erro

Os códigos de erro do MC1000 foram traduzidos para o português. Na lista a seguir, entre parênteses, acompanham os códigos originais do Microsoft BASIC.

1.  **NF** (`NEXT` sem `FOR`) = ***NF** (`NEXT` without `FOR`)*  
    O programa atingiu uma instrução `NEXT` sem que tenha havido um `FOR` correspondente.

2.  **SN** (Erro de sintaxe) = ***SN** (Syntax error)*  
    Erro na formação do comando.

3.  **RG** (`RETURN` sem `GOSUB`) = ***RG** (`RETURN` without `GOSUB`)*  
    O programa atingiu uma instrução `RETURN` sem que tenha havido um `GOSUB` correspondente.

4.  **FD** (Fim de dados) = ***OD** (Out of data)*  
    O programa atingiu uma instrução `READ` mas não há mais linhas `DATA` de onde ler dados.

5.  **PI** (Parâmetro ilegal) = ***FC** (Illegal function call)*  
    Foi fornecido um valor inaceitável para algum parâmetro.

    Exemplo: `COLOR = 4`.

6.  **SE** (Sem espaço) = ***OV** (Overflow)*  
    Utilização de valor numérico acima de 3,4×10<sup>38</sup>.

7.  **FM** (Fora da memória) = ***OM** (Out of memory)*  
    Programa ou matrizes muito grandes. Toda a memória disponível está sendo utilizada.

8.  **LI** (Linha indefinida) = ***UL** (Undefined line number/Undefined line)*  
    Uma instrução `GOTO` ou `GOSUB` tentou enviar a execução para um número linha inexistente.

9.  **II** (Índice ilegal) = ***BS** (Bad subscript)*  
    Valor de índice não aceitável.

    Exemplo: `DIM X(100000)`.

10. **MR** (Matriz redimensionada) = ***DD** (Duplicate definition/Double dimensioned array)*  
    Tentativa de dimensionar uma matriz já dimensionada.

    Exemplo: `DIM X(10): DIM X(6)`.

11. **DZ** (Divisão por zero) = ***/0** (Division by zero/Divide by zero)*  
    Um número foi dividido por zero, ou zero foi elevado a uma potência negativa.

12. **DI** (Direto ilegal) = ***ID** (Invalid in direct mode/Illegal direct)*  
    O usuário tentou executar em modo direto uma instrução que só pode ser executada em modo programado (`INPUT` e `DEF`).

13. **TI** (Tipo incompatível) = ***TM** (Type mismatch)*  
    Uso de valor numérico em lugar de valor texto ou vice-versa.

    Exemplo: `ASC(10)`.

14. **FC** (Fora da cadeia) = ***OS** (Out of string space)*  
    Não há mais espaço disponível para criação de variáveis do tipo cadeia.


15. **CL** (Cadeia longa demais) = ***LS** (String too long/Long string)*  
    Tentativa de criar uma cadeia de mais de 255 caracteres.

16. **CC** (Cadeia complexa) = ***ST** (String formula too complex)*  
    Dividir uma cadeia muito complexa em duas ou mais cadeias.
    
    Essa explicação do Manual do BASIC não é bastante clara. Eis o problema: Durante a avaliação de uma expressão, o interpretador BASIC só tem espaço para *três* cadeias temporárias. Se a expressão exigir mais do que isso, o erro ocorrerá. A descrição acima é na verdade uma sugestão de dividir a expressão em duas ou mais expressões, guardando os resultados temporários em váriáveis, para que o limite não seja atingido.

    Exemplo: `X$ = "A" + ("B" + ("C" + ("D")))`.

17. **NC** (Não pode continuar) = ***CN** (Cannot continue)*  
    O usuário executou a instrução `CONT`, mas o programa não pode continuar: Não há programa, ou o programa parou por erro.


18. **FI** (Função indefinida) = ***UF** (Undefined function)*  
    Tentativa de usar uma função que não foi definida com `DEF`.

19. **FO** (Falta operando) = ***MO** (Missing operand)*  
    O usuário não colocou todos os operandos exigidos por uma instrução.

    Exemplo: `POKE 2983`.
