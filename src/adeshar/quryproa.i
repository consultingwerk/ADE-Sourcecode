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
/*----------------------------------------------------------------------------

  File: quryproa.i

  Description: 
   This is the include file containing all of the internal procedures
   from a through d called by the Query Builder.

  Input Parameters: N/A

  Output Parameters: N/A
      <none>

  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

  Modified:
    04/06/99    tsp     Added support for various Intl Numeric Formats (in
                        addition to American and European) by using 
                        session set-numeric-format to set numeric format
                        back to user's setting after setting it to American in
                        CheckSyntax.ip

    11.20.00 achlensk   fixed BUG# 20000604-004
    Jul 1 02    tsp     Fixed Issue 4839

  ---------------------------------------------------------------------------*/

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE BuildQuery.ip:
  DEFINE OUTPUT PARAMETER cQuery   AS CHARACTER NO-UNDO.  

  DEFINE VARIABLE sort_phrase AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE in_UIB      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cTblList    AS CHARACTER NO-UNDO.  

  /* Set the sort phrase */
  RUN DisplaySort.ip (TRUE, 4, INPUT-OUTPUT sort_phrase). 

  /* Adjust some behavior based on the application type. */
  CASE application:
    WHEN "Results_Join"      THEN _TblOptList = "".  
    WHEN "{&UIB_SHORT_NAME}" THEN in_UIB = YES.
  END CASE.

  /* This is a AB wrapper for the adeshar/qbuild.i. Note that the AB
     will use this in a PREPROCESSOR. */

ASSIGN cTblList = REPLACE({&TableRight}:LIST-ITEMS, 'TEMP-TABLES.', '').

  DO WITH FRAME dialog-1:
    { adeshar/qbuild.i 
        &4GLQury     = "cQuery"
        &TblList     = cTblList
        &JoinCode    = "acJoin"
        &Where       = "acWhere"
        &SortBy      = "sort_phrase"
        &use_dbname  = "(NOT suppress_dbname)"
        &OptionList  = "_OptionList"
        &TblOptList  = "_TblOptList" 
        &ExtTbls     = "iXternalCnt"    
        &Preprocess  = "in_UIB"
        &Mode        = "FALSE"
        }

  END.
  
  /* If there is any query, then add a "FOR...:" wrapper and continue */
  IF cQuery ne "" THEN cQuery =  "FOR ":U + cQuery + ":":U.
END.  

