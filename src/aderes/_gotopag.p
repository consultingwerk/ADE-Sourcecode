/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _gotopag.p 
 *
 *    Prompt user for page number in Print Preview
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/y-define.i }
{ adecomm/adestds.i }
/*{ aderes/reshlp.i }*/

&SCOPED-DEFINE FRAME-NAME gotopage

DEFINE INPUT  PARAMETER p-max     AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p-current AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER p-goto    AS INTEGER.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
/*DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.*/
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  p-goto AT 2 FORMAT ">>>9":u LABEL "Page Number" 
    VALIDATE(p-goto > 0 AND p-goto <= EXTENT(qbf-wsys.qbf-wseek),
      SUBSTITUTE("Page number must be between 1 and &1.",
      EXTENT(qbf-wsys.qbf-wseek)))
  SPACE(1)
    
  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee } 
    /*&HELP   = qbf-help }*/

  WITH FRAME {&FRAME-NAME} NO-ATTR-SPACE SIDE-LABELS KEEP-TAB-ORDER
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Go To" VIEW-AS DIALOG-BOX.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/*
ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Go_To_Dlg_Box},?).
*/

ON GO OF FRAME {&FRAME-NAME} 
  p-goto = INTEGER(p-goto:SCREEN-VALUE).

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/

ASSIGN
  p-goto                    = p-current
  p-goto:SCREEN-VALUE       = STRING(p-goto)
  FRAME {&FRAME-NAME}:WIDTH = qbf-ee:COL + qbf-ee:WIDTH + 1.5.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
  &FRAME = "FRAME {&FRAME-NAME}" 
  &BOX   = "rect_btns"
  &OK    = "qbf-ok" }
/*  &HELP  = "qbf-help" }*/

ENABLE ALL WITH FRAME {&FRAME-NAME}.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

HIDE FRAME {&FRAME-NAME} NO-PAUSE.
RETURN.

/* _gotopag.p - end of file */

