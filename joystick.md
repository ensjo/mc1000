# Joystick

## Joystick de 6 botões

Cada conector de joystick do MC1000 está preparado de fábrica para que possa, com um cabo divisor especial, receber *dois* joysticks. (Vide explicação na página de [periféricos](perifericos).) Pode-se, em vez disso, criar um único joystick com seis botões, reaproveitando os cinco comandos reservados para o joystick adicional.

![](img/Esquema%20joystick%206%20bot%C3%B5es%20mc1000.png)
![](img/prototipo%20joystick%206%20botoes%20mc1000%281%29.jpg)
![](img/prototipo%20joystick%206%20botoes%20mc1000%282%29.jpg)

<iframe width="560" height="315" src="https://www.youtube.com/embed/wcoCLrAb7CQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Um controle de seis botões da Sega com conector DE-9 pode ser modificado para uso no MC1000. (Os botões "START" e "MODE" ficam sem uso.)

![](img/controle%20sega%206%20botoes.jpg)

<iframe width="560" height="315" src="https://www.youtube.com/embed/pKpuRqx0Gm8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Joystick de 11 botões(!)

No funcionamento normal da leitura do teclado/joystick (rotina *SKEY?*), os pinos de ativação dos conectores (7 e 8) são ativados em momentos diferentes. Se ligarmos os dois pinos a um decodificador, poderíamos distinguir também uma situação em que os dois pinos forem ativados simultaneamente (algo que a rotina *SKEY?* não faz, mas que uma rotina especial de leitura poderia fazer), e assim poderíamos acrescentar outros cinco botões ao joystick.

![](img/Esquema%20joystick%2011%20bot%C3%B5es%20mc1000.png)
