/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* file: gate/_gat_xlt.p */

/* generic name conversion code taken from: */
/* ora_fil - File manager for ORACLE databases */
/* ora_idx - Index manager for ORACLE databases */

/*
old version, new version is file prodict/gate/_gat_fnm.p

Modified: 07/13/98 Added _Owner to _file finds

*/
/*h-*/

DEFINE INPUT        PARAMETER file-index AS LOGICAL   NO-UNDO.
DEFINE INPUT        PARAMETER obj_parent AS RECID     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER obj_name   AS CHARACTER NO-UNDO.

/*
DEFINE VARIABLE c AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER   NO-UNDO.
DEFINE VARIABLE r AS RECID     NO-UNDO.
DEFINE VARIABLE s AS CHARACTER NO-UNDO.
*/

if file-index = TRUE
 then run prodict/gate/_gat_fnm.p
  ( INPUT        "TABLE",
    INPUT        obj_parent,
    INPUT-OUTPUT obj_name
  ).
else 
if file-index = FALSE
 then run prodict/gate/_gat_fnm.p
  ( INPUT        "INDEX",
    INPUT        obj_parent,
    INPUT-OUTPUT obj_name
  ).
 else run prodict/gate/_gat_fnm.p
  ( INPUT        "SEQUENCE",
    INPUT        obj_parent,
    INPUT-OUTPUT obj_name
  ).

/*
IF file-index = TRUE THEN DO TRANSACTION: /*--*/ /* translate file name */
  /* this translates a foreign file name into a native file name which is
     guaranteed not to be currently in use in this database */
  ASSIGN
    c = SUBSTRING(obj_name,INDEX(obj_name,".") + 1,-1,"character")
    c = SUBSTRING(c,IF c BEGINS "_" THEN 2 ELSE 1,32,"character").
  DO i = 1 to LENGTH(c,"character"): 
    IF INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ", SUBSTRING(c, i, 1,"character")) <= 0 THEN
      ASSIGN SUBSTRING(c, i, 1,"character") = "_".
  END.
  ASSIGN    
    c = c + (IF KEYWORD(c) = ? THEN "" ELSE "_")
    s = c.
  DO i = 1 TO 9999
    WHILE CAN-FIND(FIRST _File
      WHERE _File._Db-recid = obj_parent AND _File._File-name = c
        AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")):
    c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") + STRING(- i).
  END.
  obj_name = c.
END.

ELSE IF file-index = FALSE THEN DO TRANSACTION: /* translate index name */
  /* this translates a foreign index name into a native index name which
     is guaranteed not to be currently in use in this file */
  FIND _File WHERE RECID(_File) = obj_parent.
  ASSIGN
    c = obj_name
    s = _File._For-Name
    s = SUBSTRING(s,INDEX(s,".") + 1,-1,"character").
  IF c BEGINS s + "##" THEN c = SUBSTRING(c,LENGTH(s,"character") + 3,-1,"character").
  c = SUBSTRING(c,IF c BEGINS "_" THEN 2 ELSE 1,32,"character").
  DO i = 1 to LENGTH(c,"character"): 
    IF INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ", SUBSTRING(c, i, 1,"character")) <= 0 THEN
      ASSIGN SUBSTRING(c, i, 1, "character") = "_".
  END.
  IF KEYWORD(c) <> ? THEN SUBSTRING(c,MINIMUM(32,LENGTH(c,"character") + 1),-1,"character") = "_".
  s = c.
  DO i = 1 TO 9999
    WHILE CAN-FIND(FIRST _Index OF _File
      WHERE _Index._Index-name = c):
    c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") + STRING(- i).
  END.
  obj_name = c.
END.

ELSE DO TRANSACTION: /*-------------------*/ /* translate sequence name */
  /* this translates a foreign sequence name into a native sequence name which
     is guaranteed not to be currently in use in this file */
  ASSIGN
    c = SUBSTRING(obj_name,INDEX(obj_name,".") + 1,-1,"character")
    c = SUBSTRING(c,IF c BEGINS "_" THEN 2 ELSE 1,32,"character").
  DO i = 1 to LENGTH(c,"character"): 
    IF INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ", SUBSTRING(c, i, 1,"character")) <= 0 THEN
      ASSIGN SUBSTRING(c, i, 1,"character") = "_".
  END.
  ASSIGN    
    c = c + (IF KEYWORD(c) = ? THEN "" ELSE "_")
    s = c.
  DO i = 1 TO 9999
    WHILE CAN-FIND(FIRST _Sequence
      WHERE /* _Sequence._Db-recid = obj_parent 
      AND   */ _Sequence._Seq-name = c):
    c = SUBSTRING(s,1,32 - LENGTH(STRING(- i),"character"),"character") + STRING(- i).
  END.
  obj_name = c.
END.
*/

RETURN.
