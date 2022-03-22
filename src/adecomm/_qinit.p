/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: query.p

Description:
  This code will bring up the dialog box frame that allows the developer
  to define the files and their query relationships used in a browse.

Input Parameters:
  browser-name    - The name of the browser to be editted
  suppress_dbname - Logical to indicate if dbname should be suppressed
  from qualifications of the db fields in the generated
  4GL code

Output Parameters:
  <none>

Author: Greg O'Connor

Created: 03/23/93 - 12:17 pm

Modified: 2/28/93 by RPR (added dummy vars, auto_check & pcValidState
  needed for adeshar/_qenable.p)

-----------------------------------------------------------------------------*/

{adecomm/browqury.i NEW}
{adecomm/cbvar.i}
{adecomm/adeintl.i}

DEF INPUT  PARAMETER browserName    AS CHARACTER NO-UNDO.
DEF INPUT  PARAMETER suppressDbName AS LOGICAL   NO-UNDO.
DEF INPUT  PARAMETER iState         AS INTEGER   NO-UNDO.
DEF INPUT  PARAMETER flags          AS CHARACTER NO-UNDO.
DEF OUTPUT PARAMETER cancelled      AS LOGICAL   NO-UNDO INITIAL FALSE.

/* Standard End-of-line character */
&SCOPED-DEFINE EOL &IF "{&WINDOW-SYSTEM}" <> "OSF/Motif" &THEN "~r" + &ENDIF CHR(10)

/*--------------------------------------------------------------------------*/
DEFINE VARIABLE v_pick       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iTemp        AS INTEGER   NO-UNDO.
DEFINE VARIABLE auto_check   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE pcValidState AS LOGICAL   NO-UNDO.

DEFINE RECTANGLE RECT-4 {&STDPH_OKBOX}.

FORM
  SKIP ({&TFM_WID})
  SPACE({&HFM_WID}) 
  v_pick 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 32 INNER-LINES 10 
  /* SPACE({&HFM_WID}) */ SKIP

  /** The Standard dialog button **/
  {adecomm/okform.i
    &BOX    = "RECT-4"
    &STATUS =  NO
    &OK     = "bOk"
    &CANCEL = "bCancel" }

  WITH FRAME fr_pick NO-ATTR-SPACE NO-LABELS
  TITLE "Select Related Table":t32
  VIEW-AS DIALOG-BOX.

DEFINE VARIABLE sIndex    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lConstant AS LOGICAL   NO-UNDO.

/* Parameters Definitions ---                                               */

ON CHOOSE OF bHelp DO:
  DO WITH FRAME dialog-1:

    /*****
    CASE TRIM(rsMain:screen-value):
      WHEN "{&join}"  THEN
      /* ON HELP in the Join Builder dialog box */
      RUN adecomm/_adehelp.p ( "ab", "CONTEXT",{&Join_Builder_Dlg_Box}, ? ).
    WHEN "{&Where}" THEN
      /* ON HELP in the Where Builder dialog box */
      RUN adecomm/_adehelp.p ( "ab", "CONTEXT",{&Where_Builder_Dlg_Box}, ? ).
    WHEN "{&Sort}"  THEN
      /* ON HELP in the Sort Selection dialog box */
      RUN adecomm/_adehelp.p ( "ab", "CONTEXT",{&Sort_Selection_Dlg_Box}, ? ).
    WHEN "{&Field}" THEN
      /* ON HELP in the Field Selection dialog box */
      RUN adecomm/_adehelp.p ( "ab", "CONTEXT",{&Field_Selection_Dlg_Box}, ? ).
    WHEN "{&Table}" THEN
      /* ON HELP in the Table Builder dialog box */
      RUN adecomm/_adehelp.p ( "ab", "CONTEXT",{&Table_Builder_Dlg_Box}, ? ).
    END CASE.
    ****/
  END.
END.

{adecomm/cbdrop.i 
  &Frame  = "FRAME dialog-1"
  &CBFill = "eCurrentTable"
  &CBList = "slComboBox"
  &CBBtn  = "bDrop"
  &CBInit = "eCurrentTable"}

/* -----------------------------------------------------------
U1 is posted from cbdrop.i include file.
-------------------------------------------------------------*/
ON U1 OF eCurrentTable, slComboBox DO:
  DO WITH FRAME dialog-1:
    IF (INTEGER (rsMain:screen-value) = {&Where}) OR
      (INTEGER (rsMain:screen-value) = {&Join}) THEN
    DO:
      RUN adecomm/_qset.p ("setComboBoxQuery":u, FALSE).
      IF (INTEGER (rsMain:screen-value) = {&Join}) THEN
        RUN adecomm/_qset.p("SetCustomizeJoin", TRUE).
      ELSE DO:
        /** To set up Undo State **/
        FIND LAST ttWhere WHERE {&Where} = ttWhere.iState
          AND   lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.
        IF AVAILABLE (ttWhere) THEN DO:
          ASSIGN
            cLastField             = ttWhere.cLastField
            {&CurLeft}:sensitive   = ttWhere.lOperator
            {&CurRight}:sensitive  = ttWhere.lOperator.

          RUN load_ops.
        END.
      END.
    END.
    ELSE
      RUN adecomm/_qset.p ("setComboBox":u, FALSE).
  END.
END.

ON CHOOSE OF bFieldFormat DO:
  DO WITH FRAME dialog-1:

    DEFINE VAR cOldformat   AS CHARACTER.
    DEFINE VAR cNewFormat AS CHARACTER.
    DEFINE VAR counter AS INTEGER.

    cOldformat = eFieldFormat:screen-value.

    RUN DB_Field.ip ({&CurRight}:SCREEN-VALUE,"FORMAT",OUTPUT cTemp).

    DO counter = 2 TO NUM-ENTRIES (cTemp):
      cNewFormat = IF counter = 2 THEN ENTRY(counter, cTemp)
                   ELSE cNewFormat + ",":u + ENTRY (counter, cTemp).
    END.

    RUN adecomm/_y-build.p (INTEGER(ENTRY(1, cTemp)),INPUT-OUTPUT cOldFormat).

    eFieldFormat:screen-value = cOldFormat.

    IF (cOldformat <> cNewFormat) THEN
    ASSIGN
      cFieldName = {&CurRight}:SCREEN-VALUE
      cList      = {&CurRight}:LIST-ITEMS
      cTemp      = ENTRY(LOOKUP(cFieldName,cList,{&Sep1}),{&CurData},{&Sep1})
      ENTRY (3, cTemp, {&sep2}) = eFieldFormat:SCREEN-VALUE
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp
      .
  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON ENDKEY OF FRAME DIALOG-1 
  cancelled = TRUE.

ON GO OF FRAME DIALOG-1 DO:
  DO WITH FRAME dialog-1:

    /** If auto syntax check is set **/
    IF (tOnOk:screen-value = "yes") THEN DO:

      RUN CheckSyntax.ip (OUTPUT lOK).
      IF NOT lOK THEN
      RUN CheckDisplayWidth.ip (OUTPUT lOK).

      IF lOK THEN
      RETURN NO-APPLY.
    END.

    RUN BuildQuery.ip (OUTPUT _4GLQury).

    ASSIGN
      _TblList = {&TableRight}:LIST-ITEMS
      _OrdList = {&CurSortData}
      _FldList = {&CurFieldData}
      .

    DO i = 1 TO EXTENT (_Where):
      IF i <= NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}) THEN
      ASSIGN
        _Where[i]    = (IF (acWhere [i] > "") THEN  acWhere [i] ELSE ?)
        _JoinCode[i] = (IF (acJoin  [i] > "") THEN  acJoin  [i] ELSE ?)
        .
      ELSE
      ASSIGN
        _Where[i]    = (IF (acWhere [i] > "") THEN  acWhere [i] ELSE ?)
        _JoinCode[i] = (IF (acJoin  [i] > "") THEN  acJoin  [i] ELSE ?)
        .
    END.
  END.
END.
/* Check Syntax ----------------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bCheckSyntax DO:
  RUN CheckSyntax.ip (OUTPUT lOK).
  IF NOT lOK THEN
    MESSAGE "No syntax errors.":t48 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
/* Change Join Target ----------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bTableSwitch
  RUN ChangeJoinTarget.ip.
/* ----------------------------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bDebug
  RUN Debug.ip.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON "CHOOSE" OF bUp IN FRAME dialog-1 DO:

  DO WITH FRAME dialog-1:
    ASSIGN
      cList = {&CurRight}:LIST-ITEMS
      cTemp = {&CurRight}:SCREEN-VALUE.
    /*
    ** IF it is sort or Field have to move one at a time to keep the cMoreData
    ** in parellel with the :list-items
    */
    IF INTEGER (rsMain:screen-value) = {&Sort} OR
      INTEGER (rsMain:screen-value) = {&Field} THEN DO:
      DO i = 1 TO NUM-ENTRIES (cTemp, {&Sep1}):

        RUN MoveList.ip (TRUE,
          ENTRY(LOOKUP(ENTRY(i,cTemp,{&Sep1}),cList,{&Sep1}),{&CurData},{&Sep1}),
          {&Sep1},
          INPUT-OUTPUT {&CurData}).

        RUN MoveList.ip (TRUE,
          ENTRY (i, cTemp, {&Sep1}),
          {&Sep1},
          INPUT-OUTPUT cList).
      END.
    END.
    ELSE
      RUN MoveList.ip (TRUE, cTemp, {&Sep1}, INPUT-OUTPUT cList).
    /*
    ** Setup List-items and screen values
    */
    ASSIGN
      {&CurRight}:LIST-ITEMS   = cList
      {&CurRight}:SCREEN-VALUE = cTemp
      .
    RUN adecomm/_qset.p ("setUpDown",    TRUE).
    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
    eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
END /*TRIGGER*/ .
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON "CHOOSE" OF bDown IN FRAME dialog-1 DO:
  DO WITH FRAME dialog-1:

    ASSIGN
      cList = {&CurRight}:LIST-ITEMS
      cTemp = {&CurRight}:SCREEN-VALUE.
    /*
    ** IF it is sort or Field have to move one at a time to keep the cMoreData
    ** in parellel with the :list-items
    */
    IF INTEGER (rsMain:screen-value) = {&Sort} OR
      INTEGER (rsMain:screen-value) = {&Field} THEN DO:
      DO i = NUM-ENTRIES (cTemp, {&Sep1}) TO 1 BY -1:
        RUN MoveList.ip (FALSE,
          ENTRY (LOOKUP (ENTRY (i, cTemp, {&Sep1}), cList, {&Sep1}), {&CurData}, {&Sep1}),
          {&Sep1},
          INPUT-OUTPUT {&CurData}).

        RUN MoveList.ip (FALSE,
          ENTRY (i, cTemp, {&Sep1}),
          {&Sep1},
          INPUT-OUTPUT cList).
      END.
    END.
    ELSE
      RUN MoveList.ip (FALSE, cTemp, {&Sep1}, INPUT-OUTPUT cList).
    /*
    ** Setup List-items and screen values
    */
    ASSIGN
      {&CurRight}:LIST-ITEMS   = cList
      {&CurRight}:SCREEN-VALUE = cTemp
      .
    RUN adecomm/_qset.p ("setUpDown",    TRUE).
    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
    eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END /* DO */ .
END /*TRIGGER*/ .

/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bRemove IN FRAME dialog-1
  RUN DefaultActionRight.ip.

