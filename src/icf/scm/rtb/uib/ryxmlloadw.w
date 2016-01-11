&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
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
&Scoped-define INTERNAL-TABLES rtb_object rtb_ver rtb_subtype

/* Definitions for BROWSE BrBrowse                                      */
&Scoped-define FIELDS-IN-QUERY-BrBrowse rtb_object.pmod rtb_object.object ~
rtb_ver.sub-type rtb_ver.description rtb_ver.version rtb_object.obj-group 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrBrowse 
&Scoped-define QUERY-STRING-BrBrowse FOR EACH rtb_object ~
      WHERE rtb_object.pmod = (IF coProductModule = "<ALL>":U THEN rtb_object.pmod ELSE coProductModule) ~
 AND rtb_object.obj-type = "PCODE":U ~
 AND rtb_object.wspace-id = coWorkSpace ~
 AND rtb_object.object BEGINS fiObject NO-LOCK, ~
      FIRST rtb_ver WHERE rtb_ver.obj-type = rtb_object.obj-type ~
  AND rtb_ver.object = rtb_object.object ~
  AND rtb_ver.pmod = rtb_object.pmod ~
  AND rtb_ver.version = rtb_object.version NO-LOCK, ~
      FIRST rtb_subtype WHERE rtb_subtype.sub-type = rtb_ver.sub-type ~
  AND (rtb_subtype.part-ext[1] = "ado" OR rtb_subtype.part-ext[2] = "ado" OR rtb_subtype.part-ext[3] = "ado" OR rtb_subtype.part-ext[4] = "ado" OR rtb_subtype.part-ext[5] = "ado" OR rtb_subtype.part-ext[6] = "ado" OR rtb_subtype.part-ext[7] = "ado" OR rtb_subtype.part-ext[8] = "ado" OR rtb_subtype.part-ext[9] = "ado") NO-LOCK ~
    BY rtb_object.pmod ~
       BY rtb_object.obj-type ~
        BY rtb_object.object INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrBrowse OPEN QUERY BrBrowse FOR EACH rtb_object ~
      WHERE rtb_object.pmod = (IF coProductModule = "<ALL>":U THEN rtb_object.pmod ELSE coProductModule) ~
 AND rtb_object.obj-type = "PCODE":U ~
 AND rtb_object.wspace-id = coWorkSpace ~
 AND rtb_object.object BEGINS fiObject NO-LOCK, ~
      FIRST rtb_ver WHERE rtb_ver.obj-type = rtb_object.obj-type ~
  AND rtb_ver.object = rtb_object.object ~
  AND rtb_ver.pmod = rtb_object.pmod ~
  AND rtb_ver.version = rtb_object.version NO-LOCK, ~
      FIRST rtb_subtype WHERE rtb_subtype.sub-type = rtb_ver.sub-type ~
  AND (rtb_subtype.part-ext[1] = "ado" OR rtb_subtype.part-ext[2] = "ado" OR rtb_subtype.part-ext[3] = "ado" OR rtb_subtype.part-ext[4] = "ado" OR rtb_subtype.part-ext[5] = "ado" OR rtb_subtype.part-ext[6] = "ado" OR rtb_subtype.part-ext[7] = "ado" OR rtb_subtype.part-ext[8] = "ado" OR rtb_subtype.part-ext[9] = "ado") NO-LOCK ~
    BY rtb_object.pmod ~
       BY rtb_object.obj-type ~
        BY rtb_object.object INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrBrowse rtb_object rtb_ver rtb_subtype
&Scoped-define FIRST-TABLE-IN-QUERY-BrBrowse rtb_object
&Scoped-define SECOND-TABLE-IN-QUERY-BrBrowse rtb_ver
&Scoped-define THIRD-TABLE-IN-QUERY-BrBrowse rtb_subtype


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule fiObject buRefresh BrBrowse ~
buAllSelect buAllDeselect toLoadXML ToCheckOut buOK buCancel ToIgnoreSCM 
&Scoped-Define DISPLAYED-OBJECTS coWorkspace coProductModule fiObject ~
toLoadXML ToCheckOut ToIgnoreSCM 

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
     LABEL "Check Out Objects in SCM Tool" 
     VIEW-AS TOGGLE-BOX
     SIZE 45.2 BY .81 TOOLTIP "Check out any objects not already checked out in current task" NO-UNDO.

