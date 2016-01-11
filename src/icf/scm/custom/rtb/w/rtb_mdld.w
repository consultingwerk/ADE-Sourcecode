&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*------------------------------------------------------------------------
  File:    rtb_mdld.w  --  GUI Module Load utility
  Author:  John,Mark
  Date:    April 1996
  
  Notes:   This procedure is provided in source so that you can modify 
           it to fit your needs.  
------------------------------------------------------------------------*/

/*         This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */


/* DEFINE INPUT PARAMETER Pmodule-id AS RECID NO-UNDO. */

{rtb/g/rtbglobl.i "NEW"}

{rtb/g/rtbstand.i}
{rtb/g/rtb_prpr.i}  /* Common preprocessor directives */

{rtb/proextra/rtb_windows.i}  /*- instantiates API procedure -*/
{rtb/proextra/rtb_File-Api.i} /*- API calls for file access -*/
  
/* --- Define locals --- */
DEFINE NEW SHARED TEMP-TABLE Tsrcfile NO-UNDO
   FIELD obj-status    AS CHARACTER FORMAT "x(4)"
                       LABEL "Status"
   FIELD filename      AS CHARACTER FORMAT "x(20)"
                       LABEL "Filename"
   FIELD sub-type      LIKE rtb.rtb_ver.sub-type
                       LABEL "Sub Type"
   FIELD pmod          LIKE rtb.rtb_ver.pmod
                       LABEL "Pmodule"
   FIELD obj-group     LIKE rtb.rtb_object.obj-group
                       LABEL "Group" 
   FIELD group-level   LIKE rtb.rtb_object.group-level
                       COLUMN-LABEL " Level "
   FIELD object        LIKE rtb.rtb_object.object
   FIELD fullpath      AS CHARACTER
                       LABEL "Fullpath"
   FIELD summary-desc  AS CHARACTER
   FIELD detailed-desc AS CHARACTER
   FIELD selected      AS LOGICAL
   FIELD extension     AS CHARACTER
   FIELD subdir        AS CHARACTER
   FIELD suffix        AS CHARACTER
   FIELD module        LIKE rtb.rtb_object.module
   FIELD defaults      AS LOGICAL
   INDEX Tsrcfile-01 filename
   INDEX Tsrcfile-02 selected
   INDEX Tsrcfile-03 extension
   INDEX Tsrcfile-04 suffix
   INDEX Tsrcfile-05 subdir
   INDEX Tsrcfile-06 obj-status
   INDEX Tsrcfile-07 fullpath
   INDEX Tsrcfile-08 module
   INDEX Tsrcfile-09 defaults.

DEFINE TEMP-TABLE Tpmod-defs NO-UNDO
   FIELD extension AS CHARACTER
   FIELD pmod      AS CHARACTER.
       
DEFINE TEMP-TABLE Tsubtype-defs NO-UNDO
   FIELD extension AS CHARACTER
   FIELD subtype   AS CHARACTER.

DEFINE TEMP-TABLE Tsubtype-parts NO-UNDO
  FIELD module    AS CHARACTER
  FIELD filename  AS CHARACTER
  FIELD partname  AS CHARACTER
  INDEX Tsubtype-parts-01 module
  INDEX Tsubtype-parts-02 filename
  INDEX Tsubtype-parts-03 partname.

DEFINE NEW SHARED BUFFER Brtb_ver    FOR rtb.rtb_ver.
DEFINE NEW SHARED BUFFER Brtb_object FOR rtb.rtb_object.

DEFINE VARIABLE Malert-title       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mcorrect-steps     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Merror             AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mmodule            AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Msrcpaths          AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mpath              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mprev-filename     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mmodpath           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mworking-dir       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Msubtype-def-pmod  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Mtemp-filename     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Msrcfile-entries   AS INTEGER              NO-UNDO.
DEFINE VARIABLE Mprev-row          AS INTEGER              NO-UNDO INITIAL 1.
DEFINE VARIABLE Mrow               AS INTEGER              NO-UNDO.
DEFINE VARIABLE Mload-desc         AS LOGICAL INITIAL YES  NO-UNDO.
DEFINE VARIABLE Mret               AS LOGICAL              NO-UNDO.
DEFINE VARIABLE Mcontinue          AS LOGICAL              NO-UNDO.
DEFINE VARIABLE Mi                 AS INTEGER              NO-UNDO.
DEFINE VARIABLE Mduplicate         AS LOGICAL              NO-UNDO.
DEFINE VARIABLE Mmax-suffix        AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE Mrtbwin-handle     AS INTEGER              NO-UNDO.

DEFINE VARIABLE Mfilename-sort    AS CHARACTER NO-UNDO INITIAL "A".
DEFINE VARIABLE Mobj-status-sort  AS CHARACTER NO-UNDO INITIAL "A".
DEFINE VARIABLE Msub-type-sort    AS CHARACTER NO-UNDO INITIAL "A".
DEFINE VARIABLE Mpmod-sort        AS CHARACTER NO-UNDO INITIAL "A".
DEFINE VARIABLE Mobj-group-sort   AS CHARACTER NO-UNDO INITIAL "A".
DEFINE VARIABLE Mgroup-level-sort AS CHARACTER NO-UNDO INITIAL "A".
DEFINE VARIABLE Mfullpath-sort    AS CHARACTER NO-UNDO INITIAL "A".

/* --- Define local widgets --- */
DEFINE QUERY BR-srcfile FOR Tsrcfile.

DEFINE BROWSE BR-srcfile QUERY BR-srcfile DISPLAY
  Tsrcfile.obj-status
  Tsrcfile.filename
  Tsrcfile.sub-type FORMAT "x(12)"
  Tsrcfile.pmod FORMAT "x(24)"
  Tsrcfile.obj-group FORMAT "x(16)"
  Tsrcfile.group-level
  Tsrcfile.fullpath FORMAT "x(355)"
ENABLE
  Tsrcfile.obj-status
  Tsrcfile.filename
  Tsrcfile.sub-type
  Tsrcfile.pmod
  Tsrcfile.obj-group
  Tsrcfile.group-level
  Tsrcfile.fullpath
WITH   
  7 DOWN
  WIDTH 88
  MULTIPLE
  NO-ROW-MARKERS
  EXPANDABLE.

/* Dynamics Enhancements - BEGIN */
{src/adm2/globals.i}
{af/sup2/aficfcheck.i}
DEFINE VARIABLE hScmTool              AS HANDLE       NO-UNDO.
DEFINE VARIABLE cMesWinTitle          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinMessage        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonList     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonDefault  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonCancel   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerValue    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerDataType AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerFormat   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonPressed  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lActionUnderway       AS LOGICAL      NO-UNDO.
/* Dynamics Enhancements - END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FRAME-A

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CB-module TB-Scan-Desc RS-scan-by ~
FI-filespec CB-sub-type BT-Scan BT-Clear BT-select BT-deselect ~
BT-properties BT-view BT-load BT-delete BT-quit RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS CB-module TB-Scan-Desc RS-scan-by ~
FI-filespec CB-sub-type 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSubtypePartsCount WINDOW-1 
FUNCTION fnSubtypePartsCount RETURNS INTEGER
  ( INPUT Psub-type AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValidSubtypeFile WINDOW-1 
FUNCTION fnValidSubtypeFile RETURNS LOGICAL
  ( INPUT Psub-type AS CHARACTER,
    INPUT Pfile-name AS CHARACTER,
    INPUT Pextension AS CHARACTER,
    INPUT Psubdir AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Select_Files LABEL "Select Files..."
       MENU-ITEM m_Deselect_Files LABEL "D&eselect Files..."
       MENU-ITEM m_Properties   LABEL "Properties..." 
       MENU-ITEM m_View_File    LABEL "View File"     
       RULE
       MENU-ITEM m_Load_Selected LABEL "Load Selected Files..."
       MENU-ITEM m_Unload_Selected LABEL "Unload Selected Files..."
       RULE
       MENU-ITEM m_Done         LABEL "Done"          .

DEFINE SUB-MENU m_Search 
       MENU-ITEM m_Find         LABEL "Find..."       .

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_Module_Load  LABEL "Module Load"   
       RULE
       MENU-ITEM m_Contents     LABEL "Contents"      
       MENU-ITEM m_Search_For_Help_On LABEL "Search For Help On..."
       RULE
       MENU-ITEM m_About        LABEL "About..."      .

DEFINE MENU Main-Menu MENUBAR
       SUB-MENU  m_File         LABEL "File"          
       SUB-MENU  m_Search       LABEL "Search"        
       SUB-MENU  m_Help         LABEL "Help"          .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BT-Clear 
     LABEL "&Clear" 
     SIZE 15 BY 1.14 TOOLTIP "Clear objects from list".

DEFINE BUTTON BT-delete 
     LABEL "&Unload..." 
     SIZE 15 BY 1.

DEFINE BUTTON BT-deselect 
     LABEL "D&eselect..." 
     SIZE 15 BY 1.

DEFINE BUTTON BT-load 
     LABEL "&Load..." 
     SIZE 15 BY 1.

DEFINE BUTTON BT-properties 
     LABEL "&Properties..." 
     SIZE 15 BY 1.

DEFINE BUTTON BT-quit 
     LABEL "&Done":L 
     SIZE 10 BY 1.

DEFINE BUTTON BT-Scan 
     LABEL "Sca&n" 
     SIZE 15 BY 1.14.

DEFINE BUTTON BT-select 
     LABEL "Selec&t..." 
     SIZE 15 BY 1.

DEFINE BUTTON BT-view 
     LABEL "&View" 
     SIZE 15 BY 1.

DEFINE VARIABLE CB-module AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Workspace Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE CB-sub-type AS CHARACTER FORMAT "X(256)":U 
     LABEL "Subtype" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE FI-filespec AS CHARACTER FORMAT "X(256)":U INITIAL "*.*" 
     LABEL "Filespec" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE RS-scan-by AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Scan by f&ilespec", "Filespec",
"Scan by subt&ype", "Subtype"
     SIZE 26 BY 2.38 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY 5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY 8.33.

DEFINE VARIABLE TB-Scan-Desc AS LOGICAL INITIAL no 
     LABEL "Scan comments to &build descriptions" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .81 TOOLTIP "Toggle on to build object descriptions from comments in source" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     CB-module AT ROW 2.43 COL 24 COLON-ALIGNED HELP
          "Select Workspace Module"
     TB-Scan-Desc AT ROW 2.52 COL 66 HELP
          "Toggle on to build object descriptions from comments in source"
     RS-scan-by AT ROW 3.81 COL 6 HELP
          "Select scan method" NO-LABEL
     FI-filespec AT ROW 3.81 COL 42 COLON-ALIGNED HELP
          "Enter filespec to load from module directories"
     CB-sub-type AT ROW 5 COL 42 COLON-ALIGNED HELP
          "Select code subtype"
     BT-Scan AT ROW 4.81 COL 75 HELP
          "Scan directories for objects"
     BT-Clear AT ROW 4.81 COL 92 HELP
          "Clear specified objects"
     BT-select AT ROW 7.67 COL 93
     BT-deselect AT ROW 8.86 COL 93
     BT-properties AT ROW 10.05 COL 93
     BT-view AT ROW 11.24 COL 93 HELP
          "View the current source file"
     BT-load AT ROW 12.43 COL 93
     BT-delete AT ROW 13.62 COL 93 HELP
          "Delete current source object from Roundtable"
     BT-quit AT ROW 15.52 COL 3 HELP
          "Quit Module Load"
     RECT-1 AT ROW 1.38 COL 2
     RECT-2 AT ROW 6.91 COL 2
     " Scan Specs" VIEW-AS TEXT
          SIZE 15 BY .95 AT ROW 1 COL 5
     " Objects" VIEW-AS TEXT
          SIZE 10 BY .95 AT ROW 6.57 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 110.6 BY 15.76
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Module Load"
         HEIGHT             = 15.76
         WIDTH              = 110.6
         MAX-HEIGHT         = 15.76
         MAX-WIDTH          = 110.6
         VIRTUAL-HEIGHT     = 15.76
         VIRTUAL-WIDTH      = 110.6
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU Main-Menu:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRAME-A
   UNDERLINE Custom                                                     */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