/* -----------------------------------------------------------
  Purpose:     Recreate the _OptionList based on new values.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE BuildOptionList.ip:
  _OptionList = CAPS (cShareType:SCREEN-VALUE IN FRAME dialog-1)
                 + (IF tIndexReposition THEN " INDEXED-REPOSITION" ELSE "") 
                 + (IF tKeyPhrase THEN " KEY-PHRASE" ELSE "")
                 + (IF tSortByPhrase THEN " SORTBY-PHRASE" ELSE "") .
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE CheckSelect.ip:
  DEFINE OUTPUT PARAMETER iTblNum AS INTEGER NO-UNDO. 

  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  
  DO WITH FRAME DIALOG-1:  
    /*
    ** Re-written by R Ryan 7/94: checks to see if the screen-value tables
    ** or fields are part of the list-items.  If not, then returns 0 and
    ** nothing is removed.  This didn't work before when a user used the
    ** CTRL click to choose discontigious entries.
    **
    ** Note: This procedure shouldn't even fire off if we coded the remove
    ** button/dbl click event right - but you never know.
    */     
    IF {&CurRight}:SCREEN-VALUE <> ? THEN
    DO ix = 1 TO NUM-ENTRIES({&CurRight}:SCREEN-VALUE,{&Sep1}):  
      iTblNum = LOOKUP(ENTRY(ix,{&CurRight}:SCREEN-VALUE,{&Sep1}), 
                                {&CurRight}:LIST-ITEMS,{&Sep1}).
      IF iTblNum = 0 THEN DO:
        IF {&Table-Mode} THEN
          MESSAGE "Select a table(s)." 
            VIEW-AS ALERT-BOX WARNING.
        ELSE
          MESSAGE "Select a field(s)." 
            VIEW-AS ALERT-BOX WARNING.
        LEAVE.
      END.
    END.
  END.  
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
/* This routine will remove an entry from the available list, and place
** it at the end of the selected list.
*/
PROCEDURE addTable.ip:  
  /* name we are looking for.  This may be just a table name or db.table */
  DEFINE INPUT PARAMETER p_InName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cnt           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE v_DBname      AS CHARACTER NO-UNDO.  /* just the DB name */
  DEFINE VARIABLE v_Tblname     AS CHARACTER NO-UNDO.  /* just the table name */
  DEFINE VARIABLE v_CurrentName AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE lConstant     AS LOGICAL   NO-UNDO.    
  DEFINE VARIABLE v_DBmsg1      AS CHARACTER NO-UNDO.   
  DEFINE VARIABLE CR            AS CHARACTER NO-UNDO.   

  /* v_CurrentName is the tbl name as it is refered to in this session.
     If only one db is connected, it will be just a table name, else it
     will be a db.table name.                                           */

  DO WITH FRAME dialog-1:

    iTableNum = NUM-ENTRIES({&CurRight}:LIST-ITEMS, {&Sep1}) + 1.

    IF iTableNum = ? THEN iTableNum = 1. 
    ASSIGN rDbId[iTableNum]    = ?
           rTableId[iTableNum] = ?.

    IF NUM-ENTRIES (p_InName, ".") = 1  THEN
      p_InName = {&CurTable} + "." + p_InName.

    /* First find the ids for the table and the database */
    IF NUM-ENTRIES(p_InName, ".") = 2 THEN DO:
      ASSIGN v_DBName   = ENTRY(1,p_InName,".")
             v_TblName  = ENTRY(2,p_InName,".").

      /* See if this is a temp-table or a buffer */
      FIND _tt-tbl WHERE _tt-tbl.tt-name = v_TblName NO-ERROR.
      IF AVAILABLE _tt-tbl THEN rTableId[iTableNum] = RECID(_tt-tbl).
      ELSE DO:
        RUN adecomm/_getdbid.p (v_dbname, OUTPUT rDbId[iTableNum]).

        IF rDbId[iTableNum] NE ? THEN 
          RUN adecomm/_gttblid.p (rDbId[iTableNum], v_TblName, 
                                  OUTPUT rTableId[iTableNum]).

        /* if I could not find the db/table id, I will try with just the tblname */
        IF rTableId[iTableNum] = ? THEN p_InName = v_TblName.
      END.  /* If Not Temp-Tables psuedo db */
    END.  /* If qualified with db name */

    /* if they did not store name, or we could not find it, look for tbl */
    IF rTableId[iTableNum] = ? THEN DO:
      lLogical = YES.
      RUN adecomm/_s-alert.p (INPUT-OUTPUT lLogical, "w", "ok",
        SUBSTITUTE("Table &1 was not found in connected database(s).",p_InName)).
    END.  /* If rTableId = ? */

    /* now remove this entry from the avail list and add it to picked */
    ASSIGN v_CurrentName      = v_TblName
           cSchema[iTableNum] = IF NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = v_TblName)
                                THEN (IF rTableId[iTableNum] NE ? THEN LDBNAME("DICTDB") ELSE ?)
                                ELSE "Temp-Tables":U.

    IF (NUM-ENTRIES (eCurrentTable:LIST-ITEMS, {&Sep1}) > 1) OR
       /* We always need to qualify with db name when
        * using the "Temp-Tables" pseudo db (tomn 1/6/2000)
        */
       (v_DBName = "Temp-Tables":U) THEN
      v_CurrentName = v_DBName + "." + v_CurrentName.
    IF v_CurrentName BEGINS "Temp-Tables":U THEN DO: /* If Buffer strip Temp-Tables */
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,v_CurrentName,".":U).
      IF _tt-tbl.table-type = "B":U THEN v_CurrentName = v_TblName.
    END.
    IF {&Table-Mode} THEN DO:
      lOK = ?.

      /* Do we try to join from the Top of from the bottom. Up to 7.3A, we
         joined from the botton up (NUM-ENTRIES..TO 1 BY -1).  Changed 
         to top down (1 TO NUM-ENTRIES...) [wood 1/25/94] */
      FIND-JOIN-BLOCK:
      DO i = 1 TO NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) :
        ASSIGN cFieldName = v_CurrentName
               cTemp = ENTRY (1, ENTRY (i, {&CurRight}:LIST-ITEMS, {&Sep1}), " "). 
        IF NUM-ENTRIES(cTemp,".":U) = 1 THEN DO:   /* May be a buffer */
          FIND _tt-tbl WHERE _tt-tbl.tt-name = cTemp AND _tt-tbl.table-type = "B":U NO-ERROR.
          IF AVAILABLE _tt-tbl THEN cTemp = "Temp-Tables." + cTemp.
        END.  /* IF NUM-ENTRIES */
        RUN IsJoinable.ip (cFieldName, cTemp, OUTPUT lOk).  
        IF (lOK) THEN LEAVE FIND-JOIN-BLOCK.
      END.  /* DO i = 1 to Num-Entries */
      IF lOk THEN
        cTemp = ENTRY (1, ENTRY (i, {&CurRight}:LIST-ITEMS, {&Sep1}), " ").
      ELSE IF NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) = 1 THEN 
        cTemp = ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}).             
      ELSE IF NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) > 1 THEN DO:
        RUN pickTable.ip ({&CurRight}:PRIVATE-DATA, INPUT-OUTPUT cTemp). 
        IF (cTemp = ?) THEN RETURN.
      END.
      {&CurRight}:PRIVATE-DATA = (IF {&CurRight}:PRIVATE-DATA = ? THEN "" ELSE 
                                 {&CurRight}:PRIVATE-DATA + {&Sep1}) +  
                                 v_CurrentName.

      v_CurrentName = IF lOk = ? THEN  v_CurrentName
                      ELSE IF lOk THEN v_CurrentName + " OF "	+ cTemp
                      ELSE v_CurrentName + " WHERE " + cTemp + " ..." .
      lOk = {&CurRight}:ADD-LAST (v_CurrentName).
    END.  /* IF &Table-Mode */
    ELSE lOk = {&CurRight}:ADD-LAST (v_CurrentName).

    /* If there are options defined for the query, create an _qo record for the 
       new table because there are places in qurytrig.i where _TblOptList is set 
       based on _qo records. */
    DEFINE BUFFER b_qo FOR _qo.
    IF NUM-ENTRIES({&CurRight}:LIST-ITEMS, {&Sep1}) > NUM-ENTRIES(_TblOptList) AND
       _TblOptList NE "" THEN 
    DO:
      _TblOptList = _TblOptList + ",":U.
      FIND LAST b_qo NO-ERROR.
      IF AVAILABLE b_qo THEN
      DO:
        CREATE _qo.
        ASSIGN
          _qo._seq-no = b_qo._seq-no + 1
          _qo._tbl-name = ENTRY(NUM-ENTRIES({&CurRight}:LIST-ITEMS, {&Sep1}), {&CurRight}:LIST-ITEMS, {&Sep1})
          _qo._find-type = 'EACH':U
          _qo._flds-returned = 'All Fields':U
          _qo._join-type = 'INNER':U.
      END.  /* if b_qo available */
    END.  /* if number of tables is greater than number of tables in options list */

    IF v_CurrentName BEGINS "Temp-Tables":U AND
      NUM-ENTRIES(v_TblName, ".":U) = 1 THEN DO:  /* Quailify with Temp-Tables if not Buffer */
      FIND FIRST _tt-tbl WHERE _tt-tbl.tt-name = v_TblName.
      IF _tt-tbl.table-type = "T":U THEN
        v_TblName = "Temp-Tables.":U + v_TblName.
    END.

    RUN adecomm/_delitem.p ({&CurLeft}:HANDLE, v_TblName, OUTPUT cnt). 

    /*  
    message 'addtable' skip
      {&CurRight}:PRIVATE-DATA skip
      whRight[{&table}]:PRIVATE-DATA skip
      {&CurTable}
      view-as alert-box error buttons OK.
    */  

    DO j = {&Sort} TO {&Options}:
      IF ((NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) > 1) AND 
        NUM-ENTRIES (whRight [j]:LIST-ITEMS, ".") = 1) THEN DO:
        cTemp = whRight [j]:LIST-ITEMS.

        DO i = 1 to NUM-ENTRIES (cTemp, {&Sep1}):
          ASSIGN ENTRY(i,cTemp,{&Sep1}) = ENTRY(1,{&CurRight}:LIST-ITEMS, 
                                               {&Sep1}) + "." +
                                          ENTRY (i, cTemp, {&Sep1})
                 ENTRY(i,cMoreData [j],{&Sep1}) = 
                                          ENTRY(1,{&CurRight}:LIST-ITEMS,{&Sep1}) +
                                          "." + ENTRY (i, cMoreData [j], {&Sep1}).
        END. /* DO i = 1 to Num-Entries */
        whRight [j]:LIST-ITEMS = cTemp.
      END.  /* If RightSide has only tables (not qualified) */
    END.  /* DO j = Sort to Options */

    /* Create the Where Undo Temp Table.  */
    DO j = {&Join} TO {&Where}:
      CREATE ttWhere.
      VALIDATE ttWhere.   /* These validates are necessary to force the write  */
      ASSIGN ttWhere.iState      = j
             ttWhere.cTable      = ENTRY (1, v_CurrentName, " ") 
             ttWhere.iSeq        = 0
             ttWhere.iOffset     = 1
             ttWhere.cExpression = ""   /*** THIS MIGHT HAVE TO BE INITTED LATER ****/
             ttWHere.lOperator   = TRUE
             ttWhere.lWhState    = lWhState.
      /*
      message
        'ttWhere.iState     [' ttWhere.iState      ']' skip
        'ttWhere.cTable     [' ttWhere.cTable      ']' skip
        'ttWhere.iSeq       [' ttWhere.iSeq        ']' skip
        'ttWhere.cExpression[' ttWhere.cExpression ']' skip
        view-as alert-box error buttons Ok.
      */
    END. /* Do j = join to where */

    RUN BuildQuery.ip (OUTPUT eDisplayCode). 

    ASSIGN eDisplayCode:SCREEN-VALUE = eDisplayCode
           bCheckSyntax:SENSITIVE    = (IF eDisplayCode <> "" THEN TRUE ELSE FALSE).

    RUN RadioSetEnable.ip.
    RUN EvaluateIndexReposition.ip.     
  END.  /* DO WITH FRAME dialog-1 */
