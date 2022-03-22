&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
/* Procedure Description
"Field Wizard"
*/
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

  File: _wizfld.w

  Description: Field wizard for SmartBrowser 

  Input Parameters:
      hWizard (handle) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 4/5/95

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{ adm/support/admhlp.i} /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hWizard AS WIDGET-HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE br-recid       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE proc-recid     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE qtbls          AS CHARACTER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 e_msg s_fields b_Addf b_Helpb 
&Scoped-Define DISPLAYED-OBJECTS e_msg s_fields 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Addf 
     LABEL "Add fields" 
     SIZE 26 BY 1.1.

DEFINE BUTTON b_Helpb 
     LABEL "Help on Browse Object" 
     SIZE 26 BY 1.1.

DEFINE VARIABLE e_msg AS CHARACTER INITIAL "Your SmartBrowser object contains a browse object that requires a list of fields to display." 
     VIEW-AS EDITOR
     SIZE 26 BY 4.91
     BGCOLOR 8  NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52 BY 9.05.

DEFINE VARIABLE s_fields AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 48 BY 7.48 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_msg AT ROW 1.61 COL 57 NO-LABEL
     s_fields AT ROW 2.57 COL 5 NO-LABEL
     b_Addf AT ROW 8.04 COL 57
     b_Helpb AT ROW 9.52 COL 57
     RECT-5 AT ROW 1.61 COL 3
     " Fields to display:" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 1.85 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         THREE-D 
         AT COL 1 ROW 1.04
         SIZE 83.6 BY 10.27
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
         TITLE              = "<insert title>"
         HEIGHT             = 10.52
         WIDTH              = 84
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 95.2
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 95.2
         RESIZE             = no
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
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE Default                                                    */
ASSIGN 
       e_msg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _FldNameList[1]   = SPORTS.Customer.Cust-Num
     _FldNameList[2]   = SPORTS.Customer.Name
     _FldNameList[3]   = SPORTS.Customer.Sales-Rep
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Addf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Addf C-Win
ON CHOOSE OF b_Addf IN FRAME DEFAULT-FRAME /* Add fields */
DO:
  DEFINE VARIABLE tbllist AS CHARACTER NO-UNDO.
  DEFINE VARIABLE xtbls   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i       AS INTEGER   NO-UNDO.

  /* Get external tables of the procedure */
  RUN adeuib/_uibinfo.p(?, "PROCEDURE ?":U, "EXTERNAL-TABLES":U, OUTPUT xtbls).
  
  ASSIGN tbllist = (IF xtbls NE ? AND xtbls NE "" THEN xtbls ELSE "":U) + 
                   (IF xtbls NE "":U AND xtbls NE ? AND qtbls NE "":U THEN ",":U 
                    ELSE "":U) + qtbls.

  /* Strip out any 'OF <tbl>' from string */
  DO i = 1 TO NUM-ENTRIES(tbllist):
    ENTRY(i,tbllist) = ENTRY(1,ENTRY(i,tbllist)," ":U).
  END.

  /* Run the column editor to maintain the field list */
  RUN adeuib/_uib_dlg.p (INT(br-recid), "COLUMN EDITOR":U, INPUT-OUTPUT tbllist).
  RUN Get-Fields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Helpb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Helpb C-Win
ON CHOOSE OF b_Helpb IN FRAME DEFAULT-FRAME /* Help on Browse Object */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Wiz_Browse_Objects}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       FRAME {&FRAME-NAME}:HEIGHT-P =  FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  =  FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       .
/* Get context id of procedure */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* Get context of the browse widget */
RUN adeuib/_uibinfo.p (INT(proc-recid), "PROCEDURE ?":U, 
   "CONTAINS BROWSE RETURN CONTEXT":U, OUTPUT br-recid).

/* Get the tables used in the browse/query */
RUN adeuib/_uibinfo.p(INT(br-recid), ?, "TABLES":U, OUTPUT qtbls).

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

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
  RUN Get-Fields.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME DEFAULT-FRAME.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win _DEFAULT-ENABLE
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
  DISPLAY e_msg s_fields 
      WITH FRAME DEFAULT-FRAME.
  ENABLE RECT-5 e_msg s_fields b_Addf b_Helpb 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Get-Fields C-Win 
PROCEDURE Get-Fields :
/*------------------------------------------------------------------------------
  Purpose:     Get field names.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE fldlist AS CHARACTER NO-UNDO.
    
  IF qtbls = "":U OR qtbls = ? THEN /* No query! */
    ASSIGN b_Addf:LABEL      IN FRAME {&FRAME-NAME} = "No query defined"
           b_Addf:SENSITIVE  IN FRAME {&FRAME-NAME} = NO.
  ELSE DO:
    s_fields:LIST-ITEMS IN FRAME {&FRAME-NAME} = "":U.
    /* Get the fields used in the browse */
    RUN adeuib/_uibinfo.p(INT(br-recid), ?, "FIELDS":U, OUTPUT fldlist).
    s_fields:LIST-ITEMS = fldlist.
    IF s_fields:NUM-ITEMS > 0 THEN DO:
      b_Addf:LABEL = "Modify fields".
      APPLY "U1":U TO hWizard. /* ok to finish */
    END.
    ELSE DO:
      b_Addf:LABEL = "Add fields".
      APPLY "U2":U TO hWizard. /* not ok to finish */
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


