&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w_Color
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w_Color 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _colorch.w

  Description: change colors 0 to 15

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 04/16/93 - 10:22 am
  Updated: 2/9/94 - Updated syntax to current version (7.2A)
  Updated: 9/12/94- Updated to Run Persistent

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
{ protools/ptlshlp.i } /* help definitions */
{ adecomm/_adetool.i }
{ protools/_runonce.i}

/* Parameters Definitions ---                                                */

/* Local Variable Definitions ---                                            */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FRAME-A

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 Cancel-But OK-But Color-0 Color-1 ~
Color-2 Color-3 Color-4 Color-5 Color-6 Color-7 Revert-But Color-8 Color-9 ~
Color-10 Color-11 Color-12 Color-13 Color-14 Color-15 b_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w_Color AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Cancel-But AUTO-END-KEY 
     LABEL "&Close":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON OK-But 
     LABEL "&Save":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON Revert-But 
     LABEL "&Revert":L 
     SIZE 15 BY 1.14.

DEFINE RECTANGLE Color-0
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7 BY 1.14
     BGCOLOR 0 .

DEFINE RECTANGLE Color-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 1 .

DEFINE RECTANGLE Color-10
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 10 .

DEFINE RECTANGLE Color-11
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 11 .

DEFINE RECTANGLE Color-12
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 12 .

DEFINE RECTANGLE Color-13
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 13 .

DEFINE RECTANGLE Color-14
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 14 .

DEFINE RECTANGLE Color-15
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 15 .

DEFINE RECTANGLE Color-2
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 2 .

DEFINE RECTANGLE Color-3
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 3 .

DEFINE RECTANGLE Color-4
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 4 .

DEFINE RECTANGLE Color-5
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 5 .

DEFINE RECTANGLE Color-6
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 6 .

DEFINE RECTANGLE Color-7
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 7 .

DEFINE RECTANGLE Color-8
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 8 .

DEFINE RECTANGLE Color-9
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 7.2 BY 1.14
     BGCOLOR 9 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 5.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     Cancel-But AT ROW 1.29 COL 79
     OK-But AT ROW 2.76 COL 79
     Revert-But AT ROW 4.29 COL 79
     b_Help AT ROW 5.76 COL 79
     " Colors" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1 COL 4
     RECT-4 AT ROW 1.29 COL 3
     "Color 0" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 5
     "Color 1" VIEW-AS TEXT
          SIZE 6.6 BY .62 AT ROW 1.81 COL 14
     "Color 2" VIEW-AS TEXT
          SIZE 7 BY .62 AT ROW 1.81 COL 23
     "Color 3" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 32
     "Color 4" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 41
     "Color 5" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 50
     "Color 6" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 59
     "Color 7" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 68
     Color-0 AT ROW 2.81 COL 5
     Color-1 AT ROW 2.81 COL 14
     Color-2 AT ROW 2.81 COL 23
     Color-3 AT ROW 2.81 COL 32
     Color-4 AT ROW 2.81 COL 41
     Color-5 AT ROW 2.81 COL 50
     Color-6 AT ROW 2.81 COL 59
     Color-7 AT ROW 2.81 COL 68
     "Color 8" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 4.24 COL 5
     "Color 9" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 4.24 COL 14
     "Color 10" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 4.24 COL 23
     "Color 11" VIEW-AS TEXT
          SIZE 7.6 BY .62 AT ROW 4.24 COL 32
     "Color 12" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 4.24 COL 41
     "Color 13" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 4.24 COL 50
     "Color 14" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 4.24 COL 59
     "Color 15" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 4.24 COL 68
     Color-8 AT ROW 5.24 COL 5
     Color-9 AT ROW 5.24 COL 14
     Color-10 AT ROW 5.24 COL 23
     Color-11 AT ROW 5.24 COL 32
     Color-12 AT ROW 5.24 COL 41
     Color-13 AT ROW 5.24 COL 50
     Color-14 AT ROW 5.24 COL 59
     Color-15 AT ROW 5.24 COL 68
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.14 BY 6.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w_Color ASSIGN
         HIDDEN             = YES
         TITLE              = "Color Changer"
         HEIGHT             = 6.62
         WIDTH              = 95.6
         MAX-HEIGHT         = 6.62
         MAX-WIDTH          = 95.6
         VIRTUAL-HEIGHT     = 6.62
         VIRTUAL-WIDTH      = 95.6
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT w_Color:LOAD-ICON("adeicon/clrchnge":U) THEN
    MESSAGE "Unable to load icon: adeicon/clrchnge"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w_Color
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRAME-A
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w_Color)
THEN w_Color:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help w_Color
ON CHOOSE OF b_Help IN FRAME FRAME-A /* Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Color_Changer}, ? ).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Cancel-But
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Cancel-But w_Color
ON CHOOSE OF Cancel-But IN FRAME FRAME-A /* Close */
DO:  /* for BUTTON "Cancel"  */
  apply "window-close" to {&window-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Color-0
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Color-0 w_Color
ON MOUSE-SELECT-CLICK OF Color-0 IN FRAME FRAME-A
, color-1, color-2, color-3, color-4, color-5, color-6, color-7, color-8
, color-9, color-10, color-11, color-12, color-13, color-14, color-15
DO:  /* for RECTANGLE */
  run setcolor(self:bgcolor).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME OK-But
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL OK-But w_Color
ON CHOOSE OF OK-But IN FRAME FRAME-A /* Save */
DO:  /* for BUTTON "Save"  */
  PUT-KEY-VALUE color all NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RUN adeshar/_puterr.p ("Colors", CURRENT-WINDOW).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Revert-But
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Revert-But w_Color
ON CHOOSE OF Revert-But IN FRAME FRAME-A /* Revert */
DO:  /* for BUTTON "Revert"  */
  def var ok as log.
  def var cno as int.
  def var cinfo as char.
  repeat cno = 0 to 15:
      get-key-value section "colors" key "color" + string(cno) value cinfo.
      ok = color-table:set-red-value(cno, int(entry(1,cinfo))).
      ok = color-table:set-green-value(cno, int(entry(2,cinfo))).
      ok = color-table:set-blue-value(cno, int(entry(3,cinfo))).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w_Color 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN SetDynamic.
  STATUS INPUT "Click on the color you wish you change".
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w_Color _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w_Color)
  THEN DELETE WIDGET w_Color.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w_Color _DEFAULT-ENABLE
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
  ENABLE RECT-4 Cancel-But OK-But Color-0 Color-1 Color-2 Color-3 Color-4 
         Color-5 Color-6 Color-7 Revert-But Color-8 Color-9 Color-10 Color-11 
         Color-12 Color-13 Color-14 Color-15 b_Help 
      WITH FRAME FRAME-A IN WINDOW w_Color.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW w_Color.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setcolor w_Color 
PROCEDURE setcolor :
/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN setcolor (cno).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER cno AS INTEGER NO-UNDO.
  SYSTEM-DIALOG COLOR cno.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setdynamic w_Color 
PROCEDURE setdynamic :
/* -----------------------------------------------------------
  Purpose:     
  Run Syntax:  RUN <procedure> (INPUT, OUTPUT).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE cno AS INTEGER NO-UNDO.
  DEFINE VARIABLE ok  AS LOGICAL NO-UNDO.
  REPEAT cno = 0 TO 15:
     ok = COLOR-TABLE:SET-DYNAMIC(cno, yes).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

