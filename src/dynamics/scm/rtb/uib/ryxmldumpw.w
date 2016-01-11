&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: ryxmldumpw.w

  Description: Dump XML files from repository data and synchronise with
               SCM tool / data  versioning if required.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Anthony D Swindells, MIP

  Created: 02/05/2001

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

{af/sup2/afglobals.i}
{af/sup2/afcheckerr.i &define-only = YES}
{af/sup2/afrun2.i &Define-only = YES}


DEFINE TEMP-TABLE ttObject    NO-UNDO
       FIELD cWorkspace       AS CHARACTER
       FIELD cProductModule   AS CHARACTER
       FIELD cObjectName      AS CHARACTER
       INDEX idxMain          IS PRIMARY UNIQUE
              cObjectName
       INDEX idxFull          IS UNIQUE
              cWorkspace
              cProductModule
              cObjectName
       .

DEFINE TEMP-TABLE ttError     NO-UNDO
       FIELD cObjectName      AS CHARACTER
       FIELD cError           AS CHARACTER
       INDEX idxMain          IS PRIMARY
              cObjectName
              cError
       .

/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wsroot       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-task-num     AS INTEGER      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-propath      AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-userid       AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-access       AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsc_product_module ryc_smartobject

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse ~
gsc_product_module.product_module_code ryc_smartobject.object_filename ~
ryc_smartobject.object_description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse 
&Scoped-define QUERY-STRING-BrBrowse FOR EACH gsc_product_module ~
      WHERE gsc_product_module.product_module_code = (IF coProductModule = "<ALL>":U THEN gsc_product_module.product_module_code ELSE coProductModule) NO-LOCK, ~
      EACH ryc_smartobject WHERE ryc_smartobject.product_module_obj = gsc_product_module.product_module_obj ~
  AND ryc_smartobject.object_filename BEGINS fiObject NO-LOCK ~
    BY gsc_product_module.product_module_code ~
       BY ryc_smartobject.object_filename INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY BrBrowse FOR EACH gsc_product_module ~
      WHERE gsc_product_module.product_module_code = (IF coProductModule = "<ALL>":U THEN gsc_product_module.product_module_code ELSE coProductModule) NO-LOCK, ~
      EACH ryc_smartobject WHERE ryc_smartobject.product_module_obj = gsc_product_module.product_module_obj ~
  AND ryc_smartobject.object_filename BEGINS fiObject NO-LOCK ~
    BY gsc_product_module.product_module_code ~
       BY ryc_smartobject.object_filename INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse gsc_product_module ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse gsc_product_module
&Scoped-define SECOND-TABLE-IN-QUERY-BrBrowse ryc_smartobject


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BrBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule fiObject buRefresh BrBrowse ~
buAllSelect buAllDeselect buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS coWorkspace coProductModule fiObject ~
toDumpXML ToCheckOut ToIgnoreSCM 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAllDeselect DEFAULT 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buAllSelect DEFAULT 
     LABEL "Select &All" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK DEFAULT 
     LABEL "&Process Selected Objects" 
     SIZE 31.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buRefresh 
     LABEL "Refres&h" 
     SIZE 15 BY 1.14 TOOLTIP "Refresh list of objects"
     BGCOLOR 8 .

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 60 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE coWorkspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Workspace" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 60 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fiObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 TOOLTIP "Specify part of object name or leave blank for all" NO-UNDO.

DEFINE VARIABLE ToCheckOut AS LOGICAL INITIAL yes 
     LABEL "Create/ Check Out Objects in SCM Tool" 
     VIEW-AS TOGGLE-BOX
     SIZE 43.2 BY .81 TOOLTIP "Check out any objects not already checked out in current task" NO-UNDO.

DEFINE VARIABLE toDumpXML AS LOGICAL INITIAL yes 
     LABEL "Dump XML .ado files" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 TOOLTIP "Re-create .ado xml files for selected objects for current repository data" NO-UNDO.

