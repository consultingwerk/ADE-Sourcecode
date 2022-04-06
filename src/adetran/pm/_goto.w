&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME GotoWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS GotoWindow 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_goto.w
Author:       SLK
Created:      7/13/98 
Updated:     
Purpose:      Translation Manager's 'Goto' window
Background:   Comparable TO the vt/_find.w, this goto facility
              allows the translator a dIFferent was TO find 
              translation records (it doesn't work with the
              glossary).  Like the find program, _goto.w is a
              HIDDEN persistent window that is RUN *only* after
              a database is connected - THEN it is HIDDEN.  This
              window is DISPLAYed WHEN the user selects TO goto
              menu item IN the main menu.  'Close' simply rehides
              the window.
Called By:    pm/_pmmain.p
*/

{ adetran/vt/vthlp.i } /* definitions for help context strings */  
DEFINE SHARED VARIABLE _MainWindow  AS widget-handle  NO-UNDO.  
DEFINE SHARED VARIABLE CurrentMode  AS INTEGER  NO-UNDO.                  
DEFINE SHARED VARIABLE _hTrans      AS WIDGET-HANDLE  NO-UNDO.    
DEFINE SHARED VARIABLE _hGloss      AS WIDGET-HANDLE  NO-UNDO.    
DEFINE SHARED VARIABLE _Lang        AS CHARACTER  NO-UNDO.                  
DEFINE        VARIABLE hReplace     AS HANDLE  NO-UNDO.
DEFINE        VARIABLE RecNum       AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Category BtnGoto BtnClose BtnHelp ~
CategoryLabel IMAGE-1 RECT-6 
&Scoped-Define DISPLAYED-OBJECTS Category CategoryLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR GotoWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnClose 
     LABEL "&Close":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnGoto 
     LABEL "&Goto":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE CategoryLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Option" 
      VIEW-AS TEXT 
     SIZE 9.4 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adetran\images\find":U
     SIZE 3.2 BY .67.

DEFINE VARIABLE Category AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Top", "T":U,
"&Bottom", "B":U,
"&First Untranslated Target", "F":U,
"&Next Untranslated Target", "N":U
     SIZE 32.6 BY 3.48 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 4.05.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     Category AT ROW 2.14 COL 8.6 NO-LABEL
     BtnGoto AT ROW 1.57 COL 58
     BtnClose AT ROW 2.81 COL 58
     BtnHelp AT ROW 4.05 COL 58
     CategoryLabel AT ROW 1.48 COL 8.6 NO-LABEL
     IMAGE-1 AT ROW 1 COL 2
     RECT-6 AT ROW 1.81 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74 BY 5.33
         FONT 4
         DEFAULT-BUTTON BtnGoto.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW GotoWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Goto"
         HEIGHT             = 5.33
         WIDTH              = 74
         MAX-HEIGHT         = 7.29
         MAX-WIDTH          = 81.6
         VIRTUAL-HEIGHT     = 7.29
         VIRTUAL-WIDTH      = 81.6
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT GotoWindow:LOAD-ICON("adetran/images/props%":U) THEN
    MESSAGE "Unable to load icon: adetran/images/props%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW GotoWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   L-To-R,COLUMNS                                                       */
