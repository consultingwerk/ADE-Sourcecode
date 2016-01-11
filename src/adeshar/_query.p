/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

             ********** The QUERY BUILDER  Main Procedure **********

  File: _query.p 

  Description: 
   This code will bring up the dialog box frame that allows the developer
   to define the files for a query (and optionally, the fields for an 
   associated browse). 

  Input Parameters:
    browser-name    - The name of the browser to be editted
    suppress_dbname - Logical to indicate if dbname should be suppressed
                      from qualifications of the db fields in the generated
                      4GL code
    application     - Either "AB" or "Results"
    pcValidStates   - Valid Values for the Radio-Set at the top of the
                      screen  ("Table,Join,Where,Sort,Options").  The
                      first entry in this list is the initial state.
                      (eg. "Where,Join" will show only two items and will
                      set the initial state to "Where").
    plVisitFields   - YES if user cannot leave the dialog without first
                      Visiting the "Fields" entry.
    auto-check      - State of check syntax on OK toggle

  Output Parameters:
    pCancelBtn      - logical for ok/cancel btn    
     
  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

  Modified:
    1/17/94 wood - don't return _TblList = ?.  Use "" in this case.
    1/28/94 wood - moved to adeshar/_query2.p
    2/24/94 adams - added output param to check for endkey condition
                    added partial-key help for eDisplayCode 4GL widget
                    display WHERE clause only for single pcValidState
    2-3/94  ryan - Extensively modified all query programs to incorporate
                   calculated fields, real combo boxes, and fix about 40 query bugs
    4/28/95 wood - I &IF'd out the entire contents of the file if compiled in
                   TTY mode.
 -----------------------------------------------------------------------------*/
/* Parameters Definitions ---                                                */
&GLOBAL-DEFINE WIN95-BTN YES
DEFINE INPUT  PARAMETER browser-name    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER suppress_dbname AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER application     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcValidStates   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plVisitFields   AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER auto_check      AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cancelled       AS LOGICAL   NO-UNDO. /* dma */

/* This file is not required in TTY, so IFDEF it out */
&IF "{&WINDOW-SYSTEM}" ne "TTY" &THEN

{ adeshar/quryshar.i }
{ adecomm/tt-brws.i }
{ adeshar/qurydefs.i NEW }
{ adecomm/cbvar.i }
{ adecomm/adeintl.i }
{ adeuib/uibhlp.i }           /*   AB Help pre-processor directives      */
{ aderes/reshlp.i }           /*   Results Help pre-processor directives */

/* Standard End-of-line character */
&SCOPED-DEFINE EOL  CHR(10)

/*---------------------------------------------------------------------------*/
DEFINE VARIABLE cCompOut         AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE cCompIn          AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE cState           AS CHARACTER NO-UNDO.
DEFINE VARIABLE iTemp            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lNo_Tables       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lConstant        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lMustCheckFields AS LOGICAL   NO-UNDO.
DEFINE VARIABLE res_calcfld      AS LOGICAL   NO-UNDO. /* RESULTS calc field */
DEFINE VARIABLE sel-str          AS CHARACTER NO-UNDO. /* dma */
DEFINE VARIABLE sIndex           AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_pick           AS CHARACTER NO-UNDO.
DEFINE VARIABLE winTitle         AS CHARACTER NO-UNDO init "Query Builder":U.
DEFINE VARIABLE winTitleRelated  AS CHARACTER NO-UNDO init "Select Related Table":t32.
DEFINE RECTANGLE RECT-4 {&STDPH_OKBOX}.

DEFINE NEW SHARED STREAM P_4GL.

   
&IF DEFINED(IDE-IS-RUNNING) <> 0 &THEN
     assign  eDisplayCode:RETURN-INSERTED = TRUE 
             eDisplayCode:SCROLLBAR-H     = TRUE
            _TuneOptions:RETURN-INSERTED = TRUE
            eFieldLabel:RETURN-INSERTED  = TRUE.
&endif   
{adeuib/ide/dialoginit.i "FRAME dialog-1:handle"}
&IF DEFINED(IDE-IS-RUNNING) <> 0 &THEN
dialogService:View().
&ENDIF


/* Include the trigger code for the Query Builder */
{ adeshar/qurytrig.i }

ON WINDOW-CLOSE OF FRAME dialog-1 OR ENDKEY OF FRAME dialog-1 OR END-ERROR OF FRAME dialog-1 DO:
  cancelled = TRUE.
  APPLY "END-ERROR":u TO SELF.
END.

ON HELP OF eDisplayCode IN FRAME dialog-1 DO: /* dma */
  sel-str = "".
  IF (eDisplayCode:SELECTION-START <> eDisplayCode:SELECTION-END ) THEN
    sel-str = TRIM(TRIM(eDisplayCode:SELECTION-TEXT), ",.;:!? ~"~ '[]()").
  RUN adecomm/_adehelp.p ("lgrf","PARTIAL-KEY",?,sel-str).
END.



/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */
&if DEFINED(IDE-IS-RUNNING) = 0  &then
IF SESSION:THREE-D = TRUE THEN FRAME DIALOG-1:THREE-D = TRUE.
&endif

/* Go through the list of radio-buttons. If the radio-button is NOT in the
   list of Valid States (pcValidStates) then delete the radio button. 
   NOTE: we want the 1st,3rd,5th element of radio buttons because this
   list is of the form "Label,value,label,value" */
   
DO iTemp = 1 TO NUM-ENTRIES(rsMain:RADIO-BUTTONS) BY 2:
  CASE LOOKUP(ENTRY(iTemp, REPLACE(rsMain:RADIO-BUTTONS,"~&":U,"")),
                                   pcValidStates):
    WHEN 0 THEN /* Radio-Button is NOT valid.  Delete it. */
    DO:
      lConstant = rsMain:DELETE(ENTRY(iTemp, rsMain:RADIO-BUTTONS) ).
      iTemp = iTemp - 2.
    END.
    WHEN 1 THEN /* This button is the first in the Valid List */
      cState = ENTRY(iTemp + 1, rsMain:RADIO-BUTTONS). 
  END CASE.
END.

/* Compute the number of "external" tables -- store this for future
   enabling -- these are always at the front of the list. */
iXternalCnt = 0.

ASSIGN _TblList       = RIGHT-TRIM(_TblList,{&Sep1}) 
       tKeyPhrase     = (LOOKUP ("KEY-PHRASE":U, _OptionList, " ":U) > 0)
       tSortByPhrase  = (LOOKUP ("SORTBY-PHRASE":U, _OptionList, " ":U) > 0)
       .

COUNT-EXTERNALS:
DO iTemp = 1 TO NUM-ENTRIES(_TblList,{&Sep1}):
  cTemp = ENTRY(iTemp,_TblList,{&Sep1}).
  IF NUM-ENTRIES(cTemp," ") = 2 AND ENTRY(2,cTemp," ") = "<external>" 
  THEN iXternalCnt = iTemp.
  ELSE LEAVE COUNT-EXTERNALS.
END.

/* Ensure the interface displays over the window with focus. */
IF VALID-HANDLE(ACTIVE-WINDOW) THEN CURRENT-WINDOW = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition. */ 
&if DEFINED(IDE-IS-RUNNING) = 0  &then
RUN adeshar/_qenable.p (auto_check, application, pcValidStates).
&else
  RUN adeuib/ide/_dialog_qenable.p (auto_check, application, pcValidStates).
&endif
lNo_Tables = FALSE.

RUN RadioSetEnable.ip.

rsMain:SCREEN-VALUE = cState. 
&if DEFINED(IDE-IS-RUNNING) = 0  &then
RUN adeshar/_qenable.p (auto_check,application,pcValidStates).
&else
  RUN adeuib/ide/_dialog_qenable.p (auto_check, application, pcValidStates).
&endif

IF cState = "2" THEN	
  APPLY "VALUE-CHANGED" TO eCurrentTable IN FRAME dialog-1.

/* We don't want to build the query if we're starting with one state */
IF NUM-ENTRIES(pcValidStates) > 1 THEN DO: /* dma */
  RUN BuildQuery.ip (OUTPUT eDisplayCode). 

  bCheckSyntax:SENSITIVE    = (IF eDisplayCode > "" THEN TRUE ELSE FALSE).
  eDisplayCode:SCREEN-VALUE = eDisplayCode.
END.

DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE: 
  RUN adecomm/_setcurs.p ("").
   &scoped-define CANCEL-EVENT U2
   {adeuib/ide/dialogstart.i bok bcancel wintitle}
   &if DEFINED(IDE-IS-RUNNING) = 0  &then
     WAIT-FOR GO OF FRAME dialog-1.
   &ELSE
     WAIT-FOR GO OF FRAME dialog-1 or "U2" of this-procedure.       
     if cancelDialog THEN UNDO, LEAVE.  
   &endif
  

  IF {&Join-Mode} THEN APPLY "LEAVE" TO eDisplayCode.
END.
 
HIDE FRAME DIALOG-1.

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

/* Internal procedures for the Query Builder (used to be in quryproa.i) */
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
        do:
          &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("Select a table(s).",
                           "Warning",?).
      
          &else     
          MESSAGE "Select a table(s)." 
            VIEW-AS ALERT-BOX WARNING.
          &endif  
        end.    
        ELSE
        do:
          &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("Select a field(s).",
                        "Warning",?).
      
          &else  
          MESSAGE "Select a field(s)." 
            VIEW-AS ALERT-BOX WARNING.
          &endif  
        end.    
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
      ELSE IF NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) > 1 THEN 
      DO:
        &if DEFINED(IDE-IS-RUNNING) <> 0  &then
        define variable relationDlgService as adeuib.ide._chooserelation no-undo.
        relationDlgService = new adeuib.ide._chooserelation().                
        relationDlgService:SetCurrentEvent(this-procedure,"PickTable").
        assign
            relationDlgService:CurrentName = v_CurrentName
            relationDlgService:TableName   = v_TblName
            relationDlgService:ParentName  = cTemp
            relationDlgService:Join = lOk
            .
         
        run runChildDialog in hOEIDEService (relationDlgService) .
        return.
        &else
        
        RUN pickTable.ip ({&CurRight}:PRIVATE-DATA, INPUT-OUTPUT cTemp). 
        IF (cTemp = ?) THEN 
            RETURN.
        &endif
      END.
      run AddTabletoList(v_CurrentName,cTemp,lOk).
    END.  /* IF &Table-Mode */
    ELSE lOk = {&CurRight}:ADD-LAST (v_CurrentName).
    
    run tableAdded(v_currentname ,v_TblName).
  END.
