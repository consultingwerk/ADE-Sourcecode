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

File: _qenable.p

Description:
  This procedure enables the query builder.  There are five sections:
     join_enable, where_enable, sort_enable, field_enable, table_enable.

  A sixth section (init_frame) is called initially to initialize a new
  screen.

  Each section sets frame DIALOG-1 up to allow the user to work in the
  named aspect of the query.

INPUT Parameters - auto_check    - TRUE if set Check Syntax on OK to ON
		   application   - calling application
		   pcValidStates - if 1 then hide rsMain radio set

INPUT-OUTPUT Parameters - none

OUTPUT Parameters - none

Author: Greg O'Connor

Date Created: 3/23/93
     Changed: 8/31/99  hd indexed-reposition is default value  
                          (tIndexReposition is true ALSO if _OptionList = '')   
----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES

{ adeshar/quryshar.i }
{ adecomm/tt-brws.i }
{ adeshar/qurydefs.i }
{ adecomm/adestds.i }

DEFINE INPUT PARAMETER auto_check    AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER application   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcValidStates AS CHARACTER NO-UNDO.

DEFINE VARIABLE lbl-handle AS HANDLE              NO-UNDO.
DEFINE VARIABLE stupid     AS LOGICAL             NO-UNDO.

DO WITH FRAME dialog-1:
  CASE rsMain:SCREEN-VALUE:
    WHEN "{&join}"    THEN RUN join_enable.
    WHEN "{&Where}"   THEN RUN where_enable.
    WHEN "{&Sort}"    THEN RUN sort_enable.
    WHEN "{&Options}" THEN RUN options_enable.
    WHEN "{&Table}"   THEN RUN table_enable.
    OTHERWISE
      /* Hack assumption that the screen has not been viewed so there is no
	 SCREEN-VALUE. This code needs to be here because of size limits.
      */
      RUN init_frame.
  END CASE.
END.

/* -----------------------------------------------------------
  Purpose:    Init frame initalizes the query subsystem.
	      It also reads in 
		_Ordlist
		_TblList
		_FldList
		_Where
		_JoinCode.
				 
  Run Syntax:  RUN init_frame.
  Parameters:  <none>
  Notes:       Do things here before making dialog VISIBLE.

-------------------------------------------------------------*/
PROCEDURE init_frame:
DEFINE VARIABLE iTemp      AS INTEGER  NO-UNDO.

IF application = "Results_Join":U THEN 
  FRAME DIALOG-1:TITLE = "Join Construction".

ASSIGN FRAME DIALOG-1:VISIBLE = FALSE.

DO WITH FRAME dialog-1:
  {adecomm/okrun.i  
     &FRAME  = "FRAME dialog-1" 
     &BOX    = "RECT-3"
     &OK     = "bOK" 
     &CANCEL = "bCancel"
     &OTHER  = "SPACE({&HM_BTNG}) b_freeformq"
     &HELP   = "bHelp"
  }
     
  ASSIGN
    /* Always VISIBLE and enabled */
    rsMain:SENSITIVE             = TRUE 
    eCurrentTable:SENSITIVE      = TRUE
    lLeft:SENSITIVE              = TRUE
    bAdd:SENSITIVE               = TRUE
    bRemove:SENSITIVE            = FALSE
    bUp:SENSITIVE                = TRUE
    bDown:SENSITIVE              = TRUE
    lRight:SENSITIVE             = TRUE 
    cShareType:SENSITIVE         = TRUE
    
    eResCurrentTable:VISIBLE     = FALSE
    eResCurrentTable:SENSITIVE   = TRUE
    eResCurrentTable:READ-ONLY   = TRUE
    _qrytune:VISIBLE             = FALSE
    lqrytune:VISIBLE             = FALSE     
    _TuneOptions:VISIBLE         = FALSE
    _TuneOptions:SCREEN-VALUE    = _TuneOptions
    _TuneOptions:RETURN-INSERTED = TRUE
    _TuneOptions:SENSITIVE       = FALSE
    lPhraseLabel:VISIBLE         = FALSE
    lPhraseLabel:SCREEN-VALUE    = lPhraseLabel    
    /* Only enable the KEY-PHRASE button if NO external tables. If
       is is disabled, always show it as being unchecked. */
    tKeyPhrase:VISIBLE           = FALSE     
    tKeyPhrase:SENSITIVE         = (iXternalCnt eq 0)      
    tKeyPhrase:CHECKED           = IF (iXternalCnt eq 0) THEN tKeyPhrase ELSE FALSE
    tSortByPhrase:VISIBLE        = FALSE
    tSortByPhrase:SENSITIVE      = TRUE
    tSortByPhrase:CHECKED        = tSortByPhrase  
    
    /* Other VISIBLE and enabled  */
    lBrowseLabel:SENSITIVE       = TRUE
    eDisplayCode:SENSITIVE       = TRUE 
    eDisplayCode:RETURN-INSERTED = TRUE 
    eDisplayCode:SCROLLBAR-H     = TRUE
    l_label-2:SENSITIVE          = TRUE
    bTableSwitch:SENSITIVE       = TRUE
    eFieldLabel:SENSITIVE        = TRUE 
    eFieldLabel:RETURN-INSERTED  = TRUE
    eFieldFormat:SENSITIVE       = TRUE
    rsSortDirection:SENSITIVE    = TRUE
    bUndo:SENSITIVE              = TRUE
    bCheckSyntax:SENSITIVE       = TRUE
    bFieldFormat:SENSITIVE       = TRUE  
    bOk:SENSITIVE                = TRUE
    bCancel:SENSITIVE            = TRUE
    bHelp:SENSITIVE              = TRUE

    /* Operators                  */
    bEqual:SENSITIVE             = TRUE 
    bNotEqual:SENSITIVE          = TRUE         
    bLess:SENSITIVE              = TRUE         
    bGreater:SENSITIVE           = TRUE         
    bLessEqual:SENSITIVE         = TRUE         
    bGreaterEqual:SENSITIVE      = TRUE         
    bAnd:SENSITIVE               = TRUE
    bOR:SENSITIVE                = TRUE

    /* Operators for Where        */
    bBegins:SENSITIVE            = TRUE
    bMatches:SENSITIVE           = TRUE
    bRange:SENSITIVE             = TRUE         
    bList:SENSITIVE              = TRUE 
    bContains:SENSITIVE          = TRUE 
