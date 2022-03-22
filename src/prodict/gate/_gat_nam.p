/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
