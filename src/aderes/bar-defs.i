/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
DEFINE BUTTON qbf-ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee     LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

/*
 * Add the buttons to the frame. If the frame already exists (as it should)
 * then this define frame statement will add the buttons to the frame.
 */
DEFINE FRAME {&FRAME-NAME}
  {adecomm/okform.i
    &BOX    = "rect_btns"
    &STATUS = "no"
    &OK     = "qbf-ok"
    &CANCEL = "qbf-ee"
    &HELP   = "qbf-help"}.

{adecomm/okrun.i  
   &FRAME = "FRAME {&FRAME-NAME}" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }      

ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u, "CONTEXT":u, {&HELP-NO}, ?).

ASSIGN
  FRAME {&FRAME-NAME}:DEFAULT-BUTTON = qbf-ok:HANDLE
  qbf-ok:SENSITIVE     IN FRAME {&FRAME-NAME} = TRUE
  qbf-ok:DEFAULT       IN FRAME {&FRAME-NAME} = TRUE
  qbf-ee:SENSITIVE     IN FRAME {&FRAME-NAME} = TRUE
  qbf-help:SENSITIVE   IN FRAME {&FRAME-NAME} = TRUE.

/* bar-defs.i - end of file */
