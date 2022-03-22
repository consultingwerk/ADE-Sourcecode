&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: fieldd.w 

  Purpose: Instance Properties Dialog for SmartDataFields.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  Modified: Aug 5, 1999, Version 9.1A
  
      NOTE:  The field's operatorStyle is maintained with two toggle boxes,
             but they represent only one field. (tField.OperatoreStyle) 
             There's special logic to handle this in every place where tField is 
             referenced. 
             The toggle boxes disabling and enabling is done in attempt to avoid  
             mixing logically incompatible styles. The advantage with this approach 
             is that when the developer changes the default style, he does not need 
             to go through the fields to uncheck previously overrides that now
             is "wrong". This dialog also takes care of removing previouisly 
             overridden styles that does not follow the rules.          
             The filter does not really care, the rules are only maintained in this 
             dialog.  
                   
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
  DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
  DEFINE VARIABLE gcDisplayedFields AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE ghFuncLib         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE ghSDO             AS HANDLE    NO-UNDO.
  DEFINE VARIABLE glDesignSDO       AS LOGICAL   NO-UNDO.

/* keep track of changes to field attributes */ 
DEFINE TEMP-TABLE tField NO-UNDO
FIELD FieldName    AS CHAR
FIELD FieldLabel   AS CHAR
FIELD FieldWidth   AS DEC
FIELD FieldToolTip AS CHAR
FIELD FieldHelpId  AS INT
FIELD FieldViewAs  AS CHAR
FIELD FieldLogical AS CHAR
FIELD FieldStyle   AS CHAR
FIELD InheritLabel AS LOGICAL
FIELD InheritWidth AS LOGICAL
FIELD Modified     AS LOGICAL

