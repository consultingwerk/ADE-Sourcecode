/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* PROGRAM: okbar.i
**
** This file adds the standard OK/CANCEL/HELP button bar to the bottom of a
** dialog box created in the UIB.  This file should be included at the top
** of the Main-Code-Block.
** This file acts as a front end for the trio: adestds.i okform.i okrun.i. 
** For more information on this, see the document
** design\ade\misc\sullivan.doc.
**
** PARAMETERS:
** &BOX      widget name of the rectangle to be used for the background box
**           (optional)
** &OK       widget name of the ok button     (optional)
** &CANCEL   widget name of the cancel button (optional)
** &OTHER    4GL for any intervening buttons  (optional)
** &HELP     widget name of the help button   (optional)
** &TOOL     The name of the tool (eg uib) for use in the
**           help trigger
** &CONTEXT  Name of the help context string.
**           [both &TOOL and &CONTEXT must be available if you
**            want a help trigger.]
** If the names are not given explicitly, then default values of
** rect_btn_bar, btn_OK, btn_cancel, and btn_help will be defined.
*/
/* ADE standards are required stdui.i for this file */
&IF DEFINED(ADESTDSI) = 0 &THEN
{ adecomm/adestds.i }
&ENDIF

/* Set defaults for Names */
&IF DEFINED(BOX) eq 0 &THEN     &SCOPED-DEFINE BOX rect_btn_bar 
&ENDIF
&IF DEFINED(OK) eq 0 &THEN      &SCOPED-DEFINE OK btn_OK
&ENDIF
&IF DEFINED(CANCEL) eq 0 &THEN  &SCOPED-DEFINE CANCEL btn_cancel
&ENDIF
/* NOTE: Help is a keyword so we can't ask for DEFINED(help)*/
&IF "{&HELP}" eq "" &THEN       &SCOPED-DEFINE HELP btn_help
&ENDIF

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btn_bar {&STDPH_OKBOX}.
&ENDIF

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON {&OK}      LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON {&CANCEL}  LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON {&HELP}    LABEL "&Help":C12  {&STDPH_OKBTN}.
/* Add these to the frame */
DEFINE FRAME {&FRAME-NAME} 
  {adecomm/okform.i}
  WITH DEFAULT-BUTTON {&OK} CANCEL-BUTTON {&CANCEL} .
  
/* Do run-time layout.  ok_run.i lays out width.  We need to also do 
   HEIGHT-P. */
{adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  }

/* Adjust the height based on the position of the OK button and the relavent
   borders (standard borders plus dialog-box border). */
ASSIGN FRAME {&FRAME-NAME}:SCROLLABLE = no
       FRAME {&FRAME-NAME}:HEIGHT     = ({&OK}:ROW  - 1) + {&OK}:HEIGHT + 
       FRAME {&FRAME-NAME}:BORDER-TOP + FRAME {&FRAME-NAME}:BORDER-BOTTOM +
       /* if there is an ok box, skip to allow for it below the buttons */
       &IF {&OKBOX} &THEN {&IVM_OKBOX} + &ENDIF
       /* skip a margin below the box or the buttons */
       {&VM_OKBOX}
       .

/* Add a standard ADE help trigger */
&IF DEFINED(TOOL) ne 0 AND DEFINED(CONTEXT) ne 0 &THEN
/* Standard Help Trigger */
ON CHOOSE OF {&HELP} OR HELP OF FRAME {&FRAME-NAME} DO:
   RUN adecomm/_adehelp.p ("{&TOOL}", "CONTEXT", {&CONTEXT}, "").
END.

&ENDIF

/* Enable these new buttons */
ENABLE {&OK} {&CANCEL} {&HELP} {&WHEN_HELP} WITH FRAME {&FRAME-NAME}.

/* Make sure the OK button is the default button. */
ASSIGN FRAME {&FRAME-NAME}:DEFAULT-BUTTON = {&OK}:HANDLE.

