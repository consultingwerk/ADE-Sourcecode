&IF DEFINED(TTVARARRAY) = 0 &THEN
  &SCOPED-DEFINE TTVARARRAY ghTempTable
&ENDIF

ASSIGN
  phCallTableHandle01 = {&TTVARARRAY}[01]
  phCallTableHandle02 = {&TTVARARRAY}[02]
  phCallTableHandle03 = {&TTVARARRAY}[03]
  phCallTableHandle04 = {&TTVARARRAY}[04]
  phCallTableHandle05 = {&TTVARARRAY}[05]
  phCallTableHandle06 = {&TTVARARRAY}[06]
  phCallTableHandle07 = {&TTVARARRAY}[07]
  phCallTableHandle08 = {&TTVARARRAY}[08]
  phCallTableHandle09 = {&TTVARARRAY}[09]
  phCallTableHandle10 = {&TTVARARRAY}[10]
  phCallTableHandle11 = {&TTVARARRAY}[11]
  phCallTableHandle12 = {&TTVARARRAY}[12]
  phCallTableHandle13 = {&TTVARARRAY}[13]
  phCallTableHandle14 = {&TTVARARRAY}[14]
  phCallTableHandle15 = {&TTVARARRAY}[15]
  phCallTableHandle16 = {&TTVARARRAY}[16]
  phCallTableHandle17 = {&TTVARARRAY}[17]
  phCallTableHandle18 = {&TTVARARRAY}[18]
  phCallTableHandle19 = {&TTVARARRAY}[19]
  phCallTableHandle20 = {&TTVARARRAY}[20]
  phCallTableHandle21 = {&TTVARARRAY}[21]
  phCallTableHandle22 = {&TTVARARRAY}[22]
  phCallTableHandle23 = {&TTVARARRAY}[23]
  phCallTableHandle24 = {&TTVARARRAY}[24]
  phCallTableHandle25 = {&TTVARARRAY}[25]
  phCallTableHandle26 = {&TTVARARRAY}[26]
  phCallTableHandle27 = {&TTVARARRAY}[27]
  phCallTableHandle28 = {&TTVARARRAY}[28]
  phCallTableHandle29 = {&TTVARARRAY}[29]
  phCallTableHandle30 = {&TTVARARRAY}[30]
  phCallTableHandle31 = {&TTVARARRAY}[31]
  phCallTableHandle32 = {&TTVARARRAY}[32]
  phCallTableHandle33 = {&TTVARARRAY}[33]
  phCallTableHandle34 = {&TTVARARRAY}[34]
  phCallTableHandle35 = {&TTVARARRAY}[35]
  phCallTableHandle36 = {&TTVARARRAY}[36]
  phCallTableHandle37 = {&TTVARARRAY}[37]
  phCallTableHandle38 = {&TTVARARRAY}[38]
  phCallTableHandle39 = {&TTVARARRAY}[39]
  phCallTableHandle40 = {&TTVARARRAY}[40]
  phCallTableHandle41 = {&TTVARARRAY}[41]
  phCallTableHandle42 = {&TTVARARRAY}[42]
  phCallTableHandle43 = {&TTVARARRAY}[43]
  phCallTableHandle44 = {&TTVARARRAY}[44]
  phCallTableHandle45 = {&TTVARARRAY}[45]
  phCallTableHandle46 = {&TTVARARRAY}[46]
  phCallTableHandle47 = {&TTVARARRAY}[47]
  phCallTableHandle48 = {&TTVARARRAY}[48]
  phCallTableHandle49 = {&TTVARARRAY}[49]
  phCallTableHandle50 = {&TTVARARRAY}[50]
  phCallTableHandle51 = {&TTVARARRAY}[51]
  phCallTableHandle52 = {&TTVARARRAY}[52]
  phCallTableHandle53 = {&TTVARARRAY}[53]
  phCallTableHandle54 = {&TTVARARRAY}[54]
  phCallTableHandle55 = {&TTVARARRAY}[55]
  phCallTableHandle56 = {&TTVARARRAY}[56]
  phCallTableHandle57 = {&TTVARARRAY}[57]
  phCallTableHandle58 = {&TTVARARRAY}[58]
  phCallTableHandle59 = {&TTVARARRAY}[59]
  phCallTableHandle60 = {&TTVARARRAY}[60]
  phCallTableHandle61 = {&TTVARARRAY}[61]
  phCallTableHandle62 = {&TTVARARRAY}[62]
  phCallTableHandle63 = {&TTVARARRAY}[63]
  phCallTableHandle64 = {&TTVARARRAY}[64]
