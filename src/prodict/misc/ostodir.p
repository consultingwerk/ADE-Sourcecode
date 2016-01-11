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

/* ostodir.p - takes its parameter and makes it look like a directory name */

DEFINE INPUT-OUTPUT PARAMETER dirname AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

IF dirname = "" AND OPSYS = "UNIX" THEN dirname = "./".

i = (IF CAN-DO("MSDOS,WIN32,OS2",OPSYS) THEN INDEX(dirname,"~\") ELSE 0).
DO WHILE i > 0:
  ASSIGN
    OVERLAY(dirname,i,1) = "/"
    i = INDEX(dirname,"~\").
END.

IF CAN-DO("MSDOS,WIN32,OS2,UNIX",OPSYS) AND dirname <> ""
  AND NOT dirname MATCHES "*/" THEN dirname = dirname + "/".

RETURN.
