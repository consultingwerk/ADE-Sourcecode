/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

  File: qurytrig.i

  Description: 
   This is all of the trigger code for the Query Builder

  Input Parameters: N/A

  Output Parameters: N/A

  Author: Greg O'Connor

  Created: 03/23/93 - 12:17 pm

-----------------------------------------------------------------------------*/
&SCOPED-DEFINE SKP &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" &THEN SKIP &ELSE &ENDIF

ON CHOOSE OF bHelp OR HELP OF FRAME dialog-1 DO:
  DO WITH FRAME dialog-1:
    CASE rsMain:SCREEN-VALUE:
      WHEN "{&join}"  THEN       
        /* ON HELP in the Join Builder dialog box */
        IF application = "{&UIB_SHORT_NAME}" THEN
          RUN adecomm/_adehelp.p("AB","CONTEXT",{&Join_Builder_Dlg_Box}, ?).
        ELSE
          RUN adecomm/_adehelp.p("res","CONTEXT",
                                 {&Join_Construction_Dlg_Box},?).
      WHEN "{&Where}" THEN       
        /* ON HELP in the Where Builder dialog box */
        IF application = "{&UIB_SHORT_NAME}" THEN
          RUN adecomm/_adehelp.p("AB","CONTEXT",{&Where_Builder_Dlg_Box}, ?).
        ELSE
          RUN adecomm/_adehelp.p("res","CONTEXT",{&Data_Selection_Dlg_Box}, ?).
      WHEN "{&Sort}"  THEN       
        /* ON HELP in the Sort Selection dialog box */
        RUN adecomm/_adehelp.p ("AB","CONTEXT",{&Sort_Selection_Dlg_Box}, ?).
      WHEN "{&Options}" THEN       
        /* ON HELP in the Options Selection dialog box */
        RUN adecomm/_adehelp.p ("AB","CONTEXT", {&QB_Options_Dlg_Box}, ?).
      WHEN "{&Table}" THEN       
        /* ON HELP in the Table Builder dialog box */
        RUN adecomm/_adehelp.p ("AB","CONTEXT",{&Table_Builder_Dlg_Box}, ?).
    END CASE.
  END.
END.
/*----------------------------------------------------------------------------*/
ON MOUSE-SELECT-DBLCLICK OF _qo._flds-returned IN BROWSE _qrytune DO:
  DO WITH FRAME dialog-1: 
    IF SELF:SCREEN-VALUE = "All Fields":U THEN 
      SELF:SCREEN-VALUE = "Fields Used":U.
    ELSE SELF:SCREEN-VALUE = "All Fields":U.
  END.  
END.
/*----------------------------------------------------------------------------*/
ON ANY-PRINTABLE OF _qo._flds-returned IN BROWSE _qrytune DO:
  DO WITH FRAME dialog-1:
    CASE CHR(LASTKEY):
      WHEN "A":U THEN SELF:SCREEN-VALUE = "All Fields":U.
      WHEN "F":U THEN SELF:SCREEN-VALUE = "Fields Used":U.
      OTHERWISE BELL.
    END CASE.
    RETURN NO-APPLY.
  END.  
END.
/*----------------------------------------------------------------------------*/
ON MOUSE-SELECT-DBLCLICK OF _qo._join-type IN BROWSE _qrytune DO:
  DO WITH FRAME dialog-1: 
    IF _qo._seq-no = 1 AND iXternalCnt = 0 THEN RETURN NO-APPLY.
    IF SELF:SCREEN-VALUE = "OUTER":U THEN 
      SELF:SCREEN-VALUE = "INNER":U.
    ELSE SELF:SCREEN-VALUE = "OUTER":U.
  END.  
END.
/*----------------------------------------------------------------------------*/
ON ANY-PRINTABLE OF _qo._join-type IN BROWSE _qrytune DO:
  DO WITH FRAME dialog-1:
    IF _qo._seq-no = 1 AND iXternalCnt = 0 THEN RETURN NO-APPLY.
    CASE CHR(LASTKEY):
      WHEN "I":U THEN SELF:SCREEN-VALUE = "INNER":U.
      WHEN "O":U THEN SELF:SCREEN-VALUE = "OUTER":U.
      OTHERWISE BELL.
    END CASE.
    RETURN NO-APPLY.
  END.  
END.
/*----------------------------------------------------------------------------*/
ON MOUSE-SELECT-DBLCLICK OF _qo._find-type IN BROWSE _qrytune DO:
  DO WITH FRAME dialog-1:
    IF _qo._seq-no = 1 /* AND iXternalCnt = 0 REMOVED for 95-06-28-002 DRH */
    THEN DO:
       &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          ShowMessageInIDE("The first table in a query must be 'FOR EACH'.",
                           "Information",?,"OK",yes).
      
       &else   
       MESSAGE 'The first table in a query must be "FOR EACH".'
               VIEW-AS ALERT-BOX INFORMATION.
       &endif        
       RETURN NO-APPLY.
    END.
    CASE SELF:SCREEN-VALUE:
      WHEN "EACH":U  THEN SELF:SCREEN-VALUE = "FIRST":U.
      WHEN "FIRST":U THEN SELF:SCREEN-VALUE = "LAST":U.
      WHEN "LAST":U  THEN SELF:SCREEN-VALUE = "EACH":U.
      OTHERWISE SELF:SCREEN-VALUE = "EACH":U.
    END CASE.
  END.  