/*  bxRange:SENSITIVE            = TRUE 
    bXList:SENSITIVE             = TRUE */
    tJoinable:SENSITIVE          = TRUE   

    /* Initial visiblity can be optimized to look like table ?? **/
    lBrowseLabel:VISIBLE         = FALSE
    lRight:VISIBLE               = FALSE
    bAdd:VISIBLE                 = FALSE
    bRemove:VISIBLE              = FALSE
    eDisplayCode:VISIBLE         = FALSE
    l_label-2:VISIBLE            = FALSE
    tIndexReposition:VISIBLE     = FALSE
    bTableSwitch:VISIBLE         = FALSE
    bUp:VISIBLE                  = FALSE
    bDown:VISIBLE                = FALSE
    eFieldLabel:VISIBLE          = FALSE
    eFieldFormat:VISIBLE         = FALSE
    rsSortDirection:VISIBLE      = FALSE
    bUndo:VISIBLE                = FALSE
    bCheckSyntax:VISIBLE         = FALSE
    bFieldFormat:VISIBLE         = FALSE
    tJoinable:VISIBLE            = FALSE

    /* Operators */
    bEqual:VISIBLE               = FALSE
    bNotEqual:VISIBLE            = FALSE
    bLess:VISIBLE                = FALSE
    bGreater:VISIBLE             = FALSE
    bLessEqual:VISIBLE           = FALSE
    bGreaterEqual:VISIBLE        = FALSE
    bAnd:VISIBLE                 = FALSE
    bOR:VISIBLE                  = FALSE
    tAskRun:VISIBLE              = FALSE 

    /* Operators for Where         */
    bBegins:VISIBLE              = FALSE
    bMatches:VISIBLE             = FALSE
    bRange:VISIBLE               = FALSE
    bList:VISIBLE                = FALSE
    bContains:VISIBLE            = FALSE

    /* things that are always VISIBLE go here ?? */
    /* Misc things */
    rect-1:WIDTH-CHARS           = eff_frame_width   
    eDisplayCode:RETURN-INSERTED = TRUE
    cShareType:VISIBLE           = FALSE 
    cShareType                   = IF _Optionlist = "":U THEN "NO-LOCK":U
				                   ELSE ENTRY(1, _Optionlist," ":U)
    cShareType:SCREEN-VALUE      = cShareType
    lSyntax:SCREEN-VALUE         = lSyntax
    tOnOk:SENSITIVE              = TRUE
    tOnOk:SCREEN-VALUE           = IF auto_check THEN "yes" ELSE "no"
    rsMain:VISIBLE               = NUM-ENTRIES(pcValidStates) > 1
    b_freeformq:VISIBLE          = application = "{&UIB_SHORT_NAME}":U AND _FreeFormEnable
    b_freeformq:SENSITIVE        = application = "{&UIB_SHORT_NAME}":U AND _FreeFormEnable
    lWhState                     = FALSE
    .  

  DO i = 1 to {&Max-function}:    /* Max-function is 5 - one for each of:
				     Table, Join, Where, Sort and Field  */
    CREATE SELECTION-LIST whLeft[i]
       ASSIGN WIDTH       = 26
	      INNER-LINES = 7
	      HIDDEN      = YES
	      FRAME       = FRAME dialog-1:HANDLE
	      ROW         = 4.5 
	      COLUMN      = 2  
	      SCROLLBAR-V = TRUE
	      SCROLLBAR-H = TRUE
	      SENSITIVE   = TRUE
	      MULTIPLE    = IF (i = {&join} OR i = {&Where})
			    THEN FALSE ELSE TRUE
	      DELIMITER   = {&Sep1}
      TRIGGERS:
	ON DEFAULT-ACTION PERSISTENT RUN DefaultActionLeft.ip.
	ON ENTRY          PERSISTENT RUN ClearValueRight.ip.    
	ON VALUE-CHANGED  PERSISTENT RUN ValueChangeLeft.ip.  
      END TRIGGERS.
	      
    CREATE SELECTION-LIST whRight[i]
       ASSIGN WIDTH        = 26
	      INNER-LINES  = 7
	      HIDDEN       = YES
	      FRAME        = FRAME dialog-1:HANDLE
	      ROW          = 4.5 
	      COLUMN       = 42 
	      SENSITIVE    = TRUE
	      SCROLLBAR-V  = TRUE   
	      DRAG-ENABLED = TRUE
	      SCROLLBAR-H  = TRUE
	      MULTIPLE     = IF (i = {&join} OR i = {&Where})
			     THEN FALSE ELSE TRUE
	      DELIMITER    = {&Sep1}
      TRIGGERS:
	ON DEFAULT-ACTION PERSISTENT RUN DefaultActionRight.ip. 
	ON ENTRY          PERSISTENT RUN ClearValueLeft.ip. 
	ON VALUE-CHANGED  PERSISTENT RUN ValueChangeRight.ip.     
      END TRIGGERS.
  END.  /* i = 1 to max-function */

  /* Make Separator1 the delimiter for the center combo-box selection list */
  ASSIGN eCurrentTable:DELIMITER = {&Sep1}.
     

  DEFINE VARIABLE i        AS INTEGER   NO-UNDO. 
  DEFINE VARIABLE OldDB    AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE Tempnm   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pSuccess AS LOGICAL   NO-UNDO.   
  
  olddb = ldbname("DICTDB").

  do i = 1 to num-dbs:
    if dbtype(i) = "PROGRESS":U then do:
      create alias "DICTDB" for database value(ldbname(i)).  
      create alias "QBF$1"  for database value(ldbname(i)).
      create alias "QBF$2"  for database value(ldbname(i)).
      run adecomm/_dblist.p (input eCurrentTable:handle, output pSuccess). 
    end.
  end.
  
  /* Remove TEMP-DB if it is in the list */
  i = eCurrentTable:LOOKUP("TEMP-DB":U).
  IF i > 0 THEN stupid = eCurrentTable:DELETE(i).
  
  /* Add Temp-Tables if appropriate */
  IF CAN-FIND(FIRST _tt-tbl) THEN stupid = eCurrentTable:ADD-LAST("Temp-Tables":U).

  /* For schema holders that don't have the foreign db connected, move the
     logical name of the schema holder to the end of the table list        */
  IF LDBNAME(eCurrentTable:ENTRY(1)) = SDBNAME(eCurrentTable:ENTRY(1)) AND
     CAN-FIND(FIRST DICTDB._DB WHERE
                    DICTDB._DB._DB-NAME = PDBNAME(eCurrentTable:ENTRY(1)) AND
                    DICTDB._DB._DB-TYPE NE "PROGRESS":U) THEN DO:
    ASSIGN Tempnm = eCurrentTable:ENTRY(1).
    eCurrentTable:DELETE(1).
    eCurrentTable:ADD-LAST(Tempnm).
  END.

  IF oldDB <> "?" OR oldDB <> ? THEN 
    CREATE ALIAS "DICTDB" FOR DATABASE VALUE(olddb).  

  ASSIGN Tempnm                   = eCurrentTable:LIST-ITEMS
         cMoreData[{&Table}]      = Tempnm     
         {&TableRight}:LIST-ITEMS = _TblList
         {&CurSortData}           = _OrdList
         {&CurFieldData}          = _FldList
         b_Fields:SENSITIVE       = CAN-DO(pcValidStates,"Fields":U)  AND
                                      _TblList <> "" AND
                                      NUM-ENTRIES(_TblList) > iXternalCnt
         b_Fields:VISIBLE         = CAN-DO(pcValidStates,"Fields":U).


  DO i = 1 TO EXTENT (_Where):
    ASSIGN
      acWhere[i] = IF _Where[i] = ?      THEN ""            ELSE _Where[i]
      acJoin [i] = IF _JoinCode[i] <> "" THEN  _JoinCode[i] ELSE "".

    IF i <= NUM-ENTRIES({&TableRight}:LIST-ITEMS, {&Sep1}) THEN DO:
 
      DO j = {&Join} TO {&Where}:
	CREATE ttWhere.
	VALIDATE ttWhere. /* These validates are necessary to force the write */
	ASSIGN
	  ttWhere.cTable      = ENTRY(1,
				  ENTRY(i, {&TableRight}:LIST-ITEMS, {&Sep1}),
				  " ") 
	  ttWhere.iState      = j
	  ttWhere.iSeq        = 0
	  ttWhere.iOffset     = 1 
	  ttWhere.cExpression = if j = {&Join} then acJoin[i] else acWhere[i]  
	  ttWhere.lOperator   = TRUE
	  ttWhere.lWhState    = lWhState.
      END.  /* Do j = join to where */
      {&TableRight}:PRIVATE-DATA = (IF i = 1 THEN ttWhere.cTable
					     ELSE {&TableRight}:private-data +
						  {&Sep1} + ttWhere.cTable).
    END. /* If i < num-entries */
  END.  /* Do i = 1 TO EXTENT */

  DO j = {&Sort} TO {&Options}:
    DO i = 1 TO NUM-ENTRIES (cMoreData[j], {&Sep1}):
      lOK = whRight [j]:ADD-LAST(ENTRY(1,
				       ENTRY(i, cMoreData[j], {&Sep1}),
				       {&Sep2})).
    END. /* DO i = 1 to NUM-ENTRIES */
  END.  /* DO j = sort to field */

  DEFINE VARIABLE wHandle AS HANDLE NO-UNDO.
  j = IF application BEGINS "Results_Where" THEN 2 ELSE 1.

  IF application BEGINS "Results" THEN DO:
    wHandle = FRAME dialog-1:FIRST-CHILD.
    wHandle = wHandle:FIRST-CHILD.
    DO WHILE wHandle <> ? :
      IF wHandle:ROW > j + 1 THEN
	wHandle:ROW = wHandle:ROW - j.
      wHandle = wHandle:NEXT-SIBLING.
    END.
    FRAME dialog-1:SCROLLABLE = FALSE.
    &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
    FRAME dialog-1:RULE-ROW = FRAME dialog-1:RULE-ROW - j.
    &ENDIF
    FRAME dialog-1:HEIGHT = FRAME dialog-1:HEIGHT - j.
  END.