DEFINE VARIABLE ToIgnoreSCM AS LOGICAL INITIAL no 
     LABEL "Ignore SCM Checks" 
     VIEW-AS TOGGLE-BOX
     SIZE 42.4 BY .81 TOOLTIP "Disable all SCM checking" NO-UNDO.

DEFINE VARIABLE toLoadXML AS LOGICAL INITIAL yes 
     LABEL "Load XML .ado files" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 TOOLTIP "Rebuild repository data from information in .ado XML file" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrBrowse FOR 
      rtb_object, 
      rtb_ver, 
      rtb_subtype SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrBrowse C-Win _STRUCTURED
  QUERY BrBrowse NO-LOCK DISPLAY
      rtb_object.pmod COLUMN-LABEL "RTB Module" FORMAT "x(12)":U
            WIDTH 13
      rtb_object.object FORMAT "x(32)":U
      rtb_ver.sub-type FORMAT "x(15)":U
      rtb_ver.description FORMAT "x(40)":U
      rtb_ver.version FORMAT "999999":U
      rtb_object.obj-group FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 97.8 BY 13.71 ROW-HEIGHT-CHARS .67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coWorkspace AT ROW 1.33 COL 10.8
     coProductModule AT ROW 2.43 COL 6.8
     fiObject AT ROW 3.52 COL 21 COLON-ALIGNED
     buRefresh AT ROW 3.52 COL 85.6
     BrBrowse AT ROW 4.81 COL 2.8
     buAllSelect AT ROW 18.71 COL 2.8
     buAllDeselect AT ROW 18.71 COL 19
     toLoadXML AT ROW 18.81 COL 39
     ToCheckOut AT ROW 19.71 COL 39
     buOK AT ROW 20.24 COL 2.8
     buCancel AT ROW 20.24 COL 85.6
     ToIgnoreSCM AT ROW 20.57 COL 39
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.8 BY 20.48
         DEFAULT-BUTTON buOK CANCEL-BUTTON buCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Compile into: scm/rtb/uib
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Load XML Files into Repository"
         HEIGHT             = 20.48
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
ASSIGN 
       BrBrowse:NUM-LOCKED-COLUMNS IN FRAME DEFAULT-FRAME     = 2.