END.
/*----------------------------------------------------------------------------*/
ON ANY-PRINTABLE OF _qo._find-type IN BROWSE _qrytune DO:
  DO WITH FRAME dialog-1:
    IF _qo._seq-no = 1 AND iXternalCnt = 0 THEN DO:
       &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          ShowMessageInIDE("The first table in a query must be 'FOR EACH'.",
                           "Information",?,"OK",yes).
      
       &else  
       MESSAGE 'The first table in a query must be "FOR EACH".'
               VIEW-AS ALERT-BOX INFORMATION.
       &endif        
       RETURN NO-APPLY.
    END.
    CASE CHR(LASTKEY):
      WHEN "E":U THEN SELF:SCREEN-VALUE = "EACH":U.
      WHEN "F":U THEN SELF:SCREEN-VALUE = "FIRST":U.
      WHEN "L":U THEN SELF:SCREEN-VALUE = "LAST":U.
      OTHERWISE BELL.
    END CASE.
    RETURN NO-APPLY.
  END.  
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF eCurrentTable DO:

  DO WITH FRAME dialog-1:   
    eCurrentTable = eCurrentTable:SCREEN-VALUE.
  
    IF {&Where-Mode} OR {&Join-Mode} THEN DO:
      RUN adeshar/_qset.p ("setComboBoxQuery",application,FALSE).
      IF eDisplayCode:SCREEN-VALUE = ? OR eDisplayCode:SCREEN-VALUE = "" THEN
      ASSIGN bEqual:SENSITIVE        = FALSE
             bNotEqual:SENSITIVE     = FALSE
             bLess:SENSITIVE         = FALSE
             bGreater:SENSITIVE      = FALSE
             bLessEqual:SENSITIVE    = FALSE
             bGreaterEqual:SENSITIVE = FALSE
             bBegins:SENSITIVE       = FALSE
             bMatches:SENSITIVE      = FALSE
             bContains:SENSITIVE     = FALSE
             bRange:SENSITIVE        = FALSE
             bList:SENSITIVE         = FALSE
             bOr:SENSITIVE           = FALSE
             bAnd:SENSITIVE          = FALSE
             bCheckSyntax:SENSITIVE  = FALSE.
             
      IF {&Join-Mode} THEN RUN setCustJoin.ip.
    
      ELSE DO:  /* Must be &Where-Mode */
        /** To set up Undo State **/
        FIND LAST ttWhere WHERE {&Where} = ttWhere.iState 
          AND lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.
        IF AVAILABLE (ttWhere) THEN DO:
          ASSIGN
            cLastField             = ttWhere.cLastField
            {&CurLeft}:SENSITIVE   = ttWhere.lOperator
            {&CurRight}:SENSITIVE  = ttWhere.lOperator
            lWhState               = ttWhere.lWhState.
              
          RUN load_ops.
        END. /* A ttWhere record is available */
      END.  /* Else handle the &Where-Mode case */
    END.  /* If  &Where or &Join mode */
    ELSE  /* Other modes */
      RUN adeshar/_qset.p ("setComboBox",application,FALSE). 
  END.
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF cShareType IN FRAME dialog-1 DO:
  ASSIGN cShareType = CAPS (cShareType:SCREEN-VALUE).  
  IF cShareType:SCREEN-VALUE = "Exclusive-Lock":U AND
     application = "{&UIB_SHORT_NAME}":U AND CAN-DO(pcValidStates,"FIELDS":U)
  THEN
  do: 
  &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          ShowMessageInIDE("Opening a query with EXCLUSIVE-LOCK will cause a run-time ~n
                            error unless the OPEN statement is within a DO/REPEAT ~n
                            TRANSACTION block.",
                           "Warning",?,"OK",yes).
      
  &else    
  MESSAGE "Opening a query with EXCLUSIVE-LOCK will cause a run-time"
               "error unless the OPEN statement is within a DO/REPEAT"
               "TRANSACTION block." VIEW-AS ALERT-BOX WARNING.
  &endif             
  end.             
  RUN BuildOptionList.ip.
  RUN BuildQuery.ip (OUTPUT eDisplayCode).
  ASSIGN
     eDisplayCode:SCREEN-VALUE = eDisplayCode  
     bCheckSyntax:SENSITIVE    = (IF eDisplayCode <> "" THEN TRUE ELSE FALSE).

