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

/* JEP WIN32 7/11/97 3:56PM */
IF CAN-DO("OS2,MSDOS,WIN32,UNIX,VMS":u,OPSYS) THEN DO:
  qbf-i = INDEX(qbf-b,":":u).
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1,-1,"CHARACTER":u)
      qbf-i = INDEX(qbf-b,":":u).
  END.
END.

IF CAN-DO("OS2,MSDOS,WIN32,UNIX":u,OPSYS) THEN DO:
  qbf-i = MAXIMUM(INDEX(qbf-b,"~\":u),INDEX(qbf-b,"/":u)).
  DO WHILE qbf-i > 0:
    ASSIGN
      qbf-b = SUBSTRING(qbf-b,qbf-i + 1,-1,"CHARACTER":u)
      qbf-i = MAXIMUM(INDEX(qbf-b,"~\":u),INDEX(qbf-b,"/":u)).
  END.
END.

IF OPSYS = "BTOS":u THEN
  IF qbf-b MATCHES "~{*~}*":u THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"~}":u) + 1,-1,"CHARACTER":u).

IF CAN-DO("VMS,BTOS":u,OPSYS) THEN
  IF qbf-b MATCHES "[*]*":u THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,"]":u) + 1,-1,"CHARACTER":u).

IF CAN-DO("VMS,BTOS":u,OPSYS) THEN
  IF qbf-b MATCHES "<*>*":u THEN
    qbf-b = SUBSTRING(qbf-b,INDEX(qbf-b,">":u) + 1,-1,"CHARACTER":u).

qbf-p = SUBSTRING(qbf-f,1,LENGTH(qbf-f,"CHARACTER":u)
                            - LENGTH(qbf-b,"CHARACTER":u),"CHARACTER":u).
RETURN.

/* s-prefix.p - end of file */

