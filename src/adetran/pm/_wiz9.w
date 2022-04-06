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

Procedure:    adetran/pm/_wiz9.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                01/97 SLK Removed BGCOLOR 8
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to comparisons
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
&Scoped-define FRAME-NAME Mode9

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode9A Mode9B Mode9C Mode9D Mode9E Mode9F ~
Mode9G Mode9H Mode9I Mode9J 
&Scoped-Define DISPLAYED-OBJECTS Mode9A Mode9B Mode9C Mode9D Mode9E Mode9F ~
Mode9G Mode9H Mode9I Mode9J 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode9A AS LOGICAL INITIAL no 
     LABEL "&Case":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9B AS LOGICAL INITIAL no 
     LABEL "Display &when":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9C AS LOGICAL INITIAL no 
     LABEL "&Do":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9D AS LOGICAL INITIAL no 
     LABEL "&Enable when":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9E AS LOGICAL INITIAL no 
     LABEL "Fo&r":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9F AS LOGICAL INITIAL no 
     LABEL "&If-then":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9G AS LOGICAL INITIAL no 
     LABEL "Pr&ompt-for when":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9H AS LOGICAL INITIAL no 
     LABEL "Repe&at while":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9I AS LOGICAL INITIAL no 
     LABEL "&Set when":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode9J AS LOGICAL INITIAL no 
     LABEL "&Update when":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode9
     Mode9A AT ROW 1 COL 1.8
     Mode9B AT ROW 1.76 COL 1.8
     Mode9C AT ROW 2.52 COL 1.8
     Mode9D AT ROW 3.29 COL 1.8
     Mode9E AT ROW 4 COL 1.8
     Mode9F AT ROW 4.76 COL 1.8
     Mode9G AT ROW 5.52 COL 1.8
     Mode9H AT ROW 6.29 COL 1.8
     Mode9I AT ROW 7 COL 1.8
     Mode9J AT ROW 7.76 COL 1.8
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
         TITLE              = "Comparisons"
         HEIGHT             = 9.24
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
/* SETTINGS FOR FRAME Mode9
                                                                        */
ASSIGN 
       Mode9A:PRIVATE-DATA IN FRAME Mode9     = 
                "CASE,WHEN".

ASSIGN 
       Mode9B:PRIVATE-DATA IN FRAME Mode9     = 
                "DISPLAY,WHEN".

ASSIGN 
       Mode9C:PRIVATE-DATA IN FRAME Mode9     = 
                "DO,WHILE".

ASSIGN 
       Mode9D:PRIVATE-DATA IN FRAME Mode9     = 
                "ENABLE,WHEN".

ASSIGN 
       Mode9E:PRIVATE-DATA IN FRAME Mode9     = 
                "FOR,EXPR".

ASSIGN 
       Mode9F:PRIVATE-DATA IN FRAME Mode9     = 
                "IF,EXPR".

ASSIGN 
       Mode9G:PRIVATE-DATA IN FRAME Mode9     = 
                "PROMPT-FOR,WHEN".

ASSIGN 
       Mode9H:PRIVATE-DATA IN FRAME Mode9     = 
                "REPEAT,WHILE".

ASSIGN 
       Mode9I:PRIVATE-DATA IN FRAME Mode9     = 
                "SET,WHEN".