.

&UNDEFINE TTVARARRAY

/* Delete the handle to prevent memory leaks */
IF VALID-HANDLE(phCallTableHandle01)  AND
   NOT CAN-DO(pcHandlesToSkip,"1":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"01":U) THEN
  DELETE OBJECT phCallTableHandle01.
IF VALID-HANDLE(phCallTableHandle02)  AND
   NOT CAN-DO(pcHandlesToSkip,"2":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"02":U) THEN
  DELETE OBJECT phCallTableHandle02.
IF VALID-HANDLE(phCallTableHandle03)  AND
   NOT CAN-DO(pcHandlesToSkip,"3":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"03":U) THEN
  DELETE OBJECT phCallTableHandle03.
IF VALID-HANDLE(phCallTableHandle04)  AND
   NOT CAN-DO(pcHandlesToSkip,"4":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"04":U) THEN
  DELETE OBJECT phCallTableHandle04.
IF VALID-HANDLE(phCallTableHandle05)  AND
   NOT CAN-DO(pcHandlesToSkip,"5":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"05":U) THEN
  DELETE OBJECT phCallTableHandle05.
IF VALID-HANDLE(phCallTableHandle06)  AND
   NOT CAN-DO(pcHandlesToSkip,"6":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"06":U) THEN
  DELETE OBJECT phCallTableHandle06.
IF VALID-HANDLE(phCallTableHandle07)  AND
   NOT CAN-DO(pcHandlesToSkip,"7":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"07":U) THEN
  DELETE OBJECT phCallTableHandle07.
IF VALID-HANDLE(phCallTableHandle08)  AND
   NOT CAN-DO(pcHandlesToSkip,"8":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"08":U) THEN
  DELETE OBJECT phCallTableHandle08.
IF VALID-HANDLE(phCallTableHandle09)  AND
   NOT CAN-DO(pcHandlesToSkip,"9":U)  AND 
   NOT CAN-DO(pcHandlesToSkip,"09":U) THEN
  DELETE OBJECT phCallTableHandle09.
IF VALID-HANDLE(phCallTableHandle10)  AND
   NOT CAN-DO(pcHandlesToSkip,"10":U) THEN
  DELETE OBJECT phCallTableHandle10.
IF VALID-HANDLE(phCallTableHandle11)  AND
   NOT CAN-DO(pcHandlesToSkip,"11":U) THEN
  DELETE OBJECT phCallTableHandle11.
IF VALID-HANDLE(phCallTableHandle12)  AND
   NOT CAN-DO(pcHandlesToSkip,"12":U) THEN
  DELETE OBJECT phCallTableHandle12.
IF VALID-HANDLE(phCallTableHandle13)  AND
   NOT CAN-DO(pcHandlesToSkip,"13":U) THEN
  DELETE OBJECT phCallTableHandle13.
IF VALID-HANDLE(phCallTableHandle14)  AND
   NOT CAN-DO(pcHandlesToSkip,"14":U) THEN
  DELETE OBJECT phCallTableHandle14.
IF VALID-HANDLE(phCallTableHandle15)  AND
   NOT CAN-DO(pcHandlesToSkip,"15":U) THEN
  DELETE OBJECT phCallTableHandle15.
IF VALID-HANDLE(phCallTableHandle16)  AND
   NOT CAN-DO(pcHandlesToSkip,"16":U) THEN
  DELETE OBJECT phCallTableHandle16.
IF VALID-HANDLE(phCallTableHandle17)  AND
   NOT CAN-DO(pcHandlesToSkip,"17":U) THEN
  DELETE OBJECT phCallTableHandle17.
IF VALID-HANDLE(phCallTableHandle18)  AND
   NOT CAN-DO(pcHandlesToSkip,"18":U) THEN
  DELETE OBJECT phCallTableHandle18.
IF VALID-HANDLE(phCallTableHandle19)  AND
   NOT CAN-DO(pcHandlesToSkip,"19":U) THEN
  DELETE OBJECT phCallTableHandle19.
IF VALID-HANDLE(phCallTableHandle20)  AND
   NOT CAN-DO(pcHandlesToSkip,"20":U) THEN
  DELETE OBJECT phCallTableHandle20.
