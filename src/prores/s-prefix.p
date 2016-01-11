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
/* s-prefix.p - splits the filename prefix from the basename */

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-p AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
qbf-b = qbf-f.

IF CAN-DO("OS2,MSDOS,UNIX,VMS",OPSYS) THEN DO:
  qbf-i = INDEX(qbf-b,":").
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1)
      qbf-i = INDEX(qbf-b,":").
  END.
END.

IF CAN-DO("OS2,MSDOS,UNIX",OPSYS) THEN DO:
  qbf-i = MAXIMUM(INDEX(qbf-b,"~\"),INDEX(qbf-b,"/")).
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1)
      qbf-i = MAXIMUM(INDEX(qbf-b,"~\"),INDEX(qbf-b,"/")).
  END.
END.

IF OPSYS = "BTOS" THEN
  IF qbf-b MATCHES "~{*~}*" THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"~}") + 1).

IF CAN-DO("VMS,BTOS",OPSYS) THEN
  IF qbf-b MATCHES "[*]*" THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"]") + 1).

IF OPSYS = "BTOS" THEN
  IF qbf-b MATCHES "<*>*" THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,">") + 1).

qbf-p = SUBSTRING(qbf-f,1,LENGTH(qbf-f) - LENGTH(qbf-b)).
RETURN.
