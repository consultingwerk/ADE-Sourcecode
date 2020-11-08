&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*************************************************************/  
/* Copyright (c) 1984-2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{af/sup2/dynhlp.i}            /* Help File Preprocessor Directives         */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */  
DEFINE VARIABLE xcADMDestroy AS CHARACTER  NO-UNDO  
              INIT 'adm2/*,*/custom/*,web2/*,ry/*/rydyn*' .
  
DEFINE NEW GLOBAL SHARED VARIABLE h_ade_tool    AS HANDLE    NO-UNDO.
 
DEFINE VARIABLE hLaunchContainer  AS HANDLE   NO-UNDO.
DEFINE VARIABLE glStop            AS LOGICAL.
DEFINE VARIABLE glStopped         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE rRowID            AS ROWID      NO-UNDO.
DEFINE VARIABLE cProfileData      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghrycSmartObject AS HANDLE     NO-UNDO.
DEFINE VARIABLE lWindowClose     AS LOGICAL    NO-UNDO.

DEFINE TEMP-TABLE ttRun NO-UNDO
  FIELD hdl        AS HANDLE
  FIELD ObjectName AS CHARACTER.

{src/adm2/globals.i}

{ launch.i &Define-only = YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buBrowse buClearMRU coHistory fiFile ~
ToPersistent buRun toMultiple ToClearCache toClearData ToDestroyAdm 
&Scoped-Define DISPLAYED-OBJECTS coHistory fiFile ToPersistent toMultiple ~
ToClearCache toClearData ToDestroyAdm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkAB wWin 
FUNCTION checkAB RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkADM wWin 
FUNCTION checkADM RETURNS CHARACTER
  (pcCheck AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyADM wWin 
FUNCTION destroyADM RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitialFileName wWin 
FUNCTION getInitialFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenObjectFilter wWin 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
 (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowHandle wWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buBrowse 
     IMAGE-UP FILE "ry/img/afbinos.gif":U
     LABEL "" 
     SIZE 5 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buClearMRU 
     IMAGE-UP FILE "ry/img/objectdelete.bmp":U
     LABEL "&History" 
     SIZE 5 BY 1.14 TOOLTIP "Clears the MRU history"
     BGCOLOR 8 .

DEFINE BUTTON buRun 
     LABEL "&Run" 
     SIZE 14 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buStop 
     LABEL "&Stop" 
     SIZE 14 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coHistory AS CHARACTER 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE .2 BY .91
     BGCOLOR 7 FGCOLOR 7  NO-UNDO.

DEFINE VARIABLE fiFile AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 69.2 BY 1 TOOLTIP "Specify the dynamic container to launch".

DEFINE VARIABLE ToClearCache AS LOGICAL INITIAL no 
     LABEL "Clear &repository cache" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.6 BY .81 NO-UNDO.

DEFINE VARIABLE toClearData AS LOGICAL INITIAL no 
     LABEL "Clear &data cache" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 24.8 BY .81 NO-UNDO.

DEFINE VARIABLE ToDestroyAdm AS LOGICAL INITIAL no 
     LABEL "Destroy &ADM super procedures" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.2 BY .81 NO-UNDO.

DEFINE VARIABLE toMultiple AS LOGICAL INITIAL no 
     LABEL "Always run &new instance" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 27.6 BY .81 NO-UNDO.

DEFINE VARIABLE ToPersistent AS LOGICAL INITIAL no 
     LABEL "Run &persistent" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     buBrowse AT ROW 1.95 COL 76
     buClearMRU AT ROW 1.95 COL 81
     coHistory AT ROW 2.05 COL 1 COLON-ALIGNED NO-LABEL
     fiFile AT ROW 2.05 COL 3 HELP
          "Enter the name of the dynamic container you wish to run" NO-LABEL
     fiChar AT ROW 2.05 COL 70.2 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     ToPersistent AT ROW 3.29 COL 3
     buRun AT ROW 3.38 COL 71.8
     toMultiple AT ROW 4.1 COL 3
     buStop AT ROW 4.81 COL 71.8
     ToClearCache AT ROW 4.91 COL 3
     toClearData AT ROW 5.71 COL 3
     ToDestroyAdm AT ROW 6.52 COL 3
     "Name of &container to launch" VIEW-AS TEXT
          SIZE 29.2 BY .62 AT ROW 1.19 COL 3.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 86 BY 6.76
         DEFAULT-BUTTON buRun.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Dynamic Launcher"
         HEIGHT             = 6.62
         WIDTH              = 85.4
         MAX-HEIGHT         = 6.76
         MAX-WIDTH          = 95.2
         VIRTUAL-HEIGHT     = 6.76
         VIRTUAL-WIDTH      = 95.2
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON buStop IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiChar IN FRAME fMain
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiFile IN FRAME fMain
   ALIGN-L                                                              */
ASSIGN 
       fiFile:PRIVATE-DATA IN FRAME fMain     = 
                "run-pgm".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Dynamic Launcher */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Dynamic Launcher */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  lWindowClose = YES.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fMain wWin
ON HELP OF FRAME fMain
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Dynamic_Launcher_Dialog_Box}  , "":U).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse wWin
ON CHOOSE OF buBrowse IN FRAME fMain
DO:
 DEFINE VARIABLE cFilename AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK AS LOGICAL    NO-UNDO.

 ASSIGN {&WINDOW-NAME}:PRIVATE-DATA = STRING(THIS-PROCEDURE).
 
 RUN adeuib/_opendialog.w (INPUT {&WINDOW-NAME},
                           INPUT "",
                           INPUT No,
                           INPUT "Get Object",
                           OUTPUT cFilename,
                           OUTPUT lok).
 IF lOK THEN
    ASSIGN fiFile:SCREEN-VALUE = cFilename.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buClearMRU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClearMRU wWin
ON CHOOSE OF buClearMRU IN FRAME fMain /* History */
DO:
  DEFINE VARIABLE cChoice AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    RUN showMessages IN gshSessionManager (INPUT "Are you sure you want to clear the MRU history?",
                                       INPUT "MES":U,
                                       INPUT "&Yes,&No":U,
                                       INPUT "&No":U,
                                       INPUT "&No":U,
                                       INPUT "Clear History":U,
                                       INPUT NO,
                                       INPUT THIS-PROCEDURE,
                                       OUTPUT cChoice).
    IF cChoice <> "&YES":U THEN
    RETURN.

    RUN setProfileData IN gshProfileManager 
          (INPUT "General":U,        /* Profile type code */
           INPUT "DispRepos":U,      /* Profile code */
           INPUT "DynLauncherMRU":U, /* Profile data key */
           INPUT ?,                  /* Rowid of profile data */
           INPUT "":U,               /* Profile data value */
           INPUT YES,                /* Delete flag */
           INPUT "PER":U).           /* Save flag (permanent) */
    coHistory:LIST-ITEM-PAIRS = ?.
    DISPLAY "":U @ fiFile.
    DISPLAY coHistory.
    buClearMRU:SENSITIVE = FALSE.
    APPLY "ENTRY":U TO fiFile.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRun wWin
ON CHOOSE OF buRun IN FRAME fMain /* Run */
DO:
  RUN runContainer (INPUT fiFile:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buStop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buStop wWin
ON CHOOSE OF buStop IN FRAME fMain /* Stop */
DO:
  IF glStop THEN STOP.
  ELSE
  DO:
    lWindowClose = YES.
    RUN destroyPersistent.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coHistory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coHistory wWin
ON VALUE-CHANGED OF coHistory IN FRAME fMain
DO:
    ASSIGN fiFile:SCREEN-VALUE = SELF:SCREEN-VALUE.
    APPLY "ENTRY":U TO fiFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toClearData
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toClearData wWin
ON VALUE-CHANGED OF toClearData IN FRAME fMain /* Clear data cache */
DO:
  IF toDestroyADM:CHECKED AND toDestroyADM:SENSITIVE THEN
    SELF:CHECKED = TRUE.
  ASSIGN toClearData.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToDestroyAdm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToDestroyAdm wWin
ON VALUE-CHANGED OF ToDestroyAdm IN FRAME fMain /* Destroy ADM super procedures */
DO:
  IF SELF:CHECKED THEN
     toClearData:CHECKED = TRUE.
  ELSE 
    toClearData:CHECKED = toClearData.
/*   toClearData:SENSITIVE = NOT SELF:CHECKED. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cColumn                     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cRow                        AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cMruList                    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE rProfileRid                 AS ROWID                NO-UNDO.
DEFINE VARIABLE dSavedRow                   AS DECIMAL              NO-UNDO.
DEFINE VARIABLE dSavedColumn                AS DECIMAL              NO-UNDO.
DEFINE VARIABLE hOtherME                    AS HANDLE               NO-UNDO.
DEFINE VARIABLE hWin                        AS HANDLE               NO-UNDO.

/*
 Loop through the session and check if another launcher is running.
 We only start one launcher. This shoould not be a problem as it is able to launch as many persistent objects
 as one like and ity does not make sense to run several non-persistent objects.
 The ability to destroy supers may also cause problems if several launchers were able to run.
*/

hOtherMe = SESSION:FIRST-PROCEDURE.

DO WHILE VALID-HANDLE(hOtherMe):
  IF hOtherME:FILE-NAME = PROGRAM-NAME(1)
  AND hOtherMe <> THIS-PROCEDURE THEN
  DO:
    hWin = DYNAMIC-FUNCTION('getWindowHandle' IN hOtherMe).
    hWin:MOVE-TO-TOP().
    /* just in case we found a hidden one */ 
    VIEW hWin.
    /* or minimized one (max is disabled) */
    hWin:WINDOW-STATE = WINDOW-NORMAL.
    APPLY "ENTRY":U TO hWin.

    /* Commit suicide */
    RUN DISABLE_ui.   
    RETURN.
  END.
  hOtherMe = hOtherMe:NEXT-SIBLING. 
END.

ON ALT-C OF FRAME {&FRAME-NAME} ANYWHERE DO:
  APPLY "ENTRY" TO fifile IN FRAME {&FRAME-NAME}.
END.

/* Include custom  Main Block code for SmartWindows. */
ON CLOSE OF THIS-PROCEDURE 
DO:
  RUN destroyObject IN THIS-PROCEDURE.
  IF ERROR-STATUS:ERROR THEN
     RETURN NO-APPLY.
END.

ASSIGN
  toClearCache = TRUE
  toPersistent = TRUE
  toMultiple   = TRUE
  coHistory:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3). 

RUN constructSDO IN THIS-PROCEDURE.

/* Get the MRU list */
RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                          INPUT        "DispRepos":U,
                                          INPUT        "DynLauncherMRU":U,
                                          INPUT        NO,
                                          INPUT-OUTPUT rRowid,
                                          OUTPUT       cMruList).
