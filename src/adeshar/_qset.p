/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _qset.p

Description:
  This procedure sets various states in the query builder. 

INPUT Parameters 
  cFunction - 
  lParam -

OUTPUT Parameters - none

Author: Greg O'Connor

Date Created: 3/23/93

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adeshar/quryshar.i}
{adecomm/tt-brws.i}     
{adeshar/qurydefs.i}
{adeuib/brwscols.i}

DEFINE INPUT PARAMETER cFunction   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER application AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER lParam      AS LOGICAL   NO-UNDO.

/* Rather than include {adeuib/sharvars.i} only define _query-u-rec */
DEFINE SHARED VARIABLE _query-u-rec AS RECID         NO-UNDO.
DEFINE VARIABLE tt-info             AS CHARACTER     NO-UNDO.

IF CAN-FIND(FIRST _tt-tbl) THEN DO:
  FOR EACH _tt-tbl:
    tt-info = tt-info + ",":U + _tt-tbl.like-db + ".":U + _tt-tbl.like-table +
              "|":U + (IF _tt-tbl.tt-name = _tt-tbl.like-table
                       THEN "?":U ELSE _tt-tbl.tt-name) +
              "|":U + _tt-tbl.table-type.
  END.
  tt-info = LEFT-TRIM(tt-info,",":U).
END.
ELSE tt-info = ?.

