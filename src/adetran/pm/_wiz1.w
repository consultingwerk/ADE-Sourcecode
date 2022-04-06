&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_wiz1.w
Author:       R. Ryan
Created:      1/95 
Updated:      7/97 SLK Bug# 97-05-19-042 Enable Label = yes
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to labels
Called By:    adetran/pm/_wizard.w

*/

define input parameter parentframe as widget-handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Mode1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode1A Mode1B Mode1C Mode1D Mode1E Mode1F ~
Mode1G Mode1H Mode1I Mode1J 
&Scoped-Define DISPLAYED-OBJECTS Mode1A Mode1B Mode1C Mode1D Mode1E Mode1F ~
Mode1G Mode1H Mode1I Mode1J 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode1A AS LOGICAL INITIAL yes 
     LABEL "Bro&wse":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1B AS LOGICAL INITIAL yes 
     LABEL "&Button":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1C AS LOGICAL INITIAL yes 
     LABEL "&Display":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1D AS LOGICAL INITIAL yes 
     LABEL "&Enable":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1E AS LOGICAL INITIAL yes 
     LABEL "Fo&rm/Frame":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1F AS LOGICAL INITIAL yes 
     LABEL "&Menu":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1G AS LOGICAL INITIAL yes 
     LABEL "Promp&t-for":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1H AS LOGICAL INITIAL yes 
     LABEL "&Set":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1I AS LOGICAL INITIAL yes 
     LABEL "&Update" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode1J AS LOGICAL INITIAL no 
     LABEL "&Other" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode1
     Mode1A AT ROW 1 COL 1.8
     Mode1B AT ROW 1.76 COL 1.8
     Mode1C AT ROW 2.52 COL 1.8
     Mode1D AT ROW 3.29 COL 1.8
     Mode1E AT ROW 4 COL 1.8
     Mode1F AT ROW 4.76 COL 1.8
     Mode1G AT ROW 5.52 COL 1.8
     Mode1H AT ROW 6.29 COL 1.8
     Mode1I AT ROW 7 COL 1.8
     Mode1J AT ROW 7.76 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.72 ROW 2.69
         SIZE 33.57 BY 7.69
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Labels"
         HEIGHT             = 11.71
         WIDTH              = 82
         MAX-HEIGHT         = 23.1
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.1
         VIRTUAL-WIDTH      = 114.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Mode1
   L-To-R                                                               */
ASSIGN 
       FRAME Mode1:HIDDEN           = TRUE.

ASSIGN 
       Mode1A:PRIVATE-DATA IN FRAME Mode1     = 
                "DEF-BROWSE".

ASSIGN 
       Mode1B:PRIVATE-DATA IN FRAME Mode1     = 
                "DEF-BUTTON".

ASSIGN 
       Mode1C:PRIVATE-DATA IN FRAME Mode1     = 
                "DISPLAY".

ASSIGN 
       Mode1D:PRIVATE-DATA IN FRAME Mode1     = 
                "ENABLE".

ASSIGN 
       Mode1E:PRIVATE-DATA IN FRAME Mode1     = 
                "FORM".

ASSIGN 
       Mode1F:PRIVATE-DATA IN FRAME Mode1     = 
                "DEF-MENU".

ASSIGN 
       Mode1G:PRIVATE-DATA IN FRAME Mode1     = 
                "PROMPT-FOR".

ASSIGN 
       Mode1H:PRIVATE-DATA IN FRAME Mode1     = 
                "SET".

ASSIGN 
       Mode1I:PRIVATE-DATA IN FRAME Mode1     = 
                "UPDATE".

ASSIGN 
       Mode1J:PRIVATE-DATA IN FRAME Mode1     = 
                "OTHER".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Labels */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Labels */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       frame {&frame-name}:hidden    = true
       frame {&frame-name}:frame     = ParentFrame.

/* The CLOSE event can be used from inside or outside the procedure to  */
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
   
  run GetDB.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateRec C-Win 