END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF tIndexReposition IN FRAME dialog-1 DO:
  tIndexReposition = self:checked.
  RUN BuildOptionList.ip.
  RUN BuildQuery.ip (output eDisplayCode). 
  
  ASSIGN
     eDisplayCode:SCREEN-VALUE = eDisplayCode 
     bCheckSyntax:SENSITIVE    = (if eDisplayCode <> "" then TRUE 
                                 else FALSE).                      
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF tKeyPhrase IN FRAME dialog-1 DO:
  tKeyPhrase = self:checked.
  RUN BuildOptionList.ip.
  RUN BuildQuery.ip (output eDisplayCode). 
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF tSortByPhrase IN FRAME dialog-1 DO:   
  tSortByPhrase = self:checked.
  RUN BuildOptionList.ip.      
  RUN BuildQuery.ip (output eDisplayCode).   
  /* Disable/Enable the Sort option. */
  IF tSortByPhrase 
  THEN lConstant = rsMain:DISABLE ('Sort':U) NO-ERROR.
  ELSE lConstant = rsMain:ENABLE  ('Sort':U) NO-ERROR.
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bFieldFormat DO:
  DO WITH FRAME dialog-1:

  DEFINE VARIABLE cOldformat   AS CHARACTER.
  DEFINE VARIABLE cNewFormat   AS CHARACTER.
  DEFINE VARIABLE counter      AS INTEGER.
  DEFINE VARIABLE NewType      AS INTEGER.
  
  cOldformat = eFieldFormat:SCREEN-VALUE.

  /*
  ** only run if the field is NOT a calculated expression
  */
  IF INDEX({&CurRight}:SCREEN-VALUE,"(":U) = 0 THEN DO:
     RUN DB_Field.ip ({&CurRight}:SCREEN-VALUE, "FORMAT", OUTPUT cTemp).

     DO counter = 2 TO NUM-ENTRIES (cTemp):
       cNewFormat = IF (counter = 2) THEN ENTRY (counter, cTemp)
                    ELSE cNewFormat + "," + ENTRY (counter, cTemp).
     END.
     RUN adecomm/_y-build.p (INTEGER(ENTRY(1,cTemp)),INPUT-OUTPUT cOldFormat).
  END.
  ELSE DO:
    /*
    ** This is a kludge for calculated fields where we need to compute some
    ** kind of temp type
    */
    NewType = IF INDEX(eFieldFormat:SCREEN-VALUE,"(":U) > 0  OR
                 INDEX(eFieldFormat:SCREEN-VALUE,"!":U) > 0  OR
                 eFieldFormat:SCREEN-VALUE = "999-99-9999" OR
                 eFieldFormat:SCREEN-VALUE = "999-9999" THEN 1
              ELSE 
              IF SUBSTRING(eFieldFormat:SCREEN-VALUE,1,8,"CHARACTER":u) = 
                "99/99/99":u OR
                SUBSTRING(eFieldFormat:SCREEN-VALUE,1,8,"CHARACTER":u) = 
                "99.99.99":u OR
                SUBSTRING(eFieldFormat:SCREEN-VALUE,1,8,"CHARACTER":u) = 
                "99-99-99":u THEN 2
              ELSE
              IF INDEX(eFieldFormat:SCREEN-VALUE,"YES":U) > 0  OR
                  INDEX(eFieldFormat:SCREEN-VALUE,"NO":U)  > 0  OR
                  INDEX(eFieldFormat:SCREEN-VALUE,"TRUE":U)  > 0  OR
                  INDEX(eFieldFormat:SCREEN-VALUE,"FALSE":U)  > 0 THEN 3
              ELSE 5. 
          
    IF NewType = 5 THEN 
    do:
      &if DEFINED(IDE-IS-RUNNING) <> 0 &then
          ShowMessageInIDE("Using numeric format as default.",
                           "Warning","Format type missing","OK",yes).
      
      &else   
      MESSAGE "Using numeric format as default." 
        VIEW-AS ALERT-BOX WARNING TITLE "Format type missing".
      &endif    
    end.                     
    IF NewType >= 1 THEN
       RUN adecomm/_y-build.p (NewType, INPUT-OUTPUT cOldFormat).
  END.

  eFieldFormat:SCREEN-VALUE = cOldFormat.
  ASSIGN
      cFieldName = {&CurRight}:SCREEN-VALUE
      cList      = {&CurRight}:LIST-ITEMS
      cTemp = ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1})
      ENTRY (3, cTemp, {&sep2}) = IF cOldFormat NE cNewFormat
                                    THEN eFieldFormat:SCREEN-VALUE ELSE "":U 
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp
      .
  END.
END.
/*----------------------------------------------------------------------------*/
ON GO OF FRAME DIALOG-1 DO:
  DO WITH FRAME dialog-1:  
  /*
  ** Before exiting, make sure that the user has at least passed into the
  ** the 'fields' state.  This code used to be part of _query.p as a stacked
  ** wait-for, but this caused a lot of problems - R. Ryan 8/94
  */
  DEFINE VARIABLE chc AS LOGICAL NO-UNDO.
  IF plVisitFields and ({&TableRight}:NUM-ITEMS - iXternalCnt > 0) then do: 
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then
        chc =  ShowMessageInIDE("You have selected table(s) but no fields. ~n
                                Do you want to select some fields now?" ,
                                "Warning",?,"YES-NO",chc).
      
    &else   
    MESSAGE "You have selected table(s) but no fields." SKIP
      "Do you want to select some fields now?" 
      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE chc.
    &endif  
    IF chc THEN DO: 
      APPLY "CHOOSE" TO b_fields.
      RETURN NO-APPLY. 
    END.
  END. 
   
  /* Loadup _TblOptList with current _qo stuff */
  IF CAN-FIND(FIRST _qo) THEN DO:  /* We at least have built the records */
    _TblOptList = "".
    FOR EACH _qo:
      _TblOptList = _TblOptList 
                  + (IF _qo._seq-no = 1 THEN "" ELSE ",") 
                  + (IF _qo._find-type NE "EACH":U THEN 
                       " " + _qo._find-type ELSE "") 
                  + (IF _qo._join-type EQ "OUTER":U  THEN " OUTER" ELSE "")
                  + (IF _qo._flds-returned EQ "Fields Used":U THEN 
                       " USED" ELSE "").
    END.
  END.  /* If we have any _qo records */

  ASSIGN _TuneOptions = _TuneOptions:SCREEN-VALUE.
    
  /* 
  ** If auto syntax check is set
  */
  IF (tOnOk:SCREEN-VALUE = "yes") THEN DO:
    RUN CheckSyntax.ip (OUTPUT lOK). 
    IF NOT lOK THEN
      RUN CheckDisplayWidth.ip (OUTPUT lOK).

    IF lOK THEN RETURN NO-APPLY.
  END.

  RUN BuildQuery.ip (OUTPUT _4GLQury). 
  ASSIGN
    _TblList     = {&TableRight}:LIST-ITEMS 
    _OrdList     = {&CurSortData}
    _FldList     = {&CurFieldData}.
    
  /*
  ** Don't accept a value of ? for _TblList.  Make it "" 
  */
  IF _TblList eq ? THEN _TblList = "":U.
  DO i = 1 TO EXTENT (_Where):
    ASSIGN _Where[i]    = (IF (acWhere [i] > "") THEN  acWhere [i] ELSE ?)
           _JoinCode[i] = (IF (acJoin  [i] > "") THEN  acJoin  [i] ELSE ?).
  END.  