INDEX FieldName FieldName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lView cDataObject cFields cLabel dWidth ~
cTooltip iHelpId cOperatorStyle cOperatorViewAs dDefaultCharWidth ~
dDefaultWidth dColumn iDefaultEditorLines RECT-1 RECT-19 RECT-20 RECT-21 ~
RECT-5 RECT-6 
&Scoped-Define DISPLAYED-OBJECTS lView cDataObject cFields lInheritLabel ~
lInheritWidth cOperatorStyle cOperator lUseBegins lUseContains ~
cOperatorViewAs dDefaultCharWidth dDefaultWidth dColumn iDefaultEditorLines 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignField Attribute-Dlg 
FUNCTION assignField RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableObjects Attribute-Dlg 
FUNCTION enableObjects RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle Attribute-Dlg 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initField Attribute-Dlg 
FUNCTION initField RETURNS LOGICAL
  (pcName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initFieldStyle Attribute-Dlg 
FUNCTION initFieldStyle RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initFieldWidth Attribute-Dlg 
FUNCTION initFieldWidth RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSDO Attribute-Dlg 
FUNCTION initSDO RETURNS LOGICAL
   ( pcNewSDO AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initTheme Attribute-Dlg 
FUNCTION initTheme RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetFieldTabOrder Attribute-Dlg 
FUNCTION resetFieldTabOrder RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBrowse 
     LABEL "&Browse..." 
     SIZE 21 BY 1.1.

DEFINE BUTTON btnFields 
     LABEL "&Edit Field List..." 
     SIZE 21 BY 1.14.

DEFINE BUTTON btnRemove 
     LABEL "&Remove Field" 
     SIZE 21 BY 1.14.

DEFINE VARIABLE cOperator AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE cDataObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Target" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .95 NO-UNDO.

DEFINE VARIABLE cLabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE cTooltip AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tooltip" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE dColumn AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Column" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE dDefaultCharWidth AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "Width of Character Fields" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE dDefaultWidth AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "Width of Other Fields" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE dWidth AS DECIMAL FORMAT ">,>>9.99":U INITIAL 0 
     LABEL "Width" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE iDefaultEditorLines AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Number of Lines in Editors" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE iHelpId AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Help ID" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cOperatorStyle AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Implicit", "Implicit",
"Explicit", "Explicit",
"Range", "Range",
"Inline", "Inline"
     SIZE 14 BY 3.62 NO-UNDO.

DEFINE VARIABLE cOperatorViewAs AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Combo-box", "Combo-box",
"Radio-set", "Radio-set"
     SIZE 40 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 4.29.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 1.43.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 1.43.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 5.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 6.19.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 7.38.

DEFINE VARIABLE cFields AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 37 BY 3.91 NO-UNDO.

DEFINE VARIABLE lFieldOperator AS LOGICAL INITIAL no 
     LABEL "Explicit operator" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.6 BY .81 NO-UNDO.

DEFINE VARIABLE lFieldViewAsRange AS LOGICAL INITIAL no 
     LABEL "View as range fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE lInheritLabel AS LOGICAL INITIAL no 
     LABEL "Filter Target" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE lInheritWidth AS LOGICAL INITIAL no 
     LABEL "Default" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .81 NO-UNDO.

DEFINE VARIABLE lUseBegins AS LOGICAL INITIAL no 
     LABEL "BEGINS" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE lUseContains AS LOGICAL INITIAL no 
     LABEL "CONTAINS" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE lView AS LOGICAL INITIAL no 
     LABEL "View" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     lView AT ROW 15.76 COL 76
     cDataObject AT ROW 1.95 COL 6.6
     btnBrowse AT ROW 1.95 COL 52
     cFields AT ROW 3.29 COL 14 NO-LABEL
     btnFields AT ROW 3.33 COL 52
     btnRemove AT ROW 4.62 COL 52
     cLabel AT ROW 8.62 COL 12 COLON-ALIGNED
     lInheritLabel AT ROW 8.62 COL 52
     dWidth AT ROW 9.81 COL 12 COLON-ALIGNED
     lInheritWidth AT ROW 9.81 COL 52
     cTooltip AT ROW 11 COL 12 COLON-ALIGNED
     iHelpId AT ROW 12.19 COL 12 COLON-ALIGNED
     lFieldViewAsRange AT ROW 13.38 COL 14
     lFieldOperator AT ROW 14.29 COL 14
     cOperatorStyle AT ROW 1.95 COL 78 NO-LABEL
     cOperator AT ROW 1.86 COL 91 COLON-ALIGNED NO-LABEL
     lUseBegins AT ROW 6.57 COL 78
     lUseContains AT ROW 6.57 COL 99
     cOperatorViewAs AT ROW 8.57 COL 78 NO-LABEL
     dDefaultCharWidth AT ROW 10.57 COL 101.8 COLON-ALIGNED
     dDefaultWidth AT ROW 11.76 COL 101.8 COLON-ALIGNED
     dColumn AT ROW 12.95 COL 101.8 COLON-ALIGNED
     iDefaultEditorLines AT ROW 14.14 COL 101.8 COLON-ALIGNED
     " Style" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 1.24 COL 78
     "String Operators" VIEW-AS TEXT
          SIZE 16.8 BY .62 AT ROW 5.91 COL 78.2
     "Fields:" VIEW-AS TEXT
          SIZE 6.8 BY .62 AT ROW 3.29 COL 7.2
     "Field Properties" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 7.86 COL 5.2
     "Data" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 1.19 COL 5.4
     "Operator View as" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 7.91 COL 78
     "Size && Position" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 9.86 COL 78
     RECT-1 AT ROW 1.48 COL 76
     RECT-19 AT ROW 8.19 COL 76
     RECT-20 AT ROW 6.24 COL 76
     RECT-21 AT ROW 10.14 COL 76
     RECT-5 AT ROW 1.48 COL 3
     RECT-6 AT ROW 8.14 COL 3
     SPACE(46.79) SKIP(1.05)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartFilter Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btnBrowse IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnFields IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btnRemove IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cDataObject IN FRAME Attribute-Dlg
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cLabel IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX cOperator IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cTooltip IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN dWidth IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN iHelpId IN FRAME Attribute-Dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX lFieldOperator IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lFieldViewAsRange IN FRAME Attribute-Dlg
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX lInheritLabel IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lInheritWidth IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lUseBegins IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lUseContains IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* SmartFilter Properties */
DO:     
  DEFINE VARIABLE cStyleList AS CHAR    NO-UNDO.
  DEFINE VARIABLE cStyle     AS CHAR    NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER NO-UNDO.
  DEFINE VARIABLE lanswer    AS LOGICAL NO-UNDO.

  IF NOT VALID-HANDLE(ghSDO) THEN
  DO:
    lAnswer = YES.
    MESSAGE 
       "There is no valid Filter Target specified for this SmartFilter."
       SKIP
       "A Target is either specified with a Filter-Link or in the Target field."
       SKIP
       "Use the Target field to specify a design-time SmartDataObject"
       SKIP
       "in the case where the link is a run-time Pass Through link."
       SKIP(1)
       "Do you want to select a design-time SmartDataObject?" 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lAnswer.
    
    IF lAnswer THEN 
       APPLY "CHOOSE":U TO btnBrowse.       
    
    /* we return the the dialog also when yes to add a filter-target */ 
    IF lAnswer OR lAnswer = ? THEN
       RETURN NO-APPLY.   

  END.

  IF VALID-HANDLE(ghSDO) 
  AND gcDisplayedFields = "":U OR gcDisplayedFields = ?  THEN
  DO:
    lAnswer = YES.
    MESSAGE 
       "You should select filter field(s) from the filter-target." SKIP(1)
       "Do you want to add fields to the SmartFilter?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lAnswer.
    
    IF lAnswer THEN 
        APPLY "CHOOSE":U TO btnFields.       
    /* we return the the dialog also when yes to add fields. */ 
    IF lAnswer OR lAnswer = ? THEN
        RETURN NO-APPLY.   
  END.

  /* Save current fields attributes */ 
  assignField().
  
  /* Reassign the attribute alues back in the SmartObject. */
  
  ASSIGN 
   lView
   cOperatorStyle
   cOperator
   cOperatorViewAs
   lUseBegins
   lUseContains
   dColumn.
 /*  NOT IN USE
   cLogicalViewAs
   cLogicalValues.
   */      
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, NOT lView). 
  DYNAMIC-FUNC("setDisplayedFields":U IN p_hSMO, gcDisplayedFields).
  
  DYNAMIC-FUNC("setOperatorStyle":U IN p_hSMO,cOperatorStyle). 
  DYNAMIC-FUNC("setOperatorViewAs":U IN p_hSMO, cOperatorViewAs).
  DYNAMIC-FUNC("setUseBegins":U IN p_hSMO, lUseBegins).
  DYNAMIC-FUNC("setUseContains":U IN p_hSMO, lUseContains).
  /* Only used for implicit and inline */
  DYNAMIC-FUNC("setOperator":U IN p_hSMO, cOperator).

  DYNAMIC-FUNC("setDefaultCharWidth":U IN p_hSMO,dDefaultCharWidth).
  DYNAMIC-FUNC("setFieldColumn":U IN p_hSMO,dColumn). 
  DYNAMIC-FUNC("setDefaultWidth":U IN p_hSMO,dDefaultWidth). 
  DYNAMIC-FUNC("setDefaultEditorLines":U IN p_hSMO,iDefaultEditorLines).
  
  /* The tField temp-table has a record for every field that has been changed */
  FOR EACH tField:
    DYNAMIC-FUNC("assignColumnLabel":U IN p_hSMO,
                  tField.FieldName,
                  IF tField.InheritLabel THEN ? ELSE tField.FieldLabel). 
    DYNAMIC-FUNC("assignColumnWidth":U IN p_hSMO,
                  tField.FieldName,
                  IF tField.InheritWidth THEN ? ELSE tField.FieldWidth). 
    DYNAMIC-FUNC("assignColumnTooltip":U IN p_hSMO,
                  tField.FieldName,
                  tField.FieldTooltip).
    DYNAMIC-FUNC("assignColumnHelpId":U IN p_hSMO,
                  tField.FieldName,
                  tField.FieldHelpId).    
    DYNAMIC-FUNC("assignColumnOperatorStyle":U IN p_hSMO,
                  tField.FieldName,
                  tField.FieldStyle).
     
  END. /* for each tfield */
   
  /* The FieldOperatorStyles property stores all overridden style assigned by 
     assignColumnOperatorStyle. Because this dialog only saves CHANGED fields 
     we must access it directly in order to ensure that previously overidden fields
     is blanked if the current OperatorStyle does not allow it. 
     See notes in the header of the procedure. */
  
  cStyleList = DYNAMIC-FUNC("getFieldOperatorStyles":U IN p_hSMO).
 
  /* inline is not overridable */
  IF cOperatorStyle = "INLINE":U THEN 
     cStyleList = "":U.
  
  ELSE DO i = 2 TO NUM-ENTRIES(cStyleList,CHR(1)) BY 2:
     cStyle = ENTRY(i,cStyleList,CHR(1)).
     
     IF cStyle = cOperatorStyle 
     OR cStyle = "EXPLICIT":U AND cOperatorStyle = "IMPLICIT":U THEN
        ENTRY(i,cStyleList,CHR(1)) = "":U.

  END.
  DYNAMIC-FUNC("setFieldOperatorStyles":U IN p_hSMO, cStyleList).

  RUN initializeObject IN p_hSMO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartFilter Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowse Attribute-Dlg
ON CHOOSE OF btnBrowse IN FRAME Attribute-Dlg /* Browse... */
DO: 
  RUN adecomm/_chossdo.w("BROWSE,PREVIEW":U,
                         NO,
                         INPUT-OUTPUT cDataObject).
  
  initSDO(cDataObject).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFields Attribute-Dlg
ON CHOOSE OF btnFields IN FRAME Attribute-Dlg /* Edit Field List... */
DO:
  DEFINE VARIABLE cUpdatable AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataCols  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBrowse    AS HANDLE     NO-UNDO. 
  DEFINE VARIABLE lQuery     AS LOGICAL   NO-UNDO. 

  IF VALID-HANDLE(ghSDO) THEN    
  DO:
    {get UpdatableColumns cUpdatable ghSDO}.
    {get DataColumns cDataCols ghSDO}.
    cField = cFields:SCREEN-VALUE.
    
    RUN adecomm/_mfldsel.p
      (INPUT "":U,     /* Use an SDO, not db tables */
       INPUT ghSDO,     /* handle of the SDO */
       INPUT ?,        /* No additional temp-tables */
       INPUT "1":U,  /*  1 = no table */
       INPUT ",":U,    /* list delimiter */
       INPUT "":U, /* exclude field list */
       INPUT-OUTPUT gcDisplayedFields).
    
    /****  database based query not supported 
    RUN adecomm/_mfldsel.p
      (INPUT DYNAMIC-FUNC('getTables':U IN ghSDO),     /* Use db tables */
       INPUT ?,     /* handle of the SDO */
       INPUT ?,        /* No additional temp-tables */
       INPUT "2" ,  /* 2 = table  1 = no table */
       INPUT ",":U,    /* list delimiter */
       INPUT "":U, /* exclude field list */
       INPUT-OUTPUT gcDisplayedFields).
    ***/

    cFields:LIST-ITEMS   = gcDisplayedFields.
    /* try to reset screen-value */
    cFields:SCREEN-VALUE = cField NO-ERROR. 
    initField(cFields:SCREEN-VALUE).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemove Attribute-Dlg
