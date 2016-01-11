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

  File: afdbdeplsw.w

  Description: Astra Deployment packaging start window

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

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

{adecomm/appsrvtt.i "NEW GLOBAL"}

{af/sup2/afglobals.i NEW GLOBAL}

DEFINE TEMP-TABLE ttObject      NO-UNDO
            FIELD tfOfilename   AS CHARACTER
            FIELD tfOdirectory  AS CHARACTER
            FIELD tfOupdate     AS CHARACTER
            FIELD tfOstatus     AS CHARACTER
            FIELD tfOerror      AS CHARACTER
            INDEX tiOmain       IS PRIMARY UNIQUE
                  tfOfilename
                  tfOdirectory.

DEFINE STREAM sMain.

DEFINE VARIABLE iObjProcess AS INTEGER      NO-UNDO.
DEFINE VARIABLE iObjCopied  AS INTEGER      NO-UNDO.
DEFINE VARIABLE iObjErrors  AS INTEGER      NO-UNDO.

DEFINE VARIABLE iModRoot    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iModApp     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iModAdm     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iModTrg     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iModWeb     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iGrpApp     AS INTEGER      NO-UNDO.
DEFINE VARIABLE iGrpSdo     AS INTEGER      NO-UNDO.

DEFINE VARIABLE iEModRoot   AS INTEGER      NO-UNDO.
DEFINE VARIABLE iEModApp    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iEModAdm    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iEModTrg    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iEModWeb    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iEGrpApp    AS INTEGER      NO-UNDO.
DEFINE VARIABLE iEGrpSdo    AS INTEGER      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coWorkspace toMethod coOSDrive cOSDriveMap ~
cCopyFrom cCopyTo toModRoot toGrpApp toModApp toModAdm toGrpSdo toModTrg ~
toCompile toCheckOas edResults toEdCopy buOK buCancel toEdCount RECT-1 ~
RECT-2 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS coWorkspace toMethod coOSDrive cOSDriveMap ~
cCopyFrom cCopyTo toModRoot toGrpApp toModApp toModAdm toGrpSdo toModTrg ~
toModWeb toCompile toCheckOas edResults toEdCopy toEdCount 

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

DEFINE BUTTON buOK DEFAULT 
     LABEL "&Update R-Code to Appserver" 
     SIZE 62.4 BY 1.14 TOOLTIP "Code r-code for selection"
     BGCOLOR 8 .

DEFINE VARIABLE coOSDrive AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 12 BY 1 TOOLTIP "Select Workspace from which to deploy"
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE coWorkspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Select Workspace" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 23.2 BY 1 TOOLTIP "Select Workspace from which to deploy"
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 122.4 BY 10 NO-UNDO.

DEFINE VARIABLE cCopyFrom AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.6 BY 1 NO-UNDO.

DEFINE VARIABLE cCopyTo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.2 BY 1 NO-UNDO.

DEFINE VARIABLE cOSDriveMap AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60.2 BY 1 NO-UNDO.

DEFINE VARIABLE toMethod AS CHARACTER INITIAL "MAP" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "via Appserver Hooks", "API",
"via Physical Drive map on i.e. \\Mojo\appserver", "MAP",
"via Network Share to i.e. \\Mojo\appserver", "OAS"
     SIZE 58.4 BY 3.1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60.4 BY 2.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60.4 BY 2.57.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60.4 BY 2.95.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60.4 BY 3.05.

DEFINE VARIABLE toCheckOas AS LOGICAL INITIAL no 
     LABEL "Check remote R-code Objects not updated" 
     VIEW-AS TOGGLE-BOX
     SIZE 52.4 BY .81 TOOLTIP "Select this option to check remote r-code objects not being updated" NO-UNDO.

DEFINE VARIABLE toCompile AS LOGICAL INITIAL no 
     LABEL "Compile objects before updating" 
     VIEW-AS TOGGLE-BOX
     SIZE 52.4 BY .81 TOOLTIP "Select this option to compile objects before updating" NO-UNDO.

DEFINE VARIABLE toEdCopy AS LOGICAL INITIAL yes 
     LABEL "Display all update procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 TOOLTIP "Select this option to display all update procedures" NO-UNDO.

DEFINE VARIABLE toEdCount AS LOGICAL INITIAL yes 
     LABEL "Display count of objects updated" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .81 TOOLTIP "Select this option to display count of objects updated" NO-UNDO.

DEFINE VARIABLE toGrpApp AS LOGICAL INITIAL yes 
     LABEL "Appserver : AppServer required procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.

DEFINE VARIABLE toGrpSdo AS LOGICAL INITIAL no 
     LABEL "SDO : Smart Data Objects" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.

DEFINE VARIABLE toModAdm AS LOGICAL INITIAL no 
     LABEL "*-adm* : ADM2 custom modifications" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.

DEFINE VARIABLE toModApp AS LOGICAL INITIAL yes 
     LABEL "*-app : AppServer required procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.

DEFINE VARIABLE toModRoot AS LOGICAL INITIAL yes 
     LABEL "*-aaa : AppServer Broker Code" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.

DEFINE VARIABLE toModTrg AS LOGICAL INITIAL no 
     LABEL "*-trg : Database Triggers" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.

