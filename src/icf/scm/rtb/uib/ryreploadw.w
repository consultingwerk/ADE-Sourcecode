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

  File: ryreploadw.w

  Description: Repository Data Load Window

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

DEFINE VARIABLE gcDirectory          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcDeployDirectory    AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFindValue buFindPath edResults buOK ~
buCancel 
&Scoped-Define DISPLAYED-OBJECTS fiFindValue edResults 

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

DEFINE BUTTON buFindPath 
     LABEL "Find Path..." 
     SIZE 14.4 BY 1.14 TOOLTIP "Find root directory".

DEFINE BUTTON buOK AUTO-GO DEFAULT 
     LABEL "&Import the Repository Data" 
     SIZE 85 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 100 BY 9.05 NO-UNDO.

DEFINE VARIABLE fiFindValue AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 85 BY 1 TOOLTIP "Deployment root directory - full path" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiFindValue AT ROW 2.05 COL 4.6 NO-LABEL
     buFindPath AT ROW 2.05 COL 90.6
     edResults AT ROW 3.57 COL 4.6 NO-LABEL
     buOK AT ROW 13 COL 4.6
     buCancel AT ROW 13 COL 90.6
     "Select Root Directory Containing the Repository Data Dump Files to Load" VIEW-AS TEXT
          SIZE 85 BY .81 AT ROW 1.1 COL 4.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105.2 BY 13.24
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
         HEIGHT             = 13.24
         WIDTH              = 105.2
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ICF Deployment Load */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ICF Deployment Load */
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
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Import the Repository Data */
DO:

  DEFINE VARIABLE lValidDir             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFileName             AS CHARACTER  NO-UNDO.

  ASSIGN
      fiFindValue
      fiFindValue      = REPLACE(fiFindValue,"~\":U,"~/":U)
      gcDirectory   = TRIM(fiFindValue,"~/":U)
      gcDeployDirectory = gcDirectory + "~/":U + "icf_dbdata":U
      lValidDir = NO
      .

  ASSIGN FILE-INFO:FILE-NAME = gcDirectory.
  IF gcDirectory = "":U OR NOT FILE-INFO:FILE-TYPE MATCHES "*d*":U THEN
  DO:
    MESSAGE
        SKIP " No Valid Directory containing the Repository Data was entered."
        SKIP " Please enter a valid directory before proceeding... "
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.

  ASSIGN FILE-INFO:FILE-NAME = gcDeployDirectory.
  IF FILE-INFO:FILE-TYPE MATCHES "*d*":U THEN ASSIGN lValidDir = YES.

  IF NOT lValidDir THEN
  DO:
    MESSAGE
        SKIP " The directory specified for the repository data does not"
        SKIP " contain the subdirectory /icf_dbdata" 
        SKIP
        SKIP " Please enter a valid directory before proceeding... "
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN NO-APPLY.
  END.


  MESSAGE "Do you wish to proceed with the loading of the repository data using the" SKIP
          "dump files in the directory: " + gcDeployDirectory SKIP(1)
          "Note that this program will ONLY load repository data. Any physical program" SKIP
          "associated with the dumped repository data should have been manually copied" SKIP
          "into the correct directory before running this utility." SKIP(1)
          "Also note that the the version data associated with this version, plus any" SKIP
          "Roundtable version information will NOT be loaded. This means that Roundtable" SKIP
          "will still show the old version number of the object and assigns of this object" SKIP
          "version to other workspaces will not be possible as the version data is missing." SKIP
          "To get the repository data into other workspaces, the programs will need to be" SKIP
          "manually copied and this utility ran again in the appropriate workspace" SKIP(1)
          "This load utility should only be used as an emergency release procedure prior" SKIP
          "to a correct deployment package being sent - which will then fix the version data" SKIP
          "and Roundtable repository." SKIP(1)
          "Proceed with the load?" SKIP(1)
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE lChoice AS LOGICAL.
  IF lchoice THEN
    RUN importProcess.

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
  DISPLAY fiFindValue edResults 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE fiFindValue buFindPath edResults buOK buCancel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importProcess C-Win 
PROCEDURE importProcess :
/*------------------------------------------------------------------------------
  Purpose:     Load ICF Deployment Package
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
  PROPATH = gcDirectory + ",":U + PROPATH.

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
    IF edResults:INSERT-STRING("*** Start loading of ICF Repository Data ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

    /* Import Repository data */
    RUN importRepository (OUTPUT cErrorValue).
    IF cErrorValue <> "":U
    THEN
    DO:
        IF edResults:INSERT-STRING("~n" + "*** ERROR with loading of repository data : ":U + cErrorValue + " ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
    END.

    /* Finish message */
    IF edResults:INSERT-STRING("~n" + "*** Finished load of ICF Repository Data ... (":U + STRING(TODAY) + " - " + STRING(TIME,"HH:MM:SS":U) + ")":U + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mainSetup C-Win 
PROCEDURE mainSetup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            {&WINDOW-NAME}:TITLE = "Dynamics Repository Data Load":U
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
            lhFolder = lhServer:BrowseForFolder(CURRENT-WINDOW:HWND,"Select Dump Directory":U,0).

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