/* SETTINGS FOR COMBO-BOX coProductModule IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coWorkspace IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrBrowse
/* Query rebuild information for BROWSE BrBrowse
     _TblList          = "rtb.rtb_object,rtb.rtb_ver WHERE rtb.rtb_object ...,rtb.rtb_subtype WHERE rtb.rtb_ver ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _OrdList          = "rtb.rtb_object.pmod|yes,rtb.rtb_object.obj-type|yes,rtb.rtb_object.object|yes"
     _Where[1]         = "rtb.rtb_object.pmod = (IF coProductModule = ""<ALL>"":U THEN rtb_object.pmod ELSE coProductModule)
 AND rtb.rtb_object.obj-type = ""PCODE"":U
 AND rtb.rtb_object.wspace-id = coWorkSpace
 AND rtb.rtb_object.object BEGINS fiObject"
     _JoinCode[2]      = "rtb.rtb_ver.obj-type = rtb.rtb_object.obj-type
  AND rtb.rtb_ver.object = rtb.rtb_object.object
  AND rtb.rtb_ver.pmod = rtb.rtb_object.pmod
  AND rtb.rtb_ver.version = rtb.rtb_object.version"
     _JoinCode[3]      = "rtb.rtb_subtype.sub-type = rtb.rtb_ver.sub-type
  AND (rtb_subtype.part-ext[1] = ""ado"" OR rtb_subtype.part-ext[2] = ""ado"" OR rtb_subtype.part-ext[3] = ""ado"" OR rtb_subtype.part-ext[4] = ""ado"" OR rtb_subtype.part-ext[5] = ""ado"" OR rtb_subtype.part-ext[6] = ""ado"" OR rtb_subtype.part-ext[7] = ""ado"" OR rtb_subtype.part-ext[8] = ""ado"" OR rtb_subtype.part-ext[9] = ""ado"")"
     _FldNameList[1]   > rtb.rtb_object.pmod
"rtb_object.pmod" "RTB Module" "x(12)" "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" ""
     _FldNameList[2]   = rtb.rtb_object.object
     _FldNameList[3]   > rtb.rtb_ver.sub-type
"rtb_ver.sub-type" ? "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = rtb.rtb_ver.description
     _FldNameList[5]   = rtb.rtb_ver.version
     _FldNameList[6]   = rtb.rtb_object.obj-group
     _Query            is NOT OPENED
*/  /* BROWSE BrBrowse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Load XML Files into Repository */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Load XML Files into Repository */
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

  ASSIGN
      coWorkspace
      coProductModule
      fiObject
      toLoadXML
      toCheckOut
      toIgnoreSCM
      lChoice = NO
      .

  IF toCheckOut = YES
  AND grtb-task-num = 0
  THEN DO:
    MESSAGE "You must have a valid open task to check-out objects in SCM Tool".
    RETURN NO-APPLY.
  END.

  IF  toLoadXML   = NO
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
  IF toLoadXML
  THEN
    ASSIGN
      cMessage = cMessage + "Load XML .ado files for selected objects into current Repository database"
               + CHR(10)  + CHR(10).
  IF toCheckOut
  THEN
    ASSIGN
      cMessage = cMessage + "Check out objects in SCM tool not already checked out in the current"
               + CHR(10)  + "task, prior to loading the .ado xml file"
               + CHR(10)  + CHR(10).
  IF toIgnoreSCM
  THEN
    ASSIGN
      cMessage = cMessage + "Ignore all SCM / version database checks and just load the XML File"
               + CHR(10)  + CHR(10).
  ASSIGN
    cMessage = cMessage + "Proceed?"
             + CHR(10)  + CHR(10).

  MESSAGE
    cMessage
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lChoice.

  IF lChoice = YES
  THEN
    RUN processOptions.

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
ON VALUE-CHANGED OF ToCheckOut IN FRAME DEFAULT-FRAME /* Check Out Objects in SCM Tool */
DO:

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      toCheckOut.
  
    IF toCheckOut
    THEN DO:
      DISABLE toIgnoreSCM.    
      ASSIGN
        toIgnoreSCM = NO.
      DISPLAY
        toIgnoreSCM.        
    END.
    ELSE
    DO:
      ENABLE toIgnoreSCM.    
      ASSIGN
        toIgnoreSCM = NO.
      DISPLAY
        toIgnoreSCM.        
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
  
    IF toIgnoreSCM
    THEN DO:
      DISABLE toCheckOut.    
      ASSIGN
        toCheckOut = NO.
      DISPLAY
        toCheckOut.        
    END.
    ELSE DO:
      ENABLE toCheckOut.    
      ASSIGN
        toCheckOut = NO.
      DISPLAY
        toCheckout.        
    END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toLoadXML
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toLoadXML C-Win
ON VALUE-CHANGED OF toLoadXML IN FRAME DEFAULT-FRAME /* Load XML .ado files */
DO:

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      toLoadXML.

    IF toLoadXML
    THEN DO:
      ENABLE
        toCheckOut.
      DISABLE
        toIgnoreSCM.    
      ASSIGN
        toCheckOut  = YES
        toIgnoreSCM = NO.
      DISPLAY
        toCheckOut
        toIgnoreSCM.        
    END.
    ELSE
    DO:
      DISABLE
        toCheckOut
        toIgnoreSCM.    
      ASSIGN
        toCheckOut  = NO
        toIgnoreSCM = NO.
      DISPLAY
        toCheckOut
        toIgnoreSCM.        
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
  Notes:       coWorkSpace = grtb-wspace-id
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN 
      coProductModule:LIST-ITEMS = "":U.

    FOR EACH gsc_product_module NO-LOCK
      BY gsc_product_module.product_module_code
      :

      FIND FIRST rtb_pmod NO-LOCK
        WHERE SUBSTRING(rtb_pmod.pmod,4,LENGTH(rtb_pmod.pmod)) = gsc_product_module.product_module_code
        NO-ERROR.
      IF NOT AVAILABLE rtb_pmod
      THEN
        FIND FIRST rtb_pmod NO-LOCK
          WHERE rtb_pmod.pmod = gsc_product_module.product_module_code
          NO-ERROR.

      IF AVAILABLE rtb_pmod
      THEN
        coProductModule:ADD-LAST(LC(rtb_pmod.pmod)).

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
      coWorkspace
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
        WHERE ttObject.cWorkspace       = coWorkspace
        AND   ttObject.cProductModule   = rtb_object.pmod
        AND   ttObject.cObjectName      = REPLACE(rtb_object.OBJECT,".ado":U,"":U)
        NO-ERROR.
      IF NOT AVAILABLE ttObject
      THEN
        CREATE ttObject.

      ASSIGN
        ttObject.cWorkspace     = coWorkspace
        ttObject.cProductModule = SUBSTRING(rtb_object.pmod,4,LENGTH(rtb_pmod.pmod))
        ttObject.cObjectName    = REPLACE(rtb_object.OBJECT,".ado":U,"":U)
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
  DISPLAY coWorkspace coProductModule fiObject toLoadXML ToCheckOut ToIgnoreSCM 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coProductModule fiObject buRefresh BrBrowse buAllSelect buAllDeselect 
         toLoadXML ToCheckOut buOK buCancel ToIgnoreSCM 
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
      toLoadXML   = YES
      toCheckOut  = YES
      toIgnoreSCM = NO
      .
    DISPLAY
      toLoadXML
      toCheckOut
      toIgnoreSCM
      .

    RUN buildCoWorkspace.
    RUN buildCoProductModule.

    IF grtb-wspace-id = "":U
    THEN ENABLE coWorkspace.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processOptions C-Win 
