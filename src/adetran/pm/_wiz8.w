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

Procedure:    adetran/pm/_wiz8.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                01/97 SLK Removed BGCOLOR 8
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to assignments
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
&Scoped-define FRAME-NAME Mode8

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode8A Mode8B 
&Scoped-Define DISPLAYED-OBJECTS Mode8A Mode8B 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode8A AS LOGICAL INITIAL yes 
     LABEL "&INPUT-PARAMETER":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode8B AS LOGICAL INITIAL no 
     LABEL "Non-&alpha":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode8
     Mode8A AT ROW 1 COL 1.8
     Mode8B AT ROW 1.76 COL 1.8
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
         TITLE              = "Run Statements"
         HEIGHT             = 8.33
         WIDTH              = 81.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 81.8
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 81.8
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
/* SETTINGS FOR FRAME Mode8
                                                                        */
ASSIGN 
       Mode8A:PRIVATE-DATA IN FRAME Mode8     = 
                "NONE".

ASSIGN 
       Mode8B:PRIVATE-DATA IN FRAME Mode8     = 
                "NON-ALPHA".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Run Statements */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Run Statements */
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
define input parameter pItem as char no-undo.
  
  create xlatedb.XL_SelectedFilter.
  assign
    xlatedb.XL_SelectedFilter.Mode      = "Mode8"
    xlatedb.XL_SelectedFilter.Item      = if pItem = "NONE" then "" else pItem
    xlatedb.XL_SelectedFilter.Statement = "RUN".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode8" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults  */
    display Mode8A Mode8B with frame {&frame-name}.
    return.
  end.
  
  ASSIGN Mode8A:CHECKED = FALSE
         Mode8B:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode8":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    case xlatedb.XL_SelectedFilter.Item:
      when "" then Mode8A:checked = true.
      when "NON-ALPHA" then Mode8B:checked = true.
    end case.    
  end.

  assign
    Mode8A:screen-value = string(Mode8A:checked)
    Mode8B:screen-value = string(Mode8B:checked).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode8a:checked then pSelected = pSelected + 1.
    if Mode8b:checked then pSelected = pSelected + 1.
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
    xlatedb.XL_SelectedFilter.Mode = "Mode8":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode8":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode8A:checked then do: /* RUN [blank], RUN EXPR, and RUN INPUT-PARAM */
    run CreateRec (Mode8A:private-data).
    run CreateRec ("EXPR").
    run CreateRec ("INPUT-PARAM").
  end.
  if Mode8B:checked then run CreateRec (Mode8B:private-data).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

