&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: protools/_idxdetl.w

  Description: Index Detail Window of DB Connections PRO*Tool

  Input Parameters:
      hParentWin - handle of Schema Detail Window

  Output Parameters:
      <none>

  Author: Tammy Marshall

  Created: 04/09/99

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

{protools/_schdef.i}  /* IndexDetails temp table definition */

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hParentWin AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cname cdesc bclose bHelp 
&Scoped-Define DISPLAYED-OBJECTS cname lactive lprimary cdesc lunique ~
lwordindex labbrev 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bclose 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cdesc AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 35 BY 3.52
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cname AS CHARACTER FORMAT "X(256)":U 
     LABEL "Index Name" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE labbrev AS LOGICAL INITIAL no 
     LABEL "Abbreviated" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE lactive AS LOGICAL INITIAL no 
     LABEL "Active" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE lprimary AS LOGICAL INITIAL no 
     LABEL "Primary" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE lunique AS LOGICAL INITIAL no 
     LABEL "Unique" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE lwordindex AS LOGICAL INITIAL no 
     LABEL "Word Index" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cname AT ROW 1.38 COL 15.2 COLON-ALIGNED
     lactive AT ROW 1.43 COL 54
     lprimary AT ROW 2.71 COL 54
     cdesc AT ROW 3.91 COL 7.8 NO-LABEL
     lunique AT ROW 4.05 COL 54
     lwordindex AT ROW 5.33 COL 54
     labbrev AT ROW 6.67 COL 54
     bclose AT ROW 14.76 COL 14
     bHelp AT ROW 14.76 COL 47.6
     "Description" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 2.95 COL 7.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85 BY 15.24.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Index Details"
         HEIGHT             = 15.33
         WIDTH              = 74.4
         MAX-HEIGHT         = 15.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 15.33
         VIRTUAL-WIDTH      = 90
         MAX-BUTTON         = no
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       cdesc:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cname:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR TOGGLE-BOX labbrev IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lactive IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lprimary IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lunique IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lwordindex IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Index Details */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON PARENT-WINDOW-CLOSE OF C-Win /* Index Details */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Index Details */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "ENTRY":U TO hParentWin.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bclose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bclose C-Win
ON CHOOSE OF bclose IN FRAME DEFAULT-FRAME /* Close */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bHelp C-Win
ON CHOOSE OF bHelp IN FRAME DEFAULT-FRAME /* Help */
DO:
  RUN adecomm/_adehelp.p
    (INPUT "ptls":U, 
     INPUT "CONTEXT":U, 
     INPUT 13, 
     INPUT  ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ASSIGN CURRENT-WINDOW:PARENT = hParentWin. /* parent the previous window to this window */

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

DEFINE QUERY qIndxFlds FOR IndxFldDetails.

DEFINE BROWSE brwsIndxFlds QUERY qIndxFlds NO-LOCK
  DISPLAY 
    idxseq LABEL "Index-Seq" 
    fldname LABEL "Field Name" FORMAT "x(20)"
    fldtype LABEL "Field Type" FORMAT "x(15)"
    lasc LABEL "Ascending" WITH EXPANDABLE SIZE 63 BY 5.50.
    
ASSIGN 
  BROWSE brwsIndxFlds:ROW = 8.50
  BROWSE brwsIndxFlds:COLUMN = 5.00.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  DISPLAY brwsIndxFlds WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE brwsIndxFlds WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cname lactive lprimary cdesc lunique lwordindex labbrev 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE cname cdesc bclose bHelp 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshIndex C-Win 
PROCEDURE refreshIndex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR IndexDetails.
DEFINE INPUT PARAMETER TABLE FOR IndxFldDetails.

  FIND FIRST IndexDetails NO-LOCK NO-ERROR.
  IF AVAILABLE IndexDetails THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      cname:SCREEN-VALUE = IndexDetails.idxname
      cdesc:SCREEN-VALUE = IndexDetails.tdesc
      lactive = IndexDetails.lactive
      lprimary = IndexDetails.lprimary
      lunique = IndexDetails.lunique
      lwordindex = IndexDetails.lwordindex
      labbrev = IndexDetails.labbrev.
    
    ASSIGN {&WINDOW-NAME}:TITLE = IndexDetails.idxname + " Index Details".
    DISPLAY lactive lprimary lunique lwordindex labbrev WITH FRAME {&FRAME-NAME}.
  END.  /* do with frame */
 
  OPEN QUERY qIndxFlds FOR EACH IndxFldDetails NO-LOCK.
    
  APPLY "ENTRY":U TO C-Win.
  APPLY "ENTRY":U TO bClose.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

