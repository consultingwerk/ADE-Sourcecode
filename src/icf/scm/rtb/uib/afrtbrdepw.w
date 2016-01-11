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

  File: afrtbrdepw.w

  Description: ICF Repository Deployment Window

  Input Parameters: Input deploy repository flag
                    Input deploy version data flag
                    Input workspace being deployed
                    input directory to dump data files into
                    input site code
                    input site license type (p = partner)
                    input deployment directory
                    input deployment number
                    output errro text if any

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
DEFINE INPUT PARAMETER plDeployRepository   AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER plDeployVersion      AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER pcWorkspace          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcDirectory          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcSite               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcSiteLicense        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcDeployDirectory    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER piDeploymentSeq      AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorText         AS CHARACTER  NO-UNDO.

ASSIGN        
  pcDirectory = LC( TRIM( REPLACE(pcDirectory,"~\":U,"~/":U) ,"~/":U ) ) + "/":U
  pcErrorText = "":U
  .

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE glDone AS LOGICAL INITIAL NO NO-UNDO.

DEFINE STREAM sMain.
DEFINE STREAM sOut1.
DEFINE STREAM sOut2.

DEFINE TEMP-TABLE ttDeploy  NO-UNDO
FIELD cDeployObject         AS CHARACTER
INDEX idxMain IS PRIMARY cDeployObject.

DEFINE TEMP-TABLE ttSmartObjects
       FIELD tfSWorkspace       AS CHARACTER
       FIELD tfSProductModule   AS CHARACTER
       FIELD tfSObjectName      AS CHARACTER
       FIELD tfSBaseOverride    AS LOGICAL
       FIELD tfSDeleteHistory   AS LOGICAL
       INDEX tiSMain            IS PRIMARY UNIQUE
              tfSObjectName
       .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ToFull edResults buOK buCancel 
&Scoped-Define DISPLAYED-OBJECTS toRepositoryData ToFull ToVersionData ~
edResults 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDumpName C-Win 
FUNCTION getDumpName RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel AUTO-END-KEY DEFAULT 
     LABEL "&Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buOK DEFAULT 
     LABEL "&Deploy Data" 
     SIZE 15 BY 1.14 TOOLTIP "Run deployment packaging for selection"
     BGCOLOR 8 .

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 100 BY 12.38 NO-UNDO.

DEFINE VARIABLE ToFull AS LOGICAL INITIAL no 
     LABEL "Deploy Full Repository" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 NO-UNDO.

DEFINE VARIABLE toRepositoryData AS LOGICAL INITIAL no 
     LABEL "Deploy Repository Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE ToVersionData AS LOGICAL INITIAL no 
     LABEL "Deploy Version Data for Partner Site" 
     VIEW-AS TOGGLE-BOX
     SIZE 44.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     toRepositoryData AT ROW 1.19 COL 4.6
     ToFull AT ROW 1.19 COL 56.2
     ToVersionData AT ROW 2.24 COL 4.6
     edResults AT ROW 3.48 COL 4.6 NO-LABEL
     buOK AT ROW 16.14 COL 73.8
     buCancel AT ROW 16.14 COL 90
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105.8 BY 16.52
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
         TITLE              = "Dynamics -  Repository Deployment"
         HEIGHT             = 16.52
         WIDTH              = 105.8
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
ASSIGN 
       edResults:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       edResults:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR TOGGLE-BOX toRepositoryData IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX ToVersionData IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ICF -  Repository Deployment */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ICF -  Repository Deployment */
DO:

    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:

  IF NOT glDone THEN
  DO:
    MESSAGE "You have elected not to deploy Repository and Versioning data" SKIP
            "as part of this deployment package. Normally you should always" SKIP
            "deploy the Repository data if you are using dynamic objects." SKIP 
            "Continue with Cancel" SKIP
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE lChoice AS LOGICAL.
    IF lChoice = NO THEN RETURN NO-APPLY.
    ELSE ASSIGN pcErrorText = "Cancelled".
  END.
  
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOK C-Win
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Deploy Data */
DO:

  ASSIGN
    ToFull
    ToVersionData
    ToRepositoryData
    .

  MESSAGE
      SKIP "Do you want to deploy the Repository / Version data according to the options" SKIP
           "selected, into directory: " pcDirectory SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lChoice AS LOGICAL.
  IF lChoice = YES
  THEN
  DO:
    RUN DeployRepository.
    
    ASSIGN
        buCancel:LABEL IN FRAME {&FRAME-NAME} = "&Close":U
        glDone = YES.
  END.
  ELSE
    RETURN NO-APPLY.

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

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.

    RUN mainSetup.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildDeployed C-Win 
PROCEDURE BuildDeployed :
/*------------------------------------------------------------------------------
  Purpose:     Build temp-table of objects to deploy
  Parameters:  <none>
  Notes:       Uses files in the deployment package - source code must still be
               in deployment package to work out which objects to send.
------------------------------------------------------------------------------*/

  edResults:INSERT-STRING("  Building list of objects to deploy..." + CHR(10)) IN FRAME {&FRAME-NAME}.

  DEFINE VARIABLE cDirectory  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExtensions AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cBatchFile  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cOutputFile AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iPosn       AS INTEGER      NO-UNDO.

  /* Write batch file to do a directory listing of all files in the directory specified */
  ASSIGN
      cBatchFile      = SESSION:TEMP-DIRECTORY + "dir.bat":U
      cOutputFile     = SESSION:TEMP-DIRECTORY + "dir.log":U
      cExtensions     = "w,ado":U
      cDirectory      = LC(TRIM(REPLACE(pcDirectory,"/":U,"\":U)))
      cDirectory      = REPLACE(cDirectory,"\icf_dbdata":U,"":U)
      .

  OUTPUT STREAM sMain TO VALUE(cBatchFile).
  DO iLoop = 1 TO NUM-ENTRIES(cExtensions):
      PUT STREAM sMain UNFORMATTED
          "dir /b/l/on/s ":U
          cDirectory
          "*.":U
          ENTRY(iLoop, cExtensions)
          (IF iLoop = 1 THEN " > ":U ELSE " >> ":U)
          cOutputFile
          SKIP.
  END.
  OUTPUT STREAM sMain CLOSE.

  /* Execute batch file */
  OS-COMMAND SILENT VALUE(cBatchFile).

  /* Check result */
  IF SEARCH(cOutputFile) <> ?
  THEN DO:
      INPUT STREAM sMain FROM VALUE(cOutputFile) NO-ECHO.
      REPEAT:
          IMPORT STREAM sMain UNFORMATTED
              cFileName.

          /* strip off path */
          ASSIGN iPosn = R-INDEX(cFileName,"/":U) + 1.
          IF iPosn = 1 THEN
              ASSIGN iPosn = R-INDEX(cFileName,"~\":U) + 1.
          ASSIGN cFileName = TRIM(LC(SUBSTRING(cFileName,iPosn))).
          
          FIND FIRST ttDeploy NO-LOCK
              WHERE ttDeploy.cDeployObject = cFileName
              NO-ERROR.
          IF NOT AVAILABLE ttDeploy
          THEN DO:
              CREATE ttDeploy.
              ASSIGN
                  ttDeploy.cDeployObject = cFileName
                  .
          END.
      END.
      INPUT STREAM sMain CLOSE.
  END.

  /* Delete temp files */
  OS-DELETE VALUE(cBatchFile) NO-ERROR.
  OS-DELETE VALUE(cOutputFile) NO-ERROR.

  edResults:INSERT-STRING("  List of objects completed." + CHR(10)) IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deployRepository C-Win 
PROCEDURE deployRepository :
/*------------------------------------------------------------------------------
  Purpose:     Deploy repository / version data according to options selected
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttDeploy.
  
  SESSION:SET-WAIT-STATE("general":U).

  IF NOT toFull THEN
    RUN BuildDeployed.
  
  IF toRepositoryData THEN RUN ExportRYData.
  IF toVersionData THEN RUN ExportRVData.
  
  SESSION:SET-WAIT-STATE("":U).
  
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
  DISPLAY toRepositoryData ToFull ToVersionData edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE ToFull edResults buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportRVData C-Win 
PROCEDURE ExportRVData :
/*------------------------------------------------------------------------------
  Purpose:     Export Version Data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  edResults:INSERT-STRING("  Starting deploy of version data..." + CHR(10)) IN FRAME {&FRAME-NAME}.

  DEFINE VARIABLE cExportConfigurationType    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWorkspace            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWorkspaceModule      AS CHARACTER    NO-UNDO.
  
  DEFINE VARIABLE cExportConfigurationItem    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWorkspaceItem        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportItemVersion          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iDeployVersion              AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cVersionList                AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cModuleList                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lBaselineVersion            AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE iPrevVersion                AS INTEGER      NO-UNDO.
  DEFINE VARIABLE dPrevModule                 AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE cFullObjectName             AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb1_rvt_item_version FOR rvt_item_version.

  cExportConfigurationType  = getDumpName("rvc_configuration_type":U).
  cExportWorkspace          = getDumpName("rvm_workspace":U).
  cExportWorkspaceModule    = getDumpName("rvm_workspace_module":U).
  
  cExportConfigurationItem  = getDumpName("rvm_configuration_item":U).
  cExportWorkspaceItem      = getDumpName("rvm_workspace_item":U).
  cExportItemVersion        = getDumpName("rvt_item_version":U).
  
  /* Zap current dumps incase we re-run */
  OS-DELETE VALUE(cExportConfigurationType) NO-ERROR.
  OS-DELETE VALUE(cExportWorkspace) NO-ERROR.
  OS-DELETE VALUE(cExportWorkspaceModule) NO-ERROR.
  OS-DELETE VALUE(cExportConfigurationItem) NO-ERROR.
  OS-DELETE VALUE(cExportWorkspaceItem) NO-ERROR.
  OS-DELETE VALUE(cExportItemVersion) NO-ERROR.

  IF NOT CAN-FIND(FIRST rvm_workspace
                  WHERE rvm_workspace.workspace_code = pcWorkspace) THEN
  DO:
    edResults:INSERT-STRING("  RV Workspace does not exist for: " + pcWorkspace + CHR(10)) IN FRAME {&FRAME-NAME}.
    edResults:INSERT-STRING("  Aborting RV dump." + CHR(10)) IN FRAME {&FRAME-NAME}.
    RETURN.    
  END.

  /* Dump full static data for RV system every time */
  OUTPUT STREAM sOut1 TO VALUE(cExportConfigurationType).
  FOR EACH rvc_configuration_type NO-LOCK:
    EXPORT STREAM sOut1 rvc_configuration_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportWorkspace).
  FOR EACH rvm_workspace NO-LOCK:
    EXPORT STREAM sOut1 rvm_workspace.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportWorkspaceModule).
  FOR EACH rvm_workspace_module NO-LOCK:
    EXPORT STREAM sOut1 rvm_workspace_module.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  /* loop through objects to dump */  
  FIND FIRST rvm_workspace NO-LOCK
       WHERE rvm_workspace.workspace_code = pcWorkspace
       NO-ERROR.
  
  smartobject-loop:
  FOR EACH ryc_smartobject NO-LOCK:

    /* get full name including .ado extension */
    IF NUM-ENTRIES(ryc_smartobject.object_filename,".":U) > 1
    AND LENGTH(ENTRY(NUM-ENTRIES(ryc_smartobject.object_filename,".":U),ryc_smartobject.object_filename,".":U)) <= 3
    THEN ASSIGN cFullObjectName = ryc_smartobject.object_filename.
    ELSE ASSIGN cFullObjectName = ryc_smartobject.object_filename + ".ado":U.

    /* If not doing full repository dump - check if in list of objects required */
    IF NOT toFull AND
       NOT CAN-FIND(FIRST ttDeploy
                    WHERE ttDeploy.cDeployObject = cFullObjectName) THEN NEXT smartobject-loop.

    /* we have a smartobject we want to deploy version data for */
    edResults:INSERT-STRING("  Deploying version data for object: " + cFullObjectName + CHR(10)) IN FRAME {&FRAME-NAME}.

    /* dump data */
    FIND FIRST rvm_configuration_item NO-LOCK
         WHERE rvm_configuration_item.scm_object_name = ryc_smartobject.OBJECT_filename
         NO-ERROR.
    IF NOT AVAILABLE rvm_configuration_item THEN
    DO:
      edResults:INSERT-STRING("  Configuration Item not found for object: " + cFullObjectName + CHR(10)) IN FRAME {&FRAME-NAME}.
      NEXT smartobject-loop.
    END.

    FIND FIRST rvm_workspace_item NO-LOCK
         WHERE rvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj
           AND rvm_workspace_item.configuration_type = rvm_configuration_item.configuration_type
           AND rvm_workspace_item.scm_object_name = rvm_configuration_item.scm_object_name
         NO-ERROR.
    IF AVAILABLE rvm_workspace_item THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(cExportWorkspaceItem) APPEND.
      EXPORT STREAM sOut1 rvm_workspace_item.
      OUTPUT STREAM sOut1 CLOSE.
      ASSIGN iDeployVersion = rvm_workspace_item.ITEM_version_number.
    END.
    ELSE
    DO:
      edResults:INSERT-STRING("  Workspace Item not found for object: " + cFullObjectName + CHR(10)) IN FRAME {&FRAME-NAME}.
      NEXT smartobject-loop.
    END.

    FIND FIRST rvm_configuration_item NO-LOCK
         WHERE rvm_configuration_item.scm_object_name = ryc_smartobject.OBJECT_filename
           AND rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
           AND rvm_configuration_item.configuration_type = "rycso":U
         NO-ERROR.
    IF AVAILABLE rvm_configuration_item THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(cExportConfigurationItem) APPEND.
      EXPORT STREAM sOut1 rvm_configuration_item.
      OUTPUT STREAM sOut1 CLOSE.
    END.
    ELSE
    DO:
      edResults:INSERT-STRING("  Configuration Item not found for object: " + cFullObjectName + CHR(10)) IN FRAME {&FRAME-NAME}.
      NEXT smartobject-loop.
    END.
    
    /* See if this is a baseline version and if not, start from latest
       baseline version and dump all versions data required to build
       latest version from baseline.
    */    
    FIND FIRST rvt_item_version NO-LOCK
         WHERE rvt_item_version.configuration_type = rvm_configuration_item.configuration_type
           AND rvt_item_version.scm_object_name = rvm_configuration_item.scm_object_name
           AND rvt_item_version.product_module_obj = rvm_workspace_item.product_module_obj
           AND rvt_item_version.ITEM_version_number = iDeployVersion
         NO-ERROR.
    IF NOT AVAILABLE rvt_item_version THEN
    DO:
      edResults:INSERT-STRING("  Item Version not found for object: " + cFullObjectName + " Module: " + STRING(rvm_workspace_item.product_module_obj) + ",Version: " + STRING(iDeployVersion) + CHR(10)) IN FRAME {&FRAME-NAME}.
      NEXT smartobject-loop.
    END.

    ASSIGN
      cVersionList = STRING(rvt_item_version.item_version_number)
      cModuleList = STRING(rvt_item_version.product_module_obj)
      .

    /* Dump data for all versions from baseline */
    version-loop2:
    DO iloop = NUM-ENTRIES(cVersionList, CHR(3)) TO 1 BY -1:

      FIND FIRST lb1_rvt_item_version NO-LOCK
         WHERE lb1_rvt_item_version.configuration_type = rvt_item_version.configuration_type
           AND lb1_rvt_item_version.scm_object_name = rvt_item_version.scm_object_name
           AND lb1_rvt_item_version.item_version_number = INTEGER(ENTRY(iloop, cVersionList, CHR(3)))
           AND lb1_rvt_item_version.product_module_obj = DECIMAL(ENTRY(iloop, cModuleList,CHR(3)))
         NO-ERROR.

      OUTPUT STREAM sOut1 TO VALUE(cExportItemVersion) APPEND.
      EXPORT STREAM sOut1 lb1_rvt_item_version.
      OUTPUT STREAM sOut1 CLOSE.

    END. /* version-loop2 */
    
  END. /* smartobject loop */

  edResults:INSERT-STRING("  Version data deployed." + CHR(10)) IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportRYData C-Win 
PROCEDURE ExportRYData :
/*------------------------------------------------------------------------------
  Purpose:     Export Repository Data
  Parameters:  <none>
  Notes:       Also deploy ICFDB data required by repository
------------------------------------------------------------------------------*/
  edResults:INSERT-STRING("  Starting deploy of repository data..." + CHR(10)) IN FRAME {&FRAME-NAME}.

  DEFINE VARIABLE cExportAction           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttribute        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttributeGroup   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttributeType    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportBand             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportBandAction       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportLayout           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSmartLinkType    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSubscribe        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSupportedLink    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportUITrigger        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportValidUITrigger   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWidgetType       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportLookupField      AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE cExportObjectType       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportProduct          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportProductModule    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE cExportSmartObject      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportObjectInstance   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportPage             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportPageObject       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSmartLink        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportSmartObjectField AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportCustomUiTrigger  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportAttributeValue   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportgscObject        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportDataVersion      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cFullObjectName         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardMenc      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardObjc      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardFold      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardFoldPage  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardView      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExportWizardBrow      AS CHARACTER    NO-UNDO.

  cExportAction             = getDumpName("ryc_action":U).
  cExportAttribute          = getDumpName("ryc_attribute":U).
  cExportAttributeGroup     = getDumpName("ryc_attribute_group":U).
  cExportAttributeType      = getDumpName("ryc_attribute_type":U).
  cExportBand               = getDumpName("ryc_band":U).
  cExportBandAction         = getDumpName("ryc_band_action":U).
  cExportLayout             = getDumpName("ryc_layout":U).
  cExportSmartLinkType      = getDumpName("ryc_smartlink_type":U).
  cExportSubscribe          = getDumpName("ryc_subscribe":U).
  cExportSupportedLink      = getDumpName("ryc_supported_link":U).
  cExportUITrigger          = getDumpName("ryc_ui_trigger":U).
  cExportValidUITrigger     = getDumpName("ryc_valid_ui_trigger":U).
  cExportWidgetType         = getDumpName("ryc_widget_type":U).
  cExportLookupField        = getDumpName("rym_lookup_field":U).

  cExportObjectType         = getDumpName("gsc_object_type":U).
  cExportProduct            = getDumpName("gsc_product":U).
  cExportProductModule      = getDumpName("gsc_product_module":U).
  
  cExportSmartObject        = getDumpName("ryc_smartobject":U).
  cExportObjectInstance     = getDumpName("ryc_object_instance":U).
  cExportPage               = getDumpName("ryc_page":U).
  cExportPageObject         = getDumpName("ryc_page_object":U).
  cExportSmartLink          = getDumpName("ryc_smartlink":U).
  cExportSmartObjectField   = getDumpName("ryc_smartobject_field":U).
  cExportCustomUiTrigger    = getDumpName("ryc_custom_ui_trigger":U).
  cExportAttributeValue     = getDumpName("ryc_attribute_value":U).
  cExportgscObject          = getDumpName("gsc_object":U).
  cExportDataVersion        = getDumpName("rym_data_version":U).
  cExportWizardMenc         = getDumpName("rym_wizard_menc":U).
  cExportWizardObjc         = getDumpName("rym_wizard_objc":U).
  cExportWizardFold         = getDumpName("rym_wizard_fold":U).
  cExportWizardFoldPage     = getDumpName("rym_wizard_fold_page":U).
  cExportWizardView         = getDumpName("rym_wizard_view":U).
  cExportWizardBrow         = getDumpName("rym_wizard_brow":U).
  
  /* Zap current dumps incase we re-run */
  OS-DELETE VALUE(cExportAction) NO-ERROR.
  OS-DELETE VALUE(cExportAttribute) NO-ERROR.
  OS-DELETE VALUE(cExportAttributeGroup) NO-ERROR.
  OS-DELETE VALUE(cExportAttributeType) NO-ERROR.
  OS-DELETE VALUE(cExportBand) NO-ERROR.
  OS-DELETE VALUE(cExportBandAction) NO-ERROR.
  OS-DELETE VALUE(cExportLayout) NO-ERROR.
  OS-DELETE VALUE(cExportSmartLinkType) NO-ERROR.
  OS-DELETE VALUE(cExportSubscribe) NO-ERROR.
  OS-DELETE VALUE(cExportSupportedLink) NO-ERROR.
  OS-DELETE VALUE(cExportUITrigger) NO-ERROR.
  OS-DELETE VALUE(cExportValidUITrigger) NO-ERROR.
  OS-DELETE VALUE(cExportWidgetType) NO-ERROR.
  OS-DELETE VALUE(cExportLookupField) NO-ERROR.

  OS-DELETE VALUE(cExportObjectType) NO-ERROR.
  OS-DELETE VALUE(cExportProduct) NO-ERROR.
  OS-DELETE VALUE(cExportProductModule) NO-ERROR.
  
  OS-DELETE VALUE(cExportSmartObject) NO-ERROR.
  OS-DELETE VALUE(cExportObjectInstance) NO-ERROR.
  OS-DELETE VALUE(cExportPage) NO-ERROR.
  OS-DELETE VALUE(cExportPageObject) NO-ERROR.
  OS-DELETE VALUE(cExportSmartLink) NO-ERROR.
  OS-DELETE VALUE(cExportSmartObjectField) NO-ERROR.
  OS-DELETE VALUE(cExportCustomUiTrigger) NO-ERROR.
  OS-DELETE VALUE(cExportAttributeValue) NO-ERROR.
  OS-DELETE VALUE(cExportgscObject) NO-ERROR.
  OS-DELETE VALUE(cExportDataVersion) NO-ERROR.
  OS-DELETE VALUE(cExportWizardMenc) NO-ERROR.
  OS-DELETE VALUE(cExportWizardObjc) NO-ERROR.
  OS-DELETE VALUE(cExportWizardFold) NO-ERROR.
  OS-DELETE VALUE(cExportWizardFoldPage) NO-ERROR.
  OS-DELETE VALUE(cExportWizardView) NO-ERROR.
  OS-DELETE VALUE(cExportWizardBrow) NO-ERROR.

  /* 1st always dump all static repository data in case changed */
  OUTPUT STREAM sOut1 TO VALUE(cExportAction).
  FOR EACH ryc_action NO-LOCK:
    EXPORT STREAM sOut1 ryc_action.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportAttribute).
  FOR EACH ryc_attribute NO-LOCK:
    EXPORT STREAM sOut1 ryc_attribute.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportAttributeGroup).
  FOR EACH ryc_attribute_group NO-LOCK:
    EXPORT STREAM sOut1 ryc_attribute_group.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportAttributeType).
  FOR EACH ryc_attribute_type NO-LOCK:
    EXPORT STREAM sOut1 ryc_attribute_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportBand).
  FOR EACH ryc_band NO-LOCK:
    EXPORT STREAM sOut1 ryc_band.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportBandAction).
  FOR EACH ryc_band_action NO-LOCK:
    EXPORT STREAM sOut1 ryc_band_action.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportLayout).
  FOR EACH ryc_layout NO-LOCK:
    EXPORT STREAM sOut1 ryc_layout.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportSmartLinkType).
  FOR EACH ryc_smartlink_type NO-LOCK:
    EXPORT STREAM sOut1 ryc_smartlink_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportSubscribe).
  FOR EACH ryc_subscribe NO-LOCK:
    EXPORT STREAM sOut1 ryc_subscribe.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportSupportedLink).
  FOR EACH ryc_supported_link NO-LOCK:
    EXPORT STREAM sOut1 ryc_supported_link.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportUITrigger).
  FOR EACH ryc_ui_trigger NO-LOCK:
    EXPORT STREAM sOut1 ryc_ui_trigger.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportValidUITrigger).
  FOR EACH ryc_valid_ui_trigger NO-LOCK:
    EXPORT STREAM sOut1 ryc_valid_ui_trigger.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportWidgetType).
  FOR EACH ryc_widget_type NO-LOCK:
    EXPORT STREAM sOut1 ryc_widget_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportLookupField).
  FOR EACH rym_lookup_field NO-LOCK:
    EXPORT STREAM sOut1 rym_lookup_field.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportObjectType).
  FOR EACH gsc_object_type NO-LOCK:
    EXPORT STREAM sOut1 gsc_object_type.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportProduct).
  FOR EACH gsc_product NO-LOCK:
    EXPORT STREAM sOut1 gsc_product.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  OUTPUT STREAM sOut1 TO VALUE(cExportProductModule).
  FOR EACH gsc_product_module NO-LOCK:
    EXPORT STREAM sOut1 gsc_product_module.
  END.
  OUTPUT STREAM sOut1 CLOSE.

  FIND FIRST rvm_workspace NO-LOCK
       WHERE rvm_workspace.workspace_code = pcWorkspace
       NO-ERROR.

  /* loop through objects to dump */  
  smartobject-loop:
  FOR EACH ryc_smartobject NO-LOCK:

/*     /* ignore WIP objects if full repository selected */                                   */
/*     IF toFull AND AVAILABLE rvm_workspace AND                                              */
/*        CAN-FIND(FIRST rvm_workspace_item                                                   */
/*                 WHERE rvm_workspace_item.workspace_obj = rvm_workspace.workspace_obj       */
/*                   AND rvm_workspace_item.configuration_type = "rycso":U                    */
/*                   AND rvm_workspace_item.scm_object_name = ryc_smartobject.OBJECT_filename */
/*                   AND rvm_workspace_item.task_version_number > 0) THEN                     */
/*       NEXT smartobject-loop.                                                               */
/*                                                                                            */
    
    /* get full name including .ado extension */
    IF NUM-ENTRIES(ryc_smartobject.object_filename,".":U) > 1
    AND LENGTH(ENTRY(NUM-ENTRIES(ryc_smartobject.object_filename,".":U),ryc_smartobject.object_filename,".":U)) <= 3
    THEN ASSIGN cFullObjectName = ryc_smartobject.object_filename.
    ELSE ASSIGN cFullObjectName = ryc_smartobject.object_filename + ".ado":U.

    /* If not doing full repository dump - check if in list of objects required */
    IF NOT toFull AND
       NOT CAN-FIND(FIRST ttDeploy
                    WHERE ttDeploy.cDeployObject = cFullObjectName) THEN NEXT smartobject-loop.

    
    /* we have a smartobject we want to deploy data for */
    edResults:INSERT-STRING("  Deploying repository data for object: " + cFullObjectName + CHR(10)) IN FRAME {&FRAME-NAME}.
    
    /* dump smartobject table data */
    OUTPUT STREAM sOut1 TO VALUE(cExportSmartObject) APPEND.
    EXPORT STREAM sOut1 ryc_smartobject.
    OUTPUT STREAM sOut1 CLOSE.

    /* dump related tables info */
    OUTPUT STREAM sOut1 TO VALUE(cExportObjectInstance) APPEND.
    FOR EACH ryc_object_instance NO-LOCK
        WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_object_instance.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportPage) APPEND.
    FOR EACH ryc_page NO-LOCK
        WHERE ryc_page.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_page.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportPageObject) APPEND.
    FOR EACH ryc_page_object NO-LOCK
        WHERE ryc_page_object.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_page_object.
    END.
    OUTPUT STREAM sOut1 CLOSE.
    
    OUTPUT STREAM sOut1 TO VALUE(cExportSmartLink) APPEND.
    FOR EACH ryc_smartlink NO-LOCK
        WHERE ryc_smartlink.container_smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_smartlink.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportSmartObjectField) APPEND.
    FOR EACH ryc_smartobject_field NO-LOCK
        WHERE ryc_smartobject_field.smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_smartobject_field.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportCustomUiTrigger) APPEND.
    FOR EACH ryc_custom_ui_trigger NO-LOCK
        WHERE ryc_custom_ui_trigger.smartobject_obj = ryc_smartobject.smartobject_obj:
      EXPORT STREAM sOut1 ryc_custom_ui_trigger.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportAttributeValue) APPEND.
    FOR EACH ryc_attribute_value NO-LOCK
        WHERE ryc_attribute_value.primary_smartobject_obj = ryc_smartobject.smartobject_obj:
        EXPORT STREAM sOut1 ryc_attribute_value.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportgscObject) APPEND.
    FOR EACH gsc_object NO-LOCK
        WHERE gsc_object.object_obj = ryc_smartobject.object_obj:
        EXPORT STREAM sOut1 gsc_object.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportDataVersion) APPEND.
    FOR EACH rym_data_version NO-LOCK
        WHERE rym_data_version.related_entity_mnemonic = "RYCSO":U
          AND rym_data_version.related_entity_key = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_data_version.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardMenc) APPEND.
    FOR EACH rym_wizard_menc NO-LOCK
        WHERE rym_wizard_menc.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_menc.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardObjc) APPEND.
    FOR EACH rym_wizard_objc NO-LOCK
        WHERE rym_wizard_objc.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_objc.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardFold) APPEND.
    OUTPUT STREAM sOut2 TO VALUE(cExportWizardFoldPage) APPEND.
    FOR EACH rym_wizard_fold NO-LOCK
        WHERE rym_wizard_fold.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_fold.

      FOR EACH rym_wizard_fold_page NO-LOCK
         WHERE rym_wizard_fold_page.wizard_fold_obj = rym_wizard_fold.wizard_fold_obj:
        EXPORT STREAM sOut2 rym_wizard_fold_page.
      END.
    END.
    OUTPUT STREAM sOut1 CLOSE.
    OUTPUT STREAM sOut2 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardView) APPEND.
    FOR EACH rym_wizard_view NO-LOCK
        WHERE rym_wizard_view.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_view.
    END.
    OUTPUT STREAM sOut1 CLOSE.

    OUTPUT STREAM sOut1 TO VALUE(cExportWizardBrow) APPEND.
    FOR EACH rym_wizard_brow NO-LOCK
        WHERE rym_wizard_brow.OBJECT_name = ryc_smartobject.OBJECT_filename:
        EXPORT STREAM sOut1 rym_wizard_brow.
    END.
    OUTPUT STREAM sOut1 CLOSE.
    
  END. /* smartobject loop */
  
  edResults:INSERT-STRING("  Repository data deployed." + CHR(10)) IN FRAME {&FRAME-NAME}.

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
    {&WINDOW-NAME}:TITLE = "Dynamics Repository Deployment":U
    .

  ASSIGN
    ToRepositoryData = plDeployRepository
    ToVersionData = plDeployVersion
    .
  DISPLAY ToRepositoryData ToVersionData.

  IF plDeployRepository THEN
  DO:
    ENABLE toFull.
    ASSIGN
      toFull = NO.
    DISPLAY toFull.  
  END.
  ELSE
  DO:
    DISABLE toFull.
    ASSIGN
      toFull = NO.
    DISPLAY toFull.  
  END.

  APPLY "entry":U TO buOk.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDumpName C-Win 
