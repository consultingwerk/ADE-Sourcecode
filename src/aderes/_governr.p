/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _governr.p
*
*    Prompt user for number of records to process for report
*/

&GLOBAL-DEFINE WIN95-BTN YES

&SCOPED-DEFINE FRAME-NAME governor

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/reshlp.i }
{ adecomm/adestds.i }
{ aderes/_asbar.i }

DEFINE OUTPUT PARAMETER lRet AS LOGICAL NO-UNDO.

FORM
  SKIP({&TFM_WID})

  qbf-governor AT 2 FORMAT ">,>>>,>>9":u LABEL "&Number of Records"
  
  qbf-govergen AT 2 LABEL "&Include in Generated Code"
    VIEW-AS TOGGLE-BOX

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee 
  TITLE "Data Governor".

/*-------------------------- Triggers ---------------------------- */

ON HELP OF FRAME {&FRAME-NAME} OR CHOOSE OF qbf-help IN FRAME {&FRAME-NAME}
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Data_Governor_Dlg_Box},?).

ON GO OF FRAME {&FRAME-NAME} DO:
  IF    qbf-governor = INTEGER(qbf-governor:SCREEN-VALUE)
    AND qbf-govergen:SCREEN-VALUE = STRING(qbf-govergen) THEN
  RETURN.

  ASSIGN
   qbf-dirty    = TRUE
   lRet         = TRUE
   qbf-governor = INTEGER(qbf-governor:SCREEN-VALUE)
   qbf-govergen = (qbf-govergen:SCREEN-VALUE = STRING(TRUE))
   .
END.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME}
  APPLY "END-ERROR":u TO SELF.             

/*-------------------------- Main Block -------------------------- */

FRAME {&FRAME-NAME}:HIDDEN = TRUE.

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

ASSIGN
  qbf-governor:SCREEN-VALUE  = STRING(qbf-governor)
  qbf-govergen:SCREEN-VALUE  = STRING(qbf-govergen)
  FRAME {&FRAME-NAME}:HIDDEN = FALSE.

ENABLE qbf-governor qbf-govergen qbf-ok qbf-ee qbf-help 
  WITH FRAME {&FRAME-NAME}.

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

&UNDEFINE FRAME-NAME
 
/* _governr.p - end of file */
