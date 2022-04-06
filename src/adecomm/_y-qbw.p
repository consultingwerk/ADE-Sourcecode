/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _y-qbw.p - enter a query-by-words expression string
 */

/*
For example:
  comput* science ! (comput* & (art ! graph*))

Will find:
  "The Science of Computer" as well as "Best Computer Science Book,"
  "Art and Crafts in Computer Publications," "Graphical Way of
  Computation".  It will not find "Computer Sciences" since it looks
  for an exact match to the word science without the "s" at the end.
*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}
{adecomm/commeng.i}

OUTPUT TO TERMINAL. /* needed for RESULTS use */

DEFINE INPUT  PARAMETER pi_mode AS INTEGER             NO-UNDO. /* 1, 2 or >2 */DEFINE INPUT  PARAMETER pi_fmt  AS CHARACTER           NO-UNDO. /* format */
DEFINE INPUT  PARAMETER pi_text AS CHARACTER           NO-UNDO. /* Message */
DEFINE OUTPUT PARAMETER po_out  AS CHARACTER INITIAL ? NO-UNDO. /* value */
/*
pi_mode =  1 -> get a single value from the user
        =  2 -> unsupported for _y-qbw.p
        =  3 -> unsupported for _y-qbw.p
        =  4 -> unsupported for _y-qbw.p
If the pi_mode number is negative, then support the ask-at-run-time mode.
*/

DEFINE VARIABLE v_wh AS WIDGET-HANDLE NO-UNDO. /* for aligning buttons */

DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE v_text AS CHARACTER NO-UNDO. /* text */
DEFINE VARIABLE v_one  AS CHARACTER NO-UNDO. /* value holder */

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"   {&STDPH_OKBTN}.

DEFINE RECTANGLE rect_btns            {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  v_text FORMAT "x(40)":u AT 2 SKIP

  v_one AT 2
    VIEW-AS EDITOR INNER-CHARS 64 INNER-LINES 6 SKIP({&VM_WIDG})

  {adecomm/okform.i
    &BOX    = "rect_btns"
    &STATUS =  no
    &OK     = "qbf-ok"
    &CANCEL = "qbf-ee"
    &HELP   = "qbf-help" }

  WITH FRAME qbf%qbw NO-LABELS NO-ATTR-SPACE
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Enter Contains String":t32 VIEW-AS DIALOG-BOX.

ON GO OF FRAME qbf%qbw DO:
  IF INPUT FRAME qbf%qbw v_one = "" THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "warning", "ok",
      "Contains string cannot be blank.  A blank value will prevent all " +
      "records from being selected.").
    RETURN NO-APPLY.
  END.

  IF INPUT FRAME qbf%qbw v_one BEGINS "*":u THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "warning", "ok",
      "Contains string cannot begin with an asterisk, but may be used as " +
      "a trailing wildcard, for example 'sales*'.").
    RETURN NO-APPLY.
  END.
  
  po_out = '"':u + REPLACE(v_one:SCREEN-VALUE,'"':u,'""':u) + '"':u.
END.

ON HELP OF FRAME qbf%qbw OR CHOOSE OF qbf-help IN FRAME qbf%qbw 
   RUN "adecomm/_adehelp.p" ("comm", "CONTEXT", {&Enter_Query_By_Dlg_Box}, ?).

ON WINDOW-CLOSE OF FRAME qbf%qbw
  APPLY "END-ERROR" TO SELF.

ASSIGN 
  v_one:RETURN-INSERTED IN FRAME qbf%qbw = TRUE
  v_text:SCREEN-VALUE IN FRAME qbf%qbw   = "Enter string value:":t50.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "frame qbf%qbw" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

ENABLE v_one qbf-ok qbf-ee qbf-help WITH FRAME qbf%qbw.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf%qbw.
END.

HIDE FRAME qbf%qbw NO-PAUSE.

RETURN.

/* _y-qbw.p - end of file */

