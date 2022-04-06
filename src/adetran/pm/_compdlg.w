&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          xlatedb          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File    :    _compdlg.w
  Purpose :    Tran Man II Compile Dialog Box.
  Syntax  :
            RUN adetran/pm/_compdlg.w.

  Description:
    Use the Compile dialog box to compile application code.

  Input Parameters:

  Output Parameters:

  Author:    J. Palazzo, R. Ryan

  Created: June, 1995
  Updated: 07/97 SLK Bug# 97-04-30-022 Cannot find file if . used
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters and Shared Definitions ---                                */
&IF DEFINED(UIB_is_Running) <> 0 &THEN
define new shared var _hMeter as handle no-undo.
define new shared var StopProcessing as logical no-undo.
&ELSE
define shared var _hMeter as handle no-undo.
define shared var StopProcessing as logical no-undo.
&ENDIF


/* Local Variable Definitions ---                                       */

/* ADE Internationalization Standards. */
{ adecomm/adeintl.i }

/* TranMan Help Context IDs. */
{ adetran/pm/tranhelp.i }

&SCOPED-DEFINE EOL     CHR(10)

DEFINE STREAM Comp_Stream.

DEFINE VAR Comp_Log    AS CHARACTER NO-UNDO INIT "compile.log".
DEFINE VAR Msg_Line    AS CHARACTER NO-UNDO.

DEFINE VAR Result      AS LOGICAL   NO-UNDO.
DEFINE VAR OptionState AS LOGICAL   NO-UNDO INIT FALSE.
DEFINE VAR i           AS INTEGER   NO-UNDO.
DEFINE VAR NumProcs    AS INTEGER   NO-UNDO.
DEFINE VAR ThisRec     AS INTEGER   NO-UNDO.
DEFINE VAR Temp_Log    AS CHARACTER NO-UNDO.
DEFINE VAR File_Name   AS CHARACTER NO-UNDO.
DEFINE VAR Dir_Name    AS CHARACTER NO-UNDO.
DEFINE VAR Rcode_Name  AS CHARACTER NO-UNDO.
DEFINE VAR Full_Name   AS CHARACTER NO-UNDO.
DEFINE VAR Source_Dir  AS CHARACTER NO-UNDO.

DEFINE VAR Dlg_FullH   AS INTEGER   NO-UNDO. /* Full Height of Dialog */
DEFINE VAR Dlg_ShortH  AS INTEGER   NO-UNDO. /* Short Height of Dialog */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES xlatedb.XL_Procedure

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 ~
xlatedb.XL_Procedure.Directory + "~\":U + xlatedb.XL_Procedure.FileName
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH xlatedb.XL_Procedure NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 xlatedb.XL_Procedure
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 xlatedb.XL_Procedure


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ContainerRectangle1 IMAGE-1 RECT-1 BtnOK ~
Languages BtnCancel Growth BtnHelp SaveInto BtnOptions ReplaceRCode SaveLog ~
BROWSE-1 OptionsLabel OptionsLabel-2 FilesLabel
&Scoped-Define DISPLAYED-OBJECTS Languages Growth SaveInto ReplaceRCode ~
SaveLog OptionsLabel LangLabel OptionsLabel-2 FilesLabel

/* Custom List Definitions                                              */
/* OPTIONAL-FIELDS,List-2,List-3,List-4,List-5,List-6                   */
&Scoped-define OPTIONAL-FIELDS RECT-1 BROWSE-1 OptionsLabel-2 FilesLabel

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY
     LABEL "Cancel":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp
     LABEL "&Help":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO
     LABEL "OK":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOptions
     LABEL "&Options >>":L
     SIZE 15 BY 1.14.

DEFINE VARIABLE FilesLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Select &Files:"
      VIEW-AS TEXT
     SIZE 45.8 BY .67 NO-UNDO.

DEFINE VARIABLE Growth AS INTEGER FORMAT ">,>>9%":U INITIAL 50
     LABEL "&Growth Table"
     VIEW-AS FILL-IN
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE LangLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Languages:"
      VIEW-AS TEXT
     SIZE 12.4 BY .67 NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Compiler"
      VIEW-AS TEXT
     SIZE 10.6 BY .67 NO-UNDO.

DEFINE VARIABLE OptionsLabel-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Options"
      VIEW-AS TEXT
     SIZE 8.4 BY .67 NO-UNDO.