THEN WINDOW-1:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL WINDOW-1 WINDOW-1
ON ENTRY OF WINDOW-1 /* Module Load */
DO:
  ASSIGN CURRENT-WINDOW = {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-Clear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-Clear WINDOW-1
ON CHOOSE OF BT-Clear IN FRAME FRAME-A /* Clear */
DO:
  RUN clear_tsrcfile_recs.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-deselect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-deselect WINDOW-1
ON CHOOSE OF BT-deselect IN FRAME FRAME-A /* Deselect... */
DO:
  APPLY "CHOOSE" TO MENU-ITEM m_deselect_files IN MENU MAIN-MENU.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-load WINDOW-1
ON CHOOSE OF BT-load IN FRAME FRAME-A /* Load... */
DO:
  RUN load_files.
  RUN set_sensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-Scan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-Scan WINDOW-1
ON CHOOSE OF BT-Scan IN FRAME FRAME-A /* Scan */
DO:
  RUN scan_directories.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BT-select
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BT-select WINDOW-1
ON CHOOSE OF BT-select IN FRAME FRAME-A /* Select... */
DO:
  APPLY "CHOOSE" TO MENU-ITEM m_select_files IN MENU MAIN-MENU.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-module
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-module WINDOW-1
ON VALUE-CHANGED OF CB-module IN FRAME FRAME-A /* Workspace Module */
DO:
  RUN set_module_query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About WINDOW-1
ON CHOOSE OF MENU-ITEM m_About /* About... */
DO:
  /* Tell about this application */
  RUN display_about IN Grtb-p-library (INPUT "rtb_mdld.w").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents WINDOW-1
ON CHOOSE OF MENU-ITEM m_Contents /* Contents */
DO:
  SYSTEM-HELP Grtb-help-file FINDER.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Deselect_Files
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Deselect_Files WINDOW-1
ON CHOOSE OF MENU-ITEM m_Deselect_Files /* Deselect Files... */
DO:
  RUN select_files (INPUT "deselect").
  RUN set_sensitive.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Done WINDOW-1
ON CHOOSE OF MENU-ITEM m_Done /* Done */
OR CHOOSE OF BT-quit DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Find
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Find WINDOW-1
ON CHOOSE OF MENU-ITEM m_Find /* Find... */
DO:
  RUN find_record.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Module_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Module_Load WINDOW-1
ON CHOOSE OF MENU-ITEM m_Module_Load /* Module Load */
DO:                                            
  SYSTEM-HELP Grtb-help-file CONTEXT 722.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Properties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Properties WINDOW-1
ON CHOOSE OF MENU-ITEM m_Properties /* Properties... */
OR CHOOSE OF BT-properties DO:
  RUN modify_properties.
  RUN set_sensitive.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Search_For_Help_On
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Search_For_Help_On WINDOW-1
ON CHOOSE OF MENU-ITEM m_Search_For_Help_On /* Search For Help On... */
DO:
  SYSTEM-HELP Grtb-help-file PARTIAL-KEY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Select_Files
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Select_Files WINDOW-1
ON CHOOSE OF MENU-ITEM m_Select_Files /* Select Files... */
DO:
  RUN select_files (INPUT "select").
  RUN set_sensitive.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Unload_Selected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Unload_Selected WINDOW-1
ON CHOOSE OF MENU-ITEM m_Unload_Selected /* Unload Selected Files... */
OR CHOOSE OF BT-delete DO:
  RUN unload_files.
  RUN set_sensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_View_File
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_View_File WINDOW-1
ON CHOOSE OF MENU-ITEM m_View_File /* View File */
OR CHOOSE OF BT-view DO:
  RUN view_file.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RS-scan-by
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-scan-by WINDOW-1
ON VALUE-CHANGED OF RS-scan-by IN FRAME FRAME-A
DO:
  RUN set_sensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */
RUN instance_added IN Grtb-p-library (THIS-PROCEDURE).

/* --- Init variables --- */
ASSIGN
  Malert-title   = "Roundtable Module Load"
  Mcorrect-steps = "You must have done the following in Roundtable before
 starting Module Load:" +
                   CHR(10) +
                   "        Defined workspace modules." +
                   CHR(10) +
                   "        Defined products." +
                   CHR(10) +
                   "        Defined product modules." +
                   CHR(10) +
                   "        Defined code subtypes." +
                   CHR(10) +
                   "        Defined and selected a workspace." +
                   CHR(10) +
                   "        Defined workspace sources." +
                   CHR(10) +
                   "        Created and selected a task." +
                   CHR(10) +
                   "        Backed up your Roundtable repository.".

/* --- ensure a site exists --- */
FIND FIRST rtb.rtb_system NO-LOCK NO-ERROR.
IF NOT AVAILABLE rtb.rtb_system THEN DO:
  MESSAGE 
    "Cannot run Module Load as no site is defined.  Define a site from the
 Tabletop and try again."
    VIEW-AS ALERT-BOX ERROR
    TITLE Malert-title.
  RETURN.
END. /* if not available rtb_system */ 

/* --- ensure user has security access --- */
IF Grtb-access = "" THEN
  RUN rtb/p/rtb_bsec.p (INPUT  USERID("rtb"),
                        OUTPUT Grtb-access). 

IF NOT CAN-DO(Grtb-access,"PCODE-OBJECTS") THEN DO:               
  MESSAGE 
    "You do not have the required user security to access the Module Load
 utility.  Contact the System Administrator to change security privileges
 if this functionality is necessary."
    VIEW-AS ALERT-BOX ERROR
    TITLE Malert-title.
  RETURN.
END.  /* if not can-do(grtb-access,"pcode-objects") */

/* --- Check workspace path --- */
IF Grtb-wspath = "" THEN DO:
  MESSAGE 
    "Cannot run Module Load as no workspace is selected.  Select a workspace
 from the Tabletop and try again."
    SKIP(1)
    Mcorrect-steps
    VIEW-AS ALERT-BOX ERROR
    TITLE Malert-title.
  RETURN.
END.  /* if grtb-wspath = "" */

/* --- Find workspace --- */
FIND rtb.rtb_wspace WHERE rtb.rtb_wspace.wspace-id = Grtb-wspace-id
                      NO-LOCK NO-ERROR.

IF NOT AVAILABLE rtb.rtb_wspace THEN DO:
  MESSAGE 
    "Cannot run Module Load as no workspace is selected.  Select a workspace
 from tht Tabletop and try again."
    SKIP(1)
    Mcorrect-steps
    VIEW-AS ALERT-BOX ERROR
    TITLE Malert-title.
  RETURN.
END.  /* if grtb-wspath = "" */

/* --- Find task --- */
FIND rtb.rtb_task WHERE rtb.rtb_task.task-num = Grtb-task-num
     NO-LOCK NO-ERROR.

IF NOT AVAILABLE rtb.rtb_task OR rtb.rtb_task.task-status <> "W" THEN DO:
  MESSAGE 
    "Cannot run Module Load as no task is selected.  Select a task from the
 Tabletop and try again."
    SKIP(1)
    Mcorrect-steps
    VIEW-AS ALERT-BOX ERROR
    TITLE Malert-title.
  RETURN.
END.  /* if not available rtb_task */

/* --- Ensure at least one code sybtype is defined in the system --- */
FIND FIRST rtb.rtb_subtype NO-LOCK NO-ERROR.
IF NOT AVAILABLE rtb.rtb_subtype THEN DO:                              
  MESSAGE
    "Cannot run Module Load as no code subtypes have been defined.  Define
 code subtypes and try again."
    SKIP(1)
    Mcorrect-steps
    VIEW-AS ALERT-BOX ERROR
    TITLE Malert-title.
  RETURN.
END.  /* if not available rtb_subtype */


/* --- Working directory? --- */
ASSIGN
  Mworking-dir = IF rtb.rtb_task.share-status <> "Central" THEN
                   ENTRY(1,Grtb-taskpath)
                 ELSE 
                   Grtb-wsroot.

/* --- Put unloaded source file browse in the frame --- */
FORM
  BR-srcfile AT ROW 7.5 COLUMN 3
WITH FRAME {&FRAME-NAME}.
ASSIGN 
  BR-srcfile:HELP = "Select source file".
      
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* --- Watch for the close event, and take appropriate action. ---
 * Note that if we are going to message "Save changes?", then if the
 * window is minimized (window-state=2), then restore it
 * (window-state=3).
 * ---------------------------------------------------------------- */
ON CLOSE OF THIS-PROCEDURE DO:
  RUN unload_proextra.
  /* --- Save window position --- */
  RUN save_window_position IN Grtb-p-library
    (INPUT  "ModuleLoad",
     INPUT  {&WINDOW-NAME}:HANDLE ).
  RUN instance_deleted IN Grtb-p-library (THIS-PROCEDURE).
  RUN set_browse_mode IN Grtb-proc-handle.  /* update items in browse list */  
  RUN disable_UI.
  RETURN.
END.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON CTRL-A ANYWHERE 
DO:
   BR-srcfile:SELECT-ALL() IN FRAME {&FRAME-NAME}. 
   RUN SET_sensitive.
END.


ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END. 


/* --- value changed trigger --- */
ON "VALUE-CHANGED" OF BR-srcfile DO:
   RUN set_sensitive. 
END.  /* on value-changed of br-srcfile */

/* --- Start Search trigger (column click) --- */
ON "START-SEARCH" OF BR-srcfile DO:
  DEFINE VARIABLE Mcol-handle AS HANDLE NO-UNDO.
  ASSIGN Mcol-handle = BR-srcfile:CURRENT-COLUMN.
  APPLY "END-SEARCH" TO BR-srcfile.
  
  CASE Mcol-handle:NAME:
  WHEN "obj-status" THEN
    IF Mobj-status-sort = "D" THEN
      DO:  
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.obj-status.
        ASSIGN Mobj-status-sort = "A".  
      END.
    ELSE
      DO: 
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.obj-status DESCENDING.
        ASSIGN Mobj-status-sort = "D".
      END.
 
  WHEN "filename" THEN
    IF Mfilename-sort = "D" THEN
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.filename.
        ASSIGN Mfilename-sort = "A".
      END.
    ELSE
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.filename DESCENDING.
        ASSIGN Mfilename-sort = "D".
      END.
 
  WHEN "sub-type" THEN
    IF Msub-type-sort = "D" THEN
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.sub-type.
        ASSIGN Msub-type-sort = "A".
      END.
    ELSE
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.sub-type DESCENDING.
        ASSIGN Msub-type-sort = "D".
      END.
        
  WHEN "pmod" THEN
    IF Mpmod-sort = "D" THEN
      DO:  
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.pmod.
        ASSIGN Mpmod-sort = "A".
      END.
    ELSE
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.pmod DESCENDING.
        ASSIGN Mpmod-sort = "D".
      END.
      
  WHEN "obj-group" THEN
    IF Mobj-group-sort = "D" THEN
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.obj-group.
        ASSIGN Mobj-group-sort = "A".
      END.
    ELSE
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.obj-group DESCENDING.
        ASSIGN Mobj-group-sort = "D".
      END.
      
  WHEN "group-level" THEN
    IF Mgroup-level-sort = "D" THEN
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.group-level.
        ASSIGN Mgroup-level-sort = "A".
      END.
    ELSE
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK By Tsrcfile.group-level DESCENDING.
        ASSIGN Mgroup-level-sort = "D".
      END.
      
  WHEN "fullpath" THEN
    IF Mfullpath-sort = "D" THEN
      DO:  
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.fullpath.
        ASSIGN Mfullpath-sort = "A".
      END.
    ELSE
      DO:
        OPEN QUERY BR-srcfile
          FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
            NO-LOCK BY Tsrcfile.fullpath DESCENDING.
        ASSIGN Mfullpath-sort = "D".
      END.
  END CASE.
END.


/* --- Get a window position --- */
RUN set_window_position IN Grtb-p-library (INPUT "ModuleLoad",
                                           INPUT  {&WINDOW-NAME}:HANDLE).

ASSIGN
  Mret = {&WINDOW-NAME}:LOAD-ICON("rtb/images/rtbman.ico").

/* Best default for GUI applications is... */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition. */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire. */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /*- Load proextra.dll - this dll has some bitwise handling needed by -*/
  /*- rtb_file-api.i.  See add_tsrcfile_rec in this program            -*/
  RUN rtb/p/rtb_ldll.p (INPUT "proextra.dll":U,
                        INPUT "Load":U,
                        INPUT-OUTPUT Mrtbwin-handle ).  /* New dll instance handle. */
  
  IF RETURN-VALUE <> "" THEN DO:
    MESSAGE SUBSTITUTE(
"Failed to load &3. &1 &1
&2
&1 &1
&3 must exist in Roundtable root directory in order to run Module Load.",
      CHR(10), RETURN-VALUE, "PROEXTRA.DLL":U )
      VIEW-AS ALERT-BOX ERROR TITLE "Roundtable".
    
    RUN unload_proextra.
    RETURN.
  END.
  
  ENABLE BR-srcfile WITH FRAME FRAME-A.   
  
  RUN enable_UI.
  APPLY "ENTRY" TO CB-module IN FRAME {&FRAME-NAME}.

  ASSIGN BR-srcfile:COLUMN-RESIZABLE IN FRAME FRAME-A = TRUE.

  /*
  For some reason to have column sorting, you must enable all the fields
  in the browse, then turn around and set them to read-only.  Don't ask
  me why...
  */
  ASSIGN
    Tsrcfile.obj-status :READ-ONLY IN BROWSE BR-srcfile = TRUE
    Tsrcfile.filename   :READ-ONLY IN BROWSE BR-srcfile = TRUE
    Tsrcfile.sub-type   :READ-ONLY IN BROWSE BR-srcfile = TRUE
    Tsrcfile.pmod       :READ-ONLY IN BROWSE BR-srcfile = TRUE
    Tsrcfile.obj-group  :READ-ONLY IN BROWSE BR-srcfile = TRUE
    Tsrcfile.group-level:READ-ONLY IN BROWSE BR-srcfile = TRUE
    Tsrcfile.fullpath   :READ-ONLY IN BROWSE BR-srcfile = TRUE.
  
  ASSIGN
    FRAME {&FRAME-NAME}:HIDDEN  = NO
    CURRENT-WINDOW:TITLE        = Malert-title.

  /* --- End wait state so we can get the frame contents to display --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "").
  WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS BR-srcfile PAUSE 0.

  /* --- Fill Workspace Module and Subtype combos --- */
  RUN fill_module_combo.
  RUN fill_subtype_combo.
  
  RUN set_sensitive.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.  /* main block */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add_tsrcfile_rec WINDOW-1 
PROCEDURE add_tsrcfile_rec :
/*------------------------------------------------------------------------------
  Purpose:     Add qualifying files to table.
  Parameters:  INTPUT Pfind-data AS MEMPTR (pointing to file structure)
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER Pfind-data AS MEMPTR NO-UNDO.
   
  DEFINE VARIABLE Mextension AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mfile-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mmodule    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Msubdir    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mflags     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE Mresult    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE Mx         AS INTEGER   NO-UNDO.
  
  RUN FileInfo_LongName IN rtb_hpFileApi (INPUT Pfind-data,
                                          OUTPUT Mfile-name).
  
  ASSIGN Mflags = GET-LONG(Pfind-data, 1).
   
  RUN Bit_And IN rtb_hpExtra (INPUT Mflags,
                              INPUT {&DDL_DIRECTORY},
                              OUTPUT Mresult).
                          
  IF Mresult = 0 THEN DO:
  
    /* if object is .r code then skip it */
    IF NOT(Mfile-name MATCHES "*~~.r") and not(Mfile-name MATCHES "*~~.wrx") THEN DO:

      /* Check if object already exists */
      FIND rtb.rtb_path WHERE
           rtb.rtb_path.rtb-path = Mmodpath +
             (IF Mmodpath <> "" AND ENTRY(Mi,Msrcpaths) <> "" THEN
                "/" + ENTRY(Mi,Msrcpaths)
              ELSE 
                "") NO-LOCK NO-ERROR.

      /* --- See if the file is already referenced --- */
      IF AVAILABLE rtb.rtb_path AND
         CAN-FIND(FIRST rtb.rtb_pname WHERE
                        rtb.rtb_pname.wspace-recid = RECID(rtb.rtb_wspace) AND
                        rtb.rtb_pname.path-recid   = RECID(rtb.rtb_path) AND
                        rtb.rtb_pname.pname        = Mfile-name) THEN
        RETURN.

      /* --- See if possible name conflict exists ---
       * Note that this is just a 'potential' conflict, because
       * the same object name can be used in multiple pmods.
       * We don't give the user that option during Module Load anyway.
       * -------------------------------------------- */
     
      ASSIGN Mduplicate = NO.
      
      IF CAN-FIND(FIRST rtb.rtb_ver WHERE
                        rtb.rtb_ver.obj-type = "PCODE" AND
                        rtb.rtb_ver.object   = Mfile-name NO-LOCK) THEN
        ASSIGN Mduplicate = YES.

      IF CAN-FIND(FIRST Tsrcfile WHERE
                        Tsrcfile.filename = Mfile-name) then
        RETURN.
      
      ASSIGN Mextension = IF R-INDEX(Mfile-name,".") = 0 THEN
                            ""
                          ELSE
                            SUBSTRING(Mfile-name,R-INDEX(Mfile-name,".") + 1)
             Msubdir    = ENTRY(Mi,Msrcpaths)
             Mmodule    = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

      IF RS-scan-by:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Subtype"
         AND NOT fnValidSubtypeFile(CB-sub-type:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                    Mfile-name,
                                    Mextension,
                                    Msubdir) THEN
        RETURN.
      
      /* Ignore files already assoicated as a subtype part */
      IF CAN-FIND(Tsubtype-parts
                  WHERE Tsubtype-parts.module   = Mmodule
                    AND Tsubtype-parts.partname = Mfile-name) THEN RETURN.

      CREATE Tsrcfile.
      /* --- if the object name is blank we will prompt for it later --- */
      ASSIGN 
        Tsrcfile.object     = (IF Mduplicate THEN "" ELSE Mfile-name)
        Tsrcfile.filename   = Mfile-name
        Tsrcfile.obj-status = "New"
        Tsrcfile.fullpath   = Mpath + "/" + Mfile-name
        Tsrcfile.selected   = FALSE
        Tsrcfile.extension  = Mextension
        Tsrcfile.subdir     = Msubdir
        Tsrcfile.module     = Mmodule
        Tsrcfile.pmod       = ""
        Tsrcfile.sub-type   = ""
        Tsrcfile.defaults   = NO
        Msrcfile-entries    = Msrcfile-entries + 1.

      /* --- reverse sufix --- */       
      DO Mx = 1 TO MINIMUM(R-INDEX(Tsrcfile.filename,".") - 1,Mmax-suffix):
        ASSIGN
          Tsrcfile.suffix = Tsrcfile.suffix +
          SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,".") - Mx,1).
      END.  /* do mx = 1 to mx */
      
      /* --- scan for descriptions comments --- */  
      IF TB-Scan-Desc:CHECKED IN FRAME {&FRAME-NAME} THEN
        RUN scan_for_comments.

    end. /*- if not Mfile-name -*/
  
  end. /*- Mresult = 0 -*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build_alias WINDOW-1 
PROCEDURE build_alias :
/*------------------------------------------------------------------------------
  Purpose:     Automatically builds a unique object name for aliased objects
               using the file name and module name:
               @program.p-module 
  
  Notes:       If the name built is over 30 characters, the procedure will
               fail to load the object and will output the long name to the
               log file (<Temp-dir>/rtbload.txt).
                               
------------------------------------------------------------------------------*/

