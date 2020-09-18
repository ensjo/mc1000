# Caracteres de controle


Nota: Esta página se refere ao comportamento de caracteres ao serem impressos. Para combinações de teclas de controle, vide a página sobre o [teclado](teclado).

| ASCII | Hex. | No `PRINT`  | No teclado | Efeito |
| :---: | :--: | :---------: | :--------: | :----- | 
|  BEL  | $07  | `CHR$(7)`   | \<CTRL>+\<G> | Emite um bip. |
|  BS   | $08  | `CHR$(8)`   | \<CTRL>+\<H> ou \<RUBOUT> | O cursor anda uma coluna para a esquerda. |
|  LF   | $0A  | `CHR$(10)`  | \<CTRL>+\<J> | O cursor desce uma linha. |
|  VT   | $0B  | `CHR$(11)`  | \<CTRL>+\<K> | O cursor sobe uma linha. |
|  FF   | $0C  | `CHR$(12)`  | \<CTRL>+\<L> | ~~O cursor anda uma coluna para a direita.~~ (Não funciona. Ver [bugs](bugs).) |
|  CR   | $0D  | `CHR$(13)`  | \<CTRL>+\<M> ou \<RETURN> | O cursor vai para a primeira coluna da linha. |
|  SUB  | $1A  | `CHR$(26)`  | \<CTRL>+\<Z> | Limpa a tela (e o cursor continua onde está). |
|  ESC  | $1B  | `CHR$(27)`  | Início de sequência de escape para [posicionamento de cursor](posicionamento-do-cursor). |
|  RS   | $1E  | `CHR$(30)`  | \<CTRL>+\<↑> | O cursor vai para o início da tela. |
|  DEL  | $7E  | `CHR$(127)` |            | ~~O cursor anda uma coluna para a esquerda, apagando caracteres.~~ (Não funciona. Ver [bugs](bugs).) |

Caracteres de controle do código ASCII não constantes nesta tabela se comportam como caracteres imprimíveis no MC1000.

## Origem

O caracteres de controle do MC1000 são um subconjunto dos caracteres usados no antigo terminal burro de 80 colunas [ADM 3A](http://en.wikipedia.org/wiki/ADM-3A). Os comandos adicionais envolviam a configuração do terminal e funções de comunicação entre o terminal e o host, por isso foram descartados por não se aplicarem a um teclado ligado diretamente ao computador.

O teclado do ADM 3A tinha setas nas teclas \<H>, \<J>, \<K> e \<L>, indicando seu uso em conjunto com a tecla \<CTRL> para movimentar o cursor.