END PROCEDURE. /* addTable.ip */

/* separated out dialog for call from ide */
procedure PickTable:
    define input parameter pCurrentName  as char no-undo.  
    define input parameter pTableName  as char no-undo.  
    define input parameter pParentName as char no-undo.  
    define input parameter plJoin      as log no-undo.  
    do with frame dialog-1:  
        RUN pickTable.ip ({&CurRight}:PRIVATE-DATA, INPUT-OUTPUT pParentName). 
    end.
    IF pParentName <> ? THEN
    do: 
        run AddTabletoList(pCurrentName,pParentName,plJoin).
        run TableAdded(pCurrentName,pTableName).
    end.
end procedure.

procedure AddTableToList:
    define input parameter pCurrentname  as char no-undo.  
    define input parameter pParentName as char no-undo.  
    define input parameter plJoin      as log no-undo.  
    
    do with frame dialog-1:
        {&CurRight}:PRIVATE-DATA = (IF {&CurRight}:PRIVATE-DATA = ? THEN "" ELSE 
                                    {&CurRight}:PRIVATE-DATA + {&Sep1}) +  
                                    pCurrentname.

        pCurrentname =  IF plJoin = ? THEN  pCurrentname
                        ELSE IF plJoin THEN pCurrentname + " OF "   + pParentName
                        ELSE pCurrentname + " WHERE " + pParentName + " ..." .
        {&CurRight}:ADD-LAST (pCurrentname).
    end.
END PROCEDURE.  


procedure tableAdded:
  define input parameter pCurrentname as char no-undo.  
  define input parameter pTblName as char no-undo.  
  define variable cnt as integer no-undo.
  DO WITH FRAME dialog-1:
   
   
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

    IF pCurrentName BEGINS "Temp-Tables":U AND
      NUM-ENTRIES(pTblName, ".":U) = 1 THEN DO:  /* Quailify with Temp-Tables if not Buffer */
      FIND FIRST _tt-tbl WHERE _tt-tbl.tt-name = pTblName.
      IF _tt-tbl.table-type = "T":U THEN
        pTblName = "Temp-Tables.":U + pTblName.
    END.

    RUN adecomm/_delitem.p ({&CurLeft}:HANDLE, pTblName, OUTPUT cnt). 

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
             ttWhere.cTable      = ENTRY (1, pCurrentName, " ") 
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
END.  /* tableAdded */

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
        &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("The Browse interface only supports up to 50 fields. ~n Only the first 50 fields where saved.",
                        "Warning",?).
      
        &else    
        MESSAGE 'The Browse interface only supports up to 50 fields.' SKIP
                'Only the first 50 fields where saved.'.
        &endif        
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
        &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("The display width of the all the select fields exceeds 310. ~n
                            The current display width is " + string(tot-wdth) + ".~n 
                            Please remove a field or fields.",
                            "Warning",?).
      
        &else  
        MESSAGE 
          "The display width of the all the select fields exceeds 310." SKIP
          "The current display width is " tot-wdth "." SKIP
          "Please remove a field or fields."
          VIEW-AS ALERT-BOX WARNING.
        &endif
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
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService(cText,"Error",?).
      
    &else
    MESSAGE cText VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    &endif
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
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
        dialogService:SetCurrentEvent(this-procedure,"DoChangeJoinTarget").
        run runChildDialog in hOEIDEService (dialogService) .
     &else
        run DoChangeJoinTarget.
     &endif
end.


PROCEDURE DoChangeJoinTarget:
    
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
        &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("Please select only one table at a time.","Warning",?).
      
        &else
        MESSAGE "Please select only one table at a time." 
          VIEW-AS ALERT-BOX WARNING.
        &endif  
        RETURN.
      END.
      
      IF INDEX(cTemp,"<External>":U) > 0 THEN DO:
        /*
        ** Once again, this condition should happen, but here's another fail/safe
        ** way to bail out.
        */
        &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("You cannot switch join partners for external tables.","Warning",?).
      
        &else
        MESSAGE "You cannot switch join partners for external tables." 
          VIEW-AS ALERT-BOX WARNING.
        &endif  
        RETURN.
      END. 
      
      IF NUM-ENTRIES(cTemp," ":U) = 1 THEN DO:
        /*
        ** Last fail/safe: single tables shouldn't be allow to change partners.
        */
        &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("You cannot switch join partners after de-coupling. "
                           + cTemp +  "from another table. ~n Try removing the table and starting over." ,
                           "Warning",?).
      
        &else
        MESSAGE 
          'You cannot switch join partners after de-coupling "' 
          + cTemp + '"' + ' from another table.' skip 
          'Try removing the table and starting over.' 
          VIEW-AS ALERT-BOX WARNING.
        &endif  
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
  &if DEFINED(IDE-IS-RUNNING) <> 0 &then
      run ShowOkMessage in hOEIDEService("whRight[{&table}]:PRIVATE-DATA. " + whRight[{&table}]:PRIVATE-DATA + "~n"
                       + "whLeft[{&table}]:PRIVATE-DATA"  +  whLeft[{&table}]:PRIVATE-DATA + "~n"
                       + "{&CurLeft}:PRIVATE-DATA"        + {&CurLeft}:PRIVATE-DATA  + "~n"
                       + "{&CurData} CURRENT:"            + {&CurData} + "~n"
                       + "{&CurSortData} SORT:"           + {&CurSortData} + "~n"
                       + "{&CurFieldData} FIELD:"         + {&CurFieldData} + "~n"
                       + "cMoreData[{&Table}]"            + cMoreData[{&Table}] + "~n"
                       + "{&CurTable} CURRENT TABLE:"     + {&CurTable} + "~n",
                         "Error",?).
      
  &else
  message
   'whRight[{&table}]:PRIVATE-DATA' whRight[{&table}]:PRIVATE-DATA skip
   'whLeft[{&table}]:PRIVATE-DATA'  whLeft[{&table}]:PRIVATE-DATA skip
   '{&CurLeft}:PRIVATE-DATA'        {&CurLeft}:PRIVATE-DATA  skip
   '{&CurData} CURRENT:'          {&CurData}                skip
   '{&CurSortData} SORT:'           {&CurSortData}                skip
   '{&CurFieldData} FIELD:'       {&CurFieldData}                skip
   'cMoreData[{&Table}]'          cMoreData[{&Table}]            skip
   '{&CurTable} CURRENT TABLE:'     {&CurTable}                skip
  view-as alert-box error buttons Ok.
  &endif
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
/* the follwoing used to be in quryproe.i */

