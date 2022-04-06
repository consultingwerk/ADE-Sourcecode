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

Procedure:    adetran/pm/_wiz11.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                11/96 SLK Changed for FONT
Purpose:      Persistent procedure that reads/writes 
              XL_CustomFilter that pertain to Progress
              "keyword" values.  Keyword values are not
              keywords, but are values used in event names,
              etc.
Called By:    adetran/pm/_wizard.w

*/

define input parameter parentframe as widget-handle no-undo.
define var ThisLine as char no-undo.
define var ThisRec as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Mode11

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Choices BtnAll BtnDesel 
&Scoped-Define DISPLAYED-OBJECTS Choices 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnAll 
     LABEL "Select &All" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnDesel 
     LABEL "&Deselect All" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE Choices AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SORT SCROLLBAR-VERTICAL 
     SIZE 30.14 BY 5.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode11
     Choices AT ROW 1.19 COL 1.86 NO-LABEL
     BtnAll AT ROW 6.65 COL 10
     BtnDesel AT ROW 7.88 COL 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.86 ROW 2.69
         SIZE 32.57 BY 8.23
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
         TITLE              = "<insert window title>"
         HEIGHT             = 10
         WIDTH              = 81.72
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 81.72
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 81.72
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



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Mode11
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnAll C-Win
ON CHOOSE OF BtnAll IN FRAME Mode11 /* Select All */
DO:
  Choices:screen-value IN FRAME {&FRAME-NAME} = Choices:list-items.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDesel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDesel C-Win
ON CHOOSE OF BtnDesel IN FRAME Mode11 /* Deselect All */
DO:
  Choices:screen-value IN FRAME {&FRAME-NAME} = "".
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
   
  file-info:filename = "adetran/data/keywords.dat".
  input from value(file-info:full-pathname).
  repeat:
    import ThisLine .
    ThisRec = if ThisRec = "" then ThisLine
              else ThisRec + "," + ThisLine.
  end. 
  input close.
  Choices:list-items in frame Mode11 = ThisRec.
  
  run GetDB.
     
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDB C-Win 
PROCEDURE getDB :
do with frame {&frame-name}:
  find first xlatedb.XL_CustomFilter where 
    xlatedb.XL_CustomFilter.RecType = "KEYWORDS" no-lock no-error.

  if not available xlatedb.XL_CustomFilter then do:
    /* Establish defaults */
    assign
      Choices              = Choices:list-items
      Choices              = replace(Choices,"abort,","")
      Choices              = replace(Choices,"clear,","")
      Choices              = replace(Choices,"help,","")
      Choices              = replace(Choices,"return,","")
      Choices              = replace(Choices,"stop,","")
      Choices:screen-value = Choices.
    return.
  end.
  
  Choices = "".
  for each xlatedb.XL_CustomFilter where
    xlatedb.XL_CustomFilter.RecType = "KEYWORDS" AND
    xlatedb.XL_CustomFilter.Filter NE "X-INIT":U NO-LOCK
    by xlatedb.XL_CustomFilter.Filter:
    
    Choices = if Choices = "" then 
                  xlatedb.XL_CustomFilter.Filter
                else
                  Choices + "," +  xlatedb.XL_CustomFilter.Filter.
  end.
  Choices:screen-value = Choices.
end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
define output parameter pSelected as integer no-undo.
  define var i as integer no-undo.
  do with frame {&frame-name}:
    do i = 1 to num-entries(Choices:screen-value,","):
      if entry(i,Choices:screen-value,",") <> "" then pSelected = pSelected + 1.
    end.
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
  define var i as int.
  
  for each xlatedb.XL_CustomFilter where
    xlatedb.XL_CustomFilter.RecType = "KEYWORDS" exclusive-lock:
    delete xlatedb.XL_CustomFilter.
  end.
  
  CREATE xlatedb.XL_CustomFilter.   /* Indicate that this has been looked at */
  ASSIGN xlatedb.XL_CustomFilter.RecType = "KEYWORDS":U
         xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.
    
  do i = 1 to num-entries(Choices:screen-value,","):
    create xlatedb.XL_CustomFilter.
    assign
      xlatedb.XL_CustomFilter.RecType = "KEYWORDS"
      xlatedb.XL_CustomFilter.Filter  = entry(i,Choices:screen-value).
  end.
    
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