END.  /* Do with frame dialog-1 */ 
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE options_enable.
DO WITH FRAME dialog-1:
  RUN adeshar/_qset.p ("SetOperatorsVisible.ip",application,FALSE).
  RUN adeshar/_qset.p ("SetJoinOperatorsVisible.ip",application,FALSE).
 
  ASSIGN
     eCurrentTable:VISIBLE             = FALSE
     lbl-handle                        = eCurrentTable:SIDE-LABEL-HANDLE
     lbl-handle:VISIBLE                = FALSE
     lLeft:VISIBLE                     = FALSE
     l_label-2:VISIBLE                 = FALSE
     lRight:VISIBLE                    = FALSE
     whLeft[1]:VISIBLE                 = FALSE
     whLeft[2]:VISIBLE                 = FALSE
     whLeft[3]:VISIBLE                 = FALSE
     whLeft[4]:VISIBLE                 = FALSE
     whLeft[5]:VISIBLE                 = FALSE
     whRight[1]:VISIBLE                = FALSE
     whRight[2]:VISIBLE                = FALSE
     whRight[3]:VISIBLE                = FALSE
     whRight[4]:VISIBLE                = FALSE
     whRight[5]:VISIBLE                = FALSE
     lBrowseLabel:VISIBLE              = FALSE
     bAdd:VISIBLE                      = FALSE
     bRemove:VISIBLE                   = FALSE
     eDisplayCode:VISIBLE              = FALSE
     bUp:VISIBLE                       = FALSE
     bDown:VISIBLE                     = FALSE
     lbl-handle                        = eFieldLabel:SIDE-LABEL-HANDLE
     lbl-handle:VISIBLE                = FALSE
     eFieldLabel:VISIBLE               = FALSE
     lbl-handle                        = eFieldFormat:SIDE-LABEL-HANDLE
     lbl-handle:VISIBLE                = FALSE
     eFieldFormat:VISIBLE              = FALSE
     bFieldFormat:VISIBLE              = FALSE
     tIndexReposition:VISIBLE          = FALSE
     bTableSwitch:VISIBLE              = FALSE
     rsSortDirection:VISIBLE           = FALSE
     bUndo:VISIBLE                     = FALSE
     cShareType:VISIBLE                = FALSE
     tJoinable:VISIBLE                 = FALSE
     tAskRun:VISIBLE                   = FALSE 
     bFieldFormat:SENSITIVE            = FALSE
     eFieldLabel:SENSITIVE             = bFieldFormat:sensitive 
     eFieldFormat:SENSITIVE            = bFieldFormat:sensitive
     lSyntax:VISIBLE                   = TRUE
     tOnOk:VISIBLE                     = TRUE
     bCheckSyntax:VISIBLE              = TRUE
     _qrytune:NUM-LOCKED-COLUMNS       = 4
     _qrytune:VISIBLE                  = TRUE
     lqrytune:SCREEN-VALUE             = lqrytune
     lqrytune:VISIBLE                  = TRUE
     _TuneOptions:VISIBLE              = TRUE
     _TuneOptions:SENSITIVE            = TRUE
     lPhraseLabel:VISIBLE              = TRUE
     tKeyPhrase:VISIBLE                = TRUE
     tSortByPhrase:VISIBLE             = TRUE
     .

  RUN adeshar/_qset.p ("setQueryTune",application,TRUE).
	   
  IF application BEGINS "Results_Where":U THEN 
    FRAME DIALOG-1:TITLE = "Fields Selection".
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE sort_enable:
  DEFINE VARIABLE i      AS INTEGER NO-UNDO.
  DEFINE VARIABLE ldummy AS LOGICAL NO-UNDO.