PROCEDURE TableRemove.ip:
  DEFINE VARIABLE cDBnm        AS CHAR    NO-UNDO.
  DEFINE VARIABLE cDefJoin     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cJoinTry     AS CHAR    NO-UNDO.
  DEFINE VARIABLE cTempOne     as char    NO-UNDO.
  DEFINE VARIABLE cFldTemp     as char    NO-UNDO.
  DEFINE VARIABLE cFldTemp-idx as INTEGER NO-UNDO.
  DEFINE VARIABLE cFldDelete   as char    NO-UNDO.
  DEFINE VARIABLE cFldName     as char    NO-UNDO.
  DEFINE VARIABLE cnt          as integer NO-UNDO.
  DEFINE VARIABLE err          as logical NO-UNDO.
  DEFINE VARIABLE pos          as integer NO-UNDO.
  DEFINE VARIABLE nxtname      as char    NO-UNDO.
  DEFINE VARIABLE ix           as integer NO-UNDO.  /* loop index */
  DEFINE VARIABLE i            as integer NO-UNDO.  /* loop index */
  DEFINE VARIABLE lConstant    as logical NO-UNDO. 
  
  DO WITH FRAME dialog-1:
  
  IF (browser-name <> "") THEN RETURN.

  /* Make sure something is selected */
  RUN CheckSelect.ip (OUTPUT iTableNum).
  IF iTableNum = 0 THEN RETURN. 

  /* Get the selected name from the "picked list". */
  cFldTemp = {&CurRight}:SCREEN-VALUE.

  /* Make certain that there isn't an <external> reference */
  DO iTemp = 1 TO NUM-ENTRIES(cFldTemp,{&Sep1}):
    IF NUM-ENTRIES(ENTRY(iTemp,cFldTemp,{&Sep1})," ":U) = 2 THEN DO:
      IF ENTRY(2,ENTRY(iTemp,cFldTemp,{&Sep1})," ":U) = "<External>":U THEN DO:
      &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          run ShowOkMessage in hOEIDEService("You cannot remove a reference to an external table.",
                           "Warning",?).
      
       &else    
        MESSAGE "You cannot remove a reference to an external table."
          VIEW-AS ALERT-BOX WARNING.
       &endif   
        RETURN. 
      END.
    END.
  END.

  DO iTemp = 1 TO NUM-ENTRIES (cFldTemp, {&Sep1}):
    ASSIGN
      cTableName = ENTRY (iTemp, cFldTemp, {&Sep1}) /* full entry name */
      cTemp      = ENTRY (1,ENTRY (iTemp, cFldTemp, {&Sep1}), " ") /* table */
      pos        = LOOKUP (cTableName, {&CurRight}:LIST-ITEMS, {&Sep1})
      cDBnm      = IF NUM-ENTRIES(cTemp,".":U) = 2 THEN
                     ENTRY(1,cTemp,".":U) ELSE ?.

    /* Check to see if the table is used anywhere else ! */

    /* First check sort stuff */
    cFldDelete = whRight [{&Sort}]:LIST-ITEMS.
    DO i = 1 to NUM-ENTRIES(cFldDelete, {&Sep1}):  
      IF cDBnm NE ? THEN  
        cFldName = IF NUM-ENTRIES(ENTRY(i,cFldDelete,{&Sep1}),".") = 2 
                   THEN cDBnm + ".":U +
                        ENTRY (1, ENTRY (i, cFldDelete, {&Sep1}), ".") + "." +
                        ENTRY (2, ENTRY (i, cFldDelete, {&Sep1}), ".") 
                   ELSE ENTRY(i, cFldDelete,{&Sep1}). 
      ELSE cFldName = IF NUM-ENTRIES(ENTRY(i,cFldDelete,{&Sep1}),".") = 3 
                   THEN ENTRY (2, ENTRY (i, cFldDelete, {&Sep1}), ".") + "." +
                        ENTRY (3, ENTRY (i, cFldDelete, {&Sep1}), ".") 
                   ELSE ENTRY(i, cFldDelete,{&Sep1}). 
      /* IF the table matches or there is only one table selected that is being 
         deleted then delete the corresponding selected sort of field stuff
         from the selection list and the corresponding data */ 
      IF ENTRY (1, cTemp, " ") = ENTRY(NUM-ENTRIES(cFldName,".":U) - 1, cFldName, ".":U)
         OR (NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) = 1) THEN DO:
        RUN adecomm/_delitem.p (whRight[{&SORT}]:HANDLE, 
                                ENTRY (i, cFldDelete, {&Sep1}), OUTPUT cnt). 
        ENTRY (i, cMoreData [{&Sort}], {&Sep1}) = "".
      END.
    END.  /* DO i = 1 to NUM-ENTRIES of Sort stuff */
    /* Collapse the data after deletion */
    cMoreData [{&Sort}] = TRIM (REPLACE (cMoreData [{&Sort}], 
                                {&Sep1} + {&Sep1}, {&Sep1}), {&Sep1}).        

    RUN adecomm/_delitem.p ({&CurRight}:HANDLE, cTableName, OUTPUT cnt). 

    /** Rebuild the table list based on the info in the right list **/
    {&CurRight}:PRIVATE-DATA = ?. 
    DO i = 1 to NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}):
      {&CurRight}:PRIVATE-DATA = (IF {&CurRight}:PRIVATE-DATA = ? THEN "" ELSE 
         {&CurRight}:PRIVATE-DATA + {&Sep1}) 
       + ENTRY(1, ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}), " ").
    END. 
  
    /* Check to see if the current table in sort is what has been
       Deleted and if it is reset it to ? cTemp = table only */
    IF (whLeft[{&Sort}]:PRIVATE-DATA = cTemp) THEN
      whLeft[{&Sort}]:PRIVATE-DATA = ?.
    
    /* Check to see if the current table in Join or Where is what has been
       Deleted and if it is reset it to ? cTableName full Right Expression 
       (order OF order-line)                                             */
    DO j = {&Join} TO {&Where}:
      IF (whLeft[j]:PRIVATE-DATA = cTableName) THEN
        whLeft[j]:PRIVATE-DATA = ?.
    END.

    /*  Delete all the ttWhere records.                                   */
    DO j = {&Join} TO {&Where}:
      FOR EACH ttWhere WHERE ttWhere.iState = j AND ttWhere.cTable = cTemp:
        DELETE ttWhere.
      END.
      
      IF pos > 0 THEN DO:
        /* Delete where and join criteria of deleted table  */
        IF (j = {&Where}) THEN acWhere [pos] = "".
                          ELSE acJoin  [pos] = "".
      END.

      /* Now delete where and join criteria of subsequent tables that
         envolve deleted table                                           */
      DO i = pos TO NUM-ENTRIES({&CurRight}:LIST-ITEMS,{&Sep1}):
        IF (j = {&Where}) AND INDEX(acWhere[MAX(i,1)], cTemp) > 0 THEN acWhere[MAX(i,1)] = "".
        IF (j = {&Join}) AND INDEX(acJoin[MAX(i,1)], cTemp) > 0 THEN acJoin[MAX(i,1)] = "".

        /* Search subsequent default joins (ie order-line of order) to
           see if any need to be changed from using the deleted table as
           the "OF" part.                                                */
        cDefJoin = ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1}).
        IF i > 1 AND  /* First table gets handled later */
          j = {&Join} AND 
          NUM-ENTRIES(cDefJoin," ":U) = 3 AND
          ENTRY(2,cDefJoin," ":U) = "OF":U AND
          ENTRY(3,cDefJoin," ":U) = cTemp THEN DO:
          lOK = ?.
          FIND-JOIN-BLOCK:
          DO ix = 1 TO (i - 1):
           ASSIGN cDefJoin = ENTRY(1, cDefJoin, " ":U)
                  cJoinTry = ENTRY(1, 
                             ENTRY(ix, {&CurRight}:LIST-ITEMS, {&Sep1})," ":U).
            IF NUM-ENTRIES(cDefJoin,".":U) = 2 THEN /* Get the Table name */
              cDefJoin = ENTRY(2,cDefJoin,".":U).
            IF NUM-ENTRIES(cJoinTry,".":U) = 2 THEN /* Get the Table name */
              cJoinTry = ENTRY(2,cJoinTry,".":U).
            RUN IsJoinable.ip(cDefJoin, cJoinTry, OUTPUT lOK).
            IF (lOK) THEN LEAVE FIND-JOIN-BLOCK.                  
          END.
          /* Prepare to keep cFldTemp current with {&CurRight}:LIST-ITEMS */
          ASSIGN cFldtemp-idx = LOOKUP(ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1}),
                                          cFldtemp, {&Sep1}).
          IF lOK THEN
            lOK = {&CurRight}:REPLACE(
              ENTRY(1,ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1})," ":U) + " OF " +
                ENTRY(1, ENTRY(ix, {&CurRight}:LIST-ITEMS, {&Sep1})," ":U), i).
          ELSE
            lOK = {&CurRight}:REPLACE(
              ENTRY(1,ENTRY(i,{&CurRight}:LIST-ITEMS,{&Sep1})," ":U) 
              + " WHERE " +
              ENTRY(1, ENTRY(MAX(1,pos - 1),
                    {&CurRight}:LIST-ITEMS, {&Sep1})," ":U) + " ...", i).
          IF cFldTemp-idx > 0 THEN
            ENTRY(cFldTemp-idx, cFldtemp, {&Sep1}) = 
                  ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}).

        END.  /* If j = join and TABLE OF DELETED_TABLE */
      END.  /* DO i = pos TO NUM-ENTRIES */
    END.  /* DO j = join to where */

    /* Insert field back in it's proper place.  Determine the position
       this field took in original field list.  Look from this point
       down in original list until  find an entry that is still in
       the left hand field list.  This is the entry we want to insert
       above.                                                           */ 
    IF (NUM-ENTRIES (cTemp, ".") > 1) THEN
      ASSIGN cTableName  = cTemp  /* cTableName is tb.fld or db.tb.fld  */
             ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".") = ""
                                  /* cTableName is tb. or db.tb.        */
          cTableName  = TRIM (REPLACE (cTableName, "..", "."), ".")
                               /* cTableName is tb or db.tb          */
             cTemp       = ENTRY (NUM-ENTRIES (cTemp, "."), cTemp, ".").
                                  /* cTemp is fld */

    IF cTableName = eCurrentTable or cDBnm = ? THEN DO:
      /* Insert removed table into left */
      /* This code assumes that the list on the Left side is in
         aplhabetical order and will insert or add accordingly  */
      Insert-loop:
      DO j = 1 TO NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}):
        IF (ENTRY (j, {&CurLeft}:LIST-ITEMS, {&Sep1}) > cTemp) THEN DO:
          ASSIGN err   = {&CurLeft}:INSERT(cTemp, 
                              ENTRY (j, {&CurLeft}:LIST-ITEMS, {&Sep1}))
                 cTemp = "".
          LEAVE Insert-Loop.
        END.
      END.  /* Insert-Loop: do j = 1 to Num-Entries */

      IF j > NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) THEN
        err = {&CurLeft}:ADD-LAST(cTemp).
    END.  /* If the table is the same */

    /* Scrolling disabled to avoid a serious of bugs that occur when
       a user tries to delete all the tables */ 
    /* RUN adecomm/_scroll.p ({&CurLeft}:HANDLE, INPUT cTemp). */
   
  END. /* END DELETE LOOP */

  /*
  ** If we are deleting the first item and there are more items then
  ** remove the stuff on the right of the 2 item which soon will be the
  ** First item
  */
  IF (NUM-ENTRIES (ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}), " ") > 2) THEN
    ASSIGN
      cFieldName = {&CurRight}:LIST-ITEMS
      cTempOne = ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1})
      cTempOne = ENTRY (1, cTempOne, " ")
      ENTRY (1, cFieldName, {&Sep1}) = cTempOne
      {&CurRight}:LIST-ITEMS = cFieldName  
      .
  ASSIGN
    whLeft[INTEGER (rsMain:SCREEN-VALUE)]:LIST-ITEMS = {&CurLeft}:LIST-ITEMS.


  DO j = {&Sort} TO {&Options}:
    IF ((NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) = 1) AND 
         NUM-ENTRIES (whRight [j]:LIST-ITEMS, "."   ) > 1) THEN DO:
      cTemp = whRight [j]:LIST-ITEMS.

      DO i = 1 to NUM-ENTRIES (cTemp, {&Sep1}):
        ASSIGN
          ENTRY(i,cTemp,{&Sep1})        = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cTemp,{&Sep1}),"."), 
                                            ENTRY(i,cTemp,{&Sep1}),".")
          ENTRY(i,cMoreData[j],{&Sep1}) = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cMoreData[j],{&Sep1}),"."), 
                                            ENTRY(i,cMoreData[j],{&Sep1}),".")
          .
      END.
      whRight [j]:LIST-ITEMS = cTemp.
    END.
  END.
  RUN BuildQuery.ip (OUTPUT eDisplayCode). 
  RUN RadioSetEnable.ip.

  ASSIGN
    eDisplayCode:SCREEN-VALUE = eDisplayCode
    bCheckSyntax:SENSITIVE    = (IF eDisplayCode <> "" THEN TRUE ELSE FALSE).  
    
  RUN RadioSetEnable.ip.
  RUN EvaluateIndexReposition.ip.
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE RightRemove.ip:   
  DEFINE VARIABLE cArrayList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cArrayEntry  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lArray       AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE lMatch       AS LOGICAL   NO-UNDO INIT FALSE.
  DEFINE VARIABLE cName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFldName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempOrg     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE err          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE pos          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE nxtname      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER   NO-UNDO.  /* loop index */
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO.  /* loop index */
  DEFINE VARIABLE k            AS INTEGER   NO-UNDO.  /* loop index */
  DEFINE VARIABLE icurrent     AS INTEGER   NO-UNDO.  /* loop index */

  DO WITH FRAME dialog-1:
  
    /* Make sure something is selected */
    RUN CheckSelect.ip (OUTPUT iTableNum).
    IF iTableNum = 0 THEN RETURN. 
  
    /* Get the selected name from the "picked list". */
    ASSIGN cFldName = {&CurRight}:SCREEN-VALUE.  

    DO iTemp = 1 TO NUM-ENTRIES(cFldName,{&Sep1}):
      ASSIGN cTableName = ENTRY(iTemp,cFldName,{&Sep1})
             cTemp      = IF SUBSTRING(ENTRY(1,cTableName),1,1,
                                       "CHARACTER":u) <> "(":U 
                          THEN ENTRY(1,cTableName," ")
                          ELSE cFldName
             i          = LOOKUP(cTemp,{&CurRight}:LIST-ITEMS,{&Sep1}).

      /* message '2'  cFldName i skip {&CurRight}:LIST-ITEMS skip cTemp skip
         view-as alert-box. */
    
      /* Remove this name from the "picked list" */
      RUN adecomm/_delitem.p ({&CurRight}:HANDLE, cTableName, OUTPUT cnt).
       
      /* message '21' cFldName skip {&CurRight}:LIST-ITEMS skip cTemp skip
         view-as alert-box. */
      /* Insert field back in it's proper place.  Determine the position 
         this field took in original field list.  Look from this point down 
         in original list until find an entry that is still in the left hand 
         field list.  This is the entry we want to insert above.                      */ 
      IF ((NUM-ENTRIES (cTemp, ".") > 1) 
        AND ({&DisFieldList} <> {&CurTable})) 
        AND INDEX(cTemp,"(":U) = 0 THEN
        ASSIGN cTableName = cTemp
               ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".") = ""
               cTableName = TRIM (REPLACE (cTableName, "..", "."), ".")
               cTemp      = ENTRY (NUM-ENTRIES (cTemp, "."), cTemp,".").
            
      IF {&Sort-Mode} OR {&Options-Mode} THEN DO: 
        ASSIGN 
          ENTRY(i,{&CurData},{&Sep1}) = ""
            {&CurData} = TRIM(REPLACE({&CurData},{&Sep1} + {&Sep1},{&Sep1}),
                             {&Sep1}).
      
        RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
        eDisplayCode:SCREEN-VALUE = eDisplayCode.
      END.

      /* IF the current table is not a match to the table part of the 
         deleting item Next. */
      IF ((ENTRY(NUM-ENTRIES(cTableName,".":U),cTableName,".":U) <> {&CurTable})
         AND (cTableName <> cTemp)) THEN NEXT.

      /* IF the field is in the field and we are dealing with the display 
         field list List continue.  */
      IF (CAN-DO (whLeft[{&Options}]:LIST-ITEMS, cTemp)) THEN NEXT.

      /* Adds to the left side and handle array junk... */
      RUN adecomm/_collaps.p ({&CurLeft}:HANDLE, cTemp).

      /* Select the cTemp value, making sure it's in view. */
      /* RUN adecomm/_scroll.p ({&CurLeft}:HANDLE, INPUT cTemp). */
    END.

    DO j = {&Sort} TO {&Options}:
      IF ((NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}) = 1)
        AND NUM-ENTRIES (whRight [j]:LIST-ITEMS, ".") > 1) 
        AND INDEX(whRight [j]:LIST-ITEMS,"(":U) = 0 THEN DO:
    cTemp = whRight [j]:LIST-ITEMS.  
        DO i = 1 to NUM-ENTRIES (cTemp, {&Sep1}):
          ASSIGN ENTRY(i,cTemp,{&Sep1}) = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cTemp,{&Sep1}),"."), 
                                            ENTRY(i,cTemp,{&Sep1}),".")
                 ENTRY(i,cMoreData[j],{&Sep1}) = ENTRY(NUM-ENTRIES(
                                            ENTRY(i,cMoreData[j],{&Sep1}),"."), 
                                            ENTRY(i,cMoreData[j],{&Sep1}),".")
                 .
        END.  /* Do i = 1 to NUM-ENTRIES */
        whRight [j]:LIST-ITEMS = cTemp.
      END.
    END.  /* DO iTEMP = 1 to NUM-ENTRIES of cFldName */ 
  END.  /* DO WITH FRAME DIALOAG-1 */