DEFINE VARIABLE Malias-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE Mfile-name  AS CHARACTER NO-UNDO.

ASSIGN Mfile-name = SESSION:TEMP-DIR + "rtbload.txt".

OUTPUT TO VALUE(Mfile-name) APPEND.


ASSIGN Malias-name = '@' 
                   + Tsrcfile.filename
                   + "-"
                   + Mmodule.

IF LENGTH(Malias-name) > 30 THEN DO:
 
    DISPLAY TODAY
            STRING(TIME,"HH:MM:SS")
            "Name too long"
            Tsrcfile.FILENAME
            Malias-name.  
    RETURN "Cancel".
END.

ASSIGN Tsrcfile.object = Malias-name.
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build_source_list WINDOW-1 
PROCEDURE build_source_list :
/* -----------------------------------------------------------
  Purpose:     Build the Tscrfile temp-table.
  Parameters:  INPUT Pwsmod    - Workspace Module
               INPUT Pscan-by  - "Filespec" or "Subtype"
               INPUT Pfilespec - Filespec
               INPUT Psub-type - Selected code sub-type
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER Pwsmod    AS CHARACTER   NO-UNDO.
  DEFINE INPUT PARAMETER Pscan-by  AS CHARACTER   NO-UNDO.
  DEFINE INPUT PARAMETER Pfilespec AS CHARACTER   NO-UNDO.
  DEFINE INPUT PARAMETER Psub-type AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE Mx             AS INTEGER           NO-UNDO.  
  DEFINE VARIABLE Mdef-pmod      AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE Mdef-subtype   AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE Mpause-handle  AS HANDLE            NO-UNDO.  
  
  
  /* --- Find the module --- */
  FIND FIRST rtb.rtb_module
    WHERE rtb.rtb_module.wspace-id = Grtb-wspace-id
      AND rtb.rtb_module.module    = Pwsmod NO-LOCK NO-ERROR.
          
  FIND rtb.rtb_moddef OF rtb.rtb_module NO-LOCK.
    
  ASSIGN Mmodule              = rtb.rtb_module.module
         Mmodpath             = rtb.rtb_moddef.directory
         Malert-title         = "Roundtable Module Load for Module: " + rtb.rtb_module.module.

  /* --- Set wait and tell 'em what we're up to --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "General").

  RUN rtb/p/rtb_paus.p PERSISTENT SET Mpause-handle
      ( INPUT 0,  /* no pause timeout */
        INPUT "Scanning module directories.  Please wait..." ).  

  IF Pscan-by = "Filespec":U THEN DO:
    /* --- find the longest subtype --- */
    ASSIGN Mmax-suffix = 0.
    FOR EACH rtb.rtb_subtype NO-LOCK:
      DO Mi = 1 TO 10:
        IF rtb.rtb_subtype.part[Mi] =  "" THEN LEAVE.
        IF LENGTH(rtb.rtb_subtype.part-sufix[Mi]) > Mmax-suffix THEN
          ASSIGN
            Mmax-suffix = LENGTH(rtb.rtb_subtype.part-sufix[Mi]).
      END.  /* do mi = 1 to 10 */
    END.  /* for each rtb_subtype */
  END. /* pscan-by = "filespec" */


  /* --- Step 1 ---
   * Using the sub-type definitions we generate a list of sub-directories 
   * in which PCODE text file parts are allowed to exist.
   * -------------- */
  IF Pscan-by = "Filespec":U OR Psub-type = " All":U THEN
    FOR EACH rtb.rtb_subtype NO-LOCK:
      DO Mi = 1 TO 10:
        IF NOT CAN-DO(Msrcpaths,rtb.rtb_subtype.part-dir[Mi])
        THEN IF Msrcpaths = "" AND rtb.rtb_subtype.part-dir[MI] = "" 
             THEN Msrcpaths = ",".
             ELSE IF Msrcpaths = "" 
                  THEN Msrcpaths = rtb.rtb_subtype.part-dir[Mi].
                  ELSE Msrcpaths = Msrcpaths + "," 
                                   + rtb.rtb_subtype.part-dir[Mi].
      END.  /* do mi = 1 to 10 */
    END.  /* for each rtb_subtype */
  ELSE DO:
    FIND rtb.rtb_subtype WHERE rtb.rtb_subtype.sub-type = Psub-type NO-LOCK.
    DO Mi = 1 TO 10:
      IF NOT CAN-DO(Msrcpaths,rtb.rtb_subtype.part-dir[Mi])
      THEN IF Msrcpaths = "" AND rtb.rtb_subtype.part-dir[MI] = "" 
           THEN Msrcpaths = ",".
           ELSE IF Msrcpaths = "" 
                THEN Msrcpaths = rtb.rtb_subtype.part-dir[Mi].
                ELSE Msrcpaths = Msrcpaths + "," 
                                 + rtb.rtb_subtype.part-dir[Mi].
    END.  /* do mi = 1 to 10 */
  END.

  IF Msrcpaths = "" THEN Msrcpaths = ",".


  /* --- Step 2 ---
   * Build workfile of files in each sub-directory.
   * -------------- */
  SRCPATHS-LOOP:
  DO Mi = 1 TO NUM-ENTRIES(Msrcpaths):

    ASSIGN Mpath = Mworking-dir +
              (IF Mmodpath <> "" THEN 
                 "/" + Mmodpath 
               ELSE 
                 "") +
              (IF ENTRY(Mi,Msrcpaths) <> "" THEN 
                 "/" + ENTRY(Mi,Msrcpaths)
               ELSE 
                 "").

    /* --- Check that the directory actually exists ---
     * File-type will contain a "D" if it is a directory (as opposed
     * to a regular file), and will be ? if it doesn't exist at all.
     * ------------------------------------------------ */
    ASSIGN FILE-INFO:FILE-NAME = Mpath.
   
    IF INDEX(FILE-INFO:FILE-TYPE,"D") < 1 OR 
       INDEX(FILE-INFO:FILE-TYPE,"D") = ? THEN 
      NEXT SRCPATHS-LOOP.
    
    RUN FileFindLoop IN rtb_hpFileApi (Mpath + "/" + Pfilespec,
                                       "add_tsrcfile_rec",
                                       THIS-PROCEDURE:HANDLE).
   
  END.      /* --- 1 TO NUM-ENTRIES(Msrcpaths) --- */
                      
  /*- Open query and browser -*/
  OPEN QUERY BR-srcfile FOR EACH Tsrcfile
    WHERE Tsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  REPOSITION BR-srcfile TO ROW 1.
  ASSIGN Br-srcfile:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = Msrcfile-entries.
    
  /* --- End wait, hide message --- */
  DELETE PROCEDURE Mpause-handle NO-ERROR.
  ASSIGN Mpause-handle = ? NO-ERROR.
  RUN set_session_wait IN Grtb-p-stat (INPUT "").    
  
END PROCEDURE.   /* --- build_source_list --- */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clear_tsrcfile_recs WINDOW-1 
PROCEDURE clear_tsrcfile_recs :
/*------------------------------------------------------------------------------
  Purpose:     Remove records from table matching filespec or subtype.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Mcriterion AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mpattern   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mrecs      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE Mclear     AS LOGICAL     NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    Mcriterion = IF RS-scan-by:SCREEN-VALUE = "Filespec":U THEN
                   SUBSTITUTE("filespec '&1'",FI-filespec:SCREEN-VALUE)
                 ELSE
                   SUBSTITUTE("sub-type '&1'",CB-sub-type:SCREEN-VALUE).
   
    MESSAGE SUBSTITUTE("Remove unloaded objects from list with &1?",Mcriterion)
      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE Malert-title
      UPDATE Mclear.
    
    IF Mclear = YES THEN DO:
      IF RS-scan-by:SCREEN-VALUE = "Filespec" THEN
        /*
         Look for literal dot in MATCHES pattern, not any single character
        */
        Mpattern = REPLACE(FI-filespec:SCREEN-VALUE,".","~~.").
      
      FOR EACH Tsrcfile
        WHERE Tsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
          AND Tsrcfile.obj-status = "New"
          AND (IF RS-scan-by:SCREEN-VALUE = "Filespec" THEN
                 Tsrcfile.filename MATCHES Mpattern
               ELSE
                 Tsrcfile.sub-type = CB-sub-type:SCREEN-VALUE):
  
        /* Remove any associated parts */
        FOR EACH Tsubtype-parts
          WHERE Tsubtype-parts.module   = Tsrcfile.module
            AND Tsubtype-parts.filename = Tsrcfile.filename:
          DELETE Tsubtype-parts.
        END.
        
        DELETE Tsrcfile.  
        Mrecs = Mrecs + 1.
      END.
      BROWSE BR-srcfile:REFRESH().
      MESSAGE SUBSTITUTE("&1 object(s) were removed from the list.",Mrecs)
        VIEW-AS ALERT-BOX INFO TITLE Malert-title.
    END. /* mclear = yes */
  END.

  RUN set_sensitive.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
  THEN DELETE WIDGET WINDOW-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WINDOW-1  _DEFAULT-ENABLE
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
  DISPLAY CB-module TB-Scan-Desc RS-scan-by FI-filespec CB-sub-type 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  ENABLE CB-module TB-Scan-Desc RS-scan-by FI-filespec CB-sub-type BT-Scan 
         BT-Clear BT-select BT-deselect BT-properties BT-view BT-load BT-delete 
         BT-quit RECT-1 RECT-2 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill_defaults WINDOW-1 
PROCEDURE fill_defaults :
/*------------------------------------------------------------------------------
  Purpose: Fill workfile of files with default pmods and subtypes.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE Mpmod-decide      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Msubtype-decide   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mdef-pmod         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mdef-subtype      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mparts            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mpmod-prompt      AS LOGICAL   NO-UNDO INITIAL YES.
  DEFINE VARIABLE Msubtype-prompt   AS LOGICAL   NO-UNDO INITIAL YES.


  FOR EACH Tsrcfile
    WHERE Tsrcfile.module   = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      AND Tsrcfile.defaults = NO:
 
    /* --- Start wait state --- */
    RUN set_session_wait IN Grtb-p-stat (INPUT "General").  
  
    IF Tsrcfile.pmod = "" THEN DO:
    
      /* --- determine and assign a pmod to this file --- */
      IF R-INDEX(Tsrcfile.filename,".") = 0 AND
         CAN-FIND(FIRST Tpmod-defs WHERE Tpmod-defs.extension = "") THEN DO:
         FIND FIRST Tpmod-defs WHERE Tpmod-defs.extension = "" 
                                 NO-LOCK NO-ERROR.
        ASSIGN
          Tsrcfile.pmod = IF AVAILABLE Tpmod-defs THEN
                            Tpmod-defs.pmod
                          ELSE
                            "". 
      END.  /* if rindex(tsrcfile.filename,".") = 0 */  
      ELSE IF R-INDEX(Tsrcfile.filename,".") > 0 AND
         CAN-FIND(FIRST Tpmod-defs WHERE Tpmod-defs.extension =
         SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,"."))) THEN DO:
         FIND FIRST Tpmod-defs WHERE Tpmod-defs.extension =
                  SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,".")) 
                  NO-LOCK NO-ERROR.
        ASSIGN
          Tsrcfile.pmod = IF AVAILABLE Tpmod-defs THEN
                            Tpmod-defs.pmod
                          ELSE
                            "".                                          
      END.  /* if can-find */
      ELSE IF Mpmod-decide = "any-file" THEN
        ASSIGN
          Tsrcfile.pmod = Mdef-pmod.        
      ELSE DO:           
        /* --- find default pmod --- */
        RUN get_def_pmod (INPUT Mpmod-prompt,
                          OUTPUT Mdef-pmod,
                          OUTPUT Mpmod-decide).  
                
        IF Mpmod-decide = "Later" THEN
          ASSIGN Mpmod-prompt = NO.
      
        IF Mpmod-decide = "this-extension" THEN DO:
          CREATE Tpmod-defs.
          ASSIGN
            Tpmod-defs.extension = IF INDEX(Tsrcfile.filename,".") = 0 THEN
                                     ""
                                   ELSE
                                     SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,"."))
            Tpmod-defs.pmod      = Mdef-pmod.
        END.  /* if mpmod-decide = "this-extension */          
        
        IF Mdef-pmod <> "" THEN
          ASSIGN Tsrcfile.pmod = Mdef-pmod.
  
      END.  /* else do */

    END. /* if tsrcfile.pmod = "" */
    
    IF Tsrcfile.sub-type = "" THEN DO:
      IF Msubtype-def-pmod = "" THEN
        ASSIGN  Msubtype-def-pmod = Mdef-pmod.
   
      /* --- determine and assign a subtype to this file --- */
      IF R-INDEX(Tsrcfile.filename,".") = 0 AND
         CAN-FIND(FIRST Tsubtype-defs WHERE Tsubtype-defs.extension = "") THEN DO:
         FIND FIRST Tsubtype-defs WHERE Tsubtype-defs.extension = "" 
                                 NO-LOCK NO-ERROR.
        ASSIGN
          Tsrcfile.sub-type = IF AVAILABLE Tsubtype-defs THEN
                                Tsubtype-defs.subtype
                              ELSE
                                "". 
 
      END.  /* if rindex(tsrcfile.filename,".") = 0 */  
      ELSE IF R-INDEX(Tsrcfile.filename,".") > 0 AND
         CAN-FIND(FIRST Tsubtype-defs WHERE Tsubtype-defs.extension =
         SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,"."))) THEN DO:
        
        FIND FIRST Tsubtype-defs WHERE Tsubtype-defs.extension =
                  SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,".")) 
                  NO-LOCK NO-ERROR.
        IF AVAILABLE Tsubtype-defs THEN DO: 
          /* --- ensure subtype with same extension is ok --- */
          RUN rtb/p/rtb_pnam.p (INPUT  "", /* no root path to get relative path names */ 
                                INPUT  Msubtype-def-pmod,
                                INPUT  Tsubtype-defs.subtype,
                                INPUT  Tsrcfile.filename,
                                INPUT  "PCODE",
                                OUTPUT Mparts,
                                OUTPUT Merror).
          ASSIGN
            Tsrcfile.sub-type = IF Merror = "" AND
                                   INDEX(REPLACE(Tsrcfile.fullpath,"~\","/"),
                                         REPLACE(ENTRY(1,Mparts),"~\","/")) > 0 THEN
                                  Tsubtype-defs.subtype
                               ELSE
                                 "".
        END.  /* if available tsubtype-defs */
        ELSE
          ASSIGN
            Tsrcfile.sub-type = "".
      END.  /* if can-find */
      ELSE IF Msubtype-decide = "any-file" THEN DO:

        /* --- ensure default subtype is ok --- */
        Tsrcfile.sub-type = IF fnValidSubtypeFile(Mdef-subtype,
                                                  Tsrcfile.filename,
                                                  Tsrcfile.extension,
                                                  Tsrcfile.subdir) THEN
                              Mdef-subtype
                            ELSE
                              "".
                                          
      END.  /* else if msubtype-decide = "any-file" */
      ELSE DO:
        /* --- find default subtype --- */
        RUN get_def_subtype (INPUT Msubtype-prompt,
                             OUTPUT Mdef-subtype,
                             OUTPUT Msubtype-decide).
                             
        IF Msubtype-decide = "Later" THEN
          ASSIGN Msubtype-prompt = NO.
          
        IF Msubtype-decide = "this-extension" THEN DO:
          CREATE Tsubtype-defs.
          ASSIGN
            Tsubtype-defs.extension = IF INDEX(Tsrcfile.filename,".") = 0 THEN
                                        ""
                                      ELSE
                                        SUBSTRING(Tsrcfile.filename,R-INDEX(Tsrcfile.filename,"."))
            Tsubtype-defs.subtype   = Mdef-subtype.
        END.  /* if subtype-decide = "this-extension */          
        
        IF Mdef-subtype <> "" THEN
          ASSIGN Tsrcfile.sub-type = Mdef-subtype.        
  
      END.  /* else do */  
      
      IF Tsrcfile.sub-type <> "" THEN
        RUN remove_subtype_parts (INPUT Tsrcfile.filename).

    END. /* if tsrcfile.sub-type = "" */
  
    Tsrcfile.defaults = YES.

  END.  /* for each tsrcfile */    

  /* --- refresh the browse --- */ 
  IF CAN-FIND(FIRST Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE) THEN
    ASSIGN
      Mret = BR-srcfile:REFRESH() IN FRAME {&FRAME-NAME}.  
    
  /* --- end wait state --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "").      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill_module_combo WINDOW-1 
PROCEDURE fill_module_combo :
/*------------------------------------------------------------------------------
  Purpose:     Fill Workspace Module combo with candidate workspace modules.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER Brtb_pmod FOR rtb.rtb_pmod.
  
  RUN set_session_wait IN Grtb-p-stat (INPUT "general").

  /* --- build list of modules --- */
  wspmod-loop:
  FOR EACH rtb.rtb_wspmod
    WHERE rtb.rtb_wspmod.wspace-id  = Grtb-wspace-id 
      AND rtb.rtb_wspmod.src-status <> "EXC" 
    NO-LOCK:
    IF rtb.rtb_system.dsite = 0 THEN DO:
      IF LENGTH(rtb.rtb_wspmod.pmod) >= 3 AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,1,1)) AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,2,1)) AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,3,1)) THEN
        NEXT wspmod-loop.                           
    END.  /* if rtb_system.dsite = 0 */
    ELSE IF SUBSTRING(rtb.rtb_wspmod.pmod,1,3)
                               <> STRING(rtb.rtb_system.dsite,"999") THEN
        NEXT wspmod-loop.    

    FIND Brtb_pmod WHERE Brtb_pmod.pmod = rtb.rtb_wspmod.pmod NO-LOCK NO-ERROR.

    IF AVAILABLE Brtb_pmod THEN DO WITH FRAME {&FRAME-NAME}:
      IF CB-module:LOOKUP(Brtb_pmod.module) = 0 THEN
        CB-module:ADD-LAST(Brtb_pmod.module).
    END. /* do with frame */
  
  END.  /* for each rtb_wspmod */

  RUN set_session_wait IN Grtb-p-stat (INPUT "general").

  /* --- Ensure at least one module exists --- */
  IF CB-module:NUM-ITEMS < 1 THEN DO:
    MESSAGE
      "Cannot run Module Load as no Modules have been defined.  Define
 at least one module and try again."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN "Cancel".
  END.  /* if num-entries(mtemp-list) < 1 */  

  ASSIGN CB-module:SCREEN-VALUE = CB-module:ENTRY(1).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill_subtype_combo WINDOW-1 