DO WITH FRAME dialog-1:
  RUN adeshar/_qset.p ("SetOperatorsVisible.ip",application,FALSE).
  RUN adeshar/_qset.p ("SetJoinOperatorsVisible.ip",application,FALSE).

  ASSIGN
     eCurrenttable:LABEL        = "T&able":U
     lbl-handle                 = eCurrentTable:SIDE-LABEL-HANDLE
     lbl-handle:COLUMN          = eCurrentTable:COLUMN 
				- FONT-TABLE:GET-TEXT-WIDTH-CHARS("Table: ":U)
     _qrytune:VISIBLE           = FALSE
     lqrytune:VISIBLE           = FALSE
     _TuneOptions:VISIBLE       = FALSE
     _TuneOptions:SENSITIVE     = FALSE
     lPhraseLabel:VISIBLE       = FALSE
     tKeyPhrase:VISIBLE         = FALSE
     tSortByPhrase:VISIBLE      = FALSE
     l_label-2:VISIBLE          = FALSE
     tIndexReposition:VISIBLE   = FALSE
     bTableSwitch:VISIBLE       = FALSE
     eFieldLabel:VISIBLE        = FALSE
     eFieldFormat:VISIBLE       = FALSE
     bUndo:VISIBLE              = FALSE
     cShareType:VISIBLE         = FALSE
     bCheckSyntax:VISIBLE       = FALSE
     lSyntax:VISIBLE            = FALSE
     tOnOk:VISIBLE              = FALSE
     bFieldFormat:VISIBLE       = FALSE
     tAskRun:VISIBLE            = FALSE 
     tJoinable:VISIBLE          = FALSE
     eCurrentTable:VISIBLE      = TRUE
     eCurrentTable:SENSITIVE    = TRUE
     lbl-handle:VISIBLE         = TRUE  
     lBrowseLabel:SCREEN-VALUE  = " Sort Crit&eria:"
     lBrowseLabel:VISIBLE       = TRUE
     lLeft:VISIBLE              = TRUE
     lLeft:SCREEN-VALUE         = "Available Fields:" 
     lRight:VISIBLE             = TRUE
     lRight:SCREEN-VALUE        = "Selected Fields:"
     bAdd:VISIBLE               = TRUE
     bRemove:VISIBLE            = TRUE
     eDisplayCode:VISIBLE       = TRUE
     eDisplayCode:BGCOLOR       = {&READ-ONLY_BGC}
     eDisplayCode:FGCOLOR       = FRAME dialog-1:FGCOLOR
     eDisplayCode:READ-ONLY     = TRUE 
     bUp:VISIBLE                = TRUE
     bDown:VISIBLE              = TRUE
     bDown:ROW                  = whLeft[4]:ROW + whLeft[4]:HEIGHT - bDown:HEIGHT
     bUp:ROW                    = bDown:ROW - (bRemove:ROW - bAdd:ROW)
     rsSortDirection:VISIBLE    = TRUE
     rsSortDirection:SENSITIVE  = ({&CurRight}:SCREEN-VALUE <> ?)
     .
  RUN adeshar/_qset.p ("setLeftRight",application,TRUE).
  RUN adeshar/_qset.p ("setComboBox",application,TRUE).
  RUN adeshar/_qset.p ("setUpDown",application,TRUE).

  DO i = 1 TO {&CurRight}:NUM-ITEMS:   /* Remove fields already selected */
    IF {&CurLeft}:LOOKUP({&CurRight}:ENTRY(i)) > 0 THEN
      ldummy = {&CurLeft}:DELETE({&CurRight}:ENTRY(i)).
  END.
  IF application BEGINS "Results_Where":U THEN 
    FRAME DIALOG-1:TITLE = "Sort Selection".
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE where_enable:

DO WITH FRAME dialog-1:

  ASSIGN
     _qrytune:VISIBLE           = FALSE
     lqrytune:VISIBLE           = FALSE
     _TuneOptions:VISIBLE       = FALSE
     _TuneOptions:SENSITIVE     = FALSE
     lPhraseLabel:VISIBLE       = FALSE
     tKeyPhrase:VISIBLE         = FALSE
     tSortByPhrase:VISIBLE      = FALSE
     {&CurRight}:VISIBLE        = FALSE
     eCurrenttable:LABEL        = "T&able":U
     lbl-handle                 = eCurrentTable:SIDE-LABEL-HANDLE
     lbl-handle:COLUMN          = eCurrentTable:COLUMN - 
				     FONT-TABLE:GET-TEXT-WIDTH-CHARS("Table: ")
     lRight:VISIBLE             = FALSE /* TRUE */
     lRight:SCREEN-VALUE        = "Comparisons:" 
     bAdd:VISIBLE               = FALSE
     bRemove:VISIBLE            = FALSE
     eDisplayCode:SCREEN-VALUE  = ""
     eDisplayCode:READ-ONLY     = FALSE
     eDisplayCode:BGCOLOR       = std_fillin_bgcolor
     eDisplayCode:FGCOLOR       = std_fillin_fgcolor
     eDisplayCode:SENSITIVE     = TRUE 
     lBrowseLabel:SCREEN-VALUE  = IF application BEGINS "Results_Where" THEN
				    " Selection Crit&eria:" 
                                  ELSE " Where Crit&eria:"
     l_label-2:VISIBLE          = FALSE
     tIndexReposition:VISIBLE   = FALSE
     bTableSwitch:VISIBLE       = FALSE
     bUp:VISIBLE                = FALSE
     bDown:VISIBLE              = FALSE
     eFieldLabel:VISIBLE        = FALSE
     eFieldFormat:VISIBLE       = FALSE
     rsSortDirection:VISIBLE    = FALSE
     cShareType:VISIBLE         = FALSE
     bFieldFormat:VISIBLE       = FALSE
     tAskRun:SENSITIVE          = (application BEGINS "Results_Where") 
     rect-1:VISIBLE             = (NOT application BEGINS "Results_Where")
     tJoinable:VISIBLE          = FALSE
     eCurrentTable:VISIBLE      = NUM-ENTRIES(pcValidStates) > 1
     eCurrentTable:SENSITIVE    = TRUE
     tAskRun:VISIBLE            = (application BEGINS "Results_Where")
     lbl-handle:VISIBLE         = (application = "{&UIB_SHORT_NAME}":U)  
     eDisplayCode:VISIBLE       = TRUE
     bUndo:VISIBLE              = TRUE
     bCheckSyntax:VISIBLE       = TRUE
     bUndo:SENSITIVE            = FALSE
     bCheckSyntax:SENSITIVE     = TRUE
     lSyntax:VISIBLE            = TRUE
     tOnOk:VISIBLE              = TRUE
     lBrowseLabel:VISIBLE       = TRUE
     lWhState                   = FALSE.

  IF application BEGINS "Results_Where":U THEN 
    FRAME DIALOG-1:TITLE = " Data Selection".
     
  RUN adeshar/_qset.p ("setLeftRight",application,TRUE).
  RUN adeshar/_qset.p ("setComboBoxQuery",application,TRUE).
  RUN adeshar/_qset.p ("setComboBox",application,TRUE).
  RUN adeshar/_qset.p ("setUpDown",application,TRUE). 

  IF (LOOKUP({&CurTable}, eCurrentTable:LIST-ITEMS, {&Sep1}) > 0) THEN
    eDisplayCode:SCREEN-VALUE = 
      acWhere [LOOKUP ({&CurTable}, eCurrentTable:LIST-ITEMS, {&Sep1})].
  END.

  RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,FALSE).
  RUN adeshar/_qset.p ("SetOperatorsVisible.ip",application,TRUE).
  RUN adeshar/_qset.p ("SetJoinOperatorsSensitive.ip",application,FALSE).
  RUN adeshar/_qset.p ("SetJoinOperatorsVisible.ip",application,TRUE).

  IF eDisplayCode:SCREEN-VALUE NE "" THEN {&CurLeft}:SENSITIVE = FALSE.  
  /*
  ** the SCREEN-VALUE used to be set in _qset.p but Progress behavior
  ** changed in early 94 so that the widget had to enabled before the
  ** SCREEN-VALUE could be set.  Fixed by R. Ryan 7/94
  */
  eCurrentTable:SCREEN-VALUE = eCurrentTable:ENTRY(1).   
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE join_enable.
DO WITH FRAME dialog-1:
  
  IF application = "Results_Join":U THEN
    ASSIGN rect-1:VISIBLE                 = FALSE
           eCurrenttable:VISIBLE          = FALSE
           eResCurrenttable:VISIBLE       = TRUE.
                  
  ELSE
    ASSIGN eCurrenttable:LABEL        = "Join":U
           lbl-handle                 = eCurrentTable:SIDE-LABEL-HANDLE
           lbl-handle:COLUMN          = eCurrentTable:COLUMN 
                                         - FONT-TABLE:GET-TEXT-WIDTH-CHARS("Join: ")  
           lbl-handle:VISIBLE         = TRUE.
         
  RUN adeshar/_qset.p ("setLeftRight",application,TRUE).
  RUN adeshar/_qset.p ("setComboBoxQuery",application,TRUE).

  ASSIGN
     eCurrentTable:SCREEN-VALUE     = eCurrentTable:ENTRY(1)
     eCurrentTable:VISIBLE          = TRUE
     eResCurrenttable:SCREEN-VALUE  = eCurrentTable:SCREEN-VALUE
     _qrytune:VISIBLE               = FALSE
     lqrytune:VISIBLE               = FALSE
     _TuneOptions:VISIBLE           = FALSE
     _TuneOptions:SENSITIVE         = FALSE
     lPhraseLabel:VISIBLE           = FALSE
     tKeyPhrase:VISIBLE             = FALSE
     tSortByPhrase:VISIBLE          = FALSE
     lBrowseLabel:VISIBLE           = TRUE
     lRight:VISIBLE                 = TRUE
     lBrowseLabel:SCREEN-VALUE      = " Join Crit&eria:"
     bAdd:VISIBLE                   = FALSE
     bRemove:VISIBLE                = FALSE
     eDisplayCode:BGCOLOR           = std_fillin_bgcolor
     eDisplayCode:FGCOLOR           = std_fillin_fgcolor
     eDisplayCode:SCREEN-VALUE      = "" 
     eDisplayCode:READ-ONLY         = TRUE 
     l_label-2:VISIBLE              = FALSE
     l_label-2:SCREEN-VALUE         = l_label-2
     tIndexReposition:VISIBLE       = FALSE
     bTableSwitch:VISIBLE           = FALSE
     bUp:VISIBLE                    = FALSE
     bDown:VISIBLE                  = FALSE
     eFieldLabel:VISIBLE            = FALSE
     eFieldFormat:VISIBLE           = FALSE
     rsSortDirection:VISIBLE        = FALSE
     cShareType:VISIBLE             = FALSE
     tAskRun:VISIBLE                = FALSE 
     bFieldFormat:VISIBLE           = FALSE
     eDisplayCode:VISIBLE           = TRUE
     {&CurLeft}:SENSITIVE           = FALSE
     {&CurRight}:SENSITIVE          = FALSE
     bUndo:VISIBLE                  = TRUE
     lBrowseLabel:VISIBLE           = TRUE
     lLeft:VISIBLE                  = TRUE
     lRight:VISIBLE                 = TRUE
     bCheckSyntax:VISIBLE           = TRUE
     lSyntax:VISIBLE                = TRUE
     tOnOk:VISIBLE                  = TRUE NO-ERROR.
  
  IF eCurrentTable:SCREEN-VALUE = ? THEN 
  DO:
    MESSAGE "The join criteria for this query has been corrupted." SKIP
            "This normally occurs when fields are added to a frame from tables" +
            " that are not included in the base query." SKIP
            "To correct this problem, cancel out of the query builder and " +
            "remove the field(s) that are not part of the query then " +
            "go back into the query builder, add the tables to the query " +
            "and join the query properly. After that you may add the fields " +
            "to the frame."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.

  RUN adeshar/_qset.p ("SetJoinOperatorsVisible.ip",application,FALSE).  
     
  IF application = "Results_Join":U THEN 
     FRAME DIALOG-1:TITLE = "Join Construction".

  /** To set up Undo State **/
   FIND LAST ttWhere WHERE {&Join} = ttWhere.iState 
     AND lLeft:SCREEN-VALUE = ttWhere.cTable NO-ERROR.

   bUndo:SENSITIVE = IF AVAILABLE ttWhere THEN (ttWhere.iSeq > 0) ELSE FALSE.

   IF (LOOKUP ({&CurTable}, eCurrentTable:LIST-ITEMS, {&Sep1}) > 0) THEN
     eDisplayCode:SCREEN-VALUE = 
	 acJoin [LOOKUP ({&CurTable}, eCurrentTable:LIST-ITEMS, {&Sep1}) +
		 (IF iXternalCnt = 0 THEN 1 ELSE iXternalCnt)].
           
  RUN adeshar/_qset.p ("SetOperatorsSensitive.ip",application,FALSE).
  RUN adeshar/_qset.p ("SetOperatorsVisible.ip",application,TRUE).

  IF (eDisplayCode:SCREEN-VALUE NE ? AND eDisplayCode:SCREEN-VALUE NE "")
    OR eResCurrentTable:SCREEN-VALUE MATCHES "*WHERE*" THEN
    ASSIGN bCheckSyntax:SENSITIVE = TRUE
           tJoinable              = TRUE
           tJoinable:CHECKED      = TRUE
           bAnd:SENSITIVE         = TRUE
           bOr:SENSITIVE          = TRUE.
  ELSE tJoinable:VISIBLE          = TRUE.
           
  /* Set proper tab order */
  ASSIGN stupid = eCurrentTable:MOVE-BEFORE({&CurLeft})
         stupid = {&CurLeft}:MOVE-AFTER(eCurrentTable:HANDLE)
         stupid = bEqual:MOVE-AFTER({&CurLeft})
         stupid = bNotEqual:MOVE-AFTER(bEqual:HANDLE) 
         stupid = bLess:MOVE-AFTER(bNotEqual:HANDLE)
         stupid = bGreater:MOVE-AFTER(bLess:HANDLE)
         stupid = bLessEqual:MOVE-AFTER(bGreater:HANDLE)
         stupid = bGreaterEqual:MOVE-AFTER(bLessEqual:HANDLE)
         stupid = bAnd:MOVE-AFTER(bGreaterEqual:HANDLE)
         stupid = bOr:MOVE-AFTER(bAND:HANDLE)
         stupid = {&CurRight}:MOVE-AFTER(bOr:HANDLE)
         stupid = tJoinable:MOVE-AFTER({&CurRight})
         stupid = eDisplayCode:MOVE-AFTER(tJoinable:HANDLE)
         stupid = bUNDO:MOVE-AFTER(eDisplayCode:HANDLE)
         stupid = bCheckSyntax:MOVE-AFTER(bUNDO:HANDLE)
         stupid = tOnOk:MOVE-AFTER(bCheckSyntax:HANDLE)
         stupid = bOK:MOVE-AFTER(tOnOK:HANDLE)
         stupid = bCancel:MOVE-AFTER(bOK:HANDLE)
         stupid = bHELP:MOVE-AFTER(bCANCEL:HANDLE).

  IF NOT tJoinable:CHECKED THEN
    ASSIGN eResCurrentTable:SENSITIVE = FALSE
           eDisplayCode:SENSITIVE     = FALSE.
           
  eCurrentTable:SENSITIVE    = (eCurrentTable:NUM-ITEMS > 1).

  IF (eDisplayCode:SCREEN-VALUE EQ ? OR eDisplayCode:SCREEN-VALUE EQ "")
  THEN bCheckSyntax:SENSITIVE = FALSE.
         
  IF application BEGINS "Results_Join":U AND eDisplayCode:SENSITIVE
    THEN APPLY "ENTRY" TO eDisplayCode.