END.  /* addtable.ip */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE DB_Field.ip:
  DEFINE INPUT  PARAMETER cList   AS CHARACTER.
  DEFINE INPUT  PARAMETER cType   AS CHARACTER.
  DEFINE OUTPUT PARAMETER cOutput AS CHARACTER.

  RUN DB_LongField.ip (cList, cType, OUTPUT cCurrentDB, OUTPUT cTableName,
                       OUTPUT cFieldName, OUTPUT cOutput).

END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE DB_LongField.ip:
DEFINE INPUT   PARAMETER cList       AS CHARACTER.
DEFINE INPUT   PARAMETER cType       AS CHARACTER.
DEFINE OUTPUT  PARAMETER cDataBase   AS CHARACTER.
DEFINE OUTPUT  PARAMETER cTableName  AS CHARACTER.
DEFINE OUTPUT  PARAMETER cFieldName  AS CHARACTER.
DEFINE OUTPUT  PARAMETER cOutput     AS CHARACTER.

DO WITH FRAME dialog-1:
  IF (INDEX(cList,"(":U) > 0) OR (cList = ?) OR 
    (NUM-ENTRIES (cList, {&Sep1}) <> 1) THEN RETURN.

  IF (NUM-ENTRIES (cList, ".") = 3 ) THEN
    cDataBase = ENTRY (1 , cList, ".").

  IF (NUM-ENTRIES (cList, ".") > 1) THEN
    ASSIGN
      cTableName = ENTRY (NUM-ENTRIES (cList, ".") - 1 , cList, ".")
      cFieldName = ENTRY (NUM-ENTRIES (cList, ".")     , cList, ".")
      .
  ELSE
    ASSIGN
      cFieldName = cList
      cTableName = {&CurTable}
      .
  IF (NUM-ENTRIES (cTableName, ".") > 1) THEN
    ASSIGN
      cDataBase = ENTRY (1, cTableName, ".")
      cTableName = ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".")
      .

  IF (cDataBase = "") THEN
    cDataBase = LDBNAME (1).

  IF (cType = "LABEL") THEN
    RUN adecomm/_s-schem.p (cDatabase, cTableName, cFieldName, 
                            "FIELD:LABEL", OUTPUT cOutput).
  ELSE
    RUN adecomm/_s-schem.p (cDataBase, cTableName, cFieldName, 
                            "FIELD:TYP&FMT", OUTPUT cOutput).
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE DefaultActionRight.ip:	     
  DO WITH FRAME dialog-1:      
    IF {&Join-Mode} THEN
      RUN join.ip (lRight:SCREEN-VALUE + "." + SELF:SCREEN-VALUE, FALSE).
    ELSE DO:
      IF {&Table-Mode} THEN DO:
        RUN tableremove.ip.
        RUN EvaluateIndexReposition.ip.
      END.
      ELSE 
        RUN rightremove.ip.      
    END.

    RUN adeshar/_qset.p ("setUpDown",application,TRUE).

    IF {&Options-Mode} THEN DO:
      RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).
      /* update sIndex for format validation */
      sIndex = {&CurRight}:SCREEN-VALUE. 
    END.

    {&CurLeft}:SCREEN-VALUE = "". 
    
    /*
    ** If every table was removed (usually by a zeleous QA tester), then reapply
    ** the tables from the eCurrentTable combobox.
    */
    IF {&CurLeft}:NUM-ITEMS = 0 THEN DO:  
      APPLY "VALUE-CHANGED" TO eCurrentTable.
      RETURN.
    END.
    
    /*
    ** This block works with ClearValueLeft and ClearValueRight and insures
    ** that if there are no more items in the right hand selection list that
    ** focus returns back to the left hand selection.
    */   
    IF {&CurRight}:NUM-ITEMS = 0 THEN DO:
      {&CurLeft}:SCREEN-VALUE = {&CurLeft}:ENTRY(1).
      APPLY "ENTRY" TO {&CurLeft}. 
    END.
    /* If sort-mode - set rsSortDirection sensitive properly */
    IF {&Sort-Mode} THEN DO:
      RUN CheckSelect.ip (OUTPUT i).
      rsSortDirection:SENSITIVE = i > 0.
    END.
  END. 
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE DefaultActionLeft.ip:	     
  DEFINE VARIABLE iSelectCount AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSelection   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArrayList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArrayEntry  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iArrayHigh   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iArrayLow    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iArrayNum    AS INTEGER   NO-UNDO.

  DO WITH FRAME dialog-1: 
  
  ASSIGN tAskRun. /* dma */
  IF {&CurLeft}:SCREEN-VALUE <> ? AND NOT tAskRun THEN DO:
    ASSIGN lPasted    = TRUE
           cSelection = {&CurLeft}:SCREEN-VALUE.

    IF application = "Results_Where":u AND {&Where-Mode} 
      AND {&CurLeft}:SCREEN-VALUE MATCHES "*(*)":u THEN 
      cSelection = SUBSTRING({&CurLeft}:SCREEN-VALUE,1,
                             INDEX({&CurLeft}:SCREEN-VALUE,"(":u) - 2,
                             "CHARACTER":u).

    DO iSelectCount = 1 TO NUM-ENTRIES (cSelection, {&Sep1}):
    
      /** WHERE building **/
      IF {&Where-Mode} THEN
        RUN LeftWhere.ip (FALSE).
        
      /** JOIN building **/
      ELSE IF {&Join-Mode} THEN
        RUN join.ip (lLeft:SCREEN-VALUE + "." + SELF:SCREEN-VALUE, FALSE).
        
      /** TABLE adding **/
      ELSE IF {&Table-Mode} THEN
        RUN addTable.ip (ENTRY (iSelectCount, cSelection, {&Sep1})).
        
      /** SORT adding **/
      ELSE DO:
        RUN adecomm/_delitem.p ({&CurLeft}:HANDLE, 
          ENTRY (iSelectCount, cSelection, {&Sep1}), OUTPUT i).
    	ASSIGN
          cTemp = IF INDEX(cSelection,"(":U) > 0 THEN 
                    cSelection /* Don't add any db.tbl to a calc field */
                  ELSE IF ((INTEGER (NUM-ENTRIES (whRight [{&Table}]:LIST-ITEMS,
                                                  {&Sep1})) > 1)
                  AND ({&DisFieldList} <> {&CurTable}))  THEN
                     {&CurTable} + "." + 
                     ENTRY (iSelectCount, cSelection, {&Sep1}) 
                  ELSE
                     ENTRY (iSelectCount, cSelection, {&Sep1}).  

        /* If it matches then it is an array thing. */
        IF cTemp MATCHES ("*[*]*") THEN DO:
	  ASSIGN
	    cTemp      = TRIM (cTemp)
  	    cArrayList = SUBSTRING(cTemp,INDEX(cTemp,'[') + 1,-1,"CHARACTER":u)
  	    cArrayList = REPLACE (cArrayList,"]","")
  	    cTemp      = SUBSTRING(cTemp,1,INDEX(cTemp,'[') - 1,"CHARACTER":u)
            .
	  /* Loop through the list base on  */
          DO i = 1 TO NUM-ENTRIES (cArrayList):
	    ASSIGN cArrayEntry = ENTRY (i, cArrayList)
                  iArrayLow   = INTEGER (ENTRY (1, cArrayEntry, '-'))
                  iArrayHigh  = INTEGER (ENTRY (NUM-ENTRIES (cArrayEntry, '-'), 
                                                             cArrayEntry, '-')).
            /* Loop through the list base on X-Y. X is the low number.
               Y is the high number.  */
            DO j = iArrayLow TO iArrayHigh:
	       ASSIGN cArrayEntry = cTemp + '[' + STRING (j) + ']'
                     lOk = {&CurRight}:ADD-LAST (cArrayEntry).
              IF {&Options-Mode} THEN 
                {&CurData} = {&CurData} 
                           + (IF ({&CurData} = "") THEN "" ELSE {&Sep1}) 
                           + cArrayEntry + {&sep2} + {&sep2}.
              ELSE IF {&Sort-Mode} THEN 
                {&CurData} = {&CurData} 
                           + (IF ({&CurData} = "") THEN "" ELSE {&Sep1}) 
                           + cArrayEntry + {&sep2} + 'yes'.
            END. /* J = Low TO High */
          END.  /* i = 1 TO NUM-ENTRIES */
        END.  /* IF cTemp is an array */

        ELSE DO:  /* Not an array */
          lOk = {&CurRight}:ADD-LAST (cTemp).

          IF {&Options-Mode} THEN 
	     {&CurData} = {&CurData} 
                        + (IF ({&CurData} = "") THEN "" ELSE {&Sep1})
                        + cTemp + {&sep2} + {&sep2}.
          ELSE IF {&Sort-Mode} THEN 
            {&CurData} = {&CurData} 
                       + (IF ({&CurData} = "") THEN "" ELSE {&Sep1})
                       + cTemp + {&sep2} + 'yes'.
        END.  /* Not an array */

        RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
 
        IF NOT tAskRun THEN /* dma */
          eDisplayCode:SCREEN-VALUE = eDisplayCode.
        RUN CheckSelect.ip (OUTPUT i).
        ASSIGN rsSortDirection:SENSITIVE = i > 0
               rsSortDirection:SCREEN-VALUE = "yes".
      END.  /* SORT adding */
    END. /* iSelectCount = 1 TO NUM-ENTRIES(cSelection) */
    
    ASSIGN
      tAskRun:SENSITIVE         = TRUE /* dma */
      bAdd:SENSITIVE            = ({&CurLeft}:LIST-ITEMS NE ?).
      
  END.  /*  IF {&CurLeft}:SCREEN-VALUE <> ? AND NOT tAskRun */

  {&CurRight}:SCREEN-VALUE = "".
  END.  /* Do with frame dialog-1 */