PROCEDURE fill_subtype_combo :
/*------------------------------------------------------------------------------
  Purpose:     Fill subtype combo with defined code subtypes.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH rtb.rtb_subtype NO-LOCK:
    CB-sub-type:ADD-LAST(rtb.rtb_subtype.sub-type) IN FRAME {&FRAME-NAME}. 
  END.
  
  CB-sub-type:SCREEN-VALUE = CB-sub-type:ENTRY(1).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE find_record WINDOW-1 
PROCEDURE find_record :
/* -----------------------------------------------------------
  Purpose:     Find an object in the objects table.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DEFINE BUFFER BTsrcfile FOR Tsrcfile.

  DEFINE VARIABLE Mstring      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mcurrent-row AS INTEGER   NO-UNDO.
  DEFINE VARIABLE Mrecid       AS RECID     NO-UNDO.


  /* --- Run StringGet for a machine to find --- */
  RUN rtb/p/rtb_sget.p
      ( INPUT  CURRENT-WINDOW ,
        INPUT  "Find Filename,Filename,x(100),40,,1957" ,
        OUTPUT Mstring ).
  IF RETURN-VALUE <> ""
  THEN RETURN.


  FIND FIRST BTsrcfile 
    WHERE BTsrcfile.module    = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      AND BTsrcfile.filename >= Mstring NO-LOCK NO-ERROR.
  IF NOT AVAILABLE BTsrcfile THEN DO:
    MESSAGE 
      SUBSTITUTE("'&1' was not found.",Mstring)
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if not available */

  ASSIGN
    Mrecid       = RECID(BTsrcfile)
    Mcurrent-row = CURRENT-RESULT-ROW("BR-srcfile").
  REPOSITION BR-srcfile TO RECID Mrecid NO-ERROR. 
  
  IF NOT AVAILABLE Tsrcfile THEN DO:
    MESSAGE 
      "Reposition of browse may be incorrect as a record was not found in
 current query."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    REPOSITION BR-srcfile TO ROW Mcurrent-row.
  END.  /* if not available tsrcfile */


END PROCEDURE.   /* --- Find record --- */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_alias WINDOW-1 
PROCEDURE get_alias :
/* -----------------------------------------------------------
  Purpose:     Get an alias name for a file who's name has already
               been used by an object in Roundtable.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DEFINE VARIABLE Mmessage        AS CHARACTER
    VIEW-AS EDITOR 
    INNER-LINES 5
    INNER-CHARS 50
    NO-UNDO.
  DEFINE VARIABLE Mobject         LIKE rtb.rtb_object.object NO-UNDO.
  DEFINE VARIABLE Mgo             AS LOGICAL INITIAL NO      NO-UNDO.
  DEFINE VARIABLE BT-ok           AS WIDGET-HANDLE           NO-UNDO.
  DEFINE VARIABLE BT-cancel       AS WIDGET-HANDLE           NO-UNDO.
  DEFINE VARIABLE BT-help         AS WIDGET-HANDLE           NO-UNDO.

  DEFINE FRAME dialog-frame
    Mmessage
      AT ROW 2 COL 4
      NO-LABEL 
    Mobject
      VIEW-AS FILL-IN
      FORMAT "x(40)"
      AT ROW 6.5 COL 6
      LABEL "Alias"
  WITH
    VIEW-AS DIALOG-BOX
    SIZE 60 BY 11
    THREE-D
    TITLE Malert-title
    SIDE-LABELS
    FONT 4.


  IF NOT AVAILABLE Tsrcfile THEN RETURN.
 
  ASSIGN
    Mmessage = SUBSTITUTE("Filename '&1' has already been used as the name
 of an object in Roundtable.  To register this file in Roundtable, you have
 to use an 'alias' for the new object name.  An alias is any name that
 begins with the '@' character.",Tsrcfile.filename).


  CREATE WIDGET-POOL.

  /* --- Set up standard OK/Cancel/Help --- */
  RUN make_def_ok_cancel IN Grtb-p-library (INPUT  FRAME dialog-frame:HANDLE ,
                                            OUTPUT BT-ok,
                                            OUTPUT BT-Cancel,
                                            OUTPUT BT-Help).

  /* --- Help trigger --- */
  ON HELP OF FRAME dialog-frame OR CHOOSE OF BT-help DO:
    SYSTEM-HELP Grtb-help-file CONTEXT 1498.
  END.  /* on help */

  ON GO OF FRAME dialog-frame DO:
    ASSIGN FRAME dialog-frame Mobject.
    IF NOT Mobject BEGINS "@" THEN DO:
      MESSAGE 
        "Aliased object names must begin with '@'.  Enter a new alias name
 and try again."
        VIEW-AS ALERT-BOX ERROR
        TITLE Malert-title.
      RETURN NO-APPLY.
    END.
    IF CAN-FIND( FIRST rtb.rtb_object
                 WHERE rtb.rtb_object.wspace-id = Grtb-wspace-id
                   AND rtb.rtb_object.obj-type  = "PCODE"
                   AND rtb.rtb_object.object    = Mobject )
    THEN DO:
      MESSAGE 
        SUBSTITUTE("Aliased object already exists with name '&1'.  Enter a
 new alias name and try again.",Mobject)
        VIEW-AS ALERT-BOX ERROR
        TITLE Malert-title.
      RETURN NO-APPLY.
    END.
    ASSIGN Mgo   = YES.
  END.

  ENABLE ALL WITH FRAME dialog-frame.
   ASSIGN
     Mmessage:READ-ONLY IN FRAME dialog-frame = YES.
  DISPLAY
    Mmessage
  WITH FRAME dialog-frame.
  
  ASSIGN
    Mobject:SCREEN-VALUE = '@' + Tsrcfile.filename.

  DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
    WAIT-FOR WINDOW-CLOSE, GO OF FRAME dialog-frame.
  END.
  HIDE FRAME dialog-frame.
  DELETE WIDGET-POOL.

  IF NOT Mgo THEN RETURN "Cancel".
  
  ASSIGN
    Tsrcfile.object = Mobject.

  RETURN.

END PROCEDURE.  /* --- get_alias --- */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_def_pmod WINDOW-1 
PROCEDURE get_def_pmod :
/*------------------------------------------------------------------------------
  Purpose:  get a default pmod for the build.   
  Parameters:  INPUT  Ppmod-prompt - Prompt for pmod?
               OUTPUT Pdef-pmod    - Default pmod for object
               OUTPUT Ppmod-decide - "this file", "later", or "any file"
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER Ppmod-prompt AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER Pdef-pmod    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER Ppmod-decide AS CHARACTER NO-UNDO.

  DEFINE VARIABLE Mmessage      AS CHARACTER EXTENT 4 FORMAT "x(60)"
                                VIEW-AS TEXT                        NO-UNDO.
  DEFINE VARIABLE Mobject-name  AS CHARACTER VIEW-AS TEXT           NO-UNDO.
  DEFINE VARIABLE Mshow-dialog  AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE Mlist         AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE BT-Ok3        AS HANDLE                           NO-UNDO.
  DEFINE VARIABLE BT-Help3      AS HANDLE                           NO-UNDO.
  DEFINE VARIABLE BT-Cancel3    AS HANDLE                           NO-UNDO.

  DEFINE VARIABLE Muse-for      AS CHARACTER                        NO-UNDO
       VIEW-AS RADIO-SET
       RADIO-BUTTONS 
       "Use this Product Module for this file only","this-file",
       "Use this Product Module for all files with the same extension","this-extension",
       "Use this Product Module for any files with no other default","any-file".

  DEFINE VARIABLE CB-pmod AS CHARACTER FORMAT "x(20)"               NO-UNDO
       VIEW-AS COMBO-BOX
       SIZE 24 BY 1.1
       SORT
       INNER-LINES 5.


  DEFINE FRAME pmod-frame
    SKIP(.5)
    SPACE(4) 
    Mobject-name
      FORMAT "x(50)"
    SKIP(.5)
    SPACE(4)
    Mmessage[1]
    SKIP
    SPACE(4)
    Mmessage[2]
    SKIP
    SKIP(.5)
    SPACE(12)
    CB-pmod
    SKIP(.5)
    SPACE(4)
    Muse-for
    SPACE(15)
    SKIP(3)
  WITH THREE-D
    NO-LABELS
    TITLE Malert-title
    FONT 4
    VIEW-AS DIALOG-BOX.

  
  IF NOT AVAILABLE Tsrcfile THEN DO:
    ASSIGN
      Pdef-pmod    = ""
      Ppmod-decide = "this-file".
    RETURN.
  END.  /* if not available tsrcfile */
  

  /* --- build module combo box --- */
  FOR EACH rtb.rtb_wspmod
    WHERE rtb.rtb_wspmod.wspace-id  = Grtb-wspace-id 
      AND rtb.rtb_wspmod.src-status = "PRI"
      AND (Mmodule = ""
           OR CAN-FIND(FIRST rtb.rtb_pmod
                          WHERE rtb.rtb_pmod.pmod   = rtb.rtb_wspmod.pmod
                            AND rtb.rtb_pmod.module = Mmodule))
    NO-LOCK:
    
    IF rtb.rtb_system.dsite = 0 THEN DO:
      IF LENGTH(rtb.rtb_wspmod.pmod) >= 3 AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,1,1)) AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,2,1)) AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,3,1)) THEN
        NEXT.                           
    END.  /* if rtb_system.dsite = 0 */
    ELSE IF SUBSTRING(rtb.rtb_wspmod.pmod,1,3)
                               <> STRING(rtb.rtb_system.dsite,"999") THEN
        NEXT.    
    
    ASSIGN 
      Mlist = IF Mlist = "" THEN
                rtb.rtb_wspmod.pmod
              ELSE
                Mlist + "," + rtb.rtb_wspmod.pmod.
  END.  /* for each rtb_wspmod */
    
  FOR EACH rtb.rtb_wspmod
    WHERE rtb.rtb_wspmod.wspace-id = Grtb-wspace-id 
      AND rtb.rtb_wspmod.src-status = "INC"
      AND (Mmodule = ""
           OR CAN-FIND(FIRST rtb.rtb_pmod
                          WHERE rtb.rtb_pmod.pmod   = rtb.rtb_wspmod.pmod
                            AND rtb.rtb_pmod.module = Mmodule ))
    NO-LOCK:

    IF rtb.rtb_system.dsite = 0 THEN DO:
      IF LENGTH(rtb.rtb_wspmod.pmod) >= 3 AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,1,1)) AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,2,1)) AND
         CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(rtb.rtb_wspmod.pmod,3,1)) THEN
        NEXT.
    END.  /* if rtb_system.dsite = 0 */
    ELSE IF SUBSTRING(rtb.rtb_wspmod.pmod,1,3)
                               <> STRING(rtb.rtb_system.dsite,"999") THEN
        NEXT.

    ASSIGN 
      Mlist = IF Mlist = "" THEN
                rtb.rtb_wspmod.pmod
              ELSE
                Mlist + "," + rtb.rtb_wspmod.pmod.
  END.  /* for each rtb_wspmod */     
    
  ASSIGN
    CB-pmod:LIST-ITEMS = Mlist.

  IF NUM-ENTRIES(CB-pmod:LIST-ITEMS IN FRAME pmod-frame) = ? OR
     NUM-ENTRIES(CB-pmod:LIST-ITEMS IN FRAME pmod-frame) = 0 THEN DO:
    ASSIGN
      Ppmod-decide = "Later".
    RETURN.
  END.  /* if num-entries(cb-pmod ... */
      
  IF NUM-ENTRIES(CB-pmod:LIST-ITEMS IN FRAME pmod-frame) = 1 THEN DO:
    ASSIGN
      Ppmod-decide      = "any-file"
      Pdef-pmod         = ENTRY(1,CB-pmod:LIST-ITEMS IN FRAME pmod-frame).
    RETURN.
  END.  /* if num-entries(cb-pmod ... */  

  IF Ppmod-prompt = YES THEN DO:
  
    ASSIGN
      Mmessage[1]          = "More than one possible Product Module was found."
      Mmessage[2]          = "Please select a Product Module:"
      Mobject-name         = Tsrcfile.filename
      CB-pmod:SCREEN-VALUE = ENTRY(1,CB-pmod:LIST-ITEMS)
      CB-pmod:LIST-ITEMS   = "," + CB-pmod:LIST-ITEMS.
  
  
    /* --- Make OK,Create,Help buttons appear in frame --- */
    RUN make_def_ok_cancel IN Grtb-p-library (INPUT  FRAME pmod-frame:HANDLE,
                                              OUTPUT BT-Ok3,
                                              OUTPUT BT-Cancel3,
                                              OUTPUT BT-Help3).
  
    /* --- help trigger. --- */
    ON HELP OF FRAME pmod-frame OR CHOOSE OF BT-help3 DO:
      SYSTEM-HELP Grtb-help-file CONTEXT 722.
    END.  /* on help */
  
    /* --- make the Cancel button to be the "Decide Later" button --- */
    ASSIGN
      BT-Cancel3:LABEL = "Decide Later"
      BT-Cancel3:WIDTH = 18.
  
  
    DISPLAY
      Mobject-name
      Mmessage[1]
      Mmessage[2]
      CB-pmod
    WITH FRAME pmod-frame.
    
    ENABLE ALL WITH FRAME pmod-frame.
    
    /* --- on go trigger --- */
    ON GO OF FRAME pmod-frame DO:
      ASSIGN
        Pdef-pmod    = IF CB-pmod:SCREEN-VALUE = ? THEN
                         ""
                       ELSE
                         CB-pmod:SCREEN-VALUE
        Ppmod-decide = Muse-for:SCREEN-VALUE.
    END.  /* on go of frame */
    
    /* --- on window close --- */
    ON WINDOW-CLOSE OF FRAME pmod-frame
      ASSIGN
        Ppmod-decide = "Later".        
        
    /* --- cancel trigger --- */
    ON CHOOSE OF BT-Cancel3
      APPLY "WINDOW-CLOSE" TO FRAME pmod-frame.
      
    /* --- end wait state --- */
    RUN set_session_wait IN Grtb-p-stat (INPUT "").         
    
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
      WAIT-FOR GO, WINDOW-CLOSE OF FRAME pmod-frame.
    END.
    
    HIDE FRAME pmod-frame.

  END. /* if ppmod-prompt */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_def_subtype WINDOW-1 