END.
END PROCEDURE.

/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
PROCEDURE table_enable:
DO WITH FRAME dialog-1: 

  RUN adeshar/_qset.p ("SetOperatorsVisible.ip",application,FALSE).
  RUN adeshar/_qset.p ("SetJoinOperatorsVisible.ip",application,FALSE).

  ASSIGN
     eCurrentTable:Label       = "&Database":U
     lbl-handle                = eCurrentTable:SIDE-LABEL-HANDLE
     lbl-handle:COLUMN         = eCurrentTable:COLUMN 
			      - FONT-TABLE:GET-TEXT-WIDTH-CHARS("Database: ")  
     _qrytune:VISIBLE          = FALSE
     lqrytune:VISIBLE          = FALSE
     _TuneOptions:VISIBLE      = FALSE
     _TuneOptions:SENSITIVE    = FALSE
     lPhraseLabel:VISIBLE      = FALSE
     tKeyPhrase:VISIBLE        = FALSE
     tSortByPhrase:VISIBLE     = FALSE
     bUp:VISIBLE               = FALSE
     bDown:VISIBLE             = FALSE
     eFieldLabel:VISIBLE       = FALSE
     eFieldFormat:VISIBLE      = FALSE
     rsSortDirection:VISIBLE   = FALSE
     bUndo:VISIBLE             = FALSE
     bFieldFormat:VISIBLE      = FALSE
     tJoinable:VISIBLE         = FALSE
     tAskRun:VISIBLE           = FALSE 
     eCurrentTable:VISIBLE     = TRUE
     eCurrentTable:SENSITIVE   = TRUE
     lbl-handle:VISIBLE        = TRUE  
     lBrowseLabel:SCREEN-VALUE = " Query:"
     lBrowseLabel:VISIBLE      = TRUE
     lLeft:VISIBLE             = TRUE
     lLeft:SCREEN-VALUE        = "Available Tables:"

     lRight:VISIBLE            = TRUE
     lRight:SCREEN-VALUE       = l_label-2
     bAdd:VISIBLE              = TRUE
     bRemove:VISIBLE           = TRUE
     eDisplayCode:READ-ONLY    = TRUE
     eDisplayCode:SCREEN-VALUE = ""
     eDisplayCode:VISIBLE      = TRUE
     eDisplayCode:BGCOLOR      = {&READ-ONLY_BGC}
     eDisplayCode:FGCOLOR      = FRAME dialog-1:FGCOLOR
     cShareType:VISIBLE        = TRUE
     bCheckSyntax:VISIBLE      = TRUE
     lSyntax:VISIBLE           = TRUE
     tOnOk:VISIBLE             = TRUE
     tIndexReposition:VISIBLE  = TRUE 
     tIndexReposition          = _OptionList = "":U /* true is Default */  
                                 OR 
                                 index(_OptionList,"INDEX":U) > 0
     tIndexReposition:CHECKED  = tIndexReposition
     bTableSwitch:VISIBLE      = TRUE
     .
     
  RUN adeshar/_qset.p ("setLeftRight",application,TRUE). 
  RUN adeshar/_qset.p ("setComboBox",application,TRUE). 
  RUN adeshar/_qset.p ("setUpDown",application,TRUE).
     
  IF application BEGINS "Results_Where":U THEN 
    FRAME DIALOG-1:TITLE = "Query Builder".     
     
END.   
END PROCEDURE.

/* _qenable.p - end of file */