CASE TRIM(cFunction):
  WHEN "setLeftRight"                  THEN 
    RUN setLeftRight.
  WHEN "setComboBox"                   THEN 
    RUN setComboBox (lParam).
  WHEN "setComboBoxQuery"              THEN 
    RUN setComboBoxQuery (lParam).
  WHEN "setUpDown"                     THEN 
    RUN setupDown.
  WHEN "SetOperatorsVisible.ip"        THEN 
    RUN SetOperatorsVisible.ip (lParam).
  WHEN "SetJoinOperatorsVisible.ip"    THEN 
    RUN SetJoinOperatorsVisible.ip (lParam).
  WHEN "SetOperatorsSensitive.ip"      THEN 
    RUN SetOperatorsSensitive.ip (lParam).
  WHEN "SetJoinOperatorsSensitive.ip"  THEN 
    RUN SetJoinOperatorsSensitive.ip (lParam).
  WHEN "SetQueryTune"  THEN 
    RUN SetQueryTune.ip.
  OTHERWISE
    MESSAGE "A call was made to {&FILE-NAME} with function " 
      cFunction SKIP "which is not defined."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END CASE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE setLeftRight:
  DO WITH FRAME dialog-1:
    ASSIGN
      whRight [{&Table}]:VISIBLE   = FALSE
      whRight [{&Join}]:VISIBLE    = FALSE
      whRight [{&Where}]:VISIBLE   = FALSE
      whRight [{&Sort}]:VISIBLE    = FALSE
      whRight [{&Options}]:VISIBLE = FALSE
      whLeft [{&Table}]:VISIBLE    = FALSE
      whLeft [{&Join}]:VISIBLE     = FALSE
      whLeft [{&Where}]:VISIBLE    = FALSE
      whLeft [{&Sort}]:VISIBLE     = FALSE
      whLeft [{&Options}]:VISIBLE  = FALSE
      {&CurLeft}:VISIBLE           = TRUE
      {&CurRight}:VISIBLE          = rsMAIN:SCREEN-VALUE <> "{&Where}":u
    .
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE setComboBox: 
  DEFINE INPUT PARAMETER lInit AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE calcFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db-recid     AS RECID     NO-UNDO.
  DEFINE VARIABLE expExtent    AS INTEGER   NO-UNDO INITIAL 1.
  DEFINE VARIABLE has-tables   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ix           AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE ldummy       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE num-qlfrs    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE rID          AS RECID.
  DEFINE VARIABLE thisEntry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisDb       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisTable    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisField    AS CHARACTER NO-UNDO.
  
  DO WITH FRAME dialog-1:   
    IF {&Where-Mode} OR {&Join-Mode} THEN expExtent = 2.

    IF {&Table-Mode} THEN DO: 
      IF ({&CurLeft}:PRIVATE-DATA = ?) THEN DO:  
        ASSIGN {&CurTable} = IF {&CurRight}:LIST-ITEMS = "" OR 
                                {&CurRight}:LIST-ITEMS = ? THEN 
                                    ENTRY(1, {&CurData}, {&Sep1}) 
                             ELSE IF NUM-ENTRIES({&CurRight}:ENTRY(1),".":U) > 1 AND
                                     NUM-ENTRIES({&CurRight}:ENTRY(1),".":U) < 4 THEN 
                                    ENTRY (1,{&CurRight}:ENTRY(1),".":U)
                             ELSE ENTRY (1,{&CurData},{&Sep1})                            
               eCurrentTable:LIST-ITEMS   = {&CurData} 
               eCurrentTable:SCREEN-VALUE = {&CurTable}.

        /* Try to choose a DB that has tables associated with it */
        IF eCurrentTable:SCREEN-VALUE NE "Temp-Tables":U THEN DO:
          RUN adecomm/_getdbid.p (LDBNAME(eCurrentTable:SCREEN-VALUE),
                                  OUTPUT db-recid).

          FIND DICTDB._DB WHERE RECID(DICTDB._DB) = db-recid NO-LOCK NO-ERROR.
          IF AVAILABLE DICTDB._DB THEN DO:
            IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
              has-tables = CAN-FIND(FIRST _FILE OF DICTDB._DB WHERE NOT _FILE._HIDDEN AND
                                          LOOKUP(_FILE._OWNER,"PUB,_FOREIGN":U) > 0).
            ELSE
              has-tables = CAN-FIND(FIRST _FILE OF DICTDB._DB WHERE NOT _FILE._HIDDEN).

            IF NOT has-tables THEN DO:

              DO i = 1 TO NUM-DBS:
                IF LDBNAME(i) <> eCurrentTable:SCREEN-VALUE THEN DO:
                  FIND DICTDB._DB WHERE DICTDB._DB._DB-NAME = LDBNAME(i) NO-LOCK NO-ERROR.
                  IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
                    has-tables = CAN-FIND(FIRST _FILE OF DICTDB._DB WHERE NOT _FILE._HIDDEN AND
                                                      LOOKUP(_FILE._OWNER,"PUB,_FOREIGN":U) > 0).
                  ELSE
                    has-tables = CAN-FIND(FIRST _FILE OF DICTDB._DB WHERE NOT _FILE._HIDDEN).
                 
                  IF has-tables THEN DO:
                    ASSIGN eCurrentTable:SCREEN-VALUE = LDBNAME(i)
                           eCurrentTable              = LDBNAME(i).
                  END.  /* If can find an unhidden table */
                END.  /* IF LDNAME(i) is not current SCREEN-VALUE */
              END. /* DO i = 1 to NUM-DBS */

            END.  /* If SCREEN-VALUE has not tables (typically a schema holder) */
          END.  /* If we were able to get the DICT._DB Record */
        END.  /* If not working with the Temp-Table psuedo db */

      END.  /* If Left has unknown private data */
        
      ELSE IF (lInit) THEN DO:
        ASSIGN {&CurTable}                   = {&CurLeft}:PRIVATE-DATA
               eCurrentTable:LIST-ITEMS      = {&CurData}
               eCurrentTable:SCREEN-VALUE    = {&CurTable}.
        RETURN.
      END. /* If lInit (Initializing) is true */

      ASSIGN {&CurLeft}:PRIVATE-DATA = ""
             {&CurLeft}:LIST-ITEMS   = ""
             cCurrentDb              = {&CurTable}.

      /* Make sure {&CurLeft}:PRIVATE-DATA = selected list before calling _tbllist.p;
         it uses private-data. Look at each line of the current selection and parse
         it for Database and Table. If a table is in the current Database, remove it
         from the source list.  (We do this by putting it in PRIVATE-DATA). The 
         private-data is the list of items that are NOT to be added to the list of 
         items (used in _tbllist.p).                                                 */ 
      DO i = 1 to {&CurRight}:NUM-ITEMS:
        thisEntry = ENTRY(1, {&CurRight}:ENTRY(i), " ").
        IF NUM-ENTRIES(thisEntry,".":U) > 1 THEN
          ASSIGN thisDb    = ENTRY(1,thisEntry,".":U)
                 thisTable = ENTRY(2,thisEntry,".":U).
        ELSE ASSIGN thisDb    = cCurrentDb
                    thisTable = thisEntry.                 
        IF thisDb = cCurrentDb THEN
          {&CurLeft}:PRIVATE-DATA = {&CurLeft}:PRIVATE-DATA + ",":U + thisTable.
      END.  /* DO i 1 to NUM-ITEMs on right */
 
      IF {&CurTable} NE "Temp-Tables":U THEN DO:
        /* Get the database ID and call tbllist */
        rID = ?.  
        IF (SDBNAME ({&CurTable}) <> {&CurTable}) THEN DO:
          /* CREATE ALIAS dictdb FOR DATABASE VALUE (SDBNAME ({&CurTable})). */   
          /* get the id of the database they picked */
          RUN adecomm/_getdbid.p ({&CurTable}, OUTPUT rID).
        END.
        ELSE CREATE ALIAS dictdb FOR DATABASE VALUE ({&CurTable}).

        RUN adecomm/_tbllist.p (INPUT {&CurLeft}:HANDLE,
                                INPUT NO,
                                INPUT rID,
                                INPUT "",
                                INPUT "BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE",
                                OUTPUT lParam).
      END.  /* If not the Temp-Tables psuedo db */
      ELSE DO:  /* We are dealing with the Temp-Tables psuedo db. */
        FOR EACH _tt-tbl:
          IF {&CurLeft}:PRIVATE-DATA = ? OR 
             NOT CAN-DO({&CurLeft}:PRIVATE-DATA, _tt-tbl.tt-name) THEN
            lDummy = {&CurLeft}:ADD-LAST((IF _tt-tbl.table-type = "T":U THEN
                                        "Temp-Tables.":U ELSE "":U) + _tt-tbl.tt-name).
        END.  /* For EACH _tt-tbl */
      END.  /* Else deal Temp-Tables psuedo db */

      {&CurLeft}:PRIVATE-DATA = {&CurTable}.
      RETURN.
    END.  /* End rsmain = table */
 
    IF (lInit) THEN DO:
      IF ({&CurLeft}:PRIVATE-DATA = ?) OR ({&CurLeft}:PRIVATE-DATA = "")
      THEN
        IF (whRight[{&table}]:SCREEN-VALUE > "")
        THEN
          {&CurTable} = ENTRY(1,ENTRY(1,whRight[{&table}]:SCREEN-VALUE,{&Sep1})," ").
        ELSE
          {&CurTable} = ENTRY(1,ENTRY(1,whRight[{&table}]:LIST-ITEMS,{&Sep1})," ").
      ELSE
        {&CurTable} = {&CurLeft}:PRIVATE-DATA.
      
      IF iXternalCnt = 0 THEN 
        ASSIGN eCurrentTable:LIST-ITEMS = whRight[{&table}]:PRIVATE-DATA
               {&CurTable}              = eCurrentTable:ENTRY(1).
      ELSE DO: 
        /*
         * Two possibilities: 'Field' mode includes all tables in the combo
         * box list; 'Where' and 'Sort' state inclue all non-external tables
         * in this list. R. Ryan 8/94. 
         */
        IF {&Options-Mode} THEN 
          ASSIGN eCurrentTable:LIST-ITEMS = whRight[{&table}]:PRIVATE-DATA
                 {&CurTable}              = eCurrentTable:ENTRY(iXternalCnt + 1).
        ELSE DO:            
          DO i = 1 TO iXternalCnt:     
            j = INDEX(whRight[{&table}]:PRIVATE-DATA, {&Sep1}, j + 1).
          END. /* Do i = 1 TO number of external tables */

          /* The combo-box list starts after the ith seperator in whRight
             (or it is empty is there is no ith seperator) */ 
          eCurrentTable:LIST-ITEMS = IF j = 0 THEN "" ELSE
                 SUBSTRING(whRight[{&table}]:PRIVATE-DATA,j + 1,-1,"CHARACTER":u). 

          /* Make sure CurTable is valid */
          IF eCurrentTable:LOOKUP({&CurTable}) <= 0 
             AND eCurrentTable:NUM-ITEMS > 0 THEN  
            {&CurTable} = eCurrentTable:ENTRY(1).
        END.  /* Else NOT &Options-Mode */
      END.  /* Else external table count is larger than 0 */

      /* 
      message
        'whRight[{&table}]:PRIVATE-DATA' whRight[{&table}]:PRIVATE-DATA skip
        'whLeft[{&table}]:PRIVATE-DATA'  whLeft[{&table}]:PRIVATE-DATA  skip
        '{&CurLeft}:PRIVATE-DATA'        {&CurLeft}:PRIVATE-DATA        skip
        '~{&CurData}  {&CurData}'        {&CurData}                     skip
        '~{&CurTable} {&CurTable}'       {&CurTable}                    skip
        'cMoreData[{&Table}]'            cMoreData[{&Table}]
        view-as alert-box error buttons Ok. 
      */
    END. /* init */

    /*
    ** If Sort and field have been select from the field list picker 
    ** add this option FIRST
     DRH Removed this because it forced <<Selected Fields>> in Smart Query
     7/10/95
    IF {&Sort-Mode} AND
     /* (NUM-ENTRIES (whRight [{&Field}]:LIST-ITEMS, {&Sep1}) > 0) AND */
        (ENTRY (1, eCurrentTable:LIST-ITEMS, {&Sep1}) <> {&DisFieldList})
    THEN ASSIGN {&CurTable} = {&DisFieldList}
                lOK = eCurrentTable:ADD-FIRST ({&DisFieldList}).
    */

    /* There is no change to the right selection list so we can leave. */
    /* IF ({&CurLeft}:PRIVATE-DATA = {&CurTable}) THEN RETURN. */

    ASSIGN {&CurLeft}:LIST-ITEMS   = "" 
           {&CurLeft}:PRIVATE-DATA = "".

    IF {&CurTable} = {&DisFieldList} THEN DO:  /* Populate {&CurLeft} */
      num-qlfrs = 1.  /* Number of qualifiers: 1=NM, 2=TBL.NM, 3=DB.TBL.NM */
      FOR EACH _BC WHERE _BC._x-recid = _query-u-rec BY _BC._DISP-NAME:
        num-qlfrs = MAX(num-qlfrs,NUM-ENTRIES(_BC._DISP-NAME,".")).
        IF {&CurLeft}:LOOKUP(_BC._DISP-NAME) = 0 THEN
          ldummy = {&CurLeft}:ADD-LAST(_BC._DISP-NAME).
      END. /* For each _BC */
    END.  /* If CurTable = DisFieldList */

    /*
    ** Make sure Result items are NOT in the source list.  Look at
    ** each line of the current selection and parse it for Database, Table and
    ** Field.  If a field is in the current Database.Table, remove it from the
    ** source list.  (We do this by putting it in PRIVATE-DATA).
    ** The private-data is the list of items that are NOT to be add to
    ** the list of items based on {&CurTable}.
    */    
    DO i = 1 TO {&CurRight}:NUM-ITEMS:
      thisEntry = {&CurRight}:ENTRY(i).
      IF NUM-ENTRIES(thisEntry,".":U) > 2 THEN
        ASSIGN thisDb    = ENTRY(1,thisEntry,".":U)
               thisTable = ENTRY(2,thisEntry,".":U)
               thisField = ENTRY(3,thisEntry,".":U).
      ELSE DO:
        thisDb = cCurrentDb.
        IF NUM-ENTRIES(thisEntry,".":U) > 1 THEN
          ASSIGN thisTable = ENTRY(1,thisEntry,".":U)
                 thisField = ENTRY(2,thisEntry,".":U).
        ELSE
          ASSIGN thisTable = {&CurTable}
                 thisField = thisEntry.
      END. /* Else do (not fully qualified */
      IF thisDb = cCurrentDb AND thisTable = {&CurTable} THEN 
        {&CurLeft}:PRIVATE-DATA = {&CurLeft}:PRIVATE-DATA + ",":U + thisField.

      IF {&CurTable} = {&DisFieldList} THEN DO:
        IF NUM-ENTRIES(thisEntry,".":U) NE num-qlfrs THEN /*DO:*/
          CASE num-qlfrs:
            WHEN 1 THEN lOK = {&CurRight}:REPLACE(thisField,i).
            WHEN 2 THEN lOK = {&CurRight}:REPLACE(thisTable + ".":U + thisField,i).
            WHEN 3 THEN lOK = {&CurRight}:REPLACE(thisDB + ".":U + thisTable + ".":U 
                                          + thisField,i).
          END CASE.
        /*END.*/
        FIND _BC WHERE _BC._x-recid = _query-u-rec AND _BC._DBNAME = thisDB 
                   AND _BC._TABLE = thisTable AND _BC._NAME = thisField NO-ERROR.
        IF AVAILABLE _BC THEN lOK = {&CurLeft}:DELETE(_BC._DISP-NAME).
      END. /* If CurTable = DisFieldList */
    END.  /* Do i = 1 To Number of items on the right */

    IF ({&CurTable} <> {&DisFieldList}) THEN DO:  
      IF (ENTRY(1,_AliasList) > "") THEN
        RUN adecomm/_mfldlst.p ({&CurLeft}:HANDLE,ENTRY(1,_AliasList),
                             tt-info,TRUE,"",expExtent,_CallBack,OUTPUT lOk).
      ELSE
        RUN adecomm/_mfldlst.p ({&CurLeft}:HANDLE,ENTRY(1,{&CurTable}," "),
                             tt-info,TRUE,"",expExtent,_CallBack,OUTPUT lOk).

      IF {&Where-Mode} AND application = "Results_Where":u THEN DO:
        RUN aderes/_addlist.p (OUTPUT calcFields).

        IF calcFields > "" THEN
          DO ix = 1 TO NUM-ENTRIES(calcFields):
            {&CurLeft}:LIST-ITEMS = ENTRY(ix,calcFields) +
                                    " (":u + "Calc Field" + ")":u +
                                    {&Sep1} + {&CurLeft}:LIST-ITEMS.
          END. /* If calcfields THEN DO ix = 1 to Num-entries */

        /*
        message
          application skip(1)
          "calcFields:" calcFields skip
          "list-items:" replace({&curleft}:list-items,chr(3),chr(10))
          view-as alert-box title "_qset.p #1".
        */
      END. /* If Where-Mode AND Results_where */
    END. /* IF CurTable NE DisFieldList */

    /* Clear PRIVATE-DATA after we have used it in the _mfldlst.p procedure */
    {&CurLeft}:PRIVATE-DATA = {&CurTable}. 

    /*
    ** If all the fields in the <<Selected Fields>> get removed, then this
    ** entry and corresponding SCREEN-VALUE in the eCurrentTable combo box
    ** also need to be removed. R Ryan 7/94
    */
    /* DRH 2/8/95
    if whright[{&Field}]:num-items = 0 
      and {&CurTable} = "<<Selected Fields>>":U then do:  
      eCurrentTable:SCREEN-VALUE = eCurrentTable:ENTRY(1). 
      apply "value-changed" to eCurrentTable. 
      /* Need to clear out any old sort statements and/or selected fields */
      {&CurSortData} = "".
      {&CurRight}:LIST-ITEMS = "".
    END.
    */
    /* [gfs 10/3/96] There is a situation where when the Sort page is
     * called from the Adv. Query Settings function of a SmartBrowser,
     * fields are populated but the combo-box is never displayed with
     * the current value. I'm trying to display it below...
     */
    IF eCurrentTable:SCREEN-VALUE = ? AND 
       eCurrentTable NE ""            AND 
       eCurrentTable NE ?             THEN
      eCurrentTable:SCREEN-VALUE = eCurrentTable.
  END. /* DO WITH FRAME dialog-1 */   