PROCEDURE get_def_subtype :
/*------------------------------------------------------------------------------
  Purpose:  get a default subtype for the build process.   
  Parameters:  INPUT  Psubtype-prompt - Prompt for subtype?
               OUTPUT Pdef-subtype    - default subtype for object
               OUTPUT Psubtype-decide = "this file", "later", or "any file"
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER Psubtype-prompt AS LOGICAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER Pdef-subtype    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER Psubtype-decide AS CHARACTER NO-UNDO.

  DEFINE VARIABLE Mmessage        AS CHARACTER EXTENT 4 FORMAT "x(60)"
                                  VIEW-AS TEXT                      NO-UNDO.
  DEFINE VARIABLE Mobject-name    AS CHARACTER VIEW-AS TEXT         NO-UNDO.
  DEFINE VARIABLE Mshow-dialog    AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE Mvalid          AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE Mtemp-valid     AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE Mparts          AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE Mcounter        AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE Mi              AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE Mx              AS INTEGER                        NO-UNDO.  
  DEFINE VARIABLE Mnum-parts      AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE BT-Ok2          AS HANDLE                         NO-UNDO.
  DEFINE VARIABLE BT-Help2        AS HANDLE                         NO-UNDO.
  DEFINE VARIABLE BT-Cancel2      AS HANDLE                         NO-UNDO.
  DEFINE VARIABLE Mkeep           AS LOGICAL                        NO-UNDO.

  DEFINE VARIABLE Muse-for        AS CHARACTER                      NO-UNDO
       VIEW-AS RADIO-SET
       RADIO-BUTTONS 
       "Use this Subtype for this file only" , "this-file" ,
       "Use this Subtype for all files with the same extension" , "this-extension" ,
       "Use this Subtype for any files with no other default" , "any-file".

  DEFINE VARIABLE CB-subtype AS CHARACTER FORMAT "x(12)"  NO-UNDO
       VIEW-AS COMBO-BOX
       SIZE 24 BY 1
       SORT
       INNER-LINES 5.

  
  DEFINE FRAME subtype-frame
    SKIP(.5)
    SPACE(4) Mobject-name  FORMAT "x(50)"
    SKIP(.5)
    SPACE(4)
    Mmessage[1]
    SKIP
    SPACE(4)
    Mmessage[2]
    SKIP
    SKIP(.5)
    SPACE(12)
    CB-subtype
    SKIP(.5)
    SPACE(4)
    Muse-for
    SPACE(15)
    SKIP(3)
  WITH THREE-D
    NO-LABELS
    TITLE Malert-title
    FONT 4
    VIEW-AS DIALOG-BOX. 
         
  

  /* --- build a list of subtypes --- */

  /* --- Start with a complete list of subtypes and eliminate each time
         one does not match for an object --- */   
  FOR EACH rtb.rtb_subtype NO-LOCK:
    ASSIGN
      Mvalid = IF Mvalid = "" THEN
                 rtb.rtb_subtype.sub-type
               ELSE
                 Mvalid + "," + rtb.rtb_subtype.sub-type.
  END.  /* for each rtb.rtb_subtype */

  /* --- find non valid subtypes and remove then from the valid list --- */
  FOR EACH rtb.rtb_subtype NO-LOCK:
    
    /* --- ensure the tsrcfile record matchs subtype extension, suffix and
           subdirectory --- */           
    Mkeep = fnValidSubtypeFile(rtb.rtb_subtype.sub-type,
                                 Tsrcfile.filename,
                                 Tsrcfile.extension,
                                 Tsrcfile.subdir).
    IF NOT Mkeep THEN DO:
      /* --- not a valid subtype, remove subtype from list --- */
      ASSIGN
        Mtemp-valid = Mvalid.
      DO Mx = 1 TO NUM-ENTRIES(Mvalid):
        IF ENTRY(Mx,Mvalid) = rtb.rtb_subtype.sub-type THEN
          ASSIGN
            ENTRY(Mx,Mtemp-valid) = "".
      END.  /* do Mx = 1 to num-entries(mvalid) */
      ASSIGN
        Mvalid = REPLACE(Mtemp-valid,",,",",").
      IF LENGTH(Mvalid) > 0 AND SUBSTRING(Mvalid,1,1) = "," THEN
        ASSIGN
          Mvalid = SUBSTRING(Mvalid,2).
      IF LENGTH(Mvalid) > 0 AND SUBSTRING(Mvalid,LENGTH(Mvalid),1) = "," THEN
        ASSIGN
          Mvalid = SUBSTRING(Mvalid,1,LENGTH(Mvalid) - 1).
          
    END.  /* not mkeep */
    
    IF Mvalid = "" THEN
      LEAVE.      

  END.  /* for each rtb_subtype */
    
  ASSIGN 
    CB-subtype:LIST-ITEMS = Mvalid.

  IF NUM-ENTRIES(CB-subtype:LIST-ITEMS IN FRAME subtype-frame) = ? OR
     NUM-ENTRIES(CB-subtype:LIST-ITEMS IN FRAME subtype-frame) = 0 THEN DO:
    ASSIGN
      Pdef-subtype    = ""
      Psubtype-decide = "this-file".
    RETURN.
  END.  /* if num-entries(cb-subtype ... */

  /* Subtype with the most parts present takes the cake */
  DO Mi = 1 TO (CB-Subtype:NUM-ITEMS - 1):
    DO Mx = 2 TO CB-Subtype:NUM-ITEMS:
      IF fnSubtypePartsCount(CB-Subtype:ENTRY(Mi)) >
         fnSubtypePartsCount(CB-Subtype:ENTRY(Mx)) THEN
        CB-Subtype:DELETE(Mx).
    END.
  END.

  IF NUM-ENTRIES(CB-subtype:LIST-ITEMS IN FRAME subtype-frame) = 1 THEN DO:
    ASSIGN
      Pdef-subtype    = CB-subtype:ENTRY(1) IN FRAME subtype-frame
      Psubtype-decide = "this-file".
    RUN remove_subtype_parts (Tsrcfile.filename).
    RETURN.
  END.  /* if num-entries(cb-subtype ... */  

  IF Psubtype-prompt = YES THEN DO:
  
    ASSIGN
      Mmessage[1]             = "More than one possible Subtype was found."
      Mmessage[2]             = "Please select a Subtype:"
      Mobject-name            = Tsrcfile.filename
      CB-subtype:SCREEN-VALUE = ENTRY(1,CB-subtype:LIST-ITEMS)
      CB-subtype:LIST-ITEMS   = "," + CB-subtype:LIST-ITEMS.
  
  
    /* --- Make OK,Create,Help buttons appear in frame --- */
    RUN make_def_ok_cancel IN Grtb-p-library (INPUT  FRAME subtype-frame:HANDLE,
                                              OUTPUT BT-Ok2,
                                              OUTPUT BT-Cancel2,
                                              OUTPUT BT-Help2).
  
    /* --- help trigger. --- */
    ON HELP OF FRAME subtype-frame OR CHOOSE OF BT-help2 DO:
      SYSTEM-HELP Grtb-help-file CONTEXT 722.
    END.  /* on help */
  
    /* --- Hack the Cancel Button --- */
    ASSIGN
      BT-Cancel2:LABEL = "Decide Later"
      BT-Cancel2:WIDTH = 18.
  
    /* --- wait --- */
    DISPLAY
      Mobject-name
      Mmessage[1]
      Mmessage[2]
      CB-subtype
    WITH FRAME subtype-frame.
    
    ENABLE ALL WITH FRAME subtype-frame.
      
    /* --- on go trigger --- */
    ON GO OF FRAME subtype-frame DO:
      ASSIGN
        Pdef-subtype    = IF CB-subtype:SCREEN-VALUE = ? THEN
                            ""
                          ELSE
                            CB-subtype:SCREEN-VALUE
        Psubtype-decide = Muse-for:SCREEN-VALUE.
    END.  /* on go of frame */
    
    /* --- on window close --- */
    ON WINDOW-CLOSE OF FRAME subtype-frame
      ASSIGN
        Psubtype-decide = "Later".        
        
    /* --- cancel trigger --- */
    ON CHOOSE OF BT-Cancel2
      APPLY "WINDOW-CLOSE" TO FRAME subtype-frame.  
  
    /* --- end wait state --- */
    RUN set_session_wait IN Grtb-p-stat (INPUT "").  
    
    DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:
      WAIT-FOR GO, WINDOW-CLOSE OF FRAME subtype-frame.
    END.
    
    HIDE FRAME subtype-frame.

  END. /* if psubtype-prompt */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_part_names WINDOW-1 
PROCEDURE get_part_names :
/*------------------------------------------------------------------------------
  Purpose:     Determine part names for specified object type and subtype.
  Parameters:  INPUT  Proot-path - Root path for object parts
               INPUT  Pwsmod     - Workspace module for object
               INPUT  Psub-type  - Code subtype for object
               INPUT  Pobjname   - Name for object
               INPUT  Pobj-type  - Object type for object
               OUTPUT Pparts     - Partnames for object
               OUTPUT Perror     - Error (if any)
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER Proot-path  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER Pwsmod      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER Psub-type   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER Pobjname    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER Pobj-type   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER Pparts      AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER Perror      AS CHARACTER NO-UNDO.
  
  /* Define Locals */
  DEFINE VARIABLE Mi        AS INTEGER NO-UNDO.
  DEFINE VARIABLE Mdot      AS INTEGER NO-UNDO.
  DEFINE VARIABLE Mext      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mobj-name AS CHARACTER NO-UNDO.
  
  
  FIND rtb.rtb_moddef WHERE rtb.rtb_moddef.module = Pwsmod NO-LOCK NO-ERROR.
  
  IF AVAILABLE rtb.rtb_moddef THEN
  parts-block:
  DO:
    IF Pobj-type = "doc" THEN DO:
      /* Generate name for objects having sub-type of "doc" */
      Pparts = (IF Proot-path <> "" THEN
                  Proot-path + "/"
                ELSE "")
               + (IF rtb.rtb_moddef.directory <> "" THEN
                    rtb.rtb_moddef.directory + "/"
                  ELSE "")
               + "doc/" 
               + Pobjname.
       
    END.
    ELSE DO:
      FIND rtb.rtb_subtype WHERE rtb.rtb_subtype.sub-type = Psub-type
        NO-LOCK NO-ERROR.
      IF AVAILABLE rtb.rtb_subtype THEN DO:
    
        /* Check extension of Pobjname for correctness */
        IF rtb.rtb_subtype.part-ext[1] <> "" THEN DO:
          Mext = IF R-INDEX(Pobjname,".") > 0 
                    AND R-INDEX(Pobjname,".") < LENGTH(Pobjname) THEN
                   SUBSTRING(Pobjname,R-INDEX(Pobjname,".") + 1)
                 ELSE
                   "".
          IF Mext <> rtb.rtb_subtype.part-ext[1] THEN DO:
              Perror = SUBSTITUTE("Object name '&1' has a bad extension.",Pobjname).
            LEAVE parts-block. 
          END.
        END.
    
        /* Remove extension (if any) from Pobjname to get Mobj-name */
        Mdot = INDEX(Pobjname,".") - 1.
        ASSIGN Mobj-name = IF Mdot > 0 THEN
                             SUBSTRING(Pobjname,1,Mdot)
                           ELSE
                             Pobjname.
    
        /* Now check and remove suffix from Mobj-name if any */
        IF rtb.rtb_subtype.part-sufix[1] <> "" THEN DO:
          IF SUBSTRING(Mobj-name,LENGTH(Mobj-name) 
             - LENGTH(rtb.rtb_subtype.part-sufix[1]) + 1) <> rtb.rtb_subtype.part-sufix[1] THEN DO:
            Perror = SUBSTITUTE("Object name '&1' has a bad suffix.",Mobj-name).
            LEAVE parts-block.
          END.
        
          Mobj-name = SUBSTRING(Mobj-name,1,LENGTH(Mobj-name) 
                      - LENGTH(rtb.rtb_subtype.part-sufix[1])).
        END.
    
        /* Mobj-name is now the base name from which other part names will be 
           constructed.  */
        DO Mi = 1 TO 10:
           IF rtb.rtb_subtype.part[Mi] = "" THEN LEAVE.
        
           IF Mi > 1 THEN Pparts = Pparts + ",".
        
           Pparts = Pparts 
                  + (IF Proot-path <> "" 
                        THEN Proot-path + "/"
                        ELSE "")
                  + (IF rtb.rtb_moddef.directory <> "" 
                       THEN rtb.rtb_moddef.directory + "/"
                       ELSE "")
                  + (IF rtb.rtb_subtype.part-dir[Mi] <> "" 
                        THEN rtb.rtb_subtype.part-dir[Mi] + "/"
                        ELSE "").
        
           IF Mi = 1 THEN 
              Pparts = Pparts + Pobjname. /* Used because we may not know extension!*/
           ELSE 
              Pparts = Pparts 
                     + Mobj-name
                     + rtb.rtb_subtype.part-sufix[Mi]
                     + (IF rtb.rtb_subtype.part-ext[Mi] <> "" 
                           THEN "." + rtb.rtb_subtype.part-ext[Mi]
                           ELSE "").
        
           IF NOT AVAILABLE rtb.rtb_subtype THEN LEAVE parts-block.
      
        END.
      END. /* available rtb_subtype */
      ELSE 
        Perror = SUBSTITUTE("Subtype '&1' does not exist.",Psub-type).
    
    END. /* Pobj-type = doc */
  
  END. /* parts-block */
  ELSE
    Perror = SUBSTITUTE("Module definition '&1' does not exist.",Pwsmod).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load_files WINDOW-1 