END.  /* End Procedure */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE FieldFormat.ip:

DEFINE INPUT PARAMETER cList AS CHARACTER.

DEFINE VARIABLE cFormat AS CHARACTER.
DEFINE VARIABLE counter AS INTEGER.

DO WITH FRAME dialog-1:

  IF cList = ? OR NUM-ENTRIES(cList,{&Sep1}) <> 1 THEN DO:
    ASSIGN
      eFieldLabel:SENSITIVE     = FALSE
      eFieldFormat:SENSITIVE    = FALSE
      bFieldFormat:SENSITIVE    = FALSE
      eFieldLabel:SCREEN-VALUE  = ""
      eFieldFormat:SCREEN-VALUE = "".
    RETURN.
  END.

  /* 
  ** Get the current Label and if it is NOT set get the label's value
  ** from the data base
  */
  IF (ENTRY (2, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}) = "") THEN
    RUN DB_Field.ip (cList, "LABEL", OUTPUT cTemp).
  ELSE
    cTemp = ENTRY (2, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}).

  eFieldLabel:SCREEN-VALUE  = REPLACE (cTemp, "!", CHR(10)).
  /* 
  ** Get the currenet Format and if it is NOT set get the Format's value
  ** from the data base
  */
  IF (ENTRY (3, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}) = "") THEN
  DO:
    RUN DB_Field.ip (cList, "FORMAT", OUTPUT cTemp).
    DO counter = 2 TO NUM-ENTRIES (cTemp):
      IF (counter = 2) THEN
        cFormat = ENTRY (counter, cTemp).
      ELSE
        cFormat = cFormat + "," + ENTRY (counter, cTemp).
    END.
    eFieldFormat:SCREEN-VALUE = cFormat. /* DB_Field returns TYPE,FORMAT */
  END.
  ELSE
    eFieldFormat:SCREEN-VALUE = 
      ENTRY (3, ENTRY (LOOKUP (cList, {&CurRight}:LIST-ITEMS, {&Sep1}), 
               {&CurData}, {&Sep1}), {&sep2}).
   
  ASSIGN                              
    eFieldLabel:SENSITIVE     = TRUE
    eFieldFormat:SENSITIVE    = TRUE
    bFieldFormat:SENSITIVE    = TRUE
    .
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE ValueChangeRight.ip:
DEFINE VARIABLE cSelection AS CHARACTER NO-UNDO.