/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bAdd IN FRAME dialog-1
  RUN DefaultActionLeft.ip.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON LEAVE OF eFieldLabel DO:
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

  DO WITH FRAME dialog-1:

    /*  RUN DB_Field.ip ({&CurRight}:SCREEN-VALUE, "LABEL", OUTPUT cTemp). */
    RUN DB_Field.ip (sIndex, "LABEL", OUTPUT cTemp).

    IF (SELF:SCREEN-VALUE <> cTemp) THEN
    ASSIGN
      cFieldName = sIndex
      cList      = {&CurRight}:LIST-ITEMS
      cTemp      = ENTRY(LOOKUP(cFieldName,cList,{&Sep1}),{&CurData},{&Sep1})
      ENTRY(2,cTemp,{&sep2}) = REPLACE(REPLACE(SELF:SCREEN-VALUE,CHR(13),"!"), 
                                 CHR(10), "")
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp
      .

  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON LEAVE OF eFieldFormat DO:

  DEFINE VARIABLE counter  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lError   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cFormat AS CHARACTER NO-UNDO.

  DO WITH FRAME dialog-1:

    RUN DB_LongField.ip (sIndex, "FORMAT",
      OUTPUT cCurrentDB,
      OUTPUT cTableName,
      OUTPUT cFieldName,
      OUTPUT cTemp).

    DO counter = 2 TO NUM-ENTRIES (cTemp):
      cFormat = IF (counter = 2) THEN ENTRY (counter, cTemp)
                ELSE cFormat + ",":u + ENTRY (counter, cTemp).
    END.

    RUN adecomm/_chkfmt.p (INTEGER (ENTRY (1,cTemp)), cFieldName,
      "", SELF:SCREEN-VALUE, OUTPUT counter, OUTPUT lError).
    IF (lError) THEN RETURN NO-APPLY.

    /** Format returns TYPE,FORMAT  **/
    IF (SELF:SCREEN-VALUE <> cFormat) THEN
    ASSIGN
      cFieldName = sIndex
      cList      = {&CurRight}:LIST-ITEMS
      /** Find the item based on screen vlaue **/
      cTemp = ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1})
      /** Change the FORMAT part **/
      ENTRY (3, cTemp, {&sep2}) = SELF:SCREEN-VALUE				
      /** Put it back  **/
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp
      .
  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bEqual         OR
  CHOOSE OF bNotEqual      OR
  CHOOSE OF bLess          OR
  CHOOSE OF bGreater       OR
  CHOOSE OF bLessEqual     OR
  CHOOSE OF bGreaterEqual  OR
  CHOOSE OF bAnd           OR
  CHOOSE OF bOR            OR
  CHOOSE OF bBegins        OR
  CHOOSE OF bMatches       OR
  CHOOSE OF bRange         OR
  CHOOSE OF bList 			OR
  CHOOSE OF bOR            OR
  CHOOSE OF bContains      OR
  CHOOSE OF bXMatches 	   /*	OR
  CHOOSE OF bLike          OR
  CHOOSE OF bxRange 		OR
  CHOOSE OF bXList */ DO:

  DO WITH FRAME dialog-1:

    IF INTEGER (rsMain:screen-value) = {&Join} THEN
      RUN Join.ip (SELF:LABEL, TRUE).
    ELSE DO:
      RUN guess_field (OUTPUT cTemp).
      RUN adecomm/_qwhere.p (SELF:LABEL, cTemp).
    END.
  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON CHOOSE OF bUndo DO:
  DO WITH FRAME dialog-1:

    DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO. /* scrap */

    /* just in case any junk gets in there */
    FOR EACH ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState
      AND lLeft:SCREEN-VALUE = ttWhere.cTable AND ttWhere.iSeq > 0
      AND ttWhere.cExpression = "":
      DELETE ttWhere.
    END.

    FIND LAST ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState
      AND lLeft:SCREEN-VALUE = ttWhere.cTable.

    IF ttWhere.iSeq > 0 THEN DO:
      DELETE ttWhere.
      FIND LAST ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState
        AND lLeft:SCREEN-VALUE  = ttWhere.cTable.
    END.

    ASSIGN
      eDisplayCode:SCREEN-VALUE  = ttWhere.cExpression
      eDisplayCode:SENSITIVE     = (IF eDisplayCode:screen-value > "" THEN
                                    TRUE ELSE FALSE)
      eDisplayCode:CURSOR-OFFSET = (IF (ttWhere.iOffset > 0) THEN
                                      ttWhere.iOffset
                                    ELSE eDisplayCode:CURSOR-OFFSET)
      bCheckSyntax:SENSITIVE     = (ttWhere.iSeq > 0)
      bUndo:SENSITIVE            =  bCheckSyntax:SENSITIVE
      {&CurLeft}:screen-value    = ""
      {&CurRight}:screen-value   = ""
      {&CurLeft}:sensitive       = ttWhere.lOperator
      {&CurRight}:sensitive      = ttWhere.lOperator
      cLastField                 = ttWhere.cLastField
      .

    IF (INTEGER (rsMain:screen-value) = {&Join}) THEN DO:
      RUN adecomm/_qset.p ("SetOperatorsSensitive.ip",
        NOT ttWhere.lOperator).
      RUN adecomm/_qset.p ("SetJoinOperatorsSensitive.ip",
        NOT ttWhere.lOperator).
      acJoin[LOOKUP({&CurTable},slComboBox:LIST-ITEMS,{&Sep1})] =
        ttWhere.cExpression.
    END.
    ELSE IF (INTEGER(rsMain:screen-value) = {&Where}) THEN DO:
      acWhere[LOOKUP({&CurTable},slComboBox:LIST-ITEMS,{&Sep1})] =
        ttWhere.cExpression.
      RUN load_ops.
    END.
    /*
    IF eDisplayCode:sensitive THEN
    APPLY "ENTRY" TO eDisplayCode.
    */
  END.
END.
/* ----------------------------------------------------------- */
ON ENTRY OF eDisplayCode DO:
  DO WITH FRAME dialog-1:

    IF INTEGER (rsMain:screen-value) = {&Join} OR
      INTEGER (rsMain:screen-value) = {&Where} THEN DO:

      RUN adecomm/_qset.p ("SetOperatorsSensitive.ip", TRUE).
      RUN adecomm/_qset.p ("SetJoinOperatorsSensitive.ip", TRUE).

      ASSIGN
        {&CurLeft}:sensitive       = TRUE.
    END.
  END.
END.
/* -----------------------------------------------------------
------------------------------------------------------------*/
ON LEAVE OF eDisplayCode DO:
  DO WITH FRAME dialog-1:

    IF INTEGER (rsMain:screen-value) = {&Join} OR
      INTEGER (rsMain:screen-value) = {&Where} THEN DO:

      FIND LAST ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState 
        AND lLeft:SCREEN-VALUE = ttWhere.cTable.

      /*
      ** If from the users point of view we have saved this then
      ** Just leave...
      IF (ttWhere.iOffset      = eDisplayCode:CURSOR-OFFSET  AND
      */
      IF (ttWhere.cExpression  = eDisplayCode:SCREEN-VALUE ) THEN
      RETURN.

      i                        = ttWhere.iSeq.

      CREATE ttWhere.

      ASSIGN
        cLastField                 = TRIM(eDisplayCode:SCREEN-VALUE)
        ttWhere.iState             = INTEGER (rsMain:screen-value)
        ttWhere.cTable             = lLeft:SCREEN-VALUE
        ttWhere.iSeq               = i + 1
        ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET
        ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE
        ttWhere.lOperator          = TRUE /* ggg This needs work !! */
        bCheckSyntax:SENSITIVE     = TRUE
        bUndo:SENSITIVE            = TRUE
        {&CurLeft}:screen-value    = ""
        {&CurRight}:screen-value   = ""
        {&CurLeft}:sensitive       = ttWhere.lOperator
        {&CurRight}:sensitive      = ttWhere.lOperator.

      /*
      This is bad
      RUN adecomm/_qset.p ("SetOperatorsSensitive.ip",NOT ttWhere.lOperator).
      RUN adecomm/_qset.p ("SetJoinOperatorsSensitive.ip",NOT ttWhere.lOperator).
      */

      IF (INTEGER (rsMain:screen-value) = {&Join}) THEN
        acJoin [LOOKUP ({&CurTable}, slComboBox:List-Items, {&Sep1})] = 
          ttWhere.cExpression.
      ELSE
      IF INTEGER (rsMain:screen-value) = {&Where} THEN
        acWhere [LOOKUP ({&CurTable}, slComboBox:List-Items, {&Sep1})] = 
          ttWhere.cExpression.
    END.
  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON VALUE-CHANGED OF rsSortDirection DO:
  DO WITH FRAME dialog-1:

    ASSIGN
      cFieldName = {&CurRight}:SCREEN-VALUE
      cList      = {&CurRight}:LIST-ITEMS
      /** Find the item based on screen vlaue **/
      cTemp = ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1})
      /** Change the sort part **/
      ENTRY (2, cTemp, {&sep2}) = rsSortDirection:SCREEN-VALUE
      /** Put it back  **/
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp
      .

    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
    eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON VALUE-CHANGED OF tJoinable DO:
  DO WITH FRAME dialog-1:

    IF TRIM (tJoinable:screen-value) = "YES" THEN DO:
      ASSIGN
        cTemp                      = {&CurTable}
        {&CurTable}                = REPLACE({&CurTable},"OF":u,"WHERE":u)
        {&CurTable}                = {&CurTable} + " ...":u
        eDisplayCode:SCREEN-VALUE  = ""
        eDisplayCode:sensitive     = TRUE
        {&CurLeft}:sensitive       = TRUE
        {&CurRight}:sensitive      = TRUE
        .
    END.
    ELSE DO:
      IF (eDisplayCode:SCREEN-VALUE  > "") THEN DO:
        MESSAGE "This will delete the current join criteria." SKIP
          "Do you wish to continue ?" 
          VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE lLogical.

        IF (lLogical <> TRUE) THEN DO:
          tJoinable:screen-value = "YES".
          RETURN.
        END.
      END.

      ASSIGN
        cTemp                      = {&CurTable}
        {&CurTable}                = REPLACE ({&CurTable}, "WHERE", "OF")
        {&CurTable}                = TRIM ({&CurTable},".")
        acJoin [LOOKUP (cTemp, slComboBox:List-Items, {&Sep1})] = ""
        eDisplayCode:SCREEN-VALUE  = ""
        {&CurLeft}:screen-value    = ""
        {&CurRight}:screen-value   = ""
        bCheckSyntax:SENSITIVE     = FALSE
        bUndo:SENSITIVE            = FALSE
        eDisplayCode:sensitive     = FALSE
        {&CurLeft}:sensitive       = FALSE
        {&CurRight}:sensitive      = FALSE
        .

      RUN adecomm/_qset.p ("SetOperatorsSensitive.ip", FALSE).

      FOR EACH ttWhere WHERE {&Join} = ttWhere.iState 
        AND ENTRY (1, cTemp, " ") = ttWhere.cTable 
        AND ttWhere.iSeq > 0:
        DELETE ttWhere.
      END.
    END.

    lOK = whRight[{&table}]:REPLACE ({&CurTable}, cTemp).
    lOK = slComboBox:REPLACE ({&CurTable}, cTemp).

  END.
END.
/* -----------------------------------------------------------
-------------------------------------------------------------*/
ON VALUE-CHANGED OF rsMain DO:

  RUN adecomm/_qenable.p.
  DO WITH FRAME dialog-1:
    CASE TRIM(rsMain:screen-value):
    WHEN "{&Sort}" THEN DO:
      RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
      eDisplayCode:SCREEN-VALUE = eDisplayCode.
    END.

    WHEN "{&Join}" THEN
      RUN adecomm/_qset.p("SetCustomizeJoin", TRUE).

    WHEN "{&Where}" THEN DO:
      /** To set up Undo State **/
      FIND LAST ttWhere WHERE {&Where} = ttWhere.iState
        AND   lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.
      IF AVAILABLE (ttWhere) THEN DO:
        ASSIGN
          cLastField             = ttWhere.cLastField
          {&CurLeft}:sensitive   = ttWhere.lOperator
          {&CurRight}:sensitive  = ttWhere.lOperator.

        RUN load_ops.
      END.
    END.

    WHEN "{&Table}" THEN DO:
      RUN BuildQuery.ip (OUTPUT eDisplayCode).
      ASSIGN
        eDisplayCode:SCREEN-VALUE = eDisplayCode
        bCheckSyntax:sensitive    = (IF eDisplayCode <> "" THEN TRUE ELSE FALSE)
        .
    END.
  END CASE.
END.
END.
/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */

{adecomm/okrun.i
  &FRAME  = "frame fr_pick"
  &BOX    = "RECT-4"
  &OK     = "bOK"
  &CANCEL = "bCancel"
  }

/* Ensure the interface displays over the window with focus. */
IF VALID-HANDLE(ACTIVE-WINDOW) THEN CURRENT-WINDOW = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition. */

RUN adecomm/_qenable.p. /* init_frame.*/
rsMain:SCREEN-VALUE = STRING (iState).
RUN adecomm/_qenable.p.

/*
* Only build the source if we're starting this session with a table.
*/
IF iState = 1 THEN DO:
  RUN BuildQuery.ip (OUTPUT eDisplayCode).

  ASSIGN
    bCheckSyntax:sensitive = (IF eDisplayCode > "" THEN TRUE ELSE FALSE)
    eDisplayCode:SCREEN-VALUE = eDisplayCode.

END.

DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
  WAIT-FOR go OF FRAME dialog-1.
END.

