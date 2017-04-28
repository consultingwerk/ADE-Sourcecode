&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000-2016 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:         adeuib/_tempdbedit.w

  Description:  Editor smartObject for the temp-db maintenance tool. 
                Contains the Slickedit 

  Author:       Don Bulua
  Created    :  05/01/2004

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE glDynamicsIsRunning AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcMode              AS CHARACTER  NO-UNDO INIT "EDIT":U.


/* PopUp Menu Definitions                                                     */
DEFINE SUB-MENU m_Insert 
       MENU-ITEM m_Table_Definition LABEL "Table Definition..."
       MENU-ITEM m_Database_Fields LABEL "Database Fields..."
       MENU-ITEM m_File_Contents LABEL "File Contents..."
       MENU-ITEM m_File_Name    LABEL "File Name..."  .
       
DEFINE SUB-MENU m_Format 
       MENU-ITEM m_Indent_Selection LABEL "Indent Selection"
       MENU-ITEM m_Unindent_Selection LABEL "Unindent Selection"
       MENU-ITEM m_Comment      LABEL "&Comment"      
       MENU-ITEM m_UnComment    LABEL "Unc&omment".

DEFINE MENU Mnu_EdPopup 
       MENU-ITEM m_Check_Syntax LABEL "Check Syntax"  
       SUB-MENU  m_Insert       LABEL "Insert"        
       SUB-MENU  m_Format       LABEL "Format"        
       RULE
       MENU-ITEM m_Cut          LABEL "Cut"           
       MENU-ITEM m_Copy         LABEL "Copy"          
       MENU-ITEM m_Paste        LABEL "Paste"         
       RULE
       MENU-ITEM m_Keyword_Help LABEL "Keyword Help"  .

/* Variables required for pedit include */
DEFINE VARIABLE Ed_Schema_Prefix   AS INTEGER   NO-UNDO.
DEFINE VARIABLE Ed_Schema_Database AS CHARACTER NO-UNDO.
DEFINE VARIABLE Ed_Schema_Table    AS CHARACTER NO-UNDO.
{adecomm/pedit.i}     /*  Edit procedures */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnOpen btnSave RectTop RectBottom fiFile ~
toInclude EdSource btnAdd btnUndo btnSyntax 
&Scoped-Define DISPLAYED-OBJECTS fiFile toInclude EdSource 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditor sObject 
FUNCTION getEditor RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFileLabel sObject 
FUNCTION getFileLabel RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInclude sObject 
FUNCTION getInclude RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAdd 
     IMAGE-UP FILE "adeicon/new.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Add" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "New source file".

DEFINE BUTTON btnOpen 
     IMAGE-UP FILE "adeicon/open.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Open" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "Open existing include file".

DEFINE BUTTON btnSave 
     IMAGE-UP FILE "adeicon/save.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Save" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "Save file and rebuild TEMP-DB table".

DEFINE BUTTON btnSyntax  NO-FOCUS FLAT-BUTTON
     LABEL "Syntax" 
     CONTEXT-HELP-ID 0
     SIZE 9 BY 1.1.

DEFINE BUTTON btnUndo  NO-FOCUS FLAT-BUTTON
     LABEL "Undo" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.1 TOOLTIP "Undo".

DEFINE VARIABLE EdSource AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR LARGE
     SIZE 108 BY 8.1
     FONT 2 NO-UNDO.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(250)":U INITIAL "oe/myTempTable.i" 
     LABEL "File" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE RECTANGLE RectBottom
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY .1.

DEFINE RECTANGLE RectTop
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY .1.

DEFINE VARIABLE toInclude AS LOGICAL INITIAL no 
     LABEL "Use as Include" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnOpen AT ROW 1.24 COL 6
     btnSave AT ROW 1.24 COL 11
     fiFile AT ROW 1.24 COL 37 COLON-ALIGNED
     toInclude AT ROW 1.24 COL 86
     EdSource AT ROW 2.43 COL 1 NO-LABEL
     btnAdd AT ROW 1.24 COL 1
     btnUndo AT ROW 1.24 COL 16
     btnSyntax AT ROW 1.24 COL 21
     RectTop AT ROW 1 COL 1
     RectBottom AT ROW 2.43 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 9.86
         WIDTH              = 108.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       EdSource:AUTO-INDENT IN FRAME F-Main      = TRUE
       EdSource:RETURN-INSERTED IN FRAME F-Main  = TRUE.

ASSIGN 
       fiFile:READ-ONLY IN FRAME F-Main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btnAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAdd sObject