END PROCEDURE.  /* setComboBox */

/* -----------------------------------------------------------
  Purpose:     Set the sensitivity of buttons in the Query Builder
	       based on the current selection.
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE setUpDown:
  DEFINE VARIABLE iTop       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iBottom    AS INTEGER   NO-UNDO.

  DO WITH FRAME dialog-1:
    ASSIGN
      /* Get the position of the top and bottom selected items */
      iTop                       =  
	LOOKUP(ENTRY(1,{&CurRight}:SCREEN-VALUE,{&Sep1}),
	       {&CurRight}:LIST-ITEMS, {&Sep1})
      iBottom                    =  
	LOOKUP(ENTRY(NUM-ENTRIES ({&CurRight}:SCREEN-VALUE, {&Sep1}),
	       {&CurRight}:SCREEN-VALUE, {&Sep1}),
	       {&CurRight}:LIST-ITEMS, {&Sep1})
      bAdd:SENSITIVE             = ({&CurLeft}:SCREEN-VALUE  NE ?)
      bRemove:SENSITIVE          = ({&CurRight}:SCREEN-VALUE NE ?)
      b_fields:SENSITIVE         = b_fields:VISIBLE 
				     AND {&TableRight}:NUM-ITEMS > iXternalCnt
      bTableSwitch:SENSITIVE     = IF iTop >= 3 - iXternalCnt 
				   THEN TRUE ELSE FALSE
      {&CurLeft}:PRIVATE-DATA    = {&CurTable}
      bUp:SENSITIVE              = IF (iTop > 1) THEN TRUE ELSE FALSE
      bDown:SENSITIVE            = 
	IF iBottom < NUM-ENTRIES({&CurRight}:LIST-ITEMS, {&Sep1}) 
	THEN TRUE ELSE FALSE 
      tIndexReposition:SENSITIVE = TRUE. 
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE SetOperatorsVisible.ip:
  DEFINE INPUT PARAMETER pValue AS LOGICAL.

  DO WITH FRAME dialog-1:
    ASSIGN
      bEqual:VISIBLE           = pValue 
      bNotEqual:VISIBLE        = pValue         
      bLess:VISIBLE            = pValue         
      bGreater:VISIBLE         = pValue         
      bLessEqual:VISIBLE       = pValue         
      bGreaterEqual:VISIBLE    = pValue         
      bAnd:VISIBLE             = pValue
      bOR:VISIBLE              = pValue
    .
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE SetJoinOperatorsVisible.ip:
  DEFINE INPUT PARAMETER pValue AS LOGICAL.

  DO WITH FRAME dialog-1:
    ASSIGN
      bBegins:VISIBLE   = pValue        
      bMatches:VISIBLE  = pValue  
      bRange:VISIBLE    = pValue        
      bList:VISIBLE     = pValue                
      bContains:VISIBLE = pValue 
      .
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE SetOperatorsSensitive.ip:
  DEFINE INPUT PARAMETER pValue AS LOGICAL.

  DO WITH FRAME dialog-1:
    ASSIGN
      bEqual:SENSITIVE        = pValue 
      bNotEqual:SENSITIVE     = pValue  
      bLess:SENSITIVE         = pValue  
      bGreater:SENSITIVE      = pValue  
      bLessEqual:SENSITIVE    = pValue  
      bGreaterEqual:SENSITIVE = pValue  
      bAnd:SENSITIVE          = IF TRIM(eDisplayCode:SCREEN-VALUE) = ""
				    THEN FALSE 
				    ELSE (IF pValue THEN TRUE
				    ELSE (IF {&JOIN-MODE} THEN pValue
				    ELSE (NOT pValue)))
      bOR:SENSITIVE           = bAnd:SENSITIVE.
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE SetJoinOperatorsSensitive.ip:
  DEFINE INPUT PARAMETER pValue AS LOGICAL.

  DO WITH FRAME dialog-1:
    ASSIGN
      bBegins:SENSITIVE   = pValue      
      bMatches:SENSITIVE  = pValue  
      bRange:SENSITIVE    = pValue      
      bList:SENSITIVE     = pValue              
      bContains:SENSITIVE = pValue
      . 
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE setComboBoxQuery:
  DEFINE INPUT PARAMETER lInit AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE calcFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE expExtent    AS INTEGER   NO-UNDO INITIAL 1.

  DO WITH FRAME dialog-1:
    IF {&Where-Mode} OR {&Join-Mode} THEN expExtent = 2.

    IF lInit THEN DO:
      /*
       * If this is a Join then there must be two tables to continue.
       * So make sure everything is set to empty....
       */
      IF {&Join-Mode} AND
	((whRight[{&table}]:LIST-ITEMS = ?) OR
	(NUM-ENTRIES (whRight[{&table}]:LIST-ITEMS, {&Sep1}) < 2)) THEN DO:
	ASSIGN
	  {&CurTable}               = ""
	  eCurrentTable:LIST-ITEMS  = ""
	  lLeft:SCREEN-VALUE        = ""
	  lRight:SCREEN-VALUE       = ""
	  {&CurLeft}:LIST-ITEMS     = ""
	  {&CurRight}:LIST-ITEMS    = ""
	  eDisplayCode:SCREEN-VALUE = "".
	RETURN.
      END.
      
      /*
       * If we haven't stored the data then get the first line from the right 
       * table list. Else use the stored data
       */
      IF ({&CurLeft}:PRIVATE-DATA = ?) OR ({&CurLeft}:PRIVATE-DATA = "") THEN 
	IF (whRight[{&table}]:SCREEN-VALUE > "") THEN
	  {&CurTable} = ENTRY(1,whRight[{&table}]:SCREEN-VALUE,{&Sep1}).
	ELSE
	  {&CurTable} = ENTRY(iXternalCnt + 1,
			      whRight[{&table}]:LIST-ITEMS, {&Sep1}).
      ELSE
	{&CurTable} = {&CurLeft}:PRIVATE-DATA.
      /*
       * The available list is the same as the right table list (after
       * removing the External Tables.
       * I.E. find the position of the Seperator seperating the External 
       * from the internal tables and split it there.
       */   
      eCurrentTable:LIST-ITEMS = whright[{&table}]:LIST-ITEMS.  
 
      /* For Join delete the first list and use the second entry. */      
      i = 0.
      IF {&Join-Mode} THEN DO: 
	IF iXternalCnt = 0 THEN 
	  lOK = eCurrentTable:DELETE(
		  ENTRY(1,whRight[{&table}]:LIST-ITEMS,{&Sep1})).
	ELSE DO i = 1 TO iXternalCnt:
	  lOK = eCurrentTable:DELETE(
		  ENTRY(i,whRight[{&table}]:LIST-ITEMS,{&Sep1})).
	END. 
	 
	/* Another check: what if the user decoupled the join (i.e. None) */
	IF NUM-ENTRIES(eCurrentTable:ENTRY(1)," ":U) = 1 THEN DO:  
	  lOK = eCurrentTable:DELETE(eCurrentTable:ENTRY(1)).
	END. 
 
	IF (LOOKUP (ENTRY (1, whRight[{&table}]:SCREEN-VALUE, {&Sep1}),
	   whRight[{&table}]:LIST-ITEMS, {&Sep1}) > 1) 
	THEN
	  {&CurTable} = ENTRY (1, whRight[{&table}]:SCREEN-VALUE, {&Sep1}).
	ELSE
	  {&CurTable} = ENTRY (1, eCurrentTable:LIST-ITEMS, {&Sep1}).
      END. 
    END.                                                                       
    
    /* There is no change to the right selection list so we can leave. */
    IF ({&CurLeft}:PRIVATE-DATA = {&CurTable}) THEN DO:
      lLeft:SCREEN-VALUE = ENTRY (1, {&CurTable}, " ").
      IF {&Join-Mode} THEN
	lRight:SCREEN-VALUE = ENTRY (3, {&CurTable}, " ").
      RETURN.
    END.

    ASSIGN
      {&CurLeft}:PRIVATE-DATA = ""
      {&CurLeft}:LIST-ITEMS   = "".

    IF ({&CurTable} = "") THEN RETURN.

    IF (ENTRY(1,_AliasList) > "") THEN
      RUN adecomm/_mfldlst.p ({&CurLeft}:HANDLE,ENTRY(1,_AliasList),
			      tt-info,TRUE,"",expExtent,_CallBack,OUTPUT lOk).
    ELSE
      RUN adecomm/_mfldlst.p ({&CurLeft}:HANDLE,ENTRY(1,{&CurTable}," "), 
			      tt-info,TRUE,"",expExtent,_CallBack,OUTPUT lOk).

    ASSIGN lLeft:SCREEN-VALUE      = ENTRY(1,{&CurTable}," ")
           {&CurLeft}:PRIVATE-DATA = {&CurTable}.

    /* For WHERE we are done */
    IF {&Where-Mode} THEN DO:
      IF LOOKUP({&CurTable}, eCurrentTable:LIST-ITEMS, {&Sep1}) > 0 THEN
	eDisplayCode:SCREEN-VALUE = acWhere[LOOKUP({&CurTable}, 
	  eCurrentTable:LIST-ITEMS,{&Sep1}) + iXternalCnt].
      ELSE
	eDisplayCode:SCREEN-VALUE = "".
      RETURN.
    END.     
  
    /* For Join we are done */
    IF LOOKUP ({&CurTable}, eCurrentTable:LIST-ITEMS, {&Sep1}) > 0 THEN
      eDisplayCode:SCREEN-VALUE = acJoin [LOOKUP ({&CurTable}, 
				  eCurrentTable:LIST-ITEMS, {&Sep1}) + 
				  (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)].
    ELSE
      eDisplayCode:SCREEN-VALUE = "".

    ASSIGN
      {&CurRight}:LIST-ITEMS   = ""
      lRight:SCREEN-VALUE = ENTRY (3, {&CurTable}, " ").

    IF num-entries(_AliasList) > 2 and (ENTRY(3,_AliasList) > "") THEN
      RUN adecomm/_mfldlst.p ({&CurRight}:HANDLE,ENTRY(3,_AliasList), 
			      tt-info,TRUE,"",expExtent,_CallBack,OUTPUT lOk).
    ELSE
      RUN adecomm/_mfldlst.p ({&CurRight}:HANDLE,ENTRY(3,{&CurTable}," "), 
			      tt-info,TRUE,"",expExtent,_CallBack,OUTPUT lOk).

    ASSIGN
      {&CurLeft}:SENSITIVE   = lLogical
      {&CurRight}:SENSITIVE  = lLogical.
	 
    RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,lLogical).
  END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:  Load and enable query tuning browser   
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE SetQueryTune.ip:
  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  DEFINE VARIABLE nw AS LOGICAL NO-UNDO.  

  DO WITH FRAME dialog-1:
  
    /* Make sure _TblOptList has the correct number of entries */
    IF _TblOptList = "" THEN
      _TblOptList = FILL(",", {&TableRight}:NUM-ITEMS - iXternalCnt - 1).
    ELSE IF NUM-ENTRIES(_TblOptList) < {&TableRight}:NUM-ITEMS - iXternalCnt 
    THEN
      _TblOptList = _TblOptList 
		  + FILL(",", {&TableRight}:NUM-ITEMS - iXternalCnt -
					    NUM-ENTRIES(_TblOptList)).
				       
    /* Now _TblOptList has at least as many items as table entries - try to 
       match them with existing _qo records - start by resequencing existing 
       _qo records */
    FOR EACH _qo WHERE _qo._seq-no < 3000:
      _qo._seq-no = _qo._seq-no + 3000.
    END.
    
    /* Now go through current TableRight stuff */
    REPEAT ix = iXternalCnt + 1 TO {&TableRight}:NUM-ITEMS:
      nw = FALSE.  /* Preset "new" to FALSE */
      FIND FIRST _qo WHERE _qo._tbl-name = 
	ENTRY(ix,{&TableRight}:LIST-ITEMS,{&SEP1}) NO-ERROR.
      IF NOT AVAILABLE _qo THEN DO:
	CREATE _qo.
	nw = TRUE.     /* Creating a new record */
      END.
      ASSIGN _qo._seq-no = ix - iXternalCnt.
      IF nw THEN
	ASSIGN 
	  _qo._tbl-name      = ENTRY(ix, {&TableRight}:LIST-ITEMS, {&SEP1})
	  _qo._find-type     = 
	    IF INDEX(ENTRY(_qo._seq-no,_TblOptList),"FIRST":U) > 0 
	    THEN "FIRST":U
	    ELSE IF INDEX(ENTRY(_qo._seq-no,_TblOptList),"LAST":U) > 0
	    THEN "LAST":U
	    ELSE "EACH":U
	  _qo._flds-returned =
	    IF INDEX(ENTRY(_qo._seq-no,_TblOptList),"Used":U) > 0
	    THEN "Fields Used":U ELSE "All Fields":U
	  _qo._join-type     = 
	    IF _qo._seq-no = 1 AND iXternalCnt = 0 THEN "N/A":U
	    ELSE IF INDEX(ENTRY(_qo._seq-no,_TblOptList),"OUTER":U) > 0
	    THEN "OUTER":U
	    ELSE "INNER":U.
    END. /* REPEAT */
    
    /* Matched all non-external table entries, now trash extra entries if any */
    FOR EACH _qo WHERE _qo._seq-no > 2999:
      DELETE _qo.
    END.
	  
    /* Create new _qo records */
    OPEN QUERY _qrytune FOR EACH _qo.
    ENABLE _qrytune.
  END.
END.

/* _qset.p - end of file */

