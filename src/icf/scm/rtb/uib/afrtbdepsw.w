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

  File: afrtbdepsw.w

  Description: ICF deployment packaging
               Run from af/cod/afrtbevntp.p deploy hook

  Input Parameters: string of recid of rtb_site
                    string of recid of rtb_deploy

  Output Parameters:

  Author: Pieter Meyer

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

DEFINE INPUT  PARAMETER cRtbSite        AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER cRtbDeploy      AS CHARACTER    NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cWspaceId               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSiteLicence            AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cWspaceDirectory        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDeployDirectory        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSchemaDirectory        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cRepositoryDirectory    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDataExportDirectory    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDeltaDirectory         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iDeploymentSeq          AS INTEGER      NO-UNDO.
DEFINE VARIABLE cSiteCode               AS CHARACTER    NO-UNDO.

DEFINE STREAM sMain.
DEFINE STREAM sOut1.
DEFINE STREAM sOut2.

DEFINE TEMP-TABLE ttDelta  NO-UNDO
FIELD cDeltaFile           AS CHARACTER
INDEX idxMain IS PRIMARY cDeltaFile.

{af/sup/afproducts.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS toDeltas toExportData toDeployRepository ~
toDeployRepoVersion toCopyRcode toDeleteSource buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS fiWorkspace fiSite fiLicense fiDeployment ~
fiDirectory fiSchemaDir toDeltas tDoneDeltas toExportData tDoneExportData ~
toDeployRepository tDoneRepository toDeployRepoVersion tDoneRepoVersion ~
toCopyRcode tDoneCopyRcode toDeleteSource tDoneDeleteSource 

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
     SIZE 20.4 BY 1.14 TOOLTIP "Close this window and abondon uncompleted options"
     BGCOLOR 8 .

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&Deploy Selected Options ..." 
     SIZE 50 BY 1.14 TOOLTIP "Run deployment package options selected"
     BGCOLOR 8 .

DEFINE VARIABLE fiDeployment AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Deployment Number" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE fiDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deployment Root Directory" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE fiLicense AS CHARACTER FORMAT "X(256)":U 
     LABEL "Site License" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE fiSchemaDir AS CHARACTER FORMAT "X(256)":U 
     LABEL "RTB Schema Directory" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE fiSite AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deployment Site" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE fiWorkspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Deployment Workspace" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE tDoneCopyRcode AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneDeleteSource AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneDeltas AS LOGICAL INITIAL no 
     LABEL "Completed" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE tDoneExportData AS LOGICAL INITIAL no 
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

DEFINE VARIABLE toCopyRcode AS LOGICAL INITIAL no 
     LABEL "Copy Workspace R-Code for Deployment" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Send r-code with deployment package" NO-UNDO.

DEFINE VARIABLE toDeleteSource AS LOGICAL INITIAL no 
     LABEL "Delete Source Code from Deployment" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Delete source code from package because deploying to non-development site" NO-UNDO.

DEFINE VARIABLE toDeltas AS LOGICAL INITIAL no 
     LABEL "Create Schema Deltas Control File" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to create schema control text file for changed schema" NO-UNDO.

DEFINE VARIABLE toDeployRepository AS LOGICAL INITIAL no 
     LABEL "Deploy Repository Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Deploy ICFDB repository data for dynamic objects" NO-UNDO.

DEFINE VARIABLE toDeployRepoVersion AS LOGICAL INITIAL no 
     LABEL "Deploy Repository Version Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Deploy RVDB version data for partner site loads" NO-UNDO.

DEFINE VARIABLE toExportData AS LOGICAL INITIAL no 
     LABEL "Export Static/Transaction Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to selectively deploy static data, e.g. menus, etc." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiWorkspace AT ROW 1.19 COL 26.2 COLON-ALIGNED
     fiSite AT ROW 2.29 COL 26.2 COLON-ALIGNED
     fiLicense AT ROW 3.48 COL 26.2 COLON-ALIGNED
     fiDeployment AT ROW 4.62 COL 26.2 COLON-ALIGNED
     fiDirectory AT ROW 5.76 COL 26.2 COLON-ALIGNED
     fiSchemaDir AT ROW 6.91 COL 26.2 COLON-ALIGNED
     toDeltas AT ROW 8.24 COL 2.6
     tDoneDeltas AT ROW 8.24 COL 54.6
     toExportData AT ROW 9.19 COL 2.6
     tDoneExportData AT ROW 9.19 COL 54.6
     toDeployRepository AT ROW 10.14 COL 2.6
     tDoneRepository AT ROW 10.14 COL 54.6
     toDeployRepoVersion AT ROW 11.1 COL 2.6
     tDoneRepoVersion AT ROW 11.1 COL 54.6
     toCopyRcode AT ROW 12.05 COL 2.6
     tDoneCopyRcode AT ROW 12.05 COL 54.6
     toDeleteSource AT ROW 13 COL 2.6
     tDoneDeleteSource AT ROW 13 COL 54.6
     buOK AT ROW 14.43 COL 2.6
     buCancel AT ROW 14.43 COL 54.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.8 BY 14.71
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
         TITLE              = "Dynamics Deployment Packaging"
         HEIGHT             = 14.71
         WIDTH              = 74.8
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
/* SETTINGS FOR FILL-IN fiDeployment IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDirectory IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiLicense IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSchemaDir IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSite IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiWorkspace IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneCopyRcode IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneDeleteSource IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneDeltas IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneExportData IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneRepository IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tDoneRepoVersion IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ICF Deployment Packaging */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ICF Deployment Packaging */
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


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Deploy Selected Options ... */
DO:

  DEFINE VARIABLE lContinue AS LOGICAL INITIAL YES NO-UNDO.

  MESSAGE
    "Before proceeding with ICF deployment packaging options, please ensure that" SKIP
    "You have fully XREF compiled the workspace being deployed to ensure all the r-code" SKIP
    "is up-to-date, that you have created a release, and you have pressed the MAKE" SKIP
    "button on the SCM deployment screen to physically create the deployment" SKIP
    "package directories containing the SCM files to deploy." SKIP(1)
    "Even though ICF does not use the standard SCM schema load utilities, " SKIP
    "You should also have pressed the SCHEMA button on the deployment window to " SKIP
    "register schema changes. These are referenced in the SCM Partner Load." SKIP(1)
    "The ICF deployment options rely on the contents of the deployment package" SKIP
    "created by the SCM tool to know what to deploy. They also rely on the original" SKIP
    "workspace contents for r-code copies." SKIP(1)
    "Proceed to add options selected to deployment package in directory: " SKIP
    cDeployDirectory SKIP
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lContinue.

  IF NOT lContinue THEN RETURN NO-APPLY.

  ASSIGN
      toDeltas
      toExportData
      toDeployRepository
      toDeployRepoVersion
      toCopyRcode
      toDeleteSource
      .

    RUN continueDeploy.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildDeltaFile C-Win 
PROCEDURE buildDeltaFile :
/*------------------------------------------------------------------------------
  Purpose:     To generate a delta control file for deltas sent in deployment
  Parameters:  output error text if any
  Notes:       Uses all information available globally to this window.
               Looks in the deployment directory for all deltas included as
               part of the deployment.
               Only includes deltas that conform to the ICF standard naming
               convention, e.g. the 1st 4 characters refer to a dbname, the
               next 6 are the database version number, and the end is either
               full.df or delta.df.
               Only stores the relative path of the delta file in the control
               file.
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER cError                AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttDelta.

  SESSION:SET-WAIT-STATE("general":U).

  DEFINE VARIABLE cDirectory  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExtensions AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cBatchFile  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cOutputFile AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iLoop2      AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iPosn       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iVersion    AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cRawFile    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLastDB     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFileList   AS CHARACTER    NO-UNDO.

  DEFINE BUFFER bttDelta FOR ttDelta.

  /* Write batch file to do a directory listing of all files in the directory specified */
  ASSIGN
      cBatchFile      = SESSION:TEMP-DIRECTORY + "dir.bat":U
      cOutputFile     = SESSION:TEMP-DIRECTORY + "dir.log":U
      cExtensions     = "df":U
      cDirectory      = LC(TRIM(REPLACE(cDeployDirectory,"/":U,"\":U)))
      .

  OUTPUT STREAM sMain TO VALUE(cBatchFile).
  DO iLoop = 1 TO NUM-ENTRIES(cExtensions):
      PUT STREAM sMain UNFORMATTED
          "dir /b/l/on/s ":U
          cDirectory
          "\*.":U
          ENTRY(iLoop, cExtensions)
          (IF iLoop = 1 THEN " > ":U ELSE " >> ":U)
          cOutputFile
          SKIP.
  END.
  OUTPUT STREAM sMain CLOSE.

  /* Execute batch file */
  OS-COMMAND SILENT VALUE(cBatchFile).

  /* Check result */
  IF SEARCH(cOutputFile) <> ? THEN
  DO:
    INPUT STREAM sMain FROM VALUE(cOutputFile) NO-ECHO.
    file-loop:
    REPEAT:
      IMPORT STREAM sMain UNFORMATTED
          cFileName.

      /* strip off deployment root path */
      ASSIGN
        cFileName = REPLACE(cFileName,cDirectory,"":U)
        cFileName = REPLACE(cFileName,"~\":U,"~/":U)
        cFileName   = LC(TRIM(cFileName,"~/":U))
        .

      /* Validate file structure */
      IF INDEX(cFilename,"full.df":U) = 0 AND INDEX(cFilename,"delta.df":U) = 0 THEN
        NEXT file-loop.

      ASSIGN iPosn = R-INDEX(cFileName,"/":U) + 1.
      IF iPosn = 1 THEN
          ASSIGN iPosn = R-INDEX(cFileName,"~\":U) + 1.
      ASSIGN
        cRawFile = TRIM(LC(SUBSTRING(cFileName,iPosn)))
        iVersion = 0.

      ASSIGN iVersion = INTEGER(SUBSTRING(cRawFile,5,6)) NO-ERROR.
      IF iVersion = 0 THEN NEXT file-loop.

      FIND FIRST ttDelta NO-LOCK
          WHERE ttDelta.cDeltaFile = cFileName
          NO-ERROR.
      IF NOT AVAILABLE ttDelta THEN
      DO:
        CREATE ttDelta.
        ASSIGN
          ttDelta.cDeltaFile = cFileName
          .
      END.
    END.
    INPUT STREAM sMain CLOSE.
  END.

  /* Delete temp files */
  OS-DELETE VALUE(cBatchFile) NO-ERROR.
  OS-DELETE VALUE(cOutputFile) NO-ERROR.

  /* Tidy up temp-table of deltas to apply to only contain a single most
     recent full.df and any deltas subsequent to the last full
  */

  ASSIGN
    cLastDB = "":U
    cFileList = "":U
    .
  FOR EACH ttDelta BY ttDelta.cDeltaFile:
    ASSIGN iPosn = R-INDEX(ttDelta.cDeltaFile,"/":U) + 1.
    IF iPosn = 1 THEN
        ASSIGN iPosn = R-INDEX(ttDelta.cDeltaFile,"~\":U) + 1.
    ASSIGN
      cRawFile = TRIM(LC(SUBSTRING(ttDelta.cDeltaFile,iPosn))).

    IF SUBSTRING(cRawFile,1,4) = cLastDB OR cLastDB = "":U THEN
    DO:
      IF cLastDB = "":U THEN ASSIGN cLastDB = SUBSTRING(cRawFile,1,4). /* First time issue */
      ASSIGN
        cFileList = cFileList + (IF cFileList <> "":U THEN ",":U ELSE "":U) + ttDelta.cDeltaFile.      
    END.
    ELSE 
    DO: /* process list of files for 1 DB and remove before last full */
      delta-loop:
      DO iLoop = NUM-ENTRIES(cFileList) TO 1 BY -1:
        IF INDEX(ENTRY(iLoop,cFileList),"full.df":U) = 0 THEN NEXT delta-loop.
        ELSE LEAVE delta-loop.
      END.
      IF iLoop > 1 THEN
      delete-loop:
      DO iLoop2 = 1 TO iLoop - 1:
        FIND FIRST bttDelta
             WHERE bttDelta.cDeltaFile = ENTRY(iLoop2,cFileList).
        DELETE bttDelta.
      END.
      ASSIGN
        cFileList = ttDelta.cDeltaFile
        cLastDB = SUBSTRING(cRawFile,1,4)
        .    
    END.

  END.

  /* Finish off last one */
  IF cFileList <> "":U THEN
  DO:
    delta-loop2:
    DO iLoop = NUM-ENTRIES(cFileList) TO 1 BY -1:
      IF INDEX(ENTRY(iLoop,cFileList),"full.df":U) = 0 THEN NEXT delta-loop2.
      ELSE LEAVE delta-loop2.
    END.
    IF iLoop > 1 THEN
    delete-loop2:
    DO iLoop2 = 1 TO iLoop - 1:
      FIND FIRST bttDelta
           WHERE bttDelta.cDeltaFile = ENTRY(iLoop2,cFileList).
      DELETE bttDelta.
    END.
  END.

  /* Now have delta temp-table with entries we want - generate delta control file */
  ASSIGN
    cDirectory = LC(TRIM(REPLACE(cDeltaDirectory,"/":U,"\":U)))
    cFilename = cDirectory + "icfdeltas.txt":U
    .
  OUTPUT STREAM sMain TO VALUE(cFilename).

  PUT STREAM sMain UNFORMATTED "Deltas for Deployment Site: " cSiteCode SKIP.
  PUT STREAM sMain UNFORMATTED "Deltas for Deployment No. : " iDeploymentSeq SKIP.
  PUT STREAM sMain UNFORMATTED "Generated Date and Time   : " STRING(TODAY) + " Time: " + STRING(TIME,"hh:mm":U) SKIP(1).

  FOR EACH ttDelta BY ttDelta.cDeltafile:
    PUT STREAM sMain UNFORMATTED ttDelta.cDeltafile SKIP.
  END.

  OUTPUT STREAM sMain CLOSE.
  SESSION:SET-WAIT-STATE("":U).

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE continueDeploy C-Win 
PROCEDURE continueDeploy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
toggle
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cError                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumericDecimalPoint    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNumericSeparator       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNumericFormat          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDateFormat             AS CHARACTER    NO-UNDO.

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

  /* (1) - Create the delta control file */
  IF (toDeltas = YES AND tDoneDeltas = NO) THEN
  DO:
    ASSIGN
      tDoneDeltas:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
    OS-CREATE-DIR VALUE(cDeltaDirectory).
    ASSIGN
        cDeltaDirectory = TRIM(cDeltaDirectory,"~/":U) + "~/":U.

    RUN buildDeltaFile (OUTPUT cError).     

    IF cError = "":U THEN
      ASSIGN
          tDoneDeltas = YES
          tDoneDeltas:LABEL        IN FRAME {&FRAME-NAME} = "Completed":U
          tDoneDeltas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneDeltas)
          .
    ELSE
      ASSIGN
          tDoneDeltas = NO
          tDoneDeltas:LABEL        IN FRAME {&FRAME-NAME} = "InComplete":U
          tDoneDeltas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneDeltas)
          .
  END. /* Create the delta control file */

  /* (2) - Export the Static / Transcation Data */
  IF  (toExportData    = YES AND tDoneExportData = NO) THEN
  DO:
    ASSIGN
      tDoneExportData:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
    OS-CREATE-DIR VALUE(cDataExportDirectory).
    ASSIGN
        cDataExportDirectory = TRIM(cDataExportDirectory,"~/":U) + "~/":U.
    RUN af/cod/afdbdeplyw.w (INPUT cDataExportDirectory,
                             INPUT cDeployDirectory,
                             INPUT cSiteCode,
                             INPUT fiLicense,
                             INPUT iDeploymentSeq,
                             OUTPUT cError).
    IF cError = "":U THEN
      ASSIGN
          tDoneExportData = YES
          tDoneExportData:LABEL        IN FRAME {&FRAME-NAME} = "Completed":U
          tDoneExportData:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneExportData)
          .
    ELSE
      ASSIGN
          tDoneExportData = NO
          tDoneExportData:LABEL        IN FRAME {&FRAME-NAME} = "InComplete":U
          tDoneExportData:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneExportData)
          .
  END. /* Export the Static / Transcation Data */ 

  /* (3) - Deploy Repoistory and Version Data */
  IF (toDeployRepository  = YES AND tDoneRepository  = NO) OR 
     (toDeployRepoVersion = YES AND tDoneRepoVersion = NO) THEN
  DO:
    IF toDeployRepository  = YES THEN
      ASSIGN
        tDoneRepository:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
    IF toDeployRepoVersion = YES THEN
      ASSIGN
        tDoneRepoVersion:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
    OS-CREATE-DIR VALUE(cRepositoryDirectory).
    RUN af/cod/afrtbrdepw.w (INPUT  toDeployRepository
                            ,INPUT  toDeployRepoVersion
                            ,INPUT  cWspaceId
                            ,INPUT  cRepositoryDirectory
                            ,INPUT  cSiteCode
                            ,INPUT  cSiteLicence
                            ,INPUT  cDeployDirectory
                            ,INPUT  iDeploymentSeq
                            ,OUTPUT cError).
    IF cError = "":U THEN
    DO:
      IF toDeployRepository  = YES
      THEN ASSIGN
        tDoneRepository = YES
        tDoneRepository:LABEL IN FRAME {&FRAME-NAME} = "Completed":U
        .
      IF toDeployRepoVersion = YES
      THEN ASSIGN
        tDoneRepoVersion = YES
        tDoneRepoVersion:LABEL IN FRAME {&FRAME-NAME} = "Completed":U
        .
    END.
    ELSE
    DO:
      IF toDeployRepository  = YES
      THEN ASSIGN
        tDoneRepository = NO
        tDoneRepository:LABEL IN FRAME {&FRAME-NAME} = "InComplete":U
        .
      IF toDeployRepoVersion = YES
      THEN ASSIGN
        tDoneRepoVersion = NO
        tDoneRepoVersion:LABEL IN FRAME {&FRAME-NAME} = "InComplete":U
        .

    END.
    ASSIGN
      tDoneRepository:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = STRING(tDoneRepository)
      tDoneRepoVersion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneRepoVersion)
      .
  END. /* Deploy Repoistory and Version Data */

  /* (4) - Copy r-code and delete source code */

  /* COPY RCODE ACROSS TO THE DEPLOYMENT DIRECTORY */
  /* DELETE SOURCE IN DEPLOYMENT DIRECTORY IF NOT PARTNER "P" DEPLOYMENT */
  IF (toCopyRcode    AND tDoneCopyRcode    = NO) OR 
     (toDeleteSource AND tDoneDeleteSource = NO) THEN
  DO:
    IF toCopyRcode = YES THEN
      ASSIGN
        tDoneCopyRcode:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
    IF toDeleteSource = YES THEN 
      ASSIGN
        tDoneDeleteSource:LABEL IN FRAME {&FRAME-NAME} = "Processing...":U.
    RUN af/cod/afrtbdeplw.w (INPUT  toCopyRcode
                            ,INPUT  toDeleteSource
                            ,INPUT  cWspaceId
                            ,INPUT  cWspaceDirectory
                            ,INPUT  cDeployDirectory
                            ,INPUT  cSchemaDirectory
                            ,INPUT  cSiteLicence
                            ,OUTPUT cError).
    IF cError = "":U THEN
    DO:
      IF toCopyRcode  = YES
      THEN ASSIGN
        tDoneCopyRcode = YES
        tDoneCopyRcode:LABEL IN FRAME {&FRAME-NAME} = "Completed":U
        .
      IF toDeleteSource = YES
      THEN ASSIGN
        tDoneDeleteSource = YES
        tDoneDeleteSource:LABEL IN FRAME {&FRAME-NAME} = "Completed":U
        .
    END.
    ELSE DO:
      IF toCopyRcode  = YES
      THEN ASSIGN
        tDoneCopyRcode  = NO
        tDoneCopyRcode:LABEL IN FRAME {&FRAME-NAME} = "InComplete":U
        .
      IF toDeleteSource = YES
      THEN ASSIGN
        tDoneDeleteSource = NO
        tDoneDeleteSource:LABEL IN FRAME {&FRAME-NAME} = "InComplete":U
        .
    END.

    ASSIGN
      tDoneCopyRcode:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = STRING(tDoneCopyRcode)
      tDoneDeleteSource:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(tDoneDeleteSource)
      .
  END. /* Copy r-code and delete source code */

  ASSIGN
    buCancel:LABEL IN FRAME {&FRAME-NAME} = "Close":U
    .

  MESSAGE
    " ICF Deployment Hook's Completed - Press Close to Exit. "
    VIEW-AS ALERT-BOX INFORMATION.

  SESSION:NUMERIC-FORMAT = cNumericFormat.
  SESSION:SET-NUMERIC-FORMAT(cNumericSeparator,cNumericDecimalPoint). /* seperator, decimal */ 
  SESSION:DATE-FORMAT = cDateFormat.

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
  DISPLAY fiWorkspace fiSite fiLicense fiDeployment fiDirectory fiSchemaDir 
          toDeltas tDoneDeltas toExportData tDoneExportData toDeployRepository 
          tDoneRepository toDeployRepoVersion tDoneRepoVersion toCopyRcode 
          tDoneCopyRcode toDeleteSource tDoneDeleteSource 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE toDeltas toExportData toDeployRepository toDeployRepoVersion 
         toCopyRcode toDeleteSource buOK buCancel 
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

        FIND FIRST rtb_site NO-LOCK
            WHERE STRING(RECID(rtb_site)) = cRtbSite
            NO-ERROR.
        IF NOT AVAILABLE rtb_site
        THEN DO:
            MESSAGE
                "Roundtable Site RECID value not found":U
                VIEW-AS ALERT-BOX INFORMATION.
            APPLY "CHOOSE":U TO buCancel.
        END.

        FIND FIRST rtb_deploy NO-LOCK
            WHERE STRING(RECID(rtb_deploy)) = cRtbDeploy
            NO-ERROR.
        IF NOT AVAILABLE rtb_deploy
        THEN DO:
            MESSAGE
                "Roundtable Deployment RECID value not found":U
                VIEW-AS ALERT-BOX INFORMATION.
            APPLY "CHOOSE":U TO buCancel.
        END.

        IF rtb_site.site-code <> rtb_deploy.site-code
        OR rtb_site.wspace-id <> rtb_deploy.wspace-id
        THEN DO:
            MESSAGE
                "Roundtable Site and Deployment value discrepencies":U
                VIEW-AS ALERT-BOX INFORMATION.
            APPLY "CHOOSE":U TO buCancel.
        END.

        FIND FIRST rtb_wspace NO-LOCK
            WHERE rtb_wspace.wspace-id = rtb_deploy.wspace-id
            NO-ERROR.
        IF NOT AVAILABLE rtb_wspace
        THEN DO:
            MESSAGE
                "Roundtable Workspace not found":U
                VIEW-AS ALERT-BOX INFORMATION.
            APPLY "CHOOSE":U TO buCancel.
        END.
        IF NOT AVAILABLE rtb_wspace
        THEN DO:
            MESSAGE
                "Roundtable Workspace not found":U
                VIEW-AS ALERT-BOX INFORMATION.
            APPLY "CHOOSE":U TO buCancel.
        END.

        ASSIGN
            cWspaceDirectory        = ENTRY(1,rtb_wspace.wspace-path)
            cDeployDirectory        = ENTRY(1,TRIM( REPLACE(rtb_deploy.directory,"~\":U,"~/":U) ,"~/":U))
            cSchemaDirectory        = IF NUM-ENTRIES(rtb_deploy.directory) > 1 THEN cDeployDirectory + "/rtb_dbup/":U + ENTRY(2,TRIM( REPLACE(rtb_deploy.directory,"~\":U,"~/":U) ,"~/":U)) ELSE "":U
            cRepositoryDirectory    = cDeployDirectory + "~/":U + "icf_dbdata":U
            cDataExportDirectory    = cDeployDirectory + "~/":U + "icf_export":U
            cDeltaDirectory         = cDeployDirectory + "~/":U + "icf_deltas":U
            cWspaceId               = rtb_wspace.wspace-id
            cSiteLicence            = rtb_site.licence-type
            iDeploymentSeq          = rtb_deploy.deploy-sequence
            cSiteCode               = rtb_deploy.site-code
            .

        ASSIGN
            toDeltas            = YES
            toExportData        = YES
            toDeployRepository  = NO
            toDeployRepoVersion = NO
            toCopyRcode         = YES
            toDeleteSource      = YES
            .

        IF CONNECTED("ICFDB":U)
        THEN ASSIGN toDeployRepository = YES.
        ELSE DISABLE toDeployRepository.

        IF  CONNECTED("RVDB":U)
        AND rtb_site.licence-type = "P":U
        THEN ASSIGN toDeployRepoVersion = YES.
        ELSE DISABLE toDeployRepoVersion.

        IF rtb_site.licence-type = "P":U
        THEN ASSIGN toDeleteSource = NO.

        ASSIGN
            {&WINDOW-NAME}:TITLE = "Dynamics - Deployment Packaging":U
            toDeltas:SCREEN-VALUE            = STRING(toDeltas)
            toExportData:SCREEN-VALUE        = STRING(toExportData)
            toDeployRepository:SCREEN-VALUE  = STRING(toDeployRepository)
            toDeployRepoVersion:SCREEN-VALUE = STRING(toDeployRepoVersion)
            toCopyRcode:SCREEN-VALUE         = STRING(toCopyRcode)
            toDeleteSource:SCREEN-VALUE      = STRING(toDeleteSource)
            fiDeployment                     = rtb_deploy.deploy-sequence
            fiDirectory                      = cDeployDirectory
            fiSchemaDir                      = cSchemaDirectory
            fiLicense                        = rtb_site.licence-type
            fiSite                           = rtb_site.site-code
            fiWorkspace                      = rtb_wspace.wspace-id
            .

        DISPLAY
          fiDeployment
          fiDirectory
          fiSchemaDir
          fiLicense
          fiSite
          fiWorkspace    
          .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