DO WITH FRAME dialog-1: 
  {&CurLeft}:SCREEN-VALUE   = "".    

  IF {&Table-Mode} THEN DO:
     /*
     ** For Tables do these steps (don't allow select of <external> tables
     */      
     cSelection = "".
     DO i = 1 TO NUM-ENTRIES(SELF:SCREEN-VALUE, {&Sep1}):
       cTemp = ENTRY(i, SELF:SCREEN-VALUE, {&Sep1}).
       IF NUM-ENTRIES(cTemp," ") eq 1 OR CAN-DO("OF,WHERE":U,ENTRY(2,cTemp," "))
       THEN cSelection = cSelection 
                       + (IF cSelection ne "" THEN {&Sep1} ELSE "") + cTemp. 
     END.
   END.        
   
  /*
  ** Make these assigns all the time
  */
  ASSIGN 
    cTemp   = SELF:SCREEN-VALUE
    sIndex  = cTemp
    {&CurLeft}:SCREEN-VALUE = "".

  RUN adeshar/_qset.p ("setUpDown",application,TRUE).

  /*
  ** For Sorts, do these steps
  */
  IF {&Sort-Mode} THEN DO:
    RUN CheckSelect.ip (OUTPUT i).
    rsSortDirection:SENSITIVE = i > 0.
    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
    ASSIGN eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
  
  /*
  ** For Fields, do these steps
  */
  ELSE IF {&Options-Mode} THEN 
    RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).  
  END.
END.


/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE ValueChangeLeft.ip:
  DO WITH FRAME dialog-1: 
    ASSIGN
      {&CurRight}:SCREEN-VALUE = ""
      lPasted                  = FALSE.

    RUN adeshar/_qset.p ("setUpDown":u,application,TRUE).

    CASE rsMain:SCREEN-VALUE:
      WHEN "{&Options}":u THEN
        RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).       
      WHEN "{&Where}":u THEN 
        RUN LeftWhere.ip (TRUE).
    END CASE. 
  END.
END.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE MoveList.ip:
  DEFINE INPUT        PARAMETER lUp        AS LOGICAL NO-UNDO.
  DEFINE INPUT        PARAMETER cValue     AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER cSeparator AS CHARACTER NO-UNDO. 
  DEFINE INPUT-OUTPUT PARAMETER cList      AS CHARACTER NO-UNDO.

  /* DEFINE VARIABLE cSeparator  AS CHARACTER NO-UNDO INIT {&Sep1}. */
  DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE j     AS INTEGER     NO-UNDO.
  
  /*  
  message 
    'MOVELIST:' skip
    'CVALUE: [' cValue    ']' skip
    'CLIST:  [' cList   ']'skip
    'CSEP:   [' cSeparator  ']'
    View-as alert-box error buttons Ok.
  */  
  
  DO WITH FRAME dialog-1:
  IF (cValue <> ?) THEN DO:
    i = LOOKUP(ENTRY(1,cValue,cSeparator),cList,cSeparator).

    DO j = 1 TO NUM-ENTRIES(cValue,cSeparator):
      ASSIGN
        ENTRY(LOOKUP(ENTRY(j,cValue,cSeparator),cList,cSeparator),
                           cList,cSeparator) = ""
        cList = TRIM(REPLACE(cList,cSeparator + cSeparator,cSeparator), 
                     cSeparator).
    END.

    ASSIGN
      cList = TRIM(cList,cSeparator)
      i = (IF lUp THEN  MAXIMUM (i - 1, 1) ELSE 
                        MINIMUM (i, NUM-ENTRIES(cList, cSeparator))).

    IF i = 0 THEN
      cList = cValue.
    ELSE DO:
      IF (lUp) THEN
        ENTRY(i,cList,cSeparator) = cValue
                                  + (IF cList = "" THEN "" ELSE cSeparator 
                                     + ENTRY(i,cList,cSeparator)).
      ELSE
        ENTRY(i,cList,cSeparator) = ENTRY(i,cList,cSeparator) 
                                  + cSeparator + cValue.
    END.
  END /* IF */ .

  END /* DO */ .
END.

/*--------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------*/

