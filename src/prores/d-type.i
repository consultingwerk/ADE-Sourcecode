/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
