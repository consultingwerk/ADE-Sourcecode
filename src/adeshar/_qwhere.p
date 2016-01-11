/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

  File: _qwhere.p

  Description: 
   This code will bring up the dialog box frame that allows the developer
   to define the WHERE clauses for files and their query relationships used 
   in a browse.

  Input Parameters:
    cLabel - 
    cGuess - 

  Output Parameters:
      <none>

  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

-----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/tt-brws.i }
{ adeshar/quryshar.i }
{ adeshar/qurydefs.i } 
{ adecomm/cbvar.i }
{ adecomm/adeintl.i }

DEFINE INPUT PARAMETER cLabel      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER cGuess      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER application AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER res_calcfld AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER cField      AS CHARACTER NO-UNDO.

DO WITH FRAME dialog-1:

  DEFINE VARIABLE c4glCode      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFormat       AS CHARACTER NO-UNDO. /* format */
  DEFINE VARIABLE cSave         AS CHARACTER NO-UNDO. /* format */
  DEFINE VARIABLE iDataType     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lInclusiveVar AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE l-scrap       AS LOGICAL   NO-UNDO.

  FIND LAST ttWhere WHERE INTEGER(rsMain:SCREEN-VALUE) = ttWhere.iState 
    AND lLeft:SCREEN-VALUE = ttWhere.cTable.

  ASSIGN i = ttWhere.iSeq.

  CREATE ttWhere.
  ASSIGN
    tAskRun
    cValue                 = "" 
    c4glCode               = (IF (TRIM(eDisplayCode:SCREEN-VALUE) <> ?
                              AND TRIM(eDisplayCode:SCREEN-VALUE) > "") THEN 
                                  TRIM(eDisplayCode:SCREEN-VALUE) ELSE "") 
    ttWhere.iState         = INTEGER(rsMain:SCREEN-VALUE)
    ttWhere.cTable         = lLeft:SCREEN-VALUE 
    ttWhere.iSeq           = i + 1
    ttWhere.lWhState       = lWhState
    bUndo:SENSITIVE        = TRUE
    bCheckSyntax:SENSITIVE = TRUE
    .

  cLastField = (IF cGuess = ? THEN cLastField ELSE cGuess). 
  IF (cLastField = "" OR cLastField = ?) AND NOT res_calcfld THEN
    cLastField = lLeft:SCREEN-VALUE + "." + {&CurLeft}:SCREEN-VALUE.

  ASSIGN
    cGuess     = cLastField
    cLastField = IF res_calcfld THEN cLastField
                 ELSE lLeft:SCREEN-VALUE + ".":u + {&CurLeft}:SCREEN-VALUE
    cLastField = (IF cLastField = ? THEN cGuess ELSE cLastField)
    .

  DO i = 1 TO EXTENT(acWhereState):
    IF cLabel = ENTRY (2, REPLACE(acWhereState[i], "~&", "")) THEN LEAVE.
  END.

  IF i > EXTENT(acWhereState) THEN RETURN.

  cSave = cLastField.
  IF (_AliasList > "") AND NOT res_calcfld THEN DO:
    IF (NUM-ENTRIES (cLastField, ".") < 3) THEN
      ENTRY(1, cLastField, ".") = _AliasList.
    ELSE
      ENTRY(2, cLastField, ".") = 
        ENTRY(NUM-ENTRIES(_AliasList, "."), _AliasList, ".").
  END.

  IF res_calcfld THEN DO:
    RUN aderes/_calctyp.p (cLastField,OUTPUT cDataType,OUTPUT cFormat).
    iDataType = INTEGER(cDataType).
  END.
  ELSE DO:
    IF (NUM-ENTRIES (cLastField, ".") < 3) THEN 
      RUN adecomm/_y-schem.p (cCurrentDb + "." + cLastField,"","",
                              OUTPUT cGuess).
    ELSE DO:
      cTemp = cLastField.
      IF ENTRY(1,cLastField,".":U) = "Temp-Tables":U THEN DO:
        FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cLastField,".":U).
        cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                ENTRY(3,cLastField,".").
      END.
      ELSE DO: /* Probably a buffer */
        FIND FIRST _tt-tbl WHERE
             _tt-tbl.tt-name = ENTRY(1,cLastField,".":U) NO-ERROR.
        IF AVAILABLE _tt-tbl THEN 
          cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                  ENTRY(2,cLastField,".").          
      END.  /* Probably a buffer */
      RUN adecomm/_y-schem.p (cTemp,"","",OUTPUT cGuess).
    END.

    ASSIGN
      iDataType  = INTEGER(ENTRY(1,cGuess))
      cFormat    = ENTRY(2,cGuess,CHR(10)).
  END.

  ASSIGN
    tAskRun 
    cLastField = cSave.
    
  CASE (IF NOT tAskRun THEN 
    SUBSTRING(ENTRY(1,acWhereState[i]),1,1,"CHARACTER":u) ELSE "!":u):
    
    WHEN "o":u THEN /* get one value of any type */
      CASE iDataType:
        WHEN 1 THEN RUN adecomm/_y-strng.p
          (1,cFormat,?,OUTPUT cValue,OUTPUT lInclusiveVar).
        WHEN 2 THEN RUN adecomm/_y-date.p   
          (1,cFormat,?,OUTPUT cValue,OUTPUT lInclusiveVar).
        WHEN 34 THEN RUN adecomm/_y-datetime.p   
          (1,cFormat,?,OUTPUT cValue,OUTPUT lInclusiveVar).
        WHEN 40 THEN RUN adecomm/_y-datetime-tz.p   
          (1,cFormat,?,OUTPUT cValue,OUTPUT lInclusiveVar).
        WHEN 3 THEN RUN adecomm/_y-logic.p
          (1,cFormat,?,OUTPUT cValue). 
        WHEN 4 OR WHEN 5
               THEN RUN adecomm/_y-num.p
          (1,cFormat,?,OUTPUT cValue,OUTPUT lInclusiveVar).
      END CASE.
      
    WHEN "u":u THEN /* get one unformatted string value */
      RUN adecomm/_y-strng.p
        (1,"x(":u + STRING(LENGTH(STRING("",cFormat),"CHARACTER":u)) + ")":u,
         ?,OUTPUT cValue,OUTPUT lInclusiveVar).
         
    WHEN "q":u THEN /* get qbw string */
      RUN adecomm/_y-qbw.p (1,?,?,OUTPUT cValue).
      
    WHEN "r":u THEN DO: /* get upper & lower range for anything but logical */
      CASE iDataType:
        WHEN 1 THEN RUN "adecomm/_y-strng.p"  
          (2, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 2 THEN RUN "adecomm/_y-date.p"    
          (2, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 34 THEN RUN "adecomm/_y-datetime.p"    
          (2, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 40 THEN RUN "adecomm/_y-datetime-tz.p"    
          (2, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 4 OR WHEN 5
               THEN RUN "adecomm/_y-num.p"  
          (2, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
      END CASE.
    END.
    
    WHEN "m":u THEN DO: /* get list of values for anything but logical */
      CASE iDataType:
        WHEN 1 THEN RUN "adecomm/_y-strng.p"  
          (3, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 2 THEN RUN "adecomm/_y-date.p"    
          (3, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 34 THEN RUN "adecomm/_y-datetime.p"    
          (3, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 40 THEN RUN "adecomm/_y-datetime-tz.p"    
          (3, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
        WHEN 4 OR WHEN 5
               THEN RUN "adecomm/_y-num.p"  
          (3, cFormat, ?, OUTPUT cValue, OUTPUT lInclusiveVar).
      END CASE. 
    END.
  END CASE.

  IF cValue NE ? THEN DO:  /* Cancel was not pressed */ 
    cOperator = ENTRY(2, REPLACE(acWhereState[i], "~&", "")).

    IF LOOKUP(cOperator,"AND,OR":u) > 0 AND bEqual:SENSITIVE = FALSE THEN
      lWhState = TRUE.  /* We are at the end of a where clause */
    
    IF (cField <> "" AND cField <> ? and NOT tAskRun AND
        NOT CAN-DO("AND,OR":U,cOperator)) THEN 
      ASSIGN
        lPasted  = TRUE
        c4glCode = c4glCode + (IF c4glCode NE "":U AND
                                  NOT c4glCode MATCHES "* ":u
                                THEN " ":U ELSE "":U) + cLastField.

    IF tAskRun AND NOT lWhState THEN DO: 
      RUN adecomm/_y-strng.p 
        (5, "x(72)":u, "Enter the question to ask at run time:":u, 
        OUTPUT cGuess, OUTPUT lInclusiveVar).
      IF cGuess = ? THEN RETURN.

      /* strip last line from eDisplayCode if field was pasted - dma */
      IF lPasted THEN
        c4glCode = SUBSTRING(c4glCode,1,R-INDEX(c4glCode,CHR(10)),"CHARACTER":u).

      cValue = ' /*':u
             + ENTRY(iDataType,"CHARACTER,DATE,LOGICAL,INTEGER,DECIMAL":u)
             + ',':u
             + cLastField
             + ',':u
             + CAPS(cOperator)
             + ',:':u
             + SUBSTRING(cGuess,2,LENGTH(cGuess,"CHARACTER":u) - 2,"CHARACTER":u)
             + '*/ TRUE':u.
      lWhState = TRUE.
    END.

    CASE (IF NOT tAskRun OR LOOKUP(cOperator,"AND,OR":u) > 0
      THEN cOperator ELSE "!"):
    
      WHEN    "=":u OR WHEN "<>":u
      OR WHEN "<":u OR WHEN "<=":u
      OR WHEN ">":u OR WHEN ">=":u
      OR WHEN "BEGINS":u
      OR WHEN "MATCHES":u
      OR WHEN "AND":u
      OR WHEN "OR":u
      OR WHEN "CONTAINS":u THEN
        ASSIGN c4glCode = c4glCode + (IF CAN-DO("AND,OR":U,cOperator)
                                 THEN CHR(10) + " ":U ELSE " ":U) +
                               CAPS(cOperator) + " ":u + 
                              (IF cValue NE ? THEN cValue ELSE "")
               lWhState = FALSE.
    
      WHEN "LIKE":u THEN DO:
        IF cGuess = ? THEN
          ASSIGN
            cValue = REPLACE(cValue,"*":u,"~~*":u)
            cValue = REPLACE(cValue,".":u,"~~.":u)
            cValue = REPLACE(cValue,"%":u,"*":u)
            cValue = REPLACE(cValue,"_":u,".":u).
        c4glCode = c4glCode + " MATCHES ":u + cValue.
      END.
    
      WHEN "X-MATCHES":u THEN DO:  /** CONTAINS (QBF) ***/
        IF cGuess = ? THEN
          cValue = '"*':u 
                 + SUBSTRING(cValue,2,LENGTH(cValue,"CHARACTER":u) - 2,
                             "CHARACTER":u) 
                 + '*"':u.
        c4glCode = c4glCode + ' MATCHES ':u + cValue.
      END.
    
      WHEN "RANGE":u THEN
        IF (lInclusiveVar) THEN
          RUN insert_range (iDataType, "=":u, INPUT-OUTPUT c4glCode).
        ELSE
          RUN insert_range (iDataType, "":u, INPUT-OUTPUT c4glCode).
        
      WHEN "LIST":u THEN
        IF (lInclusiveVar) THEN
          RUN insert_list (iDataType, "=":u, INPUT-OUTPUT c4glCode).
        ELSE
          RUN insert_list (iDataType, "<>":u, INPUT-OUTPUT c4glCode).
        
      OTHERWISE /* tAskRun selected or cancel was pressed */
        c4glCode = c4glCode + (IF cValue NE ? THEN cValue ELSE "").
    END CASE.

    ASSIGN
      c4glCode                   = (IF c4glCode <> ? THEN c4glCode ELSE "") 
      eDisplayCode:SCREEN-VALUE  = c4glCode
      eDisplayCode:CURSOR-OFFSET = LENGTH(c4glCode,"RAW":u) + 1
      ttWhere.cExpression        = c4glCode
      ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
      ttWhere.lOperator          = TRUE
      ttWhere.lWhState           = lWhState
      eCurrentTable:SENSITIVE    = FALSE
      {&CurLeft}:SENSITIVE       = FALSE
      {&CurRight}:SENSITIVE      = TRUE
      acWhere[LOOKUP({&CurTable},eCurrentTable:LIST-ITEMS,
         {&Sep1}) + iXternalCnt] = ttWhere.cExpression
      .

    RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,FALSE).
    RUN adeshar/_qset.p ("SetJoinOperatorsSensitive.ip",application,FALSE).
    IF CValue = "" AND CAN-DO("AND,OR",cOperator) THEN
      ASSIGN eCurrentTable:SENSITIVE = FALSE
             {&CurLeft}:SENSITIVE    = TRUE
             bAnd:SENSITIVE          = FALSE
             bOr:SENSITIVE           = FALSE.
    ELSE IF eCurrentTable:NUM-ITEMS > 1 THEN eCurrentTable:SENSITIVE = TRUE.
    IF bAND:SENSITIVE AND NOT lWhState THEN APPLY "ENTRY" TO bAND.
  END.  /* If didn't cancel out of the y-const */
  ELSE IF eDisplayCode:SCREEN-VALUE = "":U THEN bUNDO:SENSITIVE = FALSE.
END.

PROCEDURE insert_range:
  DEFINE INPUT        PARAMETER i           AS INTEGER   NO-UNDO. /* NOT USED */
  DEFINE INPUT        PARAMETER cExpression AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER c4glCode    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE               cTemp AS CHARACTER NO-UNDO. /* scrap */

  cTemp = cValue.

  IF SUBSTRING(c4glCode,LENGTH(c4glCode,"CHARACTER":u) 
    - LENGTH(cLastField,"CHARACTER":u) + 1,-1,"CHARACTER":u) = cLastField THEN
    c4glCode = SUBSTRING(c4glCode,1,LENGTH(c4glCode,"CHARACTER":u) 
                         - LENGTH(cLastField,"CHARACTER":u),"CHARACTER":u)
             + "(":u
             + cLastField + " >":u + cExpression + " ":u 
             + ENTRY(1,cTemp,CHR(10))
             + " AND ":u
             + cLastField + " <":u + cExpression + " ":u 
             + ENTRY(2,cTemp,CHR(10))
             + ")":u.
  ELSE
    c4glCode = c4glCode + " ":u
          + cLastField + " >":u + cExpression + " ":u + ENTRY(1,cTemp,CHR(10))
          + " AND ":u
          + cLastField + " <":u + cExpression + " ":u + ENTRY(2,cTemp,CHR(10)).
END PROCEDURE. /* insert_range */

/* ---------------------------------------------------------------------*/
/*
Appends "(x _ v1 ___ x _ v2)", where "_" is "=" for in-list and "<>"
for not-in-list and "___" is "OR" for in-list and "AND" for
not-in-list.  If can't match field name as last token in qbf_4, omits
parens and produces "x _ v1 ___ x _ v2" instead.
*/

PROCEDURE insert_list:
  DEFINE INPUT        PARAMETER i AS INTEGER   NO-UNDO. /* NOT USED GJO */
  DEFINE INPUT        PARAMETER cOperator AS CHARACTER NO-UNDO. /* = or <> */
  DEFINE INPUT-OUTPUT PARAMETER c4glClode AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO. /* scrap */

  cTemp = cValue.

  /* from [a,b,c] */
  /*       !^!^!  */
  /*   to [ = a or n = b or n = c] */
  /*       ---!^^^^^^^^!^^^^^^^^!  */

  cTemp = ' ':u + CAPS(cOperator) + ' ':u
        + REPLACE(
            cTemp,
            CHR(10),
            CHR(10) + (IF cOperator = "=":u THEN "  OR ":u ELSE "  AND ":u)
            + cLastField + " ":u + CAPS(cOperator) + " ":u
          ).

  IF SUBSTRING(c4glClode,LENGTH(c4glClode,"CHARACTER":u) 
               - LENGTH(cLastField,"CHARACTER":u) + 1,-1,"CHARACTER":u) = 
    cLastField THEN
    c4glClode = SUBSTRING(c4glClode,1,LENGTH(c4glClode,"CHARACTER":u) 
                          - LENGTH(cLastField,"CHARACTER":u),"CHARACTER":u)
              + "(":u + cLastField + cTemp + ")":u.
  ELSE
    c4glClode = c4glClode + " ":u + cTemp.
END PROCEDURE. /* insert_list */

/* _qwhere.p - end of file */

