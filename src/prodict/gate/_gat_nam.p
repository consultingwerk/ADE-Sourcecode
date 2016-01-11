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

/* OLD VERSION!!!! CHECK GATE/_GAT_FNM.P !!!!!   (hutegger 95/04) */
/* gate_nam - find unique field name for gateway field extraction */

DEFINE INPUT        PARAMETER offile    AS RECID     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER fieldname AS CHARACTER NO-UNDO.

DEFINE VARIABLE c       AS CHARACTER NO-UNDO.
DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE ind     AS INTEGER   NO-UNDO.
DEFINE VARIABLE endlp   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE s       AS CHARACTER NO-UNDO.
DEFINE VARIABLE ch      AS CHARACTER NO-UNDO.

/* this translates a foreign field name into a native field name which
   is guaranteed not to be currently in use in this file */

c = fieldname.
DO WHILE INDEX("ABCDEFGHIJKLMNOPQRSTUVWXYZ",SUBSTRING(c,1,1)) = 0 AND c <> "":
  c = SUBSTRING(c,2).
END.

endlp = no.
ind = 1.
DO WHILE NOT endlp:
  ch = SUBSTRING(c, ind, 1).
  IF LENGTH(ch) = 0 OR ch = ? THEN DO:
      endlp = yes.
      NEXT.
  END. 
  
  IF INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ", ch) <= 0 THEN
    SUBSTRING(c, ind, 1) = "_".

  ind = ind + 1.
END.

ASSIGN
  c = (IF c = "" THEN "noname" ELSE c) /* avoid 0-len names */
  s = "".

IF KEYWORD(c) <> ? THEN SUBSTRING(c,MINIMUM(32,LENGTH(c) + 1)) = "_".
s = c.

DO i = 1 TO 9999
  WHILE CAN-FIND(FIRST _Field WHERE _File-recid = offile AND _Field-name = c):
  c = SUBSTRING(s,1,32 - LENGTH(STRING(- i))) + STRING(- i).
END.

assign
  fieldname = c.
  
RETURN.
