&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME SmartFolder-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS SmartFolder-Dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: folderd.w 

  Description: Dialog for getting settable attributes for a SmartFolder.

  Input Parameters:
      Handle of calling SmartFolder.

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN  YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-Parent-Hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE attr-list  AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-entry AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE attr-name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cntr       AS INTEGER   NO-UNDO.
DEFINE VARIABLE F-Labels   AS CHARACTER NO-UNDO.
DEFINE VARIABLE sts        AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE tab-label
       FIELD      tab-number AS INTEGER  FORMAT ">9":U
       FIELD      tab-value  AS CHARACTER FORMAT "X(13)":U
       INDEX      tab-number tab-number.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SmartFolder-Dlg
&Scoped-define BROWSE-NAME Tab-Browse-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tab-label

/* Definitions for BROWSE Tab-Browse-1                                  */
&Scoped-define FIELDS-IN-QUERY-Tab-Browse-1 tab-label.tab-number tab-label.tab-value   
&Scoped-define ENABLED-FIELDS-IN-QUERY-Tab-Browse-1 tab-label.tab-value   
&Scoped-define FIELD-PAIRS-IN-QUERY-Tab-Browse-1~
 ~{&FP1}tab-value ~{&FP2}tab-value ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-Tab-Browse-1 tab-label
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Tab-Browse-1 tab-label
&Scoped-define SELF-NAME Tab-Browse-1
&Scoped-define OPEN-QUERY-Tab-Browse-1 OPEN QUERY Tab-Browse-1 FOR EACH tab-label NO-LOCK     BY tab-label.tab-number.
&Scoped-define TABLES-IN-QUERY-Tab-Browse-1 tab-label
&Scoped-define FIRST-TABLE-IN-QUERY-Tab-Browse-1 tab-label


/* Definitions for BROWSE Tab-Browse-2                                  */
&Scoped-define FIELDS-IN-QUERY-Tab-Browse-2 tab-label.tab-number tab-label.tab-value   
&Scoped-define ENABLED-FIELDS-IN-QUERY-Tab-Browse-2 tab-label.tab-value   
&Scoped-define FIELD-PAIRS-IN-QUERY-Tab-Browse-2~
 ~{&FP1}tab-value ~{&FP2}tab-value ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-Tab-Browse-2 tab-label
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Tab-Browse-2 tab-label
&Scoped-define SELF-NAME Tab-Browse-2
&Scoped-define OPEN-QUERY-Tab-Browse-2 OPEN QUERY Tab-Browse-2 FOR EACH tab-label NO-LOCK     BY tab-label.tab-number.
&Scoped-define TABLES-IN-QUERY-Tab-Browse-2 tab-label
&Scoped-define FIRST-TABLE-IN-QUERY-Tab-Browse-2 tab-label


/* Definitions for DIALOG-BOX SmartFolder-Dlg                           */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-Tab-Type Btn-Add Btn-Remove 
&Scoped-Define DISPLAYED-OBJECTS F-Tab-Type 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Add 
     LABEL "&Insert" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn-Remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE F-Tab-Type AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "110 pixels", 1,
"72 pixels", 2
     SIZE 27 BY 1.14 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Tab-Browse-1 FOR 
      tab-label SCROLLING.

DEFINE QUERY Tab-Browse-2 FOR 
      tab-label SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Tab-Browse-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Tab-Browse-1 SmartFolder-Dlg _FREEFORM
  QUERY Tab-Browse-1 NO-LOCK DISPLAY
      tab-label.tab-number COLUMN-LABEL "tab#"
      tab-label.tab-value COLUMN-LABEL "Label"
          WIDTH-PIXELS 92
  ENABLE
      tab-label.tab-value
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 28.8 BY 5.67.

