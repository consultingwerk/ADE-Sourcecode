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
{ adetran/vt/vthlp.i } /* definitions for help context strings */  

define shared var hLkUp  as handle no-undo.
define shared var hMain  as handle no-undo.
define shared var hProcs as handle no-undo.
define shared var hProps as handle no-undo.
define shared var hTrans as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK RECT-3 CurLanguage BtnCancel RECT-1 ~
AutoTrans BtnHelp PropsOnTop GlossaryOnTop ConfirmAdds FullPathFlag RECT-4 ~
Priv1 Priv2 RECT-2 ZipCompression LangLabel ~
OptionsLabel PrivLabel ZipLabel compresslbl2 compresslbl
&Scoped-Define DISPLAYED-OBJECTS CurLanguage AutoTrans PropsOnTop ~
GlossaryOnTop ConfirmAdds FullPathFlag Priv1 Priv2 ZipCompression ~
LangLabel OptionsLabel PrivLabel ZipLabel compresslbl2 ~
compresslbl 

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

DEFINE {&NEW} SHARED VARIABLE CurLanguage AS CHARACTER FORMAT "X(256)":U INITIAL ? 
     LABEL "Display" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "English","French","Spanish","Dutch","German","Russian","Czech","Japanese","Korean","Chinese (Traditional)" 
     SIZE 45.57 BY 1 NO-UNDO.

DEFINE VARIABLE compresslbl AS CHARACTER FORMAT "X(256)":U INITIAL "Compression Factor" 
      VIEW-AS TEXT 
     SIZE 21 BY .62 NO-UNDO.

DEFINE VARIABLE compresslbl2 AS CHARACTER FORMAT "X(256)":U INITIAL "(1=lowest, 10=highest)" 
      VIEW-AS TEXT 
     SIZE 23 BY .62 NO-UNDO.

DEFINE VARIABLE LangLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Languages" 
      VIEW-AS TEXT 
     SIZE 13.14 BY .65 NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Options" 
      VIEW-AS TEXT 
     SIZE 7.86 BY .65 NO-UNDO.

DEFINE VARIABLE PrivLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Translator Privileges" 
      VIEW-AS TEXT 
     SIZE 21.14 BY .58 NO-UNDO.

DEFINE VARIABLE ZipLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Zip Options" 
      VIEW-AS TEXT 
     SIZE 13.14 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 4.19.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 2.69.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 1.42.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 2.04.

DEFINE VARIABLE ZipCompression AS INTEGER INITIAL 10 
     VIEW-AS SLIDER MIN-VALUE 1 MAX-VALUE 10 HORIZONTAL 
     SIZE 14 BY 1.96 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE AutoTrans AS LOGICAL INITIAL ? 
     LABEL "&Automatic Translations When Visualized" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE ConfirmAdds AS LOGICAL INITIAL ? 
     LABEL "&Confirm New Additions To The Glossary" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE FullPathFlag AS LOGICAL INITIAL ? 
     LABEL "Display Procedures With &Full-Pathnames" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE GlossaryOnTop AS LOGICAL INITIAL ? 
     LABEL "Display Glossary Window As Always On &Top" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE Priv1 AS LOGICAL INITIAL ? 
     LABEL "Must &Use Glossary For Translations" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE Priv2 AS LOGICAL INITIAL ? 
     LABEL "Can &Modify Glossary Entries" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE PropsOnTop AS LOGICAL INITIAL ? 
     LABEL "Display Properties Window As Always On &Top" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .65 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BtnOK AT ROW 1.46 COL 69
     CurLanguage AT ROW 1.77 COL 12.43 COLON-ALIGNED
     BtnCancel AT ROW 2.81 COL 69
     AutoTrans AT ROW 3.77 COL 4
     BtnHelp AT ROW 4.04 COL 69
     PropsOnTop AT ROW 4.46 COL 4
     GlossaryOnTop AT ROW 5.15 COL 4
     ConfirmAdds AT ROW 5.85 COL 4
     FullPathFlag AT ROW 6.54 COL 4
     Priv1 AT ROW 8.31 COL 4
     Priv2 AT ROW 8.96 COL 4
     ZipCompression AT ROW 10.58 COL 25 NO-LABEL
     LangLabel AT ROW 1.23 COL 3.86 NO-LABEL
     OptionsLabel AT ROW 3.12 COL 3.86 NO-LABEL
     PrivLabel AT ROW 7.58 COL 3.86 NO-LABEL
     ZipLabel AT ROW 10.15 COL 3.86 NO-LABEL
     compresslbl2 AT ROW 11.04 COL 40 COLON-ALIGNED NO-LABEL
     compresslbl AT ROW 11.15 COL 1 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1.54 COL 2
     RECT-1 AT ROW 3.31 COL 2
     RECT-4 AT ROW 7.85 COL 2
     RECT-2 AT ROW 10.35 COL 2
     SPACE(24.28) SKIP(0.45)
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR TOGGLE-BOX AutoTrans IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX ConfirmAdds IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR COMBO-BOX CurLanguage IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX FullPathFlag IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX GlossaryOnTop IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR FILL-IN LangLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN OptionsLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX Priv1 IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR TOGGLE-BOX Priv2 IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR FILL-IN PrivLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX PropsOnTop IN FRAME DIALOG-1
   SHARED                                                               */
