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

Procedure:    adetran/pm/_wiz3.w
Author:       R. Ryan
Created:      1/95 
Updated:      7/97 SLK Bug# 97-05-19-042 Prompt-For Message = yes
                                        Update Message = yes
                        Bug# 97-04-23-05 Tooltips = yes
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to messages
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
&Scoped-define FRAME-NAME Mode3

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode3A Mode3B Mode3C Mode3D Mode3K Mode3E ~
Mode3F Mode3G Mode3H Mode3J Mode3I 
&Scoped-Define DISPLAYED-OBJECTS Mode3A Mode3B Mode3C Mode3D Mode3K Mode3E ~
Mode3F Mode3G Mode3H Mode3J Mode3I 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode3A AS LOGICAL INITIAL yes 
     LABEL "&Enable":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3B AS LOGICAL INITIAL yes 
     LABEL "Expressions in &titles":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3C AS LOGICAL INITIAL yes 
     LABEL "&Help strings":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3D AS LOGICAL INITIAL yes 
     LABEL "P&ause":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3E AS LOGICAL INITIAL yes 
     LABEL "&Regular expression":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3F AS LOGICAL INITIAL yes 
     LABEL "&Set":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3G AS LOGICAL INITIAL yes 
     LABEL "Status &default":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3H AS LOGICAL INITIAL yes 
     LABEL "Status &input":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3I AS LOGICAL INITIAL yes 
     LABEL "&Update":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3J AS LOGICAL INITIAL yes 
     LABEL "&Tooltip":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.

DEFINE VARIABLE Mode3K AS LOGICAL INITIAL yes 
     LABEL "Prompt-&for":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode3
     Mode3A AT ROW 1 COL 2
     Mode3B AT ROW 1.76 COL 2
     Mode3C AT ROW 2.52 COL 2
     Mode3D AT ROW 3.24 COL 2
     Mode3K AT ROW 3.86 COL 2
     Mode3E AT ROW 4.57 COL 2
     Mode3F AT ROW 5.33 COL 2
     Mode3G AT ROW 6.14 COL 2
     Mode3H AT ROW 6.81 COL 2
     Mode3J AT ROW 7.57 COL 2
     Mode3I AT ROW 8.33 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.86 ROW 2.69
         SIZE 33.14 BY 8.15
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
         TITLE              = "Messages"
         HEIGHT             = 10.05
         WIDTH              = 82
         MAX-HEIGHT         = 23.14
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.14
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
/* SETTINGS FOR FRAME Mode3
   L-To-R                                                               */
ASSIGN 
       Mode3A:PRIVATE-DATA IN FRAME Mode3     = 
                "ENABLE,NONE".

ASSIGN 
       Mode3B:PRIVATE-DATA IN FRAME Mode3     = 
                "MESSAGE,TITLE".

ASSIGN 
       Mode3C:PRIVATE-DATA IN FRAME Mode3     = 
                "ALL,HELP".

ASSIGN 
       Mode3D:PRIVATE-DATA IN FRAME Mode3     = 
                "PAUSE,NONE".

ASSIGN 
       Mode3E:PRIVATE-DATA IN FRAME Mode3     = 
                "MESSAGE,NONE".

ASSIGN 
       Mode3F:PRIVATE-DATA IN FRAME Mode3     = 
                "SET,NONE".

ASSIGN 
       Mode3G:PRIVATE-DATA IN FRAME Mode3     = 
                "STATUS,DEFAULT".

ASSIGN 
       Mode3H:PRIVATE-DATA IN FRAME Mode3     = 
                "STATUS,INPUT".

ASSIGN 
       Mode3I:PRIVATE-DATA IN FRAME Mode3     = 
                "UPDATE,EXPR".

ASSIGN 
       Mode3J:PRIVATE-DATA IN FRAME Mode3     = 
                "ALL,TOOLTIP".

ASSIGN 
       Mode3K:PRIVATE-DATA IN FRAME Mode3     = 
                "PROMPT-FOR,EXPR".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Messages */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Messages */
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
define input parameter pItem as char no-undo.
  
  create xlatedb.XL_SelectedFilter.
  assign
    xlatedb.XL_SelectedFilter.Mode      = "Mode3"
    xlatedb.XL_SelectedFilter.Item      = if pItem = "NONE" then "" else pItem
    xlatedb.XL_SelectedFilter.Statement = IF pStatement = "ALL":U
                                          THEN ? ELSE pStatement.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
