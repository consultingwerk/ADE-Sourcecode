&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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

  Description: Dialog for getting settable properties for a SmartFolder.

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
DEFINE VARIABLE cTabType   AS CHARACTER NO-UNDO.
DEFINE VARIABLE sts        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ifont      AS INT       NO-UNDO.
DEFINE VARIABLE cFormat    AS CHAR      NO-UNDO.
DEFINE IMAGE    testHeight FILE "adeicon/righttab".  
 
DEFINE TEMP-TABLE tab-label NO-UNDO
       FIELD      tab-number AS INTEGER  FORMAT ">9":U
       FIELD      tab-value  AS CHARACTER FORMAT "X(255)":U
       INDEX      tab-number tab-number.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SmartFolder-Dlg
&Scoped-define BROWSE-NAME Tab-Browse-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tab-label

/* Definitions for BROWSE Tab-Browse-1                                  */
&Scoped-define FIELDS-IN-QUERY-Tab-Browse-1 tab-label.tab-number tab-label.tab-value   
&Scoped-define ENABLED-FIELDS-IN-QUERY-Tab-Browse-1 tab-label.tab-value   
&Scoped-define ENABLED-TABLES-IN-QUERY-Tab-Browse-1 tab-label
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Tab-Browse-1 tab-label
&Scoped-define SELF-NAME Tab-Browse-1
&Scoped-define OPEN-QUERY-Tab-Browse-1 OPEN QUERY Tab-Browse-1 FOR EACH tab-label NO-LOCK     BY tab-label.tab-number.
&Scoped-define TABLES-IN-QUERY-Tab-Browse-1 tab-label
&Scoped-define FIRST-TABLE-IN-QUERY-Tab-Browse-1 tab-label


/* Definitions for DIALOG-BOX SmartFolder-Dlg                           */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-Add Btn-Remove bFont lFixedWidth dWidth ~
RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS lFixedWidth dWidth 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initWidth SmartFolder-Dlg 
FUNCTION initWidth RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bFont 
     LABEL "&Font" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn-Add 
     LABEL "&Insert" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn-Remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE dWidth AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "Width" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 8.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 1.81.

DEFINE VARIABLE lFixedWidth AS LOGICAL INITIAL no 
     LABEL "Use Fixed Tabs" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Tab-Browse-1 FOR 
      tab-label SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Tab-Browse-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Tab-Browse-1 SmartFolder-Dlg _FREEFORM
  QUERY Tab-Browse-1 NO-LOCK DISPLAY
      tab-label.tab-number COLUMN-LABEL "tab#"
      tab-label.tab-value  COLUMN-LABEL "Label" WIDTH 40
     ENABLE
      tab-label.tab-value
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 7.33 ROW-HEIGHT-CHARS .52.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SmartFolder-Dlg
     Btn-Add AT ROW 2.19 COL 57
     Tab-Browse-1 AT ROW 2.24 COL 5
     Btn-Remove AT ROW 3.57 COL 57
     bFont AT ROW 8.43 COL 57
     lFixedWidth AT ROW 10.29 COL 5
     dWidth AT ROW 11.14 COL 13.2 COLON-ALIGNED
     RECT-1 AT ROW 1.62 COL 3
     RECT-2 AT ROW 10.67 COL 3
     "Tab Labels" VIEW-AS TEXT
          SIZE 11.6 BY .81 AT ROW 1.24 COL 5.4
     "Tab Labels" VIEW-AS TEXT
          SIZE 11.6 BY .81 AT ROW 1.24 COL 5.4
     "Tab Labels" VIEW-AS TEXT
          SIZE 11.6 BY .81 AT ROW 1.24 COL 5
     SPACE(57.40) SKIP(10.51)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartFolder Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX SmartFolder-Dlg
                                                                        */
/* BROWSE-TAB Tab-Browse-1 Btn-Add SmartFolder-Dlg */
ASSIGN 
       FRAME SmartFolder-Dlg:SCROLLABLE       = FALSE.

/* SETTINGS FOR BROWSE Tab-Browse-1 IN FRAME SmartFolder-Dlg
   NO-ENABLE                                                            */
ASSIGN 
       Tab-Browse-1:HIDDEN  IN FRAME SmartFolder-Dlg                = TRUE.

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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME SmartFolder-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SmartFolder-Dlg SmartFolder-Dlg
ON GO OF FRAME SmartFolder-Dlg /* SmartFolder Properties */
DO:   /* Save the last tab entered, if any */
  GET LAST Tab-Browse-1.
  REPOSITION Tab-Browse-1 TO ROWID ROWID(tab-label).
  APPLY "U1" TO Tab-Browse-1. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bFont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bFont SmartFolder-Dlg
ON CHOOSE OF bFont IN FRAME SmartFolder-Dlg /* Font */
DO:
  DEFINE VARIABLE lOk          AS LOG  NO-UNDO.
  DEFINE VARIABLE ifont        AS INT  NO-UNDO.
  DEFINE frame test testheight.

  ifont = bFont:FONT.
  RUN adecomm/_chsfont.p( INPUT 'Choose Folder Font',
                          INPUT ?, /* unknown is ok to disp default for button */
                          INPUT-OUTPUT iFont,
                          OUTPUT lOK).
    /* the folder adds 8 pixlels to the labelheigh to calculate height 
       and the image we test is 1 shorter than the actrual height */

  IF FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(ifont) + 8 > 
     testHeight:HEIGHT-PIXELS + 1 THEN
  DO:
    MESSAGE 
       "The selected font has a height of" 
        FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(ifont) "pixels." 
        SKIP 
       "The maximum supported height is" testHeight:HEIGHT-PIXELS - 7 "pixels." 
        SKIP
       "Please select another font."
        VIEW-AS ALERT-BOX INFORMATION.
  END.
  ELSE IF lOK THEN
    bFont:FONT = iFont.
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
  IF NUM-RESULTS("Tab-Browse-1") = 1 THEN
  DO:
      tab-label.tab-value:SCREEN-VALUE IN BROWSE Tab-Browse-1 = "":U.   
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
    {&OPEN-QUERY-Tab-Browse-1}
  END.
  APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lFixedWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lFixedWidth SmartFolder-Dlg