/* SETTINGS FOR FILL-IN CategoryLabel IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(GotoWindow)
THEN GotoWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME GotoWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GotoWindow GotoWindow
ON WINDOW-CLOSE OF GotoWindow /* Goto */
DO:
  GotoWindow:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose GotoWindow
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  GotoWindow:HIDDEN = TRUE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnGoto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnGoto GotoWindow
ON CHOOSE OF BtnGoto IN FRAME DEFAULT-FRAME /* Goto */
DO:
  DEFINE VARIABLE intval AS INTEGER                          NO-UNDO.
  DEFINE VARIABLE stringInfoKeyOfString AS CHARACTER         NO-UNDO.
  DEFINE VARIABLE stringROWID           AS ROWID         NO-UNDO.
  DEFINE VARIABLE instanceROWID         AS ROWID         NO-UNDO.
  DEFINE VARIABLE instanceNum           AS INTEGER           NO-UNDO.
  
  CASE Category:SCREEN-VALUE:
    WHEN "F":u THEN 
    DO: /* First Untranslated */
      FLoop:
      FOR EACH xlatedb.xl_string_info NO-LOCK USE-INDEX String_Key:
          FOR EACH xlatedb.xl_instance WHERE 
                 xlatedb.xl_instance.sequence_num = xlatedb.xl_string_info.sequence_num
          NO-LOCK:
             FIND FIRST xlatedb.xl_translation WHERE
                    xlatedb.xl_instance.sequence_num = xlatedb.xl_translation.sequence_num
                AND xlatedb.xl_instance.instance_num = xlatedb.xl_translation.instance_num
                AND _Lang = xlatedb.xl_translation.lang_name
                NO-LOCK NO-ERROR.
             IF NOT AVAILABLE xlatedb.xl_translation THEN
             DO:
                 /* NOTE that this will NOT reposition to the exact location */
                 Run Repo in _hTrans (INPUT ROWID(xlatedb.XL_string_info),
                                     INPUT ROWID(xlatedb.XL_instance),
                                     INPUT ?,
                                     INPUT ?).
                 LEAVE FLoop.
             END. /* NOT AVAIL translation */
          END. /* EACH xl_instance */
      END. /* EACH xl_string_info */
    END.
    
    WHEN "N":u THEN
    DO: /* Next Untranslated */
      ASSIGN stringInfoKeyOfString = IF AVAILABLE xlatedb.xl_string_info THEN
                                        xlatedb.xl_string_info.keyOfString
                                     ELSE
                                        "":U
             stringROWID           = IF AVAILABLE xlatedb.xl_string_info THEN
                                        ROWID(xlatedb.xl_string_info)
                                     ELSE
                                        ?
             instanceROWID         = IF AVAILABLE xlatedb.xl_instance THEN
                                        ROWID(xlatedb.xl_instance)
                                     ELSE
                                        ?
             instanceNum           = IF AVAILABLE xlatedb.xl_instance THEN
                                        xlatedb.xl_instance.instance_num
                                     ELSE  
                                        ?.
      NLoop:
      FOR EACH xlatedb.xl_string_info WHERE 
              xlatedb.xl_string_info.keyOfstring >= stringInfoKeyOfString 
          AND ROWID(xlatedb.xl_string_info) <> stringROWID
          NO-LOCK
          USE-INDEX String_Key:
          FOR EACH xlatedb.xl_instance WHERE 
                 xlatedb.xl_instance.sequence_num = xlatedb.xl_string_info.sequence_num
             AND ROWID(xlatedb.xl_instance) <> instanceROWID
          NO-LOCK:
             FIND FIRST xlatedb.xl_translation WHERE
                    xlatedb.xl_instance.sequence_num = xlatedb.xl_translation.sequence_num
                AND xlatedb.xl_instance.instance_num = xlatedb.xl_translation.instance_num
                AND _Lang = xlatedb.xl_translation.lang_name
                NO-LOCK NO-ERROR.
                IF NOT AVAILABLE xlatedb.xl_translation THEN
                DO:
                  /* NOTE that this will NOT reposition to the exact location */
                  Run Repo in _hTrans (INPUT ROWID(xlatedb.XL_string_info),
                                      INPUT ROWID(xlatedb.XL_instance),
                                      INPUT ?,
                                      INPUT ?).
                   LEAVE NLoop.
                END. /* NOT AVAIL translation */
          END. /* EACH xl_instance */
      END. /* EACH xl_string_info */

    END.

    WHEN "T":u THEN /* Top */
      RUN Goto IN _hTrans (INPUT 'Top':U).

    WHEN "B":u THEN /* Bottom */
      RUN Goto IN _hTrans (INPUT 'Bottom':U).

  END CASE.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp GotoWindow
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_adehelp.p ("vt","context",{&goto_db}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK GotoWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside OR outside the procedure TO  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
                                      
  ASSIGN CategoryLabel:SCREEN-VALUE = "Goto &What?"
         Category:SCREEN-VALUE = "T":u
         GotoWindow:PARENT = _MainWindow:HANDLE.
         
  APPLY "VALUE-CHANGED":u TO Category IN frame {&frame-name}.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS Category.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe GotoWindow 
PROCEDURE HideMe :
{&WINDOW-NAME}:HIDDEN = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize GotoWindow 
PROCEDURE Realize :
GotoWindow:HIDDEN = TRUE.
  DISPLAY CategoryLabel WITH FRAME default-frame.
  ENABLE ALL WITH FRAME {&FRAME-NAME} IN WINDOW GotoWindow.
  GotoWindow:HIDDEN      = FALSE.
  APPLY "VALUE-CHANGED":U TO Category IN FRAME {&FRAME-NAME}.  
  APPLY "ENTRY":U TO GotoWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

