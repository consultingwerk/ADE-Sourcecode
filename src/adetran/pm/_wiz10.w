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

Procedure:    adetran/pm/_wiz10.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                01/97 SLK Removed BGCOLOR 8
                03/97 SLK Bug# 97-03-19-003 Added PUT-SCREEN EXPR
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to "other"
              4GL statements.
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
&Scoped-define FRAME-NAME Mode10

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode10A Mode10B Mode10C Mode10D Mode10E ~
Mode10F Mode10G Mode10H Mode10I 
&Scoped-Define DISPLAYED-OBJECTS Mode10A Mode10B Mode10C Mode10D Mode10E ~
Mode10F Mode10G Mode10H Mode10I 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode10A AS LOGICAL INITIAL yes 
     LABEL "&Create":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10B AS LOGICAL INITIAL yes 
     LABEL "&Display expression":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10C AS LOGICAL INITIAL no 
     LABEL "&Export":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10D AS LOGICAL INITIAL no 
     LABEL "Image-File (&Button)":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10E AS LOGICAL INITIAL no 
     LABEL "Image-File (&Image)":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10F AS LOGICAL INITIAL yes 
     LABEL "P&ut":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10G AS LOGICAL INITIAL yes 
     LABEL "Put &screen":U 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10H AS LOGICAL INITIAL yes 
     LABEL "&Text in frames" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode10I AS LOGICAL INITIAL yes 
     LABEL "&Other" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode10
     Mode10A AT ROW 1 COL 1.8
     Mode10B AT ROW 1.76 COL 1.8
     Mode10C AT ROW 2.52 COL 1.8
     Mode10D AT ROW 3.24 COL 1.8
     Mode10E AT ROW 4 COL 2
     Mode10F AT ROW 4.76 COL 1.8
     Mode10G AT ROW 5.52 COL 1.8
     Mode10H AT ROW 6.24 COL 1.8
     Mode10I AT ROW 7 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.86 ROW 2.69
         SIZE 32.72 BY 8.12
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
         TITLE              = "Other"
         HEIGHT             = 10.05
         WIDTH              = 81.8
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
/* SETTINGS FOR FRAME Mode10
                                                                        */
ASSIGN 
       Mode10A:PRIVATE-DATA IN FRAME Mode10     = 
                "CREATE,NONE".

ASSIGN 
       Mode10B:PRIVATE-DATA IN FRAME Mode10     = 
                "DISPLAY,EXPR".

ASSIGN 
       Mode10C:PRIVATE-DATA IN FRAME Mode10     = 
                "EXPORT,NONE".

ASSIGN 
       Mode10D:PRIVATE-DATA IN FRAME Mode10     = 
                "DEF-BUTTON,IMAGE-FILE".

ASSIGN 
       Mode10E:PRIVATE-DATA IN FRAME Mode10     = 
                "DEF-IMAGE,IMAGE-FILE".

ASSIGN 
       Mode10F:PRIVATE-DATA IN FRAME Mode10     = 
                "PUT,NONE".

ASSIGN 
       Mode10G:PRIVATE-DATA IN FRAME Mode10     = 
                "PUT-SCREEN,NONE".

ASSIGN 
       Mode10H:PRIVATE-DATA IN FRAME Mode10     = 
                "FORM,NONE".

