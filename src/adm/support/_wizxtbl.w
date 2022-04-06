&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"External Table Wizard"
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

  File: _wizxtbl.w

  Description: External Table wizard screen 

  Input Parameters:
      hWizard (hdl) - handle of Wizard dialog

  Output Parameters:
      <none>

  Author: Gerry Seidl 

  Created: 4/4/95

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
{ adm/support/admhlp.i } /* ADM Help Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hWizard AS WIDGET-HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE proc-recid     AS CHARACTER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_xtbl b_AddXT b_HelpXT r_xTbl 
&Scoped-Define DISPLAYED-OBJECTS e_xtbl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_AddXT 
     LABEL "Add External Tables" 
     SIZE 26 BY 1.1.

DEFINE BUTTON b_HelpXT 
     LABEL "Help on External Tables" 
     SIZE 26 BY 1.1.

DEFINE VARIABLE e_xtbl AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 5.62
     BGCOLOR 8 FONT 4 NO-UNDO.

DEFINE VARIABLE msg AS CHARACTER FORMAT "X(256)":U INITIAL "External tables currently defined:" 
      VIEW-AS TEXT 
     SIZE 33 BY .81 NO-UNDO.

DEFINE IMAGE IMAGE-3 CONVERT-3D-COLORS
     SIZE 39 BY 7.1.

DEFINE RECTANGLE r_xTbl
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 9.05.

DEFINE VARIABLE s_xTbls AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE NO-DRAG SCROLLBAR-VERTICAL 
     SIZE 47 BY 7 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_xtbl AT ROW 1.66 COL 57 NO-LABEL
     s_xTbls AT ROW 2.94 COL 6 NO-LABEL
     b_AddXT AT ROW 8.09 COL 57
     b_HelpXT AT ROW 9.51 COL 57
     msg AT ROW 1.89 COL 6 NO-LABEL
     IMAGE-3 AT ROW 2.42 COL 12
     r_xTbl AT ROW 1.66 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         THREE-D 
         AT COL 1 ROW 1
         SIZE 83.6 BY 11.12
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert title>"
         HEIGHT             = 11.33
         WIDTH              = 83.8
         MAX-HEIGHT         = 19.76
         MAX-WIDTH          = 103.2
         VIRTUAL-HEIGHT     = 19.76
         VIRTUAL-WIDTH      = 103.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = no.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   UNDERLINE                                                            */
ASSIGN 
       e_xtbl:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR IMAGE IMAGE-3 IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       IMAGE-3:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN msg IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       msg:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR SELECTION-LIST s_xTbls IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       s_xTbls:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
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


&Scoped-define SELF-NAME b_AddXT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_AddXT C-Win
ON CHOOSE OF b_AddXT IN FRAME DEFAULT-FRAME /* Add External Tables */
DO:
  DEFINE VARIABLE arg AS CHARACTER.
  
  /* Call External Tables dialog */
  RUN adeuib/_uib_dlg.p (INT(proc-recid), "EXTERNAL-TABLES":U, INPUT-OUTPUT arg).
  RUN Check_TblList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_HelpXT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_HelpXT C-Win
ON CHOOSE OF b_HelpXT IN FRAME DEFAULT-FRAME /* Help on External Tables */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Wiz_External_Tables}, ?).  
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

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Get Procedure context (recid of procedure record in the UIB) */
RUN adeuib/_uibinfo.p(?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).
RUN Check_TblList.
  
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
  RUN Load_Image.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check_TblList C-Win 
PROCEDURE Check_TblList :
/*------------------------------------------------------------------------------
  Purpose:     Check the list of EXTERNAL-TABLES in the current procedure.
               Set the screen accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE xtbllist AS CHARACTER NO-UNDO.

/* Ask for the external tables in the Procedure */
RUN adeuib/_uibinfo.p (INT(proc-recid), "PROCEDURE ?":U, "EXTERNAL-TABLES":U, 
                       OUTPUT xtbllist).

DO WITH FRAME {&FRAME-NAME}:
  IF xTblList <> "":U AND xTblList <> ? THEN 
    ASSIGN b_AddXT:LABEL = "Modify External Tables"
           s_xTbls:HIDDEN = no
           s_xTbls:LIST-ITEMS  = xTblList
           s_xTbls:SENSITIVE = yes
           s_xTbls:VISIBLE = yes
           msg:HIDDEN     = no
           IMAGE-3:HIDDEN = yes
           .  
  ELSE
    ASSIGN b_AddXT:LABEL = "Add External Tables"
           s_xTbls:LIST-ITEMS  = "":U
           s_xTbls:SENSITIVE = no
           s_xTbls:HIDDEN = yes
           msg:HIDDEN     = yes
           IMAGE-3:HIDDEN = no
           .
  IF NOT msg:HIDDEN THEN DISPLAY msg WITH FRAME {&FRAME-NAME}.
  IF NOT s_xTbls:HIDDEN THEN DISPLAY s_xTbls WITH FRAME {&FRAME-NAME}.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  /* Hide all frames. */
  HIDE FRAME DEFAULT-FRAME.
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
  DISPLAY e_xtbl 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_xtbl b_AddXT b_HelpXT r_xTbl 
      WITH FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Load_Image C-Win 
PROCEDURE Load_Image :
/*------------------------------------------------------------------------------
  Purpose:     Check the type of object associated with this Wizard page..
               Load appropriate images and set the message text.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE objtype AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l       AS LOGICAL   NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    /* Get procedure type (SmartQuery or SmartBrowser) */
    RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT objtype).
    CASE objtype:
      WHEN "SmartQuery":U   THEN l = IMAGE-3:LOAD-IMAGE("adeicon/q-extbl":U).
      WHEN "SmartBrowser":U THEN l = IMAGE-3:LOAD-IMAGE("adeicon/b-extbl":U).
    END CASE.
    e_xtbl = "Does this " + objtype + " require database information " +
             "from another source? (e.g. Tables to complete a Join) If so, " +
             "you need to define these table(s) as 'External Tables'" + CHR(10) +
             CHR(10) +
             "Note: If you define 'External Tables', then you will not be " +
             "able to accept optional 'Foreign Keys'.".
    DISPLAY e_xtbl WITH FRAME {&FRAME-NAME}.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

