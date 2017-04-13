1  CLEAR 512,15535: GOSUB 65000: GOSUB 10000: GOSUB 11000: GOTO 4000
1000  REM *OBTEM COMANDO
1010  IF  PEEK (285) = 0 THEN C = 0: RETURN 
1020 T =  PEEK (283): IF T = C1 THEN C = 1: RETURN 
1021  IF T = C2 THEN C = 2: RETURN 
1022  IF T = C3 THEN C = 3: RETURN 
1023  IF T = C4 THEN C = 4: RETURN 
1024  IF T = C5 THEN C = 5: RETURN 
1025  IF T = C6 THEN C = 6: RETURN 
1030 C = 0: RETURN 
1100  REM OBTEM MOVIMENTO
1110 M = 0:Y1 = Y + 1: IF  FN YV(Y1) THEN  IF M(X,Y1) <  > 1 THEN M = 1:YT = Y1: RETURN 
1120  GOSUB 1000: ON C GOTO 1200,1200,1300,1400,1300,1500: GOTO 1120
1200  REM COMANDO HORIZONTAL
1210 DX =  ABS (C = 2) -  ABS (C = 1):X1 = X + DX: IF  NOT  FN XV(X1) THEN  RETURN 
1220  IF M(X1,Y) <  > 1 THEN M = 1:XT = X1:YT = Y: RETURN 
1230 X2 = X1 + DX: IF  FN XV(X2) THEN  IF M(X1,Y) = 1 THEN  IF M(X2,Y) = 0 THEN M = 2:M(X1,Y) = 0:M(X2,Y) = 1:XT = X1:YT = Y
1240  RETURN 
1300  REM COMANDO DIAGONAL
1310 Y1 = Y - 1: IF  NOT  FN YV(Y1) THEN  RETURN 
1320 DX = C - 4:X1 = X + DX: IF  FN XV(X1) THEN  IF M(X1,Y1) <  > 1 THEN M = 1:XT = X1:YT = Y1
1330  RETURN 
1400  REM COMANDO VERTICAL
1410 Y1 = Y - 1: IF  NOT  FN YV(Y1) THEN  RETURN 
1420  IF M(X,Y1) <  > 1 THEN M = 1:XT = X:YT = Y1: RETURN 
1430 Y2 = Y - 2: IF  FN YV(Y2) THEN  IF M(X,Y2) <  > 1 THEN M = 1:XT = X:YT = Y2
1440  RETURN 
1500  REM COMANDO REINICIA NIVEL
1510 M = 3: RETURN 
2000  REM CICLO
2010  GOSUB 1100: GOSUB 2300: ON M GOTO 2200,2100: RETURN 
2100  REM MOVE BLOCO
2110 M(X1,Y) = 0:M(X2,Y) = 1: GOSUB 2700: GOTO 2230
2200  REM MOVE PINGUIM
2210  IF M(XT,YT) = 2 THEN M(XT,YT) = 0:CP = CP + 1
2220  GOSUB 2600:X = XT:Y = YT
2230  IF CP < 5 THEN 2010
2240  RETURN 
2300  REM *SOM MOVIMENTO: PLAY "L32DE"
2310  SOUND 82,8,1: SOUND 84,8,1: SOUND 0,0,1: RETURN 
2400  REM *MOSTRA M(I,J)
2410 K = M(I,J)
2500  REM *MOSTRA K EM I,J
2510  POKE 277,Y0 + J: POKE 278,X0 + I:A =  USR ( CHR$ (96 + K)): RETURN 
2600  REM *MOVE PINGUIM
2610  POKE 277,Y0 + Y: POKE 278,X0 + X:A =  USR (E$): POKE 277,Y0 + YT: POKE 278,X0 + XT:A =  USR (P$): RETURN 
2700  REM *MOVE BLOCO
2710 I = X1:J = Y: GOSUB 2400:I = X2: GOTO 2400
3000  REM FASE
3010  GOSUB 3100: ON F GOSUB 3201,3202,3203,3204,3205,3206,3207,3208,3209,3210: GOSUB 3300: GOSUB 3400: READ X,Y: FOR J = 0 TO MY - 1: READ M$: FOR I = 0 TO MX - 1:K =  VAL ( MID$ (M$,I + 1,1)):M(I,J) = K AND (K <  > 3): GOSUB 2500: NEXT I,J:CP = 0
3020  GOSUB 2000: IF M <  > 3 THEN  IF CP < 5 THEN 3020
3030  RETURN 
3100  REM *SOM FASE: PLAY "V8T87O3L8CGO4CDECO3GEO4L16GR16GR16GR16GR16L8C","V8T87O5L2EDL16CR16CR16CR16CR16L8G"
3110  SOUND 64,44,1: SOUND 100,176,2: SOUND 71,44,1: SOUND 80,44,1: SOUND 82,44,1
3111  SOUND 96,22,2: SOUND 0,22,2: SOUND 84,44,1: SOUND 96,22,2: SOUND 0,22,2
3112  SOUND 80,44,1: SOUND 96,22,2: SOUND 0,22,2: SOUND 71,44,1: SOUND 96,22,2
3113  SOUND 0,22,2: SOUND 68,44,1: SOUND 103,44,2: SOUND 87,22,1: SOUND 0,0,2
3114  SOUND 0,22,1: SOUND 87,22,1: SOUND 0,22,1: SOUND 87,22,1: SOUND 0,22,1
3115  SOUND 87,22,1: SOUND 0,22,1: SOUND 80,44,1: SOUND 0,0,1
3120  RETURN 
3200  REM FASES
3201  RESTORE 3201: RETURN : DATA 0,7,000000000020001111,002000000001001002,011110001001011111,101001010101001000,001012110001001001,001011110101101111,001010101101111000,301010100020000000
3202  RESTORE 3202: RETURN : DATA 0,7,000020000000000000,001111100100010010,001000010010100110,211000000111110100,101112010101020101,001000000100010102,001000000000000110,300000000000011100
3203  RESTORE 3203: RETURN : DATA 0,7,000200110000010100,000100110000001000,110001100000100010,001110002001100001,200101111100101012,001010000002100001,110000000001110010,300000000000000101
3204  RESTORE 3204: RETURN : DATA 0,7,000000000000000002,000000200001100110,001001110010000001,002110000010001021,011010001201110010,010000100110011001,010011000001100010,300000000000000000
3205  RESTORE 3205: RETURN : DATA 0,0,301100112100001010,100110100010110020,010011010101110110,101001010101011010,001001010101011010,001000112101010101,001011100011100010,121000111112000101
3206  RESTORE 3206: RETURN : DATA 1,7,210000000002000101,100101010100101000,000002111000101211,110000001100101002,000100000000101010,101000100010101011,000010101000101001,130100001101001011
3207  RESTORE 3207: RETURN : DATA 8,4,000000200000000020,111000002000111000,102100100000100100,101010000101101010,100110003010100001,100010101000100010,100100110000110020,111000100000111010
3208  RESTORE 3208: RETURN : DATA 0,0,310000100002010200,100101210100010100,000000001010010000,102000000000010200,000001011001010000,100110000000010000,001100100110011010,100000000000010010
3209  RESTORE 3209: RETURN : DATA 0,7,000100100000121121,002111011000101110,011121001011111121,000101001000100000,001001001000100001,001011001000100000,000010001101100001,300010001001000001
3210  RESTORE 3210: RETURN : DATA 0,7,000001011010000010,111110101111110101,100101001010111012,010002100000011001,001001110110100011,120101012001010101,010000000000011211,300010000000110110
3300  REM *APAGA MAPA
3310  FOR J = 0 TO MY - 1: POKE 277,Y0 + J: POKE 278,X0:A =  USR (M2$): NEXT J: RETURN 
3400  REM *MOSTRA NUMERO DA FASE
3410  POKE 277,22: POKE 278,6:A =  USR ( RIGHT$ (" " +  STR$ (F),2)): RETURN 
4000  REM JOGO
4010 F = 1:V = 5: GOSUB 4200: GOSUB 4300
4020  GOSUB 3000: IF M = 3 THEN V = V - 1: GOSUB 4100: IF V = 0 THEN  GOSUB 4400: GOTO 4010
4030  IF M <  > 3 THEN F = F + 1: IF F > 10 THEN  GOSUB 4500: GOTO 4010
4040  GOTO 4020
4100  REM *MOSTRA REINICIOS
4110  POKE 277,22: POKE 278,26 + (5 - V):A =  USR (P$): RETURN 
4200  REM *TELA TITULO
4210  HGR 
4220  POKE 277,1: POKE 278,10: INVERSE :A =  USR (" T A C K L E "): NORMAL 
4230  POKE 277,3: POKE 278,9: INVERSE :A =  USR (" P E N G U I N "): NORMAL 
4240  POKE 277,6: POKE 278,5:A =  USR (P$ + " ..... TACKLE PENGUIN")
4250  POKE 277,8: POKE 278,5:A =  USR (C$ + " ..... CHAVE")
4260  POKE 277,10: POKE 278,5:A =  USR (B$ + " ..... BLOCO")
4270  POKE 277,22: POKE 278,9:A =  USR ("QUALQUER TECLA")
4280  FOR A = 0 TO 1 STEP 0:A =  SGN ( PEEK (285)): NEXT A: RETURN 
4300  REM *TELA DE JOGO
4310  HGR 
4320  POKE 277,0: POKE 278,0: INVERSE :A =  USR ("         TACKLE PENGUIN         "): NORMAL 
4330  FOR J =  - 1 TO MY: POKE 277,Y0 + J: POKE 278,X0 - 1:A =  USR (M1$): NEXT J
4340  FOR J = 22 TO 23: POKE 277,J: POKE 278,0:A =  USR ("                                "): NEXT J
4350  POKE 277,22: POKE 278,0:A =  USR ("FASE:")
4360  POKE 277,22: POKE 278,16:A =  USR ("REINICIOS:")
4370  POKE 277,23: POKE 278,1:A =  USR ("MIDORINOTANUKI / EMERSON COSTA")
4380  RETURN 
4400  REM FIM DE JOGO SEM VIDAS
4410  POKE 277,12: POKE 278,11: INVERSE :A =  USR ("FIM DE JOGO"): NORMAL 
4420  REM PLAY "O5L2ER8L4DCO4BO5L8CO4BL2A","O6L2ER8L4DCO5BO6L8CO5BL2A"
4430  SOUND 100,128,1: SOUND 116,128,2: SOUND 0,32,1: SOUND 0,32,2: SOUND 98,64,1
4431  SOUND 114,64,2: SOUND 96,64,1: SOUND 112,64,2: SOUND 91,64,1: SOUND 107,64,2
4432  SOUND 96,32,1: SOUND 112,32,2: SOUND 91,32,1: SOUND 107,32,2: SOUND 89,128,1
4433  SOUND 105,128,2: SOUND 0,0,1: SOUND 0,0,2
4440  FOR A = 0 TO 1 STEP 0:A =  SGN ( PEEK (285)): NEXT A: RETURN 
4500  REM FIM DE JOGO COMPLETO
4510  POKE 277,12: POKE 278,11: INVERSE :A =  USR ("PARABENS!!"): NORMAL 
4520  REM PLAY "V10T95O5L8AR8AR4L4GL8EDCR64CR2DR64DL4CL8DR8EGEL4DL8ER4R8","V10T95O4L8AR8AR4"
4530  SOUND 105,40,1: SOUND 89,40,2: SOUND 0,40,1: SOUND 0,40,2: SOUND 105,40,1
4531  SOUND 89,40,2: SOUND 0,80,1: SOUND 0,80,2: SOUND 103,80,1: SOUND 100,40,1
4532  SOUND 98,40,1: SOUND 96,40,1: SOUND 0,5,1: SOUND 96,40,1: SOUND 0,161,1
4533  SOUND 98,40,1: SOUND 0,5,1: SOUND 98,40,1: SOUND 96,80,1: SOUND 98,40,1
4534  SOUND 0,40,1: SOUND 100,40,1: SOUND 103,40,1: SOUND 100,40,1: SOUND 98,80,1
4535  SOUND 100,40,1: SOUND 0,80,1: SOUND 0,40,1
4540  REM PLAY "O4L8AR64AL4O5CO4L8AO5L8DR8DR8DL4CL8DR8EFEFEFEFL4ER4L16AR16AR16A"
4550  SOUND 89,32,1: SOUND 0,4,1: SOUND 89,32,1: SOUND 96,64,1: SOUND 89,32,1
4551  SOUND 98,32,1: SOUND 0,32,1: SOUND 98,32,1: SOUND 0,32,1: SOUND 98,32,1
4552  SOUND 96,64,1: SOUND 98,32,1: SOUND 0,32,1: SOUND 100,32,1: SOUND 101,32,1
4553  SOUND 100,32,1: SOUND 101,32,1: SOUND 100,32,1: SOUND 101,32,1: SOUND 100,32,1
4554  SOUND 101,32,1: SOUND 100,64,1: SOUND 0,64,1: SOUND 105,16,1: SOUND 0,16,1
4555  SOUND 105,16,1: SOUND 0,16,1: SOUND 105,16,1: SOUND 0,0,1
4560  FOR A = 0 TO 1 STEP 0:A =  SGN ( PEEK (285)): NEXT A: RETURN 
10000  REM INICIALIZA JOGO
10010 MX = 18:MY = 8: REM DIMENSOES DO MAPA
10020  DIM M(MX - 1,MY - 1): REM MAPA
10030  DEF  FN XV(X) = X >  = 0 AND X < MX: REM POSICAO HORIZONTAL VALIDA
10040  DEF  FN YV(Y) = Y >  = 0 AND Y < MY: REM POSICAO VERTICAL VALIDA
10050 X = 0:Y = 0: REM POSICAO DO PINGUIM
10060 C = 0: REM NUMERO DO COMANDO
10070 X1 = 0:Y1 = 0:X2 = 0:Y2 = 0: REM POSICOES PROXIMAS AO PINGUIM
10080 DX = 0: REM DIRECAO DO MOVIMENTO HORIZONTAL
10090 XT = 0:YT = 0: REM PROXIMA POSICAO DO PINGUIM
10100 M = 0: REM MOVIMENTO (0=NENHUM, 1=PINGUIM, 2=BLOCO)
10110 F = 0: REM NUMERO DA FASE
10120 CP = 0: REM CHAVES PEGAS
10130 V = 0: REM QUANTIDADE DE VIDAS RESTANTES
10140 M$ = "": REM UMA LINHA DO MAPA
10150  RETURN 
11000  REM *INICIALIZA INTERFACE
11010 T = 0: REM TECLA PRESSIONADA
11020 C1 =  ASC ("A"):C2 =  ASC ("D"):C3 =  ASC ("Q"):C4 =  ASC ("W"):C5 =  ASC ("E"):C6 =  ASC ("G"): REM COMANDOS DE TECLADO
11030 X0 = 16 -  INT (MX / 2):Y0 = 12 -  INT (MY / 2): REM POSICAO DO MAPA NA TELA
11050 P$ =  CHR$ (99): REM SPRITE DO PINGUIM
11060 C$ =  CHR$ (98): REM SPRITE DA CHAVE
11070 E$ =  CHR$ (96): REM SPRITE DO ESPACO
11080 B$ =  CHR$ (97): REM SPRITE DO BLOCO
11090 M1$ = "": FOR I =  - 1 TO MX:M1$ = M1$ + B$: NEXT I: REM FUNDO DO MAPA (BLOCOS)
11100 M2$ = "": FOR I = 0 TO MX - 1:M2$ = M2$ + E$: NEXT I: REM FUNDO DO MAPA (ESPACOS)
11120  TEMPO 255,2,1: TEMPO 255,2,2: RETURN 
64999  END 
65000  REM INSTALADOR
65010  TEXT : HOME : PRINT "POKEANDO. AGUARDE..."
65020  RESTORE 65000
65030  READ E: PRINT E;: IF E =  - 1 THEN  RETURN 
65040  READ B: PRINT ".";: IF B =  - 1 THEN  PRINT : GOTO 65030
65050  POKE E,B:E = E + 1: GOTO 65040
65100  REM CONFIGURA USR()
65110  DATA 771
65120  DATA 195,176,60,-1
65130  REM ROTINA DE IMPRESSAO EM HGR
65140  DATA 15536
65150  DATA 205,161,232,200,71,35,35,78,35,102,105,229,33,21,1,86,35,94,33,,128,25,235,225,205,134,200,126,214,32,56,41
65160  DATA 229,213,197,38,,111,41,41,41,1,,61,9,58,82,3,214,1,159,47,79,6,8,126,169,18,35,123,198,32,95,122
65170  DATA 206,,87,16,242,193,209,225,19,35,16,207,195,121,200,-1
65180  REM TABELA DE CARACTERES (32-95)
65190  DATA 15616
65200  DATA ,,,,,,,,24,24,24,24,24,,24,,108,108,36,72,,,,,108,254,108,108,254,108,,
65210  DATA 24,62,96,60,6,124,24,,98,102,12,24,48,102,70,,56,108,56,112,222,204,118,,24,24,8,16,,,,
65220  DATA 6,12,24,24,24,12,6,,96,48,24,24,24,48,96,,,102,60,126,60,102,,,,24,24,126,24,24,,
65230  DATA ,,,,24,24,8,16,,,,126,,,,,,,,,,24,24,,2,6,12,24,48,96,64,
65240  DATA 56,76,198,198,198,100,56,,24,56,24,24,24,24,126,,124,198,14,60,120,224,254,,126,12,24,60,6,198,124,
65250  DATA 28,60,108,204,254,12,12,,252,192,252,6,6,198,124,,60,96,192,252,198,198,124,,254,198,12,24,48,48,48,
65260  DATA 120,196,228,120,134,134,124,,124,198,198,126,6,12,120,,,24,24,,24,24,,,,24,24,,24,24,8,16
65270  DATA 6,12,24,48,24,12,6,,,,126,,126,,,,96,48,24,12,24,48,96,,124,198,6,28,48,,48,
65280  DATA 60,102,206,214,206,96,60,,56,108,198,198,254,198,198,,252,198,198,252,198,198,252,,60,102,192,192,192,102,60,
65290  DATA 248,204,198,198,198,204,248,,254,192,192,252,192,192,254,,254,192,192,252,192,192,192,,62,96,192,206,198,102,62,
65300  DATA 198,198,198,254,198,198,198,,60,24,24,24,24,24,60,,30,6,6,6,6,198,124,,198,204,216,240,216,204,198,
65310  DATA 96,96,96,96,96,96,126,,198,238,254,254,214,198,198,,198,230,246,254,222,206,198,,124,198,198,198,198,198,124,
65320  DATA 252,198,198,252,192,192,192,,124,198,198,198,222,204,122,,252,198,198,252,216,204,198,,120,204,192,124,6,198,124,
65330  DATA 126,24,24,24,24,24,24,,198,198,198,198,198,198,124,,198,198,198,238,124,56,16,,198,198,214,254,254,238,198,
65340  DATA 198,238,124,56,124,238,198,,102,102,102,60,24,24,24,,254,14,28,56,112,224,254,,30,24,24,24,24,24,30,
65350  DATA 64,96,48,24,12,6,2,,120,24,24,24,24,24,120,,16,56,108,198,,,,,,,,,,,,255
65360  REM SPRITES (96-99)
65370  DATA 255,255,255,255,255,255,255,255,129,60,66,64,64,64,32,129,159,95,31,239,245,250,253,255,195,129,165,24,36,126,165,153,-1
65380  REM ROTINA DE FLUIDEZ DE TECLADO
65390  DATA 59
65400  DATA 33,14,,57,126,254,93,192,35,126,254,221,192,33,8,,57,17,83,,115,35,114,201,193,209,51,51,50,29,1,183,58,27,1,50,28,1,196,223,221,195,97,221,-1
65410  DATA 289
65420  DATA 59,,-1
65430  DATA 288
65440  DATA 195,-1
65450  DATA -1
65528  REM "TACKLE PENGUIN"
65529  REM JOGO ORIGINAL PARA FM-7/77 POR
65530  REM MIDORINOTANUKI
65531  REM PUBLICADO NA REVISTA MYCOM BASIC MAGAZINE, 1988-04, PP. 118-119
65532  REM HTTPS://ARCHIVE.ORG/DETAILS/MYCOM-BASIC-MAGAZINE-1988-04
65533  REM VERSAO PARA MC-1000 POR
65534  REM EMERSON JOSE SILVEIRA DA COSTA (ENSJO)
65535  REM 2017-04-09