DEFINE BROWSE Tab-Browse-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Tab-Browse-2 SmartFolder-Dlg _FREEFORM
  QUERY Tab-Browse-2 NO-LOCK DISPLAY
      tab-label.tab-number COLUMN-LABEL "tab#" COLUMN-FONT 4
      tab-label.tab-value COLUMN-LABEL "Label" COLUMN-FONT 4
          WIDTH-PIXELS 54
  ENABLE
      tab-label.tab-value
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 24 BY 5.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SmartFolder-Dlg
     F-Tab-Type AT ROW 1.33 COL 18 NO-LABEL
     Btn-Add AT ROW 3.86 COL 38
     Tab-Browse-2 AT ROW 3.95 COL 7
     Tab-Browse-1 AT ROW 3.95 COL 7
     Btn-Remove AT ROW 5.24 COL 38
     "Tab width:" VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 1.33 COL 7
     "Tab Labels:" VIEW-AS TEXT
          SIZE 12 BY .81 AT ROW 2.86 COL 7
     SPACE(34.99) SKIP(6.32)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartFolder Attributes":L.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SmartFolder-Dlg
   Default                                                              */
ASSIGN 
       FRAME SmartFolder-Dlg:SCROLLABLE       = FALSE.

/* SETTINGS FOR BROWSE Tab-Browse-1 IN FRAME SmartFolder-Dlg
   NO-ENABLE                                                            */
ASSIGN 
       Tab-Browse-1:HIDDEN  IN FRAME SmartFolder-Dlg            = TRUE.

/* SETTINGS FOR BROWSE Tab-Browse-2 IN FRAME SmartFolder-Dlg
   NO-ENABLE                                                            */
ASSIGN 
       Tab-Browse-2:HIDDEN  IN FRAME SmartFolder-Dlg            = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX SmartFolder-Dlg
/* Query rebuild information for DIALOG-BOX SmartFolder-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX SmartFolder-Dlg */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Tab-Browse-1
/* Query rebuild information for BROWSE Tab-Browse-1
     _START_FREEFORM
OPEN QUERY Tab-Browse-1 FOR EACH tab-label NO-LOCK
    BY tab-label.tab-number.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE Tab-Browse-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Tab-Browse-2
/* Query rebuild information for BROWSE Tab-Browse-2
     _START_FREEFORM
OPEN QUERY Tab-Browse-2 FOR EACH tab-label NO-LOCK
    BY tab-label.tab-number.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE Tab-Browse-2 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SmartFolder-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SmartFolder-Dlg SmartFolder-Dlg
ON GO OF FRAME SmartFolder-Dlg /* SmartFolder Attributes */
DO:   /* Save the last tab entered, if any */
  IF F-Tab-Type = 1 THEN
      APPLY "CURSOR-DOWN" TO Tab-Browse-1. 
  ELSE
      APPLY "CURSOR-DOWN" TO Tab-Browse-2. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Add SmartFolder-Dlg