DEFINE VARIABLE toModWeb AS LOGICAL INITIAL no 
     LABEL "*-w* : WebServer objects (web)" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .81 TOOLTIP "Select this option to copy all object in the selected module" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coWorkspace AT ROW 1.52 COL 5.4
     toMethod AT ROW 2.71 COL 5 NO-LABEL
     coOSDrive AT ROW 3.67 COL 67.2 NO-LABEL
     cOSDriveMap AT ROW 4.91 COL 65.2 COLON-ALIGNED NO-LABEL
     cCopyFrom AT ROW 6.24 COL 10.2 COLON-ALIGNED NO-LABEL
     cCopyTo AT ROW 6.24 COL 65.2 COLON-ALIGNED NO-LABEL
     toModRoot AT ROW 8.33 COL 9.4
     toGrpApp AT ROW 8.48 COL 73.2
     toModApp AT ROW 9.29 COL 9.4
     toModAdm AT ROW 10.48 COL 11.4
     toGrpSdo AT ROW 10.71 COL 75.2
     toModTrg AT ROW 11.43 COL 11.4
     toModWeb AT ROW 12.38 COL 11.4
     toCompile AT ROW 13.67 COL 5
     toCheckOas AT ROW 13.67 COL 67.4
     edResults AT ROW 14.81 COL 5 NO-LABEL
     toEdCopy AT ROW 25.05 COL 5
     buOK AT ROW 25.38 COL 48.6
     buCancel AT ROW 25.38 COL 112.6
     toEdCount AT ROW 25.91 COL 5
     RECT-1 AT ROW 7.76 COL 67
     RECT-2 AT ROW 7.76 COL 3
     RECT-4 AT ROW 10.33 COL 67
     RECT-5 AT ROW 10.24 COL 3
     "to :" VIEW-AS TEXT
          SIZE 3 BY .62 AT ROW 6.43 COL 64
     "Update :" VIEW-AS TEXT
          SIZE 8.4 BY .62 AT ROW 6.33 COL 3.6
     "MODULE(s) :" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 7.48 COL 7.2
     "GROUP(s) :" VIEW-AS TEXT
          SIZE 11.8 BY .62 AT ROW 7.48 COL 71.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 165.4 BY 29.1
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
         TITLE              = "OpenAppServer Update Copy Procedure"
         HEIGHT             = 26.29
         WIDTH              = 128.2
         MAX-HEIGHT         = 47.86
         MAX-WIDTH          = 256
         VIRTUAL-HEIGHT     = 47.86
         VIRTUAL-WIDTH      = 256
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
/* SETTINGS FOR COMBO-BOX coOSDrive IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX coWorkspace IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       edResults:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       edResults:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR TOGGLE-BOX toModWeb IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* OpenAppServer Update Copy Procedure */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* OpenAppServer Update Copy Procedure */
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
ON CHOOSE OF buOK IN FRAME DEFAULT-FRAME /* Update R-Code to Appserver */
DO:

    ASSIGN
        cCopyFrom
        cCopyTo
        toCompile
        toCheckOas
        toModRoot
        toModApp
        toModAdm
        toModTrg
        toModWeb
        toGrpApp
        toGrpSdo
        toEdCopy
        toEdCount
        .

    MESSAGE
        SKIP "Do you want to process all the r-code according to the options selected"
        SKIP " from " cCopyFrom " to " cCopyTo
        SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lChoice AS LOGICAL.
    IF lChoice = YES
    THEN DO:

        RUN startProcess.

        ASSIGN
            buCancel:LABEL IN FRAME {&FRAME-NAME} = "&Close":U.

    END.
    ELSE
        RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coOSDrive
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coOSDrive C-Win
ON VALUE-CHANGED OF coOSDrive IN FRAME DEFAULT-FRAME
DO:

    RUN updateScreen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coWorkspace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coWorkspace C-Win
ON VALUE-CHANGED OF coWorkspace IN FRAME DEFAULT-FRAME /* Select Workspace */
DO:

    RUN updateScreen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toCompile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toCompile C-Win
ON VALUE-CHANGED OF toCompile IN FRAME DEFAULT-FRAME /* Compile objects before updating */
DO:

    ASSIGN
        toCompile.

    IF toCompile
    THEN DO:
        MESSAGE
            "Are the correct workspace selected and/or correct databases connected to valid a compilation of the selected workspace?"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE lCompCont AS LOGICAL.
        IF NOT lCompCont
        THEN DO:
            ASSIGN
                toCompile = NO
                toCompile:SCREEN-VALUE = STRING(toCompile)
                .
            APPLY "VALUE-CHANGED" TO toCompile.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toMethod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toMethod C-Win
ON VALUE-CHANGED OF toMethod IN FRAME DEFAULT-FRAME
DO:

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            toMethod
            toCheckOas.

        IF toMethod = "API":U
        THEN DO:
            ASSIGN
                toCheckOas = NO.
            DISABLE
                coOSDrive
                cOSDriveMap
                toCheckOas.
            IF VALID-HANDLE(gshAstraAppserver)
            AND CAN-QUERY(gshAstraAppserver, "connected":U)
            AND gshAstraAppserver:CONNECTED()
            THEN DO:
                IF coWorkspace <> Grtb-wspace-id
                THEN DO:
                    MESSAGE  "The workspace selected is different from the Roundtable selected workspace."
                        SKIP "The connected appserver broker points to a different workspace broker."
                        SKIP "This could cause errors in the update process and corrupt the appserver r-code"
                        SKIP "Do you want to continue with this option?"
                        VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE lUseApi AS LOGICAL.
                    IF NOT lUseApi
                    THEN
                        ASSIGN
                            ERROR-STATUS:ERROR = YES.
                END.
            END.
            ELSE DO:
                MESSAGE  "This Option is not currently available."
                    SKIP "No valid appserver connection could be established."
                    VIEW-AS ALERT-BOX INFORMATION.
                ASSIGN
                    ERROR-STATUS:ERROR = YES.
            END.
        END.

        IF toMethod = "OAS":U
        THEN DO:
            DISABLE
                coOSDrive.
            ENABLE
                cOSDriveMap
                toCheckOas.
            /* DISABLE OPTION - TEMP CODE */
            MESSAGE  "This Option is not currently available."
                SKIP "No valid connection could be established to copy to the share \\Mojo\appserver."
                SKIP " *** ERROR ***   Unmapped error (Progress default) (Error 999)"
                VIEW-AS ALERT-BOX INFORMATION.
            ASSIGN
                ERROR-STATUS:ERROR = YES.
            /* DISABLE OPTION - TEMP CODE */
        END.

        IF ERROR-STATUS:ERROR
        THEN DO:
            ASSIGN
                toCheckOas          = NO
                toMethod            = "MAP":U
                ERROR-STATUS:ERROR  = NO.
        END.

        ASSIGN
            toCheckOas:SCREEN-VALUE = STRING(toCheckOas)
            toMethod:SCREEN-VALUE   = toMethod.

        IF toMethod = "MAP":U
        THEN DO:
            ENABLE
                coOSDrive
                toCheckOas.
            DISABLE
                cOSDriveMap.
        END.

        RUN updateScreen.

    END.

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

    APPLY "VALUE-CHANGED" TO toMethod.
    APPLY "VALUE-CHANGED" TO coWorkspace.

    IF NOT THIS-PROCEDURE:PERSISTENT
    THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCoOSDrive C-Win 