PROCEDURE pickTable.ip: 
    DEFINE INPUT        PARAMETER ip_list AS CHARACTER NO-UNDO. /* list */
    DEFINE INPUT-OUTPUT PARAMETER io_pick AS CHARACTER NO-UNDO. /* value */ 
 
    DEFINE VARIABLE DecoupleFlg AS LOGICAL INIT FALSE.


    FORM
        SKIP ({&TFM_WID})
        SPACE({&HFM_WID}) 
  
    v_pick 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 32 INNER-LINES 10 
    SKIP

    {adecomm/okform.i
    &BOX    = "RECT-4"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"}
  
    WITH FRAME fr_pick NO-ATTR-SPACE NO-LABELS DEFAULT-BUTTON bOK 
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
    TITLE winTitleRelated VIEW-AS DIALOG-BOX
    &else
    NO-BOX
    &endif
    .

    {adecomm/okrun.i  
        &FRAME  = "FRAME fr_pick" 
        &BOX    = "rect-4"
        &OK     = "bOK" 
        &CANCEL = "bCancel" }
    
    {adeuib/ide/dialoginit.i "Frame fr_pick:handle"}
     
    ON DEFAULT-ACTION OF v_pick IN FRAME fr_pick 
        APPLY "GO" TO FRAME fr_pick.

    DO WITH FRAME dialog-1:
  
        /*
        ** Check to see if this is the first entry that isn't an external table 
        */  
        IF NUM-ENTRIES(whRight[{&Table}]:LIST-ITEMS,{&Sep1}) > iXternalCnt THEN 
        DO:  
            IF ENTRY(iXternalCnt + 1,whRight[{&Table}]:LIST-ITEMS,{&Sep1}) = 
                whRight[{&Table}]:SCREEN-VALUE THEN
            DecoupleFlg = TRUE.
        END.

        ASSIGN
            v_pick:DELIMITER  IN FRAME fr_pick   = {&Sep1}
            v_pick:LIST-ITEMS IN FRAME fr_pick   = IF DecoupleFlg 
                                                   THEN "(None)" + {&Sep1} + ip_list  
                                                   ELSE ip_list
            v_pick:SCREEN-VALUE IN FRAME fr_pick = 
                    (IF LOOKUP(io_pick,ip_list,{&Sep1}) > 0 
                     THEN io_pick ELSE 
                     ENTRY(1, ip_list, {&Sep1})) 
            io_pick = ?.
         &scoped-define CANCEL-EVENT U3
        {adeuib/ide/dialogstart.i bOk bCancel winTitleRelated}
         
        ENABLE v_pick bOk bCancel WITH FRAME fr_pick.
        
        DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
            &if DEFINED(IDE-IS-RUNNING) = 0  &then
            WAIT-FOR GO OF FRAME fr_pick FOCUS v_pick IN FRAME fr_pick.
            &ELSE
            WAIT-FOR GO OF FRAME fr_pick 
                  OR "U3" OF THIS-PROCEDURE FOCUS v_pick IN FRAME fr_pick.
            if canceldialog then 
               undo, leave.       
            &ENDIF
            
            io_pick = v_pick:SCREEN-VALUE IN FRAME fr_pick.   
        END.

        HIDE FRAME fr_pick NO-PAUSE.
    END.
END PROCEDURE. /* pick_a_table.ip */

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE Join.ip:

DEFINE INPUT PARAMETER cInsert   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER lOperator AS LOGICAL NO-UNDO.

DO WITH FRAME dialog-1:

  FIND LAST ttWhere WHERE INTEGER(rsMain:SCREEN-VALUE) = ttWhere.iState
    AND lLeft:SCREEN-VALUE = ttWhere.cTable.

  i = ttWhere.iSeq.
  /* If text selected, merely replace and return.  CURSOR-OFFSET is in
     column units, not characters, so we use RAW -dma */
  IF eDisplayCode:SELECTION-TEXT <> "" THEN
    ASSIGN
      lOK = eDisplayCode:REPLACE-SELECTION-TEXT(cInsert).
  ELSE IF (ttWhere.iOffset > 1 AND
           ttWhere.iOffset < LENGTH(ttWhere.cExpression,"RAW":u)) THEN
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = SUBSTRING(ttWhere.cExpression,1,
                                     ttWhere.iOffset - 1,"RAW":u)
                                 + cInsert 
                                 + SUBSTRING(ttWhere.cExpression,
                                     ttWhere.iOffset,-1,"RAW":u)
      eDisplayCode:CURSOR-OFFSET = ttWhere.iOffset 
                                 + LENGTH(cInsert,"RAW":u)
      lWhState                   = ttWhere.lWhState
      .

  ELSE
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = 
        (IF (eDisplayCode:SCREEN-VALUE = "" 
           OR eDisplayCode:SCREEN-VALUE = ? ) THEN cInsert 
         ELSE eDisplayCode:SCREEN-VALUE +
               (IF CAN-DO("AND,OR":U,cInsert) THEN CHR(10) + "  " 
                                             ELSE " ") + cInsert)

      eDisplayCode:CURSOR-OFFSET = LENGTH(eDisplayCode:SCREEN-VALUE,"RAW":u) + 1
      .

  CREATE ttWhere.

  ASSIGN
    /*
    eDisplayCode:SENSITIVE     = (IF eDisplayCode:SCREEN-VALUE > "" THEN TRUE 
                                  ELSE FALSE)
    */
    ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
    ttWhere.cTable             = lLeft:SCREEN-VALUE 
    ttWhere.iSeq               = i + 1
    ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
    ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
    ttWhere.lOperator          = lOperator
    ttWhere.lWhState           = lWhState
    {&CurRight}:PRIVATE-DATA   = eDisplayCode:SCREEN-VALUE 
    {&CurLeft}:SCREEN-VALUE    = ""
    {&CurRight}:SCREEN-VALUE   = ""
    {&CurLeft}:SENSITIVE       = ttWhere.lOperator
    {&CurRight}:SENSITIVE      = ttWhere.lOperator
    bUndo:SENSITIVE            = TRUE
    bCheckSyntax:SENSITIVE     = TRUE
    acJoin [LOOKUP ({&CurTable}, eCurrentTable:List-Items, {&Sep1}) +
           (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)] = ttWhere.cExpression
    .

  RUN adeshar/_qset.p ("SetOperatorsSensitive.ip":u,application,NOT lOperator).

  END.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE LeftWhere.ip:
  DEFINE INPUT PARAMETER lSelect AS LOGICAL NO-UNDO. 

DO WITH FRAME dialog-1:

  DEFINE VARIABLE cTemp      AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE sTemp      AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE cMatchName AS CHARACTER NO-UNDO. /* fieldname pattern match */
  /*DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO. /* selected field name */*/

  FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState
                      AND lLeft:SCREEN-VALUE            = ttWhere.cTable.
     
  ASSIGN
    i          = ttWhere.iSeq
    cTemp      = TRIM(eDisplayCode:SCREEN-VALUE)
    sTemp      = TRIM({&CurLeft}:SCREEN-VALUE).

  /* calc field in Results */
  IF {&Where-Mode} AND application = "Results_Where":u 
    AND sTemp MATCHES "*(*)" THEN 
    ASSIGN
      res_calcfld = TRUE
      cFieldName  = TRIM(SUBSTRING(sTemp,1,INDEX(sTemp,"(":u) - 1,"CHARACTER":u))
      .
  ELSE
    ASSIGN
      res_calcfld = FALSE
      cFieldName  = lLeft:SCREEN-VALUE + "." + sTemp /* whLeft */
      .

  /* If this is a value-change sensitize the operators and leave */
  IF lSelect THEN DO:
    RUN load_ops.
    eCurrentTable:SENSITIVE = FALSE.
    RETURN.
  END.

  /* From here down, we're dealing with double-click (pasted) case */
  
  /* if text selected, merely replace and return */
  IF eDisplayCode:SELECTION-TEXT <> "" THEN
    lOK = eDisplayCode:REPLACE-SELECTION-TEXT (cFieldName).
  ELSE DO:
    /* If picking field name, check to see if it should replace the last
       field name selected in the editor widget.
    */
    IF res_calcfld THEN
      cMatchName = cFieldName.
    ELSE
      RUN guess_field (OUTPUT cMatchName). /* do NOT put into cLastField */

    IF cMatchName <> ? AND (cTemp = cMatchName
      OR cTemp MATCHES "*":u + CHR(10) + " AND ":u + cMatchName
      OR cTemp MATCHES "*":u + CHR(10) + " OR ":u  + cMatchName) THEN DO:
      cTemp = TRIM(SUBSTRING(" ":u + cTemp,1,R-INDEX(CHR(10) + cTemp,CHR(10)),
                             "CHARACTER":u)).
    END.
   
    IF (ttWhere.iOffset > 1 
       AND ttWhere.iOffset < LENGTH(ttWhere.cExpression,"RAW":u)) THEN
       ASSIGN
         eDisplayCode:SCREEN-VALUE  = SUBSTRING(ttWhere.cExpression,1,
                                        ttWhere.iOffset - 1,"RAW":u)
                                    + cFieldName 
                                    + SUBSTRING(ttWhere.cExpression,
                                        ttWhere.iOffset,-1,"RAW":u)
         eDisplayCode:CURSOR-OFFSET = ttWhere.iOffset 
                                    + LENGTH(cFieldName,"RAW":u)
         lWhState                   = ttWhere.lWhState
         .
    ELSE
    ASSIGN
      eDisplayCode:SCREEN-VALUE = 
        (IF cTemp = "" THEN "" ELSE cTemp + " ":U) +
        (IF NOT tAskRun THEN cFieldName ELSE '') /* dma */

      eDisplayCode:CURSOR-OFFSET = LENGTH(eDisplayCode:SCREEN-VALUE,"RAW":u) + 1
      .
  END.

  CREATE ttWhere.
  ASSIGN
    cLastField                 = cFieldName
    ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
    ttWhere.cTable             = lLeft:SCREEN-VALUE
    ttWhere.iSeq               = i + 1
    ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
    ttWhere.cLastField         = cLastField 
    ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
    ttWhere.lWhState           = lWhState
    {&CurLeft}:SCREEN-VALUE    = ""
    {&CurRight}:SCREEN-VALUE   = ""
    {&CurLeft}:SENSITIVE       = ttWhere.lOperator
    {&CurRight}:SENSITIVE      = ttWhere.lOperator
    bCheckSyntax:SENSITIVE     = TRUE
    bUndo:SENSITIVE            = TRUE
    acWhere[LOOKUP({&CurTable},eCurrentTable:LIST-ITEMS,
       {&Sep1}) + iXternalCnt] = ttWhere.cExpression
    .
  RUN load_ops.

  /*
   * Load_ops changes the cLastField. Since this op is putting
   * a field into the editor, set it to the one we want it to
   * be, not what load_ops guesses at what it is.
   */
  cLastField = cFieldName.
END.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
/* try to get the last field listed in the expert window */

PROCEDURE guess_field:
  DEFINE OUTPUT PARAMETER cFieldTarget AS CHARACTER NO-UNDO. /* potential field */
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO. /* return value */
  DEFINE VARIABLE cTemp   AS CHARACTER NO-UNDO.  /* Scratch variable */
  DEFINE VARIABLE lHiden  AS LOGICAL   NO-UNDO. 

DO WITH FRAME dialog-1:

  ASSIGN
    cfieldtarget = trim(edisplaycode:SCREEN-VALUE ,
            " ,()=<>":u + CHR(9) + CHR(10) + CHR(13))
    cFieldTarget = 
      (IF cFieldTarget = "" THEN ? ELSE 
         ENTRY(NUM-ENTRIES(cFieldTarget, " ":u), cFieldTarget, " ":u))
    cFieldTarget = 
      (IF {&CurLeft}:SCREEN-VALUE <> ? THEN 
         lLeft:SCREEN-VALUE + "." + {&CurLeft}:SCREEN-VALUE 
       ELSE cFieldTarget).   

  IF NUM-ENTRIES(cFieldTarget,".":u) <> 3 THEN .
  ELSE IF lHiden THEN DO:
    /* if only one db available, quicker to search ourselves. */
    FIND FIRST DICTDB._Db NO-LOCK.
    IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
      FIND DICTDB._File OF DICTDB._Db
        WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
              DICTDB._File._File-name = ENTRY(2,cFieldTarget,".":u)
        NO-LOCK NO-ERROR.
    ELSE
      FIND DICTDB._File OF DICTDB._Db
        WHERE DICTDB._File._File-name = ENTRY(2,cFieldTarget,".":u)
        NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._File THEN
      FIND DICTDB._Field OF DICTDB._File
        WHERE DICTDB._Field._Field-name = ENTRY(3,cFieldTarget,".":u)
        NO-LOCK NO-ERROR.
    ELSE
      RELEASE DICTDB._Field. /* just in case... */
    IF NOT AVAILABLE DICTDB._Field THEN cFieldTarget = ?.
  END.
  ELSE DO:
    /* but if more than one db connected, call professional help. */
    cTemp = cLastField.
    IF ENTRY(1,cLastField,".":U) = "Temp-Tables" THEN DO:
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cLastField,".":U).
      cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
              ENTRY(3,cLastField,".").
    END.
    ELSE IF NUM-ENTRIES(cLastField,".":U) > 1 THEN DO: /* Perhaps a buffer */
      FIND FIRST _tt-tbl WHERE
           _tt-tbl.tt-name = ENTRY(1,cLastField,".":U) NO-ERROR.
      IF AVAILABLE _tt-tbl THEN 
        cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                ENTRY(2,cLastField,".").
    END.

    RUN adecomm/_y-schem.p (cTemp,"","",OUTPUT cAnswer).
    IF cAnswer = ? THEN cFieldTarget = ?.
  END.
  
  END.