END.  
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bCheckSyntax DO:
  RUN CheckSyntax.ip (OUTPUT lOK).
  IF NOT lOK THEN
  do:
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then
         ShowMessageInIDE("Syntax is correct.":t48 ,
                          "Information",?,"OK",yes).
      
    &else   
    MESSAGE "Syntax is correct.":t48 
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    &endif  
  end.    
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bTableSwitch
  RUN ChangeJoinTarget.ip.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF b_Fields DO:
  RUN ChooseFields.
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF b_FreeFormQ DO:
  &if DEFINED(IDE-IS-RUNNING) = 0 &THEN
  RUN choose_b_FreeFormQ.
  &else
    dialogService:SetCurrentEvent(this-procedure,"choose_b_FreeFormQ").
    run runChildDialog in hOEIDEService (dialogService) .
  &ENDIF 
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bUp IN FRAME dialog-1 DO:
  DO WITH FRAME dialog-1:
  ASSIGN
    cList = {&CurRight}:LIST-ITEMS
    cTemp = {&CurRight}:SCREEN-VALUE.
  /*
  ** IF it is sort or Field have to move one at a time to keep the cMoreData
  ** in parellel with the :list-items
  */
  IF {&Sort-Mode} OR {&Options-Mode} THEN DO:
     DO i = 1 to NUM-ENTRIES (cTemp, {&Sep1}):
        RUN MoveList.ip (TRUE, ENTRY (LOOKUP (ENTRY (i, cTemp, {&Sep1}), 
                         cList, {&Sep1}), {&CurData}, {&Sep1}),{&Sep1},
                         INPUT-OUTPUT {&CurData}).

        RUN MoveList.ip (TRUE, ENTRY (i, cTemp, {&Sep1}),{&Sep1},
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
    {&CurRight}:SCREEN-VALUE = cTemp.
  
  RUN adeshar/_qset.p ("setUpDown",application,TRUE). 
  RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
  eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
END. 
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bDown IN FRAME dialog-1 DO:
  DO WITH FRAME dialog-1:
  ASSIGN
    cList = {&CurRight}:LIST-ITEMS
    cTemp = {&CurRight}:SCREEN-VALUE.
  /*
  ** IF it is sort or Field have to move one at a time to keep the cMoreData
  ** in parellel with the :list-items
  */
  IF {&Sort-Mode} OR {&Options-Mode} THEN DO:
     DO i = NUM-ENTRIES (cTemp, {&Sep1}) TO 1 BY -1:
       RUN MoveList.ip (FALSE, ENTRY (LOOKUP (ENTRY (i, cTemp, {&Sep1}), 
                        cList, {&Sep1}), {&CurData}, {&Sep1}),{&Sep1},
                        INPUT-OUTPUT {&CurData}).
       RUN MoveList.ip (FALSE, ENTRY (i, cTemp, {&Sep1}), {&Sep1},
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
    {&CurRight}:SCREEN-VALUE = cTemp.

  RUN adeshar/_qset.p ("setUpDown",application,TRUE).
  RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
  eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bRemove IN FRAME dialog-1
  RUN DefaultActionRight.ip.         
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bAdd IN FRAME dialog-1
  RUN DefaultActionLeft.ip.
/*----------------------------------------------------------------------------*/
ON LEAVE OF eFieldLabel DO:
  DEFINE VARIABLE cAnswer AS CHARACTER NO-UNDO.

  DO WITH FRAME dialog-1:
  RUN DB_Field.ip (sIndex, "LABEL", OUTPUT cTemp). 

  IF (SELF:SCREEN-VALUE <> cTemp) THEN
    ASSIGN
      cFieldName = sIndex
      cList      = {&CurRight}:LIST-ITEMS
      cTemp = ENTRY(LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1})
      ENTRY (2, cTemp, {&sep2}) = 
        REPLACE( REPLACE (SELF:SCREEN-VALUE, CHR(13), ""), CHR(10), "!")
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp.
  END.
END.
/*----------------------------------------------------------------------------*/
ON LEAVE OF eFieldFormat DO:
  DEFINE VARIABLE counter  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lError   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFormat  AS CHARACTER NO-UNDO.

DO WITH FRAME dialog-1:
  RUN DB_LongField.ip (sIndex, "FORMAT", OUTPUT cCurrentDB, OUTPUT cTableName,
                       OUTPUT cFieldName, OUTPUT cTemp).
  
  DO counter = 2 TO NUM-ENTRIES(cTemp):
    cFormat = IF counter = 2 THEN ENTRY(counter,cTemp)
              ELSE cFormat + "," + ENTRY(counter,cTemp).
  END.

  /*
  ** only run if the field is NOT a calculated expression
  */
  IF INDEX(sIndex,"(":U) = 0 THEN DO:
     RUN adecomm/_chkfmt.p (INTEGER (ENTRY (1,cTemp)), cFieldName, "", 
                            SELF:SCREEN-VALUE, OUTPUT counter, OUTPUT lError).
     IF (lError) THEN
       RETURN NO-APPLY.
  END. 

  /** Format returns TYPE,FORMAT  **/
  ASSIGN
      cFieldName = sIndex
      cList      = {&CurRight}:LIST-ITEMS

      /** Find the item based on screen vlaue **/
      cTemp = ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1})

      /** Change the FORMAT part **/
      ENTRY (3, cTemp, {&sep2}) = IF SELF:SCREEN-VALUE <> cFORMAT THEN 
                                    SELF:SCREEN-VALUE ELSE "":U                
      /** Put it back  **/
      ENTRY (LOOKUP (cFieldName, cList, {&Sep1}), {&CurData}, {&Sep1}) = cTemp.
  END.