PROCEDURE processOptions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iErrorLoop                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cErrorLine                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError                        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE ghRyXmlPlip                   AS HANDLE     NO-UNDO.

  SESSION:SET-WAIT-STATE("general":U).

  EMPTY TEMP-TABLE ttError.
  EMPTY TEMP-TABLE ttObject.
  RUN buildObjectTT (INPUT-OUTPUT TABLE ttObject).

  IF toLoadXml
  OR toCheckOut
  THEN DO:
    {af/sup2/afrun2.i &PLIP = 'rtb/prc/ryxmlplipp.p'
                      &IProc = ''
                      &OnApp = 'no'
                      &Autokill = NO}
    ASSIGN
      ghRyXmlPlip = hPlip.
  END.

  /* create/checkout SCM objects if selected */
  IF toCheckOut
  AND cError = "":U
  THEN DO:
    {launch.i &PLIP = 'rtb/prc/ryxmlplipp.p'
              &IProc = 'checkOutObjects'
              &PList = "( INPUT TABLE ttObject, INPUT grtb-task-num, INPUT YES, INPUT-OUTPUT TABLE ttError, OUTPUT cError )"
              &OnApp = 'no'
              &Autokill = NO}
  END.

  /* Load XML .ado files if selected */
  IF toLoadXml
  AND cError = "":U
  THEN DO:
    {launch.i &PLIP = 'rtb/prc/ryxmlplipp.p'
              &IProc = 'loadXMLForObjects'
              &PList = "( INPUT TABLE ttObject, INPUT-OUTPUT TABLE ttError, OUTPUT cError )"
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

