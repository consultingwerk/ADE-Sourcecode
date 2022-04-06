&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/ryemptysdo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: ryoscompilev.w

  Description:  

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2003  Author:     

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryoscompilev.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{src/adm2/widgetprto.i}

DEFINE VARIABLE glStop              AS LOGICAL    NO-UNDO.

DEFINE STREAM stInput.
DEFINE STREAM stOutput.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/ryemptysdo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buStartPath coStartPath fcStartPath ~
toRecurse edResults buDeleteRcode buCompile 
&Scoped-Define DISPLAYED-OBJECTS coStartPath fcStartPath toRecurse ~
edResults 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buCompile DEFAULT 
     LABEL "&Start Compile" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeleteRcode 
     LABEL "&Delete R-code" 
     SIZE 18 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buStartPath 
     IMAGE-UP FILE "ry/img/afopen.gif":U
     LABEL "" 
     SIZE 5 BY 1.1 TOOLTIP "Choose directory"
     BGCOLOR 8 .

DEFINE BUTTON buStop 
     LABEL "S&top" 
     SIZE 18 BY 1.14.

DEFINE VARIABLE coStartPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Start Directory" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE edResults AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 120 BY 12 NO-UNDO.

DEFINE VARIABLE fcStartPath AS CHARACTER FORMAT "X(200)":U 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 61.4 BY 1 NO-UNDO.

DEFINE VARIABLE toRecurse AS LOGICAL INITIAL yes 
     LABEL "Recurse Sub-directories" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buStartPath AT ROW 1.05 COL 83
     coStartPath AT ROW 1.1 COL 15 COLON-ALIGNED
     fcStartPath AT ROW 1.1 COL 15 COLON-ALIGNED NO-LABEL
     toRecurse AT ROW 1.1 COL 90
     edResults AT ROW 2.52 COL 2.8 NO-LABEL
     buDeleteRcode AT ROW 15 COL 65
     buCompile AT ROW 15 COL 85
     buStop AT ROW 15 COL 105
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/ryemptysdo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/ryemptysdo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 16
         WIDTH              = 125.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buStop IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       edResults:READ-ONLY IN FRAME frMain        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buCompile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCompile vTableWin
ON CHOOSE OF buCompile IN FRAME frMain /* Start Compile */
DO:

  RUN processObjects (INPUT "COMPILE").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeleteRcode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeleteRcode vTableWin
ON CHOOSE OF buDeleteRcode IN FRAME frMain /* Delete R-code */
DO:

  RUN processObjects (INPUT "DELETE R-CODE").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buStartPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buStartPath vTableWin
ON CHOOSE OF buStartPath IN FRAME frMain
DO:

  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.

  RUN getFolder("Directory", OUTPUT cDirectory).

  IF cDirectory <> "":U
  THEN DO:

    ASSIGN
      fcStartPath              = cDirectory
      fcStartPath:SCREEN-VALUE = fcStartPath
      .

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buStop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buStop vTableWin
ON CHOOSE OF buStop IN FRAME frMain /* Stop */
DO:
  ASSIGN glStop = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coStartPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coStartPath vTableWin
ON ENTRY OF coStartPath IN FRAME frMain /* Start Directory */
DO:
   IF LAST-EVENT:LABEL = "TAB":U OR LAST-EVENT:LABEL = "SHIFT-TAB":U THEN 
      RETURN NO-APPLY. 
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coStartPath vTableWin
ON VALUE-CHANGED OF coStartPath IN FRAME frMain /* Start Directory */
DO:

  ASSIGN
    fcStartPath:SCREEN-VALUE = SELF:SCREEN-VALUE.

  APPLY "VALUE-CHANGED":U TO fcStartPath. 

  IF  LAST-EVENT:LABEL <> "CURSOR-UP":U
  AND LAST-EVENT:LABEL <> "CURSOR-DOWN":U
  THEN
    APPLY "ENTRY":U TO fcStartPath.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fcStartPath
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fcStartPath vTableWin
ON F4 OF fcStartPath IN FRAME frMain
DO:

  DEFINE VARIABLE iReturnValue AS INTEGER NO-UNDO.

  &GLOBAL-DEFINE CB_SHOWDROPDOWN 335

  RUN SendMessageA(INPUT  coStartPath:HWND
                  ,{&CB_SHOWDROPDOWN}
                  ,1   /* True */
                  ,0
                  ,OUTPUT iReturnValue
                  )  NO-ERROR .

  APPLY "ENTRY":U TO coStartPath.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fcStartPath vTableWin