IF VALID-HANDLE(phCallTableHandle21)  AND
   NOT CAN-DO(pcHandlesToSkip,"21":U) THEN
  DELETE OBJECT phCallTableHandle21.
IF VALID-HANDLE(phCallTableHandle22)  AND
   NOT CAN-DO(pcHandlesToSkip,"22":U) THEN
  DELETE OBJECT phCallTableHandle22.
IF VALID-HANDLE(phCallTableHandle23)  AND
   NOT CAN-DO(pcHandlesToSkip,"23":U) THEN
  DELETE OBJECT phCallTableHandle23.
IF VALID-HANDLE(phCallTableHandle24)  AND
   NOT CAN-DO(pcHandlesToSkip,"24":U) THEN
  DELETE OBJECT phCallTableHandle24.
IF VALID-HANDLE(phCallTableHandle25)  AND
   NOT CAN-DO(pcHandlesToSkip,"25":U) THEN
  DELETE OBJECT phCallTableHandle25.
IF VALID-HANDLE(phCallTableHandle26)  AND
   NOT CAN-DO(pcHandlesToSkip,"26":U) THEN
  DELETE OBJECT phCallTableHandle26.
IF VALID-HANDLE(phCallTableHandle27)  AND
   NOT CAN-DO(pcHandlesToSkip,"27":U) THEN
  DELETE OBJECT phCallTableHandle27.
IF VALID-HANDLE(phCallTableHandle28)  AND
   NOT CAN-DO(pcHandlesToSkip,"28":U) THEN
  DELETE OBJECT phCallTableHandle28.
IF VALID-HANDLE(phCallTableHandle29)  AND
   NOT CAN-DO(pcHandlesToSkip,"29":U) THEN
  DELETE OBJECT phCallTableHandle29.
IF VALID-HANDLE(phCallTableHandle30)  AND
   NOT CAN-DO(pcHandlesToSkip,"30":U) THEN
  DELETE OBJECT phCallTableHandle30.
IF VALID-HANDLE(phCallTableHandle31)  AND
   NOT CAN-DO(pcHandlesToSkip,"31":U) THEN
  DELETE OBJECT phCallTableHandle31.
IF VALID-HANDLE(phCallTableHandle32)  AND
   NOT CAN-DO(pcHandlesToSkip,"32":U) THEN
  DELETE OBJECT phCallTableHandle32.
IF VALID-HANDLE(phCallTableHandle33)  AND
   NOT CAN-DO(pcHandlesToSkip,"33":U) THEN
  DELETE OBJECT phCallTableHandle33.
IF VALID-HANDLE(phCallTableHandle34)  AND
   NOT CAN-DO(pcHandlesToSkip,"34":U) THEN
  DELETE OBJECT phCallTableHandle34.
IF VALID-HANDLE(phCallTableHandle35)  AND
   NOT CAN-DO(pcHandlesToSkip,"35":U) THEN
  DELETE OBJECT phCallTableHandle35.
IF VALID-HANDLE(phCallTableHandle36)  AND
   NOT CAN-DO(pcHandlesToSkip,"36":U) THEN
  DELETE OBJECT phCallTableHandle36.
IF VALID-HANDLE(phCallTableHandle37)  AND
   NOT CAN-DO(pcHandlesToSkip,"37":U) THEN
  DELETE OBJECT phCallTableHandle37.
IF VALID-HANDLE(phCallTableHandle38)  AND
   NOT CAN-DO(pcHandlesToSkip,"38":U) THEN
  DELETE OBJECT phCallTableHandle38.
IF VALID-HANDLE(phCallTableHandle39)  AND
   NOT CAN-DO(pcHandlesToSkip,"39":U) THEN
  DELETE OBJECT phCallTableHandle39.
IF VALID-HANDLE(phCallTableHandle40)  AND
   NOT CAN-DO(pcHandlesToSkip,"40":U) THEN
  DELETE OBJECT phCallTableHandle40.
IF VALID-HANDLE(phCallTableHandle41)  AND
   NOT CAN-DO(pcHandlesToSkip,"41":U) THEN
  DELETE OBJECT phCallTableHandle41.
IF VALID-HANDLE(phCallTableHandle42)  AND
   NOT CAN-DO(pcHandlesToSkip,"42":U) THEN
  DELETE OBJECT phCallTableHandle42.