PROCEDURE load_files :
/*------------------------------------------------------------------------------
  Purpose: Load all selected files.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE Mparts        AS CHARACTER                  NO-UNDO. 
  DEFINE VARIABLE Mleave-prog   AS LOGICAL INITIAL NO         NO-UNDO.
  DEFINE VARIABLE Mx            AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE M15           AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE Mwrx-filename AS CHARACTER                  NO-UNDO.
  DEFINE VARIABLE Mwrx-dirname  AS CHARACTER                  NO-UNDO.
  DEFINE VARIABLE Mwrx-regasone AS LOGICAL                    NO-UNDO.
  DEFINE VARIABLE Mwrx-pathname AS CHARACTER                  NO-UNDO.

  DEFINE VARIABLE Mpmod       LIKE rtb.rtb_ver.pmod           NO-UNDO.
  DEFINE VARIABLE Msubtype    LIKE rtb.rtb_ver.sub-type       NO-UNDO.
  DEFINE VARIABLE Mobject     LIKE rtb.rtb_object.object      NO-UNDO.
  DEFINE VARIABLE Mgroup      LIKE rtb.rtb_object.obj-group   NO-UNDO.
  DEFINE VARIABLE Mlevel      LIKE rtb.rtb_object.group-level NO-UNDO.   

  /* --- ensure there are selected files in the browse --- */
  IF Br-Srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 
      "Cannot load files as no file has been selected in the browse."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.     
  
  /* --- Check security --- */
  IF NOT CAN-DO(Grtb-access,"PCODE-OBJECTS") THEN DO:
    MESSAGE
      "You do not have the required user security access to add PCODE
 objects.  Contact the System Administrator to change security privileges
 if this functionality is necessary."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if merror <> "" */
 
  /*- Check to see if editing is allowed -*/
  RUN rtb/p/rtb_edok.p (INPUT  "PCODE",
                        OUTPUT Merror).
  
  IF Merror <> "" THEN DO:
    MESSAGE 
      Merror
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if merror <> "" */
                                        
  /*- ensure user wants to continue -*/
  MESSAGE
    "Loading selected files may take a long time."
    SKIP(1)
    "Continue?"
    VIEW-AS ALERT-BOX WARNING
    BUTTON YES-NO
    TITLE Malert-title
    UPDATE Mcontinue.
  
  IF NOT Mcontinue THEN
    RETURN.         

  /* Dynamics Enhancements - BEGIN */
  IF lICFRunning
  THEN DO:
    DEFINE VARIABLE cErrorPre AS CHARACTER  NO-UNDO.
    ASSIGN
      cErrorPre = "":U.
    RUN load_files_icf_pre (OUTPUT cErrorPre).
    IF cErrorPre <> "":U
    THEN RETURN.
  END.
  /* Dynamics Enhancements - END */

  /* --- start wait state --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "general").    

  DO Mi = 1 TO Br-Srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    
    /*- scroll browse to first highlighted row -*/
    Mret = Br-Srcfile:SCROLL-TO-SELECTED-ROW(Mi).

    /*- retrieve record associated with row -*/
    Mret = Br-Srcfile:FETCH-SELECTED-ROW(Mi).    
    
    /* - inform user if it's already done - */
    IF Tsrcfile.obj-status = "Done" THEN
      NEXT.

    /* --- Does this have to be an aliased object? ---
     * This was decided during the build.  If the file's name was
     * already used as an object name, then the object has to be aliased.
     * First, we get the list of file parts.
     * ----------------------------------------------- */
    ASSIGN Mparts = "".
    IF Tsrcfile.object <> Tsrcfile.filename THEN DO:

      RUN rtb/p/rtb_pnam.p
          ("", /* Pass no root path to get relative path names */
           Tsrcfile.pmod,
           Tsrcfile.sub-type,
           Tsrcfile.filename,
           "PCODE",
           OUTPUT Mparts,
           OUTPUT Merror).
      
      IF Merror <> "" THEN DO:
        MESSAGE 
           Merror
           VIEW-AS ALERT-BOX ERROR
           TITLE Malert-title.
        RUN set_session_wait IN Grtb-p-stat (INPUT "").         
        NEXT.                                       
      END.  /* Merror <> "" */


      /* ------------  begin possible alias customization  --------------- */

      /* 
      You are in this part of module load becuase you have a duplicate 
      file name (object names in RTB are uniques, so you must give the object
      a unique logical name).  The following call to get_alias will prompt 
      you for an alias name. You should use a good naming convention such as 
      @program.p-modname or @program-modname.p.  
      
      Alternatively, you can have module load automatically name the aliased
      objects for you.  Change the following statement from "RUN get_alias" 
      to "RUN build_alias" and remove the message statement if the return-value
      is not blank.  Module load will then build the names using the
      file name and the module name (@program.p-module).
      
      Always check the <temp-dir>/rtbload.txt file after running module load
      if you use this customization.
      */

      RUN get_alias.  /* RUN build_alias. */

      IF RETURN-VALUE <> "" THEN DO:

        /* remove this message if you run build_alias in place of get_alias */
        MESSAGE
          SUBSTITUTE("'&1' was not loaded.",Tsrcfile.filename)
          SKIP(1)
          "Continuing with load."
          VIEW-AS ALERT-BOX ERROR
          TITLE Malert-title.

      /* ------------  end possible alias customization  ----------------- */

        /* --- start wait state --- */
        RUN set_session_wait IN Grtb-p-stat (INPUT "").
        NEXT.                                       
      END.  /* if return-value <> "" */
    
    END.  /* if tsrcfile.object <> tsrcfile.filename */

    ASSIGN Mpmod    = Tsrcfile.pmod
           Msubtype = Tsrcfile.sub-type
           Mobject  = Tsrcfile.object
           Mgroup   = Tsrcfile.obj-group
           Mlevel   = Tsrcfile.group-level.

    
    /* --- run the "Add new object" dialog --- */        
    RUN rtb/w/rtb0222c.w
       (BUFFER Brtb_object,           /* output buffer */
        INPUT  "",                    /* title not required */
        INPUT  Mmodule,
        INPUT  Mpmod,
        INPUT  "PCODE",
        INPUT  Msubtype,
        INPUT  Mobject,
        INPUT  Mgroup,
        INPUT  Mlevel, 
        INPUT  Mparts,                /* Object file parts if aliased, else blank */
        INPUT  "All" ,                /* don't show the New Object dialog */
        OUTPUT Merror).

    IF Merror > "" OR NOT AVAILABLE Brtb_object THEN DO:
      MESSAGE
        SUBSTITUTE("Cannot create an object for '&1'.",Mobject).
     
      /* --- end wait state --- */
      RUN set_session_wait IN Grtb-p-stat (INPUT "").
      UNDO, NEXT.                                       
    END.  /* if merror > "" */

    /*- Check for existence of .WRX in working directory of the same name as pObject and offer -*/
    /*- it to the user as the matching *.WRX object for the PCODE object.                      -*/

    RUN rtb/p/rtb_nams.p (INPUT RECID(Brtb_object),
                          INPUT "",
                          OUTPUT Mwrx-pathname,
                          OUTPUT Merror).

    ASSIGN /*- first entry in parts list (Mwrx-pathname) -*/
           Mwrx-pathname = ENTRY(1,Mwrx-pathname)   
           Mwrx-filename = Mwrx-pathname
           /*- file name with no directory -*/
           Mwrx-filename = SUBSTRING(Mwrx-filename,R-INDEX(Mwrx-filename,"/") + 1)
           /*- replace extension with .wrx -*/
           Mwrx-filename = SUBSTRING(Mwrx-filename,1,INDEX(Mwrx-filename,".") - 1) + ".wrx".
    
    ASSIGN /*- relative directory -*/
           Mwrx-dirname = IF INDEX(Mwrx-pathname,"/") > 0 THEN
                             SUBSTRING(Mwrx-pathname,1,R-INDEX(Mwrx-pathname,"/") - 1)
                          ELSE
                             "".
    
    ASSIGN FILE-INFO:FILE-NAME = IF Mwrx-dirname <> "" THEN
                                    Mwrx-dirname + "/" + Mwrx-filename
                                 ELSE
                                    Mwrx-filename.

    ASSIGN Mwrx-regasone = FALSE.
    
    /* ---------------  begin possible wrx customization --------------- */

    /* 
    To always register wrx files when they are found, replace this entire
    blcok with:
            
    IF FILE-INFO:PATHNAME <> ? THEN ASSIGN Mwrx-regasone = TRUE.
    */

    IF FILE-INFO:PATHNAME <> ? THEN DO:
      RUN rtb/p/rtb_wrxf.p (INPUT Mobject,
                            INPUT Mwrx-dirname,
                            INPUT Mwrx-filename,
                            OUTPUT Mwrx-regasone).
    END. /*- pathname <> ? -*/


    /* ---------------  end possible wrx customization ----------------- */

    /* --- find version record and update version description --- */
    FIND Brtb_ver OF Brtb_object EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF AVAILABLE Brtb_ver THEN DO: 
      DO Mx = 1 TO 16:
        IF NUM-ENTRIES(Tsrcfile.detailed-desc,CHR(10)) >= Mx THEN
          ASSIGN Brtb_ver.text-desc[Mx] = ENTRY(Mx,Tsrcfile.detailed-desc,CHR(10) ).
        ELSE 
          ASSIGN Brtb_ver.text-desc[Mx] = "".
        IF Mx < 16 THEN
          ASSIGN M15 = INDEX(Tsrcfile.detailed-desc,CHR(10),M15 + 1).
      END.  /* do mx = 1 to 16 */
      IF NUM-ENTRIES(Tsrcfile.detailed-desc,CHR(10)) > 16 THEN
        ASSIGN
          Brtb_ver.text-desc[16] = SUBSTRING(Tsrcfile.detailed-desc,M15 + 1).
      ASSIGN
        Brtb_ver.description = Tsrcfile.summary-desc.

      /*- If *.wrx and *.w and registered together then... -*/
      IF Mwrx-regasone = TRUE THEN DO:
        ASSIGN Brtb_ver.parts-used[10] = YES
               Brtb_ver.ppath[10]      = Mwrx-dirname
               Brtb_ver.pname[10]      = Mwrx-filename.
      
        /* create physical names records */
        RUN rtb/p/rtb_mnam.p (INPUT RECID(Brtb_object),
                              OUTPUT Merror ).

        IF Merror <> "" THEN DO:
          MESSAGE 
            Merror
            VIEW-AS ALERT-BOX ERROR
            TITLE Malert-title.
          UNDO, NEXT.
        END.  /* if merror <> "" */
        
      END. /* Mwrx-regasone */

      FIND Brtb_ver OF Brtb_object NO-LOCK NO-ERROR.
    END.  /* if available brtb_ver */

    /* --- Get our new object values --- */
    FIND rtb.rtb_ver OF Brtb_object NO-LOCK.
     
    ASSIGN
      Tsrcfile.obj-status  = "Done"
      Tsrcfile.object      = Brtb_object.object.
  
    /* --- Display file --- */  
    DISPLAY
      Tsrcfile.obj-status
      Tsrcfile.filename
    WITH BROWSE BR-srcfile.

  END.  /*- each selected row -*/

  /* Dynamics Enhancements - BEGIN */
  IF lICFRunning
  THEN DO:
    DEFINE VARIABLE cErrorPost AS CHARACTER  NO-UNDO.
    ASSIGN
      cErrorPost = "":U.
    RUN load_files_icf_post (OUTPUT cErrorPost).
    IF cErrorPost <> "":U
    THEN RETURN.
  END.
  /* Dynamics Enhancements - END */

  /*- refresh the browse -*/ 
  ASSIGN Mret = BR-srcfile:REFRESH() IN FRAME {&FRAME-NAME}.
  
  /* --- end wait state --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "").    

  APPLY "ENTRY" TO BR-srcfile IN FRAME {&FRAME-NAME}. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load_files_icf_post WINDOW-1 
PROCEDURE load_files_icf_post :
/*------------------------------------------------------------------------------
  Purpose:     Dynamics Enhancements
  Parameters:  <none>
  Notes:       Post events, after files have been loaded
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER opError     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRTBProductModule   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSCMProductModule   AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cRTBProductModule = CB-module:SCREEN-VALUE
      cSCMProductModule = CB-module:SCREEN-VALUE.
  END.

  IF VALID-HANDLE(gshSessionManager)
  THEN DO:

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPLOADNO":U
                         ,INPUT  cRTBProductModule
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).
                         
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPLOADYES":U
                         ,INPUT  cRTBProductModule
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

  END.

  ASSIGN
    opError = "":U.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load_files_icf_pre WINDOW-1 
PROCEDURE load_files_icf_pre :
/*------------------------------------------------------------------------------
  Purpose:     Dynamics Specific Enhancements
  Parameters:  <none>
  Notes:       Pre events, before files are to be loaded
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER opError     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cRTBProductModule   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSCMProductModule   AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cRTBProductModule = CB-module:SCREEN-VALUE
      cSCMProductModule = CB-module:SCREEN-VALUE.
  END.

  IF VALID-HANDLE(gshSessionManager)
  THEN DO:

    /* Product Module Enhancement - Begin */

    /* Check if SCMTool is running */
    ASSIGN 
      hScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT 'PRIVATE-DATA:SCMTool':U) NO-ERROR
      .

    /* Default title values */
    ASSIGN
      cMesWinTitle            = "Module Load (Dynamics Enhancement)":U
      cMesWinButtonCancel     = "Cancel":U
      cMesWinAnswerValue      = "":U
      cMesWinAnswerDataType   = "":U
      cMesWinAnswerFormat     = "":U
      .

    /* This product module check should rather be moved to a API in ryscmevntp.p in the future */
    IF cSCMProductModule <> "":U
    THEN
      RUN scmSitePrefixDel IN hScmTool (INPUT-OUTPUT cSCMProductModule).

    FIND FIRST gsc_product_module NO-LOCK
      WHERE gsc_product_module.product_module_code = cSCMProductModule
      NO-ERROR.
    IF NOT AVAILABLE gsc_product_module
    THEN DO:

      /* Button values */
      ASSIGN
        cMesWinButtonList       = "Continue,Cancel":U
        cMesWinButtonDefault    = "Cancel":U
        .

      /* Warning */
      ASSIGN
        cMesWinMessage  = 'The product module (' + cRTBProductModule + ') does not exist in the Progress Dynamics repository (ICFDB)'
                        + CHR(10)
                        + 'If you answer "Continue",'
                        + CHR(10)
                        + ' - the object will only be stored in the Roundtable Repository.'
                        + CHR(10)
                        + ' - the object will not be register in the Progress Dynamics repository (ICFDB). Warning messages would be reveiced for each object it cannot register.'
                        + CHR(10)
                        + ' The objects must be manualy registered using the XML synchronization utility.'
                        + CHR(10)
                        + 'Continue with Load of objects even though the product module does not exist ? (usually choose "Cancel")'
                        .
      /* Try and display a nice formatted error if we can */
      RUN askQuestion IN gshSessionManager
                     (INPUT cMesWinMessage
                     ,INPUT cMesWinButtonList
                     ,INPUT cMesWinButtonDefault
                     ,INPUT cMesWinButtonCancel
                     ,INPUT ""
                     ,INPUT cMesWinAnswerDataType
                     ,INPUT cMesWinAnswerFormat
                     ,INPUT-OUTPUT cMesWinAnswerValue
                     ,OUTPUT cMesWinButtonPressed
                     ).

      IF LOOKUP(cMesWinButtonPressed,"Cancel":U) > 0
      THEN DO:
        ASSIGN
          opError = "Progress Dynamics Product Module":U + cRTBProductModule + "not available".
        RETURN.
      END.

    END.  /* if ERROR <> "" */

    /* Product Module Enhancement - End */

    /* Data Load Enhancement - Begin */

    /* Button values */
    ASSIGN
      cMesWinButtonList       = "Import All,Skip all,Decide Later,Cancel":U
      cMesWinButtonDefault    = "Import All":U
      .

    /* Question 01 */
    ASSIGN
      cMesWinMessage  = 'Do you wish to automatically import the objects information from the Progress Dynamics repository (ICFDB)'
                      + ' and create/update the content/information of the object from the .ado file containing the XML data.'
                      + CHR(10)
                      + 'If you choose "Decide Later", you will asked for each object if you wish to import it or not.'
                      + CHR(10)
                      + 'If you answer "Skip All", an INCORRECT version of the data could be stored in the Roundtable Repository.'
                      + ' This should ONLY be skipped if the correct version is already in the Dynamics Repository, i.e.'
                      + ' a new Dynamics Repository Database has been created/build and correctly loaded.'
                      + ' This could be done manually or by using the DCU installation/update utility.'
                      + CHR(10)
                      + 'Load the .ado XML files ? (usually choose "Import All")'
                      .
    /* Try and display a nice formatted error if we can */
    RUN askQuestion IN gshSessionManager
                   (INPUT cMesWinMessage
                   ,INPUT cMesWinButtonList
                   ,INPUT cMesWinButtonDefault
                   ,INPUT cMesWinButtonCancel
                   ,INPUT cMesWinTitle
                   ,INPUT cMesWinAnswerDataType
                   ,INPUT cMesWinAnswerFormat
                   ,INPUT-OUTPUT cMesWinAnswerValue
                   ,OUTPUT cMesWinButtonPressed
                   ).

    IF LOOKUP(cMesWinButtonPressed,"Skip All":U) > 0
    THEN DO:

      /* Question 02 */
      ASSIGN
        cMesWinMessage  = 'Are you really sure you know what you are doing and really do not want the Progress Dynamics enhancement. ' + 
                          'If you continue with this decision, then the INCORRECT version of data could be stored into Roundtable. ' + 
                          'So, to be sure we will ask again. ' + 
                          'Do you want to SKIP the Progress Dynamics enhancement and NOT load the .ado file ' + 
                          'containing the XML content/information of the object.' + "~n":U + "~n":U +
                          'Please obtain appropriate authorisation if you answer "Skip All" to this question.' + "~n":U + "~n":U +
                          'Load the .ado XML files ? (usually choose "Import All")'
                        .
      /* Try and display a nice formatted error if we can */
      RUN askQuestion IN gshSessionManager
                     (INPUT cMesWinMessage
                     ,INPUT cMesWinButtonList
                     ,INPUT cMesWinButtonDefault
                     ,INPUT cMesWinButtonCancel
                     ,INPUT cMesWinTitle
                     ,INPUT cMesWinAnswerDataType
                     ,INPUT cMesWinAnswerFormat
                     ,INPUT-OUTPUT cMesWinAnswerValue
                     ,OUTPUT cMesWinButtonPressed
                     ).

    END. /* "Skip All" */

    CASE cMesWinButtonPressed:
      WHEN cMesWinButtonCancel /* Cancel */
        THEN DO:
          Merror = "Progress Dynamics: Roundable Module Load Cancelled".
          MESSAGE 
            Merror
            VIEW-AS ALERT-BOX ERROR
            TITLE Malert-title.
          RETURN.
        END.
      WHEN "Import All":U
        THEN
          RUN setActionUnderway IN gshSessionManager
                               (INPUT "SCM":U
                               ,INPUT "SKIPLOADNO":U
                               ,INPUT cRTBProductModule
                               ,INPUT "":U
                               ,INPUT "":U
                               ).
      WHEN "Skip All":U
        THEN
          RUN setActionUnderway IN gshSessionManager
                               (INPUT "SCM":U
                               ,INPUT "SKIPLOADYES":U
                               ,INPUT cRTBProductModule
                               ,INPUT "":U
                               ,INPUT "":U
                               ).
      OTHERWISE DO: /* DECIDE LATER */
        /* do nothing */
      END.
    END CASE.

    /* Data Load Enhancement - End */

  END. /* VALID-HANDLE(gshSessionManager) */

  ASSIGN
    opError = "":U.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modify_properties WINDOW-1 
