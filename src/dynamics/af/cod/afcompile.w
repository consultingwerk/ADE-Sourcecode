&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME WI_COMPILE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WI_COMPILE 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 30/03/95 -  9:46 am

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

  DEFINE STREAM ST_1.
  DEFINE VARIABLE LV_STOP AS LOGICAL NO-UNDO.

DEFINE STREAM ls_output.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FR_COMPILE

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi_directory to_recurse ED_RESULTS BU_EXIT ~
BU_START bu_delete_rcode 
&Scoped-Define DISPLAYED-OBJECTS fi_directory to_recurse ED_RESULTS 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WI_COMPILE AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bu_delete_rcode 
     LABEL "&Delete R-code" 
     SIZE 19.6 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BU_EXIT DEFAULT 
     LABEL "E&xit" 
     SIZE 10 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BU_START DEFAULT 
     LABEL "&Start" 
     SIZE 10 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON BU_STOP 
     LABEL "S&top" 
     SIZE 10 BY 1.14.

DEFINE VARIABLE ED_RESULTS AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 76.8 BY 9.52 NO-UNDO.

DEFINE VARIABLE fi_directory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Start Directory" 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1 TOOLTIP "Specify the directory to start searching for files from" NO-UNDO.

DEFINE VARIABLE to_recurse AS LOGICAL INITIAL yes 
     LABEL "Recurse Sub-directories" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.4 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FR_COMPILE
     fi_directory AT ROW 1.48 COL 16 COLON-ALIGNED
     to_recurse AT ROW 2.81 COL 17
     ED_RESULTS AT ROW 3.95 COL 1.8 NO-LABEL
     BU_EXIT AT ROW 13.67 COL 1.8
     BU_START AT ROW 13.67 COL 12.6
     BU_STOP AT ROW 13.67 COL 23.4
     bu_delete_rcode AT ROW 13.67 COL 58.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.8 BY 14.14
         DEFAULT-BUTTON BU_EXIT.


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
  CREATE WINDOW WI_COMPILE ASSIGN
         HIDDEN             = YES
         TITLE              = "Compile Task Directory"
         COLUMN             = 45.2
         ROW                = 7
         HEIGHT             = 14.14
         WIDTH              = 78.8
         MAX-HEIGHT         = 14.14
         MAX-WIDTH          = 78.8
         VIRTUAL-HEIGHT     = 14.14
         VIRTUAL-WIDTH      = 78.8
         RESIZE             = yes
         SCROLL-BARS        = yes
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
/* SETTINGS FOR WINDOW WI_COMPILE
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FR_COMPILE
                                                                        */
/* SETTINGS FOR BUTTON BU_STOP IN FRAME FR_COMPILE
   NO-ENABLE                                                            */
ASSIGN 
       ED_RESULTS:READ-ONLY IN FRAME FR_COMPILE        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WI_COMPILE)
THEN WI_COMPILE:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FR_COMPILE
/* Query rebuild information for FRAME FR_COMPILE
     _Query            is NOT OPENED
*/  /* FRAME FR_COMPILE */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bu_delete_rcode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bu_delete_rcode WI_COMPILE
ON CHOOSE OF bu_delete_rcode IN FRAME FR_COMPILE /* Delete R-code */
DO:
  RUN delete-rcode.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BU_EXIT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BU_EXIT WI_COMPILE
ON CHOOSE OF BU_EXIT IN FRAME FR_COMPILE /* Exit */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BU_START
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BU_START WI_COMPILE
ON CHOOSE OF BU_START IN FRAME FR_COMPILE /* Start */
DO:
  RUN COMPILE_FILES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BU_STOP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BU_STOP WI_COMPILE
ON CHOOSE OF BU_STOP IN FRAME FR_COMPILE /* Stop */
DO:
  ASSIGN LV_STOP = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WI_COMPILE 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fi_directory:SCREEN-VALUE = ENTRY(1,PROPATH)
           to_recurse:SCREEN-VALUE = "YES":U.
  END.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-directory-list WI_COMPILE 
PROCEDURE build-directory-list :
/*------------------------------------------------------------------------------
  Purpose:     Output a list of Progress files for the specified extensions for the
               passed in directory and all its sub-directories. Only returns
               files that are procedures, or windows ! 
  Parameters:  INPUT    ip_directory
               OUTPUT   op_file_list
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  ip_directory    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  ip_recurse      AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  ip_extensions   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_file_list    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         lv_batchfile    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_outputfile   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_filename     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_line_numbers AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_line_texts   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_recurse      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_loop         AS INTEGER      NO-UNDO.

/* Write batch file to do a directory listing of all files in
   the directory tree specified */