ON CHOOSE OF btnRemove IN FRAME Attribute-Dlg /* Remove Field */
DO:
  DEF VAR iNum AS INT NO-UNDO.
  iNum = cFields:LOOKUP(cFields:SCREEN-VALUE).
  IF iNum <> ? THEN
  DO:
    cFields:DELETE(iNum).
    cFields:SCREEN-VALUE = cFields:ENTRY(MIN(iNum,cFields:NUM-ITEMS)) NO-ERROR.
    gcDisplayedFields = cFields:LIST-ITEMS. 
  END.
  /* Show the correct field and take care of the buttons status */ 
  initField(cFields:SCREEN-VALUE). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDataObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDataObject Attribute-Dlg
ON LEAVE OF cDataObject IN FRAME Attribute-Dlg /* Target */
DO:
  initSDO(cDataObject:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cFields Attribute-Dlg
ON VALUE-CHANGED OF cFields IN FRAME Attribute-Dlg
DO:
  initField(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cOperatorStyle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cOperatorStyle Attribute-Dlg
ON VALUE-CHANGED OF cOperatorStyle IN FRAME Attribute-Dlg
DO:
  ASSIGN cOperatorStyle.
    
  enableObjects().
  
  IF cOperatorViewAs:SCREEN-VALUE = ? THEN 
     cOperatorViewAs:SCREEN-VALUE = cOperatorViewAs:ENTRY(1).
 
  IF cOperator:SCREEN-VALUE = ? THEN 
     cOperator:SCREEN-VALUE = "=":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dColumn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dColumn Attribute-Dlg
ON VALUE-CHANGED OF dColumn IN FRAME Attribute-Dlg /* Column */
DO:
  ASSIGN iDefaultEditorLines.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dDefaultCharWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dDefaultCharWidth Attribute-Dlg
ON VALUE-CHANGED OF dDefaultCharWidth IN FRAME Attribute-Dlg /* Width of Character Fields */
DO:
  ASSIGN dDefaultCharWidth.
  initFieldWidth().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dDefaultWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dDefaultWidth Attribute-Dlg
ON VALUE-CHANGED OF dDefaultWidth IN FRAME Attribute-Dlg /* Width of Other Fields */
DO:
  ASSIGN dDefaultWidth.
  initFieldWidth().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iDefaultEditorLines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iDefaultEditorLines Attribute-Dlg
ON VALUE-CHANGED OF iDefaultEditorLines IN FRAME Attribute-Dlg /* Number of Lines in Editors */
DO:
  ASSIGN iDefaultEditorLines.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lInheritLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lInheritLabel Attribute-Dlg
ON VALUE-CHANGED OF lInheritLabel IN FRAME Attribute-Dlg /* Filter Target */
DO:
  DEF VAR hFilter AS HANDLE NO-UNDO.
   
  cLabel:READ-ONLY IN FRAME {&FRAME-NAME} = SELF:CHECKED.   
  cLabel:TAB-STOP  IN FRAME {&FRAME-NAME} = NOT SELF:CHECKED.   
  resetFieldTabOrder().
  IF SELF:CHECKED THEN
  DO:     
    hFilter = DYNAMIC-FUNC("columnFilterTarget":U IN p_hSMO,tField.FieldName).
    cLabel  = DYNAMIC-FUNC("columnLabel":U IN hFilter,tField.FieldName).
    cLabel:SCREEN-VALUE = cLabel.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lInheritWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lInheritWidth Attribute-Dlg
ON VALUE-CHANGED OF lInheritWidth IN FRAME Attribute-Dlg /* Default */
DO:
  resetFieldTabOrder().
  initFieldWidth().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartFilter_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  initTheme().
  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  initField('').
  /* Enable the interface. */         
  RUN enable_UI.  
               
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 /*  def var icont as int.
 *   run adeuib/_uib_crt.p(?,?,"SmartObject:dord.w",12,84,?,?, output icont ).*/
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY lView cDataObject cFields lInheritLabel lInheritWidth cOperatorStyle 
          cOperator lUseBegins lUseContains cOperatorViewAs dDefaultCharWidth 
          dDefaultWidth dColumn iDefaultEditorLines 
      WITH FRAME Attribute-Dlg.
  ENABLE lView cDataObject cFields cLabel dWidth cTooltip iHelpId 
         cOperatorStyle cOperatorViewAs dDefaultCharWidth dDefaultWidth dColumn 
         iDefaultEditorLines RECT-1 RECT-19 RECT-20 RECT-21 RECT-5 RECT-6 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ldummy       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cInfo   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContainerId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumns     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSDO         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lLinked      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iFld         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO.

 DO WITH FRAME {&FRAME-NAME}: 
   ASSIGN
     /* Get the attributes used in this Instance Attribute dialog-box. */
    
     lView               = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO) 
     cOperatorStyle      = DYNAMIC-FUNC("getOperatorStyle":U IN p_hSMO)
     cOperatorViewAs     = DYNAMIC-FUNC("getOperatorViewAs":U IN p_hSMO)
     cOperator:LIST-ITEM-PAIRS = 
                        DYNAMIC-FUNC("getOperatorLongValues":U IN p_hSMO)
     cOperator           = DYNAMIC-FUNC("getOperator":U IN p_hSMO)
     lUseBegins          = DYNAMIC-FUNC("getUseBegins":U IN p_hSMO)
     lUseContains        = DYNAMIC-FUNC("getUseContains":U IN p_hSMO)
     gcDisplayedFields   = DYNAMIC-FUNC("getDisplayedFields":U IN p_hSMO)
     cFields:LIST-ITEMS  = gcDisplayedFields
     dDefaultCharWidth   = DYNAMIC-FUNC("getDefaultCharWidth":U IN p_hSMO)
     dColumn             = DYNAMIC-FUNC("getFieldColumn":U IN p_hSMO)
     dDefaultWidth       = DYNAMIC-FUNC("getDefaultWidth":U IN p_hSMO)
     iDefaultEditorLines = DYNAMIC-FUNC("getDefaultEditorLines":U IN p_hSMO)
   .
    
   enableObjects().   
   initField(cFields:SCREEN-VALUE).
         
   ghSDO = WIDGET-HANDLE(DYNAMIC-FUNC('getFilterTarget' IN p_hSMO)).
    
   IF valid-HANDLE(ghSDO) THEN
   DO:
      /* Check if getFilterTarget has given us a handle of the linked object
         or the DesignDataObject.  */    
      RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), "LINK FILTER-TARGET":U, 
         OUTPUT cInfo).         
      
      /* The link may be a pass-thru which means that the sdo handle   
         is a DesignDataObject */
      IF cInfo <> "":U  THEN
      DO:
        DO i = 1 TO NUM-ENTRIES(cInfo):
          RUN adeuib/_uibinfo (INT(ENTRY(i,cInfo)), ?, "TYPE":U, OUTPUT cInfo).
          lLinked = IF lLinked = FALSE THEN cInfo <> "WINDOW":U ELSE lLinked. 
        END.
      END.

      ASSIGN
        cDataObject= ghSDO:FILE-NAME
        cColumns  = DYNAMIC-FUNCTION("getDataColumns":U IN ghSDO).

      /* The sdo may have changed its contents */ 
      DO iFld = 1 TO NUM-ENTRIES(gcDisplayedFields):
        IF NOT CAN-DO(cColumns, ENTRY(iFld,gcDisplayedFields)) THEN
        DO:
          ENTRY(iFld,gcDisplayedFields) = "":U.
          gcDisplayedFields = TRIM(REPLACE(gcDisplayedFields,",,":U,",":U),",":U).
         END.
      END.
      IF lLinked THEN
        /* Make sure that any previpously used design-time SDO names is blanked
          if the SDO is linked */
        DYNAMIC-FUNC("setDesignDataObject":U IN p_hSMO,"":U).
   END. /* valid ghSdo */    
   ELSE 
      ASSIGN
        glDesignSDO       = TRUE
        gcDisplayedFields = "":U.
    
   ASSIGN
      btnBrowse:SENSITIVE = NOT lLinked
      btnFields:SENSITIVE = VALID-HANDLE(ghSDO)
      cFields:LIST-ITEMS  = gcDisplayedFields
      cDataObject:READ-ONLY = lLinked
      cDataObject:TAB-STOP =  NOT lLinked.

 END. /* DO WITH FRAME... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignField Attribute-Dlg 
FUNCTION assignField RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Assign values in current tfield if anything is changed,
    Notes: If nothing is changed or the field is removed from the list, 
           the tField temp-table record is deleted.  
------------------------------------------------------------------------------*/
  
  IF AVAIL tField THEN 
  DO WITH FRAME {&FRAME-NAME}:
    /* if the field is in the list then... */
    IF CAN-DO(cFields:LIST-ITEMS,tField.FieldName) THEN
    DO:
      /* anything modified? */
      IF cLabel:MODIFIED 
      OR dWidth:MODIFIED
      OR cTooltip:MODIFIED
      OR iHelpId:MODIFIED
      OR lFieldViewAsRange:MODIFIED
      OR lFieldOperator:MODIFIED
      OR lInheritLabel:MODIFIED
      OR lInheritWidth:MODIFIED THEN    
      DO:     
       
        ASSIGN    
          cLabel       
          dWidth       
          cToolTip     
          iHelpid              
          lInheritLabel
          lInheritWidth
          lFieldViewAsRange
          lFieldOperator
          tField.Modified     = TRUE  /* make sure it's not deleted later */
          tField.FieldLabel   = cLabel 
          tField.FieldWidth   = dWidth
          tField.FieldTooltip = cTooltip
          tField.FieldHelpId  = iHelpID
          tField.InheritLabel = lInheritLabel
          tField.InheritWidth = lInheritWidth
          cLabel:MODIFIED = FALSE 
          dWidth:MODIFIED = FALSE
          cTooltip:MODIFIED = FALSE
          iHelpId:MODIFIED = FALSE
          lInheritLabel:MODIFIED = FALSE
          lInheritWidth:MODIFIED = FALSE.
        
        /* Ensure that FieldStyle only get changed when one of the two 
           toggles that are used for it are changed */
        IF lFieldViewAsRange:MODIFIED OR lFieldOperator:MODIFIED THEN
          ASSIGN
            tField.FieldStyle = (IF lFieldViewAsRange:SENSITIVE 
                                 AND lFieldViewAsRAnge 
                                 THEN "RANGE":U
                                 ELSE
                                 IF lFieldOperator:SENSITIVE AND lFieldOperator
                                 THEN "EXPLICIT":U
                                 ELSE "":U) 
            lFieldViewAsRange:MODIFIED = FALSE
            lFieldOperator:MODIFIED = FALSE.
           
        RETURN TRUE. 
      END. /* something modified */
      ELSE IF tField.Modified = FALSE THEN 
        DELETE tField. /* Delete if no changes */
    END. /* can-do( cfields:list-items,fieldname) */
    ELSE DELETE tField. /* delete if removed from list */
  END. /* do with frame */
  RETURN FALSE. /* We return false when nothing exists. (just a habit) */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableObjects Attribute-Dlg 
