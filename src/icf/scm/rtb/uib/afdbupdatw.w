&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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
/*------------------------------------------------------------------------

  File: afdbupdatw.w

  Description: Dynamics deployment load hook

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: December 2000

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

DEFINE STREAM sMain.

DEFINE VARIABLE gcRootDirectory     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcDeployDirectory    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcExportDirectory    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcDeltaDirectory     AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS toRunBefore toLoadDeltas toImportData ~
toImportRepository toImportRepoVersion toRunAfter fiFindValue buFindPath ~
fiFindBefore buFindBefore fiFindAfter buFindAfter edResults buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS toRunBefore tDoneRunBefore toLoadDeltas ~
tDoneLoadDeltas toImportData tDoneImportData toImportRepository ~
tDoneRepository toImportRepoVersion tDoneRepoVersion toRunAfter ~
tDoneRunAfter fiFindValue fiFindBefore fiFindAfter edResults 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Exit" 
     SIZE 14.4 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buFindAfter 
     LABEL "Find File..." 
     SIZE 14.4 BY 1.14.

DEFINE BUTTON buFindBefore 
     LABEL "Find File..." 
     SIZE 14.4 BY 1.14.

DEFINE BUTTON buFindPath 
     LABEL "Find Path..." 
     SIZE 14.4 BY 1.14 TOOLTIP "Find root directory".

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&Import the Exported / Deployed Data and Data Definitions" 
     SIZE 85 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 100 BY 4.38 NO-UNDO.

DEFINE VARIABLE fiFindAfter AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 85 BY 1 TOOLTIP "Program to run after doing all other Dynamics specific processing" NO-UNDO.

DEFINE VARIABLE fiFindBefore AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 85 BY 1 TOOLTIP "Program to run before doing any other Dynamics specific processing" NO-UNDO.

DEFINE VARIABLE fiFindValue AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 85 BY 1 TOOLTIP "Deployment root directory - full path" NO-UNDO.

DEFINE VARIABLE tDoneImportData AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneLoadDeltas AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneRepository AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneRepoVersion AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneRunAfter AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneRunBefore AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE toImportData AS LOGICAL INITIAL no 
     LABEL "Import Additional Static/Transaction Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE toImportRepository AS LOGICAL INITIAL no 
     LABEL "Import Repository Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE toImportRepoVersion AS LOGICAL INITIAL no 
     LABEL "Import Repository Version Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE toLoadDeltas AS LOGICAL INITIAL no 
     LABEL "Load Database Definition Files" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE toRunAfter AS LOGICAL INITIAL no 
     LABEL "Run Program AFTER Processing" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE toRunBefore AS LOGICAL INITIAL no 
     LABEL "Run Program BEFORE Processing" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     toRunBefore AT ROW 1.48 COL 5
     tDoneRunBefore AT ROW 1.48 COL 57
     toLoadDeltas AT ROW 2.43 COL 5
     tDoneLoadDeltas AT ROW 2.43 COL 57
     toImportData AT ROW 3.38 COL 5
     tDoneImportData AT ROW 3.38 COL 57
     toImportRepository AT ROW 4.33 COL 5
     tDoneRepository AT ROW 4.33 COL 57
     toImportRepoVersion AT ROW 5.29 COL 5
     tDoneRepoVersion AT ROW 5.29 COL 57
     toRunAfter AT ROW 6.24 COL 5
     tDoneRunAfter AT ROW 6.24 COL 57
     fiFindValue AT ROW 8.14 COL 5 NO-LABEL
     buFindPath AT ROW 8.14 COL 91
     fiFindBefore AT ROW 10.52 COL 3 COLON-ALIGNED NO-LABEL
     buFindBefore AT ROW 10.52 COL 91
     fiFindAfter AT ROW 12.81 COL 3 COLON-ALIGNED NO-LABEL
     buFindAfter AT ROW 12.81 COL 91
     edResults AT ROW 14.33 COL 5 NO-LABEL
     buOK AT ROW 19.1 COL 5
     buCancel AT ROW 19.1 COL 91
     "Select Root Directory Containing the Deployment Package" VIEW-AS TEXT
          SIZE 85 BY .81 AT ROW 7.19 COL 5
     "Program to run before package load:" VIEW-AS TEXT
          SIZE 85 BY .81 AT ROW 9.57 COL 5
     "Program to run after package load" VIEW-AS TEXT
          SIZE 85 BY .81 AT ROW 11.95 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.6 BY 19.86
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
         TITLE              = "Dynamics Deployment Load"
         HEIGHT             = 19.86
         WIDTH              = 107.6
         MAX-HEIGHT         = 32.43
         MAX-WIDTH          = 163.8
         VIRTUAL-HEIGHT     = 32.43
         VIRTUAL-WIDTH      = 163.8
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
ASSIGN 
       edResults:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       edResults:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fiFindValue IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX tDoneImportData IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneLoadDeltas IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneRepository IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneRepoVersion IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneRunAfter IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneRunBefore IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Dynamics Deployment Load */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Dynamics Deployment Load */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

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


