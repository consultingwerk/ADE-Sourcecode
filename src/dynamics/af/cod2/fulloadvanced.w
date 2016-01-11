&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME fSDOGenAdvanced
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fSDOGenAdvanced 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pcSDOTemplate    AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcSuffix         AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcLogicTemplate  AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcLogicSuffix    AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcLogFile        AS CHAR NO-UNDO.
/* &IF "{&scmTool}" = "RTB":U */
DEFINE INPUT-OUTPUT PARAMETER pcWspace         /* rtb */  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcSDOGroup       /* rtb */  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcLogicGroup     /* rtb */  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcSDOSubType     /* rtb */  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcTask           /* rtb */  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcLogicSubType   /* rtb */  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plLogicOverWrite /* rtb */  AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plSDOOverwrite   /* rtb */  AS LOGICAL NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER plAppendToLogfile             AS LOGICAL              NO-UNDO. 
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fSDOGenAdvanced

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiTemplate fiSuffix fiLogicTemplate ~
fiLogicSuffix fiLogFile toAppendToLog ToSDOOverwrite ToLogicOverwrite ~
fiSDOGroup fiLogicGroup fiSDOSubtype fiLogicSubtype Btn_OK Btn_Cancel ~
Btn_Help RECT-6 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-OBJECTS fiTemplate fiSuffix fiLogicTemplate ~
fiLogicSuffix fiLogFile toAppendToLog fiWspace ToSDOOverwrite ~
ToLogicOverwrite fiTask fiSDOGroup fiLogicGroup fiSDOSubtype fiLogicSubtype 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
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

DEFINE VARIABLE fiLogFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Log &File" 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 TOOLTIP "Enter the name of the log file where the status and errors would be logged" NO-UNDO.

DEFINE VARIABLE fiLogicGroup AS CHARACTER FORMAT "X(256)":U 
     LABEL "Logic Gr&oup" 
     VIEW-AS FILL-IN 
     SIZE 20.8 BY 1 TOOLTIP "Specify SDO Logic Procedure Group (usually same as subtype)" NO-UNDO.

DEFINE VARIABLE fiLogicSubtype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Logic Subtyp&e" 
     VIEW-AS FILL-IN 
     SIZE 20.8 BY 1 TOOLTIP "Specify SDO Logic Procedure subtype, e.g. DLProc" NO-UNDO.

DEFINE VARIABLE fiLogicSuffix AS CHARACTER FORMAT "X(256)":U INITIAL "logcp.p" 
     LABEL "Logic Suffi&x" 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 TOOLTIP "A suffix for the selected table's dump name when creating SDO logic" NO-UNDO.

DEFINE VARIABLE fiLogicTemplate AS CHARACTER FORMAT "X(256)":U INITIAL "ry/obj/rytemlogic.p" 
     LABEL "&Logic Template" 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 TOOLTIP "A Template Filename from which to take default information for the SDO logic" NO-UNDO.

DEFINE VARIABLE fiSDOGroup AS CHARACTER FORMAT "X(256)":U 
     LABEL "SDO Grou&p" 
     VIEW-AS FILL-IN 
     SIZE 20.8 BY 1 TOOLTIP "Specify SDO Group (usually same as subtype)" NO-UNDO.

DEFINE VARIABLE fiSDOSubtype AS CHARACTER FORMAT "X(256)":U 
     LABEL "SDO Subt&ype" 
     VIEW-AS FILL-IN 
     SIZE 20.8 BY 1 TOOLTIP "Specify SDO subtype, e.g. SDO" NO-UNDO.

DEFINE VARIABLE fiSuffix AS CHARACTER FORMAT "X(256)":U INITIAL "fullo.w" 
     LABEL "S&uffix" 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 TOOLTIP "A suffix for the selected table's dump name when creating a SmartDataObject" NO-UNDO.

DEFINE VARIABLE fiTask AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Tas&k" 
     VIEW-AS FILL-IN 
     SIZE 20.8 BY 1 TOOLTIP "Current selected task number in SCM" NO-UNDO.

DEFINE VARIABLE fiTemplate AS CHARACTER FORMAT "X(256)":U INITIAL "ry/obj/rysttasdoo.w" 
     LABEL "&SDO Template" 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 TOOLTIP "A Template Filename from which to take default information for the SDO" NO-UNDO.

DEFINE VARIABLE fiWspace AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Workspace" 
     VIEW-AS FILL-IN 
     SIZE 20.8 BY 1 TOOLTIP "Name of current SCM workspace selected" NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.4 BY 6.43.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.4 BY 1.67.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.4 BY 6.43.