DEFINE VARIABLE SaveInto AS CHARACTER FORMAT "x(256)":U
     LABEL "&Save Into"
     VIEW-AS FILL-IN NATIVE
     SIZE 37 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adetran/images/vert-inc":U
     SIZE 3.6 BY 1.38.

DEFINE RECTANGLE ContainerRectangle1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 60 BY 7.14.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 60 BY 5.67.

DEFINE VARIABLE Languages AS CHARACTER
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL
     SIZE 37 BY 1.67 NO-UNDO.

DEFINE VARIABLE ReplaceRCode AS LOGICAL INITIAL yes
     LABEL "&Replace .r Code If Exists"
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .67 NO-UNDO.

DEFINE VARIABLE SaveLog AS LOGICAL INITIAL yes
     LABEL "Save &Compile Log"
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .67 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR
      xlatedb.XL_Procedure SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 Dialog-Frame _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      xlatedb.XL_Procedure.Directory + "~\":U + xlatedb.XL_Procedure.FileName FORMAT "X(80)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 53 BY 3.67
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.71 COL 68
     Languages AT ROW 1.95 COL 21 NO-LABEL
     BtnCancel AT ROW 2.91 COL 68
     Growth AT ROW 3.91 COL 19 COLON-ALIGNED
     BtnHelp AT ROW 4.19 COL 68
     SaveInto AT ROW 5.1 COL 19 COLON-ALIGNED
     BtnOptions AT ROW 5.43 COL 68
     ReplaceRCode AT ROW 6.52 COL 20
     SaveLog AT ROW 7.48 COL 20
     BROWSE-1 AT ROW 10.95 COL 5
     OptionsLabel AT ROW 1.48 COL 5 NO-LABEL
     LangLabel AT ROW 2.19 COL 8 NO-LABEL
     OptionsLabel-2 AT ROW 9.57 COL 6 NO-LABEL
     FilesLabel AT ROW 10.24 COL 5.6 NO-LABEL
     ContainerRectangle1 AT ROW 1.76 COL 3
     IMAGE-1 AT ROW 3.91 COL 29
     RECT-1 AT ROW 9.81 COL 3
     SPACE(20.79) SKIP(0.42)
    WITH VIEW-AS DIALOG-BOX
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         FONT 4
         TITLE "Compile"
         DEFAULT-BUTTON BtnOK CANCEL-BUTTON BtnCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
/* BROWSE-TAB BROWSE-1 SaveLog Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BROWSE BROWSE-1 IN FRAME Dialog-Frame
   1                                                                    */
ASSIGN
       BROWSE-1:HIDDEN  IN FRAME Dialog-Frame            = TRUE.

/* SETTINGS FOR FILL-IN FilesLabel IN FRAME Dialog-Frame
   ALIGN-L 1                                                            */
ASSIGN
       FilesLabel:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR FILL-IN LangLabel IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN OptionsLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN OptionsLabel-2 IN FRAME Dialog-Frame
   ALIGN-L 1                                                            */
ASSIGN
       OptionsLabel-2:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME Dialog-Frame
   1                                                                    */
ASSIGN
       RECT-1:HIDDEN IN FRAME Dialog-Frame           = TRUE.

ASSIGN
       ReplaceRCode:HIDDEN IN FRAME Dialog-Frame           = TRUE.

ASSIGN
       SaveInto:HIDDEN IN FRAME Dialog-Frame           = TRUE.

ASSIGN
       SaveLog:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "xlatedb.XL_Procedure"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > "_<CALC>"
"xlatedb.XL_Procedure.Directory + ""~\"":U + xlatedb.XL_Procedure.FileName" ? "X(80)" "Character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME






/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON ALT-F OF FRAME Dialog-Frame /* Compile */
ANYWHERE
DO:
  APPLY "ENTRY" TO {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON ALT-L OF FRAME Dialog-Frame /* Compile */
ANYWHERE
DO:
  APPLY "ENTRY" TO Languages.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Compile */
DO:

DEFINE VARIABLE SavedRowid AS ROWID   NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  FIND FIRST xlatedb.XL_Project NO-LOCK.
  ASSIGN NumProcs = xlatedb.XL_Project.NumberOfProcedures.

  IF NumProcs = 0 THEN
  DO:
      MESSAGE "The project does not have any procedures to compile."
              VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
      APPLY "ENTRY":U TO btnCancel.
      RETURN NO-APPLY.
  END.

  /* Validate Save Into directory. */
  RUN SaveInto_Validate.
  IF RETURN-VALUE = "NO-APPLY":u THEN RETURN NO-APPLY.

  /* If the dialog is not opened to the Options state, then don't check
     the Files list. Instead, compile all files. */
  IF OptionState = FALSE THEN
  DO:
    ASSIGN SavedRowid = ROWID(xlatedb.XL_Procedure). /* END ASSIGN */
    /* Position to before the first record in the table so the first
       time GET NEXT is executed we get the first record. */
    GET FIRST {&BROWSE-NAME} NO-LOCK.
    GET PREV {&BROWSE-NAME} NO-LOCK.
  END.
  ELSE
  DO:
    ASSIGN NumProcs = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    IF NumProcs = 0 THEN
    DO ON STOP UNDO, RETRY:
      IF NOT RETRY THEN
      DO:
          IF OptionState = FALSE THEN
              APPLY "CHOOSE":U TO BtnOptions.
          MESSAGE "You do not have any procedures selected to compile."
                  VIEW-AS ALERT-BOX INFORMATION IN WINDOW ACTIVE-WINDOW.
      END.
      APPLY "ENTRY":U TO {&BROWSE-NAME}.
      RETURN NO-APPLY.
    END.
  END.

  ASSIGN Languages
         Growth
         SaveInto
         ReplaceRCode
         SaveLog
         . /* END ASSIGN */

  /* Save the Growth% back to the Project record. */
  DO TRANSACTION:
    FIND FIRST xlatedb.XL_Project EXCLUSIVE-LOCK.
    ASSIGN xlatedb.XL_Project.GrowthFactor = Growth
           xlatedb.XL_Project.SaveInto     = SaveInto.
  END.
  FIND FIRST xlatedb.XL_Project NO-LOCK.

  IF SaveLog = TRUE THEN
  DO:
    ASSIGN Temp_Log = Comp_Log.
    OS-DELETE VALUE( Temp_Log ).
  END.
  ELSE
    RUN adecomm/_tmpfile.p (INPUT "l":U , INPUT ".log", OUTPUT Temp_Log).

  HIDE FRAME {&FRAME-NAME} NO-PAUSE.

  IF NOT VALID-HANDLE( _hMeter ) THEN
    RUN adetran/common/_meter.p PERSISTENT SET _hMeter
        (INPUT ACTIVE-WINDOW).

  RUN realize IN _hMeter (INPUT "Compiling").

  ASSIGN StopProcessing = FALSE. /* END ASSIGN */

  OUTPUT STREAM Comp_Stream TO VALUE(Temp_Log)
         KEEP-MESSAGES {&NO-MAP} UNBUFFERED.

  ASSIGN Msg_Line = FILL("=" , 80) + {&EOL} +
                    "TRANSLATION MANAGER COMPILE LOG - " +
                    STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS") + {&EOL} +
                    "LANGUAGES: " + (IF Languages = ? THEN "" ELSE Languages) + {&EOL} +
                    "GROWTH TABLE: " + STRING(Growth , Growth:FORMAT) + {&EOL} +
                    "SAVE INTO: " + SaveInto + {&EOL} +
                    FILL("=" , 80).
  RUN PutMsgLine (INPUT Msg_Line + {&EOL}).

  COMP-BLOCK:
  REPEAT ThisRec = 1 TO NumProcs :
    PROCESS EVENTS.

    IF StopProcessing THEN LEAVE COMP-BLOCK.

    IF OptionState = FALSE THEN
    DO:
        GET NEXT {&BROWSE-NAME} NO-LOCK.
        IF NOT AVAILABLE xlatedb.XL_Procedure THEN
            LEAVE COMP-BLOCK.
    END.
    ELSE
        ASSIGN Result = {&BROWSE-NAME}:FETCH-SELECTED-ROW(ThisRec).

    ASSIGN File_Name = xlatedb.XL_Procedure.Filename
           Dir_Name  = IF xlatedb.XL_Procedure.Directory = ".":U THEN "":U
                       ELSE xlatedb.XL_Procedure.Directory
           . /* END ASSIGN */

    RUN adecomm/_osfmush.p
        (INPUT Dir_Name, INPUT File_Name, OUTPUT Full_Name).

    RUN setbar IN _hMeter
        (INPUT NumProcs, INPUT ThisRec, INPUT Full_Name).

    RUN CompFile.
  END.  /* COMP-BLOCK */

  RUN hideme IN _hMeter.

  IF StopProcessing = FALSE THEN
    ASSIGN Msg_Line = {&EOL} + "Compilation finished: ".
  ELSE
    ASSIGN Msg_Line = {&EOL} + "Compilation stopped: ".
  ASSIGN Msg_Line = Msg_Line + STRING(TODAY) + " " + STRING(TIME, "HH:MM:SS") + ".".
  RUN PutMsgLine (INPUT Msg_Line).

  OUTPUT STREAM Comp_Stream CLOSE.
  OUTPUT CLOSE.


  /* If we compiled all files, then Repostion record to sync up
     with the Browse object. */
  IF OptionState = FALSE THEN
    REPOSITION {&BROWSE-NAME} TO ROWID SavedRowid.

  /* Ask if the user would like to view the compile.log. */
  ASSIGN Msg_Line = Msg_Line + CHR(10) + "View compile log?".
  MESSAGE Msg_Line VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Compile"
                           UPDATE Result.
  IF Result THEN
    RUN adetran/common/_viewer.w (INPUT comp_log).

  IF SaveLog <> TRUE THEN
    OS-DELETE VALUE( Temp_Log ).

END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Compile */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("tran","context",{&Compile_DB}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions Dialog-Frame
ON CHOOSE OF BtnOptions IN FRAME Dialog-Frame /* Options >> */
DO:
  IF OptionState = FALSE THEN
  DO:
    /* Set to Option state and display the full dialog. */
    ASSIGN BtnOptions:label = "<< &Options"
           OptionState = NOT OptionState.
           FRAME {&frame-name}:HEIGHT = Dlg_FullH
           . /* END ASSIGN */
    VIEW {&OPTIONAL-FIELDS}.
    APPLY "ENTRY" TO {&BROWSE-NAME}.
  END.
  ELSE
  DO:
    /* Display the shortened dialog. */
    HIDE {&OPTIONAL-FIELDS} NO-PAUSE.
    ASSIGN BtnOptions:label = "&Options >>"
           FRAME {&frame-name}:HEIGHT = Dlg_ShortH
           OptionState = NOT OptionState.
    APPLY "ENTRY" TO Languages.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Growth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Growth Dialog-Frame
ON CURSOR-DOWN OF Growth IN FRAME Dialog-Frame /* Growth Table */
DO:
  DEFINE VARIABLE Rev AS INTEGER               NO-UNDO.

  ASSIGN Rev = MAX(INTEGER(REPLACE(Growth:SCREEN-VALUE,"%","")) - 25, 0)
         GROWTH:SCREEN-VALUE = STRING(Rev,Growth:FORMAT).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Growth Dialog-Frame
ON CURSOR-UP OF Growth IN FRAME Dialog-Frame /* Growth Table */
DO:
  DEFINE VARIABLE Rev AS INTEGER               NO-UNDO.

  ASSIGN Rev = MIN(INTEGER(REPLACE(Growth:SCREEN-VALUE,"%","")) + 25, 9999)
         GROWTH:SCREEN-VALUE = STRING(Rev,Growth:FORMAT).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE-1 Dialog-Frame
ON MOUSE-SELECT-CLICK OF IMAGE-1 IN FRAME Dialog-Frame
DO:
  def var Rev as integer.
  def var HalfWay as int.

  assign
    HalfWay = (image-1:y + (image-1:height-p / 2))
    Rev     = integer(replace(Growth:screen-value,"%","")).

  if last-event:y > HalfWay then do:
    /* User clicked down arrow. */
    Result = image-1:load-image("adetran/images/vert-dn2").
    Rev = Rev - 25.
    if Rev < 1 then Rev = 0.
  end.
  else do:
    /* User clicked up arrow. */
    Result = image-1:load-image("adetran/images/vert-dn1").
    Rev = Rev + 25.
    if Rev > 9999 then Rev = 9999.
  end.

  Growth:screen-value = string(Rev,Growth:format).

  /*
  ** Waste some time for a second
  */
  do i = 1 to 50:
  end.
  Result = image-1:load-image("adetran/images/vert-inc").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN InitVals.
  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus Languages.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CompFile Dialog-Frame
PROCEDURE CompFile :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Found_Rcode AS LOGICAL NO-UNDO.

  DO:
    /* Search for the file. If we can't find it, do not continue with
       compile for this file and do not delete .r file. */
    ASSIGN FILE-INFO:FILE-NAME = Full_Name.
    IF FILE-INFO:FULL-PATHNAME = ? THEN
    DO:
        RUN PutMsgLine (INPUT Full_Name + " was not found. (293)" + {&EOL}).
        RETURN.
    END.

    /* Set .r name by replacing existing extension if there is one. */
    IF R-INDEX(Full_Name, ".":U) > 0 THEN
        ASSIGN Rcode_Name =
               SUBSTR(Full_Name,1, R-INDEX(Full_Name, ".":U) - 1) + ".r":U.
    ELSE
        ASSIGN Rcode_Name = Full_Name + ".r":U.

    /* Append the filename to the save into dir and search for it. */
    RUN adecomm/_osfmush.p
        (INPUT SaveInto, INPUT Rcode_Name, OUTPUT Rcode_Name).
    ASSIGN Found_Rcode = (SEARCH(Rcode_Name) <> ?).

    /* If not Replacing Existing .r Code, then only compile files that
       have no .r code. */
    IF NOT ReplaceRCode AND Found_Rcode THEN NEXT.

    /* Remove the .r file. */
    IF Found_Rcode THEN OS-DELETE VALUE( Rcode_Name ) .

    RUN PutMsgLine (INPUT "Compiling " + Full_Name + " ...").

    DO ON STOP UNDO:
      COMPILE VALUE(Full_Name)
              SAVE INTO VALUE(SaveInto)
              LANGUAGES (VALUE(Languages))
              TEXT-SEG-GROWTH = Growth.
    END.
    IF COMPILER:ERROR <> TRUE THEN
        RUN PutMsgLine (INPUT "Saving to " + Rcode_Name + ".":U).
    RUN PutMsgLine (INPUT " ").

    IF COMPILER:STOPPED = TRUE THEN
        ASSIGN StopProcessing = TRUE.

  END.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Create_Path Dialog-Frame
PROCEDURE Create_Path :
/*------------------------------------------------------------------------------
  Purpose:     Create an os path.
  Notes:       Creates all the directories down a path.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_path    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p_errcode AS INTEGER   NO-UNDO.

  RUN adecomm/_oscpath.p (INPUT p_path, OUTPUT p_errcode).
END PROCEDURE. /* Create_Path */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitVals Dialog-Frame
PROCEDURE InitVals :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:

    /* Set the dialog size values and shorten the dialog height. */
    ASSIGN Dlg_ShortH = FRAME {&FRAME-NAME}:HEIGHT -
                        (FRAME {&FRAME-NAME}:HEIGHT
                         - OptionsLabel-2:ROW IN FRAME {&FRAME-NAME})
           Dlg_FullH  = FRAME {&FRAME-NAME}:HEIGHT
           FRAME {&FRAME-NAME}:HEIGHT = Dlg_ShortH
           . /* END ASSIGN */

    /* Build list of languages for this project. */
    FOR EACH xlatedb.XL_Language NO-LOCK:
      IF CAN-FIND(FIRST xlatedb.XL_Translation WHERE
                        xlatedb.XL_Translation.lang_name = xlatedb.XL_Language.Lang_Name)
        THEN  ASSIGN Languages = (IF Languages = "" THEN "" ELSE Languages + ",") +
                                  xlatedb.XL_Language.Lang_Name.
    END.

    /* Initialize Growth Table% from Project record. */
    FIND FIRST xlatedb.XL_Project NO-LOCK.
    ASSIGN Growth     = xlatedb.XL_Project.GrowthFactor
           SaveInto   = xlatedb.XL_Project.SaveInto
           Source_Dir = xlatedb.XL_Project.ApplDirectory
    . /* END ASSIGN */

    /* If user has not filled in SaveInto, initialize it to the Source Dir. */
    IF SaveInto = "" THEN ASSIGN SaveInto = xlatedb.XL_Project.ApplDirectory.

    /* Ensure the compile log is created in the Project Directory. */
    RUN adecomm/_osfmush.p
        (INPUT  xlatedb.XL_Project.RootDirectory,
         INPUT  Comp_Log,
         OUTPUT Comp_Log).

    ASSIGN LangLabel:screen-value      = "&Languages:"
           LangLabel:width             = font-table:get-text-width-chars (trim(LangLabel:screen-value),4)
           LangLabel:column            = Languages:column - LangLabel:width

           OptionsLabel:screen-value   = "Compile"
           OptionsLabel-2:screen-value = "Options"
           OptionsLabel:width          = font-table:get-text-width-chars(OptionsLabel:screen-value,4)
           OptionsLabel-2:width        = font-table:get-text-width-chars(OptionsLabel-2:screen-value,4)
           Languages:LIST-ITEMS        = Languages
           Languages:SCREEN-VALUE      = Languages:ENTRY(1)
           . /* END ASSIGN */
  END. /* DO WITH FRAME */
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PutMsgLine Dialog-Frame
PROCEDURE PutMsgLine :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Msg_Line AS CHARACTER NO-UNDO.

  PUT STREAM Comp_Stream UNFORMATTED p_Msg_Line.
  PUT STREAM Comp_Stream SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame
PROCEDURE Realize :
assign frame {&frame-name}:hidden = true.

  FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
  IF AVAILABLE xlatedb.XL_Project THEN
    ASSIGN browse-1:MAX-DATA-GUESS IN FRAME DIALOG-FRAME =
                        xlatedb.XL_Project.NumberOfProcedures.
  display
    OptionsLabel
    Growth
    OptionsLabel-2
    FilesLabel
    SaveInto
    ReplaceRCode
    SaveLog
  with frame dialog-frame.

  enable
    Languages
    Growth
    image-1
    browse-1
    SaveInto
    ReplaceRCode
    SaveLog
    BtnOK
    BtnCancel
    BtnHelp
    BtnOptions
  with frame dialog-frame.

  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  hide {&OPTIONAL-FIELDS} no-pause.
  assign frame {&frame-name}:hidden = false.

  run adecomm/_setcurs.p ("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveInto_Validate Dialog-Frame
PROCEDURE SaveInto_Validate :
/*------------------------------------------------------------------------------
  Purpose:     Test to see if a SaveInto Directory name was entered, that its
               valid, and create it if its not there.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define variable createit       as logical   no-undo initial yes.
  define variable os-rc          as integer   no-undo.
  define variable Msg_Line       as character no-undo.
  define variable SaveInto_Label as character no-undo.

  do with frame {&FRAME-NAME}:
    assign SaveInto:screen-value = TRIM(SaveInto:screen-value)
           SaveInto              = SaveInto:screen-value
           SaveInto_Label        = REPLACE(SaveInto:LABEL, "&":u, "")
    . /* end assign */

    /* Blank or Unknown is defaulted to Source Dir. */
    if (SaveInto:screen-value = "") OR (SaveInto:screen-value = ?) then
      assign SaveInto:screen-value = Source_Dir
             SaveInto              = Source_Dir.

    assign file-info:file-name = SaveInto.
    if file-info:full-pathname = ? then
    do:
      Msg_Line = SaveInto_Label + ": " + SaveInto + CHR(10) + CHR(10) +
                 "The Save Into directory does not exist." + CHR(10) +
                 "Do you want to create it?".
      message Msg_Line view-as alert-box question button yes-no update createit.
      if createit then
      do:
        run Create_Path (INPUT SaveInto, OUTPUT os-rc).
        if os-rc <> 0 then
        do:
          message SaveInto_Label + ": " + SaveInto + CHR(10) + CHR(10) +
                  "Unable to create Save Into directory."
            view-as alert-box error.
          apply "entry":u to SaveInto in frame {&FRAME-NAME}.
          return "no-apply":u.
        end.
        else assign file-info:file-name   = SaveInto
                    SaveInto:screen-value = file-info:full-pathname
                    SaveInto              = file-info:full-pathname.
      end.
      else
      do:
        apply "entry":u to SaveInto in frame {&FRAME-NAME}.
        return "no-apply":u.
      end.
    end.
    else if index(file-info:file-type, "D") = 0 then
    do:
      Msg_Line = SaveInto_Label + ": " + SaveInto + CHR(10) + CHR(10) +
                 "This is not a valid directory name.".
      message Msg_Line view-as alert-box error.
      apply "entry":u to SaveInto in frame {&FRAME-NAME}.
      return "no-apply":u.
    end.
    assign SaveInto:screen-value = file-info:full-pathname
           SaveInto              = file-info:full-pathname.
  end. /* with frame */
  return.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

