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

Procedure:    adetran/pm/_wiz2.w
Author:       R. Ryan
Created:      1/95 
Updated:      7/97 SLK Bug# 97-05-19-042 Enable Column Labels = yes
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to column labels
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
&Scoped-define FRAME-NAME Mode2

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode2A Mode2B Mode2C Mode2D Mode2E Mode2F ~
Mode2G Mode2H 
&Scoped-Define DISPLAYED-OBJECTS Mode2A Mode2B Mode2C Mode2D Mode2E Mode2F ~
Mode2G Mode2H 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode2A AS LOGICAL INITIAL yes 
     LABEL "Bro&wse":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2B AS LOGICAL INITIAL yes 
     LABEL "&Display":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2C AS LOGICAL INITIAL yes 
     LABEL "&Enable":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2D AS LOGICAL INITIAL yes 
     LABEL "Fo&rm/Frame":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2E AS LOGICAL INITIAL yes 
     LABEL "Promp&t-for":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2F AS LOGICAL INITIAL yes 
     LABEL "&Set" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2G AS LOGICAL INITIAL yes 
     LABEL "&Update" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode2H AS LOGICAL INITIAL no 
     LABEL "&Other" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode2
     Mode2A AT ROW 1 COL 1.8
     Mode2B AT ROW 1.76 COL 1.8
     Mode2C AT ROW 2.52 COL 1.8
     Mode2D AT ROW 3.29 COL 1.8
     Mode2E AT ROW 4 COL 1.8
     Mode2F AT ROW 4.76 COL 1.8
     Mode2G AT ROW 5.52 COL 1.8
     Mode2H AT ROW 6.29 COL 1.8
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
         TITLE              = "Column-Labels"
         HEIGHT             = 8.1
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
/* SETTINGS FOR FRAME Mode2
   L-To-R                                                               */
ASSIGN 
       Mode2A:PRIVATE-DATA IN FRAME Mode2     = 
                "DEF-BROWSE".

ASSIGN 
       Mode2B:PRIVATE-DATA IN FRAME Mode2     = 
                "DISPLAY".

ASSIGN 
       Mode2C:PRIVATE-DATA IN FRAME Mode2     = 
                "ENABLE".

ASSIGN 
       Mode2D:PRIVATE-DATA IN FRAME Mode2     = 
                "FORM".

ASSIGN 
       Mode2E:PRIVATE-DATA IN FRAME Mode2     = 
                "PROMPT-FOR".

ASSIGN 
       Mode2F:PRIVATE-DATA IN FRAME Mode2     = 
                "SET".

ASSIGN 
       Mode2G:PRIVATE-DATA IN FRAME Mode2     = 
                "UPDATE".

ASSIGN 
       Mode2H:PRIVATE-DATA IN FRAME Mode2     = 
                "OTHER".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Column-Labels */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Column-Labels */
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
    xlatedb.XL_SelectedFilter.Mode      = "Mode2"
    xlatedb.XL_SelectedFilter.Item      = "COL-LABEL"
    xlatedb.XL_SelectedFilter.Statement = pStatement.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode2" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults  */
    display Mode2A Mode2B Mode2C Mode2D Mode2E Mode2F Mode2G Mode2H
    with frame {&frame-name}.
    return.
  end.
  
  ASSIGN Mode2A:CHECKED = FALSE
         Mode2B:CHECKED = FALSE
         Mode2C:CHECKED = FALSE
         Mode2D:CHECKED = FALSE
         Mode2E:CHECKED = FALSE
         Mode2F:CHECKED = FALSE
         Mode2G:CHECKED = FALSE
         Mode2H:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode2":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    case xlatedb.XL_SelectedFilter.Statement:
      when "DEF-BROWSE" then Mode2A:checked = true.
      when "DISPLAY" then Mode2B:checked = true.
      when "ENABLE" then Mode2C:checked = true.
      when "FORM" then Mode2D:checked = true.
      when "PROMPT-FOR" then Mode2E:checked = true.
      when "SET" then Mode2F:checked = true.
      when "UPDATE" then Mode2G:checked = true.
      when "OTHER" then Mode2H:checked = true.
   end case.    
  end.

  assign
    Mode2A:screen-value = string(Mode2A:checked)
    Mode2B:screen-value = string(Mode2B:checked)
    Mode2C:screen-value = string(Mode2C:checked)
    Mode2D:screen-value = string(Mode2D:checked)
    Mode2E:screen-value = string(Mode2E:checked).
    Mode2F:screen-value = string(Mode2F:checked).
    Mode2G:screen-value = string(Mode2G:checked).
    Mode2H:screen-value = string(Mode2H:checked).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode2a:checked then pSelected = pSelected + 1.
    if Mode2b:checked then pSelected = pSelected + 1.
    if Mode2c:checked then pSelected = pSelected + 1.
    if Mode2d:checked then pSelected = pSelected + 1.
    if Mode2e:checked then pSelected = pSelected + 1.
    if Mode2f:checked then pSelected = pSelected + 1.
    if Mode2g:checked then pSelected = pSelected + 1.
    if Mode2h:checked then pSelected = pSelected + 1.
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
    xlatedb.XL_SelectedFilter.Mode = "Mode2":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode2":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode2A:checked then run CreateRec (Mode2A:private-data).
  if Mode2B:checked then run CreateRec (Mode2B:private-data).
  if Mode2C:checked then run CreateRec (Mode2C:private-data).
  if Mode2D:checked then do:
  /* Add both FORM COL-LABEL and DEF-FRAME COL-LABEL */
    run CreateRec (Mode2D:private-data).
    run CreateRec ("DEF-FRAME").
  end.
  if Mode2E:checked then run CreateRec (Mode2E:private-data).
  if Mode2F:checked then run CreateRec (Mode2F:private-data).
  if Mode2G:checked then run CreateRec (Mode2G:private-data).
  if Mode2H:checked then run CreateRec (Mode2H:private-data).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

