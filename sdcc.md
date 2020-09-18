# SDCC

(A maior parte das informações aqui foram adaptadas deste um artigo em inglês sobre como usar o SDCC para programar para o Amstrad CPC: [*Introduction to programming in C with SDCC: Compiling and testing a "Hello World"*](http://www.cpcmania.com/Docs/Programming/Introduction_to_programming_in_SDCC_Compiling_and_testing_a_Hello_World.htm).)

O [SDCC (Small Device C Compiler)](http://sdcc.sourceforge.net) é um pacote de compilação da [linguagem C](https://pt.wikipedia.org/wiki/C_(linguagem_de_programa%C3%A7%C3%A3o)) que gera código para diversos processadores, dentre os quais o Z80. Este é um tutorial sobre como usá-lo para programar para o MC1000.

## Pré-requisitos

Instale os seguintes produtos:

* [SDCC](http://sourceforge.net/projects/sdcc) — o compilador C.
* [Hex2bin](http://sourceforge.net/projects/hex2bin) — um utilitário para converter arquivos em formato hexadecimal (Intel Hex) gerado pelo SDCC para binário.
* [MC1000CasTools](cassete) — uma ferramenta criada em [Java](http://java.com), com o qual é possível converter o arquivo binário para .WAV.

## Preparação

O SDCC não sabe nada sobre o MC1000, então temos que criar alguns arquivos, o que pode ser feito com qualquer simples editor de texto ou de código:

1. **crt0_mc1000_load.s** — será usado em vez do arquivo crt0 padrão para Z80 do SDCC. Implementa o truque de carregar com `LOAD` um programa em código de máquina logo após o corpo de um programa em BASIC. Como ele preserva o ambiente do interpretador BASIC (o que não acontece quando se carrega um programa com `TLOAD`), é possível voltar ao BASIC naturalmente ao final do programa em código de máquina.

	```
	        ; crt0.s for CCE MC-1000. By Emerson José Silveira da Costa, 2017-11-10.
	
	        .module crt0
	        .globl  _main
	        .globl  l__INITIALIZER
	        .globl  s__INITIALIZED
	        .globl  s__INITIALIZER
	
	        ; ==================================
	
	        ; MODELO PARA PROGRAMA EM CÓDIGO DE MÁQUINA
	        ; CARREGÁVEL NO MC-1000 VIA COMANDO LOAD.
	
	        .area   _HEADER (ABS)
	
	        ; ==================================
	
	        ; (1) Programa em BASIC que chama a porção em linguagem
	        ; de máquina residente nos bytes após o fim do programa:
	
	        ; 1  CALL 992
	
	        .org    0x03d5
	
	        .dw     endlinha2 ; Endereço do próximo registro de linha do programa em BASIC.
	        .dw     1 ; Número da linha do programa em BASIC.
	        .db     0xa2 ; Token de "CALL".
	        .ascii  "992"
	        .db     0 ; Fim da linha.
	endlinha2:
	        .dw     0 ; Endereço do próximo registro de linha = 0, indicando fim do programa.
	
	        ; ==================================
	
	        ; (2) Início do programa em linguagem de máquina.
	        ; Faz preparativos antes de pular para a função main().
	
	        ; .org	0x03e0 ; =992.
	
	        ; Reativa a impressão de caracteres que é desativada
	        ; quando um programa BASIC sem nome (autoexecutável)
	        ; é carregado.
	        xor     a
	        ld      (0x0344),a
	
	        ; Inicializa variáveis globais.
	        call    gsinit
	
	        ; Executa main() (estará na área _CODE).
	        jp      _main
		
	        ; ==================================
	
	        ; Neste ponto estamos no endereço 0x3ea,
	        ; endereço que deve ser usado na opção
	        ; --code-loc do linkador.
	        ; Aqui se iniciará o código do programa em C.
	
	        .area   _CODE
	
	        ; .org	0x03ea ; =1002.	
	
	        ; ==================================
	
	        ; Declara antecipadamente demais áreas usadas pelo SDCC.
	        ; As áreas são criadas à medida que são declaradas, então
	        ; isto define a ordem em que as áreas aparecerão no
	        ; código final.
		
	        .area     _HOME
	        .area    _INITIALIZER
	        .area    _GSINIT
	        .area    _GSFINAL
	
	        .area    _DATA
	        .area    _INITIALIZED
	        .area    _BSEG
	        .area    _BSS
	        .area    _HEAP
	
	        ; ==================================
	
	        ; Inicialização de variáveis.
	
	        .area    _GSINIT
	gsinit::
	        ld       bc, #l__INITIALIZER
	        ld       a, b
	        or       a, c
	        jr       Z, gsinit_next
	        ld       de, #s__INITIALIZED
	        ld       hl, #s__INITIALIZER
	        ldir
	gsinit_next:
	
	        .area    _GSFINAL
	        ret
	```

2.  **putchar_mc1000_load.s** — implementa a função `putchar()` do C.

	```
	        .area   _CODE
	
	_putchar::
		     ld      hl,#2
	        add     hl,sp
	
	        ld      a,(hl)
	        jp      0xdc1c ; Rotina "PrintAPOS" da ROM.
	
	        ret
	```

Compile os arquivos com o programa **sdasz80** do pacote do SDCC:

```
$ sdasz80 -o crt0_mc1000_load.s
$ sdasz80 -o putchar_mc1000_load.s
```

A opção `-o` fará gerar os arquivos relocáveis **crt0_mc1000_load.rel** e **putchar_mc1000_load.rel**.

## Utilização

Eis o infame arquivo de teste **helloworld.c**:

```
#include <stdio.h>

void main() {
	printf("HELLO, WORLD!\r\n");
}
```

Compile-o com o programa **sdcc**:

```
$ sdcc -mz80 --no-std-crt0 --code-loc 0x3ea --data-loc 0 crt0_mc1000_load.rel putchar_mc1000_load.rel helloworld.c
```

Algumas explicações:

*   `-mz80` — instrui o SDCC a gerar código para o Z80.
*   `--no-std-crt0` — instrui o SDCC a não usar seu crt0 padrão para Z80.
*   `--code-loc 0x3ea` — indica o endereço onde o SDCC deve começar a área de código do programa, ou seja, após o programa em BASIC de carga e algumas instruções iniciais em linguagem de máquina constantes no nosso crt0.
*   `--data-loc 0` — indica o endereço onde o SDCC deve começar a área de dados do programa. O zero indica que não vai começar num endereço fixo padrão do SDCC, mas conforme a sequência de áreas especificada no nosso crt0.

O resultado da execução do programa sdcc são vários arquivos, dentre os quais **helloworld.ihx**, em formato hexadecimal da Intel. Execute agora o **hex2bin**:

```
$ hex2bin helloworld.ihx
```

O resultado será um novo arquivo **helloworld.bin**. Finalmente entra em ação o utilitário de cassete do MC1000 [MC1000CasTools](cassete):

```
$ java MC1000CasTools -b helloworld.bin -wav
```

(Se o arquivo MC1000CasTools.class não estiver no diretório atual, indique o caminho até ele com a opção `-cp caminho` logo após a palavra `java`.)

Agora que temos um arquivo **helloworld.wav**, toque-o para carregar o programa no MC1000.

![](img/helloworld.c%20%28sdcc%29.png)

## Informações adicionais

* <http://www.cpcwiki.eu/index.php/SDCC_and_CPC>
* <http://cygnus.tele.pw.edu.pl/olek/doc/np/obce/asxhtm.html> — sobre o assembler usado no SDCC.