DEFINE VARIABLE ToIgnoreSCM AS LOGICAL INITIAL no 
     LABEL "Ignore SCM Checks" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.4 BY .81 TOOLTIP "Disable all SCM checking" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      gsc_product_module, 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _STRUCTURED
  QUERY BrBrowse NO-LOCK DISPLAY
      gsc_product_module.product_module_code COLUMN-LABEL "Product Module" FORMAT "X(15)":U
      ryc_smartobject.object_filename FORMAT "X(36)":U
      ryc_smartobject.object_description WIDTH 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 97.8 BY 13.33 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coWorkspace AT ROW 1.48 COL 10.8
     coProductModule AT ROW 2.57 COL 6.8
     fiObject AT ROW 3.67 COL 21 COLON-ALIGNED
     buRefresh AT ROW 3.67 COL 85.6
     BrBrowse AT ROW 5 COL 2.8
     buAllSelect AT ROW 18.71 COL 2.8
     buAllDeselect AT ROW 18.71 COL 19
     toDumpXML AT ROW 18.81 COL 39
     ToCheckOut AT ROW 19.71 COL 39
     buOK AT ROW 20.24 COL 2.8
     buCancel AT ROW 20.24 COL 85.6
     ToIgnoreSCM AT ROW 20.57 COL 39
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.8 BY 20.81
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Dump XML Files from Repository Data"
         HEIGHT             = 20.76
         WIDTH              = 100.8
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 141.8
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 141.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BrBrowse buRefresh DEFAULT-FRAME */
/* SETTINGS FOR COMBO-BOX coProductModule IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coWorkspace IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR TOGGLE-BOX ToCheckOut IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX toDumpXML IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToIgnoreSCM IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _TblList          = "icfdb.gsc_product_module,icfdb.ryc_smartobject WHERE icfdb.gsc_product_module ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, FIRST"
     _OrdList          = "icfdb.gsc_product_module.product_module_code|yes,icfdb.ryc_smartobject.object_filename|yes"
     _Where[1]         = "gsc_product_module.product_module_code = (IF coProductModule = ""<ALL>"":U THEN gsc_product_module.product_module_code ELSE coProductModule)"
     _JoinCode[2]      = "ryc_smartobject.product_module_obj = gsc_product_module.product_module_obj
  AND ryc_smartobject.object_filename BEGINS fiObject"
     _FldNameList[1]   > "_<CALC>"
"gsc_product_module.product_module_code" "Product Module" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[2]   > "_<CALC>"
"ryc_smartobject.object_filename" ? "X(36)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > "_<CALC>"
"ryc_smartobject.object_description" ? ? "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Dump XML Files from Repository Data */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Dump XML Files from Repository Data */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllDeselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllDeselect C-Win
ON CHOOSE OF buAllDeselect IN FRAME DEFAULT-FRAME /* Deselect All */
DO:

    RUN rowsAllDeselect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAllSelect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAllSelect C-Win
ON CHOOSE OF buAllSelect IN FRAME DEFAULT-FRAME /* Select All */
DO:

    RUN rowsAllSelect.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Exit */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Process Selected Objects */
DO:

    DEFINE VARIABLE lChoice             AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cMessage            AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN
        coWorkspace
        coProductModule
        fiObject
        toDumpXML
        toCheckOut
        toIgnoreSCM
        lChoice = NO
        .

    IF toCheckOut = YES
    AND grtb-task-num = 0
    THEN DO:
      MESSAGE "You must have a valid open task to create/check-out objects in SCM Tool".
      RETURN NO-APPLY.
    END.

    IF  toDumpXML   = NO
    AND toCheckOut  = NO
    AND toIgnoreSCM = NO
    THEN DO:
      MESSAGE "You have not selected any options to Process".
      RETURN NO-APPLY.
    END.

  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
  THEN DO:
    MESSAGE "No objects were selected to process":U.
    RETURN NO-APPLY.
  END.

  ASSIGN
    cMessage = "You have selected to do the following for the selected objects:"
             + CHR(10) + CHR(10).
  IF toDumpXML THEN
    ASSIGN
      cMessage = cMessage + "Dump XML .ado files for selected objects from current Repository data"
               + CHR(10)  + CHR(10).
  IF toCheckOut THEN
    ASSIGN
      cMessage = cMessage + "Check out objects in SCM tool not already checked out in the current"
               + CHR(10)  + "task, prior to dumping the .ado xml file"
               + CHR(10)  + CHR(10).
  IF toIgnoreSCM THEN
    ASSIGN
      cMessage = cMessage + "Ignore all SCM / version database checks and just dump the XML File"
               + CHR(10)  + CHR(10).
  ASSIGN
    cMessage = cMessage + "Proceed?"
             + CHR(10)  + CHR(10).

  MESSAGE cMessage
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lChoice.
      
  IF lChoice = YES
  THEN
    RUN ProcessObjects.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh C-Win
ON CHOOSE OF buRefresh IN FRAME DEFAULT-FRAME /* Refresh */
DO:
  RUN buildObjectBrw.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule C-Win
ON VALUE-CHANGED OF coProductModule IN FRAME DEFAULT-FRAME /* Product Module */
DO:

    ASSIGN
        coProductModule.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coWorkspace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coWorkspace C-Win
ON VALUE-CHANGED OF coWorkspace IN FRAME DEFAULT-FRAME /* Workspace */
DO:

    ASSIGN
        coWorkSpace.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObject C-Win