IF VALID-HANDLE(phCallTableHandle43)  AND
   NOT CAN-DO(pcHandlesToSkip,"43":U) THEN
  DELETE OBJECT phCallTableHandle43.
IF VALID-HANDLE(phCallTableHandle44)  AND
   NOT CAN-DO(pcHandlesToSkip,"44":U) THEN
  DELETE OBJECT phCallTableHandle44.
IF VALID-HANDLE(phCallTableHandle45)  AND
   NOT CAN-DO(pcHandlesToSkip,"45":U) THEN
  DELETE OBJECT phCallTableHandle45.
IF VALID-HANDLE(phCallTableHandle46)  AND
   NOT CAN-DO(pcHandlesToSkip,"46":U) THEN
  DELETE OBJECT phCallTableHandle46.
IF VALID-HANDLE(phCallTableHandle47)  AND
   NOT CAN-DO(pcHandlesToSkip,"47":U) THEN
  DELETE OBJECT phCallTableHandle47.
IF VALID-HANDLE(phCallTableHandle48)  AND
   NOT CAN-DO(pcHandlesToSkip,"48":U) THEN
  DELETE OBJECT phCallTableHandle48.
IF VALID-HANDLE(phCallTableHandle49)  AND
   NOT CAN-DO(pcHandlesToSkip,"49":U) THEN
  DELETE OBJECT phCallTableHandle49.
IF VALID-HANDLE(phCallTableHandle50)  AND
   NOT CAN-DO(pcHandlesToSkip,"50":U) THEN
  DELETE OBJECT phCallTableHandle50.
IF VALID-HANDLE(phCallTableHandle51)  AND
   NOT CAN-DO(pcHandlesToSkip,"51":U) THEN
  DELETE OBJECT phCallTableHandle51.
IF VALID-HANDLE(phCallTableHandle52)  AND
   NOT CAN-DO(pcHandlesToSkip,"52":U) THEN
  DELETE OBJECT phCallTableHandle52.
IF VALID-HANDLE(phCallTableHandle53)  AND
   NOT CAN-DO(pcHandlesToSkip,"53":U) THEN
  DELETE OBJECT phCallTableHandle53.
IF VALID-HANDLE(phCallTableHandle54)  AND
   NOT CAN-DO(pcHandlesToSkip,"54":U) THEN
  DELETE OBJECT phCallTableHandle54.
IF VALID-HANDLE(phCallTableHandle55)  AND
   NOT CAN-DO(pcHandlesToSkip,"55":U) THEN
  DELETE OBJECT phCallTableHandle55.
IF VALID-HANDLE(phCallTableHandle56)  AND
   NOT CAN-DO(pcHandlesToSkip,"56":U) THEN
  DELETE OBJECT phCallTableHandle56.
IF VALID-HANDLE(phCallTableHandle57)  AND
   NOT CAN-DO(pcHandlesToSkip,"57":U) THEN
  DELETE OBJECT phCallTableHandle57.
IF VALID-HANDLE(phCallTableHandle58)  AND
   NOT CAN-DO(pcHandlesToSkip,"58":U) THEN
  DELETE OBJECT phCallTableHandle58.
IF VALID-HANDLE(phCallTableHandle59)  AND
   NOT CAN-DO(pcHandlesToSkip,"59":U) THEN
  DELETE OBJECT phCallTableHandle59.
IF VALID-HANDLE(phCallTableHandle60)  AND
   NOT CAN-DO(pcHandlesToSkip,"60":U) THEN
  DELETE OBJECT phCallTableHandle60.
IF VALID-HANDLE(phCallTableHandle61)  AND
   NOT CAN-DO(pcHandlesToSkip,"61":U) THEN
  DELETE OBJECT phCallTableHandle61.
IF VALID-HANDLE(phCallTableHandle62)  AND
   NOT CAN-DO(pcHandlesToSkip,"62":U) THEN
  DELETE OBJECT phCallTableHandle62.
IF VALID-HANDLE(phCallTableHandle63)  AND
   NOT CAN-DO(pcHandlesToSkip,"63":U) THEN
  DELETE OBJECT phCallTableHandle63.
IF VALID-HANDLE(phCallTableHandle64)  AND
   NOT CAN-DO(pcHandlesToSkip,"64":U) THEN
  DELETE OBJECT phCallTableHandle64.