ASSIGN coHistory:LIST-ITEM-PAIRS  = cMruList  NO-ERROR.

/* Get the previous position of the window . */
RUN getProfileData IN gshProfileManager ( INPUT "Window":U,
                                          INPUT "SaveSizPos":U,
                                          INPUT "SaveSizPos":U,
                                          INPUT NO,
                                          INPUT-OUTPUT rProfileRid,
                                          OUTPUT cProfileData).
IF cProfileData EQ "Yes":U THEN
DO:
    ASSIGN cProfileData = "":U
           rProfileRid  = ?
           .
    RUN getProfileData IN gshProfileManager ( INPUT "Window":U,             /* Profile type code                            */
                                              INPUT "SizePos":U,            /* Profile code                                 */
                                              INPUT "rycsolnchw.w",         /* Profile data key                             */
                                              INPUT "NO":U,                 /* Get next record flag                         */
                                              INPUT-OUTPUT rProfileRid,     /* Rowid of profile data                        */
                                              OUTPUT cProfileData       ).  /* Found profile data. Positions as follows:    */
                                                                            /* 1 = col,         2 = row,                    */
                                                                            /* 3 = width chars, 4 = height chars            */

    IF NUM-ENTRIES(cProfileData, CHR(3)) EQ 4 THEN
    DO:
        ASSIGN 
            /* Ensure that the values have the correct decimal points. 
             * These values are always stored using the American numeric format
             * ie. using a "." as decimal point.                               */
            cColumn = ENTRY(1, cProfileData, CHR(3))
            cColumn = REPLACE(cColumn, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

            cRow = ENTRY(2, cProfileData, CHR(3))
            cRow = REPLACE(cRow, ".":U, SESSION:NUMERIC-DECIMAL-POINT)

            dSavedRow    = DECIMAL(cRow)
            dSavedColumn = DECIMAL(cColumn)

            NO-ERROR.

        ASSIGN {&WINDOW-NAME}:COLUMN = IF (dSavedColumn + {&WINDOW-NAME}:WIDTH-CHARS) GE SESSION:WIDTH-CHARS THEN
                                           MAX(SESSION:WIDTH-CHARS - {&WINDOW-NAME}:WIDTH-CHARS, 1)
                                       ELSE
                                       IF dSavedColumn LT 0 THEN
                                           1
                                       ELSE
                                           dSavedColumn
               {&WINDOW-NAME}:ROW    = IF (dSavedRow + {&WINDOW-NAME}:HEIGHT-CHARS) GE SESSION:HEIGHT-CHARS THEN
                                           MAX(SESSION:HEIGHT-CHARS - {&WINDOW-NAME}:HEIGHT-CHARS - 1.5, 1)
                                       ELSE
                                       IF dSavedRow LT 0 THEN
                                           1
                                       ELSE
                                           dSavedRow.
    END.    /* There are saved positions. */
END.    /* Window positions are saved. */

/* Load correct application icon */
  {aficonload.i}

RUN ENABLE_UI.

/* Check whether the AppBuilder is running. We need to know this because the lookup button
 * is dependent on the AppBulder running. If the AB is not running, then we simply disable the 
 * button. */
ASSIGN buBrowse:HIDDEN = NOT VALID-HANDLE(h_ade_tool).

IF cProfileData > "" THEN
  ASSIGN coHistory:LIST-ITEM-PAIRS  = cMruList  
         fiFile:SCREEN-VALUE        = ENTRY(1,coHistory:ENTRY(1)," ")
         coHistory:SCREEN-VALUE     = fiFile:SCREEN-VALUE 
         NO-ERROR.

fiFile:MOVE-TO-TOP().
APPLY 'ENTRY' TO fifile IN FRAME {&FRAME-NAME}.

IF INPUT fiFile = "" OR INPUT fiFile = ? THEN
    buClearMRU:SENSITIVE = FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeObject wWin 
PROCEDURE closeObject :
/*------------------------------------------------------------------------------
  Purpose: Called from ConfirmExit procedure to keep track of when DestroyAdm 
           can be enabled again.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phRun AS HANDLE  NO-UNDO.

  DEFINE BUFFER bttRun FOR ttRun.

  FOR EACH bttRun WHERE bttRun.hdl = phRun:

    DELETE bttRun. 

  END.

  IF NOT CAN-FIND(FIRST ttRun)
  THEN
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      toDestroyADM:SENSITIVE  = TRUE
      toDestroyADM:CHECKED    = toDestroyADM
      buStop:SENSITIVE        = FALSE
      .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmExit wWin 
PROCEDURE confirmExit :
/*------------------------------------------------------------------------------
  Purpose:     If the confirmExit Does not return a Cancel response,
               assume the object was closed.
  Parameters:  plCancel   True  Object destroy was canceled
                          False Object was destroyed
  Notes:      
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.

IF NOT plCancel THEN 
    RUN closeObject IN THIS-PROCEDURE (SOURCE-PROCEDURE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructSDO wWin 
PROCEDURE constructSDO :
/*------------------------------------------------------------------------------
  Purpose:   Constructs the ryc_smartObject SDO to be used to retrieve the
             description.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
  RUN startDataObject IN gshRepositoryManager("dopendialog.w":U, 
                                              OUTPUT ghRycSmartObject).

  IF VALID-HANDLE(ghRycSmartObject) THEN
  DO:
    RUN setPropertyList IN ghRycSmartObject 
            ('AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch10CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectNamedopendialogUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U).
   
    RUN initializeObject IN ghRycSmartObject. 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject wWin 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Remember this procedure may be run when the Appbuilder shuts down.
               If so, deletePersistentProc is run in the session manager which
               shuts down all persistent procs in the session.  Keep in mind
               that some of the procedures launched by this launcher may already
               be shut when we get here.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOGICAL    NO-UNDO.
  IF (glStop OR CAN-FIND(FIRST ttrun))
  AND lWindowClose = YES THEN
  DO:
    MESSAGE 'This will close all containers that are running from the Launcher.'
            SKIP
            'Confirm close of the Launcher and all running containers?' 
        VIEW-AS ALERT-BOX QUESTION  BUTTONS YES-NO UPDATE lok.
    IF NOT lok THEN RETURN.
  END.

  IF VALID-HANDLE(gshProfileManager) /* Probably not necessary, belts and braces */
  THEN DO:
      /* Check if we should be saving window positions */
      ASSIGN rProfileRid = ?.    
      RUN getProfileData IN gshProfileManager ( INPUT "Window":U,
                                                INPUT "SaveSizPos":U,
                                                INPUT "SaveSizPos":U,
                                                INPUT NO,
                                                INPUT-OUTPUT rProfileRid,
                                                OUTPUT cProfileData).

      /* If the user wants to save window positions, save them */
      IF cProfileData EQ "Yes":U 
      THEN DO:
          /* Always store decimal values as if they were in American numeric format.
           * When retrieving decimal values, we need to convert to the current
           * SESSION:NUMERIC-DECIMAL-POINT.                                         */
          ASSIGN cProfileData = REPLACE(STRING({&WINDOW-NAME}:COLUMN),       SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3) +
                                REPLACE(STRING({&WINDOW-NAME}:ROW),          SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3) +
                                REPLACE(STRING({&WINDOW-NAME}:WIDTH-CHARS),  SESSION:NUMERIC-DECIMAL-POINT, ".":U) + CHR(3) +
                                REPLACE(STRING({&WINDOW-NAME}:HEIGHT-CHARS), SESSION:NUMERIC-DECIMAL-POINT, ".":U).
    
          RUN setProfileData IN gshProfileManager (INPUT "Window":U,        /* Profile type code */
                                                   INPUT "SizePos":U,       /* Profile code */
                                                   INPUT "rycsolnchw.w",    /* Profile data key */
                                                   INPUT ?,                 /* Rowid of profile data */
                                                   INPUT cProfileData,      /* Profile data value */
                                                   INPUT NO,                /* Delete flag */
                                                   INPUT "PER":u).          /* Save flag (permanent) */
      END.
  END.

  /* glStop is set to true to indicate that we need to STOP to get
     out of a non persistent run */ 
  IF glStop THEN
  DO:
    /* We cannot run disable_UI from here as we are in a wait-for of the
       non-persistent object. glStopped will tell the runContainer to 
       call us again when it has gotten out of the wait-for.*/ 
    glStopped = TRUE.  
    STOP.
  END.
  ELSE DO:
    /* destroy  all persistent objects that we have started */
    RUN destroyPersistent.
    IF VALID-HANDLE(ghrycSmartObject) THEN /* This object may have been closed already by the Appbuilder shutdown */
        RUN destroyObject IN ghrycSmartObject NO-ERROR.
    RUN DISABLE_ui. 
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyPersistent wWin 
PROCEDURE destroyPersistent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.
 IF lWindowClose THEN
    FOR EACH ttRun:
       IF VALID-HANDLE(ttRun.hdl) THEN
          APPLY 'close':U TO ttRun.hdl. 
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY coHistory fiFile ToPersistent toMultiple ToClearCache toClearData 
          ToDestroyAdm 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE buBrowse buClearMRU coHistory fiFile ToPersistent buRun toMultiple 
         ToClearCache toClearData ToDestroyAdm 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshADM wWin 
PROCEDURE refreshADM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cProc     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSmart    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iProc     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE i         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cFile     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cProchdl  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hObj      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE ctype     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cWin      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSuper    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cFileList AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE h AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cOpenProc AS CHARACTER  NO-UNDO.
   
 RUN adeuib/_uibinfo.p(?,'session','procedures', OUTPUT cProc) NO-ERROR.
 
 cOpenProc = checkADM('ab').

 IF INDEX(cOpenproc,'.ab') <> 0 THEN
 DO WITH FRAME {&FRAME-NAME}:
   MESSAGE 'The ADM Super Procedures are currently being used'
           'by procedures started from the AppBuilder.'
           SKIP
           'You must close these procedures or uncheck the'
           "'" REPLACE(toDestroyADM:LABEL,'&','') "'"
           'option before running.' 
           VIEW-AS ALERT-BOX information.
   RETURN ERROR.
 END.

 /* Check and close design windows */ 
 DO i = 1 TO NUM-ENTRIES(cProc):
   ASSIGN iProc = ENTRY(i,cProc).
   /*
   RUN adeuib/_uibinfo.p(iProc,?,'TYPE', OUTPUT cType).
   
   IF CAN-DO('procedure,window',ctype) THEN NEXT.
   */

   RUN adeuib/_uibinfo.p(iProc,?,'contains smartobject', OUTPUT cSmart).
 
   IF cSmart = '':U THEN NEXT.
   RUN adeuib/_uibinfo.p(iProc,'WINDOW ?','HANDLE', OUTPUT cWin).
   RUN adeuib/_uibinfo.p(iProc,?,'file-name', OUTPUT cFile).
   
   /* find current desing window and filename */
   hObj = WIDGET-HANDLE(cWin) NO-ERROR.
   
   IF cfile = '?' OR cfile = ?  THEN
   DO WITH FRAME {&FRAME-NAME}:
      MESSAGE 'You have unsaved design windows in the AppBuilder.'
              'You must save the' hObj:title 'window or uncheck the'
              "'" REPLACE(toDestroyADM:LABEL,'&','') "'"
              'option before running.' 
      VIEW-AS ALERT-BOX information.
      APPLY 'Entry':U TO hobj.
      hObj:MOVE-TO-TOP().
      RETURN ERROR.        
   END.

   IF VALID-HANDLE(hObj) THEN 
   DO:
     APPLY 'window-close' TO hObj.
     cFileList = cFileList + (IF cFileList = '' THEN '' ELSE ',') + cfile.
   END.
 END.
 
 cOpenProc = checkADM('').
 
 IF cOpenProc <> '':U  THEN
 DO WITH FRAME {&FRAME-NAME}:
  MESSAGE 'The ADM Super Procedures are currently being used by' cOpenProc '.'
          SKIP
          'You must close these procedures or uncheck the'
          "'" REPLACE(toDestroyADM:LABEL,'&','') "'"
          'option before running.' 
          VIEW-AS ALERT-BOX information.
  RETURN ERROR.
 END.

 RUN destroyObject IN ghRycSmartObject NO-ERROR.

 destroyADM(). 

 RUN constructSDO.

 DO i = 1 TO NUM-ENTRIES(cfileList):
  cFile = ENTRY(i,cFileList).
  IF cFile <> '' AND cFile <> ? THEN
   RUN adeuib/_open-w.p 
      (cfile,
       '',
       'OPEN').
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runContainer wWin 
PROCEDURE runContainer :
/*------------------------------------------------------------------------------
  Purpose:     Launches the container specified.
  Parameters:  pcRunFile - 
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRunFile         AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cPropertyList            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValueList               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lStopped                 AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContainer               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUIB                     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cLogicalName             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContainerSuperProcedure AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cChildDataKey            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRunAttribute            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hContainerWindow         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainerSource         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hObject                  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRunContainer            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRunContainerType        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hCacheManager            AS HANDLE    NO-UNDO.

  ASSIGN
    FRAME {&FRAME-NAME} toMultiple
    cChildDataKey     = "":U
    cRunAttribute     = "":U
    hContainerWindow  = ?
    hContainerSource  = ?
    hObject           = ?
    hContainerWindow  = ?
    cRunContainerType = "":U
    hRunContainer     = ?.

  DO WITH FRAME {&FRAME-NAME}:

    IF NOT VALID-HANDLE(gshSessionManager) THEN 
    DO:
      MESSAGE
        "Please correct, Session Manager is not running. Ensure the Dynamics Application is running"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
    END. /* NOT VALID-HANDLE(gshRepositoryManager) */

    IF NOT VALID-HANDLE(gshRepositoryManager) THEN 
    DO:
      MESSAGE
        "Please correct, Repository Manager is not running. Ensure the Dynamics Application is running"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
    END. /* NOT VALID-HANDLE(gshRepositoryManager) */

    IF pcRunFile = "":U THEN 
    DO:
      MESSAGE
        "Please specify the name of an object to run."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
    END.    /* runfile = '' */

    IF toClearCache:CHECKED THEN 
      RUN clearClientCache IN gshRepositoryManager.

    IF toClearData:CHECKED THEN
    DO:
      /* call getCacheManager in an ADM2 object as it defines default manager*/
      hCacheManager = DYNAMIC-FUNCTION('getManagerHandle':U IN ghRycSmartObject,
                                       'CacheManager':U).
      IF VALID-HANDLE(hCacheManager) THEN
        RUN clearCache IN hCacheManager('*':U).
    END.

    IF toDestroyADM:SENSITIVE
    AND toDestroyAdm:CHECKED THEN 
    DO:
      RUN refreshADM NO-ERROR.
      IF ERROR-STATUS:ERROR THEN 
        RETURN.
    END.   /* destroy ADM */
    ELSE 
      /* on second run set destroy false  */
      toDestroyAdm:CHECKED = FALSE.  

    DO ON STOP UNDO,  LEAVE ON ERROR UNDO, LEAVE:

      IF toPersistent:CHECKED THEN 
      DO:

        ASSIGN
          toDestroyAdm:SENSITIVE = FALSE
          buStop:SENSITIVE       = TRUE
          .

        IF VALID-HANDLE(gshSessionManager) THEN
          RUN launchContainer IN gshSessionManager 
                              (INPUT  pcRunFile            /* object filename if physical/logical names unknown */
                              ,INPUT  "":U                 /* physical object name (with path and extension) if known */
                              ,INPUT  pcRunFile            /* logical object name if applicable and known */
                              ,INPUT NOT toMultiple        /* run once only flag YES/NO */
                              ,INPUT  "":U                 /* instance attributes to pass to container */
                              ,INPUT  cChildDataKey        /* child data key if applicable */
                              ,INPUT  cRunAttribute        /* run attribute if required to post into container run */
                              ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
                              ,INPUT  hContainerWindow     /* parent (caller) window handle if known (container window handle) */
                              ,INPUT  hContainerSource     /* parent (caller) procedure handle if known (container procedure handle) */
                              ,INPUT  hObject              /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
                              ,OUTPUT hRunContainer        /* procedure handle of object run/running */
                              ,OUTPUT cRunContainerType    /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
                              ).

        IF VALID-HANDLE(hRunContainer) THEN 
        DO:
          /* Subscribe to ConfirmExit to allow launcher to know whether object was destroyed. */
          SUBSCRIBE TO "ConfirmExit" IN hRunContainer.

          RUN setMRULIST IN THIS-PROCEDURE (pcRunFile,YES).

          /* Keep the handles of the obejct we run to clean up afterwwards. */
          /* Only add a record if it does not already exist */
          FIND FIRST ttRun EXCLUSIVE-LOCK
            WHERE ttRun.hdl        = hRunContainer
            AND   ttRun.ObjectName = pcRunFile
            NO-ERROR.
          IF NOT AVAILABLE ttRUN
          THEN DO:
            CREATE ttRun.
            ASSIGN ttRun.hdl        = hRunContainer
                   ttRun.ObjectName = pcRunFile
                   .
          END.

        END.    /* valid hRun */

      END. /* Persistent */
      ELSE DO:

        IF checkAB() = FALSE THEN 
        DO:
          MESSAGE
            'You must close procedures running from the AppBuilder before'
            'you do a non persistent launch of a container.' 
            VIEW-AS ALERT-BOX  INFORMATION BUTTONS OK.
          RETURN. 
        END.

        /* Get the Logical and Physical Names */
        RUN getObjectNames IN gshRepositoryManager ( INPUT  pcRunFile,
                                                     input  '',    /* run attribute */
                                                     OUTPUT cContainer,
                                                     OUTPUT cLogicalName).

        IF cContainer = "":U THEN 
        DO:
          MESSAGE
            "A physical object could not be found for the logical object '" pcRunFile "'":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN.
        END.    /* container = '' */

        ASSIGN
          hUIB             = h_ade_tool
          buRun:SENSITIVE  = FALSE
          buStop:SENSITIVE = TRUE
          glStop           = TRUE
          .

        IF VALID-HANDLE(hUIB) THEN
          RUN disable_widgets in hUIB.

        RUN setMRULIST IN THIS-PROCEDURE (pcRunFile,YES).
        RUN VALUE(cContainer).

      END.    /* not persistent, with frame ... */

    END.    /* on stop undo leave. */

    IF NOT toPersistent:CHECKED THEN 
    DO:

      IF VALID-HANDLE(hUIB)THEN
        RUN enable_widgets in hUIB.

      buStop:SENSITIVE = FALSE.

    END.

    ASSIGN
      buRun:SENSITIVE = TRUE
      glStop          = FALSE
      .

    IF glStopped THEN
      RUN destroyObject.

  END.    /* with frame ... */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMRUList wWin 
PROCEDURE setMRUList :
/*------------------------------------------------------------------------------
  Purpose:     Adds the most recently opened file to the User profile data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plGetDescription AS LOGICAL    NO-UNDO.

DEFINE VARIABLE iPos           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cListItems     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileData   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewProfile    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectDesc    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryPosition AS CHARACTER  NO-UNDO.

/* Maximum number of Most recent items to store and display in combo-box */
&SCOPED-DEFINE MAX_MRU_ITEMS 15

IF plGetDescription AND VALID-HANDLE(ghrycSmartObject) THEN
DO:
  DYNAMIC-FUNC('removeQuerySelection':U IN ghRycSmartObject,'object_type_obj':U,'EQ':U).
  DYNAMIC-FUNC('assignQuerySelection':U IN ghRycSmartObject,'object_filename':U,pcObjectName,'EQ':U).
    
    /* open the new query  */
  DYNAMIC-FUNCTION('openQuery':U IN ghRycSmartObject).
    
  {get QueryPosition cQueryPosition ghRycSmartObject}. /* any data? */
  IF cQueryPosition <> 'NoRecordAvailable':U THEN 
  DO:   
    cObjectDesc = TRIM(DYNAMIC-FUNCTION("ColumnStringValue":U IN  ghRycSmartObject,"object_description":U)) .
  END.
END.

ASSIGN 
  cListitems = coHistory:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME}.