/* SETTINGS FOR FILL-IN ZipLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp DIALOG-1
ON CHOOSE OF BtnHelp IN FRAME DIALOG-1 /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  run adecomm/_adehelp.p ("vt":u,"context":u,{&Preferences_Dialog_Box}, ?).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK DIALOG-1
ON CHOOSE OF BtnOK IN FRAME DIALOG-1 /* OK */
DO:
  assign
    CurLanguage     = CurLanguage:screen-value
    AutoTrans       = AutoTrans:checked
    PropsOnTop      = PropsOnTop:checked
    GlossaryOnTop   = GlossaryOnTop:checked
    ConfirmAdds     = ConfirmAdds:checked
    FullPathFlag    = FullPathFlag:checked
    ZipCompression  = INT(ZipCompression:SCREEN-VALUE).
  RUN PUT_ZIP_INI.
  
  IF VALID-HANDLE(hProcs) THEN RUN OpenQuery   IN hProcs.
  IF VALID-HANDLE(hProps) THEN RUN AlwaysOnTop IN hProps.
  IF VALID-HANDLE(hTrans) THEN RUN OpenQuery   IN hTrans.
  IF VALID-HANDLE(hLkUp)  THEN RUN AlwaysONTop IN hLkUp.
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
    CurLanguage:screen-value  = if CurLanguage = ? or CurLanguage = "" 
                                then "English" 
                                else CurLanguage
    AutoTrans:checked         = AutoTrans
    PropsOnTop:checked        = PropsOnTop
    GlossaryOnTop:checked     = GlossaryOnTop
    ConfirmAdds:checked       = ConfirmAdds
    FullPathFlag:checked      = FullPathFlag
    Priv1:checked             = Priv1
    Priv2:checked             = Priv2
    LangLabel:screen-value    = "Languages"
    LangLabel:width           = font-table:get-text-width-chars(LangLabel:screen-value,4)
    OptionsLabel:screen-value = "Translation Options"
    OptionsLabel:width        = font-table:get-text-width-chars(OptionsLabel:screen-value,4)
    PrivLabel:screen-value    = "Translator Privileges"
    PrivLabel:width           = font-table:get-text-width-chars(PrivLabel:screen-value,4)
    ZipLabel:screen-value     = "Zip Options"
    ZipLabel:width            = font-table:get-text-width-chars(ZipLabel:screen-value,4)
    compresslbl:screen-value  = "Compression Factor:"
    compresslbl:width         = font-table:get-text-width-chars(compresslbl:screen-value,4)
    compresslbl2:screen-value = "(1=lowest,10=highest)"
    compresslbl2:width        = font-table:get-text-width-chars(compresslbl2:screen-value,4).

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
ENABLE ALL EXCEPT CurLanguage PRIV1 PRIV2 WITH FRAME DIALOG-1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get_ZIP_INI DIALOG-1 
PROCEDURE Get_ZIP_INI :
/*------------------------------------------------------------------------------
  Purpose:     Read ZIP settings from INI file.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Put_ZIP_INI DIALOG-1 
PROCEDURE Put_ZIP_INI :
/*------------------------------------------------------------------------------
  Purpose:     Save zip settings to INI file.
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


