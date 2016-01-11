&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
define variable wintitle as character no-undo init "Goto Page":L.



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
    
    WITH 
    &if DEFINED(IDE-IS-RUNNING) = 0  &then 
    VIEW-AS DIALOG-BOX TITLE wintitle 
    &else
    NO-BOX
    &endif
    KEEP-TAB-ORDER 
    SIDE-LABELS 
    THREE-D  
    SCROLLABLE. 
    
{adeuib/ide/dialoginit.i "FRAME f_dlg:handle"}


/* *********************** Procedure Settings ************************ */





/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

/* SETTINGS FOR DIALOG-BOX f_dlg
   UNDERLINE                                                            */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f_dlg
ON WINDOW-CLOSE OF FRAME f_dlg /* Goto Page */
DO:
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
   APPLY "END-ERROR":U TO SELF.  
END.



&UNDEFINE SELF-NAME



/* *************************  Standard Buttons ************************ */

{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&Goto_Page_Dlg_Box}
                  }

/* ***************************  Main Block  *************************** */

&IF DEFINED(IDE-IS-RUNNING) <> 0 &THEN
dialogService:View().  
&ELSE
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
&ENDIF 

/* Get the current value of the current page to show. */
FIND _P WHERE RECID(_P) eq p_Precid.
iPage_number = _P._page-current.

&scoped-define CANCEL-EVENT U2
{adeuib/ide/dialogstart.i btn_ok btn_cancel wintitle}
 
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
   &if DEFINED(IDE-IS-RUNNING) = 0  &then
     WAIT-FOR GO OF FRAME {&FRAME-NAME}.
   &ELSE
     WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.       
     if cancelDialog THEN UNDO, LEAVE.  
   &endif

  /* Did the value of the current page change. */
  ASSIGN iPage_number.
  IF iPage_number ne _P._page-current THEN DO:
    _P._page-current = iPage_number.
    RUN adeuib/_showpag.p (RECID(_P), iPage_number).
  END.
END.
RUN disable_UI.



/* **********************  Internal Procedures  *********************** */

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


