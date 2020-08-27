# Emuladores

## jsMC1000

* Linguagem: Javascript
* Desenvolvedor: [Ensjo][ensjo]
* Execução no navegador web: <http://ensjo.net/mc-1000/jsmc1000/>
* Código-fonte: <https://github.com/ensjo/jsmc1000>

Tem uma campo de formulário onde se pode escrever mais confortavelmente (ou colar) um programa BASIC a ser injetado na memória, ou, em sentido contrário, obter a listagem do programa em memória.

## BrMC1000

* Linguagem: Java (applet)
* Desenvolvedor: Ricardo Bittencourt, com algumas contribuições de [Ensjo][ensjo]
* Execução no navegador web: <http://www.700km.com.br/mundobizarro/brmc1000.php>
* Código-fonte: <https://github.com/ricbit/Oldies/tree/master/2004-08-brmc1000>

Requer Java 2 versão 1.5. Uma versão alternativa criada para testar algumas funcionalidades (que funciona com Java 2 versão 1.4) se encontra em <http://ensjo.net/mc-1000/brmc-1000>.

## MAME

* Linguagem: C++
* Download: <http://www.mamedev.org/>
* Código-fonte: <https://git.redump.net/mame/tree/>

O MAME é uma estrutura de emulação de múltiplos propósitos onde diversas máquinas são emuladas. Desde 2009 emula também o MC1000. Para isso é preciso ter a ROM original do MC1000, que pode ser encontrada [aqui](https://github.com/ensjo/mc1000-software/tree/master/cce/rom), porém dividida em dois blocos de 8KiB, tal como originalmente e nomeados como MC1000.IC17 (correspondente à EPROM MON I) e MC1000.IC12 (correspondente à EPROM MON II).

[ensjo]: mailto:emerson.costa@gmail.com "Emerson Costa"