HIDE FRAME DIALOG-1.

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/
/* Check for a selected table */
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE TableRemove.ip:
DEFINE VARIABLE cTempOne   AS CHAR    NO-UNDO.
DEFINE VARIABLE cFldTemp   AS CHAR    NO-UNDO.
DEFINE VARIABLE cFldDelete AS CHAR    NO-UNDO.
DEFINE VARIABLE cFldName   AS CHAR    NO-UNDO.
DEFINE VARIABLE cnt        AS INTEGER NO-UNDO.
DEFINE VARIABLE err        AS LOGICAL NO-UNDO.
DEFINE VARIABLE pos        AS INTEGER NO-UNDO.
DEFINE VARIABLE nxtname    AS CHAR    NO-UNDO.
DEFINE VARIABLE ix         AS INTEGER NO-UNDO.  /* loop index */
DEFINE VARIABLE i          AS INTEGER NO-UNDO.  /* loop index */

DO WITH FRAME dialog-1:

  IF (browserName <> "") THEN RETURN.

  /* Make sure something is selected */
  RUN CheckSelect.ip (OUTPUT iTableNum).
  IF iTableNum = 0 THEN
  RETURN.

  /* Get the selected name from the "picked list". */
  ASSIGN
    cFldTemp = {&CurRight}:screen-value.

  DO iTemp = 1 TO NUM-ENTRIES (cFldTemp, {&Sep1}):

    ASSIGN
      cTableName = ENTRY(iTemp,cFldTemp,{&Sep1}) /* full entry name */
      cTemp      = ENTRY(1,ENTRY(iTemp,cFldTemp,{&Sep1})," ")   /* table name */
      pos        = LOOKUP(cTableName,{&CurRight}:LIST-ITEMS,{&Sep1})
      .

    /*
    ** Check to see if the table is used anywhere else !
    */
    DO j = {&Sort} TO {&Field}:
      cFldDelete = whRight [j]:LIST-ITEMS.
      DO i = 1 TO NUM-ENTRIES (cFldDelete, {&Sep1}):

        IF NUM-ENTRIES (ENTRY (1, cTemp, " "), ".") = 2 THEN
          cFldName = ENTRY (1, ENTRY (i, cFldDelete, {&Sep1}), ".") + "." +
          ENTRY (2, ENTRY (i, cFldDelete, {&Sep1}), ".").
        ELSE
          cFldName = ENTRY (1, ENTRY (i, cFldDelete, {&Sep1}), ".").

        /*
         * IF the table matches or there is only one table selected that is 
         * being deleted then delete the corresponding selected sort of field 
         * stuff from the selection list and the corresponding data
         */
        IF (ENTRY (1, cTemp, " ") = cFldName) OR
          (NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) = 1) THEN DO:
          RUN adecomm/_delitem.p (whRight[j]:HANDLE,
            ENTRY (i, cFldDelete, {&Sep1}), OUTPUT cnt).

          ENTRY (i, cMoreData [j], {&Sep1}) = "".
        END.
      END.
      /* Collapse the data after deletion */
      cMoreData [j] = TRIM (REPLACE (cMoreData [j], {&Sep1} + {&Sep1}, {&Sep1}), {&Sep1}).
    END.

    RUN adecomm/_delitem.p ({&CurRight}:HANDLE, cTableName, OUTPUT cnt).

    /** Rebuild the table list based on the info in the right list **/
    {&CurRight}:PRIVATE-DATA = ?.

    DO i = 1 TO NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}):
      {&CurRight}:PRIVATE-DATA = (IF {&CurRight}:PRIVATE-DATA = ? THEN ""
      ELSE
      {&CurRight}:PRIVATE-DATA + {&Sep1})  +
      ENTRY(1, ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}), " ").
    END.
    /*
    ** Check to see if the current table in sort or field is what has been
    ** Deleted and if it is reset it to ? cTemp = table only
    */
    DO j = {&Sort} TO {&Field}:
      IF (whLeft[j]:PRIVATE-DATA = cTemp) THEN
      whLeft[j]:PRIVATE-DATA = ?.
    END.
    /*
    ** Check to see if the current table in Join or Where is what has been
    ** Deleted and if it is reset it to ? cTableName full Right Expression
    ** (order OF order-line)
    */
    DO j = {&Join} TO {&Where}:
      IF (whLeft[j]:PRIVATE-DATA = cTableName) THEN
      whLeft[j]:PRIVATE-DATA = ?.
    END.
    /*
    **	Delete all the ttWhere records.
    */
    DO j = {&Join} TO {&Where}:
      FOR EACH ttWhere WHERE j = ttWhere.iState AND cTemp = ttWhere.cTable:
        DELETE ttWhere.
      END.

      IF (j = {&Where}) THEN
      acWhere [pos] = "".
      ELSE
      acJoin  [pos] = "".
    END.
    /*
    ** Insert field back in it's proper place.  Determine the position
    ** this field took in original field list.  Look from this point
    ** down in original list until  find an entry that is still in
    ** the left hand field list.  This is the entry we want to insert
    ** above.
    */
    IF (NUM-ENTRIES (cTemp, ".") > 1) THEN
    ASSIGN
      cTableName = cTemp
      ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".") = ""
      cTableName = TRIM (REPLACE (cTableName, "..", "."), ".")
      cTemp      = ENTRY (NUM-ENTRIES (cTemp, "."), cTemp, ".")
      .
    /*
    ** This code assumes that the list on the Left side is in
    **  aplhabetical order and will insert or add accordingly
    */
    DO j = 1 TO NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}):
      IF (ENTRY (j, {&CurLeft}:LIST-ITEMS, {&Sep1}) > cTemp) THEN
      DO:
        ASSIGN
          err   = {&CurLeft}:INSERT(cTemp,
                    ENTRY(j,{&CurLeft}:LIST-ITEMS,{&Sep1}))
          cTemp = "".
        LEAVE.
      END.
    END.

    IF j > NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) THEN
      err = {&CurLeft}:ADD-LAST(cTemp).

    /* Select the cTemp value, making sure it's in view. */
    RUN adecomm/_scroll.p ({&CurLeft}:HANDLE, INPUT cTemp).

  END. /* END DELETE LOOP */
  /*
  ** If we are deleting the first item and there are more items then
  ** remove the stuff on the right of the 2 item which soon will be the
  ** First item
  */
  IF (NUM-ENTRIES (ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}), " ") > 1) THEN
  ASSIGN
    cFieldName = {&CurRight}:LIST-ITEMS
    cTempOne = ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1})
    cTempOne = ENTRY (1, cTempOne, " ")
    ENTRY (1, cFieldName, {&Sep1}) = cTempOne
    {&CurRight}:LIST-ITEMS = cFieldName
    .

  ASSIGN
    whLeft  [INTEGER (rsMain:screen-value)]:LIST-ITEMS = {&CurLeft}:LIST-ITEMS.

  /*    message '5'   view-as alert-box error button Ok. */

  DO j = {&Sort} TO {&Field}:
    IF ((NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) = 1) AND
      NUM-ENTRIES (whRight [j]:LIST-ITEMS, "."   ) > 1) THEN DO:
      cTemp = whRight [j]:LIST-ITEMS.
      DO i = 1 TO NUM-ENTRIES (cTemp, {&Sep1}):
        ASSIGN
          ENTRY (i, cTemp, {&Sep1}) =
          ENTRY (NUM-ENTRIES (ENTRY (i, cTemp, {&Sep1}), "."),
          ENTRY (i, cTemp, {&Sep1}), ".")
          ENTRY (i, cMoreData [j], {&Sep1}) =
          ENTRY (NUM-ENTRIES (ENTRY (i, cMoreData [j], {&Sep1}), "."),
          ENTRY (i, cMoreData [j], {&Sep1}), ".")
          .
      END.
      whRight [j]:LIST-ITEMS = cTemp.
    END.
  END.

  RUN BuildQuery.ip (OUTPUT eDisplayCode).

  ASSIGN
    eDisplayCode:SCREEN-VALUE = eDisplayCode
    bCheckSyntax:sensitive  	= (IF eDisplayCode <> "" THEN TRUE ELSE FALSE)
    .
END.
END.
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
DEFINE VARIABLE cMatch       AS CHARACTER   NO-UNDO INIT FALSE.
DEFINE VARIABLE cName        AS CHARACTER NO-UNDO.
DEFINE VAR cFldName AS CHAR    NO-UNDO.
DEFINE VAR cTempOrg AS CHAR    NO-UNDO.
DEFINE VAR cnt      AS INTEGER NO-UNDO.
DEFINE VAR err      AS LOGICAL NO-UNDO.
DEFINE VAR pos      AS INTEGER NO-UNDO.
DEFINE VAR nxtname  AS CHAR    NO-UNDO.
DEFINE VAR ix       AS INTEGER NO-UNDO.  /* loop index */
DEFINE VAR i        AS INTEGER NO-UNDO.  /* loop index */
DEFINE VAR k        AS INTEGER NO-UNDO.  /* loop index */
DEFINE VAR icurrent AS INTEGER NO-UNDO.  /* loop index */

DO WITH FRAME dialog-1:

  /* Make sure something is selected */
  RUN CheckSelect.ip (OUTPUT iTableNum).
  IF iTableNum = 0 THEN RETURN.

  /* Get the selected name from the "picked list". */
  ASSIGN
    cFldName = {&CurRight}:screen-value
    .

  DO iTemp = 1 TO NUM-ENTRIES (cFldName, {&Sep1}):

    ASSIGN
      cTableName = ENTRY (iTemp, cFldName, {&Sep1})
      cTemp      = ENTRY (1, ENTRY (iTemp, cFldName, {&Sep1}), " ")
      i          = LOOKUP (cTemp, {&CurRight}:LIST-ITEMS, {&Sep1})
      .

    /* Remove this name from the "picked list" */
    RUN adecomm/_delitem.p ({&CurRight}:HANDLE, cTableName, OUTPUT cnt).

    /*    message '21'  view-as alert-box error button Ok. */
    /* Insert field back in it's proper place.  Determine the position
    this field took in original field list.  Look from this point
    down in original list until  find an entry that is still in
    the left hand field list.  This is the entry we want to insert
    above.
    */

    IF ((NUM-ENTRIES (cTemp, ".") > 1) AND
      ({&DisFieldList} <> {&CurTable})) THEN
    ASSIGN
      cTableName = cTemp
      ENTRY (NUM-ENTRIES (cTableName, "."), cTableName, ".") = ""
      cTableName = TRIM (REPLACE (cTableName, "..", "."), ".")
      cTemp      = ENTRY (NUM-ENTRIES (cTemp, "."), cTemp,".")
      .

    IF INTEGER (rsMain:screen-value) = {&Sort} OR
      INTEGER (rsMain:screen-value) = {&Field} THEN DO:
      ASSIGN
        ENTRY (i, {&CurData}, {&Sep1}) = ""
        {&CurData} = TRIM(REPLACE({&CurData},{&Sep1} + {&Sep1},{&Sep1}),{&Sep1})
        .
      RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
      eDisplayCode:SCREEN-VALUE = eDisplayCode.
    END.

    /*    message '3' skip '[' {&CurData} ']'    skip
    cTableName
    view-as alert-box error button Ok.  */

    /*
     * IF the current table is not a match to the table part of the deleting 
     * item Next.
     */
    IF ((cTableName <> {&CurTable}) AND (cTableName <> cTemp) AND
      ({&DisFieldList} <> {&CurTable})) THEN NEXT.

    /*
     * IF the field is in the field and we are dealing with the dispplay 
     * field lsit List continue.
     */
    IF (({&DisFieldList} = {&CurTable}) AND
      (CAN-DO (whLeft[{&Field}]:LIST-ITEMS, cTemp))) THEN
    NEXT.

    /*
    ** Adds to the left side and handle array junk...
    */
    RUN adecomm/_collaps.p ({&CurLeft}:HANDLE, cTemp).

    /* Select the cTemp value, making sure it's in view. */
    /*    RUN adecomm/_scroll.p ({&CurLeft}:HANDLE, INPUT cTemp). */
  END.

  ASSIGN
    whLeft  [INTEGER (rsMain:screen-value)]:LIST-ITEMS = {&CurLeft}:LIST-ITEMS.

  DO j = {&Sort} TO {&Field}:
    /*    IF ((NUM-ENTRIES ({&CurLeft}:LIST-ITEMS, {&Sep1}) = 1) AND */
    IF ((NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}) = 1) AND
      NUM-ENTRIES (whRight [j]:LIST-ITEMS, ".") > 1) THEN
    DO:
      cTemp = whRight [j]:LIST-ITEMS.
      DO i = 1 TO NUM-ENTRIES (cTemp, {&Sep1}):
        ASSIGN
          ENTRY (i, cTemp, {&Sep1}) = 
            ENTRY (NUM-ENTRIES (ENTRY (i, cTemp, {&Sep1}), "."),
          ENTRY (i, cTemp, {&Sep1}), ".")
          ENTRY (i, cMoreData [j], {&Sep1}) =
          ENTRY (NUM-ENTRIES (ENTRY (i, cMoreData [j], {&Sep1}), "."),
          ENTRY (i, cMoreData [j], {&Sep1}), ".")
          .
      END.
      whRight [j]:LIST-ITEMS = cTemp.
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
PROCEDURE CheckSelect.ip:

DEFINE OUTPUT PARAMETER iTblNum AS INTEGER NO-UNDO.

DO WITH FRAME dialog-1:

  IF {&CurRight}:SCREEN-VALUE NE ? THEN
  iTblNum = LOOKUP({&CurRight}:SCREEN-VALUE,
    {&CurRight}:LIST-ITEMS, {&Sep1}).
  IF iTblNum = 0 THEN
  MESSAGE "Please select a table."
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
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

/*
** v_CurrentName is the tbl name as it is refered to in this session.
** If only one db is connected, it will be just a table name, else it
** will be a db.table name.
*/

DO WITH FRAME dialog-1:

  iTableNum = NUM-ENTRIES({&CurRight}:LIST-ITEMS, {&Sep1}) + 1.

  IF iTableNum = ? THEN
  iTableNum = 1.

  ASSIGN
    rDbId[iTableNum] = ?
    rTableId[iTableNum] = ?.

  IF NUM-ENTRIES (p_InName, ".") = 1  THEN
  p_InName = {&CurTable} + "." + p_InName.

  /* First find the ids for the table and the database */
  IF NUM-ENTRIES(p_InName, ".") = 2 THEN DO:
    ASSIGN
      v_DBName   = ENTRY(1,p_InName,".")
      v_TblName  = ENTRY(2,p_InName,".").

    RUN adecomm/_getdbid.p (v_dbname, OUTPUT rDbId[iTableNum]).

    IF rDbId[iTableNum] NE ? THEN
    RUN adecomm/_gttblid.p (rDbId[iTableNum], v_TblName, 
                            OUTPUT rTableId[iTableNum]).

    /* if I could not find the db/table id, I will try with just the tblname */
    IF rTableId[iTableNum] = ? THEN
      p_InName = v_TblName.
  END.

  /* if they did not store name, or we could not find it, look for tbl */

  IF rTableId[iTableNum] = ? THEN DO:
    lLogical = YES.
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lLogical, "w", "ok",
      SUBSTITUTE("Table &1 was not found in connected database(s).",p_InName)).
  END.

  /* now remove this entry from the avail list and add it to picked */
  ASSIGN
    v_CurrentName = v_TblName
    cSchema[iTableNum] = (IF rTableId[iTableNum] NE ?
    THEN LDBNAME("DICTDB") ELSE ?)
    .

  /*  RUN adecomm/_delitem.p ({&CurLeft}:HANDLE, v_CurrentName, OUTPUT cnt). */

  IF (NUM-ENTRIES (slComboBox:LIST-ITEMS, {&Sep1}) > 1) THEN
  v_CurrentName = v_DBName + "." + v_CurrentName.

  IF INTEGER (rsMain:screen-value) = {&Table} THEN DO:
    lOK = ?.

    DO i = NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) TO 1 BY -1:
      ASSIGN
        cFieldName = v_CurrentName
        cTemp = ENTRY (1, ENTRY (i, {&CurRight}:LIST-ITEMS, {&Sep1}), " ").

      RUN adecomm/_qisjoin.p (cFieldName, cTemp, OUTPUT lOk).
      IF (lOK) THEN LEAVE.
    END.

    IF lOk THEN
      cTemp = ENTRY (1, ENTRY (i, {&CurRight}:LIST-ITEMS, {&Sep1}), " ").
    ELSE IF NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) = 1 THEN
      cTemp = ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}).
    ELSE IF NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) > 1 THEN DO:
      RUN pickTable.ip ({&CurRight}:PRIVATE-DATA, INPUT-OUTPUT cTemp).
      IF (cTemp = ?) THEN
      RETURN.
    END.

    {&CurRight}:PRIVATE-DATA = (IF {&CurRight}:PRIVATE-DATA = ? THEN ""
                               ELSE {&CurRight}:PRIVATE-DATA + {&Sep1})  
                                 +  v_CurrentName.

    v_CurrentName   = (IF lOk = ? THEN v_CurrentName
                       ELSE IF lOk THEN v_CurrentName + " OF "	+ cTemp
                       ELSE v_CurrentName + " WHERE " + cTemp + " ...").

    lOk = {&CurRight}:ADD-LAST (v_CurrentName).
  END.
  ELSE
    lOk = {&CurRight}:ADD-LAST (v_CurrentName).

  RUN adecomm/_delitem.p ({&CurLeft}:HANDLE, v_TblName, OUTPUT cnt).

  DO j = {&Sort} TO {&Field}:
    IF ((NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}) > 1) AND
      NUM-ENTRIES (whRight [j]:LIST-ITEMS, ".") = 1) THEN
    DO:
      cTemp = whRight [j]:LIST-ITEMS.
      DO i = 1 TO NUM-ENTRIES (cTemp, {&Sep1}):
        ASSIGN
          ENTRY (i, cTemp, {&Sep1}) = 
            ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}) + "." +
            ENTRY (i, cTemp, {&Sep1})
          ENTRY (i, cMoreData [j], {&Sep1}) =
            ENTRY (1, {&CurRight}:LIST-ITEMS, {&Sep1}) + "." + 
            ENTRY (i, cMoreData [j], {&Sep1})
          .
      END.
      whRight [j]:LIST-ITEMS = cTemp.
    END.
  END.
  /*
  ** Create the Where Undo Temp Table.
  */
  DO j = {&Join} TO {&Where}:
    CREATE ttWhere.
    VALIDATE ttWhere.   /* These validates are necessary to force the write  */
    ASSIGN
      ttWhere.iState      = j
      ttWhere.cTable      = ENTRY (1, v_CurrentName, " ")
      ttWhere.iSeq        = 0
      ttWhere.iOffset     = 1
      ttWhere.cExpression = ""   /*** THIS MIGHT HAVE TO BE INITTED LATER ****/
      ttWHere.lOperator   = TRUE
      .

  END.

  RUN BuildQuery.ip (OUTPUT eDisplayCode).

  ASSIGN
    eDisplayCode:SCREEN-VALUE = eDisplayCode
    bCheckSyntax:sensitive  	= (IF eDisplayCode <> "" THEN TRUE ELSE FALSE)
    .
END.
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE FieldFormat.ip.
DEFINE INPUT PARAMETER cList AS CHARACTER.
DEFINE VAR cFormat AS CHARACTER.
DEFINE VAR counter AS INTEGER.

DO WITH FRAME dialog-1:

  IF (cList = ?) OR (NUM-ENTRIES (cList, {&Sep1}) <> 1) THEN DO:
    ASSIGN
      eFieldLabel:SENSITIVE     = FALSE
      eFieldFormat:SENSITIVE    = FALSE
      bFieldFormat:SENSITIVE    = FALSE
      eFieldLabel:SCREEN-VALUE  = ""
      eFieldFormat:SCREEN-VALUE = "".
    RETURN.
  END.

  /*
  ** Get the currenet Label and if it is NOT set get the label's value
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
    {&CurData}, {&Sep1}), {&sep2}) = "") THEN DO:
    RUN DB_Field.ip (cList, "FORMAT", OUTPUT cTemp).
    DO counter = 2 TO NUM-ENTRIES (cTemp):
      cFormat = IF (counter = 2) THEN ENTRY (counter, cTemp)
                ELSE cFormat + ",":u + ENTRY (counter, cTemp).
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
PROCEDURE DB_Field.ip.
DEFINE INPUT  PARAMETER cList   AS CHARACTER.
DEFINE INPUT  PARAMETER cType   AS CHARACTER.
DEFINE OUTPUT PARAMETER cOutput AS CHARACTER.

RUN DB_LongField.ip (cList, cType,
  OUTPUT cCurrentDB,
  OUTPUT cTableName,
  OUTPUT cFieldName,
  OUTPUT cOutput).

END PROCEDURE.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE DB_LongField.ip.
DEFINE INPUT   PARAMETER cList   AS CHARACTER.
DEFINE INPUT   PARAMETER cType   AS CHARACTER.
DEFINE OUTPUT  PARAMETER cDataBase   AS CHARACTER.
DEFINE OUTPUT  PARAMETER cTableName   AS CHARACTER.
DEFINE OUTPUT  PARAMETER cFieldName   AS CHARACTER.
DEFINE OUTPUT  PARAMETER cOutput AS CHARACTER.

DO WITH FRAME dialog-1:

  IF (cList = ?) OR (NUM-ENTRIES (cList, {&Sep1}) <> 1) THEN RETURN.

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
    RUN adecomm/_s-schem.p (cDatabase,cTableName,cFieldName,"FIELD:LABEL", 
                            OUTPUT cOutput).
  ELSE
    RUN adecomm/_s-schem.p (cDataBase,cTableName,cFieldName,"FIELD:TYP&FMT", 
                            OUTPUT cOutput).
END.
END PROCEDURE.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE ValueChangeRight.ip.

ASSIGN
  cTemp  = SELF:SCREEN-VALUE
  sIndex = cTemp.

DO WITH FRAME dialog-1:
  {&CurLeft}:SCREEN-VALUE  = "".

  RUN adecomm/_qset.p ("setUpDown", TRUE).

  IF (INTEGER (rsMain:screen-value) = {&Sort}) THEN DO:
    IF ({&CurRight}:SCREEN-VALUE = ?) OR
      (NUM-ENTRIES ({&CurRight}:SCREEN-VALUE, {&Sep1}) <> 1) THEN
      rsSortDirection:SENSITIVE     = FALSE.
    ELSE
      rsSortDirection:SENSITIVE     = TRUE.

    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).

    ASSIGN
      eDisplayCode:SCREEN-VALUE = eDisplayCode
      SELF:SCREEN-VALUE = cTemp.
  END.
  ELSE
  IF (INTEGER (rsMain:screen-value) = {&Field}) THEN
    RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).
END.
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE ValueChangeLeft.ip.
DO WITH FRAME dialog-1:

  {&CurRight}:SCREEN-VALUE  = "".

  RUN adecomm/_qset.p ("setUpDown", TRUE).

  IF (INTEGER (rsMain:screen-value) = {&Field}) THEN
    RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).
END.
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE DefaultActionRight.ip.

DO WITH FRAME dialog-1:
  IF (INTEGER (rsMain:screen-value) = {&Join}) THEN
    RUN join.ip (lRight:SCREEN-VALUE + "." + SELF:SCREEN-VALUE, FALSE).
  ELSE IF (INTEGER (rsMain:screen-value) = {&Table}) THEN
    RUN tableremove.ip.
  ELSE
    RUN rightremove.ip.

  RUN adecomm/_qset.p ("setUpDown", TRUE).

  IF (INTEGER (rsMain:screen-value) = {&Field}) THEN
  RUN FieldFormat.ip ({&CurRight}:SCREEN-VALUE).
END.
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE DefaultActionLeft.ip.
DEFINE VARIABLE iSelectCount AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSelection   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cArrayList   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cArrayEntry  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iArrayHigh   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iArrayLow    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iArrayNum    AS INTEGER   NO-UNDO.

DO WITH FRAME dialog-1:
  IF {&CurLeft}:screen-value <> ? THEN DO:
    cSelection = {&CurLeft}:screen-value.
    DO iSelectCount = 1 TO NUM-ENTRIES (cSelection, {&Sep1}):
      /** If we are doing table adding  **/
      IF (INTEGER (rsMain:screen-value) = {&Where}) THEN
        RUN LeftWhere.ip.
      ELSE IF (INTEGER (rsMain:screen-value) = {&Join}) THEN
        RUN join.ip (lLeft:SCREEN-VALUE + "." + SELF:SCREEN-VALUE, FALSE).
      /** If we are doing table adding  **/
      ELSE IF (INTEGER (rsMain:screen-value) = {&Table}) THEN
        RUN addTable.ip (ENTRY (iSelectCount, cSelection, {&Sep1})).
      ELSE DO:

      /** If we are doing field or sort adding  **/
        RUN adecomm/_delitem.p ({&CurLeft}:HANDLE,
          ENTRY (iSelectCount, cSelection, {&Sep1}), OUTPUT i).
        ASSIGN
          cTemp = (IF ((INTEGER(NUM-ENTRIES(whRight[{&Table}]:LIST-ITEMS, 
                     {&Sep1})) > 1) AND
                     ({&DisFieldList} <> {&CurTable})) THEN
                     {&CurTable} + ".":u + 
                     ENTRY(iSelectCount,cSelection,{&Sep1}) 
                   ELSE ENTRY (iSelectCount, cSelection, {&Sep1})).
        .
        /*
        ** If it matches the it is an array thing.
        */
        IF cTemp MATCHES ("*[*]*":u) THEN DO:
          ASSIGN
            cTemp      = TRIM(cTemp)
            cArrayList = SUBSTRING(cTemp,INDEX(cTemp,'[':u) + 1,-1,
                                   "CHARACTER":u)
            cArrayList = REPLACE(cArrayList,"]":u,"")
            cTemp      = SUBSTRING(cTemp,1,INDEX(cTemp,'[':u) - 1,"CHARACTER":u)
            .
          /*
          ** Loop through the list base on ,
          */
          DO i = 1 TO NUM-ENTRIES (cArrayList):
            ASSIGN
              cArrayEntry = ENTRY (i, cArrayList)
              iArrayLow   = INTEGER (ENTRY (1, cArrayEntry, '-'))
              iArrayHigh  = INTEGER (ENTRY (NUM-ENTRIES (cArrayEntry, '-'), 
                              cArrayEntry, '-'))
              .
            /*
             * Loop through the list base on X-Y. X is the low number Y is 
             * the high number
             */
            DO j = iArrayLow TO iArrayHigh:

              ASSIGN
                cArrayEntry = cTemp + '[' + STRING (j) + ']' 
                lOk         = {&CurRight}:ADD-LAST (cArrayEntry)
                .
              IF INTEGER (rsMain:screen-value) = {&Field} THEN
                {&CurData} = {&CurData} + (IF ({&CurData} = "") THEN ""
              ELSE
                {&Sep1}) + cArrayEntry + {&sep2} + {&sep2}.
              ELSE IF INTEGER (rsMain:screen-value) = {&Sort} THEN
                {&CurData} = {&CurData} + (IF ({&CurData} = "") THEN ""
              ELSE
                {&Sep1}) + cArrayEntry + {&sep2} + 'yes'.
            END.
          END.
        END.
        ELSE DO:

          lOk = {&CurRight}:ADD-LAST (cTemp).

          IF INTEGER (rsMain:screen-value) = {&Field} THEN
            {&CurData} = {&CurData} + (IF ({&CurData} = "") THEN ""
          ELSE
            {&Sep1}) + cTemp + {&sep2} + {&sep2}.
          ELSE IF INTEGER (rsMain:screen-value) = {&Sort} THEN
            {&CurData} = {&CurData} + (IF ({&CurData} = "") THEN ""
          ELSE
            {&Sep1}) + cTemp + {&sep2} + 'yes'.
        END.

        RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
        eDisplayCode:SCREEN-VALUE = eDisplayCode.
      END.
    END.
    ASSIGN
      bAdd:SENSITIVE    = ({&CurLeft}:LIST-ITEMS NE ?)
      rsSortDirection:sensitive  = ({&CurRight}:SCREEN-VALUE NE ?)
      .
  END.