/* If the object is already in the list, put the object at the top of the list */
IF pcObjectName > "" THEN
   cProfileData = pcObjectName + FILL(" ":u, MAX(2,INTEGER((150 - FONT-TABLE:GET-TEXT-WIDTH-P(pcObjectName)) / 3)))
                               + cObjectDesc + CHR(3) + pcObjectName.
/*   cProfileData = pcObjectName + "  /  ":U + cObjectDesc + CHR(3) + pcObjectName.*/

IF cListItems > "" THEN
DO:
  DO ipos = 2 TO MIN({&MAX_MRU_ITEMS} * 2,NUM-ENTRIES(cListItems,CHR(3))) BY 2:
     IF ENTRY(iPos,cListItems,CHR(3)) = pcObjectName THEN
       NEXT.
     ELSE
       cProfileData = cProfileData + (IF cProfileData = "" THEN "" ELSE CHR(3))
                          + ENTRY(iPos - 1,cListItems,CHR(3)) + CHR(3) + ENTRY(iPos,cListItems,CHR(3)).
  END.
  /* Ensure the profile data doesn't have more than the maximum number of items allowed */
  IF NUM-ENTRIES(cProfileData,CHR(3)) >  {&MAX_MRU_ITEMS} * 2 THEN
  DO:
    DO iPos = 1 TO {&MAX_MRU_ITEMS} * 2:
       cNewProfile = cNewProfile + (IF cNewProfile = "" THEN "" ELSE CHR(3)) 
                        + ENTRY(iPos,cProfileData,CHR(3)).
    END.
    ASSIGN cProfileData =  cNewProfile.
  END.