END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bEqual, bNotEqual, bLess, bGreater, bLessEqual, bGreaterEqual,
  bAnd, bOR, bBegins, bMatches, bRange, bList, bContains DO:
  define variable NewLabel  as character no-undo.    
  NewLabel    = REPLACE(SELF:LABEL,"&":U,"":U). /* strip "&" mnemonic */ 
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
    if self <> band:handle and self <> bOr:handle then
    do:
        dialogService:SetCurrentEvent(this-procedure,"choose_whereButton",NewLabel).
        run runChildDialog in hOEIDEService (dialogService) .
    end. 
    else 
       run choose_whereButton(NewLabel).

&else
    run choose_whereButton(NewLabel).
&endif
     

END.
/*----------------------------------------------------------------------------*/
ON CHOOSE OF bUndo DO:
  DO WITH FRAME dialog-1:
  DEFINE VARIABLE cTemp AS CHARACTER NO-UNDO. /* scrap */

  /* just in case any junk gets in there */
  FOR EACH ttWhere WHERE INTEGER(rsMain:SCREEN-VALUE) = ttWhere.iState 
    AND lLeft:SCREEN-VALUE = ttWhere.cTable 
    AND ttWhere.iSeq > 0 
    AND ttWhere.cExpression = "":
    DELETE ttWhere.
  END.

  FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState AND
     lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.

  DO WHILE AVAILABLE ttWhere AND
    ttWhere.cExpression EQ eDisplayCode:SCREEN-VALUE:
    DELETE ttWhere.
    FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState AND
       lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.
  END.

  IF AVAILABLE ttWhere THEN
    ASSIGN
      eDisplayCode:SCREEN-VALUE  = ttWhere.cExpression
      eDisplayCode:CURSOR-OFFSET = (IF (ttWhere.iOffset > 0) THEN 
                                      ttWhere.iOffset 
                                    ELSE
                                      eDisplayCode:CURSOR-OFFSET)
      bUndo:SENSITIVE            = (ttWhere.iSeq > 0)
      lWhState                   = ttWhere.lWhState
      {&CurLeft}:SCREEN-VALUE    = ""
      {&CurRight}:SCREEN-VALUE   = ""
      {&CurLeft}:SENSITIVE       = ttWhere.lOperator
      {&CurRight}:SENSITIVE      = ttWhere.lOperator
      cLastField                 = ttWhere.cLastField.
  ELSE eDisplayCode:SCREEN-VALUE = "".

  IF {&Join-Mode} THEN DO:
    RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,
                         NOT ttWhere.lOperator).
    RUN adeshar/_qset.p ("SetJoinOperatorsSensitive.ip",application, 
                         NOT ttWhere.lOperator).
    acJoin [LOOKUP (TRIM({&CurTable}), eCurrentTable:LIST-ITEMS, {&Sep1}) +
            (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)] = ttWhere.cExpression.
  END.
  ELSE IF {&Where-Mode} THEN DO:
    acWhere[LOOKUP({&CurTable},eCurrentTable:LIST-ITEMS, 
                   {&Sep1}) + iXternalCnt] = IF AVAILABLE ttWhere THEN
                                               ttWhere.cExpression
                                             ELSE "".

    RUN load_ops.
  END.
  END.