ON VALUE-CHANGED OF fcStartPath IN FRAME frMain
DO:

  /* Check whether directory is valid */
  FILE-INFO:FILE-NAME = SELF:SCREEN-VALUE NO-ERROR.
  IF FILE-INFO:FULL-PATHNAME = ?
  THEN
    ASSIGN
      SELF:FGCOLOR   = 7.
  ELSE
    ASSIGN
      SELF:FGCOLOR   = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder vTableWin 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     Use the COM interface Shell to browse for a folder
  Parameters:  pcTitle   Name of title to appear in browse folder
               pcPath    (OUTPUT) Returned path
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcTitle AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPath  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE chServer        AS COM-HANDLE NO-UNDO. /* shell application */
  DEFINE VARIABLE chFolder        AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chParent        AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin            AS HANDLE     NO-UNDO.

  ASSIGN
    hFrame = FRAME {&FRAME-NAME}:HANDLE
    hWin   = hFrame:WINDOW
    .

  /* create Shell Automation object */
  CREATE 'Shell.Application' chServer.

  IF NOT VALID-HANDLE(chServer)
  THEN RETURN "":U.
  /* automation object not present on system */

  ASSIGN
    chFolder = chServer:BrowseForFolder(hWin:HWND,pcTitle,3).

  /* see if user has selected a valid folder */
   IF VALID-HANDLE(chFolder)
   AND chFolder:SELF:IsFolder
   THEN
    ASSIGN
      pcPath = chFolder:SELF:Path.
   ELSE
    ASSIGN
      pcPath = "":U.

  RELEASE OBJECT chParent NO-ERROR.
  RELEASE OBJECT chFolder NO-ERROR.
  RELEASE OBJECT chServer NO-ERROR.

  ASSIGN
    chParent = ?
    chFolder = ?
    chServer = ?
    .

  ASSIGN
    pcPath = TRIM(REPLACE(LC(pcPath),"~\":U,"/":U),"~/":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPathEntry  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullPath   AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:

    DO iLoop = 1 TO NUM-ENTRIES(PROPATH):
      ASSIGN
        cPathEntry = ENTRY(iLoop,PROPATH).
      FILE-INFO:FILE-NAME = cPathEntry.
      IF  FILE-INFO:FILE-TYPE BEGINS "D"
      AND FILE-INFO:FULL-PATHNAME <> ?
      THEN DO:
        cFullPath = FILE-INFO:FULL-PATHNAME.
        coStartPath:ADD-LAST(cFullPath).
      END.
    END.

    IF fcStartPath = "":U
    AND coStartPath:NUM-ITEMS <> 0
    THEN
      ASSIGN
        coStartPath:SCREEN-VALUE = coStartPath:ENTRY(1)
        fcStartPath:SCREEN-VALUE = coStartPath:ENTRY(1)
        .

    APPLY "ENTRY":U TO fcStartPath.

    ASSIGN
      toRecurse:SCREEN-VALUE   = "YES":U.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processObjects vTableWin 
PROCEDURE processObjects :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ipProcessType AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFileBatch            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileOutput           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirectory            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecurse              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cObjectFullFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectBaseFileName   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFileExtension        AS CHARACTER  NO-UNDO FORMAT "X(1)".

  DEFINE VARIABLE iCountProcess         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCountError           AS INTEGER    NO-UNDO.

  DEFINE VARIABLE iErrorCount           AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cErrorMessage         AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      fcStartPath
      toRecurse.

    DISABLE
      buCompile.

    ENABLE
      buStop.

    ASSIGN
      glStop = NO.

    IF edResults:INSERT-STRING("~n") THEN .
    IF edResults:INSERT-STRING(ipProcessType + " : STARTED" + "~n") THEN .
    IF edResults:INSERT-STRING("~n") THEN .
    IF edResults:INSERT-STRING("  Start Directory : ":U + fcStartPath + "~n") THEN .
    IF edResults:INSERT-STRING("  Recurse Sub-Directories : ":U + STRING(toRecurse) + "~n") THEN .
    IF edResults:INSERT-STRING("~n") THEN .

    /* Turn on egg-timer */
    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    IF ipProcessType BEGINS "COMPILE":U
    THEN
      ASSIGN
        cFileExtension = "w,p":U.
    ELSE
    IF ipProcessType BEGINS "DELETE":U
    THEN
      ASSIGN
        cFileExtension = "r":U.

    /* Write batch file to do a directory listing of all files in the directory tree specified */
    ASSIGN
      cFileBatch  = SESSION:TEMP-DIRECTORY + "dir.bat":U
      cFileOutput = SESSION:TEMP-DIRECTORY + "dir.log":U
      cRecurse    = (IF toRecurse = YES THEN "/s ":U ELSE " ":U)
      cDirectory  = fcStartPath
      cDirectory  = LC(TRIM(REPLACE(cDirectory,"/":U,"~\":U)))
      .

    IF edResults:INSERT-STRING("  Building list of objects ...":U + "~n") THEN .

    OUTPUT STREAM stOutput TO VALUE(cFileBatch).
    DO iLoop = 1 TO NUM-ENTRIES(cFileExtension):
      PUT STREAM stOutput UNFORMATTED
          "dir /b/l/on":U
        + cRecurse
        + cDirectory
        + "~\*.":U
        + ENTRY(iLoop, cFileExtension)
        + (IF iLoop = 1 THEN " > ":U ELSE " >> ":U)
        + cFileOutput
        SKIP.
    END.
    OUTPUT STREAM stOutput CLOSE.

    /* Execute batch file */
    OS-COMMAND SILENT VALUE(cFileBatch).

    ASSIGN
      iCountProcess = 0
      iCountError   = 0
      .

    /* Turn off egg-timer */
    IF SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

    IF SEARCH(cFileOutput) <> ?
    THEN DO:

      INPUT STREAM stInput FROM VALUE(cFileOutput) NO-ECHO.

      blkFile:
      REPEAT:

        IF glStop = YES
        THEN DO:
          IF edResults:INSERT-STRING(ipProcessType + " : STOPPED" + "~n") THEN .
          LEAVE blkFile.
        END.

        IMPORT STREAM stInput UNFORMATTED
          cObjectFullFileName.

        ASSIGN
          cObjectFullFileName = (IF toRecurse = NO THEN cDirectory + "~\":U ELSE "":U)
                              + cObjectFullFileName
          cObjectFullFileName = TRIM(LC(cObjectFullFileName))
          .

        ASSIGN
          cObjectBaseFileName = cObjectFullFileName
          cObjectBaseFileName = REPLACE(cObjectBaseFileName,cDirectory,"":U)
          cObjectBaseFileName = TRIM(cObjectBaseFileName,"~\":U)
          .

        FILE-INFO:FILE-NAME = cObjectFullFileName.

        IF NOT FILE-INFO:FILE-TYPE BEGINS "F":U
        THEN NEXT blkFile.

        ASSIGN
          cFileExtension = SUBSTRING(cObjectFullFileName,(INDEX(cObjectFullFileName,".") + 1),2).

        /* COMPILE SECTION */
        ASSIGN
          cErrorMessage = "":U.

        IF ipProcessType BEGINS "COMPILE":U
        AND (cFileExtension = "P":U
          OR cFileExtension = "W":U)
        THEN DO:

          ASSIGN
            iCountProcess = iCountProcess + 1.

          IF edResults:INSERT-STRING("  " + STRING(iCountProcess,"zzzz9") + " - " + TRIM(cObjectBaseFileName) + "~n") THEN .

          COMPILE VALUE(cObjectFullFileName) SAVE NO-ERROR.

          IF COMPILER:ERROR
          THEN
          DO iErrorCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
            IF ERROR-STATUS:GET-MESSAGE(iErrorCount) <> "":U
            THEN
              ASSIGN
                cErrorMessage = cErrorMessage
                              + (IF cErrorMessage <> "":U THEN CHR(10) ELSE "":U)
                              + "        ":U + ERROR-STATUS:GET-MESSAGE(iErrorCount)
                              .
          END.

        END. /* "COMPILE":U */

        IF cErrorMessage <> "":U
        THEN DO:
          IF edResults:INSERT-STRING(cErrorMessage + "~n") THEN .
          ASSIGN
            iCountError   = iCountError + 1
            cErrorMessage = "":U
            .
        END.

        /* DELETE R-CODE SECTION */
        ASSIGN
          cErrorMessage = "":U.

        IF ipProcessType BEGINS "DELETE":U
        AND (cFileExtension = "R":U)
        THEN DO:

          ASSIGN
            iCountProcess = iCountProcess + 1.

          IF edResults:INSERT-STRING("  " + STRING(iCountProcess,"zzzz9") + " - " + TRIM(cObjectBaseFileName) + "~n") THEN .

          OS-DELETE VALUE(cObjectFullFileName).
          iErrorCount = OS-ERROR.
          IF iErrorCount <> 0
          THEN DO:
            ASSIGN
              cErrorMessage = cErrorMessage
                          + (IF cErrorMessage <> "":U THEN CHR(10) + "        ":U ELSE "":U).
            CASE iErrorCount:
              WHEN 0    THEN cErrorMessage = cErrorMessage + "** No error":U.
              WHEN 1    THEN cErrorMessage = cErrorMessage + "** Not owner":U.
              WHEN 2    THEN cErrorMessage = cErrorMessage + "** No such file or directory":U.
              WHEN 3    THEN cErrorMessage = cErrorMessage + "** Interrupted system call":U.
              WHEN 4    THEN cErrorMessage = cErrorMessage + "** I/O error":U.
              WHEN 5    THEN cErrorMessage = cErrorMessage + "** Bad file number":U.
              WHEN 6    THEN cErrorMessage = cErrorMessage + "** No more processes":U.
              WHEN 7    THEN cErrorMessage = cErrorMessage + "** Not enough core memory":U.
              WHEN 8    THEN cErrorMessage = cErrorMessage + "** Permission denied":U.
              WHEN 9    THEN cErrorMessage = cErrorMessage + "** Bad address":U.
              WHEN 10   THEN cErrorMessage = cErrorMessage + "** File exists":U.
              WHEN 11   THEN cErrorMessage = cErrorMessage + "** No such device":U.
              WHEN 12   THEN cErrorMessage = cErrorMessage + "** Not a directory":U.
              WHEN 13   THEN cErrorMessage = cErrorMessage + "** Is a directory":U.
              WHEN 14   THEN cErrorMessage = cErrorMessage + "** File table overflow":U.
              WHEN 15   THEN cErrorMessage = cErrorMessage + "** Too many open files":U.
              WHEN 16   THEN cErrorMessage = cErrorMessage + "** File too large":U.
              WHEN 17   THEN cErrorMessage = cErrorMessage + "** No space left on device":U.
              WHEN 18   THEN cErrorMessage = cErrorMessage + "** Directory not empty":U.
              WHEN 999  THEN cErrorMessage = cErrorMessage + "** Unmapped error (Progress default)":U.
              OTHERWISE DO:  cErrorMessage = cErrorMessage + "** OS Error #":U + STRING(OS-ERROR,"99").
              END.
            END CASE.
          END. /* iErrorCount <> 0 */

        END. /* "DELETE":U */

        IF cErrorMessage <> "":U
        THEN DO:
          IF edResults:INSERT-STRING(cErrorMessage + "~n") THEN .
          ASSIGN
            iCountError   = iCountError + 1
            cErrorMessage = "":U
            .
        END.

        WAIT-FOR "CHOOSE" OF buStop PAUSE 0.

      END. /* REPEAT */

      INPUT STREAM stInput CLOSE.

    END. /* SEARCH(cFileOutput) <> ? */
    ELSE DO:
      IF edResults:INSERT-STRING("  No objects found  ...":U + "~n") THEN .
    END.

    /* Delete temp files */
    OS-DELETE VALUE(cFileBatch).
    OS-DELETE VALUE(cFileOutput). 

    IF edResults:INSERT-STRING("~n") THEN .

    IF iCountProcess = 0
    THEN DO:
      IF edResults:INSERT-STRING("      No Objects processed" + "~n") THEN .
    END.
    ELSE DO:
      IF edResults:INSERT-STRING("  " + STRING(iCountProcess,"zzzz9") + " Objects processed" + "~n") THEN .
    END.
    IF iCountError <> 0
    THEN DO:
      IF edResults:INSERT-STRING("  " + STRING(iCountError,"zzzz9") + " Objects processed with Error" + "~n") THEN .
    END.

    IF edResults:INSERT-STRING("~n") THEN .
    IF edResults:INSERT-STRING(ipProcessType + " : FINISHED" + "~n") THEN .
    IF edResults:INSERT-STRING("~n") THEN .

    ENABLE
      buCompile.

    DISABLE
      buStop.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