ASSIGN
    lv_batchfile  = SESSION:TEMP-DIRECTORY + "dir.bat":U
    lv_outputfile = SESSION:TEMP-DIRECTORY + "dir.log":U
    ip_directory = LC(TRIM(REPLACE(ip_directory,"/":U,"~\":U)))
    lv_recurse = (IF ip_recurse = YES THEN "/s ":U ELSE " ":U).

OUTPUT TO VALUE(lv_batchfile).
DO lv_loop = 1 TO NUM-ENTRIES(ip_extensions):
    PUT UNFORMATTED "dir /b/l/on":U +
                    lv_recurse +
                    ip_directory + 
                    "~\*.":U +
                    ENTRY(lv_loop, ip_extensions) +
                    (IF lv_loop = 1 THEN " > ":U ELSE " >> ":U) +
                    lv_outputfile
                    SKIP.
END.

OUTPUT CLOSE.

/* Execute batch file */
OS-COMMAND SILENT VALUE(lv_batchfile).

/* Check result */
IF SEARCH(lv_outputfile) <> ? THEN
  DO:
    INPUT STREAM ls_output FROM VALUE(lv_outputfile) NO-ECHO.
    REPEAT:
        IMPORT STREAM ls_output UNFORMATTED lv_filename.
        IF ip_recurse  = NO THEN ASSIGN lv_filename = ip_directory + "~\":U + lv_filename.
        ASSIGN
            op_file_list =  op_file_list +
                            (IF NUM-ENTRIES(op_file_list) > 0 THEN ",":U ELSE "":U) +
                            LC(TRIM(lv_filename)).
    END.
    INPUT STREAM ls_output CLOSE.
  END.

/* Delete temp files */
OS-DELETE VALUE(lv_batchfile).
OS-DELETE VALUE(lv_outputfile). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE COMPILE_FILES WI_COMPILE 
PROCEDURE COMPILE_FILES :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

DEFINE VARIABLE lv_file_list AS CHARACTER NO-UNDO.
DEFINE VARIABLE LV_FILE AS CHARACTER FORMAT "X(70)" NO-UNDO.
DEFINE VARIABLE LV_EXTENSION AS CHARACTER FORMAT "X(1)" NO-UNDO.
DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN fi_directory
         to_recurse.

  DISABLE BU_START BU_EXIT.
  ENABLE BU_STOP.
  ASSIGN LV_STOP = NO.

    /* Turn on egg-timer */
    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    /* Get a list of structured includes, procedures, and windows to process */
    RUN build-directory-list (INPUT fi_directory, INPUT to_recurse, INPUT "w,p":U, OUTPUT lv_file_list).

    /* Turn off egg-timer */
    IF SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

/* Work on each file */
  DO lv_loop = 1 TO NUM-ENTRIES(lv_file_list):
    IF lv_stop = YES THEN LEAVE.

    ASSIGN lv_file = ENTRY(lv_loop,lv_file_list)

    FILE-INFO:FILE-NAME = LV_FILE.
    IF FILE-INFO:FILE-TYPE BEGINS "F" THEN
      DO:
        ASSIGN LV_EXTENSION = SUBSTRING(LV_FILE,(INDEX(LV_FILE,".") + 1),2).
        IF LV_EXTENSION = "P" OR LV_EXTENSION = "W" THEN
          DO WITH FRAME {&FRAME-NAME}:
             IF ED_RESULTS:INSERT-STRING("Compiling " + TRIM(LV_FILE) + "~n") THEN .
             COMPILE VALUE(LV_FILE) SAVE.
          END.
      END.
    WAIT-FOR "CHOOSE" OF BU_STOP PAUSE 0.
  END.
  IF ED_RESULTS:INSERT-STRING("Finished " + "~n") THEN .

  ENABLE BU_EXIT
         BU_START.
  DISABLE BU_STOP.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-rcode WI_COMPILE 
PROCEDURE delete-rcode :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

DEFINE VARIABLE lv_file_list AS CHARACTER NO-UNDO.
DEFINE VARIABLE LV_FILE AS CHARACTER FORMAT "X(70)" NO-UNDO.
DEFINE VARIABLE LV_EXTENSION AS CHARACTER FORMAT "X(1)" NO-UNDO.
DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN fi_directory
         to_recurse.

  DISABLE BU_START BU_EXIT.
  ENABLE BU_STOP.
  ASSIGN LV_STOP = NO.

    /* Turn on egg-timer */
    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    /* Get a list of structured includes, procedures, and windows to process */
    RUN build-directory-list (INPUT fi_directory, INPUT to_recurse, INPUT "r":U, OUTPUT lv_file_list).

    /* Turn off egg-timer */
    IF SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

/* Work on each file */
  DO lv_loop = 1 TO NUM-ENTRIES(lv_file_list):
    IF lv_stop = YES THEN LEAVE.

    ASSIGN lv_file = ENTRY(lv_loop,lv_file_list).
    IF ED_RESULTS:INSERT-STRING("Deleting " + TRIM(LV_FILE) + "~n") THEN .
    OS-DELETE VALUE(lv_file).

    WAIT-FOR "CHOOSE" OF BU_STOP PAUSE 0.
  END.
  IF ED_RESULTS:INSERT-STRING("Finished " + "~n") THEN .

  ENABLE BU_EXIT
         BU_START.
  DISABLE BU_STOP.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WI_COMPILE  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WI_COMPILE)
  THEN DELETE WIDGET WI_COMPILE.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WI_COMPILE  _DEFAULT-ENABLE
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
  DISPLAY fi_directory to_recurse ED_RESULTS 
      WITH FRAME FR_COMPILE IN WINDOW WI_COMPILE.
  ENABLE fi_directory to_recurse ED_RESULTS BU_EXIT BU_START bu_delete_rcode 
      WITH FRAME FR_COMPILE IN WINDOW WI_COMPILE.
  {&OPEN-BROWSERS-IN-QUERY-FR_COMPILE}
  VIEW WI_COMPILE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