FUNCTION enableObjects RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cOperatorViewAs:SENSITIVE = CAN-DO("Range,Explicit":U,cOperatorStyle)
      cOperator:SENSITIVE       = cOperatorStyle = "Implicit":U
      lUseBegins:SENSITIVE      = CAN-DO("Implicit,Inline":U,cOperatorStyle)  
      lUseContains:SENSITIVE    = CAN-DO("Implicit,Inline,Range":U,cOperatorStyle)  
    .  
    initFieldStyle(). 
         
  END.
  
  RETURN TRUE.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle Attribute-Dlg 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  IF NOT VALID-HANDLE(ghFuncLib) THEN 
  DO:
      ghFuncLib = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(ghFuncLib):
        IF ghFuncLib:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        ghFuncLib = ghFuncLib:NEXT-SIBLING.
      END.
  END.
  RETURN ghFuncLib.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initField Attribute-Dlg 
FUNCTION initField RETURNS LOGICAL
  (pcName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Display and sensitize the Field Properties part of the dialog    
    Notes: All data are stored in temp-tables while the screen uses variables.
             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataType AS CHAR No-UNDO.
  
  /* Store the previous field */
  assignField().
  
  /* No Field available, blank values and disable */
  IF pcName = "" OR pcName = ? THEN
  DO WITH FRAME {&FRAME-NAME} :
    /* Use old v6 trick to blank decimnals */
    btnRemove:SENSITIVE = FALSE.
    DISPLAY 
        "":U @ dWidth
        "":U @ iHelpId. 
    ASSIGN
      cLabel:SCREEN-VALUE ="":U
      cToolTip:SCREEN-VALUE = "":U
      lInheritLabel:CHECKED = TRUE
      lInheritWidth:CHECKED = TRUE
      lFieldOperator:CHECKED = FALSE
      lFieldViewAsRange:CHECKED = FALSE
      cLabel:READ-ONLY = TRUE
      dWidth:READ-ONLY = TRUE
      cTooltip:READ-ONLY = TRUE 
      iHelpId:READ-ONLY = TRUE
      cLabel:TAB-STOP = FALSE 
      dWidth:TAB-STOP = FALSE
      cTooltip:TAB-STOP = FALSE 
      iHelpId:TAB-STOP = FALSE
      lInheritLabel:SENSITIVE = FALSE
      lInheritWidth:SENSITIVE = FALSE
      lFieldOperator:SENSITIVE = FALSE
      lFieldViewAsRange:SENSITIVE = FALSE.
  END.  
  ELSE 
  DO:
    FIND tField WHERE tField.FieldName = pcName NO-ERROR.
    /* if the temp-table doesn't exist, create it */ 
    btnRemove:SENSITIVE = TRUE.
    IF NOT AVAIL tField THEN 
    DO:
      CREATE tField.
      tField.FieldName  = pcName .
      tField.FieldLabel = DYNAMIC-FUNC("columnLabel":U IN p_hSMO,pcName). 
      tfield.FieldWidth = DYNAMIC-FUNC("columnWidth":U IN p_hSMO,pcName). 
      tField.FieldTooltip = DYNAMIC-FUNC("columnTooltip":U IN p_hSMO,pcName). 
      tField.FieldHelpId  =
                     DYNAMIC-FUNC("columnHelpID":U IN p_hSMO,pcName). 
      tField.InheritLabel = 
               DYNAMIC-FUNC("columnLabelDefault":U IN p_hSMO,pcName). 
      tField.InheritWidth = 
               DYNAMIC-FUNC("columnWidthDefault":U IN p_hSMO,pcName).
      tField.FieldStyle   = 
                     IF DYNAMIC-FUNC("columnStyleDefault":U IN p_hSMO,pcName)
                     THEN "":U
                     ELSE DYNAMIC-FUNC("columnOperatorStyle":U IN p_hSMO,pcName). 
    END. /* if not avail tfield */

    cDataType = DYNAMIC-FUNC("columnDataType":U IN p_hSMO,pcName).  
    
    DO WITH FRAME {&FRAME-NAME}:
      ASSIGN  
        cLabel:MODIFIED = FALSE 
        dWidth:MODIFIED = FALSE
        cTooltip:MODIFIED = FALSE
        iHelpId:MODIFIED = FALSE
        lInheritLabel:CHECKED = tField.InheritLabel
        lInheritWidth:CHECKED = tField.InheritWidth
        lInheritLabel:SENSITIVE = TRUE
        lInheritWidth:SENSITIVE = TRUE
        lFieldViewAsRange:CHECKED = tField.FieldStyle = "RANGE":U
        lFieldOperator:CHECKED = tField.FieldStyle = "EXPLICIT":U
        cLabel:READ-ONLY        = tField.InheritLabel
        cLabel:TAB-STOP         = NOT tField.InheritLabel
        cTooltip:READ-ONLY = FALSE 
        iHelpId:READ-ONLY = FALSE        
        cTooltip:TAB-STOP = TRUE 
        iHelpId:TAB-STOP = TRUE        
        lFieldViewAsRange:SENSITIVE = TRUE.
      
      DISPLAY 
        tField.FieldLabel @ cLabel
        tField.FieldTooltip @ cTooltip
        tField.FieldHelpId @ iHelpID.

      initFieldWidth().

      resetFieldTabOrder().

    END. /* do with frame {&frame-name} */  
    initFieldStyle(). 
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initFieldStyle Attribute-Dlg 
FUNCTION initFieldStyle RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DO WITH FRAME {&FRAME-NAME}:
     ASSIGN
       lFieldViewAsRange:SENSITIVE = cFields:SCREEN-VALUE <> ? 
                                    AND AVAIL tField 
                                    AND CAN-DO("Implicit,Explicit":U,cOperatorStyle) 
       
       lFieldOperator:SENSITIVE    = cFields:SCREEN-VALUE <> ? 
                                    AND AVAIL tField 
                                    AND CAN-DO("Range":U,cOperatorStyle) .
  END.  
  RETURN TRUE.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initFieldWidth Attribute-Dlg 
FUNCTION initFieldWidth RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Display and enable the width of the field correctly.   
    Notes: - The defaults are also maintained in this screen 
             Called from value changed of default width fields and check-box 
             and initField().
           - lInheritWidth must be correctly CHECKED.   
           - tfield.FieldWidth is initialized from the columnWidth property 
             which may return the OLD default. So if the user unchecks the 
             default toggle, the field value will show the OLD default as the
             default BEFORE override. (This is almost a feature, because its
             unlikely that you uncheck this in order to use the new default?)  
------------------------------------------------------------------------------*/
  IF AVAIL tField THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
     lInheritWidth
     dWidth:READ-ONLY = lInheritWidth.
     dWidth:TAB-STOP   = NOT lInheritWidth.
 
    IF lInheritWidth THEN
    DO:
      IF DYNAMIC-FUNC("columnDataType" IN p_hSMO,
                     tField.FieldName) = "CHARACTER":U THEN
        dWidth = dDefaultCharWidth.
      ELSE
        dWidth = dDefaultWidth.
    END.
    ELSE 
      dWidth = tField.FieldWidth.  

    DISPLAY dWidth.
  END. /* avail tField */

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSDO Attribute-Dlg 
FUNCTION initSDO RETURNS LOGICAL
   ( pcNewSDO AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Change or add a new sdo.  
           It will be displayed as cDataObject and the handle will be stored 
           in ghSDO
    Notes: This is only a design time sdo. The SDO must be linked at run-time  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghSDO) OR ghSDO:FILE-NAME <> pcNewSdo THEN
  DO WITH FRAME {&FRAME-NAME}:

    DYNAMIC-FUNC("shutdown-sdo":U IN getFuncLibHandle(),p_hSMO).  
    
    DYNAMIC-FUNC("setDesignDataObject":U IN p_hSMO, pcNewSdo).  
    
    ghSDO = WIDGET-HANDLE(DYNAMIC-FUNC('getFilterTarget' IN p_hSMO)).
    gcDisplayedFields = IF VALID-HANDLE(ghSDO) 
                        THEN DYNAMIC-FUNC("getDataColumns":U IN ghSDO)
                        ELSE "":U.
    cFields:LIST-ITEMS = gcDisplayedFields.        
    btnFields:SENSITIVE= VALID-HANDLE(ghSDO).
    btnRemove:SENSITIVE= FALSE.
    cDataObject = pcNewSDO.    
    DISPLAY cDataObject.    
  END. /* do with frame */
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initTheme Attribute-Dlg 
FUNCTION initTheme RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  hWidget = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.
  IF SESSION:WINDOW-SYSTEM = 'MS-WINXP':U THEN
  DO WHILE VALID-HANDLE(hWidget):
    IF hWidget:TYPE = "RECTANGLE":U AND hWidget:EDGE-PIXELS = 2 THEN
      ASSIGN 
        hWidget:GROUP-BOX = TRUE
        hWidget:EDGE-PIXELS = 1.
    hWidget = hWidget:NEXT-SIBLING.
  END.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetFieldTabOrder Attribute-Dlg 
FUNCTION resetFieldTabOrder RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
 ------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
   IF cLabel:TAB-STOP THEN
      cLabel:MOVE-AFTER(btnRemove:HANDLE).
   IF dWidth:TAB-STOP THEN
     dWidth:MOVE-AFTER(lInheritLabel:HANDLE).
      
   cToolTip:MOVE-AFTER(lInheritWidth:HANDLE).
   iHelpId:MOVE-AFTER(cToolTip:HANDLE).
 END.
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

