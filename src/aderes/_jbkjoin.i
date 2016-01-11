/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _jbkjoin
*
*    An internal procedure (for performance) that breaks apart
*    the join information
*/

&GLOBAL-DEFINE defaultJoinType "     "

PROCEDURE breakJoinInfo:
  /* Purpose: Given a join element, break it apart into its various state */

  DEFINE INPUT  PARAMETER joinElement   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER joinIndex     AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER joinType      AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER joinTypeShort AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER whereIndex    AS INTEGER   NO-UNDO.

  DEFINE VARIABLE thisJoin AS CHARACTER NO-UNDO.
  DEFINE VARIABLE colonLoc AS INTEGER   NO-UNDO.

  joinIndex = ?.
  IF LENGTH(joinElement,"CHARACTER":u) = 0 THEN RETURN.

  ASSIGN
    joinType      = {&defaultJoinType}
    joinTypeShort = "?"
    thisJoin      = SUBSTRING(joinElement,2,-1,"CHARACTER":u)
    colonLoc      = INDEX(thisJoin, ":":u)
    .

  IF (colonLoc > 0) THEN 
    ASSIGN
      whereIndex = INTEGER(SUBSTRING(thisJoin,colonLoc + 1,-1,"CHARACTER":u))
      joinIndex  = INTEGER(SUBSTRING(thisJoin,1,colonLoc - 1,"CHARACTER":u))
      .
  ELSE
    ASSIGN
      whereIndex = 0
      joinIndex  = INTEGER(thisJoin)
      .

  ASSIGN
    joinTypeShort = SUBSTRING(joinElement,1,1,"CHARACTER":u)
    joinType      = ENTRY(INDEX({&joinTypeSymbolString}, joinTypeShort),
                          {&joinTypeTextList}) + "  ":u.
END PROCEDURE.

/* _jbkjoin.i -  end of file */