ASSIGN 
       Mode9J:PRIVATE-DATA IN FRAME Mode9     = 
                "UPDATE,WHEN".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Comparisons */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Comparisons */
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
    xlatedb.XL_SelectedFilter.Mode      = "Mode9"
    xlatedb.XL_SelectedFilter.Item      = if pItem = "NONE" then "" else pItem.
    xlatedb.XL_SelectedFilter.Statement = pStatement.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode9" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults  */
    display Mode9A Mode9B Mode9C Mode9D Mode9E Mode9F Mode9G Mode9H Mode9I Mode9J
    with frame {&frame-name}.
    return.
  end.
  
  ASSIGN Mode9A:CHECKED = FALSE
         Mode9B:CHECKED = FALSE
         Mode9C:CHECKED = FALSE
         Mode9D:CHECKED = FALSE
         Mode9E:CHECKED = FALSE
         Mode9F:CHECKED = FALSE
         Mode9G:CHECKED = FALSE
         Mode9H:CHECKED = FALSE
         Mode9I:CHECKED = FALSE
         Mode9J:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode9":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    case xlatedb.XL_SelectedFilter.Statement:
      when "CASE" then Mode9A:checked = true.
      when "DISPLAY" then Mode9B:checked = true.
      when "DO" then Mode9C:checked = true.
      when "ENABLE" then Mode9D:checked = true.
      when "FOR" then Mode9E:checked = true.
      when "IF" then Mode9F:checked = true.
      when "PROMPT-FOR" then Mode9G:checked = true.
      when "REPEAT" then Mode9H:checked = true.
      when "SET" then Mode9I:checked = true.
      when "UPDATE" then Mode9J:checked = true.
    end case.    
  end.

  assign
    Mode9A:screen-value = string(Mode9A:checked)
    Mode9B:screen-value = string(Mode9B:checked)
    Mode9C:screen-value = string(Mode9C:checked)
    Mode9D:screen-value = string(Mode9D:checked)
    Mode9E:screen-value = string(Mode9E:checked)
    Mode9F:screen-value = string(Mode9F:checked)
    Mode9G:screen-value = string(Mode9G:checked)
    Mode9H:screen-value = string(Mode9H:checked)
    Mode9I:screen-value = string(Mode9I:checked)
    Mode9J:screen-value = string(Mode9I:checked).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode9a:checked then pSelected = pSelected + 1.
    if Mode9b:checked then pSelected = pSelected + 1.
    if Mode9c:checked then pSelected = pSelected + 1.
    if Mode9d:checked then pSelected = pSelected + 1.
    if Mode9e:checked then pSelected = pSelected + 1.
    if Mode9f:checked then pSelected = pSelected + 1.
    if Mode9g:checked then pSelected = pSelected + 1.
    if Mode9h:checked then pSelected = pSelected + 1.
    if Mode9i:checked then pSelected = pSelected + 1.
    if Mode9j:checked then pSelected = pSelected + 1.
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
enable all with frame {&frame-name}.
frame {&frame-name}:hidden = false.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetDB C-Win 
PROCEDURE SetDB :
do with frame {&frame-name}:
  for each xlatedb.XL_SelectedFilter where 
    xlatedb.XL_SelectedFilter.Mode = "Mode9":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode9":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode9A:checked then 
    run CreateRec (entry(1,Mode9A:private-data), entry(2,Mode9A:private-data)). /* CASE */
  if Mode9B:checked then    /* DISPLAY WHEN */
    run CreateRec (entry(1,Mode9B:private-data), entry(2,Mode9B:private-data)).
  if Mode9C:checked then do: /* DO WHILE and DO WHERE */
    run CreateRec (entry(1,Mode9C:private-data), entry(2,Mode9C:private-data)).
    run CreateRec (entry(1,Mode9C:private-data), "WHERE").
  end.
  if Mode9D:checked then    /* ENABLE WHEN */
    run CreateRec (entry(1,Mode9D:private-data), entry(2,Mode9D:private-data)).
  if Mode9E:checked then do: /* FOR EXPR and FOR WHERE */
    run CreateRec (entry(1,Mode9E:private-data), entry(2,Mode9E:private-data)).
    run CreateRec (entry(1,Mode9E:private-data), "WHERE").
    run CreateRec (entry(1,Mode9E:private-data), "WHILE").
  end.
  if Mode9F:checked then do: /*Treat IF EXPR and IF [blank] */
    run CreateRec (entry(1,Mode9F:private-data), entry(2,Mode9F:private-data)).
    run CreateRec (entry(1,Mode9F:private-data), "NONE").
  end.
  if Mode9G:checked then    /* PROMPT-FOR WHEN */
    run CreateRec (entry(1,Mode9G:private-data), entry(2,Mode9G:private-data)).
  if Mode9H:checked then    /* REPEAT WHILE */
    run CreateRec (entry(1,Mode9H:private-data), entry(2,Mode9H:private-data)).
  if Mode9I:checked then    /* SET WHEN */
    run CreateRec (entry(1,Mode9I:private-data), entry(2,Mode9I:private-data)).
  if Mode9J:checked then    /* UPDATE WHEN */
    run CreateRec (entry(1,Mode9J:private-data), entry(2,Mode9J:private-data)).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