END.  /* DefaultActionLeft.ip */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE CheckDisplayWidth.ip:
  DEFINE OUTPUT PARAMETER lError AS LOGICAL INITIAL TRUE NO-UNDO.

  DEFINE VARIABLE FldNameList   AS CHARACTER EXTENT {&MaxTbl} NO-UNDO.
  DEFINE VARIABLE FldLabelList  AS CHARACTER EXTENT {&MaxTbl} NO-UNDO.
  DEFINE VARIABLE FldFormatList AS CHARACTER EXTENT {&MaxTbl} NO-UNDO.
  DEFINE VARIABLE i             AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE fmt           AS CHAR                       NO-UNDO.
  DEFINE VARIABLE fd-tp         AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE col-wdth      AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE tot-wdth      AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE lFmtError     AS LOGICAL                    NO-UNDO.
  DEFINE VARIABLE lbl           AS CHAR                       NO-UNDO.

  DO WITH FRAME dialog-1:
    ASSIGN
      lError = FALSE
      tot-wdth = 0.

    DO i = 1 TO NUM-ENTRIES ({&CurFieldData}, {&Sep1}):
      IF i > EXTENT (FldNameList) THEN DO:
        MESSAGE 'The Browse interface only supports up to 50 fields.' SKIP
                'Only the first 50 fields where saved.'.
        LEAVE.
      END.
      ELSE
        ASSIGN				 
    	  FldNameList[i]   = ENTRY(1,ENTRY(i,{&CurFieldData},{&Sep1}),{&Sep2})
	  FldLabelList[i]  = ENTRY(2,ENTRY(i,{&CurFieldData},{&Sep1}),{&Sep2})
	  FldFormatList[i] = ENTRY(3,ENTRY(i,{&CurFieldData},{&Sep1}),{&Sep2})
	  .
      IF ((NUM-ENTRIES(FldNameList  [i], ".") = 1) AND
        (NUM-ENTRIES({&TableRight}:LIST-ITEMS, {&Sep1}) = 1)) THEN
        FldNameList[i] = {&TableRight}:LIST-ITEMS + "." + FldNameList[i].
	
      IF (NUM-ENTRIES(FldNameList[i],".") = 2) THEN
        FldNameList[i] = lDBNAME(1) + "." + FldNameList[i].

      RUN adecomm/_s-schem.p (FldNameList[i],"","","FIELD:TYP&FMT",OUTPUT fmt).

      ASSIGN 
        fd-tp = INTEGER(ENTRY(1,fmt)) /* Fld Type 1-ch, 2-da, 3-lo, 4-int  */
        fmt   = SUBSTRING(fmt,3,-1,"CHARACTER":u). /* Format */

      IF FldFormatList[i] NE ? AND FldFormatList[i] NE "" THEN
        fmt = FldFormatList[i].
	  
      IF FldLabelList[i] NE ? AND FldLabelList[i] NE " " THEN
	lbl = FldLabelList[i].
      ELSE
        RUN adecomm/_s-schem.p (FldNameList[i], "", "", "FIELD:LABEL", 
                                OUTPUT lbl).

      IF NUM-ENTRIES(lbl,"!") > 1 THEN
        ASSIGN 
          lbl             = ENTRY(NUM-ENTRIES(lbl,"!"),lbl,"!")
	  FldLabelList[i] = lbl.
	
      RUN adecomm/_chkfmt.p (fd-tp, "", lbl, fmt, OUTPUT col-wdth, 
                             OUTPUT lFmtError ).
      IF (lFmtError) THEN
        fmt = FILL ("?", col-wdth).

      tot-wdth = tot-wdth + col-wdth.
	
      IF (tot-wdth > 310) THEN DO:
        MESSAGE 
          "The display width of the all the select fields exceeds 310." SKIP
          "The current display width is " tot-wdth "." SKIP
          "Please remove a field or fields."
          VIEW-AS ALERT-BOX WARNING.
	
        IF rsMain:SCREEN-VALUE <> "{&Options}" THEN DO:
          rsMain:SCREEN-VALUE = "{&Options}".
          APPLY "VALUE-CHANGED" TO rsMain.  
        END.

        lError = TRUE.
        RETURN.         
      END.
    END.
  END.
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE DisplaySort.ip:
  DEFINE INPUT        PARAMETER lAppend AS LOGICAL   NO-UNDO.
  DEFINE INPUT        PARAMETER iSpace  AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER cSort   AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cTemp  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cField AS CHARACTER NO-UNDO.

  /* Use a Phrase if necessary. (Use leading tilde in UIB). */
  IF tSortByPhrase THEN cSort = IF application eq "{&UIB_SHORT_NAME}" 
                                THEN "~~~{&SORTBY-PHRASE}"
                                ELSE "~{&SORTBY-PHRASE}".
  ELSE DO WITH FRAME dialog-1:     
    IF (rsMain:SCREEN-VALUE <> "{&Sort}" AND (NOT lAppend)) THEN RETURN.

    cTemp = "".
    DO i = 1 TO NUM-ENTRIES ({&CurSortData}, {&Sep1}):
      DO j = 2 TO (i + iSpace):
        cTemp = cTemp + " ".
      END.

      cField = ENTRY (1, ENTRY (i, {&CurSortData}, {&Sep1}), {&sep2}).

      IF INDEX(cField,"(":U) > 0 THEN 
        cField = trim(cField).
      ELSE IF (NUM-ENTRIES (cField, ".") = 1) THEN
        cField = ENTRY (1, {&TableRight}:LIST-ITEMS, {&Sep1}) + "." + cField.
      ELSE IF (NUM-ENTRIES (cField, ".") = 2) THEN
        cField = LDBNAME (1)  + "." + cField.

      cTemp  = cTemp + "BY " + cField + " " 
	     + (IF ENTRY(2,ENTRY(i,{&CurSortData},{&Sep1}),{&sep2}) = 'yes' 
                THEN "" ELSE "DESCENDING") 
             + {&EOL}.
    END.
    IF (lAppend) THEN
      cSort = cSort + cTemp.
    ELSE DO:
      cSort = cTemp.

      IF ({&CurRight}:SCREEN-VALUE <> ?) AND
        (NUM-ENTRIES ({&CurRight}:SCREEN-VALUE, {&Sep1}) = 1) THEN
        rsSortDirection:SCREEN-VALUE = 
          STRING (ENTRY (2, ENTRY (LOOKUP ({&CurRight}:SCREEN-VALUE,
                                           {&CurRight}:LIST-ITEMS, {&Sep1}), 
                         {&CurSortData}, {&Sep1}), {&sep2})).
      ELSE IF NUM-ENTRIES({&CurRight}:LIST-ITEMS, {&Sep1}) = 1 THEN
        rsSortDirection:SCREEN-VALUE = 
          STRING (ENTRY (2, ENTRY(1, {&CurSortData}, {&Sep1}), {&Sep2})).
    END. 
  END.
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE CheckSyntax.ip:
DEFINE OUTPUT PARAMETER lError AS LOGICAL INITIAL TRUE NO-UNDO.

