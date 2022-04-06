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

Procedure:    adetran/pm/_wiz14.w
Author:       R. Ryan
Created:      1/95 
Updated:      11/96 SLK Renamed from _wiz13.w to _wiz14.w. Added hWiz13
                01/97 SLK Removed BGCOLOR 8
Purpose:      Persistent procedure that summarizes the number
              and type of filters that have been defined (see
              the procedure, GetTotals).
Called By:    adetran/pm/_wizard.w

*/

define input parameter parentframe as widget-handle no-undo.

define input parameter hWiz1 as handle no-undo.
define input parameter hWiz2 as handle no-undo.
define input parameter hWiz3 as handle no-undo.
define input parameter hWiz4 as handle no-undo.
define input parameter hWiz5 as handle no-undo.
define input parameter hWiz6 as handle no-undo.
define input parameter hWiz7 as handle no-undo.
define input parameter hWiz8 as handle no-undo.
define input parameter hWiz9 as handle no-undo.
define input parameter hWiz10 as handle no-undo.
define input parameter hWiz11 as handle no-undo.
define input parameter hWiz12 as handle no-undo.
define input parameter hWiz13 as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Summary

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Summary1 Summary2 Summary3 Summary4 
&Scoped-Define DISPLAYED-OBJECTS Summary1 Summary2 Summary3 Summary4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Summary1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 31.14 BY 1 NO-UNDO.

DEFINE VARIABLE Summary2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 31.14 BY 1 NO-UNDO.

DEFINE VARIABLE Summary3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 31.14 BY 1 NO-UNDO.

DEFINE VARIABLE Summary4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 31.14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Summary
     Summary1 AT ROW 1.38 COL 1.86 NO-LABEL
     Summary2 AT ROW 2.35 COL 1.86 NO-LABEL
     Summary3 AT ROW 3.54 COL 1.86 NO-LABEL
     Summary4 AT ROW 4.54 COL 1.86 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.86 ROW 2.69
         SIZE 33.43 BY 8.12
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
         HEIGHT             = 10.04
         WIDTH              = 82.14
         MAX-HEIGHT         = 23.12
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 23.12
         VIRTUAL-WIDTH      = 114.14
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
/* SETTINGS FOR FRAME Summary
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FILL-IN Summary1 IN FRAME Summary
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN Summary2 IN FRAME Summary
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN Summary3 IN FRAME Summary
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN Summary4 IN FRAME Summary
   ALIGN-L                                                              */
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

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetTotals C-Win 
PROCEDURE GetTotals :
define output parameter IncludeTotal as int.
 
  define var Tot1 as integer no-undo.
  define var Tot2 as integer no-undo.
  define var Tot3 as integer no-undo.
  define var Tot4 as integer no-undo.
  define var Tot5 as integer no-undo.
  define var Tot6 as integer no-undo.
  define var Tot7 as integer no-undo.
  define var Tot8 as integer no-undo.
  define var Tot9 as integer no-undo.
  define var Tot10 as integer no-undo.
  
  run GetStats in hWiz1 (output Tot1).  
  run GetStats in hWiz2 (output Tot2).  
  run GetStats in hWiz3 (output Tot3).  
  run GetStats in hWiz4 (output Tot4).  
  run GetStats in hWiz5 (output Tot5).  
  run GetStats in hWiz6 (output Tot6).  
  run GetStats in hWiz7 (output Tot7).  
  run GetStats in hWiz8 (output Tot8).  
  run GetStats in hWiz9 (output Tot9).  
  run GetStats in hWiz10 (output Tot10). 
  
  IncludeTotal = Tot1 + Tot2 + Tot3 + Tot4 + Tot5 + Tot6 + Tot7 + Tot8 + Tot9 + Tot10.
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
do with frame Summary:
  define var IncludeFilters as int no-undo.
  define var KeywordFilters as int no-undo.
  define var UserFilters as int no-undo.
  define var SpecialFilters as int no-undo.
  
  enable all with frame {&frame-name}.
  run GetTotals (output IncludeFilters).
  run GetStats in hWiz11 (output KeyWordFilters).
  run GetStats in hWiz12 (output UserFilters).
  run GetStats in hWiz13 (output SpecialFilters).
  
  assign
    Summary1:screen-value      = string(IncludeFilters) + " 4GL Filters"
    Summary2:screen-value      = string(KeywordFilters) + " Keyword Filters"
    Summary3:screen-value      = IF UserFilters <> ? THEN
                                 string(UserFilters) + " Custom Filters"
                                 ELSE "? Custom Filters"
    Summary4:screen-value      = IF SpecialFilters <> ? THEN
                                 string(SpecialFilters) + " Special Filters"
                                 ELSE "? Special Filters"
    frame {&frame-name}:hidden = false.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


