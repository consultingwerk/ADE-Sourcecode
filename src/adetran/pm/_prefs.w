&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_prefs.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
Purpose:      Dialog which allows the user to set preference settings
              for the session.  In turn, these settings are written
              out to the progress.ini file and read back in.  A number
              of shared variables keep track of this information. 
              
               -Supress Warnings during Extract
               -Supress Warning during RC file 
               -Supress Warning during Add Procedure 
               -Supress Ask during Replace String 

Notes:        Some of the setting are disabled or are not functioning:

               -Language (the displayed translated language)
               
Called By:    pm/_pmmain.p
*/



{ adetran/pm/tranhelp.i } /* definitions for help context strings */  

DEFINE SHARED VARIABLE _hTrans     AS HANDLE  NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 BtnOK _FullPathFlag ~
BtnCancel _ExtractWarnings _RCWarnings BtnHelp _AddProcWarnings ~
_SuppressReplaceAsk ZipCompression OptionsLabel ZipLabel ~
compresslbl compresslbl2 
&Scoped-Define DISPLAYED-OBJECTS _FullPathFlag _ExtractWarnings _RCWarnings ~
_AddProcWarnings _SuppressReplaceAsk ZipCompression ~
OptionsLabel ZipLabel compresslbl compresslbl2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE compresslbl AS CHARACTER FORMAT "X(256)":U INITIAL "Compression Factor" 
      VIEW-AS TEXT 
     SIZE 21 BY .62 NO-UNDO.

DEFINE VARIABLE compresslbl2 AS CHARACTER FORMAT "X(256)":U INITIAL "(1=lowest, 10=highest)" 
      VIEW-AS TEXT 
     SIZE 23 BY .62 NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Options" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .65 NO-UNDO.

DEFINE VARIABLE ZipLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Zip Options" 
      VIEW-AS TEXT 
     SIZE 12.57 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61.43 BY 4.65.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61 BY 2.69.

