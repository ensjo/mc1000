# ZX BASIC

O **ZX BASIC Compiler** de Boriel (<https://www.boriel.com/pages/the-zx-basic-compiler.html>) é um compilador cruzado multiplataforma de uma versão extendida da linguagem BASIC usada no ZX Spectrum. O código gerado também é voltado para o ZX Spectrum, mas ao remendarmos o resultado compilado final com um script, e tomando o cuidado de evitar funcionalidades que dependem da ROM do ZX Spectrum (strings, arrays…), podemos criar material para outras máquinas com CPU Z80, incluindo o MC1000.

<iframe width="560" height="315" src="https://www.youtube.com/embed/VCsv2JoArHQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Pré-requisitos

* [Python](https://www.python.org).
* [Boriel's ZX BASIC Compiler](https://zxbasic.readthedocs.io/en/docs/).
* mc1000bin2wav.py (<https://pastebin.com/raw/GHXwde8E>).
* createmc1000header.py (<https://pastebin.com/raw/qfRjRvDy>).

## Preparação

1.   Fazer com que zxb.py seja reconhecido como comando (no GNU/Linux: “export PATH=$PATH:/opt/borielszxbasiccompiler” (o diretório é um exemplo de onde poderíamos tê-lo instalado) numa linha em ~/.bashrc (a última linha, por exemplo).

2.   Instalar mc1000bin2wav.py e createmc1000header.py em /usr/bin/ (ou outro directório, mas utilizando um procedimento parecido com o item 1) — estes scripts devem estar com permissão de execução (chmod +x).

3.   O Bash script utilizado para compilação foi criado e usado em GNU/Linux, ainda não testado em outros Unix (como MacOS-X). No caso do MS Windows, não deve ser difícil converter o script .sh para .BAT.

## Utilização

O Bash script seria algo parecido com este teste.sh (<https://pastebin.com/raw/Fx0WzAiD>):

```
rm teste.bin teste.asm mc1000header.bin mc1000tail.bin
zxb.py teste.bas --asm --org=0x0200
zxb.py teste.bas --org=0x0200
createmc1000header.py teste.bin
cat mc1000header.bin > teste.final.bin
cat teste.bin >> teste.final.bin
cat mc1000tail.bin >> teste.final.bin
mv teste.final.bin teste.bin
rm mc1000header.bin mc1000tail.bin
mc1000bin2wav.py teste.bin
zip teste.bin.wav.zip teste.bin.wav
rm teste.bin.wav
mess mc1000 -video soft -w -bp ~/.mess/roms -resolution0 640x480 -skip_gameinfo -ramsize 48k -cass teste.bin.wav.zip
# tload, [enter], [insert], [tab], , , [tab]
```

Para maior comodidade, utilizando um IDE como Geany, podemos ter um makefile com uma linha como “a:;./teste.sh” no mesmo directório do código a ser compilado, e do script de compilação
Em [http://www.boriel.com/wiki/en/index.php/ZX_BASIC:Released_Programs_-_MC1000](http://www.boriel.com/wiki/en/index.php/ZX_BASIC:Released_Programs_-_MC1000) está disponível um exemplo, a pasta /library/ contém alguns comandos (functions e subs) específicos para o MC1000.

## Informações adicionais

* Tutorial do ZX Basic Compiler (para ZX Spectrum em castelhano): <https://tcyr.wordpress.com/2012/02/20/tutorial-de-iniciacion-a-zx-basic-fourspriter-1-instalar-el-compilador>
* Materiais feitos com o ZX Basic Compiler (começando pelo ZX Spectrum, terminando pelos mais variados hardwares): <https://zxbasic.readthedocs.io/en/docs/released_programs>