ON VALUE-CHANGED OF fiObject IN FRAME DEFAULT-FRAME /* Object */
DO:
  ASSIGN
    fiObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToCheckOut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToCheckOut C-Win
ON VALUE-CHANGED OF ToCheckOut IN FRAME DEFAULT-FRAME /* Create/ Check Out Objects in SCM Tool */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      toCheckOut.
  
      IF toCheckOut THEN
      DO:
        DISABLE toIgnoreSCM.    
        ASSIGN
          toIgnoreSCM = NO
          .
        DISPLAY toIgnoreSCM.        
      END.
      ELSE
      DO:
        ENABLE toIgnoreSCM.    
        ASSIGN
          toIgnoreSCM = NO
          .
        DISPLAY toIgnoreSCM.        
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toDumpXML
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toDumpXML C-Win
ON VALUE-CHANGED OF toDumpXML IN FRAME DEFAULT-FRAME /* Dump XML .ado files */
DO:

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
        toDumpXML.

    IF toDumpXML THEN
    DO:
      ENABLE toCheckOut.
      DISABLE toIgnoreSCM.    
      ASSIGN
        toCheckOut = YES
        toIgnoreSCM = NO
        .
      DISPLAY toCheckOut toIgnoreSCM.        
    END.
    ELSE
    DO:
      DISABLE toCheckOut toIgnoreSCM.    
      ASSIGN
        toCheckOut = NO
        toIgnoreSCM = NO
        .
      DISPLAY toCheckOut toIgnoreSCM.        
    END.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToIgnoreSCM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToIgnoreSCM C-Win
ON VALUE-CHANGED OF ToIgnoreSCM IN FRAME DEFAULT-FRAME /* Ignore SCM Checks */
DO:

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      toIgnoreSCM.
  
      IF toIgnoreSCM THEN
      DO:
        DISABLE toCheckOut.    
        ASSIGN
          toCheckOut = NO
          .
        DISPLAY toCheckOut.        
      END.
      ELSE
      DO:
        ENABLE toCheckOut.    
        ASSIGN
          toCheckOut = NO
          .
        DISPLAY toCheckout.        
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN
    CURRENT-WINDOW                = {&WINDOW-NAME} 
    THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN mainSetup.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoProductModule C-Win 
PROCEDURE buildCoProductModule :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
            coWorkSpace          = grtb-wspace-id
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN 
      coProductModule:LIST-ITEMS = "":U.

    FOR EACH gsc_product_module NO-LOCK
      BY gsc_product_module.product_module_code
      :
      coProductModule:ADD-LAST(LC(gsc_product_module.product_module_code)).
    END.

    coProductModule:ADD-FIRST(LC("<ALL>":U)).

    IF  coProductModule:LIST-ITEMS <> "":U
    AND coProductModule:LIST-ITEMS <> ? 
    THEN
      ASSIGN
        coProductModule:SCREEN-VALUE = ENTRY(1,coProductModule:LIST-ITEMS).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoWorkspace C-Win 
PROCEDURE buildCoWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
            coWorkSpace          = grtb-wspace-id
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN 
      coWorkspace:LIST-ITEMS = "":U.

    FIND FIRST rtb_wspace NO-LOCK
      WHERE rtb_wspace.wspace-id = grtb-wspace-id
      NO-ERROR.
    IF AVAILABLE rtb_wspace
    THEN DO:
      coWorkspace:ADD-FIRST(LC(rtb_wspace.wspace-id)).
    END.
    ELSE DO:
      coWorkspace:ADD-FIRST("NONE":U).
    END.

    IF  coWorkspace:LIST-ITEMS <> "":U
    AND coWorkspace:LIST-ITEMS <> ? 
    THEN
      ASSIGN
        coWorkspace:SCREEN-VALUE = ENTRY(1,coWorkspace:LIST-ITEMS).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectBrw C-Win 
PROCEDURE buildObjectBrw :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  SESSION:SET-WAIT-STATE("general":U).

  DO WITH FRAME {&FRAME-NAME}:
      
    ASSIGN
      coProductModule
      fiObject
      .
    {&OPEN-QUERY-{&BROWSE-NAME}}
    
  END.

  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildObjectTT C-Win 