DEFINE VARIABLE ZipCompression AS INTEGER INITIAL 10 
     VIEW-AS SLIDER MIN-VALUE 1 MAX-VALUE 10 HORIZONTAL 
     SIZE 13 BY 1.92 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE _AddProcWarnings AS LOGICAL INITIAL no 
     LABEL "Suppress Messages During &Add Procedure" 
     VIEW-AS TOGGLE-BOX
     SIZE 52.57 BY .77 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE _SuppressReplaceAsk AS LOGICAL INITIAL no 
     LABEL "Suppress Messages During String &Replace" 
     VIEW-AS TOGGLE-BOX
     SIZE 52.57 BY .77 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE _ExtractWarnings AS LOGICAL INITIAL no 
     LABEL "Suppress Messages During &Extract" 
     VIEW-AS TOGGLE-BOX
     SIZE 53 BY .77 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE _FullPathFlag AS LOGICAL INITIAL no 
     LABEL "Display Procedures With &Full-Pathnames" 
     VIEW-AS TOGGLE-BOX
     SIZE 49.57 BY .77 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE _RCWarnings AS LOGICAL INITIAL no 
     LABEL "Suppress Messages During .rc File &Generation" 
     VIEW-AS TOGGLE-BOX
     SIZE 52.57 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BtnOK AT ROW 1.46 COL 65
     _FullPathFlag AT ROW 2.15 COL 4
     BtnCancel AT ROW 2.81 COL 65
     _ExtractWarnings AT ROW 2.92 COL 4
     _RCWarnings AT ROW 3.69 COL 4
     BtnHelp AT ROW 4.04 COL 65
     _AddProcWarnings AT ROW 4.46 COL 4
     _SuppressReplaceAsk AT ROW 5.31 COL 4
     ZipCompression AT ROW 7.04 COL 25.43 NO-LABEL
     OptionsLabel AT ROW 1.27 COL 4 NO-LABEL
     ZipLabel AT ROW 6.38 COL 4 NO-LABEL
     compresslbl AT ROW 7.5 COL 2.43 COLON-ALIGNED NO-LABEL
     compresslbl2 AT ROW 7.5 COL 38.43 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 6.81 COL 3
     RECT-1 AT ROW 1.54 COL 2.57
     SPACE(15.99) SKIP(3.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Preferences"
         DEFAULT-BUTTON BtnCancel CANCEL-BUTTON BtnCancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN OptionsLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ZipLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX _AddProcWarnings IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX _SuppressReplaceAsk IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX _ExtractWarnings IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX _FullPathFlag IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX _RCWarnings IN FRAME DIALOG-1
   SHARED                                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp DIALOG-1
ON CHOOSE OF BtnHelp IN FRAME DIALOG-1 /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  run adecomm/_adehelp.p ("tran","context",{&Preferences_Dlgbx}, ?).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK DIALOG-1
ON CHOOSE OF BtnOK IN FRAME DIALOG-1 /* OK */
DO:
  DEFINE VARIABLE reopen AS LOGICAL               NO-UNDO.
  reopen = (_FullPathFlag NE _FullPathFlag:CHECKED).
  assign _FullPathFlag           = _FullPathFlag:checked
         _ExtractWarnings       = _ExtractWarnings:CHECKED
         _RCWarnings            = _RCWarnings:CHECKED
         _AddProcWarnings       = _AddProcWarnings:CHECKED
         _SuppressReplaceAsk      = _SuppressReplaceAsk:CHECKED
         ZipCompression         = INT(ZipCompression:SCREEN-VALUE).
  RUN Put_Zip_INI.
  IF CONNECTED ("xlatedb") AND reopen AND CurrentMode = 2 THEN
     RUn OpenQuery IN _hTrans.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   RUN enable_UI.            
   
  assign
    _FullPathFlag:checked     = _FullPathFlag
    _ExtractWarnings:checked  = _ExtractWarnings
    _RCWarnings:checked       = _RCWarnings
    _AddProcWarnings:checked  = _AddProcWarnings
    _SuppressReplaceAsk:checked = _SuppressReplaceAsk
    OptionsLabel:screen-value = "Options"
    OptionsLabel:width        = font-table:get-text-width-chars(OptionsLabel:screen-value,4)
    ZipLabel:screen-value     = "Zip Options"
    ZipLabel:width            = font-table:get-text-width-chars(ZipLabel:screen-value,4)
    compresslbl:screen-value  = "Compression Factor:"
    compresslbl:width         = font-table:get-text-width-chars(compresslbl:screen-value,4)
    compresslbl2:screen-value = "(1=lowest,10=highest)"
    compresslbl2:width        = font-table:get-text-width-chars(compresslbl2:screen-value,4)
    .
  RUN Get_Zip_INI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 
PROCEDURE enable_UI :
ENABLE ALL WITH FRAME DIALOG-1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_Zip_INI DIALOG-1 
PROCEDURE Get_Zip_INI :
/*------------------------------------------------------------------------------
  Purpose:     Gets ZIP INI settings from the INI file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE inp AS CHARACTER NO-UNDO.
  
DO WITH FRAME {&FRAME-NAME}:
  USE "".
  GET-KEY-VALUE SECTION "Translation Manager":U key "ZipCompFactor":U value inp.
  IF inp = ? OR inp = "" OR INT(inp) < 1 OR INT(inp) > 10 THEN
    ASSIGN ZipCompression = 5.
  ELSE
    ASSIGN ZipCompression = INT(inp).
    
  ASSIGN ZipCompression:SCREEN-VALUE = STRING(ZipCompression).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Put_Zip_INI DIALOG-1 
PROCEDURE Put_Zip_INI :
/*------------------------------------------------------------------------------
  Purpose:     Save Preference settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ErrorStatus AS LOGICAL NO-UNDO INIT YES.
  
  PUT-KEY-VALUE SECTION "Translation Manager":U 
                KEY     "ZipCompFactor":U 
                VALUE   STRING(ZipCompression) NO-ERROR.
    
  IF ERROR-STATUS:ERROR THEN
    RUN adecomm/_s-alert.p (
       INPUT-OUTPUT ErrorStatus,
       "w*":u,
       "ok":u,
       "Unable to save Translation Manager Preference settings.^^The PROGRESS environment file may be read-only or it may be located in a directory where you do not have write permissions.").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