END.

RUN setProfileData IN gshProfileManager (INPUT "General":U,        /* Profile type code */
                                         INPUT "DispRepos":U,  /* Profile code */
                                         INPUT "DynLauncherMRU",     /* Profile data key */
                                         INPUT ?,                 /* Rowid of profile data */
                                         INPUT cProfileData,      /* Profile data value */
                                         INPUT NO,                /* Delete flag */
                                         INPUT "PER":u).          /* Save flag (permanent) */

ASSIGN coHistory:LIST-ITEM-PAIRS  = cProfileData NO-ERROR.

buClearMRU:SENSITIVE = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkAB wWin 
FUNCTION checkAB RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE h        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hObj     AS HANDLE     NO-UNDO.
 ASSIGN hObj = SESSION:FIRST-PROCEDURE.
 DO WHILE VALID-HANDLE(hObj):
   IF ENTRY(NUM-ENTRIES(hObj:FILE-NAME,'.':U),hObj:FILE-NAME,'.':U) = 'ab' THEN
      RETURN FALSE.
   hObj = hObj:NEXT-SIBLING.
 END. 

 RETURN TRUE.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkADM wWin 
FUNCTION checkADM RETURNS CHARACTER
  (pcCheck AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hObj     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cSupers  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSuper   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjType AS CHARACTER  NO-UNDO.

 ASSIGN hObj = SESSION:FIRST-PROCEDURE.
 ProcLoop:
 DO WHILE VALID-HANDLE(hObj):
   ASSIGN 
     cSupers  = hObj:SUPER-PROCEDURES.
     cObjType = ''.

   IF hObj <> ghRycSmartObject THEN
   DO:
     IF CAN-DO(xcADMdestroy,hObj:FILE-NAME) THEN 
       cObjType = {fn getObjectType hObj} NO-ERROR.
  
     IF cObjType <> 'SUPER' THEN
     DO i = 1 TO NUM-ENTRIES(cSupers):
       hSuper= WIDGET-HANDLE(ENTRY(i,cSupers)).
       
       IF (pccheck = '':u 
           OR ENTRY(NUM-ENTRIES(hObj:FILE-NAME,'.':U),hObj:FILE-NAME,'.':U) = pcCheck)
       AND CAN-DO(xcADMdestroy,hSuper:FILE-NAME) THEN
       DO:
         cList = cList + (IF clist = '' THEN '' ELSE ', ') + hObj:FILE-NAME. 
         LEAVE. 
       END.
     END.
   END.

   hObj = hObj:NEXT-SIBLING.
 END. 
 
 IF INDEX(cList,',') > 0 THEN
   SUBSTR(cList,R-INDEX(cList,','),1) = ' and'.
 
 RETURN cList.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyADM wWin 
FUNCTION destroyADM RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE h      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hSuper AS HANDLE     NO-UNDO.

 ASSIGN hSuper = SESSION:FIRST-PROCEDURE.
 DO WHILE VALID-HANDLE(hSuper) WITH DOWN:
   h = hSuper:NEXT-SIBLING. 
   IF CAN-DO(xcADMdestroy,hSuper:FILE-NAME) THEN 
   DO:
      /* cDeleted = cDeleted + chr(10) + hSuper:FILE-NAME. */
     DELETE PROCEDURE hSuper.     
   END.
   ASSIGN hSuper = h.   
 END.
 return TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitialFileName wWin 
FUNCTION getInitialFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: To send the file-name entered to the Open Object browse, so that it may 
          filter on it initially.
    Notes:  
------------------------------------------------------------------------------*/
  
  RETURN fiFile:SCREEN-VALUE IN FRAME {&FRAME-NAME}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenObjectFilter wWin 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
 (   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDynWindows    AS CHARACTER  NO-UNDO.


ASSIGN
  cDynWindows = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, "DynFold,DynObjc,DynMenc,DynTree":U)
  cDynWindows = REPLACE(cDynWindows,CHR(3),",").
  
RETURN cDynWindows.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowHandle wWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN {&WINDOW-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