END.
/*----------------------------------------------------------------------------*/
ON ENTRY OF eDisplayCode DO:
  DO WITH FRAME dialog-1:

    IF {&Join-Mode} OR {&Where-Mode} THEN DO:
      RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,TRUE).
      RUN adeshar/_qset.p ("SetJoinOperatorsSensitive.ip",application,TRUE).

      ASSIGN
        {&CurLeft}:SENSITIVE       = TRUE
        tJoinable                  = TRUE
        tJoinable:checked          = tJoinable
        {&CurRight}:SENSITIVE      = TRUE.

      FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState 
        AND lLeft:SCREEN-VALUE = ttWhere.cTable.

      /* If from the users point of view we have saved this then just leave */
      IF (ttWhere.cExpression = TRIM(eDisplayCode:SCREEN-VALUE)) THEN RETURN.   
      i = ttWhere.iSeq.
      CREATE ttWhere.
      ASSIGN
        cLastField                 = TRIM(eDisplayCode:SCREEN-VALUE)
        ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
        ttWhere.cTable             = lLeft:SCREEN-VALUE
        ttWhere.iSeq               = i + 1
        ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
        ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
        ttWhere.lOperator          = TRUE /* ggg This needs work !! */ 
        ttWhere.lWhState           = lWhState
        bCheckSyntax:SENSITIVE     = TRUE
        bUndo:SENSITIVE            = TRUE.
    END.
  END.
END.
/*----------------------------------------------------------------------------*/
ON LEAVE OF eDisplayCode DO:
  DO WITH FRAME dialog-1:
  IF {&Join-Mode} OR {&Where-Mode} THEN DO:
    /*
    ** As you leave, if blank then turn the custom join toggle off that
    ** was turned on when you entered here. R Ryan 7/94
    */
    IF (eDisplayCode:SCREEN-VALUE = ? OR
      eDisplayCode:SCREEN-VALUE = "") AND 
      {&Join-Mode} THEN DO:

      ASSIGN   
        /* zap acJoin -dma */
        acJoin[LOOKUP(TRIM({&CurTable}),eCurrentTable:LIST-ITEMS, {&Sep1}) +
          (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)] = ""

        tJoinable              = FALSE
        tJoinable:SCREEN-VALUE = STRING(tJoinable) 
        {&CurLeft}:SENSITIVE   = FALSE
        {&CurRight}:SENSITIVE  = FALSE.
       APPLY "VALUE-CHANGED" TO tJoinable.
       RETURN.
    END.

    FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState 
      AND lLeft:SCREEN-VALUE = ttWhere.cTable.

    /* If from the users point of view we have saved this then just leave */
    IF (ttWhere.cExpression = eDisplayCode:SCREEN-VALUE ) THEN RETURN.   
    i = ttWhere.iSeq.

    CREATE ttWhere.
    ASSIGN
      cLastField                 = TRIM(eDisplayCode:SCREEN-VALUE)
      ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
      ttWhere.cTable             = lLeft:SCREEN-VALUE
      ttWhere.iSeq               = i + 1
      ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
      ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
      ttWhere.lOperator          = TRUE /* ggg This needs work !! */ 
      ttWhere.lWhState           = lWhState
      bCheckSyntax:SENSITIVE     = TRUE
      bUndo:SENSITIVE            = TRUE
      {&CurLeft}:SCREEN-VALUE    = ""
      {&CurLeft}:SENSITIVE       = ttWhere.lOperator
      {&CurRight}:SENSITIVE      = ttWhere.lOperator.
 
    IF {&Join-Mode} THEN DO:
      acJoin[LOOKUP(TRIM({&CurTable}),eCurrentTable:LIST-ITEMS, {&Sep1}) +
        (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)] = ttWhere.cExpression.
    END.
    ELSE IF {&Where-Mode} THEN
      acWhere[LOOKUP({&CurTable},eCurrentTable:LIST-ITEMS,
        {&Sep1}) + iXternalcnt] = ttWhere.cExpression.            
  END.