END.
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE CheckDisplayWidth.ip.
DEFINE OUTPUT PARAMETER lError AS LOGICAL INITIAL TRUE NO-UNDO.

DEFINE VARIABLE FldNameList   AS CHAR EXTENT {&MaxTbl} NO-UNDO.
DEFINE VARIABLE FldLabelList  AS CHAR EXTENT {&MaxTbl} NO-UNDO.
DEFINE VARIABLE FldFormatList AS CHAR EXTENT {&MaxTbl} NO-UNDO.
DEFINE VARIABLE i             AS INTEGER   	       NO-UNDO.
DEFINE VARIABLE fmt           AS CHAR                  NO-UNDO.
DEFINE VARIABLE fd-tp         AS INTEGER               NO-UNDO.
DEFINE VARIABLE col-wdth      AS INTEGER               NO-UNDO.
DEFINE VARIABLE tot-wdth      AS INTEGER               NO-UNDO.
DEFINE VARIABLE lFmtError     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE lbl           AS CHAR                  NO-UNDO.

DO WITH FRAME dialog-1:
  ASSIGN
    lError = FALSE
    tot-wdth = 0.

  DO i = 1 TO NUM-ENTRIES ({&CurFieldData}, {&Sep1}):
    IF i > EXTENT (FldNameList) THEN DO:
      MESSAGE 'The BROWSE interface only supports UP TO 20 fields.' SKIP
        'Only the FIRST 20 FIELDS WHERE saved.'.
      LEAVE.
    END.
    ELSE
    ASSIGN				
      FldNameList  [i] = ENTRY (1, ENTRY (i, {&CurFieldData}, {&Sep1}), {&Sep2})
      FldLabelList [i] = ENTRY (2, ENTRY (i, {&CurFieldData}, {&Sep1}), {&Sep2})
      FldFormatList[i] = ENTRY (3, ENTRY (i, {&CurFieldData}, {&Sep1}), {&Sep2})
      .
    IF ((NUM-ENTRIES (FldNameList  [i], ".") = 1) AND
      (NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}) = 1)) THEN
      FldNameList [i] = {&TableRight}:LIST-ITEMS + "." + FldNameList [i].

    IF (NUM-ENTRIES (FldNameList  [i], ".") = 2)  THEN
      FldNameList [i] =  LDBNAME (1) + "." + FldNameList [i].

    RUN adecomm/_s-schem.p (FldNameList[i],"","","FIELD:TYP&FMT",OUTPUT fmt).

    ASSIGN fd-tp = INTEGER(ENTRY(1,fmt)) /* Fld Type 1-ch, 2-da, 3-lo, 4-int  */
      /* ksu 02/23/94 default mode */
      fmt   = SUBSTRING(fmt,3,-1,"CHARACTER":u).  /* Format                   */
    IF FldFormatList[i] NE ? AND FldFormatList[i] NE "" THEN
      fmt = FldFormatList[i].

    IF FldLabelList[i] NE ? AND FldLabelList[i] NE " " THEN
      lbl = FldLabelList[i].
    ELSE
      RUN adecomm/_s-schem.p (FldNameList[i],"","","FIELD:LABEL",OUTPUT lbl).
    IF NUM-ENTRIES(lbl,"!") > 1 THEN
    ASSIGN lbl             = ENTRY(NUM-ENTRIES(lbl,"!"),lbl,"!")
           FldLabelList[i] = lbl.

    RUN adecomm/_chkfmt.p (fd-tp,"",lbl,fmt,OUTPUT col-wdth,OUTPUT lFmtError).
    IF (lFmtError) THEN
      fmt = FILL ("?", col-wdth).

    tot-wdth = tot-wdth + col-wdth.

    IF (tot-wdth > 310) THEN DO:
      MESSAGE "The display width of the all the select fields exceeds 310." SKIP
        "The current display width is " tot-wdth "." SKIP
        "Please remove a field or fields."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

      IF rsMain:SCREEN-VALUE <> "{&Field}" THEN DO:
        rsMain:SCREEN-VALUE = "5".
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
PROCEDURE MoveList.ip.
DEFINE INPUT        PARAMETER lUp        AS LOGICAL NO-UNDO.
DEFINE INPUT        PARAMETER cValue     AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER cSeperator AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER cList      AS CHARACTER NO-UNDO.

/*  DEFINE VARIABLE cSeperator  AS CHARACTER   NO-UNDO INIT {&Sep1}. */
DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
DEFINE VARIABLE j     AS INTEGER     NO-UNDO.

DO WITH FRAME dialog-1:
  IF (cValue <> ?) THEN DO:
    i = LOOKUP (ENTRY (1, cValue, cSeperator), cList, cSeperator).

    DO j = 1 TO NUM-ENTRIES(cValue, cSeperator):
      ASSIGN
        ENTRY (LOOKUP (ENTRY (j, cValue, cSeperator), cList, cSeperator), 
           cList, cSeperator) = ""
        cList = TRIM (REPLACE (cList, cSeperator + cSeperator, cSeperator), 
           cSeperator).
    END.

    ASSIGN
      cList = TRIM (cList, cSeperator)
      i     = (IF lUp THEN  MAXIMUM (i - 1, 1) ELSE
               MINIMUM (i, NUM-ENTRIES(cList, cSeperator))).

    IF i = 0 THEN
      cList = cValue.
    ELSE DO:
      IF (lUp) THEN
      ENTRY (i, cList, cSeperator) = cValue
        + (IF cList = "" THEN "" ELSE cSeperator + ENTRY(i,cList,cSeperator)).
      ELSE
      ENTRY(i,cList,cSeperator) = ENTRY(i,cList,cSeperator) 
                                + cSeperator + cValue.
    END.
  END /* IF */ .

END /* DO */ .
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE DisplaySort.ip.
DEFINE INPUT PARAMETER lAppend AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER iSpace  AS INTEGER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER cSort   AS CHARACTER NO-UNDO.

DEFINE VARIABLE cTemp  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cField AS CHARACTER NO-UNDO.

DO WITH FRAME dialog-1:

  IF ((INTEGER (rsMain:screen-value) <> {&Sort}) AND (NOT lAppend)) THEN
  RETURN.

  cTemp = "".

  DO i = 1 TO NUM-ENTRIES ({&CurSortData}, {&Sep1}):
    DO j = 2 TO (i + iSpace):
      cTemp = cTemp + " ".
    END.

    cField = ENTRY (1, ENTRY (i, {&CurSortData}, {&Sep1}), {&sep2}).
    IF (NUM-ENTRIES (cField, ".") = 1) THEN
      cField = ENTRY (1, {&TableRight}:LIST-ITEMS, {&Sep1}) + "." + cField.

    IF (NUM-ENTRIES (cField, ".") = 2) THEN
      cField = LDBNAME (1)  + "." + cField.

    cTemp  =  cTemp + "BY " + cField + " " +
    (IF ENTRY (2, ENTRY (i, {&CurSortData}, {&Sep1}), {&sep2}) = 'yes' THEN
    "" ELSE "DESCENDING") + CHR (10).
  END.

  IF (lAppend) THEN
    cSort = cSort + cTemp.
  ELSE DO:
    cSort = cTemp.

    IF ({&CurRight}:SCREEN-VALUE <> ?) AND
      (NUM-ENTRIES ({&CurRight}:SCREEN-VALUE, {&Sep1}) = 1) THEN
    rsSortDirection:screen-value =
    STRING (ENTRY (2, ENTRY (LOOKUP ({&CurRight}:SCREEN-VALUE,
      {&CurRight}:LIST-ITEMS, {&Sep1}),
      {&CurSortData}, {&Sep1}), {&sep2})).
  END.
END.
END.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE BuildQuery.ip.
DEFINE OUTPUT PARAMETER cQuery   AS CHARACTER NO-UNDO.

DEFINE VAR cLine AS CHARACTER.
DEFINE VAR lWHere AS LOGICAL.

DO WITH FRAME dialog-1:

  cQuery = "".

  IF NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}) = 0 THEN RETURN.
END.

DO i = 1 TO NUM-ENTRIES ({&TableRight}:LIST-ITEMS, {&Sep1}):
  IF (1 = i) THEN
    cQuery = 'FOR '.
  ELSE
    cQuery = cQuery +  ' NO-LOCK,' + {&EOL} + '      '.

  cLine = ENTRY (i, {&TableRight}:LIST-ITEMS, {&Sep1}).

  /*
  ** If the line ends with ... then there should be a join attached so
  ** rebuild the line based on the join.
  */
  IF (ENTRY (
    NUM-ENTRIES (cLine, " "), cLine, " ")  = "...") AND
    (acJoin [i - 1] <> "") AND (acJoin [i - 1] <> ?) THEN
  ASSIGN
    lWhere = TRUE
    cLine = ENTRY (1, cLine, " ") + " WHERE " + acJoin [i - 1] .
  ELSE
  ASSIGN
    lWhere = FALSE
    cLine = ENTRY (i, {&TableRight}:LIST-ITEMS, {&Sep1}).

  /*
  ** If there is only one data base fully qualify
  */
  IF (NUM-ENTRIES (ENTRY (1, cLine, " "), ".") = 1) AND
    NOT suppressDbName THEN
    ENTRY (1, cLine, " ") = LDBNAME (1) + "." + ENTRY (1, cLine, " ").

  IF (NUM-ENTRIES (cLine, " ") > 2) AND
    (NUM-ENTRIES (ENTRY (3, cLine, " "), ".") = 1) AND
    NOT suppressDbName THEN
    ENTRY (3, cLine, " ") = LDBNAME (1) + "." + ENTRY (3, cLine, " ").

  cQuery = cQuery + 'EACH ' + cLine.

  IF (acWhere [i] <> "") THEN
    IF (lWHere) THEN
      cQuery= cQuery + {&EOL} + "      AND " + acWhere [i].
    ELSE
      cQuery= cQuery + {&EOL} + "      WHERE " + acWhere [i].