PROCEDURE modify_properties :
/*------------------------------------------------------------------------------
  Purpose: Let user view and modify code properties.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE Mx       AS INTEGER NO-UNDO.
  DEFINE VARIABLE Mchanged AS LOGICAL NO-UNDO.
  
  /* --- ensure at least one record is selected in the code browse --- */
  IF BR-srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE
      "Cannot view property dialog as no Files are selected.  Select at
 least one File in the browse and try again."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if br-srcfile:num-selected-rows ... */

  /*- Run through browse, to see which row are selected -*/
  RUN set_session_wait IN Grtb-p-stat (INPUT "General").

  /*- but first, we must turn everything off -*/
  FOR EACH Tsrcfile WHERE Tsrcfile.module = CB-module:SCREEN-VALUE:
    ASSIGN Tsrcfile.selected = FALSE.
  END.
  
  /*- now see which ones are actually selected -*/
  DO Mi = 1 TO Br-Srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    
    /*- scroll browse to first highlighted row -*/
    Mret = Br-Srcfile:SCROLL-TO-SELECTED-ROW(Mi).

    /*- retrieve record associated with row -*/
    Mret = Br-Srcfile:FETCH-SELECTED-ROW(Mi).   

    ASSIGN Tsrcfile.selected = TRUE.             
    
  END.  /* for each tsrcfile */
                                              
  /* --- end wait state --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "").
  
  /* --- fill properties.  note: tsrcfile is shared with rtb_mlpr.w --- */
  RUN rtb/w/rtb_mlpr.w (INPUT  CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                        OUTPUT Mchanged).

  /* --- If any change occurred refresh the browse --- */
  IF Mchanged THEN DO:
    FOR EACH Tsrcfile
      WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
        AND Tsrcfile.selected NO-LOCK:
      RUN remove_subtype_parts (INPUT Tsrcfile.filename).
    END.
    ASSIGN
      Mret = BR-srcfile:REFRESH().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove_subtype_parts WINDOW-1 
PROCEDURE remove_subtype_parts :
/*------------------------------------------------------------------------------
  Purpose:     Remove subordinate subtype parts for specified file from list
  Parameters:  INPUT Pfilename AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER Pfilename AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE Merror    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mfilename AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mfullpath AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mparts    AS CHARACTER   NO-UNDO.

  DEFINE BUFFER BTsrcfile  FOR Tsrcfile.
  DEFINE BUFFER B2Tsrcfile FOR Tsrcfile.
  
  FIND BTsrcfile
    WHERE BTsrcfile.module   = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      AND BTsrcfile.filename = Pfilename NO-ERROR.

  IF AVAILABLE BTsrcfile THEN DO:
    RUN get_part_names (INPUT  Mworking-dir,
                        INPUT  BTsrcfile.module,
                        INPUT  BTsrcfile.sub-type,
                        INPUT  BTsrcfile.filename,
                        INPUT  "PCODE",
                        OUTPUT Mparts,
                        OUTPUT Merror).
    IF Merror = "" THEN
      DO Mi = 2 TO NUM-ENTRIES(Mparts):
        IF ENTRY(Mi,Mparts) <> "" THEN DO:
          ASSIGN Mfullpath = REPLACE(ENTRY(Mi,Mparts),"~\","~/")
                 Mfilename = SUBSTRING(Mfullpath,R-INDEX(Mfullpath,"~/") + 1).
          FOR EACH B2Tsrcfile 
            WHERE B2Tsrcfile.module   = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
              AND B2Tsrcfile.filename = Mfilename:
            IF REPLACE(B2Tsrcfile.fullpath,"~\","~/") = Mfullpath THEN DO:
              CREATE Tsubtype-parts.
              ASSIGN Tsubtype-parts.module    = B2Tsrcfile.module
                     Tsubtype-parts.filename  = Pfilename
                     Tsubtype-parts.partname  = B2Tsrcfile.filename.
              DELETE B2Tsrcfile.
            END.
          END.
        END.
      END.
  END. /* available btsrcfile */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scan_directories WINDOW-1 
PROCEDURE scan_directories :
/*------------------------------------------------------------------------------
  Purpose:     Scan directories for unloaded object files
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Mmsg AS CHARACTER   NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    RUN build_source_list (INPUT CB-module:SCREEN-VALUE,
                           INPUT RS-scan-by:SCREEN-VALUE,
                           INPUT FI-filespec:SCREEN-VALUE,
                           INPUT CB-sub-type:SCREEN-VALUE).
  END.

  /* --- fill the list with pmods and subtypes --- */
  RUN fill_defaults.

  FIND FIRST Tsrcfile
    WHERE Tsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    NO-LOCK NO-ERROR.
  
  IF NOT AVAILABLE Tsrcfile THEN DO WITH FRAME {&FRAME-NAME}:
    
    Mmsg = SUBSTITUTE("No source code files matching &1 '&2' exist in or~
 below &3 that have not already been loaded into Roundtable.",
     (IF RS-scan-by = "Subtype":U THEN
        "Subtype":U
      ELSE ""),
     (IF RS-scan-by = "Filespec":U THEN
       FI-Filespec:SCREEN-VALUE
     ELSE
       CB-sub-type:SCREEN-VALUE),
     Mworking-dir).
   
   MESSAGE Mmsg VIEW-AS ALERT-BOX INFORMATION TITLE Malert-title.
  
  END.
    
      
  RUN set_sensitive.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scan_for_comments WINDOW-1 
PROCEDURE scan_for_comments :
/*------------------------------------------------------------------------------
  Purpose: scans files for comments     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE Msummary-desc  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Mdetailed-desc AS CHARACTER NO-UNDO.

  IF NOT AVAILABLE Tsrcfile THEN RETURN.

  RUN rtb/p/rtb_scom.p (INPUT  Tsrcfile.fullpath,
                        OUTPUT Msummary-desc,
                        OUTPUT Mdetailed-desc).

  /* --- assign descriptions --- */  
  ASSIGN
    Tsrcfile.summary-desc  = Msummary-desc
    Tsrcfile.detailed-desc = Mdetailed-desc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select_files WINDOW-1 
PROCEDURE select_files :
/*------------------------------------------------------------------------------
  Purpose: prompt user for filenames that match other files and either
           select or deselect these file..     
  Parameters:  Mselect-type: either "select" or "deselect"
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER Mselect-type AS CHARACTER NO-UNDO.

  DEFINE VARIABLE Mfile        AS CHARACTER                NO-UNDO.
  DEFINE VARIABLE Mstart-recid AS RECID                    NO-UNDO.
  DEFINE VARIABLE BT-Ok5       AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE BT-Help5     AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE BT-Cancel5   AS HANDLE                   NO-UNDO.
  DEFINE VARIABLE Mx           AS INTEGER                  NO-UNDO.
  DEFINE VARIABLE Mmessage    AS CHARACTER
    VIEW-AS EDITOR 
    INNER-LINES 8
    INNER-CHARS 74
    NO-UNDO.

  DEFINE FRAME matches-frame
    Mmessage
      NO-LABEL
      AT ROW 2 COL 2
    Mfile FORMAT "x(20)"
      LABEL "Matching Criteria"
      AT ROW 8.5 COL 10
      HELP "Enter file name with wildcard values."
      VIEW-AS FILL-IN
  WITH
    VIEW-AS DIALOG-BOX
    SIZE 80 BY 13
    FONT 4
    SIDE-LABELS
    THREE-D
    TITLE Malert-title.      

  
  ASSIGN
    Mmessage = SUBSTITUTE("Enter matching criteria for Filenames to &1 in
 browse.&2&2    Example criteria:&2&2        *          : Matches
 all files.&2        string*  : Matches all files that begin with 'string'.
 &2        *~~.ext  : Matches all files that end with '.ext'.",
 Mselect-type,CHR(10)).
 
 
  /* --- ensure there are files in the browse --- */
  IF NOT CAN-FIND(FIRST Tsrcfile
                   WHERE Tsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME})
  THEN DO:
    MESSAGE 
      "Cannot select any files as no files exist in the browse."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if srcfile-entries < 1 */
  
  /* --- find the current row so we can reselect it later --- */
  ASSIGN
    Mret = BR-srcfile:SELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.
  IF AVAILABLE Tsrcfile THEN DO:
    ASSIGN
      Mstart-recid = RECID(Tsrcfile).
    IF NOT Tsrcfile.selected THEN DO:
      ASSIGN
        Mtemp-filename = Tsrcfile.filename.
      DO Mrow = 1 TO BR-srcfile:NUM-SELECTED-ROWS:
        ASSIGN
          Mret = BR-srcfile:FETCH-SELECTED-ROW(Mrow).
        IF Tsrcfile.filename = Mtemp-filename THEN
          LEAVE.
      END.  /* do mrow = 1 to ... */      
      ASSIGN  
        Mret = BR-srcfile:DESELECT-SELECTED-ROW(Mrow). 
    END.  /* if not tsrcfile.selected */
  END.  /* if available tsrcfile */


  /* --- Make OK,Create,Help buttons appear in frame --- */
  RUN make_def_ok_cancel IN Grtb-p-library (INPUT  FRAME matches-frame:HANDLE,
                                            OUTPUT BT-Ok5,
                                            OUTPUT BT-Cancel5,
                                            OUTPUT BT-Help5).

  /* --- help trigger. --- */
  ON HELP OF FRAME matches-frame OR CHOOSE OF BT-help5 DO:
    SYSTEM-HELP Grtb-help-file CONTEXT 722.
  END.  /* on help */
  
  /* --- go trigger --- */
  ON GO OF FRAME matches-frame
    ASSIGN
      Mfile.

  /* --- close trigger --- */
  ON WINDOW-CLOSE OF FRAME matches-frame
    ASSIGN
      Mfile = "".

  ENABLE ALL WITH FRAME matches-frame.
  ASSIGN
    Mmessage:READ-ONLY IN FRAME matches-frame = YES.
  DISPLAY
    Mmessage
  WITH FRAME matches-frame.  
  
  ASSIGN
    Mfile:SCREEN-VALUE = "*".
  
  APPLY "ENTRY" TO Mfile IN FRAME matches-frame.
                                 
  DO ON ENDKEY UNDO, LEAVE 
     ON ERROR  UNDO, LEAVE:
    WAIT-FOR WINDOW-CLOSE, GO OF FRAME matches-frame.
  END.                 
  
  HIDE FRAME matches-frame.
  
  IF Mfile = "" OR Mfile = ? THEN RETURN.


  /* --- start wait state --- */  
  RUN set_session_wait IN Grtb-p-stat (INPUT "General").

  /* --- determine which files where matched and select or deselect --- */
  FOR EACH Tsrcfile
    WHERE Tsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
    EXCLUSIVE-LOCK:
    IF Tsrcfile.filename MATCHES Mfile THEN DO:
      REPOSITION BR-srcfile TO RECID RECID(Tsrcfile).
      IF Mselect-type = "select" THEN
        ASSIGN
           Mret = BR-srcfile:SELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.
      ELSE
        ASSIGN
           Mret = BR-srcfile:DESELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.
    END.  /* IF Tsrcfile.filenema MATCHES */
  END.  /* For Each Tsrcfile */

  /* --- posititon browse to currently selected row --- */
  FIND FIRST Tsrcfile WHERE RECID(Tsrcfile) = Mstart-recid
                        NO-LOCK NO-ERROR.
  IF AVAILABLE Tsrcfile THEN
    REPOSITION BR-srcfile TO RECID Mstart-recid.
  ELSE
    REPOSITION BR-srcfile TO ROW(1).
  APPLY "ENTRY" TO BR-srcfile IN FRAME {&FRAME-NAME}.

  /* --- end wait state --- */  
  RUN set_session_wait IN Grtb-p-stat (INPUT "").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_module_query WINDOW-1 
