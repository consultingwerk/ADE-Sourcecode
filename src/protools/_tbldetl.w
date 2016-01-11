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

  File: protools/_tbldetl.w

  Description: This is the Table Details Window of the DB Connections PRO*Tool

  Input Parameters:
      hParentWin - handle of the Schema Detail Window

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

{protools/_schdef.i}  /* Table-Details temp table definition */

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

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 cname cdesc clabel lMultitenant ~
lKeepDefault cstorarea creplproc cvalexp cvalmsg crtrig repcrtrig deltrig ~
repdeltrig fndtrig repwrtrig wrtrig bClose bHelp 
&Scoped-Define DISPLAYED-OBJECTS cname cdesc clabel lMultitenant ~
lKeepDefault cstorarea creplproc cvalexp cvalmsg crtrig repcrtrig deltrig ~
repdeltrig fndtrig repwrtrig wrtrig 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bClose 
     LABEL "&Close" 
     SIZE 15 BY 1.14.

DEFINE BUTTON bHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cdesc AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 38.6 BY 4.95
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE clabel AS CHARACTER FORMAT "X(256)":U 
     LABEL "Label" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cname AS CHARACTER FORMAT "X(256)":U INITIAL "abcdefghijklmnopqrstuvwxyz" 
     LABEL "Table Name" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE creplproc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Replication" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE crtrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Create" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cstorarea AS CHARACTER FORMAT "X(256)":U 
     LABEL "Storage Area" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cvalexp AS CHARACTER FORMAT "X(256)":U 
     LABEL "ValExp" 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cvalmsg AS CHARACTER FORMAT "X(256)":U 
     LABEL "ValMsg" 
     VIEW-AS FILL-IN 
     SIZE 76 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE deltrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Delete" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE fndtrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Find" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE lKeepDefault AS LOGICAL FORMAT "yes/no":U INITIAL NO 
     LABEL "Keep Default Area" 
     VIEW-AS FILL-IN 
     SIZE 6.8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE lMultitenant AS LOGICAL FORMAT "yes/no":U INITIAL NO 
     LABEL "Multi-tenant" 
     VIEW-AS FILL-IN 
     SIZE 6.8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE repcrtrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Replication-Create" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE repdeltrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Replication-Delete" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE repwrtrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Replication-Write" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE wrtrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Write" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 5.57.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cname AT ROW 1.38 COL 17 COLON-ALIGNED
     cdesc AT ROW 2.67 COL 56.4 NO-LABEL
     clabel AT ROW 2.71 COL 17 COLON-ALIGNED
     lMultitenant AT ROW 4 COL 17 COLON-ALIGNED WIDGET-ID 2
     lKeepDefault AT ROW 4 COL 44 COLON-ALIGNED WIDGET-ID 4
     cstorarea AT ROW 5.33 COL 17 COLON-ALIGNED
     creplproc AT ROW 6.62 COL 17 COLON-ALIGNED
     cvalexp AT ROW 7.91 COL 17 COLON-ALIGNED
     cvalmsg AT ROW 9.24 COL 17 COLON-ALIGNED
     crtrig AT ROW 11.14 COL 10.8 COLON-ALIGNED
     repcrtrig AT ROW 11.14 COL 60.6 COLON-ALIGNED
     deltrig AT ROW 12.43 COL 10.8 COLON-ALIGNED
     repdeltrig AT ROW 12.43 COL 60.6 COLON-ALIGNED
     fndtrig AT ROW 13.76 COL 10.8 COLON-ALIGNED
     repwrtrig AT ROW 13.76 COL 60.6 COLON-ALIGNED
     wrtrig AT ROW 15.05 COL 10.8 COLON-ALIGNED
     bClose AT ROW 17.05 COL 20.4
     bHelp AT ROW 17.05 COL 60.8
     "Description:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.76 COL 56.4
     "Triggers" VIEW-AS TEXT
          SIZE 8.2 BY .62 AT ROW 10.48 COL 5.4
     RECT-5 AT ROW 10.81 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


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
         TITLE              = "Table Details"
         HEIGHT             = 18.81
         WIDTH              = 96
         MAX-HEIGHT         = 20.48
         MAX-WIDTH          = 101
         VIRTUAL-HEIGHT     = 20.48
         VIRTUAL-WIDTH      = 101
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
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME DEFAULT-FRAME:SCROLLABLE       = FALSE.

ASSIGN 
       cdesc:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       clabel:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cname:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       creplproc:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       crtrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cstorarea:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cvalexp:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cvalmsg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       deltrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fndtrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       lKeepDefault:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       lMultitenant:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       repcrtrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       repdeltrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       repwrtrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       wrtrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Table Details */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON PARENT-WINDOW-CLOSE OF C-Win /* Table Details */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Table Details */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "ENTRY":U TO hParentWin.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bClose C-Win
ON CHOOSE OF bClose IN FRAME DEFAULT-FRAME /* Close */
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
     INPUT 11, 
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

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
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
  DISPLAY cname cdesc clabel lMultitenant lKeepDefault cstorarea creplproc 
          cvalexp cvalmsg crtrig repcrtrig deltrig repdeltrig fndtrig repwrtrig 
          wrtrig 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-5 cname cdesc clabel lMultitenant lKeepDefault cstorarea 
         creplproc cvalexp cvalmsg crtrig repcrtrig deltrig repdeltrig fndtrig 
         repwrtrig wrtrig bClose bHelp 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshTable C-Win 
PROCEDURE refreshTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR TableDetails.
 
  FIND FIRST TableDetails NO-LOCK NO-ERROR.
  IF AVAILABLE TableDetails THEN DO WITH FRAME {&FRAME-NAME}:
    IF TableDetails.multitenant then
        cstorarea:label = "Default Area".
    else    
        cstorarea:label = "Storage Area".
        
    ASSIGN 
      cname:SCREEN-VALUE = TableDetails.name
      cdesc:SCREEN-VALUE = TableDetails.tdesc
      clabel:SCREEN-VALUE = TableDetails.tlabel
      crtrig:SCREEN-VALUE = TableDetails.crtrig
      deltrig:SCREEN-VALUE = TableDetails.deltrig
      fndtrig:SCREEN-VALUE = TableDetails.fndtrig
      wrtrig:SCREEN-VALUE = TableDetails.wrtrig
      repcrtrig:SCREEN-VALUE = TableDetails.repcrtrig
      repdeltrig:SCREEN-VALUE = TableDetails.repdeltrig
      repwrtrig:SCREEN-VALUE = TableDetails.repwrtrig
      cvalexp:SCREEN-VALUE = TableDetails.valexp
      cvalmsg:SCREEN-VALUE = TableDetails.valmsg
      creplproc:SCREEN-VALUE = TableDetails.replproc   
      cstorarea:SCREEN-VALUE = TableDetails.storarea
      lMultitenant:SCREEN-VALUE = string(TableDetails.multitenant)
      lKeepDefault:SCREEN-VALUE = string(TableDetails.keepdefaultarea).       
    ASSIGN {&WINDOW-NAME}:TITLE = TableDetails.name + " Table Details".
  END.  /* do with frame */
  
  APPLY "ENTRY":U TO C-Win.
  APPLY "ENTRY":U TO bClose.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

