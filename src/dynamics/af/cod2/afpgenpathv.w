&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*------------------------------------------------------------------------

  File:        ryclcstatusv.w
               This object viewer has a editor box to display the status
               of client cache generation.
               
  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:      Edsel Garcia
  Created:     11/23/2004

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
/* ***************************  Definitions  ************************** */

&scop object-name       ryclientcachelogv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes
{src/adm2/globals.i}

DEFINE VARIABLE ghContainerSource AS HANDLE     NO-UNDO.

DEFINE VARIABLE cUserLogin AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-5 btnBrowseLogFilename ~
fiLogFileName btnViewLogFile btnBrowseTargetLocation fiTargetLocation ~
btnBrowseHookProcedure fiHookProcedure toCompile btnBrowseRcodeLocation ~
fiRcodeLocation 
&Scoped-Define DISPLAYED-OBJECTS fiLogFileName fiTargetLocation ~
fiHookProcedure toCompile fiRcodeLocation 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnBrowseHookProcedure 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "Browse..." 
     CONTEXT-HELP-ID 0
     SIZE 6 BY 1.14.

DEFINE BUTTON btnBrowseLogFilename 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "Browse..." 
     CONTEXT-HELP-ID 0
     SIZE 6 BY 1.14.

DEFINE BUTTON btnBrowseRcodeLocation 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "Browse..." 
     CONTEXT-HELP-ID 0
     SIZE 6 BY 1.14.

DEFINE BUTTON btnBrowseTargetLocation 
     IMAGE-UP FILE "adeicon/open.bmp":U
     LABEL "Browse..." 
     CONTEXT-HELP-ID 0
     SIZE 6 BY 1.14.

DEFINE BUTTON btnViewLogFile 
     LABEL "View log file" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14 TOOLTIP "Open the log file using notepad".

DEFINE VARIABLE fiHookProcedure AS CHARACTER FORMAT "X(255)":U 
     LABEL "Hook procedure" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 TOOLTIP "The path to the generation procedure" NO-UNDO.

DEFINE VARIABLE fiLogFileName AS CHARACTER FORMAT "X(255)":U 
     LABEL "Log file name" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 TOOLTIP "The path to the file where the log entries are to be written" NO-UNDO.

DEFINE VARIABLE fiRcodeLocation AS CHARACTER FORMAT "X(255)":U 
     LABEL "Rcode location" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN NATIVE 
     SIZE 58 BY 1 TOOLTIP "The path to the directory where the static objects are compiled" NO-UNDO.

DEFINE VARIABLE fiTargetLocation AS CHARACTER FORMAT "X(255)":U 
     LABEL "Target location" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 TOOLTIP "The path to the directory where the static objects are to be written" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY 1.86.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 108 BY 3.81.

DEFINE VARIABLE toCompile AS LOGICAL INITIAL no 
     LABEL "Compile" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 11.75 BY .81 TOOLTIP "Compile objects while generating" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnBrowseLogFilename AT ROW 1.43 COL 78.2
     fiLogFileName AT ROW 1.52 COL 18 COLON-ALIGNED
     btnViewLogFile AT ROW 1.52 COL 85.6
     btnBrowseTargetLocation AT ROW 2.52 COL 78.2
     fiTargetLocation AT ROW 2.62 COL 18 COLON-ALIGNED
     btnBrowseHookProcedure AT ROW 3.62 COL 78.2
     fiHookProcedure AT ROW 3.71 COL 18 COLON-ALIGNED
     toCompile AT ROW 5.1 COL 3.6
     btnBrowseRcodeLocation AT ROW 5.67 COL 78.2
     fiRcodeLocation AT ROW 5.76 COL 18 COLON-ALIGNED
     RECT-1 AT ROW 5.33 COL 2
     RECT-5 AT ROW 1.24 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 21.19
         WIDTH              = 142.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       toCompile:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btnBrowseHookProcedure
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowseHookProcedure sObject
ON CHOOSE OF btnBrowseHookProcedure IN FRAME F-Main /* Browse... */
DO:
  DEFINE VARIABLE cFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAnswer   AS LOGICAL    NO-UNDO.

  cFilename = fiHookProcedure:SCREEN-VALUE.
  SYSTEM-DIALOG GET-FILE
      cFilename
      TITLE "Select Hook Procedure"
      FILTERS "*.p" "*.p"
      MUST-EXIST
      USE-FILENAME
      UPDATE lAnswer.
  IF lAnswer THEN
      fiHookProcedure:SCREEN-VALUE = cFilename.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrowseLogFilename
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowseLogFilename sObject
ON CHOOSE OF btnBrowseLogFilename IN FRAME F-Main /* Browse... */
DO:
  DEFINE VARIABLE cFilename AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAnswer   AS LOGICAL    NO-UNDO.

  cFilename = fiLogFilename:SCREEN-VALUE.
  SYSTEM-DIALOG GET-FILE
      cFilename
      TITLE "Select Log File"
      FILTERS "*.txt" "*.txt", "*.log" "*.log"
      USE-FILENAME
      UPDATE lAnswer.
  IF lAnswer THEN
      fiLogFilename:SCREEN-VALUE = cFilename.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrowseRcodeLocation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowseRcodeLocation sObject