DEFINE VARIABLE cText    AS CHARACTER INITIAL ""  NO-UNDO.
DEFINE VARIABLE cLine    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE cTable   AS CHARACTER initial ""  NO-UNDO.
DEFINE VARIABLE cExtTbls AS CHARACTER             NO-UNDO.
DEFINE VARIABLE i        AS INTEGER               NO-UNDO.
DEFINE VARIABLE tmpopts  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE wherecls AS CHARACTER INITIAL ""  NO-UNDO.
DEFINE VARIABLE num-sep  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE num-dec  AS CHARACTER             NO-UNDO.

DO WITH FRAME dialog-1:
  IF cCompIn = ? THEN
    RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_TEMPLATE}, {&STD_EXT_UIB}, 
                            OUTPUT cCompIn).

  lError = FALSE.
  IF application = "{&UIB_SHORT_NAME}":U OR pcValidStates <> "Where" THEN DO:
    ASSIGN num-sep               = SESSION:NUMERIC-SEPARATOR
           num-dec               = SESSION:NUMERIC-DECIMAL-POINT
           SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    OUTPUT STREAM P_4GL TO VALUE (cCompIn) NO-ECHO {&NO-MAP}.
    RUN BuildQuery.ip (OUTPUT cText). 
    IF (cText = "") THEN RETURN.      
    cText = REPLACE(cText, "INDEXED-REPOSITION":U, "").                      
    cText = REPLACE(cText, 'TEMP-TABLES.', '').
    IF iXternalCnt > 0 THEN DO: 
      /*
      ** If there are external tables, then these need to be added to the for 
      ** each phrase so that syntax will check ok - R. Ryan 8/94
      */
      DO i = 1 to iXternalCnt:
        cExtTbls = IF i = 1 
          THEN "FOR EACH " + 
               ENTRY(1,ENTRY(i,whRight[{&Table}]:LIST-ITEMS,{&Sep1})," ":U)
          ELSE cExtTbls + ", EACH " + 
               ENTRY(1,ENTRY(i,whRight[{&Table}]:LIST-ITEMS,{&Sep1})," ":U).
      END.
      cText = cExtTbls + ", ":U + REPLACE(cText,"FOR EACH":U, "EACH":U).
    END.
       
    IF application = "{&UIB_SHORT_NAME}":U THEN DO:
      IF {&Options-Mode} THEN DO:
        tmpopts = _TuneOptions:SCREEN-VALUE.
        PUT STREAM P_4GL UNFORMATTED
           "DEFINE TEMP-TABLE TT FIELD f AS INTEGER.":U SKIP
           "DEFINE QUERY q FOR TT.":U SKIP
           "OPEN QUERY q FOR EACH TT":U +
               (IF TRIM(tmpopts) = "":U THEN ".":U
                                        ELSE " QUERY-TUNING(":U + tmpopts + ").":U).
      END. 
      ELSE RUN adeuib/_writedf.p.
    END.

    IF (entry(1,_AliasList) > "") THEN DO:
      cTable = lLeft:screen-value.
      IF cTable <> "" AND cTable <> ? AND NOT {&Options-Mode} THEN
       PUT STREAM P_4GL UNFORMATTED 
           'DEFINE BUFFER ':u ENTRY(NUM-ENTRIES(cTable,"."),cTable,".")
                    ' FOR ':u entry(1,_AliasList) '.':u SKIP.
    END.
  
    IF (num-entries(_AliasList)) = 3 and (entry(3,_AliasList) > "") AND
      NOT {&Options-Mode} THEN DO:

      cTable = lRight:screen-value.
      if cTable <> "" and cTable <> ? THEN
       PUT STREAM P_4GL UNFORMATTED 
           'DEFINE BUFFER ':u ENTRY(NUM-ENTRIES(cTable,"."),cTable,".")
                    ' FOR ':u entry(3,_AliasList) '.':u SKIP.
    END.
 
    IF NOT {&Options-Mode} THEN DO:    
      /* Define any preprocessors that need to be defined. NOTE that
         we need to strip out preprocessors from the text field.  */   
      cText = REPLACE(cText, "~~~{&":U, "~{&":U).
      IF tKeyPhrase 
      THEN PUT STREAM P_4GL UNFORMATTED "&Scoped KEY-PHRASE TRUE" skip.    
      /* 
       * If we are using OUTER-JOIN, we have to put the query in
       * an OPEN QUERY statement for it to compile
       */
      IF application = "{&UIB_SHORT_NAME}":U AND 
        INDEX(cText,"OUTER-JOIN":U) <> 0 THEN DO:
          PUT STREAM P_4GL CONTROL "OPEN QUERY #CHKSYNTAX#":U CHR(10).
          PUT STREAM P_4GL CONTROL RIGHT-TRIM(cText,":":U) + ".":U CHR (10).
      END.
      ELSE DO:
        PUT STREAM P_4GL CONTROL cText CHR (10).
        PUT STREAM P_4GL UNFORMATTED "END." skip.
      END.
    END.  /* Not options mode */
    OUTPUT STREAM P_4GL CLOSE.
    SESSION:SET-NUMERIC-FORMAT(num-sep,num-dec). 
  END.
  ELSE DO:
    /* RESULTS needs a different kind of test compile file that will
       make sure this clause will work with OPEN QUERY instead of FOR EACH.
       Only needed for data selection WHERE clause not Join WHERE clause. 
    */
    DO i = 1 TO EXTENT (acWhere):
      wherecls = wherecls + acWhere[i].
    END.
    RUN aderes/_wcompil.p (cCompIn, {&TableRight}:LIST-ITEMS, wherecls).
  END.

  IF cCompOut = ? THEN
    RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_TEMPLATE}, {&STD_EXT_UIB}, 
                             OUTPUT cCompOut).

  OUTPUT TO VALUE(cCompOut) KEEP-MESSAGES.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    COMPILE VALUE(cCompIn).
  END.
  OUTPUT CLOSE.

  lError = COMPILER:ERROR.
  IF lError THEN DO:
    IF {&Options-Mode} THEN cText = tmpopts.

    INPUT FROM VALUE (cCompOut) NO-ECHO {&NO-MAP}.
    REPEAT:
      IMPORT UNFORMATTED cLine.
      IF cLine MATCHES "* (198)":u THEN NEXT.
      cText = cText + (IF cText = "" THEN "" ELSE CHR(10))
              + REPLACE (cLine, cCompIn,"").
    END.
    INPUT CLOSE.
    {&CurLeft}:SCREEN-VALUE  = "".
    {&CurRight}:SCREEN-VALUE = "".
    /* {&CurRight}:SCREEN-VALUE = 
            ENTRY(COMPILER:ERROR-ROW, {&CurRight}:LIST-ITEMS, {&Sep1}).*/

    RUN adeshar/_qset.p ("setUpDown",application,TRUE).

    MESSAGE cText VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    /* RUN edit_where_clause.ip. */
  END.

  /* Clean Up */
  OS-DELETE VALUE (cCompIn)  NO-ERROR.
  OS-DELETE VALUE (cCompOut) NO-ERROR.  
