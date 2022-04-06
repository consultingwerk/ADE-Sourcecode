/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
  /* delet_cd.i -- include file to delete a code block
   * and the associated _code-text records. 
   * (by Wm.T.Wood 2/3/97) 
   */  
  &IF DEFINED(delet_cd) eq 0 &THEN 
  /* Define the variables used by this include file only once per file */
  &Global-define delet_cd yes
  DEFINE VARIABLE delcdText-id LIKE _code._text-id NO-UNDO.
  &ENDIF  
  
  delcdText-id = _code._text-id.
  DO WHILE delcdText-id ne ?:
  FIND _code-text WHERE RECID(_code-text) eq delcdText-id.
  delcdText-id = _code-text._next-id.
    DELETE _code-text.
  END.
  DELETE _code.