END.
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF rsSortDirection DO:
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  
  DO WITH FRAME dialog-1:
    ASSIGN
      cFieldName = {&CurRight}:SCREEN-VALUE
      cList      = {&CurRight}:LIST-ITEMS.
    DO i = 1 TO NUM-ENTRIES(cFieldName,{&Sep1}):
      ASSIGN
      /** Find the item based on screen vlaue **/
      cTemp = ENTRY (LOOKUP (ENTRY(i,cFieldName,{&Sep1}), cList, {&Sep1}),
                             {&CurData}, {&Sep1})
      /** Change the sort part **/
      ENTRY (2, cTemp, {&sep2}) = rsSortDirection:SCREEN-VALUE
      /** Put it back  **/
      ENTRY (LOOKUP (ENTRY(i,cFieldName,{&Sep1}), cList, {&Sep1}),
                             {&CurData}, {&Sep1}) = cTemp
      .
    END. /* DO i = 1 to NUM-selected */
    
    RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode).
    eDisplayCode:SCREEN-VALUE = eDisplayCode.
  END.
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF tJoinable DO:
  DO WITH FRAME dialog-1:
  /*
  message 
    "on value-changed of tjoinable" skip
    "tjoinable:sv" tjoinable:screen-value skip
    "edisplaycode:sv" edisplaycode:screen-value skip
    view-as alert-box title "qurytrig.i".
  */

  IF TRIM (tJoinable:SCREEN-VALUE) = "YES" THEN 
    ASSIGN
      cTemp                         = {&CurTable}
      {&CurTable}                   = REPLACE ({&CurTable}, " OF ", " WHERE ")
      {&CurTable}                   = {&CurTable} + " ..."
      eResCurrentTable:SCREEN-VALUE = {&CurTable}
      eDisplayCode:SCREEN-VALUE     = ""
      {&CurLeft}:SENSITIVE          = TRUE
      {&CurRight}:SENSITIVE         = TRUE
      eDisplayCode:READ-ONLY        = FALSE
      eDisplayCode:SENSITIVE        = TRUE
      eDisplayCode:BGCOLOR          = ?
      .
  ELSE DO:
    IF (eDisplayCode:SCREEN-VALUE  > "") THEN DO:
      &if DEFINED(IDE-IS-RUNNING) <> 0 &then
         lLogical = ShowMessageInIDE("This will delete the current join criteria. ~n
                                      Do you wish to continue?" ,
                                      "Warning",?,"YES-NO",lLogical).
      
      &else    
      MESSAGE "This will delete the current join criteria." SKIP
              "Do you wish to continue?" 
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE lLogical.
      &endif  

      IF (lLogical <> TRUE) THEN DO:
        tJoinable:SCREEN-VALUE = "YES".
        RETURN.
      END.
    END.

    ASSIGN
      cTemp                      = {&CurTable}
      {&CurTable}                = REPLACE ({&CurTable}, " WHERE ", " OF ")
      {&CurTable}                = TRIM ({&CurTable},".")
      eResCurrentTable:SCREEN-VALUE   = {&CurTable}
      acJoin [LOOKUP (TRIM(cTemp), eCurrentTable:LIST-ITEMS, {&Sep1}) 
        + (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)] = ""
      eDisplayCode:SCREEN-VALUE  = ""
      {&CurLeft}:SCREEN-VALUE    = ""
      {&CurRight}:SCREEN-VALUE   = ""
      bCheckSyntax:SENSITIVE     = FALSE
      bUndo:SENSITIVE            = FALSE
      eDisplayCode:SENSITIVE     = FALSE
      eDisplayCode:BGCOLOR       = {&READ-ONLY_BGC}
      {&CurLeft}:SENSITIVE       = FALSE
      {&CurRight}:SENSITIVE      = FALSE.

     RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,FALSE).

     FOR EACH ttWhere WHERE {&Join} = ttWhere.iState 
       AND ENTRY (1, cTemp, " ") = ttWhere.cTable AND ttWhere.iSeq > 0:
       DELETE ttWhere.
     END.
  END.

  lOK = whRight[{&table}]:REPLACE ({&CurTable}, cTemp).
  lOK = eCurrentTable:REPLACE ({&CurTable}, cTemp).

  /*
    message
     lOK SKIP
     whRight[{&table}]:LIST-ITEMS SKIP
     {&CurTable} SKIP
     cTemp SKIP
     tJoinable:SCREEN-VALUE 
     view-as alert-box error buttons Ok.
  */
  END.
END.
/*----------------------------------------------------------------------------*/
ON VALUE-CHANGED OF rsMain DO:
  DEFINE VARIABLE chkstrng AS CHARACTER NO-UNDO. 
  DO WITH FRAME dialog-1:
    DEF VAR lConstant AS LOG NO-UNDO.
    
    IF NUM-ENTRIES(whRight[{&Table}]:LIST-ITEMS,{&Sep1}) = iXternalCnt THEN DO:
      /*
      ** Fail/safe: don't go into the various states if there are only
      ** external tables available. Shouldn't have to do this, but you never
      ** know.
      */       
      ASSIGN
        lConstant = rsMain:DISABLE("Join") 
        lConstant = rsMain:DISABLE("Where")
        lConstant = rsMain:DISABLE("Sort")
        lConstant = rsMain:DISABLE("Options").
      RETURN NO-APPLY.
    END.
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
    RUN adeshar/_qenable.p (auto_check, application, pcValidStates).
    &else
    RUN adeuib/ide/_dialog_qenable.p (auto_check, application, pcValidStates).
    &endif
      CASE rsMain:SCREEN-VALUE:
      WHEN "{&Sort}" THEN DO:                 
         RUN DisplaySort.ip (FALSE, 0, INPUT-OUTPUT eDisplayCode). 
         ASSIGN
           eDisplayCode:SCREEN-VALUE  = eDisplayCode.
      END.

      WHEN "{&Join}" THEN DO:
         RUN setCustJoin.ip.
      END.
      
      WHEN "{&Where}" THEN DO:
        /** To set up Undo State **/
        FIND LAST ttWhere WHERE {&Where} = ttWhere.iState 
                           AND   lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.
        IF AVAILABLE (ttWhere) THEN DO:
           ASSIGN cLastField  = ttWhere.cLastField
                  chkstrng    = TRIM(eDisplayCode:SCREEN-VALUE).

           IF chkstrng = "" OR chkstrng MATCHES "*AND" 
             OR chkstrng MATCHES "*OR" THEN DO:
             /* re-inits the combo-box */
             RUN adeshar/_qset.p ("setComboBox",application,TRUE).
             ASSIGN
               cLastField                 = ttWhere.cLastField
               {&CurLeft}:SENSITIVE       = ttWhere.lOperator
               {&CurRight}:SENSITIVE      = ttWhere.lOperator
               lWhState                   = ttWhere.lWhState.
             RUN load_ops.
           END.
           ELSE DO:  /* We can't really tell if this should be done, but
                        it is better to have them on just in case.       */
             RUN adeshar/_qset.p ("SetOperatorsSensitive.ip", application,TRUE).
             RUN adeshar/_qset.p ("setJoinOperatorsSensitive.ip",
                                   application,TRUE).
           END.
           ASSIGN
             eCurrentTable:SCREEN-VALUE = eCurrentTable
             lLeft:SCREEN-VALUE         = eCurrentTable
             eDisplayCode:SCREEN-VALUE  = ttWhere.cExpression.
    END.
      END.

      WHEN "{&Table}" THEN DO:
        /* Loadup _TblOptList with current _qo stuff */
        IF CAN-FIND(FIRST _qo) THEN DO:  /* We at least have built the records */
          _TblOptList = "".
          FOR EACH _qo:
           _TblOptList = _TblOptList 
                  + (IF _qo._seq-no = 1 THEN "" ELSE ",") 
                  + (IF _qo._find-type NE "EACH":U THEN 
                       " " + _qo._find-type ELSE "") 
                  + (IF _qo._join-type EQ "OUTER":U  THEN " OUTER" ELSE "")
                  + (IF _qo._flds-returned EQ "Fields Used":U THEN 
                       " USED" ELSE "").
          END.
        END.  /* If we have any _qo records */

        RUN BuildOptionList.ip.
        RUN BuildQuery.ip (OUTPUT eDisplayCode). 
    ASSIGN
          eDisplayCode:SCREEN-VALUE = eDisplayCode  
          bCheckSyntax:SENSITIVE    = IF eDisplayCode <> "" THEN 
                                        TRUE ELSE FALSE.
      END.
      
   END CASE.
    eCurrentTable:SCREEN-VALUE = {&CurTable} NO-ERROR. 
  END.                                                 