ON CHOOSE OF btnBrowseRcodeLocation IN FRAME F-Main /* Browse... */
DO:
    DEFINE VARIABLE cTargetLocation AS CHARACTER  NO-UNDO.

    cTargetLocation = fiRcodeLocation:SCREEN-VALUE.
    RUN getFolderName(INPUT-OUTPUT cTargetLocation).
    IF cTargetLocation > "" THEN
        fiRcodeLocation:SCREEN-VALUE = cTargetLocation.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBrowseTargetLocation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBrowseTargetLocation sObject
ON CHOOSE OF btnBrowseTargetLocation IN FRAME F-Main /* Browse... */
DO:
    DEFINE VARIABLE cTargetLocation AS CHARACTER  NO-UNDO.

    cTargetLocation = fiTargetLocation:SCREEN-VALUE.
    RUN getFolderName(INPUT-OUTPUT cTargetLocation).
    IF cTargetLocation > "" THEN
        fiTargetLocation:SCREEN-VALUE = cTargetLocation.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnViewLogFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnViewLogFile sObject
ON CHOOSE OF btnViewLogFile IN FRAME F-Main /* View log file */
DO:
  DEFINE VARIABLE iResult AS INTEGER    NO-UNDO.

  FILE-INFO:FILE-NAME = fiLogFilename:SCREEN-VALUE.
  IF FILE-INFO:FULL-PATHNAME > "" THEN
      RUN launchExternalProcess IN gshSessionManager ( "notepad.exe " + fiLogFilename:SCREEN-VALUE,
                                                       ".",
                                                       1,
                                                       OUTPUT iResult).
  ELSE
      MESSAGE "Log file: " fiLogFilename:SCREEN-VALUE " was not found" VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toCompile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toCompile sObject
ON VALUE-CHANGED OF toCompile IN FRAME F-Main /* Compile */
DO:
  RUN setRcodeLocationSensitive.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCompileOption sObject 
PROCEDURE getCompileOption :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plCompile       AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRcodeLocation AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      plCompile = toCompile:CHECKED.
      pcRcodeLocation = fiRcodeLocation:SCREEN-VALUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolderName sObject 
PROCEDURE getFolderName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcFolderName    AS CHARACTER        NO-UNDO.

  DEFINE VARIABLE cOriginalFolderName           AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE hServer                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE hFolder                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE hParent                       AS COM-HANDLE       NO-UNDO.
  DEFINE VARIABLE iErrorCount                   AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cButtonPressed                AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cErrorText                    AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cFolder                       AS CHARACTER        NO-UNDO.

  ASSIGN
    cOriginalFolderName = pcFolderName.

  CREATE 'Shell.Application' hServer NO-ERROR.

  IF ERROR-STATUS:ERROR
  THEN
  DO WITH FRAME {&FRAME-NAME}:

    /* Inform user. */
    DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN
        cErrorText = cErrorText
                   + (IF NUM-ENTRIES(cErrorText, "~n":U) EQ 0 THEN "":U ELSE "~n":U)
                   + ERROR-STATUS:GET-MESSAGE(iErrorCount).
    END.    /* count error messages */
    RUN showMessages IN gshSessionManager
                    (INPUT  {aferrortxt.i 'AF' '40' '?' '?' "cErrorText" }
                    ,INPUT  "ERR"                                /* error type */
                    ,INPUT  "&OK"                                /* button list */
                    ,INPUT  "&OK"                                /* default button */ 
                    ,INPUT  "&OK"                                /* cancel button */
                    ,INPUT  "Error Creating Automation Server"   /* error window title */
                    ,INPUT  YES                                  /* display if empty */
                    ,INPUT  ?                                    /* container handle */ 
                    ,OUTPUT cButtonPressed                       /* button pressed */
                    ).
    RETURN.

  END.  /* Error. */

  ASSIGN
    hFolder = hServer:BrowseForFolder(CURRENT-WINDOW:HWND, "Select a folder to act as the root for any static objects generated", 0).

  IF VALID-HANDLE(hFolder)
  THEN DO:

    ASSIGN
      cFolder    = hFolder:TITLE
      hParent    = hFolder:ParentFolder
      iErrorCount = 0
      .

    REPEAT:
      IF iErrorCount >= hParent:Items:Count
      THEN DO:
        ASSIGN
          pcFolderName = "":U.
        LEAVE.
      END.
      ELSE
      IF hParent:Items:Item(iErrorCount):Name = cFolder
      THEN DO:
        ASSIGN
          pcFolderName = hParent:Items:Item(iErrorCount):Path.
        LEAVE.               
      END.
      ASSIGN
        iErrorCount = iErrorCount + 1.
    END.    /* repeat */

  END.    /* valid folder */
  ELSE
    ASSIGN
      pcFolderName = "":U.


  IF pcFolderName = "":U
  THEN
    ASSIGN
      pcFolderName = cOriginalFolderName.

  RELEASE OBJECT hParent NO-ERROR.
  RELEASE OBJECT hFolder NO-ERROR.
  RELEASE OBJECT hServer NO-ERROR.

  ASSIGN
    hParent = ?
    hFolder = ?
    hServer = ?
    .

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGeneratedFileRoot sObject 
PROCEDURE getGeneratedFileRoot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcGeneratedFileRoot AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
        pcGeneratedFileRoot = fiTargetLocation:SCREEN-VALUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHookProcedure sObject 
