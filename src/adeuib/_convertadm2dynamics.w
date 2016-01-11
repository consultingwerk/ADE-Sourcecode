&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          files            PROGRESS
*/
&Scoped-define WINDOW-NAME V89dcnv

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Procedure NO-UNDO /* LIKE Procedure.                  */
    FIELD Name AS CHARACTER FORMAT "X(255)"
    FIELD Stts AS CHARACTER FORMAT "X(9)" LABEL "Status" INITIAL "Not Migrated"
    FIELD Extension AS CHARACTER
    FIELD DynObject AS CHARACTER FORMAT "X(255)" LABEL "Dynamic object"
  INDEX Name IS PRIMARY UNIQUE Name
  INDEX Extension Extension Name.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V89dcnv 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:        protools/v89conv.w

  Description: Main procedure for the V8 to V9 SmartObject migration
               utility/

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:     D. Ross Hunter

  Created:    March 1, 2002

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{adeuib/sharvars.i}   /* Shared variables                               */
{adeuib/uniwidg.i}    /* AppBuilder Temptables                          */

{protools/ptlshlp.i}  /* help definitions        */
{adecomm/_adetool.i}  /* Register as an ADE tool */
{protools/_runonce.i} /* allow one instance      */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{adecomm/dirsrch.i}
{adecomm/cbvar.i}
{src/adm2/globals.i}
{src/adm2/inrepprmod.i}

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE forget-sw     AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE gcProfileData AS CHARACTER               NO-UNDO.
DEFINE VARIABLE list-mem      AS MEMPTR                  NO-UNDO.
DEFINE VARIABLE list-size     AS INTEGER   INITIAL 20000 NO-UNDO.
DEFINE VARIABLE missed-file   AS INTEGER                 NO-UNDO.
DEFINE VARIABLE name-seq      AS INTEGER                 NO-UNDO.
DEFINE VARIABLE DirError      AS INTEGER                 NO-UNDO.
DEFINE VARIABLE FileSize      AS INTEGER                 NO-UNDO.
DEFINE VARIABLE CurFilter     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE error         AS INTEGER                 NO-UNDO.
DEFINE VARIABLE ThisMessage   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE pm_obj        AS DECIMAL                 NO-UNDO.
DEFINE VARIABLE rRowid        AS ROWID                   NO-UNDO.
DEFINE VARIABLE cPMValue      AS CHARACTER               NO-UNDO.
DEFINE VARIABLE cRepModules   AS CHARACTER               NO-UNDO.
DEFINE VARIABLE cSDOList      AS CHARACTER               NO-UNDO.

DEFINE VARIABLE abort-conv    AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE sort-mode     AS INTEGER   INITIAL 2     NO-UNDO.


DEFINE STREAM log-file.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Procedure

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Procedure.Stts Procedure.Name ~
Procedure.DynObject 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH Procedure NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH Procedure NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 Procedure
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 Procedure


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Directory btn_browse tog_subdir file-filter ~
filter-btn Btn-rebuild coProductModule  BROWSE-1 Btn_Sort Btn_Add ~
Btn_Remove TBReg Btn_Advance LogFile Btn_Convert Btn_Abort Btn_Exit ~
Btn_Help RECT-1 RECT-2 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS Directory tog_subdir file-filter ~
coProductModule  TBReg LogFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR V89dcnv AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-rebuild 
     LABEL "Build file &list" 
     SIZE 24 BY 1.14 TOOLTIP "Generate a list of files meeting specified criteria and displays them below.".

DEFINE BUTTON Btn_Abort AUTO-GO 
     LABEL "&Abort migrations" 
     SIZE 25 BY 1.14 TOOLTIP "Stop the batch process after  it completes action on the current file."
     BGCOLOR 8 .

DEFINE BUTTON Btn_Add AUTO-GO 
     LABEL "Add a &file..." 
     SIZE 15 BY 1.14 TOOLTIP "Add an additional file to the list of files to process."
     BGCOLOR 8 .

DEFINE BUTTON Btn_Advance 
     LABEL "Advanced settin&gs" 
     SIZE 25 BY 1.14 TOOLTIP "More migration options are available in the Advanced Migration Settings window."
     BGCOLOR 8 .

DEFINE BUTTON btn_browse 
     LABEL "&Browse..." 
     SIZE 15 BY 1.14 TOOLTIP "Select the top level directory containing the files to migrate.".

DEFINE BUTTON Btn_Convert AUTO-GO 
     LABEL "Start &migrations" 
     SIZE 25 BY 1.14 TOOLTIP "Run a batch process to migrate the files listed in the browser above."
     BGCOLOR 8 .

DEFINE BUTTON Btn_Exit AUTO-GO DEFAULT 
     LABEL "&Exit" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Remove AUTO-GO 
     LABEL "&Remove" 
     SIZE 15 BY 1.14 TOOLTIP "Remove the selected files from the browser to the left."
     BGCOLOR 8 .

DEFINE BUTTON Btn_Sort AUTO-GO 
     LABEL "&Sort ..." 
     SIZE 15 BY 1.14 TOOLTIP "Sort the files to migrate in the browser to the left."
     BGCOLOR 8 .

DEFINE BUTTON filter-btn 
     IMAGE-UP FILE "adeicon\cbbtn":U
     LABEL "F" 
     SIZE 4 BY 1.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>>>>99999999999.9999999999":U INITIAL 0 
     LABEL "&Product module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",00000000001.0000
     DROP-DOWN-LIST
     SIZE 72 BY 1 TOOLTIP "You must enter (or select) a valid product module." NO-UNDO.

DEFINE VARIABLE Directory AS CHARACTER FORMAT "X(256)":U INITIAL "." 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1.19 TOOLTIP "Enter the top level directory containing files to migrate or press 'Browse'." NO-UNDO.

DEFINE VARIABLE file-filter AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fi&lter" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 TOOLTIP "Generally, only files of type '.w' or '.p' are candidates for migration." NO-UNDO.

DEFINE VARIABLE LogFile AS CHARACTER FORMAT "X(256)":U INITIAL "./V89DConv.log" 
     LABEL "Log file" 
     VIEW-AS FILL-IN 
     SIZE 62.4 BY 1.19 TOOLTIP "Enter the path/filename for the log file.  It will be overwritten if it exists." NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .2 BY 5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 4.76.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93 BY 18.67.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93 BY .1.

DEFINE VARIABLE filter-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "*.w,*.p,*.i","*.w","*.p","*.i","*.*" 
     SIZE 19 BY 3.57 NO-UNDO.

DEFINE VARIABLE TBReg AS LOGICAL INITIAL no 
     LABEL "Register non-migrated static objects if they are in the proper directory" 
     VIEW-AS TOGGLE-BOX
     SIZE 73 BY .81 TOOLTIP "You must have a valid Product Module specified above." NO-UNDO.

DEFINE VARIABLE tog_subdir AS LOGICAL INITIAL yes 
     LABEL "&Include subdirectories" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .81 TOOLTIP "Files in the subdirectories of the directory above will also be included." NO-UNDO.

DEFINE VARIABLE srch-dir AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 44 BY .62 NO-UNDO.

DEFINE VARIABLE srch-lbl AS CHARACTER FORMAT "X(256)":U INITIAL "Searching:" 
      VIEW-AS TEXT 
     SIZE 19 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.4 BY 5.57.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      Procedure SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 V89dcnv _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      Procedure.Stts FORMAT "X(12)":U WIDTH 14.2
      Procedure.Name FORMAT "X(44)":U WIDTH 33.4
      Procedure.DynObject FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 71 BY 9 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     Directory AT ROW 2.19 COL 4 COLON-ALIGNED NO-LABEL
     btn_browse AT ROW 2.19 COL 60
     tog_subdir AT ROW 3.86 COL 6
     file-filter AT ROW 3.86 COL 54 COLON-ALIGNED
     filter-btn AT ROW 3.86 COL 72
     Btn-rebuild AT ROW 5.05 COL 51
     coProductModule AT ROW 7.67 COL 20 COLON-ALIGNED
     BROWSE-1 AT ROW 10.48 COL 6
     Btn_Sort AT ROW 12.14 COL 78.8
     Btn_Add AT ROW 13.57 COL 78.8
     Btn_Remove AT ROW 15 COL 78.8
     TBReg AT ROW 20.05 COL 6
     Btn_Advance AT ROW 8.91 COL 68.8
     LogFile AT ROW 21.29 COL 12.6 COLON-ALIGNED
     Btn_Convert AT ROW 23.76 COL 22.8
     Btn_Abort AT ROW 23.76 COL 51.8
     Btn_Exit AT ROW 1.71 COL 81.2
     Btn_Help AT ROW 3.14 COL 81.2
     filter-list AT ROW 4.81 COL 56 NO-LABEL
     RECT-1 AT ROW 1.48 COL 78.2
     RECT-2 AT ROW 1.71 COL 4
     RECT-4 AT ROW 7.19 COL 4
     RECT-5 AT ROW 6.71 COL 4
     "  Directory:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 1.24 COL 5
     "Files to migrate:" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 9.76 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 97.2 BY 25.19
         DEFAULT-BUTTON Btn_Exit.

DEFINE FRAME FRAME-A
     srch-lbl AT ROW 2.91 COL 7 COLON-ALIGNED NO-LABEL
     srch-dir AT ROW 3.86 COL 7 COLON-ALIGNED NO-LABEL
     RECT-6 AT ROW 1.14 COL 1.6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 8 ROW 11.86
         SIZE 55 BY 6
         BGCOLOR 4 FGCOLOR 15 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Compile into: 
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ? T "?" NO-UNDO files Procedure
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW V89dcnv ASSIGN
         HIDDEN             = YES
         TITLE              = "Static SmartObject to Dynamic Object Migration Utility"
         HEIGHT             = 25.19
         WIDTH              = 97.2
         MAX-HEIGHT         = 25.19
         MAX-WIDTH          = 97.2
         VIRTUAL-HEIGHT     = 25.19
         VIRTUAL-WIDTH      = 97.2
         MAX-BUTTON         = no
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

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT V89dcnv:LOAD-ICON("adeicon\smoupgrd":U) THEN
    MESSAGE "Unable to load icon: adeicon\smoupgrd"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V89dcnv
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME FRAME-A:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME FRAME-A:MOVE-BEFORE-TAB-ITEM (Directory:HANDLE IN FRAME DEFAULT-FRAME)
/* END-ASSIGN-TABS */.