ON CHOOSE OF Btn-Add IN FRAME SmartFolder-Dlg /* Insert */
DO:
  ASSIGN tab-label.tab-value = tab-label.tab-value:SCREEN-VALUE IN BROWSE Tab-Browse-1.
  RUN insert-tab("AFTER":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Remove SmartFolder-Dlg
ON CHOOSE OF Btn-Remove IN FRAME SmartFolder-Dlg /* Remove */
DO:
  DEFINE VARIABLE deleted-tab AS INTEGER NO-UNDO.
  /* Don't actually delete the first tab. */
  IF F-Tab-Type = 1 AND NUM-RESULTS("Tab-Browse-1") = 1 THEN
  DO:
      tab-label.tab-value:SCREEN-VALUE IN BROWSE Tab-Browse-1 = "":U.   
      ASSIGN tab-label.tab-value
             Btn-Remove:SENSITIVE = no.
  END.
  ELSE IF F-Tab-Type = 2 AND NUM-RESULTS("Tab-Browse-2") = 1 THEN
  DO:
      tab-label.tab-value:SCREEN-VALUE IN BROWSE Tab-Browse-2 = "":U.   
      ASSIGN tab-label.tab-value
             Btn-Remove:SENSITIVE = no.
  END.
  ELSE 
  DO:
    deleted-tab = tab-label.tab-number.
    DO TRANSACTION:
      FIND CURRENT tab-label EXCLUSIVE-LOCK.
      DELETE tab-label.
      REPEAT PRESELECT EACH tab-label  /* avoid finding same rec twice */
        WHERE tab-label.tab-number > deleted-tab:
           FIND NEXT tab-label.
           tab-label.tab-number = tab-label.tab-number - 1.
      END.
    END.
    IF F-Tab-Type = 1 THEN
         {&OPEN-QUERY-Tab-Browse-1}
    ELSE
         {&OPEN-QUERY-Tab-Browse-2}
  END.
  IF F-Tab-Type = 1 THEN
      APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-1.
  ELSE
      APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Tab-Type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Tab-Type SmartFolder-Dlg
ON VALUE-CHANGED OF F-Tab-Type IN FRAME SmartFolder-Dlg
DO: /* Switch browsers to show the other label width and font */
  ASSIGN F-Tab-Type.
  IF F-Tab-Type = 1 THEN 
  DO:
      {&OPEN-QUERY-Tab-Browse-1}
      ASSIGN Tab-Browse-1:HIDDEN = NO
             Tab-Browse-1:SENSITIVE = YES
             Tab-Browse-2:HIDDEN = YES
             Tab-Browse-2:SENSITIVE = NO.
  END.
  ELSE DO:
      {&OPEN-QUERY-Tab-Browse-2}
      ASSIGN Tab-Browse-2:HIDDEN = NO
             Tab-Browse-2:SENSITIVE = YES
             Tab-Browse-1:HIDDEN = YES
             Tab-Browse-1:SENSITIVE = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Tab-Browse-1
&Scoped-define SELF-NAME Tab-Browse-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-1 SmartFolder-Dlg
ON OFF-END OF Tab-Browse-1 IN FRAME SmartFolder-Dlg
DO:
  IF LAST-EVENT:LABEL = "OFF-END" THEN
         RUN insert-tab ("AFTER":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-1 SmartFolder-Dlg
ON OFF-HOME OF Tab-Browse-1 IN FRAME SmartFolder-Dlg
DO:
  IF LAST-EVENT:LABEL = "OFF-HOME" THEN
         RUN insert-tab ("BEFORE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-1 SmartFolder-Dlg
ON ROW-LEAVE OF Tab-Browse-1 IN FRAME SmartFolder-Dlg
DO:
  DEFINE VARIABLE last-hdl AS HANDLE NO-UNDO.
  last-hdl = LAST-EVENT:WIDGET-ENTER.
  IF LOOKUP (LAST-EVENT:LABEL, "CURSOR-UP,CURSOR-DOWN,ENTER,TAB":U) NE 0
     OR (LAST-EVENT:LABEL = "ROW-LEAVE" AND VALID-HANDLE(last-hdl) AND
         (last-hdl:NAME = "Btn-Add":U OR last-hdl:NAME = "btn_OK":U)) THEN 
  DO:
     IF INDEX (Tab-Label.Tab-Value:SCREEN-VALUE IN BROWSE Tab-Browse-1,
          "|":U) NE 0 OR
        INDEX (Tab-Label.Tab-Value:SCREEN-VALUE IN BROWSE Tab-Browse-1,
          ",":U) NE 0 THEN 
     DO:
          MESSAGE "Invalid character in tab label."
              VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Tab-Browse-2
&Scoped-define SELF-NAME Tab-Browse-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-2 SmartFolder-Dlg
ON OFF-END OF Tab-Browse-2 IN FRAME SmartFolder-Dlg
DO:
  IF LAST-EVENT:LABEL = "OFF-END" THEN
         RUN insert-tab ("AFTER":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-2 SmartFolder-Dlg
ON OFF-HOME OF Tab-Browse-2 IN FRAME SmartFolder-Dlg
DO:
  IF LAST-EVENT:LABEL = "OFF-HOME" THEN
         RUN insert-tab ("BEFORE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-2 SmartFolder-Dlg
ON ROW-LEAVE OF Tab-Browse-2 IN FRAME SmartFolder-Dlg
DO:
  DEFINE VARIABLE last-hdl AS HANDLE NO-UNDO.
  last-hdl = LAST-EVENT:WIDGET-ENTER.
  IF LOOKUP (LAST-EVENT:LABEL, "CURSOR-UP,CURSOR-DOWN,ENTER,TAB":U) NE 0
     OR (LAST-EVENT:LABEL = "ROW-LEAVE" AND VALID-HANDLE(last-hdl) AND
         (last-hdl:NAME = "Btn-Add":U OR last-hdl:NAME = "btn_OK":U)) THEN 
  DO:
     IF INDEX (Tab-Label.Tab-Value:SCREEN-VALUE IN BROWSE Tab-Browse-2,
          "|":U) NE 0 OR
        INDEX (Tab-Label.Tab-Value:SCREEN-VALUE IN BROWSE Tab-Browse-2,
          ",":U) NE 0 THEN 
     DO:
          MESSAGE "Invalid character in tab label."
              VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Tab-Browse-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SmartFolder-Dlg 


/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ adm/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartFolder_Attributes_Dlg_Box} }


/* ***************************  Main Block  *************************** */
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Keep newly added entries from being at the top of the viewport. */
sts = Tab-Browse-1:SET-REPOSITIONED-ROW
    (Tab-Browse-1:DOWN,"ALWAYS":U). 
sts = Tab-Browse-2:SET-REPOSITIONED-ROW
    (Tab-Browse-2:DOWN,"ALWAYS":U).     
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   RUN get-attribute-list IN p-Parent-Hdl (OUTPUT attr-list).     
   DO cntr = 1 TO NUM-ENTRIES(attr-list): 
      attr-entry = ENTRY(cntr, attr-list).
      attr-name = TRIM(SUBSTR(attr-entry, 1, INDEX(attr-entry,"=":U) - 1,
          "CHARACTER":U)).
      attr-value = TRIM(SUBSTR(attr-entry, INDEX(attr-entry,"=":U) + 1, -1,
          "CHARACTER":U)).
      CASE attr-name :
      WHEN "FOLDER-TAB-TYPE":U THEN
          F-Tab-Type = INT(attr-value).
      WHEN "FOLDER-LABELS":U THEN
          F-Labels = attr-value.
      END CASE.
  END.
  
  IF F-Labels = "":U THEN   /* Give browser a starting point if no labels. */
  DO TRANSACTION:
      CREATE tab-label.
      ASSIGN tab-label.tab-number = 1.
      
  END.  
  ELSE DO TRANSACTION cntr = 1 TO NUM-ENTRIES(F-Labels,'|':U):
      CREATE tab-label.
      ASSIGN tab-label.tab-number = cntr
             tab-label.tab-value = ENTRY(cntr, F-Labels, '|':U).
  END.
      
  RUN enable_UI.
  IF F-Tab-Type = 1 THEN 
  DO:     /* 110 pixel labels */
      {&OPEN-QUERY-Tab-Browse-1}
      ASSIGN Tab-Browse-1:HIDDEN = NO
             Tab-Browse-1:SENSITIVE = YES.
  END.
  ELSE DO:  /* 72 pixel labels in smaller font */
      {&OPEN-QUERY-Tab-Browse-2}
      ASSIGN Tab-Browse-2:HIDDEN = NO
             Tab-Browse-2:SENSITIVE = YES.
  END.
  
      
  
  IF F-Labels = "":U THEN
      Btn-Remove:SENSITIVE IN FRAME {&FRAME-NAME} = no.
      
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U). 
  
  IF F-Tab-Type = 1 THEN
      APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-1.
  ELSE
      APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-2. 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
  ASSIGN  F-Tab-Type.
  IF F-Tab-Type = 1 THEN
      CLOSE QUERY Tab-Browse-1.
  ELSE
      CLOSE QUERY Tab-Browse-2.
  F-Labels = "":U.
  FOR EACH tab-label BY tab-number:
      IF tab-label.tab-number NE 1 THEN F-Labels = F-Labels + '|':U.
      F-Labels = F-labels + TRIM(tab-label.tab-value).
  END.
   
  /* If the first item in the list is empty, suppress it. */
  IF SUBSTR(F-Labels,1,1, "CHARACTER":U) = '|':U THEN
      F-Labels = SUBSTR(F-Labels,2, -1, "CHARACTER":U).
         
  /* If the last item(s) in the list is (are) empty, suppress the extra tab(s). */
  DO WHILE LENGTH(F-Labels, "CHARACTER":U) > 0 AND 
    R-INDEX(F-Labels,'|':U) = LENGTH(F-Labels, "CHARACTER":U):
      F-Labels = SUBSTR(F-Labels,1,LENGTH(F-Labels, "CHARACTER":U) - 1, 
        "CHARACTER":U).
  END.
      
  attr-list = "FOLDER-TAB-TYPE = ":U + STRING(F-Tab-Type) + 
              ",FOLDER-LABELS = ":U + F-Labels.
 
  RUN set-attribute-list IN p-Parent-Hdl (INPUT attr-list).
  RUN initialize-folder IN p-Parent-Hdl.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SmartFolder-Dlg _DEFAULT-DISABLE
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
  HIDE FRAME SmartFolder-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SmartFolder-Dlg _DEFAULT-ENABLE
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
  DISPLAY F-Tab-Type 
      WITH FRAME SmartFolder-Dlg.
  ENABLE F-Tab-Type Btn-Add Btn-Remove 
      WITH FRAME SmartFolder-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-SmartFolder-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insert-tab SmartFolder-Dlg 
PROCEDURE insert-tab :
/*------------------------------------------------------------------------------
  Purpose:  Allows insertion of a new folder tab.   
  Parameters:  BEFORE or AFTER
  Notes:    AFTER is used for the Insert button (Btn_Add) and 
            OFF-END and ENTER. BEFORE is used for OFF-HOME (so only
            applies for inserting before the first existing tab).   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER insert-direction AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tab#      AS INTEGER NO-UNDO.
  DEFINE VARIABLE tab-rowid AS ROWID   NO-UNDO.
  
  ASSIGN tab# = IF insert-direction = "BEFORE":U THEN 0
                ELSE tab-label.tab-number.   /* save off the current tab # */
  FIND LAST tab-label.
  IF tab-label.tab-number >= 20 THEN    /* 20 is max-labels in folder.w */
    MESSAGE "Maximum of 20 labels allowed in a tab folder."
        VIEW-AS ALERT-BOX WARNING.
  ELSE DO:
    DO TRANSACTION:
       /* Use PRESELECT to avoid finding the same rec twice. */
      REPEAT PRESELECT EACH tab-label WHERE tab-label.tab-number > tab#:
          FIND NEXT tab-label.  
          ASSIGN tab-label.tab-number = tab-label.tab-number + 1.
      END.
      CREATE tab-label.
      ASSIGN tab-label.tab-number = tab# + 1
                             tab# = tab-label.tab-number.
    END.

    IF F-Tab-Type = 1 THEN
        {&OPEN-QUERY-Tab-Browse-1}
    ELSE
        {&OPEN-QUERY-Tab-Browse-2}
 
    FIND tab-label WHERE tab-label.tab-number = tab#.
    ASSIGN tab-rowid = ROWID(tab-label).
    Btn-Remove:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
    IF F-Tab-Type = 1 THEN 
    DO:
        REPOSITION Tab-Browse-1 TO ROWID tab-rowid.
        APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-1.
    END.
    ELSE DO:
        REPOSITION Tab-Browse-2 TO ROWID tab-rowid.
        APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-2.
    END.
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


