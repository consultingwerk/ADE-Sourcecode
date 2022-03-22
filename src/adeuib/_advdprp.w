&Scoped-define WINDOW-NAME    adv-dial
&Scoped-define FRAME-NAME     adv-dial
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------------

  File: _advdprp.w

  Description: Advanced Property Sheet for a SmartData. 

  Input Parameters:
      u-recid  - The recid of the current widget
      lbl_wdth - The width of a label for FILL-INS and COMBO-BOXES in CHARACTERS
                 0 for other widgets.

  Output Parameters:
      <none>

  Author:  SLK
  Modified: 11/24/98

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE USE-3D           YES
&GLOBAL-DEFINE WIN95-BTN        YES


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER u-recid  AS RECID   NO-UNDO.
DEFINE INPUT PARAMETER lbl_wdth AS DECIMAL NO-UNDO.

/* Local Variable Definitions ---                                       */
{adeuib/uniwidg.i}
{adecomm/adestds.i}
{adeuib/uibhlp.i}
{adeuib/sharvars.i}

DEFINE VARIABLE i                 AS INTEGER                       NO-UNDO.
define variable frameTitle as character no-undo init "Advanced Properties":L.
/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF
/* New-line character */
&Scoped-define NL CHR(10)


/* ***********************  Control Definitions  ********************** */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME adv-dial
     _U._PRIVATE-DATA VIEW-AS EDITOR SIZE 63 BY 4 SCROLLBAR-VERTICAL 
              {&STDPH_ED4GL_SMALL}  AT ROW 1.13 COL 16 COLON-ALIGN SKIP ({&VM_WID})
    WITH 
     &if defined(IDE-IS-RUNNING) = 0 &then
    VIEW-AS DIALOG-BOX 
      TITLE frameTitle
     &else
     no-box
     &endif
    KEEP-TAB-ORDER
    SIDE-LABELS THREE-D
    SIZE 82.01 BY 16.94.

ASSIGN FRAME adv-dial:HIDDEN = TRUE
       .
{adeuib/ide/dialoginit.i "Frame adv-dial:handle"}

FIND _U WHERE RECID(_U) = u-recid.
FIND _P WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE.

ASSIGN 
     &if defined(IDE-IS-RUNNING) = 0 &then 
   FRAME adv-dial:TITLE = FRAME adv-dial:TITLE 
    &else
    frameTitle = frameTitle 
    &endif
        + " for " +  _P._TYPE + " " + _U._NAME 
			     
   _U._PRIVATE-DATA:RETURN-INSERTED IN FRAME adv-dial = TRUE.


/* Shrink the dialog */
FRAME adv-dial:HEIGHT = FRAME adv-dial:HEIGHT - .75.

/* ***************  Runtime Attributes and UIB Settings  ************** */

/* SETTINGS FOR DIALOG-BOX adv-dial
   VISIBLE,L                                                            */

/* SETTINGS FOR DIALOG-BOX adv-dial
   UNDERLINE                                                            */
ASSIGN 
       FRAME adv-dial:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN cur-layout IN FRAME adv-dial
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */

/* ************************  Control Triggers  ************************ */




/* ***************************  Main Block  *************************** */

/* Restore the current-window if it is an icon.                         */
/* Otherwise the dialog box will be hidden                              */
IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED 
THEN CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

{adecomm/okbar.i}

ASSIGN FRAME adv-dial:DEFAULT-BUTTON = btn_OK:HANDLE IN FRAME adv-dial.

ON CHOOSE OF btn_help IN FRAME adv-dial OR HELP OF FRAME adv-dial DO:
  RUN adecomm/_adehelp.p ( "ab", "CONTEXT", {&Advanced_Property_Sheet_for_SmartDataObjects}, ? ).
END.

&SCOPED-DEFINE CANCEL-EVENT U2
{adeuib/ide/dialogstart.i btn_ok btn_cancel frametitle}
     
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
  
  
    VIEW FRAME {&FRAME-NAME}.      
        
    &if defined(IDE-IS-RUNNING) = 0 &then
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    &else
    WAIT-FOR GO OF FRAME {&FRAME-NAME} or "{&CANCEL-EVENT}" of this-procedure.
    &endif.
  
  /* Remove trailing whitespace on the PRIVATE-DATA. (Users often hit an
     extra <cr> at the end of this field.  Also, stripping trailing blanks
     is consistent with Progress Fill-In field behavior.) */
  IF _U._PRIVATE-DATA:MODIFIED IN FRAME adv-dial 
  THEN _U._PRIVATE-DATA = RIGHT-TRIM(_U._PRIVATE-DATA:SCREEN-VALUE 
                                     IN FRAME adv-dial).
END.  /* MAIN-BLOCK */

RUN disable_UI.


/* **********************  Internal Procedures  *********************** */

PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME adv-dial.
END PROCEDURE.


PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */

  DISPLAY _U._PRIVATE-DATA WITH FRAME adv-dial.
  ENABLE _U._PRIVATE-DATA WITH FRAME adv-dial.
END PROCEDURE.