ASSIGN 
       Mode10I:PRIVATE-DATA IN FRAME Mode10     = 
                "OTHER,NONE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Other */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Other */
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
    xlatedb.XL_SelectedFilter.Mode      = "Mode10"
    xlatedb.XL_SelectedFilter.Item      = if pItem = "NONE" then "" else pItem
    xlatedb.XL_SelectedFilter.Statement = pStatement.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode10" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults */
    display Mode10A Mode10B Mode10C Mode10D Mode10E Mode10F Mode10G Mode10H Mode10I
    with frame {&frame-name}.
    return.
  end.
  
  ASSIGN Mode10A:CHECKED = FALSE
         Mode10B:CHECKED = FALSE
         Mode10C:CHECKED = FALSE
         Mode10D:CHECKED = FALSE
         Mode10E:CHECKED = FALSE
         Mode10F:CHECKED = FALSE
         Mode10G:CHECKED = FALSE
         Mode10H:CHECKED = FALSE
         Mode10I:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode10":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    case xlatedb.XL_SelectedFilter.Statement:
      when "CREATE" then Mode10A:checked = true.
      when "DISPLAY" then Mode10B:checked = true.
      when "DEF-BROWSE" then Mode10B:checked = true.
      when "EXPORT" then Mode10C:checked = true.
      when "DEF-BUTTON" then Mode10D:checked = true.
      when "DEF-IMAGE" then Mode10E:checked = true.
      when "PUT" then Mode10F:checked = true.
      when "PUT-SCREEN" then Mode10G:checked = true.
      when "FORM" then Mode10H:checked = true.
      when "OTHER" then Mode10I:checked = true.
    end case.    
  end.

  assign
    Mode10A:screen-value = string(Mode10A:checked)
    Mode10B:screen-value = string(Mode10B:checked)
    Mode10C:screen-value = string(Mode10C:checked)
    Mode10D:screen-value = string(Mode10D:checked)
    Mode10E:screen-value = string(Mode10E:checked)
    Mode10F:screen-value = string(Mode10F:checked)
    Mode10G:screen-value = string(Mode10G:checked).
    Mode10H:screen-value = string(Mode10H:checked).
    Mode10I:screen-value = string(Mode10I:checked).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode10a:checked then pSelected = pSelected + 1.
    if Mode10b:checked then pSelected = pSelected + 1.
    if Mode10c:checked then pSelected = pSelected + 1.
    if Mode10d:checked then pSelected = pSelected + 1.
    if Mode10e:checked then pSelected = pSelected + 1.
    if Mode10f:checked then pSelected = pSelected + 1.
    if Mode10g:checked then pSelected = pSelected + 1.
    if Mode10h:checked then pSelected = pSelected + 1.
    if Mode10i:checked then pSelected = pSelected + 1.
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
    xlatedb.XL_SelectedFilter.Mode = "Mode10":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode10":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode10A:checked then run CreateRec (entry(1,Mode10A:private-data),entry(2,Mode10A:private-data)).
  /* Handles DISPLAY EXPR
   *         DEF-BROWSE EXPR
   */
  IF Mode10B:CHECKED THEN 
  DO:
     RUN CreateRec 
       (entry(1,Mode10B:private-data),entry(2,Mode10B:private-data)).
     RUN CreateRec 
       ("DEF-BROWSE":U,entry(2,Mode10B:private-data)).
  END.
  if Mode10C:checked then run CreateRec (entry(1,Mode10C:private-data),entry(2,Mode10C:private-data)).
  if Mode10D:checked then run CreateRec (entry(1,Mode10D:private-data),entry(2,Mode10D:private-data)).
  if Mode10E:checked then do: /*add both DEF-IMAGE IMAGE-FILE and DEF-IMAGE EXPR */
    run CreateRec (entry(1,Mode10E:private-data),entry(2,Mode10E:private-data)).
    run CreateRec (entry(1,Mode10E:private-data),"EXPR").
  end. 
  if Mode10F:checked then run CreateRec (entry(1,Mode10F:private-data),entry(2,Mode10F:private-data)).
  if Mode10G:checked then DO: /*add both PUT-SCREEN NONE and PUT-SCREEN EXPR */
    run CreateRec (entry(1,Mode10G:private-data),entry(2,Mode10G:private-data)).
    run CreateRec (entry(1,Mode10G:private-data),"EXPR":U).
  END.
  if Mode10H:checked then do: /*add both FORM NONE and FORM EXPR */
    run CreateRec (entry(1,Mode10H:private-data),entry(2,Mode10H:private-data)).
    run CreateRec (entry(1,Mode10H:private-data),"EXPR").
  end. 
  if Mode10I:checked then run CreateRec (entry(1,Mode10I:private-data),entry(2,Mode10I:private-data)).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

