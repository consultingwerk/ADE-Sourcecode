/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* d-type.i - set defaults for export types */

IF {&type} = "PROGRESS" THEN
  ASSIGN
    qbf-d-attr[2] = "false"
    qbf-d-attr[3] = ',,,,,,,,,,,'
    qbf-d-attr[4] = '32,13,10,,,,,,,,,'
    qbf-d-attr[5] = '34,,,,,,,,,,,'
    qbf-d-attr[6] = '32,,,,,,,,,,,'
    qbf-d-attr[7] = '*'.
ELSE
IF CAN-DO("ASCII,ASCII-H,CSV,FIXED",{&type}) THEN
  ASSIGN
    qbf-d-attr[2] = TRIM(STRING({&type} MATCHES "*-H","true/false"))
    qbf-d-attr[3] = ',,,,,,,,,,,'
    qbf-d-attr[4] = '13,10,,,,,,,,,,'
    qbf-d-attr[5] = '34,,,,,,,,,,,'
    qbf-d-attr[6] = '44,,,,,,,,,,,'
    qbf-d-attr[7] = (IF {&type} = "CSV" THEN '1,2,3' ELSE '*').
ELSE
IF CAN-DO("DIF,SYLK,USER",{&type}) THEN
  ASSIGN
    qbf-d-attr[2] = "false"
    qbf-d-attr[3] = ',,,,,,,,,,,'
    qbf-d-attr[4] = ',,,,,,,,,,,'
    qbf-d-attr[5] = ',,,,,,,,,,,'
    qbf-d-attr[6] = ',,,,,,,,,,,'
    qbf-d-attr[7] = '*'.
ELSE
IF CAN-DO("WS,WORD",{&type}) THEN
  ASSIGN
    qbf-d-attr[2] = (IF {&type} = "WS" THEN "false" ELSE "true")
    qbf-d-attr[3] = ',,,,,,,,,,,'
    qbf-d-attr[4] = '13,10,,,,,,,,,,'
    qbf-d-attr[5] = '34,,,,,,,,,,,'
    qbf-d-attr[6] = '44,,,,,,,,,,,'
    qbf-d-attr[7] = '1,2,3'.
ELSE
IF {&type} = "WORD4WIN" THEN
  ASSIGN
    qbf-d-attr[2] = "true"
    qbf-d-attr[3] = ',,,,,,,,,,,'
    qbf-d-attr[4] = '13,10,,,,,,,,,,'
    qbf-d-attr[5] = ',,,,,,,,,,,'
    qbf-d-attr[6] = '9,,,,,,,,,,,'
    qbf-d-attr[7] = '1,2,3'.
ELSE
IF {&type} = "WPERF" THEN
  ASSIGN
    qbf-d-attr[2] = "false"
    qbf-d-attr[3] = ',,,,,,,,,,,'
    qbf-d-attr[4] = '5,13,10,,,,,,,,,'  /* ctrl-E */
    qbf-d-attr[5] = ',,,,,,,,,,,'
    qbf-d-attr[6] = '18,13,10,,,,,,,,,' /* ctrl-R */
    qbf-d-attr[7] = '*'.
ELSE
IF {&type} = "OFISW" THEN
  ASSIGN
    qbf-d-attr[2] = "true"
    qbf-d-attr[3] = '42,124,,,,,,,,,,'
    qbf-d-attr[4] = '10,,,,,,,,,,,'
    qbf-d-attr[5] = ',,,,,,,,,,,'
    qbf-d-attr[6] = '124,,,,,,,,,,,'
    qbf-d-attr[7] = '*'.
