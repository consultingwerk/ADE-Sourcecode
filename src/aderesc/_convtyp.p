/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _convtyp.p 
 *
 *    Prompt user for TTY conversion mode
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ adecomm/adestds.i }
{ aderes/reshlp.i }

&SCOPED-DEFINE FRAME-NAME convtype

DEFINE OUTPUT PARAMETER c-type AS INTEGER NO-UNDO.

DEFINE VARIABLE qbf-a AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c AS INTEGER   NO-UNDO VIEW-AS RADIO-SET VERTICAL
  RADIO-BUTTONS "&Configuration", 1,
                "&Query Directory", 2,
                "&All Files", 3.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  qbf-c AT 2 
    
  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME {&FRAME-NAME} NO-ATTR-SPACE NO-LABELS KEEP-TAB-ORDER
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee THREE-D
  TITLE "Conversion Type" VIEW-AS DIALOG-BOX.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Conversion_Type_Dialog_Box},?).

ON GO OF FRAME {&FRAME-NAME} 
  c-type = INTEGER(qbf-c:SCREEN-VALUE). 

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
  &FRAME = "FRAME {&FRAME-NAME}" 
  &BOX   = "rect_btns"
  &OK    = "qbf-ok" 
  &HELP  = "qbf-help" }

ENABLE qbf-c qbf-ok qbf-ee qbf-help
  WITH FRAME {&FRAME-NAME}.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

HIDE FRAME {&FRAME-NAME} NO-PAUSE.
RETURN.

/* _convtyp.p - end of file */