PROCEDURE set_module_query :
/*------------------------------------------------------------------------------
  Purpose:     Show selected module's objects in browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN Mmodule = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  OPEN QUERY BR-srcfile
      FOR EACH Tsrcfile
        WHERE Tsrcfile.module = Mmodule NO-LOCK BY Tsrcfile.filename.

  IF CAN-FIND(FIRST Tsrcfile WHERE Tsrcfile.module = Mmodule) THEN
    BROWSE BR-srcfile:REFRESH().

  RUN set_sensitive.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_sensitive WINDOW-1 
PROCEDURE set_sensitive :
/*------------------------------------------------------------------------------
  Purpose: enable/disable widgets.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE Many-selected AS LOGICAL               NO-UNDO.
  DEFINE VARIABLE Mdelete       AS LOGICAL INITIAL YES   NO-UNDO.
  DEFINE VARIABLE Mfiles        AS LOGICAL               NO-UNDO.
  DEFINE VARIABLE Mload         AS LOGICAL INITIAL YES   NO-UNDO.
  DEFINE VARIABLE Mrow-selected AS LOGICAL               NO-UNDO.

  DEFINE BUFFER BTsrcfile FOR Tsrcfile.

  /*
   Select/deselect current and previous clicked items --
  
   Since ROW-ENTRY trigger does not fire for a non-updatable browse, we
   have to synch up the Tsrcfile data with the browse on VALUE-CHANGED.
   
   In a multiple-select browse, the previous browse row may or may not
   be still selected (depending upon Ctrl key) when a new row is cliked.
   
   Select status is maintained in the transaction block below:
  */
  IF CAN-FIND(FIRST Tsrcfile WHERE
                Tsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN
    DO WITH FRAME {&FRAME-NAME} TRANSACTION:
      /*
       Did user click on a different row?
      */
      IF Tsrcfile.filename <> Mprev-filename THEN DO:
        /*
         Make sure underlying Tsrcfile.selected is properly updated
        */
        FIND BTsrcfile
          WHERE BTsrcfile.module = CB-module:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            AND BTsrcfile.filename = Mprev-filename NO-ERROR.
        IF AVAILABLE BTsrcfile THEN
          ASSIGN BTsrcfile.selected = BROWSE BR-srcfile:IS-ROW-SELECTED(Mprev-row)
                                      NO-ERROR.
      END. /* mrow <> mprev-row */

      /*
       Keep track of last file selected
      */
      /* --- Work around a browse deselect bug  --- */
      ASSIGN Mrow-selected = BROWSE BR-srcfile:FOCUSED-ROW-SELECTED.
      IF NOT Mrow-selected THEN
        BROWSE BR-srcfile:SELECT-FOCUSED-ROW().
        
      ASSIGN Mprev-filename    = Tsrcfile.filename
             Mprev-row         = BROWSE BR-srcfile:FOCUSED-ROW
             Tsrcfile.selected = Mrow-selected.
             
      IF NOT Mrow-selected THEN
        BROWSE BR-srcfile:DESELECT-FOCUSED-ROW().

    END. /* do transaction... */

  ASSIGN
    Many-selected = BR-srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0
    Mfiles        = CAN-FIND(FIRST Tsrcfile
                               WHERE Tsrcfile.module = CB-module:SCREEN-VALUE).
                                      
  IF CAN-FIND(FIRST Tsrcfile 
                WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
                  AND Tsrcfile.selected = YES
                  AND (Tsrcfile.obj-status <> "New"
                       OR Tsrcfile.sub-type = ?
                       OR Tsrcfile.sub-type = ""
                       OR Tsrcfile.pmod     = ?
                       OR Tsrcfile.pmod     = "")) THEN
    Mload = NO.
  
   IF CAN-FIND(FIRST Tsrcfile 
                WHERE Tsrcfile.module = CB-module:SCREEN-VALUE
                  AND Tsrcfile.selected = YES
                  AND Tsrcfile.obj-status <> "Done") THEN
    Mdelete = NO.

  /* --- enable/disable frame widgets --- */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      /* --- buttons --- */
      BT-properties:SENSITIVE    = Many-selected AND Mfiles
      BT-load:SENSITIVE          = Many-selected AND Mload AND Mfiles
      BT-delete:SENSITIVE        = Many-selected AND Mdelete AND Mfiles
      BT-view:SENSITIVE          = Mfiles
      BT-select:SENSITIVE        = Mfiles
      BT-deselect:SENSITIVE      = Mfiles
      BT-clear:SENSITIVE         = Mfiles
      /* --- other widgets --- */
      FI-filespec:TAB-STOP       = RS-scan-by:SCREEN-VALUE = "Filespec":U
      FI-filespec:READ-ONLY      = RS-scan-by:SCREEN-VALUE = "Subtype":U
      CB-sub-type:SENSITIVE      = RS-scan-by:SCREEN-VALUE = "Subtype":U
      BROWSE BR-srcfile:TAB-STOP = Mfiles.
  END.
  
  /* --- file menu items --- */
  ASSIGN  
    MENU-ITEM m_Select_Files:SENSITIVE IN SUB-MENU m_File    = BT-select:SENSITIVE IN FRAME {&FRAME-NAME}
    MENU-ITEM m_Deselect_Files:SENSITIVE IN SUB-MENU m_File  = BT-deselect:SENSITIVE IN FRAME {&FRAME-NAME}
    MENU-ITEM m_Properties:SENSITIVE IN SUB-MENU m_File      = BT-properties:SENSITIVE IN FRAME {&FRAME-NAME}
    MENU-ITEM m_View_File:SENSITIVE IN SUB-MENU m_File       = BT-view:SENSITIVE IN FRAME {&FRAME-NAME}
    MENU-ITEM m_Load_Selected:SENSITIVE IN SUB-MENU m_File   = BT-load:SENSITIVE IN FRAME {&FRAME-NAME}
    MENU-ITEM m_Unload_Selected:SENSITIVE IN SUB-MENU m_File = BT-delete:SENSITIVE IN FRAME {&FRAME-NAME}
    /* --- find menu items --- */
    MENU-ITEM m_Find:SENSITIVE IN SUB-MENU m_Search = Mfiles.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unload_files WINDOW-1 
PROCEDURE unload_files :
/*------------------------------------------------------------------------------
  Purpose: unload selected files from rtb and delete associated records.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* --- ensure there are selected files in the browse --- */
  IF Br-Srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    MESSAGE 
      "Cannot unload files as no file has been selected in the browse."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if not can-find ... */
    
  /* --- ensure user wants to continue --- */
  MESSAGE
    "Unloading selected files may take a long time."
    SKIP(1)
    "Continue?"
    VIEW-AS ALERT-BOX WARNING
    BUTTON YES-NO
    TITLE Malert-title
    UPDATE Mcontinue.
  
  IF NOT Mcontinue THEN
    RETURN.

  /* --- start wait state --- */  
  RUN set_session_wait IN Grtb-p-stat (INPUT "General").

  DO Mi = 1 TO Br-Srcfile:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    
    /*- scroll browse to first highlighted row -*/
    Mret = Br-Srcfile:SCROLL-TO-SELECTED-ROW(Mi).

    /*- retrieve record associated with row -*/
    Mret = Br-Srcfile:FETCH-SELECTED-ROW(Mi).   

    IF NOT Tsrcfile.obj-status = "Done" THEN
      NEXT.
  
    FIND FIRST rtb.rtb_object WHERE rtb.rtb_object.wspace-id = Grtb-wspace-id
                                AND rtb.rtb_object.obj-type  = "PCODE"
                                AND rtb.rtb_object.object    = Tsrcfile.object
                                NO-LOCK NO-ERROR.

    RUN rtb/p/rtb_objd.p (INPUT RECID(rtb_object),
                          INPUT "No-Prompt,No-Delete-Source").
        
    ASSIGN Tsrcfile.obj-status = "New".             
    
    DISPLAY Tsrcfile.obj-status WITH BROWSE BR-srcfile.
    
  END.  /* for each tsrcfile */
                                              
  /* --- end wait state --- */
  RUN set_session_wait IN Grtb-p-stat (INPUT "").
  
  /* --- refresh the browse --- */ 
  ASSIGN Mret = BR-srcfile:REFRESH() IN FRAME {&FRAME-NAME}.  

  APPLY "ENTRY" TO BR-srcfile IN FRAME {&FRAME-NAME}. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unload_proextra WINDOW-1 
PROCEDURE unload_proextra :
/*------------------------------------------------------------------------------
  Purpose: Unloads ProExtra.DLL and deletes ProExtra PP's.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /*- Clean up PP's called from File-Api.i and Windows.i -*/
  IF VALID-HANDLE(rtb_hpFileApi) THEN DO:
    DELETE PROCEDURE rtb_hpFileApi.
    ASSIGN rtb_hpFileApi = ?.
  END.
  IF VALID-HANDLE(rtb_hpExtra) THEN DO:
    DELETE PROCEDURE rtb_hpExtra.
    ASSIGN rtb_hpExtra = ?.
  END.
  IF VALID-HANDLE(rtb_hpApi) THEN DO:
    DELETE PROCEDURE rtb_hpApi.
    ASSIGN rtb_hpApi = ?.
  END.
  IF VALID-HANDLE(rtb_hpWinFunc) THEN DO:
    DELETE PROCEDURE rtb_hpWinFunc.
    ASSIGN rtb_hpWinFunc = ?.
  END.

  /*- Unload ProExtra.dll -*/
  RUN rtb/p/rtb_ldll.p (INPUT "proextra.dll":U,
                        INPUT "Unload":U,
                        INPUT-OUTPUT Mrtbwin-handle ).  /* Handle to unload */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE view_file WINDOW-1 
PROCEDURE view_file :
/*------------------------------------------------------------------------------
  Purpose: Allow user to view source in O/S.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* --- ensure there are files in the browse --- */
  IF Msrcfile-entries < 1 THEN DO:
    MESSAGE 
      "Cannot view a file as no file has been selected in the browse."
      VIEW-AS ALERT-BOX ERROR
      TITLE Malert-title.
    RETURN.
  END.  /* if srcfile-entries < 1 */

  /* --- find current tsrcfile record --- */
  ASSIGN
    Mret = BR-srcfile:SELECT-FOCUSED-ROW() IN FRAME {&FRAME-NAME}.

  APPLY "ENTRY" TO BR-srcfile IN FRAME {&FRAME-NAME}.
  
  IF NOT AVAILABLE Tsrcfile THEN RETURN.

  /* --- Create procedure window for the selected file --- */
  RUN adecomm/_pwmain.p (INPUT "Roundtable",
                         INPUT Tsrcfile.fullpath,
                         INPUT "").

  IF NOT Tsrcfile.selected THEN DO:
    ASSIGN
      Mtemp-filename = Tsrcfile.filename.
    DO Mrow = 1 TO BR-srcfile:NUM-SELECTED-ROWS:
      ASSIGN
        Mret = BR-srcfile:FETCH-SELECTED-ROW(Mrow).
      IF Tsrcfile.filename = Mtemp-filename THEN
        LEAVE.
    END.  /* do mrow = 1 to ... */      
    ASSIGN  
      Mret = BR-srcfile:DESELECT-SELECTED-ROW(Mrow). 
  END.  /* if not tsrcfile.selected */

      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSubtypePartsCount WINDOW-1 
FUNCTION fnSubtypePartsCount RETURNS INTEGER
  ( INPUT Psub-type AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the number of parts defined for specified subtype.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Mcount AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER Brtb_subtype FOR rtb.rtb_subtype.
  
  FIND Brtb_subtype WHERE Brtb_subtype.sub-type = Psub-type NO-LOCK NO-ERROR.
  
  IF AVAILABLE Brtb_subtype THEN
    count-loop:
    DO Mcount = 1 TO 9:
      IF Brtb_subtype.part[Mcount] = "" THEN DO:
        Mcount = Mcount - 1.
        LEAVE count-loop.
      END.
    END. /* count-loop */
  
  RETURN Mcount.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValidSubtypeFile WINDOW-1 
FUNCTION fnValidSubtypeFile RETURNS LOGICAL
  ( INPUT Psub-type AS CHARACTER,
    INPUT Pfile-name AS CHARACTER,
    INPUT Pextension AS CHARACTER,
    INPUT Psubdir AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determine if filename is valid for selected subtype.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Mbasename          AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mpath              AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Msubname           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Msuffix            AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Mdot               AS INTEGER     NO-UNDO.
  DEFINE VARIABLE Mx                 AS INTEGER     NO-UNDO.
  DEFINE VARIABLE Mvalid-for-subtype AS LOGICAL     NO-UNDO.
  
  DEFINE BUFFER Brtb_subtype FOR rtb.rtb_subtype.
  
  FIND Brtb_subtype WHERE Brtb_subtype.sub-type = Psub-type NO-LOCK NO-ERROR.
  
  IF AVAILABLE Brtb_subtype THEN DO:
    /* --- Get file specs per main subtype part --- */
    ASSIGN Mdot      = IF Brtb_subtype.part-ext[1] = "" THEN
                         LENGTH(Pfile-name)
                       ELSE
                         R-INDEX(Pfile-name,".")
           Msuffix   = IF Mdot > LENGTH(Brtb_subtype.part-sufix[1]) THEN
                         SUBSTRING(Pfile-name,
                                   Mdot - LENGTH(Brtb_subtype.part-sufix[1]),
                                   LENGTH(Brtb_subtype.part-sufix[1]))
                       ELSE
                         ""
           Mbasename = IF Mdot > LENGTH(Brtb_subtype.part-sufix[1]) THEN
                         SUBSTRING(Pfile-name,1,
                                   Mdot - LENGTH(Brtb_subtype.part-sufix[1]) - 1)
                       ELSE
                         Pfile-name.
    
    /*
      Determine if object qualifies for subtype
    */
    Mvalid-for-subtype = YES. /* default to yes */
    /* --- Does filename conform to main part specs? --- */
    IF (Brtb_subtype.part-ext[1] <> "" AND 
        Pextension <> Brtb_subtype.part-ext[1])
       OR (Brtb_subtype.part-sufix[1] <> "" AND
           NOT Msuffix = Brtb_subtype.part-sufix[1])
       OR Psubdir <> Brtb_subtype.part-dir[1] THEN
      Mvalid-for-subtype = NO.
    ELSE DO Mx = 2 TO 9:
      IF Brtb_subtype.part[Mx] = "" THEN LEAVE.
  
      /* --- Does subtype part exist? --- */
      FIND rtb.rtb_moddef WHERE rtb.rtb_moddef.module = Tsrcfile.module
        NO-LOCK NO-ERROR.

      ASSIGN Mpath = Grtb-wsroot
                     + "/"
                     + (IF AVAILABLE rtb.rtb_moddef
                           AND rtb.rtb_moddef.directory <> "" THEN
                          (rtb.rtb_moddef.directory + "/")
                        ELSE
                          "")
                     + (IF Brtb_subtype.part-dir[Mx] <> "" THEN
                          (Brtb_subtype.part-dir[Mx] + "/")
                        ELSE
                          "").
                   
      Msubname = Mpath
                 + Mbasename
                 + Brtb_subtype.part-sufix[Mx]
                 + (IF Brtb_subtype.part-ext[Mx] <> "" THEN
                     ("." + Brtb_subtype.part-ext[Mx])
                    ELSE
                      "").

      IF SEARCH(Msubname) = ? THEN DO:
        Mvalid-for-subtype = NO.
        LEAVE.
      END.
  
      /* --- Filename not valid if it conforms to a subpart spec --- */
      IF Pextension <> Brtb_subtype.part-ext[Mx]
         OR Psubdir <> Brtb_subtype.part-dir[Mx] THEN NEXT.
  
      IF Brtb_subtype.part-sufix[Mx] <> "" THEN
      ASSIGN Mdot    = IF Brtb_subtype.part-ext[Mx] = "" THEN
                         LENGTH(Pfile-name)
                       ELSE
                         R-INDEX(Pfile-name,".")
             Msuffix = IF Mdot > LENGTH(Brtb_subtype.part-sufix[Mx]) THEN
                         SUBSTRING(Pfile-name,
                                   Mdot - LENGTH(Brtb_subtype.part-sufix[Mx]),
                                   LENGTH(Brtb_subtype.part-sufix[Mx]))
                       ELSE
                         "".
      
      IF Msuffix = Brtb_subtype.part-sufix[Mx] THEN DO:
        Mvalid-for-subtype = NO.
        LEAVE.
      END.
    END. /* do mx = 2 to 9 */
  END.

  RETURN Mvalid-for-subtype.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

