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

  File: protools/_flddetl.w

  Description: Field Detail Window of the DB Connections PRO*Tool

  Input Parameters:
      hParentWin - Handle of the Schema Detail Window

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

{protools/_schdef.i}  /* FieldDetails temp table definition */

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
&Scoped-Define ENABLED-OBJECTS cname cdatatype cformat iorder clabel ~
idecimals ccollabel iextent casgntrig cinitial chelp cvalexp cvalmsg ~
cviewas cdesc bClose bHelp 
&Scoped-Define DISPLAYED-OBJECTS cname cdatatype cformat iorder clabel ~
idecimals ccollabel iextent casgntrig cinitial chelp cvalexp cvalmsg ~
cviewas cdesc lmandatory lcasesen 

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
     SIZE 45 BY 3.33
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cviewas AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 45 BY 3.33
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE casgntrig AS CHARACTER FORMAT "X(256)":U 
     LABEL "Assign Trig" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE ccollabel AS CHARACTER FORMAT "X(30)":U 
     LABEL "Col. Label" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cdatatype AS CHARACTER FORMAT "X(15)":U 
     LABEL "Data Type" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cformat AS CHARACTER FORMAT "X(45)":U 
     LABEL "Format" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE chelp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Help" 
     VIEW-AS FILL-IN 
     SIZE 82 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cinitial AS CHARACTER FORMAT "X(30)":U INITIAL "0" 
     LABEL "Initial" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE clabel AS CHARACTER FORMAT "X(30)":U 
     LABEL "Label" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cname AS CHARACTER FORMAT "X(30)":U 
     LABEL "Field Name" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cvalexp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Valexp" 
     VIEW-AS FILL-IN 
     SIZE 82 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cvalmsg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Valmsg" 
     VIEW-AS FILL-IN 
     SIZE 82 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE idecimals AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Decimals" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE iextent AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Extent" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE iorder AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Order #" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE lcasesen AS LOGICAL INITIAL no 
     LABEL "Case Sensitive":L 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .86 NO-UNDO.

DEFINE VARIABLE lmandatory AS LOGICAL INITIAL no 
     LABEL "Mandatory":L 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cname AT ROW 1.38 COL 13 COLON-ALIGNED
     cdatatype AT ROW 1.48 COL 70 COLON-ALIGNED
     cformat AT ROW 2.67 COL 13 COLON-ALIGNED
     iorder AT ROW 2.76 COL 70 COLON-ALIGNED
     clabel AT ROW 4 COL 13 COLON-ALIGNED
     idecimals AT ROW 4.1 COL 70 COLON-ALIGNED
     ccollabel AT ROW 5.29 COL 13 COLON-ALIGNED
     iextent AT ROW 5.38 COL 70 COLON-ALIGNED
     casgntrig AT ROW 6.57 COL 13 COLON-ALIGNED
     cinitial AT ROW 6.67 COL 70 COLON-ALIGNED
     chelp AT ROW 7.86 COL 13 COLON-ALIGNED
     cvalexp AT ROW 9.19 COL 13 COLON-ALIGNED
     cvalmsg AT ROW 10.48 COL 13 COLON-ALIGNED
     cviewas AT ROW 12.91 COL 52 NO-LABEL
     cdesc AT ROW 12.95 COL 5.8 NO-LABEL
     lmandatory AT ROW 16.76 COL 14
     lcasesen AT ROW 16.76 COL 53
     bClose AT ROW 18.43 COL 18.6
     bHelp AT ROW 18.43 COL 66.4
     "Description:" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 12 COL 6.6
     "View-As phrase:" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 12 COL 52.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 98 BY 19.


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
         TITLE              = "Field Details"
         HEIGHT             = 19.05
         WIDTH              = 98.8
         MAX-HEIGHT         = 19.91
         MAX-WIDTH          = 118.2
         VIRTUAL-HEIGHT     = 19.91
         VIRTUAL-WIDTH      = 118.2
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
       casgntrig:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       ccollabel:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cdatatype:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cdesc:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cformat:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       chelp:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cinitial:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       clabel:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cname:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cvalexp:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cvalmsg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       cviewas:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       idecimals:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       iextent:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       iorder:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR TOGGLE-BOX lcasesen IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lmandatory IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Field Details */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON PARENT-WINDOW-CLOSE OF C-Win /* Field Details */
DO:
  APPLY "WINDOW-CLOSE":U TO C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Field Details */
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
     INPUT 30, 
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
  DISPLAY cname cdatatype cformat iorder clabel idecimals ccollabel iextent 
          casgntrig cinitial chelp cvalexp cvalmsg cviewas cdesc lmandatory 
          lcasesen 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE cname cdatatype cformat iorder clabel idecimals ccollabel iextent 
         casgntrig cinitial chelp cvalexp cvalmsg cviewas cdesc bClose bHelp 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshField C-Win 
PROCEDURE refreshField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR FieldDetails.

  FIND FIRST FieldDetails NO-LOCK NO-ERROR.
  IF AVAILABLE FieldDetails THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      casgntrig:SCREEN-VALUE = FieldDetails.asgntrig
      ccollabel:SCREEN-VALUE = FieldDetails.collabel
      cdatatype:SCREEN-VALUE = FieldDetails.datatype
      cdesc:SCREEN-VALUE = FieldDetails.tdesc
      cformat:SCREEN-VALUE = FieldDetails.tformat
      chelp:SCREEN-VALUE = FieldDetails.thelp
      cviewas:SCREEN-VALUE = FieldDetails.viewas
      cinitial:SCREEN-VALUE = FieldDetails.initval
      clabel:SCREEN-VALUE = FieldDetails.tlabel
      cname:SCREEN-VALUE = FieldDetails.fldname
      cvalexp:SCREEN-VALUE = FieldDetails.valexp
      cvalmsg:SCREEN-VALUE = FieldDetails.valmsg
      idecimals:SCREEN-VALUE = STRING(FieldDetails.tdec)
      iextent:SCREEN-VALUE = STRING(FieldDetails.textent)
      iorder:SCREEN-VALUE = STRING(FieldDetails.torder)
      lmandatory = FieldDetails.tmandatory
      lcasesen = FieldDetails.casesensitive.
      
    ASSIGN {&WINDOW-NAME}:TITLE = FieldDetails.tblname + "." + 
      FieldDetails.fldname + " Field Details".
    DISPLAY lmandatory lcasesen WITH FRAME {&FRAME-NAME}.
  END.  /* do with frame */
  
  APPLY "ENTRY":U TO C-Win.
  APPLY "ENTRY":U TO bClose.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