PROCEDURE buildObjectTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttObject.

  DEFINE VARIABLE iLoopRows   AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iLoopCols   AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    DO iLoopRows = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:

      lBrwReturn = {&BROWSE-NAME}:FETCH-SELECTED-ROW(iLoopRows).

      GET CURRENT {&BROWSE-NAME} NO-LOCK.
      FIND FIRST ttObject EXCLUSIVE-LOCK
        WHERE ttObject.cWorkspace     = coWorkspace
        AND   ttObject.cProductModule = gsc_product_module.product_module_code
        AND   ttObject.cObjectName    = ryc_smartobject.object_filename
        NO-ERROR.
      IF NOT AVAILABLE ttObject
      THEN
        CREATE ttObject.

      ASSIGN
        ttObject.cWorkspace     = coWorkspace
        ttObject.cProductModule = gsc_product_module.product_module_code
        ttObject.cObjectName    = ryc_smartobject.object_filename
        .

    END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY coWorkspace coProductModule fiObject toDumpXML ToCheckOut ToIgnoreSCM 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coProductModule fiObject buRefresh BrBrowse buAllSelect buAllDeselect 
         buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN
      toDumpXML   = YES
      toCheckOut  = YES
      toIgnoreSCM = NO
      .
    DISPLAY
      toDumpXML
      toCheckOut
      toIgnoreSCM
      .
    
    IF CONNECTED("RTB")
    THEN DO:
      ENABLE
        toDumpXML
        toCheckOut
        toIgnoreSCM
        .        
    END.
    ELSE DO:
      ASSIGN
        toCheckOut  = NO
        toIgnoreSCM = YES
        .
      DISPLAY
        toIgnoreSCM
        toCheckOut
        .
    END.

    RUN buildCoWorkspace.
    RUN buildCoProductModule.

    IF grtb-wspace-id = "":U
    THEN
      ENABLE
        coWorkspace.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessObjects C-Win 
PROCEDURE ProcessObjects :
/*------------------------------------------------------------------------------
  Purpose:     Process selected objects
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iErrorLoop                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cErrorLine                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE ghRyXmlPlip                   AS HANDLE       NO-UNDO.

  SESSION:SET-WAIT-STATE("general":U).

  EMPTY TEMP-TABLE ttError.
  EMPTY TEMP-TABLE ttObject.
  RUN buildObjectTT (INPUT-OUTPUT TABLE ttObject).

  IF toDumpXml
  OR toCheckOut
  THEN DO:
    {af/sup2/afrun2.i &PLIP = 'rtb/prc/ryxmlplipp.p'
                      &IProc = ''
                      &OnApp = 'no'
                      &Autokill = NO}
    ASSIGN
      ghRyXmlPlip = hPlip.
  END.

  /* Dump XML .ado files if selected */
  IF toDumpXml
  THEN DO:
    {launch.i &PLIP = 'rtb/prc/ryxmlplipp.p'
              &IProc = 'dumpXMLForObjects'
              &PList = "( INPUT TABLE ttObject, INPUT-OUTPUT TABLE ttError, OUTPUT cError )"
              &OnApp = 'no'
              &Autokill = NO}
  END.

  /* create/checkout SCM objects if selected */
  IF toCheckOut
  AND cError = "":U
  THEN DO:
    {launch.i &PLIP = 'rtb/prc/ryxmlplipp.p'
              &IProc = 'checkOutObjects'
              &PList = "( INPUT TABLE ttObject, INPUT grtb-task-num, INPUT NO, INPUT-OUTPUT TABLE ttError, OUTPUT cError )"
              &OnApp = 'no'
              &Autokill = NO}
  END.

  IF VALID-HANDLE(ghRyXmlPlip)
  THEN
    RUN killPlip IN ghRyXmlPlip.

  SESSION:SET-WAIT-STATE("":U).

  ASSIGN
    iErrorLoop = 0
    cErrorLine = "":U
    .

  IF cError <> "":U
  THEN
    FOR EACH ttError NO-LOCK
      BREAK BY ttError.cObjectName
            BY ttError.cError
      :

      ASSIGN
        iErrorLoop = iErrorLoop + 1
        cErrorLine = cErrorLine + CHR(10) + ttError.cError
        .

      IF iErrorLoop = 20
      OR (LAST-OF(ttError.cObjectName)
      AND LAST-OF(ttError.cError)
         )
      THEN DO:
        RUN showMessages IN gshSessionManager
                        (INPUT cErrorLine,
                         INPUT "ERR":U,
                         INPUT "OK":U,
                         INPUT "OK":U,
                         INPUT "OK":U,
                         INPUT "Process Error",
                         INPUT YES,
                         INPUT ?,
                         OUTPUT cButton).
        ASSIGN
          iErrorLoop = 0
          cErrorLine = "":U
          .
      END.

    END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllDeselect C-Win 
PROCEDURE rowsAllDeselect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    lBrwReturn = {&BROWSE-NAME}:DESELECT-ROWS().

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowsAllSelect C-Win 
PROCEDURE rowsAllSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lBrwReturn  AS LOGICAL      NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    lBrwReturn = {&BROWSE-NAME}:SELECT-ALL().

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

