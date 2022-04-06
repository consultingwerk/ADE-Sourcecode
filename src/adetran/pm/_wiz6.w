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

Procedure:    adetran/pm/_wiz6.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                01/97 SLK Removed BGCOLOR 8
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to assignment
              statements
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
&Scoped-define FRAME-NAME Mode6

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode6A Mode6B Mode6C Mode6D Mode6E Mode6F 
&Scoped-Define DISPLAYED-OBJECTS Mode6A Mode6B Mode6C Mode6D Mode6E Mode6F 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode6A AS LOGICAL INITIAL no 
     LABEL "&Current-language":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode6B AS LOGICAL INITIAL yes 
     LABEL "&Expression":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode6C AS LOGICAL INITIAL no 
     LABEL "Non-&alpha":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode6D AS LOGICAL INITIAL no 
     LABEL "Pro&msgs":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode6E AS LOGICAL INITIAL no 
     LABEL "Propat&h":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode6F AS LOGICAL INITIAL no 
     LABEL "&Termcap":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode6
     Mode6A AT ROW 1 COL 1.8
     Mode6B AT ROW 1.76 COL 1.8
     Mode6C AT ROW 2.52 COL 32 RIGHT-ALIGNED
     Mode6D AT ROW 3.29 COL 1.8
     Mode6E AT ROW 4 COL 1.8
     Mode6F AT ROW 4.76 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.72 ROW 2.69
         SIZE 33.72 BY 7.69
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
         TITLE              = "Assignments"
         HEIGHT             = 8.29
         WIDTH              = 81.8
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
/* SETTINGS FOR FRAME Mode6
                                                                        */
ASSIGN 
       Mode6A:PRIVATE-DATA IN FRAME Mode6     = 
                "ASSIGN,CUR-LANG".

ASSIGN 
       Mode6B:PRIVATE-DATA IN FRAME Mode6     = 
                "ASSIGN,NONE".

/* SETTINGS FOR TOGGLE-BOX Mode6C IN FRAME Mode6
   ALIGN-R                                                              */
ASSIGN 
       Mode6C:PRIVATE-DATA IN FRAME Mode6     = 
                "ASSIGN,NON-ALPHA".

ASSIGN 
       Mode6D:PRIVATE-DATA IN FRAME Mode6     = 
                "ASSIGN,PROMSGS".

ASSIGN 
       Mode6E:PRIVATE-DATA IN FRAME Mode6     = 
                "ASSIGN,PROPATH".

ASSIGN 
       Mode6F:PRIVATE-DATA IN FRAME Mode6     = 
                "ASSIGN,TERMCAP".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Assignments */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Assignments */
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
    xlatedb.XL_SelectedFilter.Mode      = "Mode6"
    xlatedb.XL_SelectedFilter.Item      = if pItem = "NONE" then ""
                                           else pItem
    xlatedb.XL_SelectedFilter.Statement = pStatement.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode6" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults */
    display Mode6A Mode6B Mode6C Mode6D Mode6E Mode6F 
    with frame {&frame-name}.
    return.
  end.
  
  ASSIGN Mode6A:CHECKED = FALSE
         Mode6B:CHECKED = FALSE
         Mode6C:CHECKED = FALSE
         Mode6D:CHECKED = FALSE
         Mode6E:CHECKED = FALSE
         Mode6F:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
           xlatedb.XL_SelectedFilter.Mode = "Mode6":u AND
           xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    CASE xlatedb.XL_SelectedFilter.Item:
      WHEN "CUR-LANG"  then Mode6A:checked = true.
      WHEN ""          then Mode6B:checked = true. /* This test counts for both
                                                      ASSIGN [blank] and ASSIGN EXPR */
      WHEN "NON-ALPHA" then Mode6C:checked = true.
      WHEN "PROMSGS"   then Mode6D:checked = true.
      WHEN "PROPATH"   then Mode6E:checked = true.
      WHEN "TERMCAP"   then Mode6F:checked = true.
    END CASE.
  end.

  assign
    Mode6A:screen-value = string(Mode6A:checked)
    Mode6B:screen-value = string(Mode6B:checked)
    Mode6C:screen-value = string(Mode6C:checked)
    Mode6D:screen-value = string(Mode6D:checked)
    Mode6E:screen-value = string(Mode6E:checked)
    Mode6F:screen-value = string(Mode6F:checked).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode6a:checked then pSelected = pSelected + 1.
    if Mode6b:checked then pSelected = pSelected + 1.
    if Mode6c:checked then pSelected = pSelected + 1.
    if Mode6d:checked then pSelected = pSelected + 1.
    if Mode6e:checked then pSelected = pSelected + 1.
    if Mode6f:checked then pSelected = pSelected + 1.
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
    xlatedb.XL_SelectedFilter.Mode = "Mode6":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode6":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode6A:checked then run CreateRec (entry(1,Mode6A:private-data),entry(2,Mode6A:private-data)).
  if Mode6B:checked then do: /* Add both NONE and EXPR */
    run CreateRec (entry(1,Mode6B:private-data),entry(2,Mode6B:private-data)).
    run CreateRec (entry(1,Mode6B:private-data),"EXPR").
  end.
  if Mode6C:checked then run CreateRec (entry(1,Mode6C:private-data),entry(2,Mode6C:private-data)).
  if Mode6D:checked then run CreateRec (entry(1,Mode6D:private-data),entry(2,Mode6D:private-data)).
  if Mode6E:checked then run CreateRec (entry(1,Mode6E:private-data),entry(2,Mode6E:private-data)).
  if Mode6F:checked then run CreateRec (entry(1,Mode6F:private-data),entry(2,Mode6F:private-data)).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

