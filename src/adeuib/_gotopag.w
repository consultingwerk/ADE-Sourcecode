&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg 
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
/*------------------------------------------------------------------------

  File: _gotopag.w

  Description: Change the current page number shown in the Current Window.

  Input-Output Parameters:
      p_Precid - Recid of the current procedure.
      
  Author: Wm.T.Wood 

  Created: March 27, 1995

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Shared Variable Definitions ---                                      */
&SCOPED-DEFINE USE-3D    YES
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}   /* Standard Definitions             */ 
{adeuib/uibhlp.i}     /* Help pre-processor directives    */
{adeuib/uniwidg.i}    /* Universal Widget Temp-Table      */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) eq 0 &THEN
  DEFINE INPUT PARAMETER p_Precid AS RECID NO-UNDO.
&ELSE
  DEFINE VAR p_Precid AS RECID NO-UNDO.
  FIND FIRST _P.
  p_Precid = RECID(_P).
&ENDIF

/* Local Variable Definitions --                                        */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS iPage_number 
&Scoped-Define DISPLAYED-OBJECTS iPage_number 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE iPage_number AS INTEGER FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Display Page Number" 
     VIEW-AS FILL-IN 
     SIZE 10.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     iPage_number AT ROW 1.38 COL 28 COLON-ALIGNED
     "Note - the ~"Main~" page (i.e. 0) is always shown." VIEW-AS TEXT
          SIZE 55 BY 1 AT ROW 2.62 COL 2.6
     SPACE(1.79) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "Goto Page":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_dlg
   UNDERLINE                                                            */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_dlg f_dlg
ON WINDOW-CLOSE OF FRAME f_dlg /* Goto Page */
DO:
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
   APPLY "END-ERROR":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg 


/* *************************  Standard Buttons ************************ */

{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Goto_Page_Dlg_Box}
                  }

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Get the current value of the current page to show. */
FIND _P WHERE RECID(_P) eq p_Precid.
iPage_number = _P._page-current.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  /* Did the value of the current page change. */
  ASSIGN iPage_number.
  IF iPage_number ne _P._page-current THEN DO:
    _P._page-current = iPage_number.
    RUN adeuib/_showpag.p (RECID(_P), iPage_number).
  END.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg  _DEFAULT-DISABLE
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
  HIDE FRAME f_dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg  _DEFAULT-ENABLE
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
  DISPLAY iPage_number 
      WITH FRAME f_dlg.
  ENABLE iPage_number 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