ON CHOOSE OF btnAdd IN FRAME F-Main /* Add */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("NEW-FILE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOpen sObject
ON CHOOSE OF btnOpen IN FRAME F-Main /* Open */
DO:
 RUN EditorAction IN THIS-PROCEDURE ("OPEN-FILE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSave sObject
ON CHOOSE OF btnSave IN FRAME F-Main /* Save */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("SAVE-FILE":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSyntax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSyntax sObject
ON CHOOSE OF btnSyntax IN FRAME F-Main /* Syntax */
DO:
   RUN EditorAction IN THIS-PROCEDURE ("CHECK-SYNTAX":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnUndo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnUndo sObject
ON CHOOSE OF btnUndo IN FRAME F-Main /* Undo */
DO:
  IF EdSource:EDIT-CAN-UNDO THEN
     RUN EditorAction IN this-procedure ("UNDO":U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toInclude
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toInclude sObject
ON VALUE-CHANGED OF toInclude IN FRAME F-Main /* Use as Include */
DO:
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  
   {get ContainerSource hContainer}.
   IF VALID-HANDLE(hContainer) THEN
     {set Include SELF:CHECKED hContainer}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */
 
 /* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

ON MENU-DROP OF MENU mnu_EdPopup
DO:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN":u &THEN
  RUN EdPopupDrop IN THIS-PROCEDURE.
  &ELSE
  RETURN NO-APPLY.
  &ENDIF
END.

 /*  INSERT >> PopUp Menu Actions */
ON CHOOSE OF MENU-ITEM m_Table_Definition /* Table definition... */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("INSERT-TABLE":U).
END.

ON CHOOSE OF MENU-ITEM m_DataBase_Fields /* Database Fields... */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("INSERT-FIELDS":U).
END.

ON CHOOSE OF MENU-ITEM m_File_Contents /* File Contents... */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("INSERT-FILE-CONTENTS":U).
END.

ON CHOOSE OF MENU-ITEM m_File_Name /* File Name... */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("INSERT-FILE-NAME":U).
END.


/* FORMAT >> Popup Menu Actions  */
ON CHOOSE OF MENU-ITEM m_Indent_Selection /* Indent */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("INDENT-SELECTION":U).
END.

ON CHOOSE OF MENU-ITEM m_Unindent_Selection /* UnIndent */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("UNINDENT-SELECTION":U).
END.

ON CHOOSE OF MENU-ITEM m_Comment /* Comment. */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("COMMENT-SELECTION":U).
END.

ON CHOOSE OF MENU-ITEM m_UnComment /* Uncomment */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("UNCOMMENT-SELECTION":U).
END.

/* Other Popup menu options */
ON CHOOSE OF MENU-ITEM m_Check_Syntax /* Check Syntax */
DO:
   RUN EditorAction IN THIS-PROCEDURE ("CHECK-SYNTAX":U).
END.

ON CHOOSE OF MENU-ITEM m_Cut /* Cut */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("CUT":U).
END.

ON CHOOSE OF MENU-ITEM m_Copy /* Copy */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("COPY":U).
END.

ON CHOOSE OF MENU-ITEM m_Paste /* Paste */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("PASTE":U).
END.

ON CHOOSE OF MENU-ITEM m_Keyword_Help /* Help */
DO:
  RUN EditorAction IN THIS-PROCEDURE ("HELP-KEYWORD":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearEditor sObject 
PROCEDURE clearEditor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Clear the Editor and get the full path */
 ASSIGN EdSource:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""  
        fiFile:SCREEN-VALUE   = ""
        toInclude:CHECKED     = NO
        EdSource:EDIT-CAN-UNDO = FALSE 
        EdSOurce:SENSITIVE     = FALSE
        EdSource:MODIFIED      = FALSE.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditorAction sObject 
PROCEDURE EditorAction :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles any of the actions needed by the editor
               such as launching search windows, compiles or general editing
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcAction AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lOk         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hWindow     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
  
  {get ContainerSource hContainer}.
    
  CASE pcAction:

    WHEN "BACK_TAB":U THEN
      RUN Apply_BackTab IN THIS-PROCEDURE (EdSource:HANDLE IN FRAME {&FRAME-NAME}, OUTPUT lOK).

    WHEN "CHECK-SYNTAX":U THEN                 /* disp message */
      RUN CheckSyntax IN hContainer (EdSource:HANDLE, "", YES, OUTPUT lOK).

    WHEN "COMMENT-SELECTION":U THEN
      RUN Comment_Selection IN THIS-PROCEDURE (INPUT Edsource:HANDLE , TRUE,OUTPUT lOK).
  
    WHEN "UNCOMMENT-SELECTION":U THEN
      RUN Comment_Selection IN THIS-PROCEDURE (INPUT EdSource:HANDLE, FALSE,OUTPUT lOK).    

    WHEN "COPY":U THEN
      RUN EditCopy IN THIS-PROCEDURE  (INPUT EdSource:HANDLE).
    
    WHEN "CUT":U THEN
      RUN EditCut  IN THIS-PROCEDURE (INPUT EdSource:HANDLE).

    WHEN "DESELECT":U THEN
      RUN DeselectText IN THIS-PROCEDURE (INPUT EdSource:HANDLE).

    WHEN "EDITING-OPTIONS":U THEN
      RUN EditingOptions IN THIS-PROCEDURE (INPUT EdSource:HANDLE).

    WHEN "END-ERROR":U THEN
      RETURN ERROR.

    WHEN "HELP-KEYWORD":U THEN
      RUN adecomm/_kwhelp.p (EdSource:HANDLE, INPUT "comm":U, 0). 

    WHEN "INSERT-FIELDS":U THEN
      RUN InsertDBFields IN hContainer (INPUT EdSource:HANDLE).
    
    WHEN "INSERT-FILE-CONTENTS":U THEN
      RUN Insert_file IN hContainer ("CONTENTS":U,EdSource:HANDLE).

    WHEN "INSERT-FILE-NAME":U THEN
      RUN Insert_file IN hContainer ("NAME":U,EdSource:HANDLE).
  
    WHEN "INSERT-TABLE":U  THEN
      RUN InsertDBTableDef IN hContainer (INPUT EdSource:HANDLE).

    WHEN "INDENT-SELECTION":U THEN
      RUN ApplyTab IN THIS-PROCEDURE (INPUT EdSource:HANDLE, TRUE).

    WHEN "NEW-FILE":U THEN
      RUN NewFile IN THIS-PROCEDURE.

    WHEN "OPEN-FILE":U THEN 
      RUN InsertNewFile IN hCOntainer (INPUT EdSource:HANDLE).

    WHEN "PASTE":U THEN
      RUN EditPaste IN THIS-PROCEDURE (INPUT EdSource:HANDLE).

    WHEN "PRINT-FILE":U THEN
      RUN PrintFile IN THIS-PROCEDURE.
        
    WHEN "SAVE-FILE":U THEN
      RUN SaveProcess IN hContainer.

    WHEN "TAB":U THEN
      RUN Apply_Tab IN THIS-PROCEDURE (EdSource:HANDLE, OUTPUT lOK).

    WHEN "UNDO":U THEN
      RUN EditUndo IN THIS-PROCEDURE (INPUT EdSource:HANDLE).

    WHEN "UNDO_ALL":U THEN
    DO:
      EdSource:MODIFIED = FALSE.
      RUN loadFile IN THIS-PROCEDURE(fiFile:SCREEN-VALUE,"",toInclude:CHECKED).
    END.
   
    WHEN "UNINDENT-SELECTION":U THEN
      RUN ApplyBackTab IN THIS-PROCEDURE (INPUT EdSource:HANDLE, TRUE).

    OTHERWISE DO:
      MESSAGE "Assertion Failure: Unknown editor action - " pcAction
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
  
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EdPopupDrop sObject 
PROCEDURE EdPopupDrop :
/*------------------------------------------------------------------------------
  Purpose:     On the MENU-DROP event for the Editor Popup Menu,
               set the enable/disable state of the Edit Menu selections.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR Read_Only        AS LOGICAL NO-UNDO.
    DEFINE VAR Text_Is_Selected AS LOGICAL NO-UNDO.

    ASSIGN
        Read_Only        = EdSource:READ-ONLY IN FRAME {&FRAME-NAME}
        Text_Is_Selected = EdSource:TEXT-SELECTED
       
        SUB-MENU  m_Insert:SENSITIVE = (NOT Read_Only)

        SUB-MENU  m_Format:SENSITIVE = /* TRUE IF... */
                        ( NOT Read_Only ) AND ( Text_Is_Selected )
        
        /* You can always do a cut in the source editor. It will cut
        ** the selection if text is selected. Otherwise it cuts the
        ** line the cursor is on.
        */
        MENU-ITEM m_Cut:SENSITIVE IN MENU mnu_EdPopup  = /* TRUE IF... */
                        IF EdSource:SOURCE-EDITOR THEN
                            ( NOT Read_Only )
                        ELSE
                            ( NOT Read_Only ) AND ( Text_Is_Selected )

        /* You can always do a copy in the source editor. It will copy
        ** the selection if text is selected. Otherwise it copies the
        ** line the cursor is on.
        */
        MENU-ITEM m_Copy:SENSITIVE IN MENU mnu_EdPopup = /* TRUE IF...*/
                        IF EdSource:SOURCE-EDITOR THEN
                            TRUE
                        ELSE
                            ( Text_Is_Selected  )
                            
        MENU-ITEM m_Paste:SENSITIVE IN MENU mnu_EdPopup = /* TRUE IF... */
                        ( EdSource:EDIT-CAN-PASTE ) AND ( NOT Read_Only )
        
        MENU-ITEM m_Check_Syntax:SENSITIVE IN MENU mnu_EdPopup = /* TRUE IF...*/
                        ( NOT Read_Only )
      . 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h_menu     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.
  
  /* Attach to edit control adecomm/peditor.i */
  edSource:POPUP-MENU IN FRAME {&FRAME-NAME} = ?.
  RUN SetEditor (INPUT edSource:HANDLE IN FRAME {&FRAME-NAME}).

  {get ContainerSource hContainer}.
  
  /* Subscribe to events for maintaining states */
  SUBSCRIBE TO "setMode":U IN THIS-PROCEDURE NO-ERROR.
  SUBSCRIBE TO "setMode":U IN hContainer NO-ERROR.
  SUBSCRIBE TO "stateChanged":U IN THIS-PROCEDURE NO-ERROR.
  SUBSCRIBE TO "stateChanged":U IN hContainer NO-ERROR.

  /* Determine whether Dynamics is running */
  ASSIGN glDynamicsIsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF glDynamicsIsRunning = ? THEN glDynamicsIsRunning = NO.

  /* Set images */
  btnUndo:LOAD-IMAGE("adeicon/bitlib.bmp",17,102,16,16) IN FRAME {&FRAME-NAME}.
  
  RUN SUPER.
  /* Set the popup Menu */
  ASSIGN edSource:POPUP-MENU    = MENU Mnu_EdPopup:HANDLE.
         EdSource:MODIFIED      = FALSE.
         EdSource:EDIT-CAN-UNDO = FALSE.    /* Clear Undo state. */

   /* Set the advanced/color editor dialog box help file name. */
   RUN SetEdHelpFile.            /* adecomm/peditor.i */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadFile sObject 
PROCEDURE loadFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the include file contents into the editor
  Parameters:  <none>
  Notes:       
----------------------------------- -------------------------------------------*/
 DEFINE INPUT  PARAMETER pcInclude    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcStatus     AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER plUseInclude AS LOGICAL    NO-UNDO.

 DEFINE VARIABLE hCOntainer AS HANDLE     NO-UNDO.

 {get ContainerSource hContainer}.

 RUN CheckModified IN hContainer (EdSource:HANDLE IN FRAME {&FRAME-NAME}).
 IF RETURN-VALUE BEGINS "CANCEL":U THEN
     RETURN RETURN-VALUE.
 
 /* Clear the Editor and get the full path */
 ASSIGN EdSource:SCREEN-VALUE = ""  
        FILE-INFO:FILE-NAME   = pcInclude
        fiFile:SCREEN-VALUE   = IF FILE-INFO:FULL-PATHNAME = ? 
                                THEN pcInclude
                                ELSE FILE-INFO:FULL-PATHNAME
        toInclude:CHECKED     = IF plUseInclude = ? 
                                THEN FALSE ELSE plUseInclude.
 
 EdSource:INSERT-FILE(pcInclude) .  /* Load file into editor */
 /* Set Line toggle as it resets. */
 
 /* Clear the undo state so that the insert of the file isn't cleared on undo. */
 ASSIGN EdSource:EDIT-CAN-UNDO = FALSE 
        EdSource:MODIFIED      = FALSE
        EdSOurce:CURSOR-LINE   = 1.
        
/* If file isn't found, make editor read-only and set button state accordingly */
IF INDEX(pcStatus,"F":U) > 0  
OR INDEX(pcStatus,"C":U) > 0
THEN ASSIGN toInclude:SENSITIVE  = FALSE
            EdSource:SENSITIVE   = FALSE
            btnAdd:SENSITIVE     = TRUE
            btnOpen:SENSITIVE    = TRUE
            btnSave:SENSITIVE    = FALSE
            btnUndo:SENSITIVE    = FALSE
            btnSyntax:SENSITIVE  = FALSE
            fiFile:SENSITIVE     = FALSE
            fiFile:FGCOLOR       = 7
            fiFile:SIDE-LABEL-HANDLE:FGCOLOR = 7
            EdSource:BGCOLOR     = 7
            .
ELSE ASSIGN toInclude:SENSITIVE  = TRUE
            EdSource:SENSITIVE   = TRUE
            btnAdd:SENSITIVE     = TRUE
            btnOpen:SENSITIVE    = TRUE
            btnSave:SENSITIVE    = TRUE
            btnUndo:SENSITIVE    = TRUE
            btnSyntax:SENSITIVE  = TRUE
            fiFile:SENSITIVE     = TRUE
            fiFile:FGCOLOR       = ?
            fiFile:SIDE-LABEL-HANDLE:FGCOLOR = ?
            EdSource:BGCOLOR     = ?.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewFile sObject 
PROCEDURE NewFile :
/*------------------------------------------------------------------------------
  Purpose:     Clears the editor and allows for adding a new table
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainer AS HANDLE     NO-UNDO.

{get ContainerSource hContainer}.

/* Check whether file was modified */
 RUN CheckModified IN hContainer (INPUT EdSource:HANDLE IN FRAME {&FRAME-NAME}).
 IF RETURN-VALUE BEGINS "CANCEL":U THEN
     RETURN RETURN-VALUE.             
 
 ASSIGN gcMode   = "Add":U.

 PUBLISH "setMode":U (gcMode).
 PUBLISH "stateChanged":U .
 
 APPLY "ENTRY":U TO EdSource.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of a SmartDataViewer.
  Parameters:  pdHeight AS DECIMAL -- The desired height (in rows)
               pdWidth  AS DECIMAL -- The desired width (in columns)
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL NO-UNDO.

  DEFINE VARIABLE cUIB   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

  {get UIBMode cUIB}.
  IF cUIB BEGINS "Design":U THEN RETURN.

  ASSIGN hFrame                = FRAME {&FRAME-NAME}:HANDLE
         hFrame:SCROLLABLE     = TRUE
         hFrame:WIDTH          = MAX(60,pdWidth - 2)
         hFrame:HEIGHT         = MAX(5,pdHeight - 2)
         hFrame:VIRTUAL-WIDTH  = hFrame:WIDTH
         hFrame:VIRTUAL-HEIGHT = hFrame:HEIGHT
         fiFile:WIDTH          = MAX(1,pdWidth - hFrame:COL - fiFile:COL - toInclude:WIDTH - 3)
         toInclude:COL         = fiFile:COL + fiFile:WIDTH + 1
         RectTop:WIDTH         = MAX(5,pdWidth - RectTop:COL - hFrame:COL + 2)
         Rectbottom:WIDTH      = RectTop:WIDTH
         EdSource:WIDTH        = MAX(10,pdWidth - hFrame:COL + 1)
         EdSource:HEIGHT       = MAX(3,pdHeight - EdSOurce:ROW - 1)
         hFrame:SCROLLABLE     = FALSE
         NO-ERROR.
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMode sObject 
PROCEDURE setMode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcMode AS CHARACTER  NO-UNDO.

ASSIGN gcMode = pcMode.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stateChanged sObject 
PROCEDURE stateChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cValue   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lInclude AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.

 IF gcMode = "ADD":U THEN
 DO:
   GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBUseInclude":U VALUE cValue.
   lInclude = IF cValue EQ ? THEN TRUE
              ELSE CAN-DO ("true,yes,on",cValue).
   ASSIGN btnAdd:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
          Edsource:SCREEN-VALUE  = ""
          EdSource:SENSITIVE     = TRUE
          EdSource:EDIT-CAN-UNDO = FALSE 
          Edsource:MODIFIED      = FALSE
          FiFile:SCREEN-VALUE    = ""
          btnSave:SENSITIVE      = TRUE
          btnUndo:SENSITIVE      = TRUE
          btnSyntax:SENSITIVE    = TRUE
          toInclude:CHECKED      = lInclude
          toInclude:SENSITIVE    = TRUE
          fiFile:SENSITIVE       = TRUE
          fiFile:FGCOLOR         = ?
          fiFile:SIDE-LABEL-HANDLE:FGCOLOR = ?
          EdSource:BGCOLOR       = ?.
   
   {get ContainerSource hContainer}.
   IF VALID-HANDLE(hContainer) THEN
     {set Include lInclude hContainer}.
 END.
ELSE
  ASSIGN btnAdd:SENSITIVE  = TRUE
         btnOpen:SENSITIVE = TRUE
         btnOpen:SENSITIVE = TRUE.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditor sObject 
FUNCTION getEditor RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the editor
    Notes:  
------------------------------------------------------------------------------*/

  RETURN EdSource:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFileLabel sObject 
FUNCTION getFileLabel RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN fiFile:HANDLE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInclude sObject 
FUNCTION getInclude RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN toInclude:CHECKED IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

