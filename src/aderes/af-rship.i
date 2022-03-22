/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * af-rship.i
 *
 *    Internal procedure to figure out if a saved relationship is still
 *    valid and populates the data structures
 *
 *  This procedure is included in af-idefs.i so may not contain any
 *  variable starting with underscore.
 *
 *  For performance, it is up to the caller to sort the relationships. The
 *  perform the sort after all relats are added, instead of on each call.
 */

/*------------------------------------------------------------------------*/
PROCEDURE af-rship:
  DEFINE INPUT PARAMETER baseTableName  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER otherTableName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER relationString AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER leftText       AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER rightText      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER aliasOnly      AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER abortRead     AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE baseIndex    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE otherIndex   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE relationType AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf-i        AS INTEGER   NO-UNDO. /* loop scrap */
  DEFINE VARIABLE qbf-j        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf-t        AS CHARACTER NO-UNDO. /* tables to join */
  DEFINE VARIABLE upgradedRel  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE relExists    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE tIndex       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cJunk        AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE lJunk        AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE iJunk        AS INTEGER   NO-UNDO. /* scrap */

  /*
  message
    "basetable" basetablename skip
    "othertable" othertablename skip
    "relation" relationstring skip
    "lefttext" lefttext skip
    "righttext" righttext skip
    "aliasonly" aliasonly skip
    view-as alert-box title "af-rship.i".
  */

  /*
   * See if these tables are still valid. The tables may been destroyed
   * or the user has lost permission to use them.
   */
  {&FIND_TABLE_BY_NAME} baseTableName NO-ERROR.
  IF NOT AVAILABLE (qbf-rel-buf) THEN RETURN.
  baseIndex = qbf-rel-buf.tid.
  
  {&FIND_TABLE2_BY_NAME} otherTableName NO-ERROR.
  IF NOT AVAILABLE (qbf-rel-buf2) THEN RETURN.
  otherIndex = qbf-rel-buf2.tid.

  /* If the client only wants aliases relationships to be created...  */
  IF aliasOnly = TRUE THEN
    IF (qbf-rel-buf.sid = ? AND qbf-rel-buf2.sid = ?) THEN RETURN.

  /* Get the internal representation of the relationship */
  ASSIGN
    relationType = SUBSTRING({&joinTypeSymbolString}, 
      LOOKUP(relationString,{&joinTypeTextList}), 1,"CHARACTER":u)
    qbf-t        = baseTableName + CHR(10) + otherTableName.
    
  IF relationType = {&joinShTypeUnknown} THEN
    RUN aderes/j-guess.p (baseIndex, otherIndex, leftText,
                         OUTPUT relationType).

  /*
   * We have to decide to upgrade from standard to custom, or just to add, or
   * to ignore.  The upgrade happens because the natural relationships have 
   * already been figured out. If the custom join involves two tables that 
   * have a natural join then we "upgrade".
   */
  DO qbf-i = 2 TO NUM-ENTRIES(qbf-rel-buf.rels):
    RUN breakJoinInfo (ENTRY(qbf-i, qbf-rel-buf.rels),
      OUTPUT tIndex,
      OUTPUT cJunk,
      OUTPUT cJunk,
      OUTPUT iJunk).
        
    IF tIndex = otherIndex THEN DO:
      relExists = TRUE.
      LEAVE.
    END.
  END.

  IF relExists AND (leftText <> "" OR rightText <> "") THEN DO:
    /* Upgrade, and check on both sides */
    IF LENGTH(leftText,"CHARACTER":u) > 0 THEN DO:
 
      IF INDEX(ENTRY(qbf-i,qbf-rel-buf.rels),":":u) > 0 THEN DO:
        RUN error_msg (baseTableName,otherTableName,leftText,
                       OUTPUT abortRead).
        RETURN.
      END.
      ELSE DO:
        ASSIGN
          upgradedRel  = TRUE
          qbf-rel-whr# = qbf-rel-whr# + 1
          .
        RUN find_where (qbf-rel-whr#).
        
        ASSIGN
          qbf-rel-whr.jwhere            = TRIM(leftText)
          ENTRY(qbf-i,qbf-rel-buf.rels) = ENTRY(qbf-i,qbf-rel-buf.rels)
                                        + ":":u + STRING(qbf-rel-whr#)
          .
      END.
    END.

    IF LENGTH(rightText,"CHARACTER":u) > 0 AND rightText <> "X":u THEN DO:
      /* Find the relationship */
      DO qbf-j = 2 TO NUM-ENTRIES(qbf-rel-buf2.rels):
        
        RUN breakJoinInfo(ENTRY(qbf-j, qbf-rel-buf2.rels),
          OUTPUT tIndex,
          OUTPUT cJunk,
          OUTPUT cJunk,
          OUTPUT iJunk).
        
        /* Upgrade */
        IF tIndex = baseIndex THEN DO:
          /*
          message
            "qbf-i" qbf-i skip
            "rels" qbf-rel-buf.rels skip(1)
            "qbf-j" qbf-j skip
            "rels2" qbf-rel-buf2.rels skip
            view-as alert-box. 
          */
 
          IF INDEX(ENTRY(qbf-j,qbf-rel-buf2.rels),":":u) > 0 THEN DO:
            RUN error_msg (baseTableName,otherTableName,rightText,
                           OUTPUT abortRead).
            RETURN.
          END.
          ELSE DO:
            qbf-rel-whr# = qbf-rel-whr# + 1.
            RUN find_where (qbf-rel-whr#).
        
            ASSIGN
              qbf-rel-whr.jwhere             = TRIM(rightText)
              ENTRY(qbf-j,qbf-rel-buf2.rels) = ENTRY(qbf-j,qbf-rel-buf2.rels)
                                             + ":":u + STRING(qbf-rel-whr#)
              .
            LEAVE.
          END.
        END.
      END.
    END.
  END.

  IF upgradedRel = FALSE AND relExists = FALSE THEN DO:
    /* The relationship doesn't exist. Create it. */
    qbf-rel-buf.rels = qbf-rel-buf.rels + ",":u + relationType 
                     + STRING(otherIndex).

    IF leftText <> "" THEN DO:
      DO:
        qbf-rel-whr# = qbf-rel-whr# + 1.
        RUN find_where (qbf-rel-whr#).
          
        ASSIGN
          qbf-rel-whr.jwhere      = TRIM(leftText)
          qbf-rel-buf.rels        = qbf-rel-buf.rels + ":":u 
                                  + STRING(qbf-rel-whr#)
          .
      END.
    END.

    /* If the other relationship exist then create it */
    IF rightText <> "X" THEN DO:

      /* Switch the relationship */
      qbf-rel-buf2.rels = qbf-rel-buf2.rels + ",":u
                        + SUBSTRING("=><*?":u, 
                                    INDEX({&joinTypeSymbolString},relationType),
                                    1,"CHARACTER":u)
                        + STRING(baseIndex).

      IF rightText <> "" THEN DO:
        DO:
          qbf-rel-whr# = qbf-rel-whr# + 1.
          RUN find_where (qbf-rel-whr#).
          
          ASSIGN
            qbf-rel-whr.jwhere      = TRIM(rightText)
            qbf-rel-buf2.rels       = qbf-rel-buf2.rels + ":":u
                                    + STRING(qbf-rel-whr#)
            .
        END.
      END.
    END.
  END.
END.							  

/*
 * This is a duplicate of the code found in _jbkjoin.i. It has to be
 * duplicated to avoid having that .i having to be shipped to
 * customers. If _jbkjoin.i changes then this version must change too.
 *
 * _jbkjoin
 *
 *    An internal procedure (for performance) that breaks apart
 *    the join information
 */
&GLOBAL-DEFINE defaultJoinType "     "

/*------------------------------------------------------------------------*/
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
    joinTypeShort = "?":u
    thisJoin      = SUBSTRING(joinElement,2,-1,"CHARACTER":u)
    colonLoc      = INDEX(thisJoin,":":u)
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

/*------------------------------------------------------------------------*/
PROCEDURE find_where:
  DEFINE INPUT PARAMETER ix AS INTEGER NO-UNDO.

  {&FIND_WHERE_BY_ID} ix NO-ERROR.
  IF NOT AVAILABLE qbf-rel-whr THEN DO:
    CREATE qbf-rel-whr.
    qbf-rel-whr.wid = ix.
  END.
END PROCEDURE.

/*--------------------------------------------------------------------------*/

/* Display error msg */
PROCEDURE error_msg:
  DEFINE INPUT  PARAMETER table1    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER table2    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER relText   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER abortRead AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE lJunk        AS LOGICAL   NO-UNDO INITIAL TRUE. /* scrap */

  /*
  /* Write out to .ql file */
  OUTPUT TO VALUE(qbf-qcfile + ".ql":u) NO-ECHO APPEND.
  PUT UNFORMATTED
    "** ":u + "Configuration read error" + " - ":u + qbf-qcfile + CHR(10)
    + "   ":u + "Duplicate relationship" + ": ":u + relText 
    SKIP FILL("-":u,76) SKIP.
  OUTPUT CLOSE.
  */

  RUN adecomm/_s-alert.p (INPUT-OUTPUT lJunk, "warning":u, "yes-no":u,
    SUBSTITUTE("A duplicate relationship was found for &1 and &2:^^&3^^Do you want to continue?",
    table1,table2,relText)).

  IF NOT lJunk THEN DO:
    abortRead = TRUE.
    RETURN.
  END.
END PROCEDURE.

/* af-rship.i - end of file */