END. 
END PROCEDURE. /* check_syntax.ip */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE ChangeJoinTarget.ip:

DEFINE VARIABLE cRight     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLeft      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbRight   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbLeft    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
DEFINE VARIABLE pos        AS INTEGER NO-UNDO.  
DEFINE VARIABLE lConstant  AS LOGICAL NO-UNDO.

  DO WITH FRAME dialog-1:
  ASSIGN
    cList      = ""
    cTemp      = {&CurRight}:SCREEN-VALUE
    cListItems = {&CurRight}:LIST-ITEMS
    pos        = LOOKUP (cTemp, cListItems, {&Sep1}) 
    cLeft      = ENTRY (1, cTemp, " "). 
    
  IF NUM-ENTRIES(cTemp,{&Sep1}) > 1 THEN DO: 
    /*
    ** This is a work-around to keep the user from selecting too many
    ** tables to switch (used to get ENTRY n not found) - Ryan 8/94
    */
    MESSAGE "Please select only one table at a time." 
      VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.
  
  IF INDEX(cTemp,"<External>":U) > 0 THEN DO:
    /*
    ** Once again, this condition should happen, but here's another fail/safe
    ** way to bail out.
    */
    MESSAGE "You cannot switch join partners for external tables." 
      VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END. 
  
  IF NUM-ENTRIES(cTemp," ":U) = 1 THEN DO:
    /*
    ** Last fail/safe: single tables shouldn't be allow to change partners.
    */
    MESSAGE 
      'You cannot switch join partners after de-coupling "' 
      + cTemp + '"' + ' from another table.' skip 
      'Try removing the table and starting over.' 
      VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.
  
  /* find all potential join candidates */
  DO i = 1 TO NUM-ENTRIES (cListItems, {&Sep1}):
    IF ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}) = cTemp THEN LEAVE.
    cList = cList + (IF i = 1 THEN "" ELSE {&Sep1})
           + ENTRY (1, ENTRY (i, cListItems, {&Sep1})," ").
  END. 
  ASSIGN
    cRight = (IF NUM-ENTRIES (cList, {&Sep1}) = 1 THEN 
             cLeft ELSE ENTRY (3, cTemp, " ")).

  IF NUM-ENTRIES(cList, {&Sep1}) >= 1 THEN 
    RUN pickTable.ip (cList, INPUT-OUTPUT cRight).

  IF cRight = ? THEN RETURN ERROR.  
  IF cRight = "(None)":U THEN DO:  
    {&CurRight}:list-items = replace({&CurRight}:list-items, 
                                     {&CurRight}:screen-value, 
                                     entry(1,{&CurRight}:screen-value," ":U)).
    RUN BuildQuery.ip (OUTPUT eDisplayCode). 
    eDisplayCode:SCREEN-VALUE = eDisplayCode. 
    RUN EvaluateIndexReposition.ip.           
    lConstant = rsMain:DISABLE("Join").    
    RETURN.
  END. 
  /*
  ** Delete all the ttWhere records. By selecting a new join partner the
  ** users has invalidated the old join criteria so delete it.  
  */
  FOR EACH ttWhere WHERE {&Join} = ttWhere.iState 
    AND cLeft = ttWhere.cTable AND ttWhere.iSeq > 0 :
    DELETE ttWhere.
  END.
  
  IF (pos >= 1) THEN
    acJoin  [pos] = "".
  RUN IsJoinable.ip (cRight, cLeft, OUTPUT lOk).

  ASSIGN
    cTemp                          = ENTRY(1,cTemp," ") 
                                   + (IF lOK THEN " OF " + cRight
                                      ELSE " WHERE " + cRight + " ...")
    ENTRY (i, cListItems, {&Sep1}) = cTemp
    {&CurRight}:LIST-ITEMS         = cListItems
    {&CurRight}:SCREEN-VALUE       = cTemp.
    
  RUN BuildQuery.ip (OUTPUT eDisplayCode). 
  eDisplayCode:SCREEN-VALUE = eDisplayCode.
  RUN RadioSetEnable.ip.