END PROCEDURE. /* guess_field */

/*--------------------------------------------------------------------------*/
/* load up appropriate comparison operators into qbf-p */
PROCEDURE load_ops:

DO WITH FRAME dialog-1:
 
  DEFINE VARIABLE iExtent     AS INTEGER   NO-UNDO. /* extent */
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE cListItems  AS CHARACTER NO-UNDO. /* LIST-ITEMS string */
  DEFINE VARIABLE cDataType   AS CHARACTER NO-UNDO. /* datatype */
  DEFINE VARIABLE cFormat     AS CHARACTER NO-UNDO. /* format */
  DEFINE VARIABLE cGuessField AS CHARACTER NO-UNDO. /* guessed field name */
  DEFINE VARIABLE cTemp       AS CHARACTER NO-UNDO. /* Scratch variable */
  DEFINE VARIABLE lQBW        AS LOGICAL   NO-UNDO. /* is qbw field? */

  IF res_calcfld THEN
    cGuessField = cFieldName.
  ELSE
    RUN guess_field (OUTPUT cGuessField). /* returns ? for unknown field */

  IF NUM-ENTRIES(cGuessField," ":U) > 1 THEN
    cGuessField = ENTRY(NUM-ENTRIES(cGuessField," ":U),
                                    cGuessField," ":U).
  cLastField = (IF cGuessField = ? THEN cLastField ELSE cGuessField).
  cLastField = (IF cLastField <= "" OR cLastField = ? THEN 
                lLeft:SCREEN-VALUE + "." + {&CurLeft}:SCREEN-VALUE
                ELSE cLastField ).

  IF _AliasList > "" AND NOT res_calcfld THEN DO:
    IF (NUM-ENTRIES (cLastField, ".") < 3) THEN 
      ENTRY(1,cLastField,".":u) = _AliasList.
    ELSE
      ENTRY(2,cLastField,".":u) = ENTRY(NUM-ENTRIES(_AliasList,".":u),
                                        _AliasList,".":u).
  END.

  IF (cCurrentDb <= "" ) THEN cCurrentDb = LDBNAME(1).

  IF cLastField <> ? AND cLastField <> "" THEN DO:
    IF res_calcfld THEN DO:
      RUN aderes/_calctyp.p (cGuessField,OUTPUT cDataType,OUTPUT cFormat).

      ASSIGN
        iExtent = 0
        lQBW    = FALSE.
    END.
    ELSE DO:
      IF (NUM-ENTRIES (cLastField, ".") < 3) AND
         NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(1,cLastField,".":U))
        THEN /* Normal db table */
       RUN adecomm/_y-schem.p (cCurrentDb + ".":u + cLastField,"","",
                                     OUTPUT cListItems).
      ELSE DO: /* Else a temp-table or buffer */
        cTemp = cLastField.
        IF cCurrentDB = "Temp-Tables" THEN DO:
          IF ENTRY(1,cLastField,".":U) = "Temp-Tables":U THEN DO: /* A temp-table */
            FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cLastField,".":U).
            cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                    ENTRY(3,cLastField,".").
          END. /* A temp-table */
          ELSE DO: /* Probably a buffer */
            FIND FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(1,cLastField,".":U) NO-ERROR.
            IF AVAILABLE _tt-tbl THEN
              cTemp = _tt-tbl.like-db + ".":U + _tt-tbl.like-table + ".":U +
                      ENTRY(2,cLastField,".").
          END. /* Probably a buffer */
        END.  /* If current db is the virtual temp-table database */
        RUN adecomm/_y-schem.p (cTemp,"","",OUTPUT cListItems).
      END. /* Else a temp-table or buffer */

      ASSIGN cDataType = ENTRY(1,cListItems)
             iExtent   = INTEGER(ENTRY(2,cListItems))
             lQBW      = (ENTRY(4,cListItems) = "y":u).
    END.
  END.

  cListItems = "".

  /* if data type is datetime or datetime-tz, then set it to date */
  IF CAN-DO("34,40",cDataType) THEN
      cDataType = "2".

  /*if data type is INT64, then set it to integer*/
  IF cDataType = "41" THEN
      cDataType = "4".

  /* If field name is unknown, load up everything. */
  /* If selection-text non-null and guess_field = ?, load up everything. */
  DO i = 1 TO EXTENT(acWhereState):
    IF   /* (cLastField = ?) 
      OR */ (cGuessField = ? AND eDisplayCode:SELECTION-TEXT <> "")
      OR (INDEX(ENTRY(1,acWhereState[i]),"q":u) > 0 AND lQBW)
      OR (INDEX(ENTRY(1,acWhereState[i]),cDataType) > 0) THEN
    CASE i:
      WHEN {&bEqual}        THEN bEqual:SENSITIVE        = TRUE.
      WHEN {&bNotEqual}     THEN bNotEqual:SENSITIVE     = TRUE.
      WHEN {&bLess}         THEN bLess:SENSITIVE         = TRUE.
      WHEN {&bGreater}      THEN bGreater:SENSITIVE      = TRUE.
      WHEN {&bLessEqual}    THEN bLessEqual:SENSITIVE    = TRUE.
      WHEN {&bGreaterEqual} THEN bGreaterEqual:SENSITIVE = TRUE.
      WHEN {&bBegins}       THEN bBegins:SENSITIVE       = TRUE.
      WHEN {&bMatches}      THEN bMatches:SENSITIVE      = TRUE.
      WHEN {&bRange}        THEN bRange:SENSITIVE        = TRUE.
      WHEN {&bList}         THEN bList:SENSITIVE         = TRUE.
      WHEN {&bContains}     THEN bContains:SENSITIVE     = TRUE.
      WHEN {&bAnd}          THEN bAnd:SENSITIVE          = TRUE.
      WHEN {&bOr}           THEN bOr:SENSITIVE           = TRUE.
    END CASE.
  ELSE
    CASE i:
      WHEN {&bEqual}        THEN bEqual:SENSITIVE        = FALSE.
      WHEN {&bNotEqual}     THEN bNotEqual:SENSITIVE     = FALSE.
      WHEN {&bLess}         THEN bLess:SENSITIVE         = FALSE.
      WHEN {&bGreater}      THEN bGreater:SENSITIVE      = FALSE.
      WHEN {&bLessEqual}    THEN bLessEqual:SENSITIVE    = FALSE.
      WHEN {&bGreaterEqual} THEN bGreaterEqual:SENSITIVE = FALSE.
      WHEN {&bBegins}       THEN bBegins:SENSITIVE       = FALSE.
      WHEN {&bMatches}      THEN bMatches:SENSITIVE      = FALSE.
      WHEN {&bRange}        THEN bRange:SENSITIVE        = FALSE.
      WHEN {&bList}         THEN bList:SENSITIVE         = FALSE.
      WHEN {&bContains}     THEN bContains:SENSITIVE     = FALSE.
      WHEN {&bAnd }         THEN bAnd:SENSITIVE          = FALSE.
      WHEN {&bOr }          THEN bOr:SENSITIVE           = FALSE.
    END CASE.
  END.
END.
END PROCEDURE. /* load_ops */