PROCEDURE getHookProcedure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pchookProcedure AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      pcHookProcedure = fiHookProcedure:SCREEN-VALUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogFilename sObject 
PROCEDURE getLogFilename :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcLogFileName AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
        pcLogFileName = fiLogFileName:SCREEN-VALUE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeData sObject 
PROCEDURE initializeData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCompileDirectory AS CHARACTER  NO-UNDO INITIAL ".":U.

  DO WITH FRAME {&FRAME-NAME}:
      cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                    INPUT "currentUserLogin":U,
                                    INPUT NO).

      RUN getClientCacheDir IN gshRepositoryManager (INPUT "ry-clc", OUTPUT cCompileDirectory) NO-ERROR.
      cCompileDirectory = cCompileDirectory + "/gen":U.

      ASSIGN fiLogFilename:SCREEN-VALUE            = IF cUserLogin > "" THEN
                                                         SESSION:TEMP-DIRECTORY + cUserLogin + "_pgenlog.txt"
                                                     ELSE
                                                         SESSION:TEMP-DIRECTORY + "pgenlog.txt"
             FILE-INFO:FILE-NAME                   = ".":U
             fiTargetLocation:SCREEN-VALUE         = FILE-INFO:FULL-PATHNAME
             fiHookProcedure:SCREEN-VALUE          = "ry/app/rygen4glhp.p"
             fiRcodeLocation:SCREEN-VALUE          = REPLACE(cCompileDirectory, "~/":U, "\":U).

      ASSIGN toCompile:CHECKED = FALSE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN initializeData IN TARGET-PROCEDURE.
  
  ENABLE ALL WITH FRAME F-main.
  RUN setRCodeLocationSensitive.

  IF VALID-HANDLE(ghContainerSource) THEN
  DO:
      SUBSCRIBE TO "getLogFilename":U            IN ghContainerSource.
      SUBSCRIBE TO "getHookProcedure":U          IN ghContainerSource.
      SUBSCRIBE TO "getGeneratedFileRoot":U      IN ghContainerSource.
      SUBSCRIBE TO "validateGeneratePage":U      IN ghContainerSource.
      SUBSCRIBE TO "getCompileOption":U          IN ghContainerSource.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

  /* Code placed here will execute AFTER standard behavior.    */

  /* Set the handle of the container source immediately upon making the link */
  IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
     ASSIGN ghContainerSource = phObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight             AS DECIMAL          NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth              AS DECIMAL          NO-UNDO.

  DEFINE VARIABLE iCurrentPage                AS INTEGER          NO-UNDO.
  DEFINE VARIABLE lHidden                     AS LOGICAL          NO-UNDO.  

  DEFINE VARIABLE hLabelHandle                AS HANDLE           NO-UNDO.

  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRcodeLocationSensitive sObject 
PROCEDURE setRcodeLocationSensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      IF toCompile:CHECKED THEN
          ASSIGN fiRcodeLocation:SENSITIVE = TRUE
                 btnBrowseRcodeLocation:SENSITIVE = TRUE.
      ELSE
          ASSIGN fiRcodeLocation:SENSITIVE = FALSE
                 btnBrowseRcodeLocation:SENSITIVE = FALSE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateGeneratePage sObject 
PROCEDURE validateGeneratePage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      IF fiTargetLocation:SCREEN-VALUE = "" THEN
          RETURN "A target directory has not been specified".
      IF fiLogFileName:SCREEN-VALUE = "" THEN
          RETURN "A log file name has not been specified".
      IF fiHookProcedure:SCREEN-VALUE = "" THEN
          RETURN "A hook procedure has not been specified".
      IF toCompile:CHECKED AND fiRcodeLocation:SCREEN-VALUE = "" THEN
          RETURN "An rcode directory has not been specified".
  END.
  RETURN "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