ON VALUE-CHANGED OF lFixedWidth IN FRAME SmartFolder-Dlg /* Use Fixed Tabs */
DO:
  ASSIGN lFixedwidth.
  initWidth().
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
  IF LOOKUP (LAST-EVENT:LABEL, "CURSOR-UP,CURSOR-DOWN,TAB":U) NE 0 THEN
    APPLY "U1" TO Tab-Browse-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tab-Browse-1 SmartFolder-Dlg
ON U1 OF Tab-Browse-1 IN FRAME SmartFolder-Dlg
DO:
  ASSIGN tab-label.tab-value = tab-label.tab-value:SCREEN-VALUE IN BROWSE Tab-Browse-1.
  IF LAST-EVENT:LABEL = "CURSOR-UP" THEN
    RUN insert-tab("BEFORE":U).
  ELSE RUN insert-tab("AFTER":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK SmartFolder-Dlg 


/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ? THEN 
  FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartFolder_Attributes_Dlg_Box} }


/* ***************************  Main Block  *************************** */
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Keep newly added entries from being at the top of the viewport. */
sts = Tab-Browse-1:SET-REPOSITIONED-ROW (Tab-Browse-1:DOWN,"ALWAYS":U). 
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  ASSIGN
    cFormat     = dWidth:FORMAT
    F-Labels    = DYNAMIC-FUNCTION("getFolderLabels":U IN p-Parent-Hdl)
    dWidth      = DYNAMIC-FUNCTION("getFolderTabWidth":U IN p-Parent-Hdl)
    iFont       = DYNAMIC-FUNCTION("getFolderFont":U IN p-Parent-Hdl) 
    bFont:FONT  = IF ifont < 0 THEN ? ELSE iFont 
    lFixedWidth = dWidth <> 0 AND dWidth <> ?.
  initWidth().

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
  
  {&OPEN-QUERY-Tab-Browse-1}
  
  GET LAST Tab-Browse-1.
  REPOSITION Tab-Browse-1 TO ROWID ROWID(tab-label).
  ASSIGN Tab-Browse-1:HIDDEN = NO
         Tab-Browse-1:SENSITIVE = YES.    
  
  IF F-Labels = "":U THEN
      Btn-Remove:SENSITIVE IN FRAME {&FRAME-NAME} = no.
      
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U). 
  APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-1.
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
  
  CLOSE QUERY Tab-Browse-1.
  ASSIGN 
    dWidth.
    lFixedWidth.

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
      
  DYNAMIC-FUNCTION("setFolderLabels":U IN p-Parent-hdl,f-Labels).
  DYNAMIC-FUNCTION("setFolderFont":U IN p-Parent-hdl,
                    /* workaround problem with unknown Instance Properties */
                    IF bFont:FONT = ? THEN -1 ELSE bFont:FONT).
  DYNAMIC-FUNCTION("setFolderTabWidth":U IN p-Parent-hdl,
                    IF LFixedWidth THEN dWidth ELSE 0).
  RUN initializeObject IN p-Parent-Hdl.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI SmartFolder-Dlg  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI SmartFolder-Dlg  _DEFAULT-ENABLE
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
  DISPLAY lFixedWidth dWidth 
      WITH FRAME SmartFolder-Dlg.
  ENABLE Btn-Add Btn-Remove bFont lFixedWidth dWidth RECT-1 RECT-2 
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
  IF tab-label.tab-number > 31 THEN    /* 32 is max-labels in folder.w */
    MESSAGE "Maximum of 32 labels allowed in a tab folder."
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

    {&OPEN-QUERY-Tab-Browse-1}
    FIND tab-label WHERE tab-label.tab-number = tab#.
    ASSIGN tab-rowid = ROWID(tab-label).
    Btn-Remove:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
    REPOSITION Tab-Browse-1 TO ROWID tab-rowid.
    APPLY "ENTRY":U TO tab-label.tab-value IN BROWSE Tab-Browse-1.
    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initWidth SmartFolder-Dlg 
FUNCTION initWidth RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Set dwidth sensitivity on or off   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOG    NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      dWidth:READ-ONLY = NOT lFixedWidth
      dWidth:TAB-STOP  = NOT dWidth:READ-ONLY.
    
    IF dWidth:SCREEN-VALUE = '?':U THEN dWidth:SCREEN-VALUE = '0':U. 

    IF NOT dWidth:READ-ONLY THEN
      ASSIGN 
        dWidth:FORMAT = cFormat
        lOk = dWidth:MOVE-AFTER(lFixedWidth:HANDLE).
    
    ELSE IF INT(dWidth:SCREEN-VALUE) = 0 THEN 
      dWidth:FORMAT = "ZZZZ":U.
  END.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

