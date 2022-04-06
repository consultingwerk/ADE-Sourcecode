&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
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

  File: _expstr.w
  Description: Exports Data Tab strings to be translated
  Input Parameters:
      <none>
  Output Parameters:
      <none>
  Author: SLK
  Created: 05/1999
  Updated: 09/03/1999 tomn - Changed export format from .d to .csv
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBulder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cBaseName            AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cDirName             AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cGlossaryList        AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cTemp                AS CHARACTER                NO-UNDO.
DEFINE VARIABLE lErrorStatus         AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE OptionState          AS LOGICAL   INITIAL TRUE   NO-UNDO.
DEFINE VARIABLE ThisMessage          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE FullHeight           AS INTEGER                  NO-UNDO.
DEFINE VARIABLE ShortHeight          AS INTEGER                  NO-UNDO.

{adetran/pm/tranhelp.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK FileName BtnFile Btn_Cancel ~
ReplaceIfExists Btn_Help CodePage Btn_Options GlossaryName TargetLanguage ~
SourceLanguage rdExportString FromLabel FileNameLabel LanguageLabel ~
exportStringLabel Rect-4 Rect-5 Rect2 
&Scoped-Define DISPLAYED-OBJECTS FileName ReplaceIfExists CodePage ~
GlossaryName TargetLanguage SourceLanguage rdExportString FromLabel ~
FileNameLabel LanguageLabel exportStringLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnFile 
     LABEL "&Files..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Options AUTO-GO 
     LABEL "Options >>" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE CodePage AS CHARACTER FORMAT "X(256)":U 
     LABEL "Code Page" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "undefined" 
     DROP-DOWN-LIST
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE GlossaryName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Glossary Name" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "None" 
     DROP-DOWN-LIST
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE SourceLanguage AS CHARACTER FORMAT "X(256)":U INITIAL "<unnamed>" 
     LABEL "Source" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "<unnamed>" 
     DROP-DOWN-LIST
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE TargetLanguage AS CHARACTER FORMAT "X(15)":U 
     LABEL "Target" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE exportStringLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Export Strings" 
      VIEW-AS TEXT 
     SIZE 15.2 BY .67 NO-UNDO.

DEFINE VARIABLE FileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE FileNameLabel AS CHARACTER FORMAT "X(256)":U INITIAL "File Name:" 
      VIEW-AS TEXT 
     SIZE 35.4 BY .67 NO-UNDO.

DEFINE VARIABLE FromLabel AS CHARACTER FORMAT "X(256)":U INITIAL "To" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .67 NO-UNDO.

DEFINE VARIABLE LanguageLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Language" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE rdExportString AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "All Strings", 1,
"Translated Strings Only", 2,
"UnTranslated Strings Only", 3
     SIZE 67 BY 2.38 NO-UNDO.

DEFINE RECTANGLE Rect-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 5.

DEFINE RECTANGLE Rect-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 3.57.

DEFINE RECTANGLE Rect2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 4.29.

DEFINE VARIABLE ReplaceIfExists AS LOGICAL INITIAL no 
     LABEL "Replace If &Exists" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.6 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.48 COL 76
     FileName AT ROW 2.91 COL 5.6 NO-LABEL
     BtnFile AT ROW 2.91 COL 58.6
     Btn_Cancel AT ROW 2.91 COL 76
     ReplaceIfExists AT ROW 4.1 COL 5.6
     Btn_Help AT ROW 4.33 COL 76
     CodePage AT ROW 5.05 COL 15.2
     Btn_Options AT ROW 5.76 COL 76
     GlossaryName AT ROW 7.62 COL 25 COLON-ALIGNED
     TargetLanguage AT ROW 8.81 COL 25 COLON-ALIGNED
     SourceLanguage AT ROW 10.05 COL 25 COLON-ALIGNED
     rdExportString AT ROW 12.91 COL 5 NO-LABEL
     FromLabel AT ROW 1.24 COL 4 NO-LABEL
     FileNameLabel AT ROW 2.19 COL 5 NO-LABEL
     LanguageLabel AT ROW 6.95 COL 2 COLON-ALIGNED NO-LABEL
     exportStringLabel AT ROW 11.95 COL 2 COLON-ALIGNED NO-LABEL
     Rect-4 AT ROW 1.48 COL 2
     Rect-5 AT ROW 12.19 COL 2
     Rect2 AT ROW 7.19 COL 2
     SPACE(17.19) SKIP(4.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Export"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CodePage IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileName IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileNameLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FromLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Export */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile Dialog-Frame
ON CHOOSE OF BtnFile IN FRAME Dialog-Frame /* Files... */
DO:
  define variable ExpStrFile as character no-undo.
  define variable OKPressed as logical no-undo.

  system-dialog get-file ExpStrFile
     title      "Export File"
     filters    "Comma-separated values (*.csv)":u  "*.csv":u,                
                "All Files (*.*)":u                 "*.*":u
     use-filename
     DEFAULT-EXTENSION ".csv"
     update okpressed.      

  if okpressed = true then do:
    FileName:screen-value = ExpStrFile. 
    apply "leave":u to FileName.
  end.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  RUN adecomm/_adehelp.p ("tran":U, "context":U, {&Export_Data_Dialog_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
   RUN adecomm/_setcurs.p ("WAIT":U).

   /* Don't allow blank filename */
   IF FileName:SCREEN-VALUE = "":U OR FileName:SCREEN-VALUE = ? THEN
   DO:
      ThisMessage = "You must enter an export file name.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT lErrorStatus, "w*":U
                                 , "ok":U, ThisMessage).
      APPLY "ENTRY":U TO FileName.
      RETURN NO-APPLY.
   END.

   /* Does output file exists, check to see if we should overwrite this */
   FILE-INFO:FILE-NAME = FileName:SCREEN-VALUE.
   IF FILE-INFO:FULL-PATHNAME <> ? THEN
   DO:
      IF NOT ReplaceIfExists:CHECKED THEN
      DO:
         ThisMessage = FileName:SCREEN-VALUE + 
                       '^Exists. Try changing the name or specify "Replace If Exists"'.
         RUN adecomm/_s-alert.p (INPUT-OUTPUT lErrorStatus, "w*":U
                                 , "ok":U, ThisMessage).
         APPLY "ENTRY":U TO ReplaceIfExists.
         RETURN NO-APPLY.
      END.
   END.
   ELSE OS-DELETE VALUE(FILE-INFO:FULL-PATHNAME).

   RUN ExportData.
   RUN adecomm/_setcurs.p ("":U).
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Options
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Options Dialog-Frame
ON CHOOSE OF Btn_Options IN FRAME Dialog-Frame /* Options >> */
DO:

   IF OptionState THEN
   DO:
      /* Set to Option state and display the full dialog. */
      FRAME {&FRAME-NAME}:HEIGHT = FullHeight.
      ASSIGN Btn_Options:LABEL        = "<< &Options"
             OptionState              = NOT OptionState
             exportStringLabel:HIDDEN = FALSE
             rdExportString:HIDDEN    = FALSE
             rect-5:HIDDEN            = FALSE
      .
   END.
   ELSE
   DO:
      /* Display the shortened dialog */
      ASSIGN Btn_Options:LABEL        = "&Options >>"
             OptionState              = NOT OptionState
             exportStringLabel:HIDDEN = TRUE
             rdExportString:HIDDEN    = TRUE
             rect-5:HIDDEN            = TRUE
      .
      ASSIGN FRAME Dialog-Frame:HEIGHT-CHARS    = shortHeight.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileName Dialog-Frame
ON LEAVE OF FileName IN FRAME Dialog-Frame
DO:
  DEFINE VARIABLE FileExt AS CHARACTER                              NO-UNDO.
  IF FileName:SCREEN-VALUE = "" THEN RETURN.
  IF NUM-ENTRIES(FileName:SCREEN-VALUE,".":U) > 1 THEN
    FileExt = ENTRY(2,FileName:SCREEN-VALUE,".":U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GlossaryName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GlossaryName Dialog-Frame
ON VALUE-CHANGED OF GlossaryName IN FRAME Dialog-Frame /* Glossary Name */
DO:
  if self:screen-value = "" then return.
  find xlatedb.XL_Glossary where xlatedb.XL_Glossary.GlossaryName = self:screen-value  
                           no-lock no-error.
  if available xlatedb.XL_Glossary then do:
    assign
      TargetLanguage              = replace(xlatedb.XL_Glossary.GlossaryType,"/":u,",":u)
      TargetLanguage:list-items   = TargetLanguage
      TargetLanguage              = "":U
      TargetLanguage:screen-value = TargetLanguage:entry(2).
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SourceLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SourceLanguage Dialog-Frame
ON VALUE-CHANGED OF SourceLanguage IN FRAME Dialog-Frame /* Source */
DO:
  if self:screen-value = "<unnamed>":U then return.
  
  /* ?????????????????????????????????????????????????????????????????????????????????? */
  /* (9/23/99 tomn) ??? This code makes no sense to me, I think it should be removed... */
  find xlatedb.XL_Glossary where xlatedb.XL_Glossary.GlossaryName = self:screen-value  
                           no-lock no-error.
  if available xlatedb.XL_Glossary then do:
    assign
      SourceLanguage              = replace(xlatedb.XL_Glossary.GlossaryType,"/":u,",":u)
      SourceLanguage:list-items   = "<unnamed>,":U + TargetLanguage:entry(1)
      SourceLanguage:SCREEN-VALUE = "<unnamed>":U.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* This CLOSE event can be user from inside or outside the procedure to */
/* terminate it.                                                         */
ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

/* Best default for GUI applications is ...                             */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  DO WITH FRAME {&FRAME-NAME}:

     FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
     RUN adetran/pm/_getproj.p (  OUTPUT cGlossaryList
                                , OUTPUT cTemp
                                , OUTPUT lErrorStatus).

     IF cGlossaryList = ? OR cGlossaryList = "":U THEN
     DO:
         ThisMessage = "You must define a glossary first".
         RUN adecomm/_s-alert.p (INPUT-OUTPUT lErrorStatus, "w*":U
                                 , "ok":U, ThisMessage).
         RETURN.
     END.  /* No glossary defined */

     ASSIGN 
        FileName                  = xlatedb.XL_Project.ProjectName + ".csv":U
        CodePage:LIST-ITEMS       = get-codepages
        CodePage:SCREEN-VALUE     = "ISO8859-1":U
        GlossaryName:LIST-ITEMS   = LEFT-TRIM(cGlossaryList)
        GlossaryName:SCREEN-VALUE = GlossaryName:ENTRY(1) 
     .
     APPLY "VALUE-CHANGED":U TO GlossaryName.
     RUN setLanguages.
     RUN Realize.

     IF NOT THIS-PROCEDURE:PERSISTENT THEN
     WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportData Dialog-Frame 
PROCEDURE exportData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTemp                 AS CHARACTER             NO-UNDO.
DEFINE VARIABLE cExportFile           AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cTempFile             AS CHARACTER             NO-UNDO.
DEFINE VARIABLE _hExport              AS HANDLE                NO-UNDO.
DEFINE VARIABLE piRecordCount         AS INTEGER               NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
   RUN adecomm/_setcurs.p ("WAIT":U).
   RUN adecomm/_tmpfile.p ("t2":U, ".tmp":U, OUTPUT cTempFile). 

   cExportFile = FileName:SCREEN-VALUE.

   /* Generate the export procedure to run */
   OUTPUT TO VALUE(cTempFile) NO-ECHO.
   PUT UNFORMATTED
     ' /* File generated by adetran/common/_expstr.w '                    SKIP
     '  * Exports String Data in CSV format'                              SKIP
     '  */'                                                               SKIP
     ' DEFINE OUTPUT PARAMETER piRecCnt      AS INTEGER         NO-UNDO.' SKIP
     ' DEFINE VARIABLE cStringValue          AS CHARACTER       NO-UNDO.' SKIP
     ' DEFINE VARIABLE cSource               AS CHARACTER       NO-UNDO.' SKIP
     ' DEFINE VARIABLE cTranslation          AS CHARACTER       NO-UNDO.' SKIP
     ' DEFINE VARIABLE cJustification        AS CHARACTER       NO-UNDO.' SKIP
     ' DEFINE BUFFER XL_Trans2 FOR xlatedb.XL_Translation.'               SKIP(1)
     ' FUNCTION FormatExportString RETURNS CHARACTER'                     SKIP
     '   ( INPUT pcInputString AS CHARACTER ):'                           SKIP(1)
     '   ASSIGN'                                                          SKIP
     '     pcInputString = REPLACE(pcInputString, ~'"~':U, ~'""~':U)'     SKIP
     '     pcInputString = IF INDEX(pcInputString, ~'""~':U) GT 0'        SKIP
     '                     OR INDEX(pcInputString, ~',~':U)  GT 0'        SKIP
     '                       THEN ~'"~':U + pcInputString + ~'"~':U'      SKIP
     '                       ELSE pcInputString.'                         SKIP
     '   RETURN pcInputString.'                                           SKIP
     ' END FUNCTION.'                                                     SKIP(1)
     ' OUTPUT TO "' cExportFile '".'                                      SKIP(1)
     .

     /* Include project details in export file */
     PUT UNFORMATTED
       ' FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.'                 SKIP(1)
       ' /* HEADER */'                                                    SKIP
       ' PUT UNFORMATTED'                                                 SKIP
       '    "' CodePage:SCREEN-VALUE ',"'                                 SKIP
       '    "' TargetLanguage:SCREEN-VALUE ',"'                           SKIP
       '    xlatedb.XL_Project.ProjectName ","'                           SKIP
       '    xlatedb.XL_Project.ProjectDesc'                               SKIP
       '    SKIP.'                                                        SKIP(1)
       .

   /* Output data field names */
   PUT UNFORMATTED
      ' /* COLUMN LABELS */'                                              SKIP
      ' PUT UNFORMATTED'                                                  SKIP
      '    "Sequence Number,"'                                            SKIP
      '    "Instance Number,"'                                            SKIP
      '    "Source Phrase,"'                                              SKIP
      '    "Translation,"'                                                SKIP
      '    "Number of Occurances,"'                                       SKIP
      '    "Line Number,"'                                                SKIP
      '    "Justification,"'                                              SKIP
      '    "Max Length,"'                                                 SKIP
      '    "Object Name,"'                                                SKIP
      '    "Statement,"'                                                  SKIP
      '    "Item,"'                                                       SKIP
      '    "Comments"'                                                    SKIP
      '    SKIP.'                                                         SKIP(1)
      .

   IF    rdExportString:SCREEN-VALUE = "1" 
      OR rdExportString:SCREEN-VALUE = "3" THEN
   DO:

      IF SourceLanguage:SCREEN-VALUE = "<unnamed>":U THEN
         PUT UNFORMATTED
            ' recordLoop:'                                                 SKIP
            ' FOR EACH xlatedb.XL_Instance NO-LOCK:'                       SKIP
            '    FIND FIRST xlatedb.XL_String_Info WHERE'                  SKIP
            '           xlatedb.XL_String_Info.Sequence_Num ='
            ' xlatedb.XL_Instance.Sequence_Num'                            SKIP
            '    NO-LOCK NO-ERROR.'                                        SKIP(1)
            '    FIND FIRST xlatedb.XL_Translation WHERE'                  SKIP
            '           xlatedb.XL_Translation.Sequence_Num ='
            ' xlatedb.XL_Instance.Sequence_Num'                            SKIP
            '       AND xlatedb.XL_Translation.Instance_Num ='
            ' xlatedb.XL_Instance.Instance_Num'                            SKIP
            '       AND xlatedb.XL_Translation.Lang_Name = "'
              TargetLanguage:SCREEN-VALUE '"'                              SKIP
            '    NO-LOCK NO-ERROR.'                                        SKIP(1)
            '    ASSIGN cSource = xlatedb.XL_String_Info.Original_String.' SKIP(1)
            .
      ELSE  /* Source language is another translation */
         PUT UNFORMATTED
            ' recordLoop:'                                                 SKIP
            ' FOR EACH xlatedb.XL_Instance NO-LOCK:'                       SKIP
            '    FIND FIRST XL_Trans2 WHERE'                               SKIP
            '           XL_Trans2.Sequence_Num ='
            ' xlatedb.XL_Instance.Sequence_Num'                            SKIP
            '       AND XL_Trans2.Instance_Num ='
            ' xlatedb.XL_Instance.Instance_Num'                            SKIP
            '       AND XL_Trans2.Lang_Name = "'
                 SourceLanguage:SCREEN-VALUE '"'                           SKIP
            '    NO-LOCK NO-ERROR.'                                        SKIP(1)
            '    IF NOT AVAILABLE XL_Trans2'                               SKIP
            '       OR XL_Trans2.Trans_String = ""'                        SKIP
            '       OR XL_Trans2.Trans_String = ? THEN NEXT recordLoop.'   SKIP(1)
            '    FIND FIRST xlatedb.XL_String_Info WHERE'                  SKIP
            '           xlatedb.XL_String_Info.Sequence_Num ='
            ' xlatedb.XL_Instance.Sequence_Num'                            SKIP
            '    NO-LOCK NO-ERROR.'                                        SKIP(1)
            '    FIND FIRST xlatedb.XL_Translation WHERE'                  SKIP
            '           xlatedb.XL_Translation.Sequence_Num ='
            ' xlatedb.XL_Instance.Sequence_Num'                            SKIP
            '       AND xlatedb.XL_Translation.Instance_Num ='
            ' xlatedb.XL_Instance.Instance_Num'                            SKIP
            '       AND xlatedb.XL_Translation.Lang_Name = "'
                 TargetLanguage:SCREEN-VALUE '"'                           SKIP
            '    NO-LOCK NO-ERROR.'                                        SKIP(1)
            '    ASSIGN cSource = XL_Trans2.Trans_String.'                 SKIP(1)
            .

      IF rdExportString:SCREEN-VALUE = "3" THEN /* Untranslated strings only */
         PUT UNFORMATTED
            '    IF AVAILABLE xlatedb.XL_Translation THEN NEXT recordLoop.' SKIP(1)
            .           
    END. /* All String or untranslated strings */

    ELSE IF rdExportString:SCREEN-VALUE = "2" THEN /* Translated Strings */
    DO:
       IF SourceLanguage:SCREEN-VALUE = "<unnamed>":U THEN
          PUT UNFORMATTED
             ' recordLoop:'                                                  SKIP
             ' FOR EACH xlatedb.XL_Translation WHERE lang_name = "'              
               TargetLanguage:SCREEN-VALUE '" NO-LOCK:'                      SKIP
             '    FIND FIRST xlatedb.XL_Instance WHERE'                      SKIP
             '           xlatedb.XL_Instance.Sequence_Num ='
             ' xlatedb.XL_Translation.Sequence_Num'                          SKIP
             '       AND xlatedb.XL_Instance.Instance_Num ='
             ' xlatedb.XL_Translation.Instance_Num'                          SKIP
             '    NO-LOCK NO-ERROR.'                                         SKIP(1)
             '    FIND FIRST xlatedb.XL_String_Info WHERE'                   SKIP
             '       xlatedb.XL_String_Info.Sequence_Num ='
             ' xlatedb.XL_Translation.Sequence_Num'                          SKIP
             '    NO-LOCK NO-ERROR.'                                         SKIP(1)
             '    ASSIGN cSource = xlatedb.XL_String_Info.Original_String.'  SKIP(1)
             .
       ELSE  /* Source language is another translation */
          PUT UNFORMATTED
             ' recordLoop:'                                                  SKIP
             ' FOR EACH xlatedb.XL_Translation WHERE lang_name = "'              
               TargetLanguage:SCREEN-VALUE '" NO-LOCK:'                      SKIP
             '    FIND FIRST XL_Trans2 WHERE'                                SKIP
             '           XL_Trans2.Sequence_Num ='
             ' xlatedb.XL_Translation.Sequence_Num'                          SKIP
             '       AND XL_Trans2.Instance_Num ='
             ' xlatedb.XL_Translation.Instance_Num'                          SKIP
             '       AND XL_Trans2.Lang_Name = "'
                  SourceLanguage:SCREEN-VALUE '"'                            SKIP
             '    NO-LOCK NO-ERROR.'                                         SKIP(1)
             '    IF NOT AVAILABLE XL_Trans2'                                SKIP
             '       OR XL_Trans2.Trans_String = ""'                         SKIP
             '       OR XL_Trans2.Trans_String = ? THEN NEXT recordLoop.'    SKIP
             '    ELSE cSource = XL_Trans2.Trans_String.'                    SKIP(1)
             '    FIND FIRST xlatedb.XL_Instance WHERE'                      SKIP
             '           xlatedb.XL_Instance.Sequence_Num ='
             ' XL_Trans2.Sequence_Num'                                       SKIP
             '       AND xlatedb.XL_Instance.Instance_Num ='
             ' XL_Trans2.Instance_Num'                                       SKIP
             '    NO-LOCK NO-ERROR.'                                         SKIP
             '    FIND FIRST xlatedb.XL_String_Info WHERE'                   SKIP
             '       xlatedb.XL_String_Info.Sequence_Num ='
             ' XL_Trans2.Sequence_Num'                                       SKIP
             '    NO-LOCK NO-ERROR.'                                         SKIP(1)
             .
    END.  /* Translated Strings */
                
    PUT UNFORMATTED
       '    ASSIGN'                                                       SKIP
       '       piRecCnt = piRecCnt + 1'                                   SKIP
       '       cJustification ='                                          SKIP
       '          IF      xlatedb.XL_Instance.Justification = 1 THEN "Left"'   SKIP
       '          ELSE IF xlatedb.XL_Instance.Justification = 2 THEN "Right"'  SKIP
       '          ELSE IF xlatedb.XL_Instance.Justification = 3 THEN "Center"' SKIP
       '          ELSE "Trim"'                                            SKIP
       '       cTranslation = IF AVAILABLE xlatedb.XL_Translation THEN'   SKIP
       '                        xlatedb.XL_Translation.Trans_String'      SKIP
       '                      ELSE ?.'                                    SKIP(1)
       '    /* DATA */'                                                   SKIP
       '    PUT UNFORMATTED'                                              SKIP 
       '       xlatedb.XL_Instance.Sequence_Num "," '                     SKIP
       '       xlatedb.XL_Instance.Instance_Num "," '                     SKIP
       '       FormatExportString(cSource) "," '                          SKIP
       '       FormatExportString(cTranslation) "," '                     SKIP
       '       xlatedb.XL_Instance.Num_Occurs "," '                       SKIP
       '       xlatedb.XL_Instance.Line_Num "," '                         SKIP
       '       cJustification "," '                                       SKIP
       '       xlatedb.XL_Instance.MaxLength "," '                        SKIP
       '       xlatedb.XL_Instance.ObjectName "," '                       SKIP
       '       xlatedb.XL_Instance.Statement "," '                        SKIP
       '       xlatedb.XL_Instance.Item "," '                             SKIP
       '       xlatedb.XL_String_Info.Comment'                            SKIP
       '       SKIP.'                                                     SKIP
       ' END. /* FOR EACH */'                                             SKIP(1)
       ' OUTPUT CLOSE.'                                                   SKIP(1)
       ' PROCEDURE ADEPersistent:'                                        SKIP
       '    RETURN "OK".'                                                 SKIP
       ' END.'                                                            SKIP
    .
           
   OUTPUT CLOSE.
   IF VALID-HANDLE(_hExport) THEN DELETE PROCEDURE _hExport.

   RUN VALUE(cTempFile) PERSISTENT SET _hExport (OUTPUT piRecordCount).

   IF VALID-HANDLE(_hExport) THEN DELETE PROCEDURE _hExport.
   OS-DELETE VALUE(cTempFile).

   ThisMessage = STRING(piRecordCount) + " Records exported.".
   RUN adecomm/_s-alert.p (INPUT-OUTPUT lErrorStatus, "i*":U, "ok":U, ThisMessage).
   
   RUN adecomm/_setcurs.p ("":U).

   IF piRecordCount LE 0 THEN OS-DELETE VALUE(cExportFile).

END. /* Do with Frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame 
PROCEDURE Realize :
ASSIGN ShortHeight = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS.
   DISPLAY FromLabel FileName FileNameLabel ReplaceIfExists CodePage
           LanguageLabel GlossaryName TargetLanguage SourceLanguage
           exportStringLabel rdExportString
   WITH FRAME Dialog-Frame.
   ENABLE Btn_OK Btn_Cancel BtnFile FileName ReplaceIfExists Btn_Help CodePage 
         Btn_Options GlossaryName TargetLanguage SourceLanguage rdExportString 
         FromLabel LanguageLabel exportStringLabel Rect-4 Rect-5 Rect2 
      WITH FRAME Dialog-Frame.

   ASSIGN 
      FullHeight                  = FRAME {&FRAME-NAME}:HEIGHT
      RECT-5:HIDDEN               = TRUE
      exportStringLabel:HIDDEN    = TRUE
      rdExportString:HIDDEN       = TRUE
      OptionState                 = TRUE
      Btn_Options:LABEL           = "&Options >>"
      FRAME {&FRAME-NAME}:HEIGHT  = Rect2:ROW + Rect2:HEIGHT + 0.6.
     
   ASSIGN ShortHeight = FRAME {&FRAME-NAME}:HEIGHT.
   VIEW FRAME {&FRAME-NAME}.
   RUN adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetLanguages Dialog-Frame 
PROCEDURE SetLanguages :
DO WITH FRAME {&FRAME-NAME}:
    SourceLanguage = "".
    FOR EACH xlatedb.XL_Language NO-LOCK:
      SourceLanguage = if SourceLanguage = "" THEN 
                           xlatedb.XL_Language.Lang_Name
                        else 
                           SourceLanguage + ",":U + xlatedb.XL_Language.Lang_Name.
    END.
    ASSIGN
      SourceLanguage:list-items   = SourceLanguage + ",<unnamed>":U
      SourceLanguage              = "":U
      SourceLanguage:SCREEN-VALUE = "<unnamed>":U.
  END.
END PROCEDURE. /* SetLanguages */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