/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE IsJoinable.ip:

  DEFINE INPUT        PARAMETER cRight    AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER cLeft     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT       PARAMETER lJoinable AS LOGICAL NO-UNDO.

  DEFINE VARIABLE cDbRight AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDbLeft  AS CHARACTER NO-UNDO.

  DO WITH FRAME dialog-1:

    /* First, worry about any Aliases */ 
    IF (cCurrentDb <= "" ) THEN cCurrentDb = LDBNAME(1).

    IF NUM-ENTRIES(_AliasList) = 3 AND ENTRY(3, _AliasList) <> "" THEN
        cLeft = ENTRY(3, _AliasList).
    IF ENTRY(1, _AliasList) <> "" THEN cRight = ENTRY(1, _AliasLIst).
    IF NUM-ENTRIES (cRight, ".") = 1 THEN cDbRight  = cCurrentDb + "." + cRight.
                                     ELSE cDbRight  = cRight.
    IF NUM-ENTRIES (cLeft, ".") = 1 THEN cDbLeft  = cCurrentDb + "." + cLeft.
                                    ELSE cDbLeft  = cLeft.
    IF cCurrentDB = "Temp-Tables":U THEN DO:
      /* External tables can get confused with temp-tables */
      IF NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBLeft,".":U))
      THEN ENTRY(1,cDBLeft,".":U) = LDBNAME(1).
      IF NOT CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBRight,".":U))
      THEN ENTRY(1,cDBRight,".":U) = LDBNAME(1).
    END.  /* cCurrentDB is Temp-Tables */

    /* If dealing with temp-tables or buffer then use like things instead */
    IF cDBLeft BEGINS "Temp-Tables." THEN DO:
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBLeft,".":U).
      cDBLeft = _tt-tbl.like-db + ".":U + _tt-tbl.like-table.
    END. /* If a temp-table */
    
    IF cDBRight BEGINS "Temp-Tables." THEN DO:
      FIND _tt-tbl WHERE _tt-tbl.tt-name = ENTRY(2,cDBRight,".":U).
      cDBRight = _tt-tbl.like-db + ".":U + _tt-tbl.like-table.
    END.

    RUN adecomm/_j-test.p (cDbLeft, cDbRight, OUTPUT lOK).
    IF NOT lOK THEN
      RUN adecomm/_j-test.p (cDbRight, cDbLeft, OUTPUT lOK).
    lJoinable = lOk.
    IF lJoinable AND {&Join-Mode} THEN DO:
      RUN adeshar/_qset.p ("SetJoinOperatorsSensitive.ip":U,
                            application, tJoinable).
      ASSIGN whLeft[{&Join}]:SENSITIVE = tJoinable
             whRight[{&Join}]:SENSITIVE = tJoinable.
    END.  /* IF lJoinable AND Join-Mode */
  END. /* DO WITH FRAME dialog-1 */
END PROCEDURE. 

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
 returns TRUE if syntax error 
-------------------------------------------------------------*/
PROCEDURE SetCustJoin.ip:
  DO WITH FRAME dialog-1:
  
    IF (lLeft:SCREEN-VALUE > "") THEN DO:
      RUN IsJoinable.ip (lLeft:SCREEN-VALUE, lRight:SCREEN-VALUE,
                         OUTPUT lOK).
      ASSIGN tJoinable:visible = lOK.
      IF NUM-ENTRIES({&CurTable}," ":U) > 1 THEN DO: 
        IF (ENTRY (2, {&CurTable}, " ") = "OF") THEN DO:
          /** Change to WHERE **/
          tJoinable:CHECKED = FALSE.
          APPLY "ENTRY" TO tJoinable.
        END.
        ELSE tJoinable:CHECKED = TRUE.
      END. /* If the tables have a natural join */
      IF NOT tJoinable:VISIBLE THEN
        ASSIGN whLeft[{&Join}]:SENSITIVE  = TRUE
               whRight[{&Join}]:SENSITIVE = TRUE
               eDisplayCode:READ-ONLY     = FALSE
               eDisplayCode:BGCOLOR       = ?.
      ELSE DO:
        ASSIGN whLeft[{&Join}]:SENSITIVE  = tJoinable:CHECKED
               whRight[{&Join}]:SENSITIVE = tJoinable:CHECKED
               eDisplayCode:READ-ONLY     = NOT tJoinable:CHECKED.
        IF tJoinable:CHECKED THEN 
          ASSIGN eDisplayCode:BGCOLOR  = ?.
      END.
    END. 
  END. 
END PROCEDURE. 

/* -----------------------------------------------------------
  Purpose:     RadioSetEnable.ip  
  Parameters:  <none>
  Notes:       Enable/Disable the radio set at the top of the
               screen based on the number of tables selected. 
               We only need to do this if we have changed the
               state of the flag: lNo_Tables.    
-------------------------------------------------------------*/
PROCEDURE RadioSetEnable.ip:  
 
  DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cButton   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cList     AS CHARACTER NO-UNDO 
    INITIAL "Join,Where,Options,Sort":u.
  DEFINE VARIABLE NoEntries AS INTEGER   NO-UNDO. 

  /*
  ** Note: this procedure turns on and off the radio set items that
  ** control the QB's state.  It's very important to disable states that
  ** don't make any sense to avoid 'ENTRY n not found ...' errors that
  ** occur when a join is attempted with one table, for example.
  ** Rewritten by R. Ryan 8/94.
  */
   
  DO WITH FRAME dialog-1:  
    IF Application <> "{&UIB_SHORT_NAME}" THEN RETURN. /* i.e don't do this for Results */
    
    NoEntries = NUM-ENTRIES(whRight[{&Table}]:LIST-ITEMS,{&Sep1}).

    IF NoEntries = 0 OR 
       NoEntries = ? OR
       iXternalCnt >= NoEntries
    THEN DO: 
      /*
      ** No tables are selected or the only tables selected are external 
      ** ones, then disable all valid buttons
      */                                   
      DO ix = 1 TO NUM-ENTRIES(cList):  
        cButton = ENTRY(ix, cList).
        IF CAN-DO (pcValidStates, cButton)
        THEN lConstant = rsMain:DISABLE(cButton) NO-ERROR.
      END.
    END.
    
    ELSE DO:
      /*
      ** Enable everything. Do Special cases for the "Join" and
      ** "Sort" buttons.
      */ 
      IF CAN-DO (pcValidStates, "Join":U) THEN DO:
        /* Don't enable the Join button if there is only one table
           and nothing to join it to. */
        IF (iXternalCnt = 0 AND NoEntries = 1) OR 
           (NoEntries <= iXternalCnt)
        THEN lConstant = rsMain:DISABLE("Join":U) NO-ERROR.
        ELSE lConstant = rsMain:ENABLE("Join":U) NO-ERROR.
      END.
      IF CAN-DO (pcValidStates, "Sort":U) THEN DO:       
        /* If there is a SortBy-Phrase, don't allow user to go to
           Sort Page. */
        IF tSortByPhrase
        THEN lConstant = rsMain:DISABLE("Sort":U) NO-ERROR.
        ELSE lConstant = rsMain:ENABLE("Sort":U) NO-ERROR. 
      END.
      /* Do the other pages. */
      DO ix = 2 TO NUM-ENTRIES(cList) - 1:   
        cButton = ENTRY(ix, cList).
        IF CAN-DO (pcValidStates, cButton)     
        THEN lConstant = rsMain:ENABLE(cButton) NO-ERROR.
      END.
    END.

   IF NoEntries NE ? THEN 
      b_fields:SENSITIVE = b_fields:VISIBLE AND NoEntries > iXternalCnt.
    ELSE b_fields:SENSITIVE = FALSE.
  END.  
  
END PROCEDURE. 

/* quryproe.i - end of file */
procedure ChooseFields:
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
        dialogService:SetCurrentEvent(this-procedure,"DoChooseFields").
        run runChildDialog in hOEIDEService (dialogService) .
     &else
        run DoChooseFields.
     &endif
     
end procedure.

procedure DoChooseFields:
  DEFINE VARIABLE tblst        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tmptblnm     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
  
  /* Get current list of tables including external tables */
  DO i = 1 TO {&TableRight}:NUM-ITEMS:
    ASSIGN tmptblnm = ENTRY(1,ENTRY(i,{&TableRight}:LIST-ITEMS,{&SEP1}), " ")
           tblst    = tblst + (IF i > 1 THEN "," ELSE "") +
                     (IF NUM-ENTRIES(tmptblnm,".") = 1 THEN
                       (IF CAN-FIND(FIRST _tt-tbl WHERE _tt-tbl.tt-name = tmptblnm)
                          THEN "Temp-Tables":U ELSE LDBNAME(1)) + "." ELSE "") +
                        tmptblnm.
  END.
  /* send the table list or a SmartData handle */
  &if DEFINED(IDE-IS-RUNNING) <> 0  &then
  RUN adeuib/ide/_dialog_coledit.p (INPUT tblst, INPUT ?).
  &else
  RUN adeuib/_coledit.p (INPUT tblst, INPUT ?).
  &endif
  ASSIGN plVisitFields  = NO.
end.
  
&ENDIF /* _query.p - end of file  (and end of &IF..ne "TTY") */