&Scoped-define SELF-NAME buFindAfter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFindAfter C-Win
ON CHOOSE OF buFindAfter IN FRAME DEFAULT-FRAME /* Find File... */
DO:

    RUN selectRunAfter.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFindBefore
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFindBefore C-Win
ON CHOOSE OF buFindBefore IN FRAME DEFAULT-FRAME /* Find File... */
DO:

    RUN selectRunBefore.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFindPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFindPath C-Win
ON CHOOSE OF buFindPath IN FRAME DEFAULT-FRAME /* Find Path... */
DO:

    RUN selectOutput.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Import the Exported / Deployed Data and Data Definitions */
DO:

  DEFINE VARIABLE lValidDir             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFileName             AS CHARACTER  NO-UNDO.

  ASSIGN
      fiFindValue
      toRunBefore
      toLoadDeltas
      toImportData
      toImportRepository
      toImportRepoVersion
      toRunAfter
      fiFindValue      = REPLACE(fiFindValue,"~\":U,"~/":U)
      gcRootDirectory   = TRIM(fiFindValue,"~/":U)
      gcDeployDirectory = gcRootDirectory + "~/":U + "icf_dbdata":U
      gcExportDirectory = gcRootDirectory + "~/":U + "icf_export":U
      gcDeltaDirectory  = gcRootDirectory + "~/":U + "icf_deltas":U
      lValidDir = NO
      .

  ASSIGN FILE-INFO:FILE-NAME = gcRootDirectory.
  IF gcRootDirectory = "":U OR NOT FILE-INFO:FILE-TYPE MATCHES "*d*":U THEN
  DO:
    MESSAGE
        SKIP " No Valid Root Directory containing the Exported / Deployed Data "
        SKIP " and Delta files was entered. "
        SKIP " Please enter a valid directory before proceeding... "
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.

  ASSIGN FILE-INFO:FILE-NAME = gcDeployDirectory.
  IF FILE-INFO:FILE-TYPE MATCHES "*d*":U THEN ASSIGN lValidDir = YES.
  ASSIGN FILE-INFO:FILE-NAME = gcExportDirectory.
  IF FILE-INFO:FILE-TYPE MATCHES "*d*":U THEN ASSIGN lValidDir = YES.
  ASSIGN FILE-INFO:FILE-NAME = gcDeltaDirectory.
  IF FILE-INFO:FILE-TYPE MATCHES "*d*":U THEN ASSIGN lValidDir = YES.

  IF NOT lValidDir THEN
  DO:
    MESSAGE
        SKIP " The root directory specified for the deployment package does not"
        SKIP " contain the standard Dynamics subdirectories containing the dumped" 
        SKIP " Dynamics details. The root directory should contain at least one"
        SKIP " of the following; /icf_dbdata /icf_export /icf_deltas"
        SKIP
        SKIP " Please enter a valid root directory before proceeding... "
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.

  IF toRunBefore AND SEARCH(fiFindBefore) = ? THEN
  DO:
    MESSAGE "The program to run before loading the Dynamics deployment package" SKIP
            "can not be found. Please specify a valid file, or leave the " SKIP
            "prompt empty if no before processing is required" SKIP(1)
            VIEW-AS ALERT-BOX INFORMATION.  
    RETURN NO-APPLY.
  END.

  IF toRunAfter AND SEARCH(fiFindAfter) = ? THEN
  DO:
    MESSAGE "The program to run after loading the Dynamics deployment package" SKIP
            "can not be found. Please specify a valid file, or leave the " SKIP
            "prompt empty if no after processing is required" SKIP(1)
            VIEW-AS ALERT-BOX INFORMATION.  
    RETURN NO-APPLY.
  END.

  ASSIGN cFileName = gcDeltaDirectory + "/icfdeltas.txt":U .
  IF toLoadDeltas AND SEARCH(cFileName) = ? THEN
  DO:
    MESSAGE "You specified to load deltas, but the delta control file: " SKIP
            cFileName SKIP
            "could not be found. It may be that this release does not contain" SKIP
            "any schema changes, in which case simply specify not to load database" SKIP
            "definitions and try again." SKIP(1)
            "If the release notes specify there were schema changes, then you must" SKIP
            "obtain a valid copy of the schema control file before proceeding with" SKIP
            "the loading of this package." SKIP(1)
            VIEW-AS ALERT-BOX INFORMATION.  
    RETURN NO-APPLY.
  END.

  MESSAGE "Do you wish to proceed with the Dynamics deployment load options selected." SKIP(1)
          "Please ensure that you have fully copied the deployment package into " SKIP
          "the correct application workspace directory over the top of the existing" SKIP
          "application." SKIP(1)
          "Please also ensure you have the correct databases connected that require" SKIP
          "updating. If you do not, then exit the program, connect the databases" SKIP
          "and then start again. Ideally you should have a specific PF file set-up" SKIP
          "for doing this load process." SKIP(1)
          "If this is a partner site and version data is also being loaded, please" SKIP
          "ensure you have first fully completed the standard Roundtable partner site" SKIP
          "load. This ensures the Roundtable repository data is up-to-date and the" SKIP
          "Dynamics load options will then synchronise with the new Roundtable" SKIP
          "repository data." SKIP(1)
          "Continue with package load?" SKIP(1)
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE lChoice AS LOGICAL.
  IF lchoice THEN
    RUN importProcess.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFindAfter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFindAfter C-Win
ON LEAVE OF fiFindAfter IN FRAME DEFAULT-FRAME
DO:
  IF SELF:SCREEN-VALUE <> "":U THEN
    ASSIGN toRunAfter:SCREEN-VALUE = "yes":U.
  ELSE
    ASSIGN toRunAfter:SCREEN-VALUE = "no":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFindBefore
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFindBefore C-Win
ON LEAVE OF fiFindBefore IN FRAME DEFAULT-FRAME
DO:
  IF SELF:SCREEN-VALUE <> "":U THEN
    ASSIGN toRunBefore:SCREEN-VALUE = "yes":U.
  ELSE
    ASSIGN toRunBefore:SCREEN-VALUE = "no":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkPPs C-Win 
PROCEDURE checkPPs :
/*------------------------------------------------------------------------------
  Purpose:     Check if db's in use before loading deltas
  Parameters:  output dbs in use
  Notes:       Stolen from _chkpp.i from dlc91b directory and hacked !!!
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pcInUse           AS CHARACTER NO-UNDO.

  /* Finds all persistent procedures and generates a list of databases which they
   * use. The user gets a warning message stating that if they modify the schema
   * of any of these database, PROGRESS will restart and all unsaved work will
   * be lost.
   */
  DEFINE VARIABLE h          AS HANDLE    NO-UNDO. /* procedure handle */
  DEFINE VARIABLE dbentry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE run_dblist AS CHARACTER NO-UNDO. /* list of databases */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.

  ASSIGN h  = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    IF NOT (h:FILE-NAME BEGINS "adetran") THEN 
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i,h:DB-REFERENCES).
      IF dbentry NE "PROGRESST":U AND
         LOOKUP(dbentry, run_dblist) = 0 THEN
        ASSIGN run_dblist = run_dblist + (IF run_dblist NE "" THEN "," + dbentry ELSE dbentry).
    END.
    h = h:NEXT-SIBLING.
  END.

  ASSIGN pcInUse = run_dblist.

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
  DISPLAY toRunBefore tDoneRunBefore toLoadDeltas tDoneLoadDeltas toImportData 
          tDoneImportData toImportRepository tDoneRepository toImportRepoVersion 
          tDoneRepoVersion toRunAfter tDoneRunAfter fiFindValue fiFindBefore 
          fiFindAfter edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE toRunBefore toLoadDeltas toImportData toImportRepository 
         toImportRepoVersion toRunAfter fiFindValue buFindPath fiFindBefore 
         buFindBefore fiFindAfter buFindAfter edResults buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importDeltas C-Win 