/* BROWSE-TAB BROWSE-1 DEFAULT-FRAME */
/* SETTINGS FOR SELECTION-LIST filter-list IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       filter-list:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FRAME FRAME-A
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-A:HIDDEN           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(V89dcnv)
THEN V89dcnv:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.Procedure"
     _FldNameList[1]   > Temp-Tables.Procedure.Stts
"Procedure.Stts" ? ? "character" ? ? ? ? ? ? no ? no no "14.2" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.Procedure.Name
"Procedure.Name" ? "X(44)" "character" ? ? ? ? ? ? no ? no no "33.4" yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.Procedure.DynObject
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME V89dcnv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V89dcnv V89dcnv
ON END-ERROR OF V89dcnv /* Static SmartObject to Dynamic Object Migration Utility */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL V89dcnv V89dcnv
ON WINDOW-CLOSE OF V89dcnv /* Static SmartObject to Dynamic Object Migration Utility */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-rebuild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-rebuild V89dcnv
ON CHOOSE OF Btn-rebuild IN FRAME DEFAULT-FRAME /* Build File List */
DO:
  DEFINE VARIABLE ErrorStatus AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER                         NO-UNDO.
  DEFINE VARIABLE tmpflnm     AS CHARACTER                       NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    RUN adecomm/_setcurs.p ("WAIT":U).

    /* Clear out the old stuff */
    FOR EACH Procedure:
      DELETE Procedure.
    END.
    
    ASSIGN Directory
           FILE-INFO:filename = RIGHT-TRIM(Directory,"~\,~/")
           Directory          = FILE-INFO:FULL-PATHNAME
           tog_subdir         = tog_subdir:CHECKED
           CurFilter          = file-filter:SCREEN-VALUE.

    IF Directory = ? THEN DO:
      MESSAGE "Directory" Directory:SCREEN-VALUE "does not exist, please select a valid directory."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY" TO DIRECTORY.
      RETURN.
    END.

    RUN process_subdirectories(Directory, Directory, CurFilter).

    HIDE FRAME FRAME-A.
    SELF:LABEL = "Rebuild file &list":U.
    RUN open-browse.
    RUN adecomm/_setcurs.p ("":U).

    IF NUM-RESULTS("{&BROWSE-NAME}") = 0 THEN DO:
      ThisMessage =  "No files were found that matched your criteria. " +
                     "Try changing the file type filters.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U,"ok":U, ThisMessage).
      RETURN "False":U.
    END.  /* IF no files were found */
    
  END. /* DO WITH FRAME {&FRAME-NAME} */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Abort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Abort V89dcnv
ON CHOOSE OF Btn_Abort IN FRAME DEFAULT-FRAME /* Abort Migrations */
DO:
  abort-conv = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Add V89dcnv
ON CHOOSE OF Btn_Add IN FRAME DEFAULT-FRAME /* Add a File... */
DO:
  DEFINE VARIABLE Filter_NameString AS CHARACTER EXTENT 5      NO-UNDO.
  DEFINE VARIABLE Filter_FileSpec   AS CHARACTER EXTENT 5      NO-UNDO.
  DEFINE VARIABLE File_Ext          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE FileName          AS CHARACTER               NO-UNDO.
  DEFINE VARIABLE NewRecid          AS RECID                   NO-UNDO.
  DEFINE VARIABLE NumEntries        AS INTEGER                 NO-UNDO.
  DEFINE VARIABLE p_ok              AS LOGICAL                 NO-UNDO.

  ASSIGN Directory
         FILE-INFO:filename = RIGHT-TRIM(Directory,"~\,~/")
         Directory          = FILE-INFO:FULL-PATHNAME
         Filter_NameString[ 1 ] = "All Source(*.w~;*.p~;*.i)"
         Filter_FileSpec[ 1 ]   = "*.w~;*.p~;*.i"
         Filter_NameString[ 2 ] = "Windows(*.w)"
         Filter_FileSpec[ 2 ]   = "*.w"
         Filter_NameString[ 3 ] = "Procedures(*.p)"
         Filter_FileSpec[ 3 ]   = "*.p"
         Filter_NameString[ 4 ] = "Includes(*.i)"
         Filter_FileSpec[ 4 ]   = "*.i"
         Filter_NameString[ 5 ] = "All Files(*.*)"
         Filter_FileSpec[ 5 ]   = "*.*".
         
  SYSTEM-DIALOG GET-FILE filename
     TITLE    "Add File Dialog" 
     FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
              Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
              Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
              Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
              Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ]             
     MUST-EXIST
     UPDATE   p_ok IN WINDOW CURRENT-WINDOW.
  IF p_ok <> TRUE THEN RETURN.

  RUN adecomm/_setcurs.p ("WAIT":U).

  IF FileName BEGINS Directory THEN
    FileName = SUBSTRING(FileName, LENGTH(Directory, "CHARACTER":U) + 2).   
  ASSIGN FILE-INFO:FILE-NAME = FileName.
  IF FILE-INFO:FILE-TYPE = "FRW":U THEN DO:
    /* Don't allow .r's even if user asks for them */
    IF (NOT FileName MATCHES "*~~.r":U) THEN DO:
      CREATE Procedure.
      ASSIGN Procedure.name      = FileName
             NumEntries          = NUM-ENTRIES(FileName,".":U)
             Procedure.extension = IF NumEntries < 2 THEN ""
                                   ELSE ENTRY(NumEntries, FileName, ".":U)
             NewRecid            = RECID(Procedure).
      {&BROWSE-NAME}:SET-REPOSITIONED-ROW(5,"CONDITIONAL").
      RUN open-browse.
      REPOSITION {&BROWSE-NAME} TO RECID NewRecid.
    END.  /* IF not a .r */
  END.  /* IF a file */
  RUN adecomm/_setcurs.p ("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Advance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Advance V89dcnv
ON CHOOSE OF Btn_Advance IN FRAME DEFAULT-FRAME /* Advanced Settings */
DO:
  DEFINE VARIABLE hAdvSettings AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPM_Base     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperPMs    AS CHARACTER  NO-UNDO.
  define variable cValues as character no-undo.

  /* Make sure the Session Manager is running */
  IF NOT VALID-HANDLE(gshSessionManager) THEN DO:
    MESSAGE "The Session Manager isn't running and needs to be to get saved settings."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  /* Make sure that the user has specified a valid Product Module */
  ASSIGN coProductModule.
  run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                         + ' gsc_product_module.product_module_obj = ':u 
                                         + quoter(coProductModule)
                                         + ' NO-LOCK ', output cValues).
  if cValues ne ? and cValues ne '':u then
      cPMValue = dynamic-function('mappedEntry' in _h_func_lib,
                                  'gsc_product_module.product_module_code':u, cValues, true, Chr(3)).
  else
  do:
    MESSAGE "Please specify a valid Product Module."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  /* See if any of the super PMs are non-blank */
  cSuperPMs = DYNAMIC-FUNCTION("MappedEntry":U IN _h_func_lib,
                               "SDO_DlpPM":U,
                                gcProfileData,
                                TRUE,
                                CHR(3)).
  cSuperPMs = cSuperPMs + DYNAMIC-FUNCTION("MappedEntry":U IN _h_func_lib,
                                           "SBO_DlpPM":U,
                                           gcProfileData,
                                           TRUE,
                                           CHR(3)).
  cSuperPMs = cSuperPMs + DYNAMIC-FUNCTION("MappedEntry":U IN _h_func_lib,
                                           "SDV_SupPM":U,
                                           gcProfileData,
                                           TRUE,
                                           CHR(3)).
  cSuperPMs = cSuperPMs + DYNAMIC-FUNCTION("MappedEntry":U IN _h_func_lib,
                                           "SDB_SupPM":U,
                                           gcProfileData,
                                           TRUE,
                                           CHR(3)).
  IF cSuperPMs = "":U THEN DO:  /* All are blank, initialize with current value */
    cPM_Base = DYNAMIC-FUNCTION("MappedEntry":U IN _h_func_lib,
                                "PM_Base":U,
                                gcProfileData,
                                TRUE,
                                CHR(3)).
    gcProfileData = DYNAMIC-FUNCTION("assignMappedEntry":U IN _h_func_lib, 
                  "SDO_DlpPM":U  + CHR(3) +
                  "SDV_SupPM":U  + CHR(3) +
                  "SDB_SupPM":U  + CHR(3) +
                  "SBO_DlpPM":U,             /* 4 Names          */
                  gcProfileData,          /* String to Change */
                  cPM_Base    + CHR(3) +
                  cPM_Base    + CHR(3) +
                  cPM_Base    + CHR(3) +
                  cPM_Base,               /* 4 Vlaues         */
                  CHR(3),                 /* Delimiter        */
                  TRUE).                  /* Name then Value  */
       /* Store cProfile in repository */
   RUN setProfileData IN gshProfileManager (INPUT "General":U,       /* Profile type code */
                                            INPUT "Preference":U,    /* Profile code */
                                            INPUT "GenerateObjects", /* Profile data key */
                                            INPUT ?,                 /* Rowid of profile data */
                                            INPUT gcProfileData,     /* Profile data value */
                                            INPUT NO,                /* Delete flag */
                                            INPUT "PER":u).          /* Save flag (permanent) */

  END. /* If all super procedure PMs are blank */
  
  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
    RUN launchContainer IN gshSessionManager
        (INPUT  "ryadvmigw":U        /* object filename if physical/logical names unknown */
        ,INPUT  "":U                 /* physical object name (with path and extension) if known */
        ,INPUT  "ryadvmigw":U        /* logical object name if applicable and known */
        ,INPUT  YES                  /* run once only flag YES/NO */
        ,INPUT  "":U                 /* instance attributes to pass to container */
        ,INPUT  "":U                 /* child data key if applicable */
        ,INPUT  "":U                 /* run attribute if required to post into container run */
        ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
        ,INPUT  ?                    /* parent (caller) window handle if known (container window handle) */
        ,INPUT  ?                    /* parent (caller) procedure handle if known (container procedure handle) */
        ,INPUT  ?                    /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
        ,OUTPUT hAdvSettings         /* procedure handle of object run/running */
        ,OUTPUT cObjType             /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
        ).
    
    WAIT-FOR WINDOW-CLOSE, CLOSE OF hAdvSettings.   
  END.  /* do on stop, on error */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_browse V89dcnv
ON CHOOSE OF btn_browse IN FRAME DEFAULT-FRAME /* Browse... */
DO:
  DO WITH FRAME {&FRAME-NAME}.
    ASSIGN directory.
    RUN adeshar/_seldir.w (INPUT-OUTPUT directory).
    DISPLAY directory.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Convert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Convert V89dcnv