PROCEDURE CreateRec :
define input parameter pStatement as char no-undo.
  
  create xlatedb.XL_SelectedFilter.
  assign
    xlatedb.XL_SelectedFilter.Mode      = "Mode1":u
    xlatedb.XL_SelectedFilter.Item      = "LABEL":u
    xlatedb.XL_SelectedFilter.Statement = pStatement.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode1":u no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults */
    display Mode1A Mode1B Mode1C Mode1D Mode1E Mode1F Mode1G Mode1H Mode1I Mode1J
    with frame {&frame-name}.
    return.
  end.

  ASSIGN Mode1A:CHECKED = FALSE
         Mode1B:CHECKED = FALSE
         Mode1C:CHECKED = FALSE
         Mode1D:CHECKED = FALSE
         Mode1E:CHECKED = FALSE
         Mode1F:CHECKED = FALSE
         Mode1G:CHECKED = FALSE
         Mode1H:CHECKED = FALSE
         Mode1I:CHECKED = FALSE
         Mode1J:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode1":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    case xlatedb.XL_SelectedFilter.Statement:
      when "DEF-BROWSE":u then Mode1A:checked = true.
      when "DEF-BUTTON":u then Mode1B:checked = true.
      when "DISPLAY":u then Mode1C:checked = true.
      when "ENABLE":u then Mode1D:checked = true.
      when "FORM":u then Mode1E:checked = true.
      when "DEF-MENU":u then Mode1F:checked = true.
      when "PROMPT-FOR":u then Mode1G:checked = true.
      when "SET":u then Mode1H:checked = true.
      when "UPDATE":u then Mode1I:checked = true.
      when "OTHER":u then Mode1J:checked = true.
    end case.    
  end.

  assign
    Mode1A:screen-value = string(Mode1A:checked)
    Mode1B:screen-value = string(Mode1B:checked)
    Mode1C:screen-value = string(Mode1C:checked)
    Mode1D:screen-value = string(Mode1D:checked)
    Mode1E:screen-value = string(Mode1E:checked)
    Mode1F:screen-value = string(Mode1F:checked)
    Mode1G:screen-value = string(Mode1G:checked)
    Mode1H:screen-value = string(Mode1H:checked).
    Mode1I:screen-value = string(Mode1I:checked).
    Mode1J:screen-value = string(Mode1J:checked).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode1a:checked then pSelected = pSelected + 1.
    if Mode1b:checked then pSelected = pSelected + 1.
    if Mode1c:checked then pSelected = pSelected + 1.
    if Mode1d:checked then pSelected = pSelected + 1.
    if Mode1e:checked then pSelected = pSelected + 1.
    if Mode1f:checked then pSelected = pSelected + 1.
    if Mode1g:checked then pSelected = pSelected + 1.
    if Mode1h:checked then pSelected = pSelected + 1.
    if Mode1i:checked then pSelected = pSelected + 1.
    if Mode1j:checked then pSelected = pSelected + 1.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe C-Win 
PROCEDURE HideMe :
frame {&frame-name}:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize C-Win 
PROCEDURE Realize :
enable all with frame {&frame-name}.
frame {&frame-name}:hidden = false.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetDB C-Win 
PROCEDURE SetDB :
do with frame {&frame-name}:
  for each xlatedb.XL_SelectedFilter where 
    xlatedb.XL_SelectedFilter.Mode = "Mode1":u:
    delete xlatedb.XL_SelectedFilter.
  end.

  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode1":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode1A:checked then run CreateRec (Mode1A:private-data).
  if Mode1B:checked then run CreateRec (Mode1B:private-data).
  if Mode1C:checked then run CreateRec (Mode1C:private-data).
  if Mode1D:checked then run CreateRec (Mode1D:private-data).
  if Mode1E:checked then do: /* add both FORM LABEL and DEF-FRAME LABEL */
     run CreateRec (Mode1E:private-data).
     run CreateRec ("DEF-FRAME").
  end.
  if Mode1F:checked then do: /* add both DEF-MENU and DEF-SUB-MENU */
     run CreateRec (Mode1F:private-data).
     run CreateRec ("DEF-SUB-MENU").
  end.
  if Mode1G:checked then run CreateRec (Mode1G:private-data).
  if Mode1H:checked then run CreateRec (Mode1H:private-data).
  if Mode1I:checked then run CreateRec (Mode1I:private-data).
  if Mode1J:checked then run CreateRec (Mode1J:private-data).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