END. 
END PROCEDURE. /* changeJoinTarget.ip */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE Debug.ip:
  DO WITH FRAME dialog-1:

  message
   'whRight[{&table}]:PRIVATE-DATA' whRight[{&table}]:PRIVATE-DATA skip
   'whLeft[{&table}]:PRIVATE-DATA'  whLeft[{&table}]:PRIVATE-DATA skip
   '{&CurLeft}:PRIVATE-DATA'        {&CurLeft}:PRIVATE-DATA  skip
   '{&CurData} CURRENT:'   	      {&CurData}                skip
   '{&CurSortData} SORT:'           {&CurSortData}                skip
   '{&CurFieldData} FIELD:'	      {&CurFieldData}                skip
   'cMoreData[{&Table}]'   		  cMoreData[{&Table}]            skip
   '{&CurTable} CURRENT TABLE:'     {&CurTable}                skip
  view-as alert-box error buttons Ok.
  END.
END PROCEDURE.   

PROCEDURE ClearValueLeft.ip: 
  /*
  ** Clears contents of left selection list so that we don't end up with
  ** both left and right selection lists having screen-values
  */
  DO WITH FRAME dialog-1:      
    {&CurLeft}:SCREEN-VALUE = "". 

    RUN adeshar/_qset.p ("setUpDown",application,TRUE).
    IF {&Sort-Mode} THEN DO:
      RUN CheckSelect.ip (OUTPUT i).
      rsSortDirection:SENSITIVE = i > 0.
    END.  /* If Sort-Mode */
  END. 