DEFINE VARIABLE toAppendToLog AS LOGICAL INITIAL no 
     LABEL "&Append?" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.8 BY .81 TOOLTIP "Check to always append to an existing log file" NO-UNDO.

DEFINE VARIABLE ToLogicOverwrite AS LOGICAL INITIAL no 
     LABEL "Overwite Logi&c in task" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.6 BY .81 TOOLTIP "If SDO Logic is found checked-out in the selected task, it will be overwritten" NO-UNDO.

DEFINE VARIABLE ToSDOOverwrite AS LOGICAL INITIAL yes 
     LABEL "Ove&rwite SDO in task" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.6 BY .81 TOOLTIP "If a SDO is found checked-out in the selected task, it will be overwritten" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fSDOGenAdvanced
     fiTemplate AT ROW 2.05 COL 22 COLON-ALIGNED
     fiSuffix AT ROW 3.1 COL 22 COLON-ALIGNED
     fiLogicTemplate AT ROW 4.14 COL 22 COLON-ALIGNED
     fiLogicSuffix AT ROW 5.19 COL 22 COLON-ALIGNED
     fiLogFile AT ROW 6.24 COL 22 COLON-ALIGNED
     toAppendToLog AT ROW 6.43 COL 60.8
     fiWspace AT ROW 8.86 COL 16 COLON-ALIGNED
     ToSDOOverwrite AT ROW 8.86 COL 57
     ToLogicOverwrite AT ROW 9.81 COL 57
     fiTask AT ROW 9.91 COL 16 COLON-ALIGNED
     fiSDOGroup AT ROW 11.43 COL 16 COLON-ALIGNED
     fiLogicGroup AT ROW 11.43 COL 55 COLON-ALIGNED
     fiSDOSubtype AT ROW 12.48 COL 16 COLON-ALIGNED
     fiLogicSubtype AT ROW 12.48 COL 55 COLON-ALIGNED
     Btn_OK AT ROW 14.71 COL 2.8
     Btn_Cancel AT ROW 14.71 COL 18.4
     Btn_Help AT ROW 14.71 COL 70.6
     RECT-6 AT ROW 1.24 COL 2
     RECT-7 AT ROW 14.43 COL 2
     RECT-8 AT ROW 7.71 COL 2
     "Source Control Management" VIEW-AS TEXT
          SIZE 32 BY .95 AT ROW 7.91 COL 4
     SPACE(50.40) SKIP(7.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Advanced Settings for Object Generator"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX fSDOGenAdvanced
                                                                        */
ASSIGN 
       FRAME fSDOGenAdvanced:SCROLLABLE       = FALSE
       FRAME fSDOGenAdvanced:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiTask IN FRAME fSDOGenAdvanced
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiWspace IN FRAME fSDOGenAdvanced
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fSDOGenAdvanced
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fSDOGenAdvanced fSDOGenAdvanced
ON WINDOW-CLOSE OF FRAME fSDOGenAdvanced /* Advanced Settings for Object Generator */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help fSDOGenAdvanced
ON CHOOSE OF Btn_Help IN FRAME fSDOGenAdvanced /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: 
  /* Help for this Frame */

  RUN adecomm/_adehelp.p
                ("ICAB", "CONTEXT", {&Adv_Settings_for_Object_Generator_Dlg_Box}  , "").


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK fSDOGenAdvanced
ON CHOOSE OF Btn_OK IN FRAME fSDOGenAdvanced /* OK */
DO:
    DEFINE VARIABLE cDirectory AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lContinue  AS LOGICAL INITIAL YES NO-UNDO.

    IF SEARCH(fiTemplate:SCREEN-VALUE) = ? THEN
    DO:
       MESSAGE 
           "Template file not found. Template file must exist in a directory in the propath.".
       RETURN NO-APPLY.
    END.
    IF SEARCH(fiLogicTemplate:SCREEN-VALUE) = ? THEN
    DO:
       MESSAGE 
           "Logic Template file not found. Template file must exist in a directory in the propath.".
       RETURN NO-APPLY.
    END.
    IF fiSDOSubtype:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "The SDO object type must be specified.".
        RETURN NO-APPLY.
    END.

    IF fiLogicSubtype:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "The Logic Procedure object type must be specified.".
        RETURN NO-APPLY.
    END.
        
    IF fiLogFile:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "The Log File must be specified.".
        RETURN NO-APPLY.
    END.

    IF fiSuffix:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "The Suffix must be specified.".
        RETURN NO-APPLY.
    END.
    
    IF fiLogicSuffix:SCREEN-VALUE = "":U THEN DO:
        MESSAGE "The Logical Suffix must be specified.".
        RETURN NO-APPLY.
    END.

    ASSIGN 
        pcSDOTemplate   = fiTemplate:SCREEN-VALUE
        pcSuffix        = fiSuffix:SCREEN-VALUE
        pcLogicTemplate = fiLogicTemplate:SCREEN-VALUE
        pcLogicSuffix   = fiLogicSuffix:SCREEN-VALUE
        pcwspace        = fiwspace:SCREEN-VALUE
        pcSDOGroup      = fiSDOGroup:SCREEN-VALUE
        pcLogicGroup    = fiLogicGroup:SCREEN-VALUE
        pcSDOSubType    = fiSDOSubType:SCREEN-VALUE
        pcTask          = fiTask:SCREEN-VALUE
        pcLogicSubType    = fiLogicSubType:SCREEN-VALUE
        pllogicOverWrite  = toLogicOverwrite:CHECKED
        plSDOOverWrite    = toSDOOverWrite:CHECKED
        plAppendToLogFile = toAppendToLog:CHECKED
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fSDOGenAdvanced 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN populateScreen IN THIS-PROCEDURE.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fSDOGenAdvanced  _DEFAULT-DISABLE
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
  HIDE FRAME fSDOGenAdvanced.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fSDOGenAdvanced  _DEFAULT-ENABLE
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
  DISPLAY fiTemplate fiSuffix fiLogicTemplate fiLogicSuffix fiLogFile 
          toAppendToLog fiWspace ToSDOOverwrite ToLogicOverwrite fiTask 
          fiSDOGroup fiLogicGroup fiSDOSubtype fiLogicSubtype 
      WITH FRAME fSDOGenAdvanced.
  ENABLE fiTemplate fiSuffix fiLogicTemplate fiLogicSuffix fiLogFile 
         toAppendToLog ToSDOOverwrite ToLogicOverwrite fiSDOGroup fiLogicGroup 
         fiSDOSubtype fiLogicSubtype Btn_OK Btn_Cancel Btn_Help RECT-6 RECT-7 
         RECT-8 
      WITH FRAME fSDOGenAdvanced.
  VIEW FRAME fSDOGenAdvanced.
  {&OPEN-BROWSERS-IN-QUERY-fSDOGenAdvanced}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateScreen fSDOGenAdvanced 
PROCEDURE populateScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  ASSIGN 
    fiTemplate:SCREEN-VALUE      = pcSDOTemplate
    fiSuffix:SCREEN-VALUE        = pcSuffix
    fiLogicTemplate:SCREEN-VALUE = pcLogicTemplate
    fiLogicSuffix:SCREEN-VALUE   = pcLogicSuffix
    fiLogFile:SCREEN-VALUE       = pcLogFile
    fiWspace:SCREEN-VALUE        = pcWspace          /* rtb */
    fiSDOGroup:SCREEN-VALUE      = pcSDOGroup        /* rtb */
    fiLogicGroup:SCREEN-VALUE    = pcLogicGroup      /* rtb */
    fiSDOSubType:SCREEN-VALUE    = pcSDOSubType      /* rtb */
    fiTask:SCREEN-VALUE          = pcTask            /* rtb */
    fiLogicSubType:SCREEN-VALUE  = pcLogicSubType    /* rtb */
    toLogicOverwrite:CHECKED     = plLogicOverWrite  /* rtb */
    toSDOOverwrite:CHECKED       = plSDOOverwrite    /* rtb */
    toAppendToLog:CHECKED        = plAppendToLogFile
    .

  IF NOT CONNECTED("RTB":U)
  THEN
    ASSIGN 
      fiWspace:SENSITIVE         = NO                /* rtb */
      fiSDOGroup:SENSITIVE       = NO                /* rtb */
      fiLogicGroup:SENSITIVE     = NO                /* rtb */
      fiSDOSubType:SENSITIVE     = NO                /* rtb */
      fiTask:SENSITIVE           = NO                /* rtb */
      fiLogicSubType:SENSITIVE   = NO                /* rtb */
      toLogicOverwrite:SENSITIVE = NO                /* rtb */
      toSDOOverwrite:SENSITIVE   = NO                /* rtb */
      .

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