PROCEDURE importDeltas :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to load deltas sent in package
  Parameters:  output error if any
  Notes:       Assumes Dynamics standard naming conventions for delta names
               e.g. 1st 4 characters  = DB name
                    next 6 = database version
                    then ending in full.df or delta.df
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pcErrorValue    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDeltaFile              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBDeltas               AS CHARACTER EXTENT 20 NO-UNDO.
  DEFINE VARIABLE cRawFile                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastDB                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPosn                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFileList               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullList               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisconnected           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorFile              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorText              AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN cDeltaFile = gcDeltaDirectory + "/icfdeltas.txt":U .
    IF SEARCH(cDeltaFile) = ? THEN
    DO:
      ASSIGN pcErrorValue = "Could not find schema control file: " + cDeltaFile.
      RETURN.
    END.

    ASSIGN
      cLastDB = "":U
      cFileList = "":U
      cDBList = "":U
      iEntry = 0
      .
    INPUT STREAM sMain FROM VALUE(cDeltaFile) NO-ECHO.
    import-loop:
    REPEAT:
      IMPORT STREAM sMain UNFORMATTED cFileName.
      IF INDEX(cFileName,".df":U) = 0 THEN NEXT import-loop.

      ASSIGN iPosn = R-INDEX(cFileName,"/":U) + 1.
      IF iPosn = 1 THEN
          ASSIGN iPosn = R-INDEX(cFileName,"~\":U) + 1.
      ASSIGN
        cRawFile = TRIM(LC(SUBSTRING(cFileName,iPosn))).

      IF SUBSTRING(cRawFile,1,4) = cLastDB OR cLastDB = "":U THEN
      DO:
        IF cLastDB = "":U THEN ASSIGN cLastDB = SUBSTRING(cRawFile,1,4). /* First time issue */
        ASSIGN
          cFileList = cFileList + (IF cFileList <> "":U THEN ",":U ELSE "":U) + cFileName.      
      END.
      ELSE
      DO: 
        ASSIGN
          iEntry = iEntry + 1
          cDBList = cDBList + (IF iEntry = 1 THEN "":U ELSE ",":U) + cLastDB
          cDBDeltas[iEntry] = cFileList
          cLastDB = SUBSTRING(cRawFile,1,4)
          cFileList = cFileName
          .    
      END.
    END.
    INPUT STREAM sMain CLOSE.

    /* Finish off last one */
    IF cFileList <> "":U THEN
    DO:
      ASSIGN
        iEntry = iEntry + 1
        cDBList = cDBList + (IF iEntry = 1 THEN "":U ELSE ",":U) + cLastDB
        cDBDeltas[iEntry] = cFileList
        cLastDB = "":U
        cFileList = "":U
        .    
    END.

    ASSIGN cDisconnected = "":U.
    DO iLoop = 1 TO NUM-ENTRIES(cDBList):
      IF NOT CONNECTED(ENTRY(iLoop,cDBList)) THEN
        ASSIGN cDisconnected = cDisconnected + (IF cDisconnected <> "":U THEN ",":U ELSE "":U) + ENTRY(iLoop,cDBList).
      IF INDEX (cDBDeltas[iLoop],"full.df":U) <> 0 THEN
        ASSIGN cFullList = cFullList + (IF cFullList <> "":U THEN ",":U ELSE "":U) + ENTRY(iLoop,cDBList).
    END.
    IF cDisconnected <> "":U THEN
    DO:
      pcErrorValue = "Databases not connected = " + cDisconnected.
      RETURN.
    END.

    IF cFullList <> "":U THEN
    DO:
      MESSAGE "The following databases have schema changes, but the schema control" SKIP
              "file contains a full Definition File (DF) for them:" SKIP(1)
              cFullList SKIP(1)
              "You may only proceed with the load of these definition files if your" SKIP
              "databases are completely empty and this is a first time install." SKIP(1)
              "If this is not a first time install and your databases contain data" SKIP
              "then you will need to manually dump your data, apply the schema changes" SKIP
              "and reload your data, before proceeding with the rest of this deployment" SKIP
              "package. Once done, just re-run this load utility and do not select the" SKIP
              "schema load option." SKIP(1)
              "You may look at the schema control file: " + cDeltaFile SKIP
              "to review what DF's must be loaded and in what sequence. When loading" SKIP
              "manually, it is VERY important to ensure you load the DF's in exactly" SKIP
              "the correct sequence, for all the databases in the control file." SKIP(1)
              "Do you want to continue with the automatic full schema load?" SKIP(1)
              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
              UPDATE lContinue AS LOGICAL.
      IF NOT lContinue THEN
      DO:
        ASSIGN  pcErrorValue = "Full Definitions exist for databases: " + cFullList.      
        RETURN.
      END.
    END.

    IF cDBList = "":U THEN RETURN.  /* no deltas to process */

    /* Databases connected - process deltas for them in order */
    db-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cDBList):

      CREATE ALIAS DICTDB FOR DATABASE VALUE(ENTRY(iLoop,cDBList)).

      DO iEntry = 1 TO NUM-ENTRIES(cDBDeltas[iLoop]):
        ASSIGN
          cFileName = SEARCH(ENTRY(iEntry,cDBDeltas[iLoop])).

        IF cFileName = ? THEN
        DO:
          ASSIGN pcErrorValue = "Delta File: " + ENTRY(iEntry,cDBDeltas[iLoop]) + " not found.".
          LEAVE db-loop.        
        END.

        IF edResults:INSERT-STRING("*** Loading Delta: " + TRIM(cFileName) + " (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .        

        /* delete error file if there from last time */
        ASSIGN
          cErrorFile = SEARCH(ENTRY(iLoop,cDBList) + ".e":U).
        IF cErrorFile <> ? THEN
          OS-DELETE VALUE(cErrorFile) NO-ERROR.

        df-block:
        DO ON STOP UNDO df-block, LEAVE df-block ON ERROR UNDO df-block, LEAVE df-block:
          RUN prodict/load_df.p (INPUT TRIM(cFileName)). 
        END.
/*         IF ERROR-STATUS:ERROR THEN                                                 */
/*         DO:                                                                        */
/*           ASSIGN pcErrorValue = "Delta Load Error on file: " + cFileName NO-ERROR. */
/*           RETURN.                                                                  */
/*         END.                                                                       */

        /* see if worked by looking for file with dbname.e */
        ASSIGN
          cErrorFile = SEARCH(ENTRY(iLoop,cDBList) + ".e":U).
        IF cErrorFile <> ? THEN
        DO:
          INPUT STREAM sMain FROM VALUE(cErrorFile) NO-ECHO.
          REPEAT:
            IMPORT STREAM sMain UNFORMATTED cErrorText.
            IF cErrorText = "":U THEN NEXT.
            IF edResults:INSERT-STRING("*** ERROR: " + cErrorText + CHR(10) ) THEN .        
          END.
          INPUT STREAM sMain CLOSE.
          ASSIGN pcErrorValue = "Delta Load Error on file: " + cFileName.
          LEAVE db-loop.
        END.
      END.
    END.

  END. /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importExport C-Win 
PROCEDURE importExport :
/*------------------------------------------------------------------------------
  Purpose:     Import static data exported with package using generated program
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pcErrorValue    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProcedure              AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN cProcedure = SEARCH(gcExportDirectory + "/icfstaticload.r":U).
    IF cProcedure = ? THEN
      ASSIGN cProcedure = SEARCH(gcExportDirectory + "/icfstaticload.p":U).
    IF cProcedure = ? THEN
    DO:
      ASSIGN pcErrorValue = "Could not find static data import program: " + gcExportDirectory + "/icfstaticload.r":U.
      RETURN.
    END.

    RUN-BLOCK:
    DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
      RUN VALUE(cProcedure).
    END.

  END. /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importProcess C-Win 
PROCEDURE importProcess :
/*------------------------------------------------------------------------------
  Purpose:     Load Dynamics Deployment Package
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cErrorValue             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNumericDecimalPoint    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNumericSeparator       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNumericFormat          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDateFormat             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSavePropath            AS CHARACTER    NO-UNDO.

  ASSIGN cSavePropath = PROPATH.

  /* (1) Add deployment package root directory to PROPATH */
  PROPATH = gcRootDirectory + ",":U + PROPATH.

  /* save session settings and reset to MIP dumped settings */
  ASSIGN
    cNumericDecimalPoint = SESSION:NUMERIC-DECIMAL-POINT
    cNumericSeparator = SESSION:NUMERIC-SEPARATOR
    cNumericFormat = SESSION:NUMERIC-FORMAT
    cDateFormat = SESSION:DATE-FORMAT
    .

  SESSION:NUMERIC-FORMAT = "AMERICAN".
  SESSION:SET-NUMERIC-FORMAT(",":U,".":U). /* seperator, decimal */ 
  SESSION:DATE-FORMAT = "dmy":U.

  DO WITH FRAME {&FRAME-NAME}:

    /* Start message */
    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.
    IF edResults:INSERT-STRING("*** Start loading of Dynamics Deployment Package ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

    /* Run the files specified for before processing */
    IF  (toRunBefore = YES AND tDoneRunBefore = NO)
    AND fiFindBefore <> "":U
    AND SEARCH(fiFindBefore) <> ?
    THEN DO:
        ASSIGN
            tDoneRunBefore:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
        IF edResults:INSERT-STRING("***   Running the before processing program ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

        ASSIGN cErrorValue = "Run Error":U.
        RUN-BLOCK1:
        DO ON STOP UNDO RUN-BLOCK1, LEAVE RUN-BLOCK1 ON ERROR UNDO RUN-BLOCK1, LEAVE RUN-BLOCK1:
          RUN VALUE(fiFindBefore) (INPUT gcRootDirectory, OUTPUT cErrorValue).
        END.
        IF ERROR-STATUS:ERROR OR cErrorValue <> "":U THEN
        DO:
          ASSIGN
              tDoneRunBefore = NO
              tDoneRunBefore:LABEL        IN FRAME {&FRAME-NAME} = "Error":U
              tDoneRunBefore:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRunBefore)
              .
          IF edResults:INSERT-STRING("~n" + "*** ERROR in before processing program  : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ELSE
        DO:
          ASSIGN
              tDoneRunBefore = YES
              tDoneRunBefore:LABEL        IN FRAME {&FRAME-NAME} = "Completed":U
              tDoneRunBefore:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRunBefore)
              .
          IF edResults:INSERT-STRING("***   Before processing program completed (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
    END.
    IF  (toRunBefore = YES AND tDoneRunBefore = NO) THEN
    DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Dynamics Package Load Aborted - error in before processing"
        VIEW-AS ALERT-BOX INFORMATION.

      ASSIGN PROPATH = cSavePropath.
      SESSION:NUMERIC-FORMAT = cNumericFormat.
      SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
      SESSION:DATE-FORMAT = cDateFormat.

      RETURN.
    END.

    /* Import and load Deltas */
    IF (toLoadDeltas = YES AND tDoneLoadDeltas = NO)
    THEN DO:
        ASSIGN
            tDoneLoadDeltas:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
        IF edResults:INSERT-STRING("***   Processing the deltas ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        RUN importDeltas (OUTPUT cErrorValue).
        IF cErrorValue <> "":U
        THEN
        DO:
            ASSIGN
                tDoneLoadDeltas:LABEL IN FRAME {&FRAME-NAME} = "Error...":U.
            IF edResults:INSERT-STRING("~n" + "*** ERROR with loading process of Dynamics delta : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ELSE
        DO:
            ASSIGN
                tDoneLoadDeltas = YES
                tDoneLoadDeltas:LABEL IN FRAME {&FRAME-NAME} = "Completed":U.
            IF edResults:INSERT-STRING("***   Processing of deltas completed (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ASSIGN
            tDoneLoadDeltas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneLoadDeltas)
            .
    END.
    IF (toLoadDeltas = YES AND tDoneLoadDeltas = NO) THEN
    DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Dynamics Package Load Aborted - error in loading deltas"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN PROPATH = cSavePropath.
      SESSION:NUMERIC-FORMAT = cNumericFormat.
      SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
      SESSION:DATE-FORMAT = cDateFormat.
      RETURN. /* stop here */
    END.

    /* Import Exported data */
    IF (toImportData = YES AND tDoneImportData = NO)
    THEN DO:
        ASSIGN
            tDoneImportData:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
        IF edResults:INSERT-STRING("***   Processing the exported data files ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        RUN importExport (OUTPUT cErrorValue).
        IF cErrorValue <> "":U
        THEN
        DO:
            ASSIGN
                tDoneImportData:LABEL IN FRAME {&FRAME-NAME} = "Error...":U.
            IF edResults:INSERT-STRING("~n" + "*** ERROR with processing exported data files : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ELSE
        DO:
            ASSIGN
                tDoneImportData = YES
                tDoneImportData:LABEL IN FRAME {&FRAME-NAME} = "Completed":U.
            IF edResults:INSERT-STRING("***   Processing of exported data files completed (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ASSIGN
            tDoneImportData:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneImportData)
            .
    END.
    IF (toImportData = YES AND tDoneImportData = NO) THEN
    DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Dynamics Package Load Aborted - error in loading exported data"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN PROPATH = cSavePropath.
      SESSION:NUMERIC-FORMAT = cNumericFormat.
      SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
      SESSION:DATE-FORMAT = cDateFormat.
      RETURN. /* stop here */
    END.

    /* Import Repository data */
    IF (toImportRepository  AND tDoneRepository  = NO)
    THEN DO:
          ASSIGN
            tDoneRepository:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
        IF edResults:INSERT-STRING("***   Processing the repository deployed data files ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        RUN importRepository (OUTPUT cErrorValue).
        IF cErrorValue <> "":U
        THEN
        DO:
            ASSIGN
                tDoneRepository:LABEL IN FRAME {&FRAME-NAME} = "Error...":U.
            IF edResults:INSERT-STRING("~n" + "*** ERROR with loading of repository data : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ELSE
        DO:
            ASSIGN
                tDoneRepository = YES
                tDoneRepository:LABEL IN FRAME {&FRAME-NAME} = "Completed":U.
            IF edResults:INSERT-STRING("***   Processing of repository data completed (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ASSIGN
            tDoneRepository:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRepository)
            .
    END.
    IF (toImportRepository = YES AND tDoneRepository = NO) THEN
    DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Dynamics Package Load Aborted - error in loading repository data"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN PROPATH = cSavePropath.
      SESSION:NUMERIC-FORMAT = cNumericFormat.
      SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
      SESSION:DATE-FORMAT = cDateFormat.
      RETURN. /* stop here */
    END.

    /* Import Version data */
    IF (toImportRepoVersion  AND tDoneRepoVersion  = NO)
    THEN DO:
          ASSIGN
            tDoneRepoVersion:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
        IF edResults:INSERT-STRING("***   Processing the versioning deployed data files ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        RUN importVersion (OUTPUT cErrorValue).
        IF cErrorValue <> "":U
        THEN DO:
            ASSIGN
                tDoneRepoVersion:LABEL IN FRAME {&FRAME-NAME} = "Error...":U.
            IF edResults:INSERT-STRING("~n" + "*** ERROR with loading of versioning data : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ELSE
        DO:
            ASSIGN
                tDoneRepoVersion = YES
                tDoneRepoVersion:LABEL IN FRAME {&FRAME-NAME} = "Completed":U.
            IF edResults:INSERT-STRING("***   Processing of versioning data completed (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ASSIGN
            tDoneRepoVersion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRepoVersion)
            .
    END.
    IF (toImportRepoVersion = YES AND tDoneRepoVersion = NO) THEN
    DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Dynamics Package Load Aborted - error in loading versioning data"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN PROPATH = cSavePropath.
      SESSION:NUMERIC-FORMAT = cNumericFormat.
      SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
      SESSION:DATE-FORMAT = cDateFormat.
      RETURN. /* stop here */
    END.

    /* Finally run the files specified for after processing */
    IF  (toRunAfter = YES AND tDoneRunAfter = NO)
    AND fiFindAfter <> "":U
    AND SEARCH(fiFindAfter) <> ?
    THEN DO:
        ASSIGN
            tDoneRunAfter:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
        IF edResults:INSERT-STRING("***   Running the after processing files ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

        ASSIGN cErrorValue = "Error":U.
        RUN-BLOCK2:
        DO ON STOP UNDO RUN-BLOCK2, LEAVE RUN-BLOCK2 ON ERROR UNDO RUN-BLOCK2, LEAVE RUN-BLOCK2:
          RUN VALUE(fiFindAfter) (INPUT gcRootDirectory, OUTPUT cErrorValue).
        END.
        IF ERROR-STATUS:ERROR OR cErrorValue <> "":U THEN
        DO:
          ASSIGN
              tDoneRunAfter = NO
              tDoneRunAfter:LABEL        IN FRAME {&FRAME-NAME} = "Error":U
              tDoneRunAfter:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRunAfter)
              .
          IF edResults:INSERT-STRING("~n" + "*** ERROR in after processing program  : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
        ELSE
        DO:
          ASSIGN
              tDoneRunAfter = YES
              tDoneRunAfter:LABEL        IN FRAME {&FRAME-NAME} = "Completed":U
              tDoneRunAfter:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRunAfter)
              .
          IF edResults:INSERT-STRING("***   After processing program completed (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        END.
    END.
    IF  (toRunAfter = YES AND tDoneRunAfter = NO) THEN
    DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Dynamics Package Load Aborted - error in after processing"
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN PROPATH = cSavePropath.
      SESSION:NUMERIC-FORMAT = cNumericFormat.
      SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
      SESSION:DATE-FORMAT = cDateFormat.
      RETURN.
    END.

    /* Finish message */
    IF edResults:INSERT-STRING("~n" + "*** Finished load of Dynamics Deployment Package ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
    IF  SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

    ASSIGN
        edResults:MODIFIED = FALSE.

  END.  /* do with frame */

  ASSIGN PROPATH = cSavePropath.
  SESSION:NUMERIC-FORMAT = cNumericFormat.
  SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
  SESSION:DATE-FORMAT = cDateFormat.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importRepository C-Win 
PROCEDURE importRepository :
/*------------------------------------------------------------------------------
  Purpose:     Import repository data exported with package
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pcErrorValue    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProcedure              AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN cProcedure = SEARCH("ry/app/rydimportp.r":U).
    IF cProcedure = ? THEN
      ASSIGN cProcedure = SEARCH("ry/app/rydimportp.p":U).
    IF cProcedure = ? THEN
    DO:
      ASSIGN pcErrorValue = "Could not find repository import program: ry/app/rydimportp.r".
      RETURN.
    END.

    RUN-BLOCK:
    DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
      RUN VALUE(cProcedure).
    END.

  END. /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importVersion C-Win 
PROCEDURE importVersion :
/*------------------------------------------------------------------------------
  Purpose:     Import version data exported with package
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pcErrorValue    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cProcedure              AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN cProcedure = SEARCH("rv/app/rvdimportp.r":U).
    IF cProcedure = ? THEN
      ASSIGN cProcedure = SEARCH("rv/app/rvdimportp.p":U).
    IF cProcedure = ? THEN
    DO:
      ASSIGN pcErrorValue = "Could not find version data import program: rv/app/rvdimportp.r".
      RETURN.
    END.

    RUN-BLOCK:
    DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
      RUN VALUE(cProcedure).
    END.

  END. /* do with frame */

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
            {&WINDOW-NAME}:TITLE = "Dynamics Deployment Load":U
            .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectOutput C-Win 
PROCEDURE selectOutput :
/*------------------------------------------------------------------------------
  Purpose:     Finds a Folder name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE fiFindValueOld   AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE lhServer        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE lhFolder        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE lhParent        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE lvFolder        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lvCount         AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            fiFindValueOld = fiFindValue.

        CREATE 'Shell.Application' lhServer.

        ASSIGN
            lhFolder = lhServer:BrowseForFolder(CURRENT-WINDOW:HWND,"Select Deploy Directory":U,0).

        IF VALID-HANDLE(lhFolder) = TRUE 
        THEN DO:
            ASSIGN 
                lvFolder = lhFolder:Title
                lhParent = lhFolder:ParentFolder
                lvCount  = 0
                .
            REPEAT:
                IF lvCount >= lhParent:Items:Count
                THEN DO:
                    ASSIGN
                        fiFindValue = "":U.
                END.
                ELSE
                IF lhParent:Items:Item(lvCount):Name = lvFolder
                THEN DO:
                    ASSIGN
                        fiFindValue = lhParent:Items:Item(lvCount):Path.
                    LEAVE.
                END.
                ASSIGN
                    lvCount = lvCount + 1.
            END.

        END.
        ELSE DO:
            ASSIGN
                fiFindValue = fiFindValueOld.
        END.

        RELEASE OBJECT lhParent NO-ERROR.
        RELEASE OBJECT lhFolder NO-ERROR.
        RELEASE OBJECT lhServer NO-ERROR.

        ASSIGN
            fiFindValue:SCREEN-VALUE = fiFindValue
            lhParent = ?
            lhFolder = ?
            lhServer = ?
            .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectRunAfter C-Win 
PROCEDURE selectRunAfter :
/*------------------------------------------------------------------------------
  Purpose:     Finds a Folder name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE fiFindAfterOld  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSelect         AS LOGICAL  NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            fiFindAfterOld = fiFindAfter.

        SYSTEM-DIALOG GET-FILE fiFindAfter
            FILTERS "Object Files (*.r)" "*.r",
                    "Source Procedure Files (*.p)" "*.p",
                    "Source Window Files (*.w)" "*.w",
                    "All Files (*.*)" "*.*"
            CREATE-TEST-FILE
            MUST-EXIST
            TITLE "Select the file to run after package load":U
            USE-FILENAME
            UPDATE lSelect
            .

        IF NOT lSelect 
        THEN
            ASSIGN
                fiFindAfter = fiFindAfterOld.

        ASSIGN
            fiFindAfter:SCREEN-VALUE    = fiFindAfter.

        APPLY "VALUE-CHANGED" TO fiFindAfter.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectRunBefore C-Win 
PROCEDURE selectRunBefore :
/*------------------------------------------------------------------------------
  Purpose:     Finds a Folder name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE fiFindBeforeOld  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSelect         AS LOGICAL  NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            fiFindBeforeOld = fiFindBefore.

        SYSTEM-DIALOG GET-FILE fiFindBefore
            FILTERS "Object Files (*.r)" "*.r",
                    "Source Procedure Files (*.p)" "*.p",
                    "Source Window Files (*.w)" "*.w",
                    "All Files (*.*)" "*.*"
            CREATE-TEST-FILE
            MUST-EXIST
            TITLE "Select the file to run before package load":U
            USE-FILENAME
            UPDATE lSelect
            .

        IF NOT lSelect 
        THEN
            ASSIGN
                fiFindBefore = fiFindBeforeOld.

        ASSIGN
            fiFindBefore:SCREEN-VALUE    = fiFindBefore.

        APPLY "VALUE-CHANGED" TO fiFindBefore.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