END.

IF (i = 1) THEN RETURN.

ASSIGN
  cQuery =  cQuery + ' NO-LOCK'.
  cLine  = ""
  .

RUN DisplaySort.ip (TRUE, 4, INPUT-OUTPUT cLine).

IF (cLine > "") THEN
  cQuery =  cQuery + {&EOL} + RIGHT-TRIM (cLine) + ":".
ELSE
  cQuery =  cQuery + ":".

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

DEFINE VARIABLE cText AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE cLine AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cCompOut AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cCompIn  AS CHARACTER            NO-UNDO.

DO WITH FRAME dialog-1:

  RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_TEMPLATE},{&STD_EXT_UIB},
                          OUTPUT cCompIn).

  OUTPUT TO VALUE (cCompIn) NO-ECHO {&NO-MAP}.

  /*
  DO i = 1 TO NUM-ENTRIES ({&CurRight}:LIST-ITEMS, {&Sep1}):
  PUT UNFORMATTED
  'FIND FIRST ':u ENTRY (i, {&CurRight}:LIST-ITEMS, {&Sep1}) '.':u SKIP.
  END.
  */

  lError = FALSE.

  RUN BuildQuery.ip (OUTPUT cText).

  IF (cText = "") OR (cText = "") THEN RETURN.

  PUT CONTROL  cText CHR (10).
  PUT UNFORMATTED "end." SKIP.

  OUTPUT CLOSE.

  RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_TEMPLATE}, {&STD_EXT_UIB}, 
                          OUTPUT cCompOut).

  OUTPUT TO VALUE(cCompOut) KEEP-MESSAGES.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    COMPILE VALUE(cCompIn).
  END.
  OUTPUT CLOSE.

  lError = COMPILER:ERROR.
  IF lError THEN DO:
    INPUT FROM VALUE (cCompOut) NO-ECHO {&NO-MAP}.
    REPEAT:
      IMPORT UNFORMATTED cLine.
      IF cLine MATCHES "* (198)":u THEN NEXT.
      cText = cText 
            + (IF cText = "" THEN "" ELSE CHR(10)) 
            + REPLACE (cLine, cCompIn,"").
    END.
    INPUT CLOSE.
    {&CurLeft}:SCREEN-VALUE  = "".
    {&CurRight}:SCREEN-VALUE = "".
    /*    {&CurRight}:SCREEN-VALUE = ENTRY(COMPILER:ERROR-ROW, {&CurRight}:LIST-ITEMS, {&Sep1}).*/

    RUN adecomm/_qset.p ("setUpDown", TRUE).
    MESSAGE cText VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    /*    RUN edit_where_clause.ip. */
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

DO WITH FRAME dialog-1:

  ASSIGN
    cList      = ""
    cTemp      = {&CurRight}:SCREEN-VALUE
    cListItems = {&CurRight}:LIST-ITEMS
    pos        = LOOKUP (cTemp, cListItems, {&Sep1})
    cLeft      = ENTRY (1, cTemp, " ")
    .

  /* find all potential join candidates */
  DO i = 1 TO NUM-ENTRIES (cListItems, {&Sep1}):
    IF ENTRY(i, {&CurRight}:LIST-ITEMS, {&Sep1}) = cTemp THEN
    LEAVE.
    cList = cList + (IF i = 1 THEN ""
    ELSE
    {&Sep1})
    + ENTRY (1, ENTRY (i, cListItems, {&Sep1})," ").
  END.

  ASSIGN
    cRight = (IF NUM-ENTRIES (cList, {&Sep1}) = 1 THEN 
                cLeft ELSE ENTRY (3, cTemp, " "))
    .

  IF NUM-ENTRIES(cList, {&Sep1}) > 1 THEN
    RUN pickTable.ip (cList, INPUT-OUTPUT cRight).

  IF cRight = ? THEN RETURN ERROR.
  /*
  ** Delete all the ttWhere records. By selecting a new join partner the
  ** users has invaildated the old join criteria so delete it.
  */
  FOR EACH ttWhere WHERE {&Join} = ttWhere.iState AND cLeft = ttWhere.cTable
      AND ttWhere.iSeq > 0 :
    DELETE ttWhere.
  END.

  IF (pos > 1) THEN
    acJoin  [pos - 1] = "".

  RUN adecomm/_qisjoin.p (cRight, cLeft, OUTPUT lOk).

  ASSIGN
    cTemp = ENTRY (1, cTemp, " ")
          + (IF lOK THEN " OF " + cRight
             ELSE " WHERE " + cRight + " ...")
    ENTRY (i, cListItems, {&Sep1}) = cTemp
    {&CurRight}:LIST-ITEMS = cListItems
    {&CurRight}:SCREEN-VALUE = cTemp
    .

  RUN BuildQuery.ip (OUTPUT eDisplayCode).
  eDisplayCode:SCREEN-VALUE = eDisplayCode.

END.
END PROCEDURE. /* changeJoinTarget.ip */
/*--------------------------------------------------------------------------*/

ON DEFAULT-ACTION OF v_pick IN FRAME fr_pick APPLY "GO" TO FRAME fr_pick.

/*--------------------------------------------------------------------------*/
PROCEDURE pickTable.ip:

DEFINE INPUT        PARAMETER ip_list AS CHARACTER NO-UNDO. /* list */
DEFINE INPUT-OUTPUT PARAMETER io_pick AS CHARACTER NO-UNDO. /* value */

ASSIGN
  v_pick:DELIMITER  IN FRAME fr_pick = {&Sep1}
  v_pick:LIST-ITEMS IN FRAME fr_pick = ip_list
  v_pick:SCREEN-VALUE IN FRAME fr_pick = (IF LOOKUP (io_pick, ip_list, {&Sep1}) > 0
  THEN io_pick ELSE ENTRY(1, ip_list, {&Sep1}))
  io_pick = ?.

ENABLE v_pick bOk bCancel WITH FRAME fr_pick.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME fr_pick FOCUS v_pick IN FRAME fr_pick.
  io_pick = v_pick:SCREEN-VALUE IN FRAME fr_pick.
END.
HIDE FRAME fr_pick NO-PAUSE.

END PROCEDURE. /* pick_a_table.ip */
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
returns TRUE if syntax error
-------------------------------------------------------------*/
PROCEDURE Debug.ip:

DO WITH FRAME dialog-1:

  MESSAGE
    'whRight[{&table}]:PRIVATE-DATA' whRight[{&table}]:PRIVATE-DATA SKIP
    'whLeft[{&table}]:PRIVATE-DATA'  whLeft[{&table}]:PRIVATE-DATA  SKIP
    '{&CurLeft}:PRIVATE-DATA'        {&CurLeft}:PRIVATE-DATA        SKIP
    '{&CurData} CURRENT:'   	     {&CurData}                     SKIP
    '{&CurSortData} SORT:'           {&CurSortData}                 SKIP
    '{&CurFieldData} FIELD:'	     {&CurFieldData}                SKIP
    'cMoreData[{&Table}]'            cMoreData[{&Table}]            SKIP
    '{&CurTable} CURRENT TABLE:'     {&CurTable}                    SKIP
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.
END PROCEDURE.
/* -----------------------------------------------------------
Purpose:
Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
Parameters:  <none>
Notes:
-------------------------------------------------------------*/
PROCEDURE Join.ip.

DEFINE INPUT PARAMETER cInsert   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER lOperator AS LOGICAL NO-UNDO.

DO WITH FRAME dialog-1:

  FIND LAST ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState AND
    lLeft:SCREEN-VALUE = ttWhere.cTable.

  i               = ttWhere.iSeq.
  /* if text selected, merely replace and return */
  /* ksu 02/23/94 LENGTH and SUBSTRING use default mode */
  /* dma 04/17/95 - CURSOR-OFFSET works in RAW mode */
  IF eDisplayCode:SELECTION-TEXT <> "" THEN
    lOK = eDisplayCode:REPLACE-SELECTION-TEXT (cInsert).
  ELSE IF (ttWhere.iOffset > 1 AND
    ttWhere.iOffset < LENGTH(ttWhere.cExpression,"RAW":u)) THEN
  ASSIGN
    eDisplayCode:SCREEN-VALUE  = SUBSTRING(ttWhere.cExpression,1,
                                   ttWhere.iOffset - 1,"RAW":u)
                               + cInsert
                               + SUBSTRING(ttWhere.cExpression,
                                   ttWhere.iOffset,-1,"RAW":u)
    eDisplayCode:CURSOR-OFFSET = ttWhere.iOffset
                               + LENGTH(cInsert,"RAW":U)
    .
  ELSE
  ASSIGN
    eDisplayCode:SCREEN-VALUE = (IF (eDisplayCode:SCREEN-VALUE = ""
                                 OR eDisplayCode:SCREEN-VALUE = ? ) THEN
                                   cInsert
                                 ELSE
                                   eDisplayCode:SCREEN-VALUE + " " + cInsert)
    eDisplayCode:CURSOR-OFFSET = LENGTH(eDisplayCode:SCREEN-VALUE,"RAW":U) + 1
    .

  CREATE ttWhere.

  ASSIGN
    eDisplayCode:sensitive     = (IF eDisplayCode:screen-value > "" THEN 
                                    TRUE ELSE FALSE)
    ttWhere.iState             = INTEGER(rsMain:screen-value)
    ttWhere.cTable             = lLeft:SCREEN-VALUE
    ttWhere.iSeq               = i + 1
    ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE
    ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET
    ttWhere.lOperator          = lOperator
    {&CurRight}:PRIVATE-DATA   = eDisplayCode:SCREEN-VALUE
    {&CurLeft}:screen-value    = ""
    {&CurRight}:screen-value   = ""
    {&CurLeft}:sensitive       = ttWhere.lOperator
    {&CurRight}:sensitive      = ttWhere.lOperator
    bUndo:SENSITIVE            = TRUE
    bCheckSyntax:SENSITIVE     = TRUE
    acJoin[LOOKUP({&CurTable},slComboBox:List-Items,{&Sep1})]
    = ttWhere.cExpression
    .

  RUN adecomm/_qset.p ("SetOperatorsSensitive.ip", NOT lOperator).

  /*
  IF eDisplayCode:sensitive THEN
  APPLY "ENTRY" TO eDisplayCode.
  */
END.
END PROCEDURE.
/*--------------------------------------------------------------------------*/
PROCEDURE LeftWhere.ip.

