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