END PROCEDURE.

PROCEDURE ClearValueRight.ip:
  /*
  ** Clears contents of right selection list so that we don't end up with
  ** both left and right selection lists having screen-values
  */
  DO WITH FRAME dialog-1:      
    {&CurRight}:SCREEN-VALUE = "". 

    RUN adeshar/_qset.p ("setUpDown",application,TRUE).  
    IF {&Sort-Mode} THEN DO:
      RUN CheckSelect.ip (OUTPUT i).
      rsSortDirection:SENSITIVE = i > 0.
    END.  /* If Sort-Mode */
  END.  
END PROCEDURE.

PROCEDURE EvaluateIndexReposition.ip:    
  /*
  ** This procedure used to decide whether tIndexReposition should be selected
  ** or even checked based on whether there is more than one table selected.
  ** Then it would make proper displays and updates.  Now that index reposition
  ** is valid regardless of how many tables are in the query, we no-longer
  ** turn tIndexReposition off when more than one table is selected, but we
  ** still make the displays and updates.
  **
  ** DRH 6/98
  */
  DO WITH FRAME Dialog-1:
     
    RUN BuildOptionList.ip. 
    RUN BuildQuery.ip (OUTPUT eDisplayCode).
    ASSIGN
         eDisplayCode:SCREEN-VALUE = eDisplayCode  
         bCheckSyntax:SENSITIVE    = (IF eDisplayCode <> "" THEN TRUE 
                                      ELSE FALSE). 
  END.
END PROCEDURE.

/* quryproa.i - end of file */