END.
/*----------------------------------------------------------------------------*/
ON ALT-E OF FRAME dialog-1 DO:
  IF eDisplayCode:VISIBLE IN FRAME dialog-1 THEN
    APPLY "ENTRY":u TO eDisplayCode IN FRAME dialog-1.
END.

/* qurytrig.i - end of file */

PROCEDURE choose_b_FreeFormQ:
  DEF VAR ok-cancel            AS CHARACTER INITIAL "Cancel":U           NO-UNDO.
  DEF VAR qcode                AS CHARACTER                              NO-UNDO.
  
  /* Build the query as it is currently known                                  */
  RUN BuildQuery.ip (OUTPUT qcode).
  ASSIGN _TblList = TRIM({&TableRight}:LIST-ITEMS).
  
  /* It is necessary to call another procedure, because the query builder is
     unaware of the _U record for the currently in use because of its double
     duty with results.   
                                                         */
  RUN adeuib/_ffqdlg.p (INPUT qcode, INPUT _TblList, INPUT-OUTPUT ok-cancel).
  IF ok-cancel = "Freeform":U THEN DO:
    plVisitFields = FALSE.
    APPLY "GO" TO FRAME DIALOG-1.
  END.
  ELSE RETURN NO-APPLY.
      
END PROCEDURE.

procedure choose_whereButton:
  define input  parameter pOperator as character no-undo.
  DO WITH FRAME dialog-1:
    IF {&Join-Mode} THEN 
      RUN Join.ip (pOperator, TRUE).
    ELSE DO:
      IF res_calcfld THEN 
        cTemp = SUBSTRING({&CurLeft}:SCREEN-VALUE,1,
                          INDEX({&CurLeft}:SCREEN-VALUE,"(":u) - 2,
                          "CHARACTER":u).
      ELSE
        RUN guess_field (OUTPUT cTemp). 

      IF NUM-ENTRIES(cTemp," ":U) > 1 THEN
        cTemp = ENTRY(NUM-ENTRIES(cTemp," ":U),cTemp," ":U).
      RUN adeshar/_qwhere.p (pOperator,cTemp,application,res_calcfld,
                             {&CurLeft}:SCREEN-VALUE).
    END.
    FIND LAST ttWhere WHERE INTEGER (rsMain:SCREEN-VALUE) = ttWhere.iState 
      AND lLeft:SCREEN-VALUE = ttWhere.cTable.

    /* If from the users point of view we have saved this then just leave */
    IF (ttWhere.cExpression = TRIM(eDisplayCode:SCREEN-VALUE)) THEN RETURN.   
    i = ttWhere.iSeq.
    CREATE ttWhere.
    ASSIGN
      cLastField                 = TRIM(eDisplayCode:SCREEN-VALUE)
      ttWhere.iState             = INTEGER (rsMain:SCREEN-VALUE)
      ttWhere.cTable             = lLeft:SCREEN-VALUE
      ttWhere.iSeq               = i + 1
      ttWhere.iOffset            = eDisplayCode:CURSOR-OFFSET 
      ttWhere.cExpression        = eDisplayCode:SCREEN-VALUE 
      ttWhere.lOperator          = TRUE /* ggg This needs work !! */ 
      ttWhere.lWhState           = lWhState
      bCheckSyntax:SENSITIVE     = TRUE
      bUndo:SENSITIVE            = TRUE.
  END. 
end procedure.    