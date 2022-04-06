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

Procedure:    adetran/pm/_wiz7.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                01/97 SLK Removed BGCOLOR 8
Purpose:      Persistent procedure that reads/writes 
              XL_SelectedFilter that pertain to formats
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
&Scoped-define FRAME-NAME Mode7

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Mode7A Mode7B Mode7C Mode7D Mode7E 
&Scoped-Define DISPLAYED-OBJECTS Mode7A Mode7B Mode7C Mode7D Mode7E 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Mode7A AS LOGICAL INITIAL no 
     LABEL "&Character":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode7B AS LOGICAL INITIAL no 
     LABEL "&Date":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode7C AS LOGICAL INITIAL no 
     LABEL "&Logical":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode7D AS LOGICAL INITIAL no 
     LABEL "Non-&alpha":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.

DEFINE VARIABLE Mode7E AS LOGICAL INITIAL no 
     LABEL "Nu&meric":U 
     VIEW-AS TOGGLE-BOX
     SIZE 31.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode7
     Mode7A AT ROW 1 COL 1.8
     Mode7B AT ROW 1.76 COL 1.8
     Mode7C AT ROW 2.52 COL 1.8
     Mode7D AT ROW 3.29 COL 1.8
     Mode7E AT ROW 4 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.72 ROW 2.69
         SIZE 33.86 BY 7.69
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
         TITLE              = "Formats"
         HEIGHT             = 8.38
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
/* SETTINGS FOR FRAME Mode7
                                                                        */
ASSIGN 
       Mode7A:PRIVATE-DATA IN FRAME Mode7     = 
                "CHAR".

ASSIGN 
       Mode7B:PRIVATE-DATA IN FRAME Mode7     = 
                "DATE".

ASSIGN 
       Mode7C:PRIVATE-DATA IN FRAME Mode7     = 
                "BOOL".

ASSIGN 
       Mode7D:PRIVATE-DATA IN FRAME Mode7     = 
                "NON-ALPHA".

ASSIGN 
       Mode7E:PRIVATE-DATA IN FRAME Mode7     = 
                "NUMERIC".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Formats */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Formats */
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
    xlatedb.XL_SelectedFilter.Mode      = "Mode7"
    xlatedb.XL_SelectedFilter.Item        = if pItem = "NONE" then ""
                                           else pItem
xlatedb.XL_SelectedFilter.Statement = "FORMAT".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
find first xlatedb.XL_SelectedFilter where
             xlatedb.XL_SelectedFilter.Mode = "Mode7" no-error.
    
  if not available xlatedb.XL_SelectedFilter then do:
    /* Establish defaults  */
    display Mode7A Mode7B Mode7C Mode7D Mode7E 
    with frame {&frame-name}.
    return.
  end.
  
  ASSIGN Mode7A:CHECKED = FALSE
         Mode7B:CHECKED = FALSE
         Mode7C:CHECKED = FALSE
         Mode7D:CHECKED = FALSE
         Mode7E:CHECKED = FALSE.

  for each xlatedb.XL_SelectedFilter where
    xlatedb.XL_SelectedFilter.Mode = "Mode7":u AND
    xlatedb.XL_SelectedFilter.Item NE "X-INIT":U NO-LOCK:
    case xlatedb.XL_SelectedFilter.Item:
      when "CHAR"      then Mode7A:checked = true.
      when "DATE"      then Mode7B:checked = true.
      when "BOOL"      then Mode7C:checked = true.
      when "NON-ALPHA" then Mode7D:checked = true.
      when "NUMERIC"   then Mode7E:checked = true.
    end case.    
  end.

  assign
    Mode7A:screen-value = string(Mode7A:checked)
    Mode7B:screen-value = string(Mode7B:checked)
    Mode7C:screen-value = string(Mode7C:checked)
    Mode7D:screen-value = string(Mode7D:checked)
    Mode7E:screen-value = string(Mode7E:checked).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  do with frame {&frame-name}:
    pSelected = 0.
    if Mode7a:checked then pSelected = pSelected + 1.
    if Mode7b:checked then pSelected = pSelected + 1.
    if Mode7c:checked then pSelected = pSelected + 1.
    if Mode7d:checked then pSelected = pSelected + 1.
    if Mode7e:checked then pSelected = pSelected + 1.
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
    xlatedb.XL_SelectedFilter.Mode = "Mode7":
    delete xlatedb.XL_SelectedFilter.
  end.
  
  CREATE xlatedb.XL_SelectedFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_SelectedFilter.Mode = "Mode7":U
         xlatedb.XL_SelectedFilter.Item = "X-INIT":U.
  
  if Mode7A:checked then run CreateRec (Mode7A:private-data).
  if Mode7B:checked then run CreateRec (Mode7B:private-data).
  if Mode7C:checked then run CreateRec (Mode7C:private-data).
  if Mode7D:checked then do: /* NON-ALPHA and blank */
    run CreateRec (Mode7D:private-data).
    run CreateRec ("NONE").
  end.
  if Mode7E:checked then run CreateRec (Mode7E:private-data).
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