DO WITH FRAME dialog-1:

  DEFINE VARIABLE cTemp      AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE cMatchName AS CHARACTER NO-UNDO. /* fieldname pattern match */
  DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO. /* selected field name */

  &if {&Debug} &then
  MESSAGE "#1 in".
  &endif

  FIND LAST ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState AND
    lLeft:SCREEN-VALUE = ttWhere.cTable.
  ASSIGN
    i          = ttWhere.iSeq
    cTemp      = TRIM(eDisplayCode:SCREEN-VALUE)
    cFieldName = lLeft:SCREEN-VALUE + "." +
    /*    (IF NUM-ENTRIES({&TableRight}:LIST-ITEMS,{&Sep1} ) = 1 THEN
    IF lFullName THEN
    cTableList + ".":u
    ELSE
    ENTRY (2, cTableList, ".") + ".":u
    ELSE IF lHiden THEN
    LDBNAME("RESULTSDB":u) + ".":u
    ELSE "")
    + */
    {&CurLeft}:SCREEN-VALUE. /* QBF_S ?? */

  /* if text selected, merely replace and return */
  IF eDisplayCode:SELECTION-TEXT <> "" THEN
    lOK = eDisplayCode:REPLACE-SELECTION-TEXT (cFieldName).
  ELSE DO:
    /* if picking field name, check to see if it should replace the last */
    /* field name selected in the editor widget */
    RUN guess_field (OUTPUT cMatchName). /* do NOT put into cLastField */
    IF cMatchName <> ?
      AND (cTemp = cMatchName
      OR cTemp MATCHES "*":u + CHR(10) + "AND ":u + cMatchName
      OR cTemp MATCHES "*":u + CHR(10) + "OR ":u  + cMatchName) THEN DO:

      /* ksu 02/23/94 use default mode */
      cTemp = TRIM(SUBSTRING(" ":u + cTemp,1,
                             R-INDEX(CHR(10) + cTemp,CHR(10)),"CHARACTER":u)).
    END.

    IF (ttWhere.iOffset > 1 AND
      ttWhere.iOffset < LENGTH(ttWhere.cExpression,"RAW":U)) THEN
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = SUBSTRING(ttWhere.cExpression,1,
                                     ttWhere.iOffset - 1,"RAW":u)
                                 + cFieldName
                                 + SUBSTRING(ttWhere.cExpression,
                                     ttWhere.iOffset,-1,"RAW":u)
      eDisplayCode:CURSOR-OFFSET = ttWhere.iOffset
                                 + LENGTH(cFieldName,"RAW":U)
      .
    ELSE
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = (IF cTemp = "" THEN ""
                                    ELSE cTemp + CHR(10)
                                 + (IF TRIM(radio-set-2:SCREEN-VALUE) = "YES" 
                                    THEN "AND" ELSE "OR")
                                 + " ":u) + cFieldName

      eDisplayCode:CURSOR-OFFSET = LENGTH(eDisplayCode:SCREEN-VALUE,
                                     "RAW":U) + 1.
  END.

  CREATE ttWhere.

  ASSIGN
    eDisplayCode:sensitive     = (IF eDisplayCode:screen-value > "" THEN
                                  TRUE ELSE FALSE)
    cLastField                 = cFieldName
    ttWhere.iState             = INTEGER(rsMain:screen-value)
    ttWhere.cTable             = lLeft:SCREEN-VALUE
    ttWhere.iSeq               = i + 1
    ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE
    ttWhere.cLastField         = cLastField
    ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET
    {&CurLeft}:screen-value    = ""
    {&CurRight}:screen-value   = ""
    {&CurLeft}:sensitive       = ttWhere.lOperator
    {&CurRight}:sensitive      = ttWhere.lOperator
    bCheckSyntax:SENSITIVE     = TRUE
    bUndo:SENSITIVE            = TRUE
    acWhere [LOOKUP ({&CurTable}, slComboBox:List-Items, {&Sep1})] = ttWhere.cExpression
    .

  RUN load_ops.

  /*
  IF eDisplayCode:sensitive THEN
  APPLY "ENTRY" TO eDisplayCode.
  */

  &if {&Debug} &then
  MESSAGE "#1 out".
  &endif
END.
END.
/*--------------------------------------------------------------------------*/
/* try to get the last field listed in the expert window */

PROCEDURE guess_field:

&if {&Debug} &then
MESSAGE "#5 in".
&endif

DEFINE OUTPUT PARAMETER cFieldTarget AS CHARACTER NO-UNDO. /* potential field */

DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO. /* return value */
DEFINE VARIABLE lHiden AS LOGICAL   NO-UNDO.

DO WITH FRAME dialog-1:

  ASSIGN
    cFieldTarget = TRIM(eDisplayCode:SCREEN-VALUE,
                     " ,()=<>":u + CHR(9) + CHR(10) + CHR(13))
    cFieldTarget = (IF cFieldTarget = "" THEN ? ELSE
                    ENTRY(NUM-ENTRIES(cFieldTarget," ":u),cFieldTarget," ":u)).
  IF /* NUM-ENTRIES(cTableList) = 1 AND*/ INDEX(cFieldTarget,".":u) = 0 THEN
    cFieldTarget = lLeft:SCREEN-VALUE + ".":u + cFieldTarget.
  /*  IF lHiden AND NUM-ENTRIES(cFieldTarget,".":u) = 2 THEN
      cFieldTarget = LDBNAME("RESULTSDB":u) + ".":u + cFieldTarget.
  */

  IF NUM-ENTRIES(cFieldTarget,".":u) <> 3 THEN
  .
  ELSE IF lHiden THEN DO:
    /* if only one db available, quicker to search ourselves. */
    FIND FIRST DICTDB._Db NO-LOCK.
    FIND DICTDB._File OF DICTDB._Db
      WHERE DICTDB._File._File-name = ENTRY(2,cFieldTarget,".":u)
      NO-LOCK NO-ERROR.
    IF AVAILABLE DICTDB._File THEN
    FIND DICTDB._Field OF DICTDB._File
      WHERE DICTDB._Field._Field-name = ENTRY(3,cFieldTarget,".":u)
      NO-LOCK NO-ERROR.
    ELSE
    RELEASE DICTDB._Field. /* just in case... */
    IF NOT AVAILABLE DICTDB._Field THEN
      cFieldTarget = ?.
  END.
  ELSE
  DO:
    /* but if more than one db connected, call professional help. */
    RUN "adecomm/_y-schem.p" (cFieldTarget,"","",OUTPUT cAnswer).
    IF cAnswer = ? THEN
    cFieldTarget = ?.
  END.
  &if {&Debug} &then
  MESSAGE "#5 out".
  &endif
END.
END PROCEDURE. /* guess_field */


/*--------------------------------------------------------------------------*/
/* load up appropriate comparison operators into qbf-p */
PROCEDURE load_ops:

DO WITH FRAME dialog-1:

  &if {&Debug} &then
  MESSAGE "#7 in".
  &endif
  DEFINE VARIABLE iExtent AS INTEGER   NO-UNDO. /* extent */
  DEFINE VARIABLE i AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO. /* list-items string */
  DEFINE VARIABLE cDataType AS CHARACTER NO-UNDO. /* datatype */
  DEFINE VARIABLE cGuessField AS CHARACTER NO-UNDO. /* guessed field name */
  DEFINE VARIABLE lQBW AS LOGICAL   NO-UNDO. /* is qbw field? */

  RUN guess_field (OUTPUT cGuessField). /* returns ? for unknown field name */
  cLastField = (IF cGuessField = ? THEN
  cLastField ELSE
  cGuessField).

  /* if ((NOT lFullName) AND NUM-ENTRIES(cLastField, ".") = 2) then 
   * remove database piece ?
   */
  /*    cLastField = ENTRY (1, cTableList, ".") + "." + cLastField. */

  /* ggg cLastField = lLeft:SCREEN-VALUE + "." + {&CurLeft}:SCREEN-VALUE. */

  IF cLastField <> ? AND cLastField <> "" THEN DO:
    IF (NUM-ENTRIES (cLastField, ".") < 3) THEN
      RUN adecomm/_y-schem.p (cCurrentDb + "." + cLastField,"","",
                              OUTPUT cListItems).
    ELSE
      RUN adecomm/_y-schem.p (cLastField,"","",OUTPUT cListItems).
    ASSIGN
      cDataType = ENTRY(1,cListItems)
      iExtent   = INTEGER(ENTRY(2,cListItems))
      lQBW      = (ENTRY(4,cListItems) = "y":u).
  END.
  cListItems = "".

  /* if data type is datetime or datetime-tz, then set it to date */
  IF CAN-DO("34,40",cDataType) THEN
      cDataType = "2".

  /* if data type is INT64, then set it to INTEGER */
  IF cDataType = "41" THEN
      cDataType = "4".

  /* If field name is unknown, load up everything. */
  /* If selection-text non-null and guess_field = ?, load up everything. */

  DO i = 1 TO EXTENT(acWhereState):
    IF   (cLastField = ?)
      OR (cGuessField = ? AND eDisplayCode:SELECTION-TEXT <> "")
      OR (INDEX(ENTRY(1,acWhereState[i]),"q":u) > 0 AND lQBW)
      OR (INDEX(ENTRY(1,acWhereState[i]),cDataType) > 0          ) THEN
    /*
    cListItems = cListItems + (IF cListItems = "" THEN "" ELSE ",":u)
    + ENTRY(3,acWhereState[i]).
    */
    CASE i:
      WHEN {&bEqual}        THEN bEqual:SENSITIVE        = TRUE.
      WHEN {&bNotEqual}     THEN bNotEqual:SENSITIVE     = TRUE.
      WHEN {&bLess}         THEN bLess:SENSITIVE         = TRUE.
      WHEN {&bGreater}      THEN bGreater:SENSITIVE      = TRUE.
      WHEN {&bLessEqual}    THEN bLessEqual:SENSITIVE    = TRUE.
      WHEN {&bGreaterEqual} THEN bGreaterEqual:SENSITIVE = TRUE.
      WHEN {&bBegins}       THEN bBegins:SENSITIVE       = TRUE.
      WHEN {&bMatches}      THEN bMatches:SENSITIVE      = TRUE.
      /* WHEN {&bLike}        THEN bLike:SENSITIVE         = TRUE.*/
      WHEN {&bRange}        THEN bRange:SENSITIVE        = TRUE.
      WHEN {&bList}         THEN bList:SENSITIVE         = TRUE.
      WHEN {&bXMatches}     THEN bXMatches:SENSITIVE     = TRUE.
      WHEN {&bContains}     THEN bContains:SENSITIVE     = TRUE.
      /* WHEN {&bxRange}      THEN bxRange:SENSITIVE       = TRUE.
         WHEN {&bXList}       THEN bXList:SENSITIVE        = TRUE.*/
      WHEN {&bAnd }         THEN bAnd:SENSITIVE          = TRUE.
      WHEN {&bOr }          THEN bOr:SENSITIVE           = TRUE.
    END CASE.
  ELSE
  CASE i:
    WHEN {&bEqual}          THEN bEqual:SENSITIVE        = FALSE.
    WHEN {&bNotEqual}       THEN bNotEqual:SENSITIVE     = FALSE.
    WHEN {&bLess}           THEN bLess:SENSITIVE         = FALSE.
    WHEN {&bGreater}        THEN bGreater:SENSITIVE      = FALSE.
    WHEN {&bLessEqual}      THEN bLessEqual:SENSITIVE    = FALSE.
    WHEN {&bGreaterEqual}   THEN bGreaterEqual:SENSITIVE = FALSE.
    WHEN {&bBegins}         THEN bBegins:SENSITIVE       = FALSE.
    WHEN {&bMatches}        THEN bMatches:SENSITIVE      = FALSE.
    /* WHEN {&bLike}          THEN bLike:SENSITIVE         = FALSE.*/
    WHEN {&bRange}          THEN bRange:SENSITIVE        = FALSE.
    WHEN {&bList}           THEN bList:SENSITIVE         = FALSE.
    WHEN {&bXMatches}       THEN bXMatches:SENSITIVE     = FALSE.
    WHEN {&bContains}       THEN bContains:SENSITIVE     = FALSE.
    /* WHEN {&bxRange}        THEN bxRange:SENSITIVE       = FALSE.
    WHEN {&bXList}            THEN bXList:SENSITIVE        = FALSE.*/ 
    WHEN {&bAnd }           THEN bAnd:SENSITIVE          = FALSE.
    WHEN {&bOr }            THEN bOr:SENSITIVE           = FALSE.

END CASE.
END.

/*
IF qbf-p:LIST-ITEMS IN FRAME qbf%where <> cListItems THEN
qbf-p:LIST-ITEMS IN FRAME qbf%where = cListItems.
*/
&if {&Debug} &then
MESSAGE "#7 out".
&endif
END.
END PROCEDURE. /* load_ops */
/*--------------------------------------------------------------------------*/
/*
PROCEDURE WhereOperator.ip.

DEFINE INPUT PARAMETER cLabel AS CHARACTER NO-UNDO.

DO with frame dialog-1:

&if {&Debug} &then
message "#3 in".
&endif
DEFINE VARIABLE c4glCode AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE cFormat AS CHARACTER NO-UNDO. /* format */
DEFINE VARIABLE i AS INTEGER   NO-UNDO.
DEFINE VARIABLE iDataType AS INTEGER   NO-UNDO.
DEFINE VARIABLE lInclusive AS LOGICAL   NO-UNDO.

DEFINE VARIABLE iAskRunTime AS INTEGER NO-UNDO. /* ask at runtime flag */

/*  DEFINE VARIABLE qbf_e AS INTEGER   NO-UNDO.  GJO ***/
/*  DEFINE VARIABLE qbf_w AS LOGICAL   NO-UNDO.  GJO ****/

FIND LAST ttWhere WHERE INTEGER (rsMain:screen-value) = ttWhere.iState 
  AND lLeft:SCREEN-VALUE = ttWhere.cTable.

i               = ttWhere.iSeq.

CREATE ttWhere.

ASSIGN
c4glCode        = TRIM(eDisplayCode:SCREEN-VALUE)
ttWhere.iState  = INTEGER (rsMain:screen-value)
ttWhere.cTable  = lLeft:SCREEN-VALUE
ttWhere.iSeq    = i + 1
bUndo:SENSITIVE = TRUE
iAskRunTime     = 1
bCheckSyntax:SENSITIVE = TRUE
.