PROCEDURE buildCoOSDrive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cBatchFile      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOutputFile     AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE iLoop           AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cOSDrive        AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOSDriveName    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOSDriveInfo    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOSDriveData    AS CHARACTER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            coOSDrive:LIST-ITEMS   = "":U
            coOSDrive:LIST-ITEMS   = OS-DRIVES
            coOSDrive:PRIVATE-DATA = "":U
            .

        ASSIGN
            cBatchFile  = SESSION:TEMP-DIRECTORY + "tmp_drive.bat":U
            cOutputFile = SESSION:TEMP-DIRECTORY + "tmp_drive.log":U
            .

        OUTPUT STREAM sMain TO VALUE(cBatchFile).
        PUT STREAM sMain UNFORMATTED
            "net use > ":U cOutputFile
            SKIP.
        OUTPUT STREAM sMain CLOSE.

        /* Execute batch file */
        OS-COMMAND SILENT VALUE(cBatchFile).

        /* Check result */
        IF SEARCH(cOutputFile) <> ?
        THEN DO:
            INPUT STREAM sMain FROM VALUE(cOutputFile) NO-ECHO.
            REPEAT:
                IMPORT STREAM sMain
                    ^
                    cOSDriveName
                    cOSDriveInfo
                    .
                 ASSIGN
                    iLoop =  LOOKUP(cOSDriveName,coOSDrive:LIST-ITEMS)
                    .
                 IF iLoop > 0
                 THEN DO:
                    ASSIGN
                        cOSDriveData = coOSDrive:PRIVATE-DATA
                        .
                    IF cOSDriveData = ?
                    OR cOSDriveData = "?":U
                    THEN
                        ASSIGN
                            cOSDriveData = "":U
                            .
                    IF NUM-ENTRIES(cOSDriveData) < iLoop
                    OR NUM-ENTRIES(cOSDriveData) < iLoop - 1
                    THEN
                    REPEAT:
                        IF NUM-ENTRIES(cOSDriveData) = iLoop
                        THEN LEAVE.
                        ELSE
                            ASSIGN
                                cOSDriveData = cOSDriveData + ",":U
                                .
                    END.
                    ASSIGN
                        ENTRY(iLoop, cOSDriveData ) = cOSDriveInfo
                        coOSDrive:PRIVATE-DATA      = cOSDriveData
                        .
                END.
            END.
            INPUT STREAM sMain CLOSE.
        END.

        /* Delete temp files */
        OS-DELETE VALUE(cBatchFile).
        OS-DELETE VALUE(cOutputFile).

        ASSIGN
            cOSDriveData = coOSDrive:PRIVATE-DATA
            .
        DO iLoop = 1 TO NUM-ENTRIES(cOSDriveData):
            IF ENTRY(iLoop,cOSDriveData) = "":U
            THEN
                ASSIGN
                    ENTRY(iLoop, cOSDriveData ) = "*LOCAL*":U
                    coOSDrive:PRIVATE-DATA      = cOSDriveData
                    .
        END.
        ASSIGN
            coOSDrive:PRIVATE-DATA = cOSDriveData
            .
        ASSIGN
            iLoop =  LOOKUP("~\~\Mojo\appserver":U,coOSDrive:PRIVATE-DATA)
            .
        IF iLoop > 0
        THEN
            ASSIGN
                coOSDrive:SCREEN-VALUE = ENTRY(iLoop,coOSDrive:LIST-ITEMS)
                NO-ERROR.
        ELSE
            ASSIGN
                coOSDrive:SCREEN-VALUE = "O:":U
                NO-ERROR.

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
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN 
            coWorkspace:LIST-ITEMS = "":U
            .

        FOR EACH rtb_wspace NO-LOCK
              BY rtb_wspace.wspace-id
            :

            coWorkspace:ADD-LAST(LC(rtb_wspace.wspace-id)).

        END.

        IF  coWorkspace:LIST-ITEMS <> "":U
        AND coWorkspace:LIST-ITEMS <> ? 
        THEN
            ASSIGN
                coWorkspace:SCREEN-VALUE = ENTRY(1,coWorkspace:LIST-ITEMS)
                .

        /* Default to current workdpace if any */
        IF  Grtb-wspace-id <> "":U 
        AND Grtb-wspace-id <> ?
        THEN
            ASSIGN
                coWorkspace:SCREEN-VALUE = Grtb-wspace-id
                NO-ERROR.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildOasObjects C-Win 