FUNCTION getDumpName RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Return dump name for passed in table (plus .d extension and directory).
    Notes:  
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer1                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDumpName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSchema                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk                     AS LOGICAL    NO-UNDO.
  
  /* Create buffer for passed in table */
  CREATE BUFFER hBuffer1 FOR TABLE pcTable NO-ERROR.
  
  /* get dump name for table from metaschema */
  ASSIGN cSchema = hBuffer1:DBNAME + "._file":U.
  
  CREATE BUFFER hBuffer FOR TABLE cSchema NO-ERROR.
  CREATE QUERY hQuery NO-ERROR.
  lOk = hQuery:SET-BUFFERS(hBuffer).
  lOk = hQuery:QUERY-PREPARE("FOR EACH ":U + cSchema + " NO-LOCK WHERE ":U + cSchema + "._file-name BEGINS '":U + pcTable + "'":U).
  hQuery:QUERY-OPEN() NO-ERROR.
  hQuery:GET-FIRST() NO-ERROR.
  
  IF VALID-HANDLE(hBuffer) AND hBuffer:AVAILABLE THEN
  ASSIGN
    hField  = hBuffer:BUFFER-FIELD("_dump-name":U)
    cDumpName = hField:BUFFER-VALUE
    .
  hQuery:QUERY-CLOSE() NO-ERROR.
  
  IF cDumpName = "":U THEN ASSIGN cDumpName = pcTable.

  DELETE OBJECT hBuffer1 NO-ERROR.
  DELETE OBJECT hQuery NO-ERROR.
  DELETE OBJECT hBuffer NO-ERROR.
  ASSIGN
    hQuery = ?
    hBuffer = ?
    hBuffer1 = ?
    .
  
  RETURN pcDirectory + cDumpName + ".d":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

