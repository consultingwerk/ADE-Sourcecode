/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _y-logic.p - enter a logical literal */
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i } 
{ adecomm/commeng.i }  /* Help contexts */

&SCOPED-DEFINE FRAME-NAME qbf%logical
/*
pi_mode =  1 -> get a single value from the user
        =  2 -> unsupported for _y-logic.p
        =  3 -> unsupported for _y-logic.p
        =  4 -> unsupported for _y-logic.p
If the pi_mode number is negative, then support the ask-at-run-time mode.
*/
DEFINE INPUT  PARAMETER pi_mode AS INTEGER   NO-UNDO. /* 1, 2 or >2 */
DEFINE INPUT  PARAMETER pi_fmt  AS CHARACTER NO-UNDO. /* format */
DEFINE INPUT  PARAMETER pi_text AS CHARACTER NO-UNDO. /* message */
DEFINE OUTPUT PARAMETER po_out  AS CHARACTER NO-UNDO INITIAL ?. /* value */

DEFINE VARIABLE v_one   AS LOGICAL NO-UNDO. /* value holder */
DEFINE VARIABLE v_width AS INTEGER NO-UNDO. /* new width of literal text */
DEFINE VARIABLE v_false AS HANDLE  NO-UNDO. /* 'false' radio-item */
DEFINE VARIABLE v_true  AS HANDLE  NO-UNDO. /* 'true' radio-item */
DEFINE VARIABLE v_wh    AS HANDLE  NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "   OK   ":c15 {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL " Cancel ":c15 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help":c15   {&STDPH_OKBTN}. 
/*DEFINE BUTTON qbf-rt   LABEL "  Ask When Run  ":c16.*/

DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

OUTPUT TO TERMINAL. /* needed for RESULTS use */

FORM
  SKIP(.5)
  SPACE(2)
  v_one LABEL "Logical Value"
    VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "&YES (or TRUE)":t32 ,TRUE,
    "&NO  (or FALSE)":t32 ,FALSE
  SPACE(2) /*SKIP(.5)
  SPACE(2) qbf-ok qbf-ee SPACE(2) qbf-rt */

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee}
    /*&HELP   = qbf-help}*/

  WITH FRAME {&FRAME-NAME} SIDE-LABELS OVERLAY NO-ATTR-SPACE
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Enter Constant":t32 VIEW-AS DIALOG-BOX.

/*----------------------------------------------------------------------*/

/*
ON CHOOSE OF qbf-rt IN FRAME {&FRAME-NAME} DO:
  ASSIGN
    po_out = "<<ask>>":u
    v_wh   = SELF:FRAME.
  APPLY "END-ERROR" TO v_wh.
END.
*/

/*----------------------------------------------------------------------*/

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok}
  /*&HELP  = qbf-help}*/

ASSIGN
  v_true                                = v_one:handle IN FRAME {&FRAME-NAME}
  v_one                                 = TRUE
  /*qbf-rt:VISIBLE IN FRAME {&FRAME-NAME} = (pi_mode < 0)*/
  .

IF pi_text <> ? THEN DO:
  CREATE TEXT v_wh
    ASSIGN
      FORMAT       = SUBSTITUTE("x(&1)":u,LENGTH(pi_text,"RAW":U))
      SCREEN-VALUE = pi_text
      FRAME        = FRAME {&FRAME-NAME}:HANDLE.

  v_width = v_wh:WIDTH-PIXELS.
  DELETE WIDGET v_wh.
  ASSIGN
    v_one:TITLE IN FRAME {&FRAME-NAME} = pi_text
    v_wh                               = v_one:HANDLE IN FRAME {&FRAME-NAME}
    v_wh:SCREEN-VALUE                  = pi_text
    v_wh:WIDTH-PIXELS                  = v_width.
END.

/*
IF pi_mode > 0 THEN
  qbf-ee:X IN FRAME {&FRAME-NAME} = v_true:X
                                  + v_true:WIDTH-PIXELS
                                  - qbf-ee:WIDTH-PIXELS IN FRAME {&FRAME-NAME}.
*/

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  UPDATE
    v_one qbf-ok qbf-ee
    /*qbf-rt WHEN pi_mode < 0*/
    WITH FRAME {&FRAME-NAME}.

  po_out = TRIM(STRING(v_one,"TRUE/FALSE":u)).
END.

HIDE FRAME {&FRAME-NAME} NO-PAUSE.

RETURN.

/* _y-logic.p - end of file */