ON CHOOSE OF Btn_Convert IN FRAME DEFAULT-FRAME /* Start Migrations */
DO:
  DEFINE VARIABLE cBaseFile      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cDirName       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cFilename      AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cLine          AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cLine2         AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cPM            AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cPM_List       AS CHARACTER          NO-UNDO     INITIAL 
  "PM_Base,SDO_PM,SDO_DlpPM,SDV_PM,SDV_SupPM,SDB_PM,SDB_SupPM,SBO_PM,SBO_DlpPM":U.
  DEFINE VARIABLE cRootDirectory AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cSuperName     AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cTemp          AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE ConvRecid      AS RECID                          NO-UNDO.
  DEFINE VARIABLE dir-dirs       AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE dDlObj         AS DECIMAL                        NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer AS HANDLE                       NO-UNDO.
  DEFINE VARIABLE hAttributeTable  AS HANDLE                       NO-UNDO.
  DEFINE VARIABLE hSCMTool       AS HANDLE                         NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE iCharPos       AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE rel-name       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpDir         AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpFile        AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tmpflnm        AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE tst-line       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE CantConvert    AS LOGICAL                        NO-UNDO.
  DEFINE VARIABLE CheckLog       AS LOGICAL    INITIAL YES         NO-UNDO.
  DEFINE VARIABLE iLine          AS INTEGER                        NO-UNDO.
  DEFINE VARIABLE lDirError      AS LOGICAL                        NO-UNDO.
  DEFINE VARIABLE lDirFound      AS LOGICAL                        NO-UNDO.
  DEFINE VARIABLE lErrorFound    AS LOGICAL                        NO-UNDO.
  DEFINE VARIABLE pError         AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE ProcType       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE FromDesc       AS CHARACTER                      NO-UNDO.
  DEFINE VARIABLE cObjectFileName AS CHARACTER                      NO-UNDO.
  define variable cValues as character no-undo.
  define variable cRelPath as character no-undo.
  define variable hClassBuffer as handle no-undo.

  /* First check to be sure that a product module has been choosen */
  ASSIGN TBReg
         LogFile.

  ASSIGN hAttributeBuffer = ?
         hAttributeTable  = ?.
  
  assign coProductModule.       
  run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                         + ' gsc_product_module.product_module_obj = ':u 
                                         + quoter(coProductModule)
                                         + ' NO-LOCK ', output cValues).
  if cValues ne ? and cValues ne '':u then
      cPMValue = dynamic-function('mappedEntry' in _h_func_lib,
                                  'gsc_product_module.product_module_code':u, cValues, true, Chr(3)).
  else
  do:
    MESSAGE "Please specify a valid Product Module."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
  END.

  RUN checkDirectory (LogFile, OUTPUT lDirFound).
  IF NOT lDirFound THEN RETURN.

  DISABLE ALL EXCEPT Btn_abort filter-list WITH FRAME {&FRAME-NAME}.

  OUTPUT STREAM log-file TO VALUE(LogFile).

  PUT STREAM log-file UNFORMATTED SKIP (2)
      "Migrating Static SmartObjects to Dynamic Objects" FILL(" ",20) TODAY " " +
      STRING(TIME,"HH:MM:SS") SKIP (1).

  /* Loop through all product modules specified in the advance tool and make sure their
     directories exist */
  rRowid = ?.
  RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                           INPUT "Preference":U,      /* Profile code          */
                                           INPUT "GenerateObjects":U, /* Profile data key      */
                                           INPUT "NO":U,              /* Get next record flag  */
                                           INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                           OUTPUT gcProfileData).     /* Found profile data.   */

  /* Get the various SCM related values that may be needed */
  hSCMTool      = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, "PRIVATE-DATA:SCMTool":U).
  IF VALID-HANDLE(hSCMTool) THEN
    cRootDirectory = DYNAMIC-FUNCTION('getSessionRootDirectory':U IN THIS-PROCEDURE).
  ELSE cRootDirectory = ".":U.
  cRootDirectory = REPLACE(cRootDirectory, "~\":U, "~/":U).

  DO i = 1 TO NUM-ENTRIES(cPM_LIST):
    ASSIGN cPM = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                                   ENTRY(i, cPM_LIST), gcProfileData, TRUE, CHR(3)).
    IF cPM = "":U THEN cPM = cPMValue.
    IF cPM NE "":U THEN DO:
      run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                              + ' gsc_product_module.product_module_code = ':u 
                                              + quoter(cPM)
                                              + ' NO-LOCK ', output cValues).
      cDirName = cRootDirectory + "~/":U
               + dynamic-function('mappedEntry':u in _h_func_lib,
                                  'gsc_product_module.relative_path':u,
                                  cValues, true, chr(3)).
      ASSIGN FILE-INFO:FILE-NAME = cDirName.
      IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        lDirError = TRUE.   /* Used to space log file better */
        /* Directory doesn't exist, create it and log it */
        OS-CREATE-DIR VALUE(cDirName).
        PUT STREAM log-file UNFORMATTED
          "Creating directory " + cDirName + " for Product Module " + cPM + ".":U SKIP(1).
      END.  /* If the directory doesn't exist */
    END.  /* If we have a valid PM */
  END.  /* Loop through specified PMs */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN Directory
           FILE-INFO:filename = RIGHT-TRIM(Directory,"~\,~/")
           Directory          = FILE-INFO:FULL-PATHNAME.

    RUN open-browse.
    GET FIRST {&BROWSE-NAME}.
    IF NOT AVAILABLE Procedure THEN DO:
      MESSAGE "The file list is empty." SKIP
              "No migrations have been done." VIEW-AS ALERT-BOX INFORMATION.
      ENABLE ALL WITH FRAME {&FRAME-NAME}.
      PUT STREAM log-file UNFORMATTED
        "The file list is empty." SKIP
         "No migrations have been done.".
      OUTPUT STREAM log-file CLOSE.
      RETURN.
    END.
    {&BROWSE-NAME}:SET-REPOSITIONED-ROW(2,"CONDITIONAL").
    {&BROWSE-NAME}:SELECT-ROW(1).

    CONVERSION-LOOP:
    REPEAT WHILE AVAILABLE Procedure:
  
      ASSIGN Procedure.Stts = "..."
             ConvRecid      = RECID(Procedure).

      DISPLAY Procedure.Stts Procedure.Name Procedure.DynObject WITH BROWSE {&BROWSE-NAME}.
      PROCESS EVENTS.
      
      IF abort-conv THEN DO:
        MESSAGE "Migration batch process is aborting." SKIP
                "Do you want to check the log file:" LogFile "?"  
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET CheckLog.
        ENABLE ALL WITH FRAME {&FRAME-NAME}.
        HIDE filter-list IN FRAME {&FRAME-NAME}.
        PUT STREAM log-file UNFORMATTED
           "Migration is aborting." SKIP.
        OUTPUT STREAM log-file CLOSE.
        IF CheckLog THEN RUN adecomm/_pwmain.p
                             ("":U,            /* Parent ID [eg. UIB] */
                              logFile,         /* FileList            */
                              "READ-ONLY":U).  /* p_Edit_command      */

        RETURN.
      END.
      
      /* See if the procedure is some where below the directory:
            For example: the directory might be C:\work\area but 
                         the procedure might be C:\test\myfile.w
         This can easily happen if the user pressed the "Add a File" button. */
      IF SUBSTRING(Procedure.Name,2,1) = ":" THEN DO:
        /* Here the user has choosen a file not in the directory specified. */
        ASSIGN i       = R-INDEX(Procedure.Name,"~\")
               tmpDir  = SUBSTRING(Procedure.Name,1 , i - 1, "CHARACTER":U)
               tmpFile = SUBSTRING(Procedure.Name,i + 1, -1, "CHARACTER":U).
      END.
      ELSE ASSIGN tmpDir  = directory
                  tmpFile = Procedure.Name.

      /* Look for a null (or trivially small) file */
      CantConvert = TRUE.  /* Assume that we can't convert until we discover that we can. */
      FILE-INFO:FILE-NAME = SEARCH(tmpDir + "~\" + tmpFile).
      IF FILE-INFO:FILE-SIZE < 50 THEN DO:  /* Too small to contain any useful id information */
        PUT STREAM log-file UNFORMATTED
           "Procedure " + procedure.name + " is an invalid SmartObject." + CHR(10).
        IF (tmpFile MATCHES "*~.p" OR  tmpFile MATCHES "*~.w") AND TBReg:CHECKED THEN DO:
          IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
            ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                                         INPUT "RepositoryDesignManager":U) 
                                                         NO-ERROR.
                                                         
           cRelPath = dynamic-function('mappedEntry':u in _h_func_lib,
                                      'gsc_product_module.relative_path':u,
                                      cValues, true, chr(3)).                                                         
          /* Check physical file is stored in same relative directory as module */
          ASSIGN cObjectFileName = REPLACE(Procedure.Name, "~\", "/")
                 cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
          IF R-INDEX(cObjectFileName,".") > 0
             AND SEARCH(cRelPath 
                       + (IF cRelPath > "" THEN "~/":U ELSE "") 
                       + cObjectFileName ) = ? THEN 
          DO:
             ASSIGN pError = cObjectFileName + " is not located in the '" 
                            + (IF cRelPath > "" AND cRelPath <> "."
                              THEN cRelPath
                              ELSE "default")
                            + "' directory." + CHR(10) 
                            + "The file must be located in the same directory as the product module relative path.":U.
             PUT STREAM log-file UNFORMATTED "Not registered. " + pError + CHR(10).
             ASSIGN Procedure.Stts = "Error"
             lErrorFound       = YES.

          END.                  
          ELSE DO:
             /* Register this procedure */
             RUN insertObjectMaster IN ghRepositoryDesignManager 
               ( INPUT  cObjectFileName,                         /* pcObjectName         */
                 INPUT  "":U,                                    /* pcResultCode         */
                 INPUT  cPMValue,                                /* pcProductModuleCode  */
                 INPUT  "Procedure":U,                           /* pcObjectTypeCode     */
                 INPUT  "":U,                                    /* pcObjectDescription  */
                 INPUT  "":U,                                    /* pcObjectPath         */
                 INPUT  "":U,                                    /* pcSdoObjectName      */
                 INPUT  "":U,                                    /* pcSuperProcedureName */
                 INPUT  NO,                                      /* plIsTemplate         */
                 INPUT  YES,                                     /* plIsStatic           */
                 INPUT  "":U,                                    /* pcPhysicalObjectName */
                 INPUT  NO,                                      /* plRunPersistent      */
                 INPUT  "":U,                                    /* pcTooltipText        */
                 INPUT  "":U,                                    /* pcRequiredDBList     */
                 INPUT  "":U,                                    /* pcLayoutCode         */
                 INPUT  hAttributeBuffer,
                 INPUT  TABLE-HANDLE hAttributeTable,
                 OUTPUT dDlObj                                   ) NO-ERROR.
             pError = RETURN-VALUE.

             IF pError NE "":U THEN DO:
               PUT STREAM log-file UNFORMATTED "Not registered. " + pError + CHR(10).
               ASSIGN Procedure.Stts = "Error"
                      lErrorFound       = YES.
             END.  /* If an error occurred */
             ELSE DO:
               PUT STREAM log-file UNFORMATTED "Registered as 'Procedure'." + CHR(10).
               ASSIGN Procedure.Stts = "Registered".
             END.  /* Else no error and properly registered */
          END.  /* No error in file directory */
        END.  /* If it is a .p or .w and all is to be registered */
        ELSE DO:  /* Don't try to register */
          PUT STREAM log-file UNFORMATTED "    No processing occurred." + CHR(10).
          ASSIGN Procedure.Stts = "No Action".
        END.
      END. /* If it is too small to analyze */
      
      ELSE DO: /* Have a procedure to migrate - First check to see if it is a supported
                  object.  Currently we only migrate V8 and V9 SDVs, SDBs and SDOs */
        ASSIGN ProcType = ""
               FromDesc = "".
               
        IF tmpFile MATCHES "*_CL.w":U OR tmpFile MATCHES "*~.i":U THEN DO:
          /* _Cls are considered part of an SDO  and .i's are not objects */
          PUT STREAM log-file UNFORMATTED tmpFile + " is not migratable." + CHR(10) +
                   "    No processing occurred." + CHR(10).
          ASSIGN Procedure.Stts = "No Action".
        END.

        ELSE DO:  /* Go ahead and try to covert this object */
          INPUT FROM VALUE(SEARCH(tmpDir + "~\" + tmpFile)) NO-ECHO.
          IMPORT UNFORMATTED tst-line.

          IF INDEX(tst-line,"AB_v9") > 0 OR INDEX(Tst-line,"UIB_v8") > 0 THEN DO:
            /* There is a chance that we can migrate this */
            LookForProcType:
            REPEAT:
              IMPORT UNFORMATTED tst-line.
              IF INDEX(tst-line,"Description:":U) > 0 THEN DO:
                /* Find token that begins "Smart" */
                Smart-Search:
                REPEAT i = 1 TO NUM-ENTRIES(tst-line," ":U):
                  IF ENTRY(i,tst-line," ":U) BEGINS "SMART" OR 
                     ENTRY(i,tst-line," ":U) EQ "SBO":U THEN DO:
                    FromDesc = ENTRY(i, tst-line, " ":U).
                    LEAVE Smart-Search.
                  END. /* If found a Smart Type of object */
                END.  /* SmartSearch - looping though tokens looking for Smart */
              END.  /* Id found the description line */
              ELSE IF INDEX(tst-line,"PROCEDURE-TYPE":U) > 0 THEN DO:
                ProcType = ENTRY(3, REPLACE(tst-line,"  ":U, " ":U), " ":U).
                IF INDEX(tst-line,"SmartDataViewer":U) > 0 OR 
                   INDEX(tst-Line,"SmartViewer":U) > 0 OR
                   INDEX(tst-line,"SmartDataObject":U) > 0 OR
                   INDEX(tst-line,"SmartDataBrowser":U) > 0 OR
                   INDEX(tst-line,"SmartBrowser":U) > 0 OR
                   INDEX(tst-line,"SmartBusinessObject":U) > 0 THEN 
                  ASSIGN CantConvert = FALSE.
                LEAVE LookForProcType.
              END. /* Procedure-type line */
            END. /* LookForProcType Loop */
          END. /* If this is a V8 or V9 AppBuilder object */

          IF LOOKUP(ProcType, "SBO,SmartBusinessObject":U) > 0 THEN DO:
            /* This is an SBO, need to compile a list of its SDOs */
            cSDOList = "":U.
            REPEAT:
              IMPORT UNFORMATTED tst-line.
              IF INDEX(tst-line,"RUN constructObject":U) > 0 THEN DO:
                IMPORT UNFORMATTED tst-line.
                tst-line = TRIM(REPLACE(tst-line, "  ":U, " ":U)).
                cTemp = TRIM(ENTRY(1, ENTRY(2, tst-line, " ":U), CHR(3)), "~'":U).
                IF ENTRY(1,tst-line," ") NE "INPUT":U OR 
                   ENTRY(2, cTemp, ".":U) NE "w":U THEN DO:  /* Should have .w  */
                  PUT STREAM log-file UNFORMATTED "    Error reading SDO list in " + 
                             tmpDir + "~\":U + tmpFile + ".":U + CHR(10).
                  ASSIGN Procedure.Stts = "Error"
                         lErrorFound       = YES.
                END. /* If line doesn't start with INPUT or SDO doesn't end with .w */
                cSDOList = cSDOList + ",":U + REPLACE(cTemp, "~/":U, "~\":U).
              END.  /* IF we have found a Run Construct Obejct line */
              IF INDEX(tst-line, "RUN AddLink":U) > 0 THEN LEAVE.  /* Done reading  */
            END. /* Repeat looking for SDO lines */
            cSDOList = LEFT-TRIM(cSDOList, ",":U).
          END.  /* If we are migrating an SBO */

          INPUT CLOSE.
          
          /* See if ProcType is valid */
          IF ProcType = "":U THEN
            ASSIGN ProcType = FromDesc.  /* See if we got a valid type in FromDesc */
          IF ProcType = "":U THEN
            ASSIGN ProcType = "Procedure":U.  /* If not default to procedure */

          /* set-up real object type as defined in repository */
          CASE ProcType:
            WHEN "SmartDataObject":U OR 
            WHEN "SmartData":U THEN
              ASSIGN ProcType = "SDO":U.
            WHEN "SmartBusinessObject":U THEN
              ASSIGN ProcType = "SBO":U.
            WHEN "SmartDataViewer":U OR 
            WHEN "SmartViewer":U THEN
              ASSIGN ProcType = "StaticSDV":U.
            WHEN "SmartDataBrowser":U OR 
            WHEN "SmartBrowser":U THEN
              ASSIGN ProcType = "StaticSDB":U.
            WHEN "SmartObject":U THEN
              ASSIGN ProcType = "StaticSO":U.
          END CASE.
          
          IF CantConvert THEN DO: /* Register this procedure */
            /* First see if it is to be registered. */
            IF TBReg:CHECKED THEN DO:

              /* See if we can find our proctype in the gsc_object_type table */
              hClassBuffer = {fnarg getCacheClassBuff ProcType gshRepositoryManager}.
              if not hClassBuffer:available then
                ProcType = "Procedure":U.  /* Last resort */

              IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
                ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                                             INPUT "RepositoryDesignManager":U) 
                                                             NO-ERROR.
                                                                                                            
               /* Check physical file is stored in same relative directory as module */
              ASSIGN cObjectFileName = REPLACE(Procedure.Name, "~\", "/")
                     cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
              IF R-INDEX(cObjectFileName,".") > 0 
                 AND SEARCH(cRelPath 
                            + (IF cRelPath > "" THEN "~/":U ELSE "") 
                            + cObjectFileName ) = ? THEN 
              DO:
                 ASSIGN pError = cObjectFileName + " is not located in the '" 
                                + (IF cRelPath > "" AND cRelPath <> "."
                                  THEN cRelPath
                                  ELSE "default")
                                + "' directory." + CHR(10) 
                                + "The file must be located in the same directory as the product module relative path.":U.
                 PUT STREAM log-file UNFORMATTED "Not registered. " + pError + CHR(10).
                 ASSIGN Procedure.Stts = "Error"
                 lErrorFound       = YES.
 
              END.                  
              ELSE DO:                                               
                 /* Register this procedure */
                 RUN insertObjectMaster IN ghRepositoryDesignManager 
                   ( INPUT  cObjectFileName,                         /* pcObjectName         */
                     INPUT  "":U,                                    /* pcResultCode         */
                     INPUT  cPMValue,                                /* pcProductModuleCode  */
                     INPUT  ProcType,                                /* pcObjectTypeCode     */
                     INPUT  "":U,                                    /* pcObjectDescription  */
                     INPUT  "":U,                                    /* pcObjectPath         */
                     INPUT  "":U,                                    /* pcSdoObjectName      */
                     INPUT  "":U,                                    /* pcSuperProcedureName */
                     INPUT  NO,                                      /* plIsTemplate         */
                     INPUT  YES,                                     /* plIsStatic           */
                     INPUT  "":U,                                    /* pcPhysicalObjectName */
                     INPUT  NO,                                      /* plRunPersistent      */
                     INPUT  "":U,                                    /* pcTooltipText        */
                     INPUT  "":U,                                    /* pcRequiredDBList     */
                     INPUT  "":U,                                    /* pcLayoutCode         */
                     INPUT  hAttributeBuffer,
                     INPUT  TABLE-HANDLE hAttributeTable,
                     OUTPUT dDlObj                                   ) NO-ERROR.
                 pError = RETURN-VALUE.

                 IF pError NE "":U THEN DO:
                   PUT STREAM log-file UNFORMATTED "Not registered. " + pError + CHR(10).
                   ASSIGN Procedure.Stts = "Error"
                          lErrorFound       = YES.
                 END.  /* If an error occurred */
                 ELSE DO:
                   PUT STREAM log-file UNFORMATTED "Procedure " + procedure.name + " registered as '" + ProcType + "'." + CHR(10).
                   ASSIGN Procedure.Stts = "Registered".
                 END.  /* Else no error and properly registered */
              END. /* END valid directory */
            END.  /* If TBReg - need to register all objects */
        
            ELSE DO:  /* This isn't migratable but is also not to be registered */
              PUT STREAM log-file UNFORMATTED
                 "Procedure " + procedure.name + " is not a migratable object." + CHR(10) +
                 "    No processing occurred." + CHR(10).
              Procedure.Stts = "No Action".
            END. /* ELSE DO this isn't migratable and not to be registered */
          END. /* If CantConvert */

          ELSE DO: /* Migrate here */
            PUT STREAM log-file UNFORMATTED CHR(10) +
                "Migrating " + Procedure.Name + "."
                FORMAT "X(75)" + CHR(10).

            /* First strip .extension */
            cBaseFile = TmpFile.
            IF NUM-ENTRIES(TmpFile,".":U) > 1 THEN cBaseFile = ENTRY(1,TmpFile,".":U).
            cBaseFile = REPLACE(cBaseFile, "~/":U, "~\":U).
            cBaseFile = ENTRY(NUM-ENTRIES(cBaseFile,"~\":U), cBaseFile, "~\":U).

            /* We know the type, do name migration here */
            RUN FormNewNames(INPUT cBaseFile,    /* Original name without extension */
                             INPUT ProcType,     /* Procedure type                  */ 
                             OUTPUT cFilename,   /* New object filename             */
                             OUTPUT cSuperName). /* DLP or SuperProc Name           */
          
            RUN CONVERT (INPUT SEARCH(tmpDir + "~\" + tmpFile),  /* Static File to be migrated */
                         INPUT cFilename,                        /* New dynamic Name           */
                         INPUT cSuperName,                       /* Super Proc or DLP name     */
                         INPUT ProcType,                         /* Procedure type             */
                         OUTPUT pError).                         /* Error message if error     */

            IF pError NE ""  AND 
               NOT pError BEGINS "Associated datasource" THEN DO:
              IF pError = "Error":U THEN pError = "":U.  /* A flag ... no message */
              ASSIGN lErrorFound = YES
                     pError = pError + (IF pError NE "":U THEN CHR(10) ELSE "":U) +
                              Procedure.Name + " not migrated." + CHR(10).
            END. /* pError has a value */
            ELSE /* Either no error or a non-fatal error */
              pError = Procedure.Name + " was successfully migrated to " + cFilename + 
                        "." + CHR(10) + pError.

            DO iLine = 1 TO NUM-ENTRIES(pError,CHR(10)):
              ASSIGN cLine    = ENTRY(iLine,pError,CHR(10))
                     iCharPos = 0
                     cLine2   = "".
              IF LENGTH(cLine) > 85 THEN DO:
                /* Break it into 2 lines */
                iCharPos = R-INDEX(SUBSTRING(cLine,1, 85), CHR(32)).
                cLine2 = SUBSTRING(cLine, iCharPos).
                cLine  = SUBSTRING(cLine, 1, iCharPos).
              END.
              PUT STREAM log-file UNFORMATTED
                         "    " +
                        (IF pError = "" THEN "No errors." ELSE cLine)
                         FORMAT "X(85)" SKIP.
              IF cLine2 NE "":U THEN
                PUT STREAM log-file UNFORMATTED
                           "    " + cLine2 FORMAT "X(85)" SKIP.
            END.
         
            ASSIGN Procedure.Stts      = IF NOT lErrorFound THEN "Migrated" ELSE "Error"
                   Procedure.DynObject = IF NOT lErrorFound THEN cFilename   ELSE "Error".

            /* Close the migrated window */
            IF VALID-HANDLE(_h_win) THEN
              RUN choose_close IN _h_uib. 

          END.  /* If migrating */
        END.  /* Else do because it isn't too small to consider */
      END.  /* Else DO (have something to migrate) */
      DISPLAY Procedure.Stts Procedure.Name Procedure.DynObject WITH BROWSE {&BROWSE-NAME}.

      GET NEXT {&BROWSE-NAME}.
      IF NOT AVAILABLE Procedure THEN LEAVE CONVERSION-LOOP.
      {&BROWSE-NAME}:SELECT-NEXT-ROW().
    END.  /* Repeat while available Procedure */
  END.  /* Do With Frame */

  BELL.
  ENABLE ALL EXCEPT filter-list WITH FRAME {&FRAME-NAME}.
  OUTPUT STREAM log-file CLOSE.

  IF lErrorFound THEN
      MESSAGE "Errors encountered." SKIP
              "Do you want to check the log file:" logFile "?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET CheckLog.
  ELSE
      MESSAGE "No errors were encountered." SKIP
              "Do you want to check the log file:" logFile "?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET CheckLog.
  IF CheckLog THEN RUN adecomm/_pwmain.p
                             ("":U,          /* Parent ID [eg. UIB] */
                              logFile,       /* FileList            */
                              "READ-ONLY").  /* p_Edit_command      */
END.  /* DO for trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Exit V89dcnv
ON CHOOSE OF Btn_Exit IN FRAME DEFAULT-FRAME /* Exit */
DO:
  APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help V89dcnv
ON CHOOSE OF Btn_Help IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT":U, {&Static_to_Dynamic_Conversion_Utility},?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Remove V89dcnv
ON CHOOSE OF Btn_Remove IN FRAME DEFAULT-FRAME /* Remove */
DO:
  DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
  DEFINE VARIABLE num-sel AS INTEGER     NO-UNDO.
  
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS < 1 THEN DO:
    MESSAGE "No procedures are selected." SKIP
            " Nothing has been deleted." VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  ELSE DO:
    num-sel = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO i = num-sel to 1 BY -1:
      {&BROWSE-NAME}:FETCH-SELECTED-ROW(i).
      DELETE PROCEDURE.
    END.
    {&BROWSE-NAME}:DELETE-SELECTED-ROWS().
  END.  /* Else something was selected */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Sort V89dcnv
ON CHOOSE OF Btn_Sort IN FRAME DEFAULT-FRAME /* Sort ... */
DO:
  DEFINE VARIABLE cur-sort AS INTEGER              NO-UNDO.
  cur-sort = sort-mode.
  RUN protools/sort-dia.w (INPUT-OUTPUT sort-mode).
  IF sort-mode NE cur-sort THEN RUN open-browse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule V89dcnv
ON VALUE-CHANGED OF coProductModule IN FRAME DEFAULT-FRAME /* Product Module */
DO:
  DEFINE VARIABLE hTBReg AS HANDLE     NO-UNDO.
  define variable cValues as character no-undo.
    
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN pm_obj = DECIMAL(SELF:SCREEN-VALUE)
           hTBReg = TBReg:HANDLE.
           
    run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                          + ' gsc_product_module.product_module_obj = ':u 
                                          + quoter(pm_obj)
                                          + ' NO-LOCK ', output cValues).
    if cValues ne '' and cValues ne ? then
    do:
        hTBReg:TOOLTIP = 'To be registered, non migrated static objects must be in the "' +
                           dynamic-function('mappedEntry':u in _h_func_lib,
                                            'gsc_product_module.relative_path':u, cValues, true, chr(3))
                       + '" directory'.
      RUN UpdatePMinProfile.
    END.
    ELSE hTBReg:TOOLTIP = "You must enter a valid product module above.".
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Directory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Directory V89dcnv
ON RETURN OF Directory IN FRAME DEFAULT-FRAME
DO:
  APPLY "TAB".
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V89dcnv 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Set the combo box */
{adecomm/cbdropx.i &Frame  = "FRAME {&FRAME-NAME}"
                   &CBFill = "file-filter"
                   &CBList = "filter-list"
                   &CBBtn  = "filter-btn"
                   &CBInit = '"~*~.w"'}
                   
/* Set the Product Module combo-box */
RUN PopulatePM.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Initialize gcProfileData */
  /* Set the basic PM in the Migration Settings profile */
  rRowid = ?.
  IF VALID-HANDLE(gshProfileManager) THEN
    RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                             INPUT "Preference":U,      /* Profile code          */
                                             INPUT "GenerateObjects":U, /* Profile data key      */
                                             INPUT "NO":U,              /* Get next record flag  */
                                             INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                             OUTPUT gcProfileData).     /* Found profile data.   */

  IF gcProfileData = ? OR INDEX(gcProfileData,"SBO_MSDO":U) = 0 THEN DO:
    /* This is the first time this user has tried to access the StatToDyn settings,
       create a default set for him                                                            */
    gcProfileData = "PM_Base":U     + CHR(3) + cPMValue         + CHR(3) +
                    "SDO_Type":U    + CHR(3) + "DynSDO":U       + CHR(3) +
                    "SDO_PM":U      + CHR(3) + cPMValue         + CHR(3) +
                    "SDO_RmPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SDO_RmSuf":U   + CHR(3) + "":U             + CHR(3) +
                    "SDO_AdPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SDO_AdSuf":U   + CHR(3) + "w":U            + CHR(3) +
                    "SDO_DlpOpt":U  + CHR(3) + "ValOnly":U      + CHR(3) +
                    "SDO_DlpPM":U   + CHR(3) + cPMValue         + CHR(3) +
                    "SDO_DlpPre":U  + CHR(3) + "":U             + CHR(3) +
                    "SDO_DlpSuf":U  + CHR(3) + "logcp":U        + CHR(3) +

                    "SDV_Type":U    + CHR(3) + "DynView":U      + CHR(3) +
                    "SDV_PM":U      + CHR(3) + cPMValue         + CHR(3) +
                    "SDV_RmPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SDV_RmSuf":U   + CHR(3) + "":U             + CHR(3) +
                    "SDV_AdPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SDV_AdSuf":U   + CHR(3) + "w":U            + CHR(3) +
                    "SDV_SupOpt":U  + CHR(3) + "None":U         + CHR(3) +
                    "SDV_SupPM":U   + CHR(3) + cPMValue         + CHR(3) +
                    "SDV_SupPre":U  + CHR(3) + "":U             + CHR(3) +
                    "SDV_SupSuf":U  + CHR(3) + "super":U        + CHR(3) +

                    "SDB_Type":U    + CHR(3) + "DynBrow":U      + CHR(3) +
                    "SDB_PM":U      + CHR(3) + cPMValue         + CHR(3) +
                    "SDB_RmPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SDB_RmSuf":U   + CHR(3) + "":U             + CHR(3) +
                    "SDB_AdPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SDB_AdSuf":U   + CHR(3) + "w":U            + CHR(3) +
                    "SDB_SupOpt":U  + CHR(3) + "None":U         + CHR(3) +
                    "SDB_SupPM":U   + CHR(3) + cPMValue         + CHR(3) +
                    "SDB_SupPre":U  + CHR(3) + "":U             + CHR(3) +
                    "SDB_SupSuf":U  + CHR(3) + "super":U        + CHR(3) +

                    "SBO_Type":U    + CHR(3) + "DynSBO":U       + CHR(3) +
                    "SBO_PM":U      + CHR(3) + cPMValue         + CHR(3) +
                    "SBO_RmPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SBO_RmSuf":U   + CHR(3) + "":U             + CHR(3) +
                    "SBO_AdPre":U   + CHR(3) + "":U             + CHR(3) +
                    "SBO_AdSuf":U   + CHR(3) + "w":U            + CHR(3) +
                    "SBO_MSDO":U    + CHR(3) + "YES":U          + CHR(3) +
                    "SBO_DlpOpt":U  + CHR(3) + "ValOnly":U      + CHR(3) +
                    "SBO_DlpPM":U   + CHR(3) + cPMValue         + CHR(3) +
                    "SBO_DlpPre":U  + CHR(3) + "":U             + CHR(3) +
                    "SBO_DlpSuf":U  + CHR(3) + "logcp":U.
  END.  /* If first time */

  /* Store cProfile in repository */
  RUN setProfileData IN gshProfileManager (INPUT "General":U,       /* Profile type code */
                                           INPUT "Preference":U,    /* Profile code */
                                           INPUT "GenerateObjects", /* Profile data key */
                                           INPUT ?,                 /* Rowid of profile data */
                                           INPUT gcProfileData,     /* Profile data value */
                                           INPUT NO,                /* Delete flag */
                                           INPUT "PER":u).          /* Save flag (permanent) */



  RUN enable_UI.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckDirectory V89dcnv 
PROCEDURE CheckDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Checks to see if the file we are about to write to is in a valid
               directory
  Parameters:
    INPUT  FName    Name of the file (prepended with any directory info)
    OUTPUT pSuccess True if the directory is found.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER FName    AS CHARACTER                  NO-UNDO.
DEFINE OUTPUT PARAMETER pSuccess AS LOGICAL    INITIAL FALSE   NO-UNDO.

DEFINE VARIABLE errcode     AS INTEGER    NO-UNDO.
DEFINE VARIABLE ErrorStatus AS LOGICAL    NO-UNDO.
DEFINE VARIABLE DirName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE BaseName    AS CHARACTER  NO-UNDO.

  RUN adecomm/_osprefx.p (input FName, output DirName, output BaseName).  

  ASSIGN FILE-INFO:FILE-NAME = DirName
         pSuccess = True.
  IF FILE-INFO:FULL-PATHNAME = ? THEN
  DO:
    ASSIGN ThisMessage = "Directory " + "'" + DirName + "'" + " does not exist." + 
                          CHR(10) + "Do you want to create it?"
                ErrorStatus = no.
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q":U, "yes-no":U, ThisMessage).
    IF ErrorStatus THEN DO:
      RUN adecomm/_oscpath.p (INPUT DirName, OUTPUT errcode).
      ASSIGN psuccess = IF errcode NE 0 THEN FALSE ELSE TRUE.
    END.
    ELSE pSuccess = FALSE.
  END. /* unknown path/file */   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convert V89dcnv 
PROCEDURE convert :
/*------------------------------------------------------------------------------
  Purpose:     To migrate a static object to a Dynamics Dynamic Object
  Parameters:  
      INPUT pcSourceFile - File to be migrated
      INPUT pcObjName    - New Object Filename
      INPUT pcSuperName  - Name of Super Procedure ort DLP to create
      INPUT pcType       - Procedure type of object being migrated 
      OUTPUT pcError     - Any error message (Blank mean success.)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcSourceFile AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjName    AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcSuperName  AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcType       AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError      AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cAssocError          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLookupVal           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNewName             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSuperProdMod        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSuperProcOpt        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cTemp                AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i                    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iSetting             AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lSkip                AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lIsInRepos           AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lOkToGo              AS LOGICAL    NO-UNDO.
    define variable cValues as character no-undo.

    pcError = "":U.

    /* Before doing anything, check to see if this is an SBO.  If it is, process
       its SDO's first */
    IF pcType = "SBO":U THEN DO:
      RUN processSDOsOfSBO(pcSourceFile, OUTPUT lOKToGo).
      IF NOT lOkToGo THEN DO:
        pcError = "Error":U.
        RETURN.
      END.  /* Not Ok */
    END. /* Print errors */

    /* First step is to load it into the Appbuilder */
    RUN adeuib/_qssuckr.p (INPUT pcSourceFile,       /* File to read        */
                           INPUT "",                 /* WebObject           */
                           INPUT "WINDOW-SILENT":U,  /* Import mode         */
                           INPUT FALSE).             /* Reading from schema */
    IF RETURN-VALUE BEGINS "_ABORT":U THEN DO:
      pcError = RETURN-VALUE.
      IF LENGTH(pcError,"CHARACTER") > 7 THEN
        pcError = SUBSTRING(pcError, 8, -1, "CHARACTER").
      ELSE pcError = "":U.
      RETURN.
    END.
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

    /* This should never happen, but it is here to clear the ERROR-STATUS handle */
    IF NOT AVAILABLE _P THEN
      MESSAGE "Can't find _P" VIEW-AS ALERT-BOX.

    /* Depends on type */
    cLookupVal = (IF LOOKUP(pcType,"SDO,SBO":U) > 0 
                  THEN pcType ELSE SUBSTRING(pcType, 7, 3, "CHARACTER":U)) + "_PM":U.
    ASSIGN _P.product_module_code = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                                               cLookupVal, gcProfileData, TRUE, CHR(3)).
                                               
    run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                         + ' gsc_product_module.product_module_code = ':u 
                                         + quoter(_P.product_module_code)
                                         + ' NO-LOCK ', output cValues).
   
    ASSIGN  _P.object_filename       = pcObjName
            _P._SAVE-AS-FILE         = pcObjName
            _P.product_module_code   = dynamic-function('mappedEntry':u in _h_func_lib,
                                                        'gsc_product_module.product_module_code':u,
                                                        cValues,
                                                        true,
                                                        chr(3))
            _P.object_type_code      = 
                    IF LOOKUP(_P._TYPE,"SmartDataViewer,SmartViewer":U) > 0 THEN
                                                 "DynView":U ELSE _P._TYPE
            _P.object_path           = dynamic-function('mappedEntry':u in _h_func_lib,
                                                        'gsc_product_module.relative_path':u,
                                                        cValues,
                                                        true,
                                                        chr(3))
            _P.design_action         = "OPEN,MIGRATE":u
            _P.static_object         = NO
            _P.design_ryobject       = YES
            _P.design_precid         = RECID(_P) NO-ERROR.

   _P.design_action = "OPEN,MIGRATE":u.

   /* We need to load the _C of the window's _U with user preference info */
   FIND _U WHERE RECID(_U) = _P._u-recid.  /* Window */
   FIND _C WHERE RECID(_C) = _U._x-recid.  /* _C of window */

   /* If we are working on an SBO, we have already migrated the SDOs and need to update
      the _S._settings to reflect the new objectNames */
   IF pcType = "SBO":U THEN DO:
     DO i = 1 TO NUM-ENTRIES(cSDOList):
       /* Find the corresponding _S */
       FIND _S WHERE _S._FILE-NAME = ENTRY(1, ENTRY(i, cSDOList), "|":U) NO-ERROR.
       IF NOT AVAILABLE _S THEN DO:
         pcError = pcError + "    ":U + "Unable to locate instance properties for " +
                             ENTRY(1, ENTRY(i, cSDOList), "|":U) + "." + CHR(10).
       END.
       ELSE DO:
         cNewName = ENTRY(2, ENTRY(i, cSDOList), "|":U).
         UpdateFileName:
         DO iSetting = 1 TO NUM-ENTRIES(_S._SETTING, CHR(3)):
           IF ENTRY(iSetting, _S._SETTING, CHR(3)) BEGINS "ObjectName":U THEN DO:
             cTemp = "ObjectName":U + CHR(4) + cNewName.
             ENTRY(iSetting, _S._SETTING, CHR(3)) = cTemp.
             LEAVE UpdateFileName.
           END.  /* If we have the Objectname setting */
         END.  /* UpdateFileName search loop */
       END. /* Else we have found the _S */
     END. /* Do all of the contained SDOs */
   END. /* If we are working on an SBO */

   /* Load preferred Product module  */
   cLookupVal = (IF LOOKUP(pcType,"SDO,SBO":U) > 0 
                 THEN pcType + "_DlpPM":U 
                 ELSE SUBSTRING(pcType, 7, 3, "CHARACTER":U) + "_SupPM":U).
  
   cSuperProdMod = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                                cLookupVal,
                                                gcProfileData,
                                                TRUE,
                                                CHR(3)).

   IF cSuperProdMod = "":U THEN cSuperProdMod = cPMValue.

    run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                         + ' gsc_product_module.product_module_code = ':u 
                                         + quoter(cSuperProdMod)
                                         + ' NO-LOCK ', output cValues).
              
   if cValues ne ? and cValues ne '':u then
   do:
       /* Load preferred procname */
       IF LOOKUP(pcType,"SDO,SBO":U) > 0 THEN
           _C._DATA-LOGIC-PROC = dynamic-function('mappedEntry':u in _h_func_lib,
                                                  'gsc_product_module.relative_path':u,
                                                  cValues, true, chr(3))
                               + "~/":U + pcSuperName + ".p".
        ELSE
            _C._CUSTOM-SUPER-PROC = dynamic-function('mappedEntry':u in _h_func_lib,
                                                     'gsc_product_module.relative_path':u,
                                                     cValues, true, chr(3))
                                  + "~/":U + pcSuperName + ".p".

     IF LOOKUP(pcType,"SDO,SBO":U) > 0 
       THEN _C._DATA-LOGIC-PROC-PMOD = dynamic-function('mappedEntry':u in _h_func_lib,
                                                        'gsc_product_module.product_module_code':u,
                                                        cValues, true, chr(3)).
       ELSE _C._CUSTOM-SUPER-PROC-PMOD  = dynamic-function('mappedEntry':u in _h_func_lib,
                                                           'gsc_product_module.product_module_code':u,
                                                            cValues, true, chr(3)).
   END.  /* If we have avalid gsc_product_module */

   /* Before generating new objects, make sure that the object(s) don't alrady exist */

   IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
     ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                                  INPUT "RepositoryDesignManager":U) 
                                                  NO-ERROR.
   lIsInrepos = DYNAMIC-FUNCTION("ObjectExists":U IN ghRepositoryDesignManager,
                                 INPUT pcObjName ).
   IF lIsInRepos THEN DO:
     pcError = pcError + pcObjName + " already exists in the repository." + CHR(10).
     lSkip = TRUE.
   END.

   /* If superProcOpt NE "None, make sure that the super proc or DLP doesn't alrady exist */
   lIsInrepos = DYNAMIC-FUNCTION("ObjectExists":U IN ghRepositoryDesignManager,
                                 INPUT pcSuperName  ).

   CASE pcType:
     WHEN "SDO":U       THEN cLookupVal = "SDO_DlpOpt":U.
     WHEN "SBO":U       THEN cLookupVal = "SBO_DlpOpt":U.
     WHEN "StaticSDV":U THEN cLookupVal = "SDV_SupOpt":U.
     WHEN "StaticSDB":U THEN cLookupVal = "SDB_SupOpt":U.
   END CASE.
   cSuperProcOpt = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                     cLookupVal,
                                     gcProfileData,
                                     TRUE,
                                     CHR(3)).


   IF lIsInrepos AND cSuperProcOpt NE "<None>" THEN DO:
     pcError = pcError + pcSuperName + " already exists in the repository." + CHR(10).
     lSkip = TRUE.
   END.

   IF NOT lSkip THEN
     RUN adeuib/_gendynp.p (INPUT RECID(_P), 
                            OUTPUT pcError,          /* Error saving object */
                            OUTPUT cAssocError).     /* Error saving associated procedure - if there is one */
   ELSE
     pcError = PcError + "Consider changing the naming rules." + 
                         CHR(10).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V89dcnv  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(V89dcnv)
  THEN DELETE WIDGET V89dcnv.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI V89dcnv  _DEFAULT-ENABLE
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
  DISPLAY Directory tog_subdir file-filter coProductModule  TBReg 
          LogFile 
      WITH FRAME DEFAULT-FRAME IN WINDOW V89dcnv.
  ENABLE Directory btn_browse tog_subdir file-filter filter-btn Btn-rebuild 
         coProductModule  BROWSE-1 Btn_Sort Btn_Add Btn_Remove TBReg 
         Btn_Advance LogFile Btn_Convert Btn_Abort Btn_Exit Btn_Help RECT-1 
         RECT-2 RECT-4 RECT-5 
      WITH FRAME DEFAULT-FRAME IN WINDOW V89dcnv.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  DISPLAY srch-lbl srch-dir 
      WITH FRAME FRAME-A IN WINDOW V89dcnv.
  ENABLE srch-lbl srch-dir RECT-6 
      WITH FRAME FRAME-A IN WINDOW V89dcnv.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW V89dcnv.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormNewNames V89dcnv 
PROCEDURE FormNewNames :
/*------------------------------------------------------------------------------
  Purpose:     Follow the User Preferences in gcProfileData to strip off
               old prefixes and suffixes  and add new
  Parameters:  
     INPUT  pcOldName  - Orignal name without extension
     INPUT  pcProcType - Old proctype
     OUTPUT pcNewName  - New object name
     OUTPUT pcSuper    - Super Procedure (or DLP) name
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcOldName           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcProcType          AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcNewName           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSuper             AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE rmPrefix    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rmSuffix    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE AddPrefix   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE AddSuffix   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE AddSuperPre AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE AddSuperSuf AS CHARACTER  NO-UNDO.

  IF pcProcType BEGINS "Static" THEN
    pcProcType = SUBSTRING(pcProcType, 7 ,3, "CHARACTER":U).
 
  rmPrefix = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                              pcProcType + "_RmPre":U,
                              gcProfileData,
                              TRUE,
                              CHR(3)).
  rmSuffix = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                              pcProcType + "_RmSuf":U,
                              gcProfileData,
                              TRUE,
                              CHR(3)).
  AddPrefix = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                              pcProcType + "_AdPre":U,
                              gcProfileData,
                              TRUE,
                              CHR(3)).
  AddSuffix = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                              pcProcType + "_AdSuf":U,
                              gcProfileData,
                              TRUE,
                              CHR(3)).
  AddSuperPre = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                              pcProcType + (IF LOOKUP(pcProcType,"SDO,SBO":U) > 0
                                            THEN "_DlpPre":U ELSE "_SupPre":U),
                              gcProfileData,
                              TRUE,
                              CHR(3)).
  AddSuperSuf = DYNAMIC-FUNCTION("mappedEntry" IN _h_func_lib,
                              pcProcType + (IF LOOKUP(pcProcType,"SDO,SBO":U) > 0
                                            THEN "_DlpSuf":U ELSE "_SupSuf":U),
                              gcProfileData,
                              TRUE,
                              CHR(3)).
 
  /* Strip off Prefix if necessary */
  IF rmPrefix NE "":U THEN DO:
    IF pcOldName BEGINS rmPreFix THEN 
      pcOldName = SUBSTRING(pcOldname, LENGTH(rmPreFix, "CHARACTER") + 1, -1 , "CHARACTER").
  END. /* If there is a prefix to remove */

  /* Strip off Suffix if necessary */
  IF rmSuffix NE "":U THEN DO:
    IF INDEX(pcOldName,rmSuffix) > 1 THEN 
      pcOldName = SUBSTRING(pcOldname, 1, R-INDEX(pcOldName,rmSuffix) - 1, "CHARACTER").
  END. /* If there is a suffix to remove */

  /* Add prefixes and suffixes */
  ASSIGN pcNewName = AddPrefix + pcOldName + AddSuffix
         pcSuper   = AddSuperPre + pcOldName + AddSuperSuf.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-browse V89dcnv 
PROCEDURE open-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  CASE sort-mode:
    WHEN 1 THEN
      OPEN QUERY BROWSE-1 FOR EACH Procedure
                                BY Procedure.Stts
                                BY Procedure.Name.
    WHEN 2 THEN
      OPEN QUERY BROWSE-1 FOR EACH Procedure.
    WHEN 3 THEN
      OPEN QUERY BROWSE-1 FOR EACH Procedure
                                BY Procedure.Extension.
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PopulatePM V89dcnv 
PROCEDURE PopulatePM :
/*------------------------------------------------------------------------------
  Purpose: To populate the Poduct Module combo box.    
  Parameters:  <none>
  Notes:   This is called before anything is realized and also on change of 
           value of the toggle box that determines if repository modules are
           to be shown.    
------------------------------------------------------------------------------*/
    DEFINE VARIABLE listItemPairs AS CHARACTER  NO-UNDO.

    listItemPairs = "".
    ghRepositoryDesignManager = {fnarg getManagerHandle 'RepositoryDesignManager'}.
    listItemPairs = dynamic-function('getProductModuleList':u in ghRepositoryDesignManager,
                                    'product_module_obj':u,
                                    'product_module_code,product_module_description',
                                    '&1 // &2',
                                    chr(4)).
   ASSIGN coProductModule:DELIMITER IN FRAME {&FRAME-NAME} = CHR(4)
          ListItemPairs = TRIM(ListItemPairs,CHR(4)).
   IF ListItemPairs NE "":U THEN
      coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = TRIM(ListItemPairs,CHR(4)).          
   ELSE DO:
     RUN PopulatePM.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processSDOsOfSBO V89dcnv 
PROCEDURE processSDOsOfSBO :
/*------------------------------------------------------------------------------
  Purpose:     To Migrate or register the SDOs of an SBO
  Parameters:  cSBOFileName - Source file name of the SBO
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER cSBOFilenam AS CHARACTER      NO-UNDO.
  DEFINE OUTPUT PARAMETER plOkToGo    AS LOGICAL        NO-UNDO.

  DEFINE VARIABLE cBaseFile    AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE cFileName    AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE cFullName    AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE cSuperName   AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE dDlObj       AS DECIMAL               NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer AS HANDLE            NO-UNDO.
  DEFINE VARIABLE hAttributeTable  AS HANDLE            NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER               NO-UNDO.
  DEFINE VARIABLE lMigrate     AS LOGICAL               NO-UNDO.
  DEFINE VARIABLE pError       AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE TmpFile      AS CHARACTER             NO-UNDO.
  DEFINE VARIABLE cObjectFileName AS CHARACTER          NO-UNDO.
  define variable cValues as character no-undo.
  define variable cRelPath as character no-undo.

  ASSIGN plOkToGo         = TRUE
         hAttributeBuffer = ?
         hAttributeTable  = ?.

  /* First determine if we should migrate or register the SDOs */
  lMigrate = (DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                               "SBO_MSDO":U,
                               gcProfileData,
                               TRUE,
                               CHR(3))
               EQ "Yes":U).

  /* Loop through the list of SDOs */
  DO i = 1 TO NUM-ENTRIES(cSDOList):
    TmpFile = ENTRY(i, cSDOList).
    TmpFile = REPLACE(TmpFile, "~/":U, "~\":U).

    /* Strip directories and .extension */
    cBaseFile = TmpFile.
    IF NUM-ENTRIES(TmpFile,".":U) > 1 THEN cBaseFile = ENTRY(1,TmpFile,".":U).
    cBaseFile = ENTRY(NUM-ENTRIES(cBaseFile,"~\":U), cBaseFile, "~\":U).

    IF lMigrate THEN DO:
      PUT STREAM log-file UNFORMATTED 
        "    Migrating SDO " + TmpFile + ".":U SKIP.

      /* We know the type, do name migration here */
      RUN FormNewNames(INPUT cBaseFile,    /* Original name without extension */
                       INPUT "SDO":U,      /* Procedure type                  */ 
                       OUTPUT cFilename,   /* New object filename             */
                       OUTPUT cSuperName). /* DLP or SuperProc Name           */

      cFullName = SEARCH(TmpFile).
      IF cFullName = ? THEN DO:
        PUT STREAM log-file UNFORMATTED  
             "    " + TmpFile + " cannot be found." + CHR(10) +
             "    " + TmpFile + " not migrated." SKIP.
        plOkTOGo = FALSE.
        RETURN.
      END.

      /* Check to see if cFilename already exists in the repository */
      IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
        ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                                     INPUT "RepositoryDesignManager":U) 
                                                     NO-ERROR.
      IF DYNAMIC-FUNCTION("ObjectExists":U IN ghRepositoryDesignManager,
                           INPUT cFilename ) THEN 
      DO:
        PUT STREAM log-file unformatted
            "    ":U + cFilename + " is already in the repository." SKIP.
        ENTRY(i, cSDOList) = ENTRY(i, cSDOList) + "|":U + cFilename.
      END.

      ELSE DO:  /* Not there */
        RUN CONVERT (INPUT cFullName,     /* Static File to be migrated */
                     INPUT cFilename,     /* New dynamic Name           */
                     INPUT cSuperName,    /* Super Proc or DLP name     */
                     INPUT "SDO":U,       /* Procedure type             */
                     OUTPUT pError).      /* Error message if error     */

        PUT STREAM log-file UNFORMATTED pError.
        IF pError NE ""  AND 
           NOT pError BEGINS "Associated datasource" THEN DO:
          ASSIGN plOkToGo = FALSE.
        END. /* pError has a fatal value */
        ELSE /* Migration was successful ... Store name mapping in cSDOList */
          ENTRY(i, cSDOList) = ENTRY(i, cSDOList) + "|":U + cFilename.
              /* Close the migrated window */
        IF VALID-HANDLE(_h_win) THEN
          RUN choose_close IN _h_uib. 
      END. /* Not there so migrate it */
    END.  /* If migrating */

    ELSE DO:  /* Must register it */

      IF NOT VALID-HANDLE(ghRepositoryDesignManager) THEN
        ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                                     INPUT "RepositoryDesignManager":U) 
                                                     NO-ERROR.
      run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                            + ' gsc_product_module.product_module_obj = ':u 
                                            + quoter(coProductModule)
                                            + ' NO-LOCK ', output cValues).
      cRelPath = dynamic-function('mappedEntry':u in _h_func_lib,
                                  'gsc_product_module.relative_path':u, cValues, yes, chr(3)).
      
      /* Check physical file is stored in same relative directory as module */
      ASSIGN cObjectFileName = REPLACE(TmpFile, "~\", "/")
             cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
      IF R-INDEX(cObjectFileName,".") > 0 
        AND SEARCH(cRelPath + (IF cRelPath > "" THEN "~/":U ELSE "") + cObjectFileName ) = ? THEN 
      DO:
         ASSIGN pError = cObjectFileName + " is not located in the '" 
                        + (IF cRelPath > "" AND cRelPath <> "." THEN cRelPath ELSE "default")
                        + "' directory. " + CHR(10) 
                        + "The file must be located in the same directory as the product module relative path.":U.
         PUT STREAM log-file UNFORMATTED "Not registered. " + pError + CHR(10).
 
      END.                                                                 
      ELSE DO:
         /* Register this procedure */
         RUN insertObjectMaster IN ghRepositoryDesignManager 
           ( INPUT  cObjectFileName,                         /* pcObjectName         */
             INPUT  "":U,                                    /* pcResultCode         */
             INPUT  coProductModule,                         /* pcProductModuleCode  */
             INPUT  "SDO":U,                                 /* pcObjectTypeCode     */
             INPUT  "":U,                                    /* pcObjectDescription  */
             INPUT  "":U,                                    /* pcObjectPath         */
             INPUT  "":U,                                    /* pcSdoObjectName      */
             INPUT  "":U,                                    /* pcSuperProcedureName */
             INPUT  NO,                                      /* plIsTemplate         */
             INPUT  YES,                                     /* plIsStatic           */
             INPUT  "":U,                                    /* pcPhysicalObjectName */
             INPUT  NO,                                      /* plRunPersistent      */
             INPUT  "":U,                                    /* pcTooltipText        */
             INPUT  "":U,                                    /* pcRequiredDBList     */
             INPUT  "":U,                                    /* pcLayoutCode         */
             INPUT  hAttributeBuffer,
             INPUT  TABLE-HANDLE hAttributeTable,
             OUTPUT dDlObj                                   ) NO-ERROR.
         pError = RETURN-VALUE.

          IF pError NE "":U THEN DO:
             PUT STREAM log-file  UNFORMATTED 
                        "    ":U + TmpFile + " not registered. " + CHR(10) + 
                        "    ":U + pError SKIP.
             plOkToGo = FALSE.
          END.
          ELSE DO:
            ENTRY(i, cSDOList) = ENTRY(i, cSDOList) + "|":U + cBaseFile.
            PUT STREAM log-file UNFORMATTED "    " + TmpFile + " registered as 'Static SDO'." SKIP.
          END.  /* Else sucessful */
       END. /* Valid directory */
    END. /* Else registering */
  END. /* Do i = 1 to num-entries */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process_subdirectories V89dcnv 
PROCEDURE process_subdirectories :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER Org-Dir   AS CHARACTER                        NO-UNDO.
  DEFINE INPUT PARAMETER Directory AS CHARACTER                        NO-UNDO.
  DEFINE INPUT PARAMETER CurFilter AS CHARACTER                        NO-UNDO.
  
  DEFINE VARIABLE ErrorStatus      AS LOGICAL                          NO-UNDO.
  DEFINE VARIABLE i                AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE newlist          AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE NumEntries       AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE tmpflnm          AS CHARACTER                        NO-UNDO.

  ASSIGN SET-SIZE(list-mem) = list-size
         FILE-INFO:filename = Directory
         Directory          = FILE-INFO:FULL-PATHNAME.
  
  /* Don't process the "save" directory tree */
  IF INDEX(Directory,"V8-ADM") > 0 AND INDEX(Directory,Org-DIR) > 0
    THEN RETURN.

  /* First process any subdirectories IF tog_subdir is TRUE */
  IF tog_subdir THEN DO:
    RUN file_search(
        Directory,
        "*.*",
        INPUT-OUTPUT list-mem,
        list-size,
        OUTPUT missed-file,
        OUTPUT DirError).

      IF DirError <> 0 THEN DO:
        RUN adecomm/_setcurs.p ("":U).
        ASSIGN SET-SIZE(list-mem) = 0
               ThisMessage        = "Error in directory search. ".
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
        RETURN "False":U.
      END.

      IF missed-file > 0 THEN DO:
        ThisMessage = "Too many files in your directory. " +
                      "The file list may not be inclusive.".
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
      END.

      ASSIGN NewList            = GET-STRING(list-mem,1)
             SET-SIZE(list-mem) = 0.

      DO i = 1 TO NUM-ENTRIES(NewList):
        tmpflnm = ENTRY(i,NewList).
        IF tmpflnm NE "." AND tmpflnm NE ".." THEN DO:
          ASSIGN tmpflnm             = Directory + "~\":U + tmpflnm
                 FILE-INFO:FILE-NAME = tmpflnm.
          IF FILE-INFO:FILE-TYPE = "DRW" THEN
            RUN process_subdirectories(Org-Dir, tmpflnm, CurFilter).
        END.  /* If not current directory and not upper directory */
      END. /* DO i = 1 to NUM-ENTRIES of NewList */
    END. /* If the user wants recusion */

    VIEW FRAME FRAME-A.
    RECT-6:MOVE-TO-BOTTOM().
    ASSIGN srch-lbl:SCREEN-VALUE IN FRAME FRAME-A = "Searching:"
           srch-dir:SCREEN-VALUE IN FRAME FRAME-A = Directory.

    /* Now process files in this directory - recall file_search with proper filter */
    ASSIGN SET-SIZE(list-mem) = list-size.
    RUN file_search(
        Directory,
        CurFilter,
        INPUT-OUTPUT list-mem,
        list-size,
        OUTPUT missed-file,
        OUTPUT DirError).
    
    IF DirError <> 0 THEN DO:
      RUN adecomm/_setcurs.p ("":U).
      ASSIGN SET-SIZE(list-mem) = 0
             ThisMessage        = "Error in directory search. ".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
      RETURN "False":U.
    END.

    ASSIGN newlist            = GET-STRING(list-mem,1)
           SET-SIZE(list-mem) = 0.

    DO i = 1 TO NUM-ENTRIES(NewList):
      /* Don't allow directories 
       * Note that FILE-INFO can return ? for FILE-TYPE or FULL-PATHNAME
       * when there is no permission to access the file etc.
       * The ideal would have been to have file-type = F, but it screened
       * out valid files.                                                    */
      ASSIGN tmpflnm             = Directory + "~\":U + ENTRY(i,NewList)
             FILE-INFO:FILE-NAME = tmpflnm.
      IF FILE-INFO:FILE-TYPE = "FRW":U THEN DO:
        /* Don't allow .r's even if user asks for them */
        IF (NOT tmpflnm MATCHES "*~~.r":U) THEN DO:
          CREATE Procedure.
          ASSIGN Procedure.name      = SUBSTRING(tmpflnm,LENGTH(Org-Dir,"CHARACTER") + 2)
                 NumEntries          = NUM-ENTRIES(tmpflnm,".":U)
                 Procedure.extension = IF NumEntries < 2 THEN ""
                                       ELSE ENTRY(NumEntries, tmpflnm, ".":U).
        END.  /* IF not a .r */
      END.  /* IF a file */
    END. /* DO i = 1 to NUM-ENTRIES of list-char */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdatePMinProfile V89dcnv 
PROCEDURE UpdatePMinProfile :
/*------------------------------------------------------------------------------
  Purpose:     To update Profile data with current value of default Product Module
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable cValues as character no-undo.
    
    run getRecordDetail in gshGenManager ('for each gsc_product_module WHERE ':u
                                         + ' gsc_product_module.product_module_obj = ':u 
                                         + quoter(coProductModule:screen-value in frame {&frame-name}) 
                                         + ' NO-LOCK ', output cValues).
  if cValues ne ? and cValues ne '':u then
      cPMValue = dynamic-function('mappedEntry' in _h_func_lib,
                                  'gsc_product_module.product_module_code':u, cValues, true, Chr(3)).

   /* Set the basic PM in the Migration Settings profile */
   rRowid = ?.
   IF VALID-HANDLE(gshProfileManager) THEN
     RUN getProfileData IN gshProfileManager (INPUT "General":U,         /* Profile type code     */
                                              INPUT "Preference":U,      /* Profile code          */
                                              INPUT "GenerateObjects":U, /* Profile data key      */
                                              INPUT "NO":U,              /* Get next record flag  */
                                              INPUT-OUTPUT rRowid,       /* Rowid of profile data */
                                              OUTPUT gcProfileData).     /* Found profile data.   */

     gcProfileData = DYNAMIC-FUNCTION("assignMappedEntry":U IN _h_func_lib,
                     "PM_Base":U + CHR(3) + 
                     "SDO_PM":U  + CHR(3) +
                     "SDV_PM":U  + CHR(3) +
                     "SDB_PM":U  + CHR(3) +
                     "SBO_PM":U,             /* 5 Names          */
                     gcProfileData,          /* String to Change */
                     cPMValue    + CHR(3) +
                     cPMValue    + CHR(3) +
                     cPMValue    + CHR(3) +
                     cPMValue    + CHR(3) +
                     cPMValue,               /* 5 Vlaues         */
                     CHR(3),                 /* Delimiter        */
                     TRUE).                  /* Name then Value  */

   /* Store cProfile in repository */
   RUN setProfileData IN gshProfileManager (INPUT "General":U,       /* Profile type code */
                                            INPUT "Preference":U,    /* Profile code */
                                            INPUT "GenerateObjects", /* Profile data key */
                                            INPUT ?,                 /* Rowid of profile data */
                                            INPUT gcProfileData,     /* Profile data value */
                                            INPUT NO,                /* Delete flag */
                                            INPUT "PER":u).          /* Save flag (permanent) */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