define var TestItem as char no-undo.
  define var TestStmt as char no-undo.
  
  find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode3" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults  */
    display Mode3A Mode3B Mode3C Mode3D Mode3E Mode3F Mode3G Mode3H
            Mode3I Mode3J Mode3K
    with frame {&frame-name}.
    return.
  end.

  ASSIGN Mode3A:CHECKED = FALSE
         Mode3B:CHECKED = FALSE
         Mode3C:CHECKED = FALSE
         Mode3D:CHECKED = FALSE
         Mode3K:CHECKED = FALSE
         Mode3E:CHECKED = FALSE
         Mode3F:CHECKED = FALSE
         Mode3G:CHECKED = FALSE
         Mode3H:CHECKED = FALSE
         Mode3I:CHECKED = FALSE
         Mode3J:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode3":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
      TestItem = xlatedb.XL_SelectedFilter.Item.
      TestStmt = xlatedb.XL_SelectedFilter.Statement.
      
      IF (TestStmt = "ENABLE":U AND TestItem = "") OR
         (TestStmt = "ENABLE":U AND TestItem = "VALIDATE") OR
         (TestStmt = "FORM":U AND TestItem = "VALIDATE") THEN 
         Mode3A:checked = true.
      if TestStmt = "MESSAGE":U and TestItem = "TITLE"  then Mode3B:checked = true.
      IF TestStmt = ? AND TestItem = "HELP":U           THEN Mode3C:CHECKED = TRUE.
      if TestStmt = "PAUSE":U                           then Mode3D:checked = true.
      if TestStmt = "PROMPT-FOR":U and TestItem = "EXPR":U then Mode3K:checked = true.
      if TestStmt = "MESSAGE":U and TestItem = ""       then Mode3E:checked = true.
      if TestStmt = "SET":U and TestItem = ""           THEN Mode3F:CHECKED = TRUE.
      if TestStmt = "STATUS":U and TestItem = "DEFAULT" then Mode3G:checked = true.
      if TestStmt = "STATUS":U and TestItem = "INPUT"   then Mode3H:checked = true.
      IF TestStmt = ? AND TestItem = "TOOLTIP":U        THEN Mode3J:CHECKED = TRUE.
      IF TestStmt = "UPDATE":U                          THEN Mode3I:CHECKED = TRUE.
  end.

  assign
    Mode3A:screen-value = string(Mode3A:checked)
    Mode3B:screen-value = string(Mode3B:checked)
    Mode3C:screen-value = string(Mode3C:checked)
    Mode3D:screen-value = string(Mode3D:checked)
    Mode3K:screen-value = string(Mode3K:checked)
    Mode3E:screen-value = string(Mode3E:checked)
    Mode3F:screen-value = string(Mode3F:checked)
    Mode3G:screen-value = string(Mode3G:checked)
    Mode3H:screen-value = string(Mode3H:checked)
    Mode3I:SCREEN-VALUE = STRING(Mode3I:checked)
    Mode3J:SCREEN-VALUE = STRING(Mode3J:checked).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode3a:checked then pSelected = pSelected + 1.
    if Mode3b:checked then pSelected = pSelected + 1.
    if Mode3c:checked then pSelected = pSelected + 1.
    if Mode3d:checked then pSelected = pSelected + 1.
    if Mode3k:checked then pSelected = pSelected + 1.
    if Mode3e:checked then pSelected = pSelected + 1.
    if Mode3f:checked then pSelected = pSelected + 1.
    if Mode3g:checked then pSelected = pSelected + 1.
    if Mode3h:checked then pSelected = pSelected + 1.
    if Mode3i:checked then pSelected = pSelected + 1.
    if Mode3J:checked then pSelected = pSelected + 1.
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
    xlatedb.XL_SelectedFilter.Mode = "Mode3":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode3":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  /* Mode3A: "ENABLE,NONE". 
   * Handles ENABLE NONE
   *         ENABLE VALIDATE
   *         FORM VALIDATE
   */
  if Mode3A:checked then DO:
     run CreateRec (entry(1,Mode3A:private-data), entry(2,Mode3A:private-data)).
     run CreateRec (entry(1,Mode3A:private-data), "VALIDATE":U).
     run CreateRec ("FORM":U, "VALIDATE":U).
  END.
  /* Mode3B: "MESSAGE,TITLE". */
  if Mode3B:checked then run CreateRec (entry(1,Mode3B:private-data), entry(2,Mode3B:private-data)).
  /* Mode3C: "ALL,HELP". */
  if Mode3C:checked then run CreateRec (entry(1,Mode3C:private-data), entry(2,Mode3C:private-data)).
  /* Mode3D: "PAUSE,NONE". */
  if Mode3D:checked then run CreateRec (entry(1,Mode3D:private-data), entry(2,Mode3D:private-data)).
  /* Mode3K: "PROMPT-FOR,EXPR". */
  if Mode3K:checked then DO:
     run CreateRec (entry(1,Mode3K:private-data), entry(2,Mode3K:private-data)).
     run CreateRec (entry(1,Mode3K:private-data), "VALIDATE":U).
  END.
  /* Mode3E: "MESSAGE,NONE". */
  if Mode3E:checked then do: /* For regular expressions, add MESSAGE EXPR and MESSAGE NON-ALPHA */
   run CreateRec (entry(1,Mode3E:private-data), entry(2,Mode3E:private-data)).
   run CreateRec ("MESSAGE","EXPR").
   run CreateRec ("MESSAGE","NON-ALPHA").
  end.
  /* Mode3F: "SET,NONE". */
  if Mode3F:checked then DO:
    run CreateRec (entry(1,Mode3F:private-data), entry(2,Mode3F:private-data)).
    run CreateRec (entry(1,Mode3F:private-data), "VALIDATE":U).
  END.
  /* Mode3G: "STATUS,DEFAULT". */
  if Mode3G:checked then run CreateRec (entry(1,Mode3G:private-data), entry(2,Mode3G:private-data)).
  /* Mode3H: "STATUS,INPUT". */
  if Mode3H:checked then run CreateRec (entry(1,Mode3H:private-data), entry(2,Mode3H:private-data)).
  /* Mode3J: "ALL,TOOLTIP". */
  if Mode3J:checked then run CreateRec (entry(1,Mode3J:private-data), entry(2,Mode3J:private-data)).
  /* Mode3I: "UPDATE,EXPR". */
  if Mode3I:checked then DO:
    run CreateRec (entry(1,Mode3I:private-data), entry(2,Mode3I:private-data)).
    run CreateRec (entry(1,Mode3I:private-data), "NONE":U).
    run CreateRec (entry(1,Mode3I:private-data), "VALIDATE":U).
  END.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