PROCEDURE buildOasObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cBatchFile          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cOutputFile         AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cFileName           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iCount              AS INTEGER      NO-UNDO.

    DEFINE VARIABLE cObjectName         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDirectory          AS CHARACTER    NO-UNDO.

    ASSIGN
        cBatchFile  = SESSION:TEMP-DIRECTORY + "tmp_dir.bat":U
        cOutputFile = SESSION:TEMP-DIRECTORY + "tmp_dir.log":U
        .

    OUTPUT STREAM sMain TO VALUE(cBatchFile).

    PUT STREAM sMain UNFORMATTED
        "dir /b/l/on/s ":U
        TRIM( REPLACE(cCopyTo,"~/":U,"~\":U) ,"~\":U )
        "~\*.r > ":U
        cOutputFile
        SKIP.

    OUTPUT STREAM sMain CLOSE.

    /* Execute batch file */
    OS-COMMAND SILENT VALUE(cBatchFile).

    /* Check result */
    IF SEARCH(cOutputFile) <> ?
    THEN DO:

        INPUT STREAM sMain FROM VALUE(cOutputFile) NO-ECHO.
        REPEAT:

            IMPORT STREAM sMain UNFORMATTED cFileName.

            ASSIGN
                cFileName   = LC(TRIM(cFileName))
                cFileName   = REPLACE(cFileName,"~\":U,"~/":U)
                cFileName   = REPLACE(cFileName,cCopyTo,"":U)
                cFileName   = TRIM(cFileName,"~/":U)
                cObjectName = ENTRY(NUM-ENTRIES(cFileName,"~/":U),cFileName,"~/":U)
                cDirectory  = REPLACE(cFileName,cObjectName,"":U)
                cDirectory  = TRIM(cDirectory,"~/":U)
                .

            FIND FIRST ttObject NO-LOCK
                WHERE ttObject.tfOfilename = cFileName
                NO-ERROR.
            IF NOT AVAILABLE ttObject
            THEN DO:
                CREATE ttObject.
                ASSIGN
                    ttObject.tfOfilename  = cObjectName
                    ttObject.tfOdirectory = cDirectory
                    ttObject.tfOupdate    = "REMOTE":U
                    ttObject.tfOstatus    = "EXIST":U
                    ttObject.tfOerror     = "":U
                    .
            END.
        END.
        INPUT STREAM sMain CLOSE.
    END.

    /* Delete temp files */
    OS-DELETE VALUE(cBatchFile).
    OS-DELETE VALUE(cOutputFile).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkOasObjects C-Win 
PROCEDURE checkOasObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cObjectName AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cPModule    AS CHARACTER    NO-UNDO.

    FOR EACH ttObject NO-LOCK
        WHERE ttObject.tfOstatus = "ERROR":U
        :
        IF edResults:INSERT-STRING("* " + ttObject.tfOdirectory + "/" + ttObject.tfOfilename + ttObject.tfOerror + "~n" ) IN FRAME {&FRAME-NAME} THEN .
    END.

    Obj_Blk:
    FOR EACH ttObject NO-LOCK
        WHERE ttObject.tfOupdate = "REMOTE":U
        AND   ttObject.tfOstatus = "EXIST":U
        :

        FIND FIRST rtb_object NO-LOCK
            WHERE rtb_object.wspace-id = coWorkspace
            AND   rtb_object.obj-type  = "PCODE":U
            AND   rtb_object.object BEGINS ENTRY(1,ttObject.tfOfilename,".":U)
            AND   LOOKUP( ENTRY(2,rtb_object.object,".":U) , "p,w":U ) > 0
            NO-ERROR.
        IF AVAILABLE rtb_object
        THEN DO:

            IF ( NOT toModRoot   AND INDEX(rtb_object.pmod,"-aaa":U)           <> 0 )
            OR ( NOT toModApp    AND INDEX(rtb_object.pmod,"-app":U)           <> 0 )
            OR ( NOT toModTrg    AND INDEX(rtb_object.pmod,"-trg":U)           <> 0 )
            OR ( NOT toModWeb    AND INDEX(rtb_object.pmod,"-w":U)             <> 0 )
            OR ( NOT toModAdm    AND INDEX(rtb_object.pmod,"-adm":U)           <> 0 )
            OR ( NOT toGrpApp    AND INDEX(rtb_object.obj-group,"APPSERVER":U) <> 0 )
            OR ( NOT toGrpSdo    AND INDEX(rtb_object.obj-group,"SDO":U)       <> 0 )
            THEN NEXT Obj_Blk.

            IF  INDEX(rtb_object.pmod,"-aaa":U)           = 0
            AND INDEX(rtb_object.pmod,"-app":U)           = 0
            AND INDEX(rtb_object.pmod,"-adm":U)           = 0
            AND INDEX(rtb_object.pmod,"-trg":U)           = 0
            AND INDEX(rtb_object.pmod,"-w":U)             = 0
            AND INDEX(rtb_object.obj-group,"APPSERVER":U) = 0
            AND INDEX(rtb_object.obj-group,"SDO":U)       = 0
            THEN DO:
                IF edResults:INSERT-STRING("* " + ttObject.tfOdirectory + "/" + ttObject.tfOfilename + "   | R-code NOT updated: Criteria Mismatched" + "~n" ) IN FRAME {&FRAME-NAME} THEN .
            END.

            FIND FIRST rtb_moddef NO-LOCK
                WHERE rtb_moddef.module = rtb_object.pmod
                NO-ERROR.
            ASSIGN
                cPModule = IF AVAILABLE rtb_moddef THEN rtb_moddef.directory ELSE rtb_object.pmod.
                cPModule = REPLACE(cPModule,"-":U,"~/":U).

            IF cPModule <> ttObject.tfOdirectory
            THEN DO:
                IF edResults:INSERT-STRING("* " + ttObject.tfOdirectory + "/" + ttObject.tfOfilename + "   | R-code NOT updated: Directory Mismatched" + "~n" ) IN FRAME {&FRAME-NAME} THEN .
            END.

            IF SEARCH(TRIM(cCopyFrom,"/":U)  + "/":U + TRIM(ttObject.tfOdirectory,"/":U) + "/ " + TRIM(ttObject.tfOfilename,"/":U)) <> ?
            THEN DO:
                IF edResults:INSERT-STRING("* " + ttObject.tfOdirectory + "/" + ttObject.tfOfilename + "   | R-code NOT updated: R-Code not found on source" + "~n" ) IN FRAME {&FRAME-NAME} THEN .
            END.

        END.
        ELSE DO:
            IF edResults:INSERT-STRING("* " + ttObject.tfOdirectory + "/" + ttObject.tfOfilename + "   | R-code NOT updated: RTB Object not found" + "~n" ) IN FRAME {&FRAME-NAME} THEN .
        END.

    END.

END PROCEDURE.
/*
            IF edResults:INSERT-STRING("* " + ttObject.tfOdirectory + "/" + ttObject.tfOfilename + "~n" ) IN FRAME {&FRAME-NAME} THEN .
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRCode C-Win 
PROCEDURE copyRCode :
/*------------------------------------------------------------------------------
  Purpose:     This function 
  Parameters:  <none>
  Notes:       This procedure finds the actual object for compilation
               and afterward continue to copy depending on the method option selected.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cObjectName     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjectNameR    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cPModule        AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cDirSource      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDirTarget      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjSource      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjTarget      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjSourceR     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cObjTargetR     AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE cErrMessage     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iErrMessage     AS INTEGER      NO-UNDO.

    DEFINE VARIABLE iLoop           AS INTEGER      NO-UNDO.

    ASSIGN
        iObjProcess = 0     iObjCopied  = 0     iObjErrors  = 0
        iModRoot    = 0     iModApp     = 0     iModAdm     = 0
        iModTrg     = 0     iModWeb     = 0
        iGrpApp     = 0     iGrpSdo     = 0
        iEModRoot   = 0     iEModApp    = 0     iEModAdm    = 0
        iEModTrg    = 0     iEModWeb    = 0
        iEGrpApp    = 0     iEGrpSdo    = 0
        .

    IF edResults:INSERT-STRING("       Copy from " + cCopyFrom + " to " + cCopyTo + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

    FOR EACH rtb_object NO-LOCK
        WHERE rtb_object.wspace-id = coWorkspace
        AND   rtb_object.obj-type  = "PCODE":U
        :

        IF  INDEX(rtb_object.object,".p":U) = 0
        AND INDEX(rtb_object.object,".w":U) = 0
        THEN NEXT.

        /* Count Section */
        ASSIGN
            iObjProcess = iObjProcess + 1.
        /* Count Section */

        FIND FIRST rtb_moddef NO-LOCK
            WHERE rtb_moddef.module = rtb_object.pmod
            NO-ERROR.
        ASSIGN
            cPModule        = IF AVAILABLE rtb_moddef THEN rtb_moddef.directory ELSE rtb_object.pmod
            cPModule        = REPLACE(cPModule,"-":U,"~/":U)
            cObjectName     = rtb_object.object
            cObjectNameR    = cObjectName
            cObjectNameR    = REPLACE(cObjectNameR,".p":U,".r":U)
            cObjectNameR    = REPLACE(cObjectNameR,".w":U,".r":U)
            .

        IF ( toModRoot   AND  INDEX(rtb_object.pmod     ,"-aaa":U)      <> 0 )
        OR ( toModApp    AND  INDEX(rtb_object.pmod     ,"-app":U)      <> 0 )
        OR ( toModAdm    AND  INDEX(rtb_object.pmod     ,"-adm":U)      <> 0 )
        OR ( toModTrg    AND  INDEX(rtb_object.pmod     ,"-trg":U)      <> 0 )
        OR ( toModWeb    AND  INDEX(rtb_object.pmod     ,"-w":U)        <> 0 )
        OR ( toGrpApp    AND  INDEX(rtb_object.obj-group,"APPSERVER":U) <> 0 )
        OR ( toGrpSdo    AND  INDEX(rtb_object.obj-group,"SDO":U)       <> 0 )
        THEN DO:

            /* Count Section */
            ASSIGN
                iObjCopied = iObjCopied + 1.
            IF INDEX(rtb_object.pmod,"-aaa":U)           <> 0 THEN ASSIGN iModRoot  = iModRoot  + 1.
            IF INDEX(rtb_object.pmod,"-app":U)           <> 0 THEN ASSIGN iModApp   = iModApp   + 1.
            IF INDEX(rtb_object.pmod,"-adm":U)           <> 0 THEN ASSIGN iModAdm   = iModAdm   + 1.
            IF INDEX(rtb_object.pmod,"-trg":U)           <> 0 THEN ASSIGN iModTrg   = iModTrg   + 1.
            IF INDEX(rtb_object.pmod,"-w":U)             <> 0 THEN ASSIGN iModWeb   = iModWeb   + 1.
            IF INDEX(rtb_object.obj-group,"APPSERVER":U) <> 0 THEN ASSIGN iGrpApp   = iGrpApp   + 1.
            IF INDEX(rtb_object.obj-group,"SDO":U)       <> 0 THEN ASSIGN iGrpSdo   = iGrpSdo   + 1.
            /* Count Section */

            ASSIGN
                cDirSource      = cCopyFrom  + ( IF cPModule <> "":U THEN "~/":U + cPModule ELSE "":U )
                cDirTarget      = cCopyTo    + ( IF cPModule <> "":U THEN "~/":U + cPModule ELSE "":U )
                /* The actual object name, source and target directory */
                cObjSource      = cDirSource + "~/":U + cObjectName
                cObjTarget      = cDirTarget + "~/":U + cObjectName
                /* The RCode object name, source and target directory */
                cObjSourceR     = cDirSource + "~/":U + cObjectNameR
                cObjTargetR     = cDirTarget + "~/":U + cObjectNameR
                .

            FIND FIRST ttObject EXCLUSIVE-LOCK
                WHERE ttObject.tfOfilename  = cObjectNameR
                AND   ttObject.tfOdirectory = ( IF cPModule <> "":U THEN cPModule ELSE "":U )
                NO-ERROR.
            IF NOT AVAILABLE ttObject
            THEN DO:
                CREATE ttObject.
                ASSIGN
                    ttObject.tfOfilename  = cObjectNameR
                    ttObject.tfOdirectory = ( IF cPModule <> "":U THEN cPModule ELSE "":U )
                    ttObject.tfOupdate    = "CLIENT":U
                    ttObject.tfOstatus    = "EXIST":U.
            END.
            ELSE
                ASSIGN
                    ttObject.tfOupdate = "BOTH":U.
            ASSIGN
                ttObject.tfOerror  = "":U.

            IF toEdCopy
            THEN DO:
                IF edResults:INSERT-STRING("  ":U + "    Processing... " + rtb_object.object + "~n") IN FRAME {&FRAME-NAME} THEN .
            END.

            IF toCompile
            THEN DO:

                IF toEdCopy
                THEN DO:
                    IF edResults:INSERT-STRING("  ":U + "    ... Compiling    :  " + cObjSourceR + "~n") IN FRAME {&FRAME-NAME} THEN .
                END.

                COMPILE VALUE(cObjSource) SAVE INTO VALUE(cDirSource) NO-ERROR.

                ASSIGN
                    cErrMessage = "":U
                    .
                IF COMPILER:ERROR
                THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    IF iLoop > 1
                    THEN
                        ASSIGN
                            cErrMessage = cErrMessage + CHR(10).
                    ASSIGN
                        cErrMessage = cErrMessage + ERROR-STATUS:GET-MESSAGE(iLoop).
                    IF edResults:INSERT-STRING("  ":U + "    *** ERROR        :  " + ERROR-STATUS:GET-MESSAGE(iLoop) + "~n") IN FRAME {&FRAME-NAME} THEN .

                    ASSIGN
                        ttObject.tfOstatus = "ERROR":U
                        ttObject.tfOerror  = cErrMessage
                        .
                END.
                ELSE DO:
                    ASSIGN
                        ttObject.tfOstatus = "COMILE":U
                        .
                END.

                /* Compile client proxy _cl version of SDO also */
                IF SEARCH("rtb/prc/afcompsdop.p":U) <> ?
                OR SEARCH("rtb/prc/afcompsdop.r":U) <> ?
                THEN DO:
                    FIND FIRST rtb_ver NO-LOCK
                        WHERE rtb_ver.obj-type  = "PCODE":U
                        AND   rtb_object.object = rtb_object.object
                        AND   rtb_ver.pmod      = rtb_object.pmod
                        AND   rtb_ver.version   = rtb_object.version
                        NO-ERROR.
                    IF AVAILABLE rtb_ver
                    AND rtb_ver.sub-type = "SDO":U
                    THEN DO:
                        RUN rtb/prc/afcompsdop.p (INPUT STRING(RECID(rtb_object)) ).
                    END.
                END.

            END.

            IF SEARCH(cObjSourceR) <> ?
            THEN DO:

                IF toMethod = "API":U
                THEN DO:

                    IF toEdCopy
                    THEN DO:
                        IF edResults:INSERT-STRING("  ":U + "    ... Transfering  :  " + cObjSourceR + "~n") IN FRAME {&FRAME-NAME} THEN .
                    END.

                    IF SEARCH("rtb/prc/afrtbappsp.p":U) <> ?
                    OR SEARCH("rtb/prc/afrtbappsp.r":U) <> ?
                    THEN
                        RUN rtb/prc/afrtbappsp.p (INPUT 0
                                                 ,INPUT rtb_object.object
                                                 ,OUTPUT cErrMessage).

                    IF cErrMessage <> ""
                    THEN DO:
                        IF edResults:INSERT-STRING("  ":U + "    *** ERROR        :  " + cErrMessage + "~n") IN FRAME {&FRAME-NAME} THEN .

                        ASSIGN
                            ttObject.tfOstatus = "ERROR":U
                            ttObject.tfOerror  = (IF ttObject.tfOerror <> "":U THEN ttObject.tfOerror + CHR(10) ELSE "":U) + cErrMessage
                            .
                    END.
                    ELSE
                        ASSIGN
                            ttObject.tfOstatus = "UPDATE":U
                            .
                END.
                ELSE
                IF  toMethod = "OAS":U
                OR  toMethod = "MAP":U
                THEN DO:

                    IF toEdCopy
                    THEN DO:
                        IF edResults:INSERT-STRING("  ":U + "    ... Copying      :  " + cObjSourceR + "~n") IN FRAME {&FRAME-NAME} THEN .
                    END.

                    OS-CREATE-DIR VALUE(cDirTarget).
                    OS-COPY VALUE(cObjSourceR) VALUE(cObjTargetR).
                    iErrMessage = OS-ERROR.
                    IF iErrMessage <> 0
                    THEN DO:
                        CASE iErrMessage:
                            WHEN 0    THEN cErrMessage = "No error":U.
                            WHEN 1    THEN cErrMessage = "Not owner":U.
                            WHEN 2    THEN cErrMessage = "No such file or directory":U.
                            WHEN 3    THEN cErrMessage = "Interrupted system call":U.
                            WHEN 4    THEN cErrMessage = "I/O error":U.
                            WHEN 5    THEN cErrMessage = "Bad file number":U.
                            WHEN 6    THEN cErrMessage = "No more processes":U.
                            WHEN 7    THEN cErrMessage = "Not enough core memory":U.
                            WHEN 8    THEN cErrMessage = "Permission denied":U.
                            WHEN 9    THEN cErrMessage = "Bad address":U.
                            WHEN 10   THEN cErrMessage = "File exists":U.
                            WHEN 11   THEN cErrMessage = "No such device":U.
                            WHEN 12   THEN cErrMessage = "Not a directory":U.
                            WHEN 13   THEN cErrMessage = "Is a directory":U.
                            WHEN 14   THEN cErrMessage = "File table overflow":U.
                            WHEN 15   THEN cErrMessage = "Too many open files":U.
                            WHEN 16   THEN cErrMessage = "File too large":U.
                            WHEN 17   THEN cErrMessage = "No space left on device":U.
                            WHEN 18   THEN cErrMessage = "Directory not empty":U.
                            WHEN 999  THEN cErrMessage = "Unmapped error (Progress default)":U.
                            OTHERWISE DO:  cErrMessage = "OS Error #":U + STRING(OS-ERROR,"99").
                            END.
                        END CASE.

                        IF edResults:INSERT-STRING("  ":U + "    *** ERROR        :  " + cErrMessage + "~n") IN FRAME {&FRAME-NAME} THEN .

                        ASSIGN
                            ttObject.tfOstatus = "ERROR":U
                            ttObject.tfOerror  = (IF ttObject.tfOerror <> "":U THEN ttObject.tfOerror + CHR(10) ELSE "":U) + cErrMessage
                            .
                    END.
                    ELSE
                        ASSIGN
                            ttObject.tfOstatus = "UPDATE":U
                            .
                END.

            END.
            ELSE DO:
                ASSIGN
                    cErrMessage        = "R-code not found":U
                    ttObject.tfOstatus = "ERROR":U
                    ttObject.tfOerror  = (IF ttObject.tfOerror <> "":U THEN ttObject.tfOerror + CHR(10) ELSE "":U) + cErrMessage
                    .
                        IF edResults:INSERT-STRING("  ":U + "    *** ERROR        :  " + cErrMessage + "~n") IN FRAME {&FRAME-NAME} THEN .
            END.

            /* Count Section */
            IF ttObject.tfOstatus = "ERROR":U
            THEN DO:
                ASSIGN
                    iObjErrors = iObjErrors + 1.
                IF INDEX(rtb_object.pmod,"-aaa":U)           <> 0 THEN ASSIGN iEModRoot  = iEModRoot  + 1.
                IF INDEX(rtb_object.pmod,"-app":U)           <> 0 THEN ASSIGN iEModApp   = iEModApp   + 1.
                IF INDEX(rtb_object.pmod,"-adm":U)           <> 0 THEN ASSIGN iEModAdm   = iEModAdm   + 1.
                IF INDEX(rtb_object.pmod,"-trg":U)           <> 0 THEN ASSIGN iEModTrg   = iEModTrg   + 1.
                IF INDEX(rtb_object.pmod,"-w":U)             <> 0 THEN ASSIGN iEModWeb   = iEModWeb   + 1.
                IF INDEX(rtb_object.obj-group,"APPSERVER":U) <> 0 THEN ASSIGN iEGrpApp   = iEGrpApp   + 1.
                IF INDEX(rtb_object.obj-group,"SDO":U)       <> 0 THEN ASSIGN iEGrpSdo   = iEGrpSdo   + 1.
            END.
            /* Count Section */

        END.
        ELSE    /* Mark object not selected for update to checked in the remote r-code builded table if selected. */
        IF ( NOT toModRoot   AND  INDEX(rtb_object.pmod     ,"-aaa":U)      <> 0 )
        OR ( NOT toModApp    AND  INDEX(rtb_object.pmod     ,"-app":U)      <> 0 )
        OR ( NOT toModAdm    AND  INDEX(rtb_object.pmod     ,"-adm":U)      <> 0 )
        OR ( NOT toModTrg    AND  INDEX(rtb_object.pmod     ,"-trg":U)      <> 0 )
        OR ( NOT toModWeb    AND  INDEX(rtb_object.pmod     ,"-w":U)        <> 0 )
        OR ( NOT toGrpApp    AND  INDEX(rtb_object.obj-group,"APPSERVER":U) <> 0 )
        OR ( NOT toGrpSdo    AND  INDEX(rtb_object.obj-group,"SDO":U)       <> 0 )
        THEN DO:
            FIND FIRST ttObject EXCLUSIVE-LOCK
                WHERE ttObject.tfOfilename  = cObjectNameR
                AND   ttObject.tfOdirectory = ( IF cPModule <> "":U THEN cPModule ELSE "":U )
                NO-ERROR.
            IF AVAILABLE ttObject
            THEN
                ASSIGN
                    ttObject.tfOupdate  = "BOTH":U.
        END.

    END.

    IF toEdCount
    THEN DO:

        IF edResults:INSERT-STRING("~n" + "DETAIL"    + "~n") IN FRAME {&FRAME-NAME} THEN .

        IF edResults:INSERT-STRING(toModRoot:LABEL    + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iModRoot   ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEModRoot,">,>>>,>>9":U)   + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING(toModApp:LABEL     + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iModApp    ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEModApp,">,>>>,>>9":U)    + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING(toModAdm:LABEL     + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iModAdm    ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEModAdm,">,>>>,>>9":U)    + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING(toModTrg:LABEL     + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iModTrg    ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEModTrg,">,>>>,>>9":U)    + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING(toModWeb:LABEL     + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iModWeb    ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEModWeb,">,>>>,>>9":U)    + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING(toGrpApp:LABEL     + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iGrpApp    ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEGrpApp,">,>>>,>>9":U)    + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING(toGrpSdo:LABEL     + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("     Copied: ":U  + STRING(iGrpSdo    ,">,>>>,>>9":U) + " - Errors: ":U + STRING(iEGrpSdo,">,>>>,>>9":U)    + "~n") IN FRAME {&FRAME-NAME} THEN .

        IF edResults:INSERT-STRING("~n" + "SUMMARY"   + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

        IF edResults:INSERT-STRING("All Processed : " + STRING(iObjProcess,">,>>>,>>9":U) + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("Total Copied  : " + STRING(iObjCopied ,">,>>>,>>9":U) + "~n") IN FRAME {&FRAME-NAME} THEN .
        IF edResults:INSERT-STRING("Total Errors  : " + STRING(iObjErrors ,">,>>>,>>9":U) + "~n") IN FRAME {&FRAME-NAME} THEN .

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
  DISPLAY coWorkspace toMethod coOSDrive cOSDriveMap cCopyFrom cCopyTo toModRoot 
          toGrpApp toModApp toModAdm toGrpSdo toModTrg toModWeb toCompile 
          toCheckOas edResults toEdCopy toEdCount 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coWorkspace toMethod coOSDrive cOSDriveMap cCopyFrom cCopyTo toModRoot 
         toGrpApp toModApp toModAdm toGrpSdo toModTrg toCompile toCheckOas 
         edResults toEdCopy buOK buCancel toEdCount RECT-1 RECT-2 RECT-4 RECT-5 
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

        RUN buildCoWorkspace.
        RUN buildCoOSDrive.

        ASSIGN
            {&WINDOW-NAME}:TITLE = "OpenAppServer Update Copy Procedure":U
            .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startProcess C-Win 
PROCEDURE startProcess :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF edResults:INSERT-STRING("~n" + "*** Starting with process for Workspace ":U + coWorkspace + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

    EMPTY TEMP-TABLE ttObject.

    IF  toMethod = "MAP":U
    AND toCheckOas
    THEN DO:
        IF edResults:INSERT-STRING("~n" + "Starting list of current r-code on Open Appserver drive " + cCopyTo + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        RUN buildOasObjects.
        IF edResults:INSERT-STRING("~n" + "Complete list of current r-code on Open Appserver drive" + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
    END.

    IF toMethod = "API":U
    OR toMethod = "OAS":U
    OR toMethod = "MAP":U
    THEN
        RUN copyRCode.

    IF  toMethod = "MAP":U
    AND toCheckOas
    THEN DO:
        IF edResults:INSERT-STRING("~n" + "Starting check of unprocessed r-code on Open Appserver drive " + cCopyTo + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
        RUN checkOasObjects.
        IF edResults:INSERT-STRING("~n" + "Complete check of unprocessed r-code on Open Appserver drive" + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .
    END.

    IF edResults:INSERT-STRING("~n" + "*** Completed with process for Workspace ":U + coWorkspace + "~n" + "~n") IN FRAME {&FRAME-NAME} THEN .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateScreen C-Win 
PROCEDURE updateScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iDriveLoop  AS INTEGER      NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN
            coWorkspace
            toMethod
            coOSDrive
            .

        ASSIGN
            iDriveLoop  =  LOOKUP(coOSDrive,coOSDrive:LIST-ITEMS)
            cOSDriveMap = ENTRY(iDriveLoop,coOSDrive:PRIVATE-DATA)
            cCopyFrom   = REPLACE(coWorkspace,"-":U,"~/":U)
            cCopyFrom   = TRIM(cCopyFrom,"~/":U)
            cCopyTo     = REPLACE(coWorkspace,"-":U,"":U)
            cCopyTo     = TRIM(cCopyTo,"~/":U)
            .

        IF ENTRY(2,coWorkspace,"-":U) BEGINS "dev":U
        THEN ASSIGN cCopyFrom = "g:~/":U + cCopyFrom.
        ELSE
        IF ENTRY(2,coWorkspace,"-":U) BEGINS "tst":U
        THEN ASSIGN cCopyFrom = "t:~/":U + cCopyFrom.
        ELSE
        IF ENTRY(2,coWorkspace,"-":U) BEGINS "v":U
        THEN ASSIGN cCopyFrom = "v:~/":U + cCopyFrom.
        ELSE ASSIGN cCopyFrom = "x:~/":U + cCopyFrom.

        CASE toMethod:
            WHEN "API":U
                THEN DO:
                    FIND FIRST AppSrv-TT
                        WHERE AppSrv-TT.Partition = "Astra"
                        NO-ERROR.
                    IF AVAILABLE AppSrv-TT
                    THEN
                        ASSIGN
                            cCopyTo = AppSrv-TT.App-Service.
                    ELSE
                        ASSIGN
                            cCopyTo = "oas_":U + LC(TRIM(REPLACE(coWorkspace,"-":U,"":U))).
                END.
            WHEN "OAS":U
                THEN DO:
                    ASSIGN
                        cCopyTo = "~\~\Mojo~\appserver":U.
                END.
            WHEN "MAP":U
                THEN DO:
                    ASSIGN
                        cCopyTo = TRIM(coOSDrive,"~/":U) + "~/":U + cCopyTo.
                END.
            OTHERWISE
                DO:
                    ASSIGN
                        cCopyTo = "~/share~/oas~/":U + cCopyTo.
                END.
        END.

        ASSIGN
            cCopyFrom  = LC( cCopyFrom )
            cCopyTo    = LC( cCopyTo   )
            .

        ASSIGN
            cCopyFrom:SCREEN-VALUE      = cCopyFrom
            cCopyTo:SCREEN-VALUE        = cCopyTo
            cOSDriveMap:SCREEN-VALUE    = cOSDriveMap
            .

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