RUN guess_field (OUTPUT cTemp).
cLastField = (IF cTemp = ? THEN cLastField ELSE cTemp).

DO i = 1 TO EXTENT(acWhereState):
/*    IF qbf-p:SCREEN-VALUE IN FRAME qbf%where = ENTRY(3,acWhereState[i]) THEN LEAVE.*/

/*
message
'['   i ']'skip
'['   cLabel ']'skip
'['   ENTRY (2, acWhereState[i]) ']' skip
'['   acWhereState[i] ']'
view-as alert-box error buttons Ok.
*/
IF cLabel = ENTRY (2, acWhereState[i]) THEN LEAVE.
END.

&if {&Debug} &then
if i > extent(acWhereState) then
  message "#3 out early" skip
  cLabel skip
  ENTRY(2,acWhereState[1])
  view-as alert-box error buttons OK.
&endif

IF i > EXTENT(acWhereState) THEN RETURN.

IF (NUM-ENTRIES (cLastField, ".") < 3) THEN
  RUN adecomm/_y-schem.p (cCurrentDb + "." + cLastField,"","",OUTPUT cTemp).
ELSE
  RUN adecomm/_y-schem.p (cLastField,"","",OUTPUT cTemp).

ASSIGN
  iDataType = INTEGER(ENTRY(1,cTemp))
  /*    qbf_e = INTEGER(ENTRY(2,cTemp)) */
  /*    qbf_w = (ENTRY(4,cTemp) = "y":u) */
  cFormat = ENTRY(2,cTemp,CHR(10)).

CASE SUBSTRING(ENTRY(1,acWhereState[i]),1,1,"CHARACTER":u):
  WHEN "o":u THEN /* get one value of any type */
    CASE iDataType:
      WHEN 1 THEN RUN adecomm/_y-strng.p (iAskRunTime,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 2 THEN RUN adecomm/_y-date.p  (iAskRunTime,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 34 THEN RUN adecomm/_y-datetime.p (iAskRunTime,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 40 THEN RUN adecomm/_y-datetime-tz.p (iAskRunTime,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 3 THEN RUN adecomm/_y-logic.p (iAskRunTime,cFormat,?,OUTPUT cValue).
      WHEN 4 OR WHEN 5 THEN
                  RUN "adecomm/_y-num.p" (iAskRunTime,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
  END CASE.
  WHEN "u":u THEN /* get one unformatted string value */
    RUN adecomm/_y-strng.p (iAskRunTime,
      "x(":u + STRING(LENGTH(STRING("",cFormat),"RAW":U)) + ")":u,
      ?,OUTPUT cValue,OUTPUT lInclusive).
  WHEN "q":u THEN /* get qbw string */
    RUN adecomm/_y-qbw.p (iAskRunTime,?,?,OUTPUT cValue).
  WHEN "r":u THEN DO: /* get upper & lower range for anything but logical */
    CASE iDataType:
      WHEN 1 THEN RUN adecomm/_y-strng.p (2,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 2 THEN RUN adecomm/_y-date.p  (2,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 34 THEN RUN adecomm/_y-datetime.p (2,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 40 THEN RUN adecomm/_y-datetime-tz.p (2,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 4 OR WHEN 5 THEN
                  RUN adecomm/_y-num.p   (2,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
    END CASE.
  END.
  WHEN "m":u THEN DO: /* get list of values for anything but logical */
    CASE iDataType:
      WHEN 1 THEN RUN adecomm/_y-strng.p (3,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 2 THEN RUN adecomm/_y-date.p  (3,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
      WHEN 4 OR WHEN 5 THEN
                  RUN adecomm/_y-num.p   (3,cFormat,?,OUTPUT cValue,
                                          OUTPUT lInclusive).
    END CASE.
  END.
END CASE.

IF cValue = ? THEN RETURN.

/* quoter-ize it */
/*...*/
/* other sequences as well? */

&if {&Debug} &then
message 'greg' cLastField iDataType cValue i SUBSTRING(ENTRY(1,acWhereState[i]),1,1).
&endif

cOperator = ENTRY(2,acWhereState[i]).

cTemp = ?.
IF cValue = "<<ask>>":u THEN DO:
  RUN adecomm/_y-strng.p (1,"x(72)":u,"What question...",OUTPUT cTemp).

  IF cTemp = ? THEN RETURN.

  cValue = '/*':u
         + ENTRY(iDataType,"character,date,logical,integer,decimal":u)
         + ',':u
         + cLastField
         + ',':u
         + cOperator
         + ',:':u
         + SUBSTRING(cTemp,2,LENGTH(cTemp,"CHARACTER":u) - 2,"CHARACTER":u)
         + '*/':u.
END.

CASE cOperator:
     WHEN    "=":u OR WHEN "<>":u
  OR WHEN "<":u OR WHEN "<=":u
  OR WHEN ">":u OR WHEN ">=":u
  OR WHEN "BEGINS":u
  OR WHEN "MATCHES":u
  OR WHEN "AND":u
  OR WHEN "OR":u
  OR WHEN "CONTAINS":u THEN 
  c4glCode = c4glCode + " ":u + cOperator + " ":u + cValue.

  WHEN "LIKE":u THEN DO:
  IF cTemp = ? THEN
    ASSIGN
      cValue = REPLACE(cValue,"*":u,"~~*":u)
      cValue = REPLACE(cValue,".":u,"~~.":u)
      cValue = REPLACE(cValue,"%":u,"*":u)
      cValue = REPLACE(cValue,"_":u,".":u).
      c4glCode = c4glCode + " MATCHES ":u + cValue.
  END.
  WHEN "X-MATCHES":u THEN DO:  /** CONTAINS (QBF) ***/
    IF cTemp = ? THEN
      ASSIGN
        cValue   = '"*':u
                 + SUBSTRING(cValue,2,LENGTH(cValue,"CHARACTER":u) - 2,
                             "CHARACTER":u)
                 + '*"':u
        c4glCode = c4glCode + ' MATCHES ':u + cValue.
  END.
  WHEN "RANGE":u THEN
    IF (lInclusive) THEN
      RUN insert_range (iDataType,"=":u,INPUT-OUTPUT c4glCode).
    ELSE
      RUN insert_range (iDataType,"":u,INPUT-OUTPUT c4glCode).
  WHEN "LIST":u THEN
    IF (lInclusive) THEN
      RUN insert_list (iDataType,"=":u,INPUT-OUTPUT c4glCode).
    ELSE
      RUN insert_list (iDataType,"<>":u,INPUT-OUTPUT c4glCode).
 END CASE.

ASSIGN
  eDisplayCode:SCREEN-VALUE  = c4glCode
  eDisplayCode:CURSOR-OFFSET = LENGTH(c4glCode,"RAW":U) + 1
  eDisplayCode:sensitive     = (IF eDisplayCode:screen-value > "" THEN 
                                TRUE ELSE FALSE)
  ttWhere.cExpression        = c4glCode
  ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET
  ttWhere.lOperator          = TRUE
  {&CurLeft}:sensitive       = TRUE
  {&CurRight}:sensitive      = TRUE
  acWhere [LOOKUP ({&CurTable}, slComboBox:List-Items, {&Sep1})] = ttWhere.cExpression
.

RUN adecomm/_qset.p ("SetOperatorsSensitive.ip", FALSE).
RUN adecomm/_qset.p ("SetJoinOperatorsSensitive.ip", FALSE).

/*
IF eDisplayCode:sensitive THEN
APPLY "ENTRY" TO eDisplayCode.
*/

&if {&Debug} &then
message "#3 out".
&endif
END.
END.
/* ---------------------------------------------------------------------*/

/*
Appends "(x >_ v1 AND x <_ v2)", where "_" is "=" for inclusive range
or "" for exclusive range.  If can't match field name as last token in
qbf_4, omits parens and produces "x >_ v1 AND x <_ v2" instead.
*/

PROCEDURE insert_range:
DEFINE INPUT        PARAMETER i           AS INTEGER   NO-UNDO. /* NOT USED */
DEFINE INPUT        PARAMETER cExpression AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER c4glCode    AS CHARACTER NO-UNDO.
DEFINE VARIABLE               cTemp       AS CHARACTER NO-UNDO. /* scrap */

/*hack!*/
/*if index(cValue,",") > 0 then substring(cValue,index(cValue,","),1) = chr(10).*/

/*
IF i = 1 THEN
  cTemp = '"':u + REPLACE(ENTRY(1,cValue,CHR(10)),'"':u,'""':u) + '"':u
        + CHR(10)
        + '"':u + REPLACE(ENTRY(2,cValue,CHR(10)),'"':u,'""':u) + '"':u.
ELSE
*/
  cTemp = cValue.

/* tex 02/22/94 tex check to use LENGTH default mode */
IF SUBSTRING(c4glCode,LENGTH(c4glCode,"CHARACTER":u)
  - LENGTH(cLastField,"CHARACTER":u) + 1,"CHARACTER":u) = cLastField THEN
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
           + cLastField + " >":u + cExpression + " ":u
           + ENTRY(1,cTemp,CHR(10))
           + " AND ":u
           + cLastField + " <":u + cExpression + " ":u
           + ENTRY(2,cTemp,CHR(10)).
END PROCEDURE. /* insert_range */

/* ---------------------------------------------------------------------*/
/*
Appends "(x _ v1 ___ x _ v2)", where "_" is "=" for in-list and "<>"
for not-in-list and "___" is "OR" for in-list and "AND" for
not-in-list.  If can't match field name as last token in qbf_4, omits
parens and produces "x _ v1 ___ x _ v2" instead.
*/

PROCEDURE insert_list:
DEFINE INPUT        PARAMETER i AS INTEGER   NO-UNDO. /*** THIS IS NOT USED GJO ****/
DEFINE INPUT        PARAMETER cOperator AS CHARACTER NO-UNDO. /* = or <> */
DEFINE INPUT-OUTPUT PARAMETER c4glClode AS CHARACTER NO-UNDO.

DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO. /* scrap */

cTemp = cValue.

/* from [a,b,c] */
/*       !^!^!  */
/*   to [ = a or n = b or n = c] */
/*       ---!^^^^^^^^!^^^^^^^^!  */

cTemp = ' ':u + cOperator + ' ':u
      + REPLACE( cTemp, CHR(10), CHR(10) 
      + (IF cOperator = "=":u THEN "  OR ":u ELSE "  AND ":u)
      + cLastField + " ":u + cOperator + " ":u).

IF SUBSTRING(c4glClode,LENGTH(c4glClode,"CHARACTER":u)
  - LENGTH(cLastField,"CHARACTER":u) + 1,"CHARACTER":u) = cLastField THEN
  c4glClode = SUBSTRING(c4glClode,1,LENGTH(c4glClode,"CHARACTER":u)
              - LENGTH(cLastField,"CHARACTER":u),"CHARACTER":u)
            + "(":u + cLastField + cTemp + ")":u.
ELSE
  c4glClode = c4glClode + " ":u + cTemp.
END PROCEDURE. /* insert_list */
*/
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

/*  DO WITH FRAME dialog-1: */
MESSAGE "cCurrentDb" cCurrentDb SKIP
  "cDbLeft " cDBleft SKIP
  "cDBRigh " cDbRight SKIP
  VIEW-AS ALERT-BOX ERROR BUTTONS OK.

IF (NUM-ENTRIES (cRight, ".") = 1) THEN
ASSIGN
  cDbRight  = cCurrentDb + "." + cRight
  cDbLeft   = cCurrentDb + "." + cLeft.
ELSE
ASSIGN
  cDbRight  = cRight
  cDbLeft   = cLeft.

/* message cDbLeft cDbRight. */
RUN adecomm/_j-test.p (cDbLeft, cDbRight, OUTPUT lOK).
IF NOT lOK THEN
  RUN adecomm/_j-test.p (cDbRight, cDbLeft, OUTPUT lOK).

lJoinable = lOk.

/*END. */
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

  IF (lLeft:screen-value > "") THEN DO:

    RUN adecomm/_qisjoin.p (lLeft:screen-value, lRight:screen-value,
                            OUTPUT lOK).
    ASSIGN
      tJoinable:visible   	= lOK.

    IF (ENTRY (2, {&CurTable}, " ") = "OF") THEN /** Change to WHERE **/
      tJoinable:screen-value = STRING (FALSE).
    ELSE
      tJoinable:screen-value = STRING (TRUE).
  END.
  ELSE
  ASSIGN
    tJoinable:visible       = FALSE.
  /*
  tJoinable:sensitive     = FALSE
  tJoinable:screen-value  = STRING (FALSE).
  */

END.
END PROCEDURE.

/* _qinit.p - end of file */


