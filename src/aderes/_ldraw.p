/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* _ldraw.p - does redraw logic for labels */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/l-define.i }
{ aderes/s-menu.i }

DEFINE VARIABLE c-scrap  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-loop   AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-scrap  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE l-line   AS INTEGER   NO-UNDO.
DEFINE VARIABLE lbl-type AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-scroll AS LOGICAL   NO-UNDO.
DEFINE VARIABLE y-scroll AS LOGICAL   NO-UNDO.
DEFINE VARIABLE save_dim AS INTEGER   NO-UNDO.

/* validate label layout before redrawing */
RUN aderes/l-verify.p (FALSE, OUTPUT l-line, OUTPUT c-scrap).
IF l-line > 0 THEN
  RUN aderes/l-edit.p (OUTPUT l-scrap).
  
FIND FIRST qbf-lsys NO-ERROR.

ASSIGN
  hdr-text = 
    IF qbf-lsys.qbf-type BEGINS "Custom" THEN
      "  Label: " + qbf-lsys.qbf-type
    ELSE IF qbf-lsys.qbf-type > "" THEN
      "  Label: " + qbf-lsys.qbf-type + " (" + qbf-lsys.qbf-dimen + ")"
    ELSE
      "  Label: Default layout"
  hdr-text = hdr-text + CHR(10) 
    + "  Width:" + STRING(qbf-lsys.qbf-label-wd," ZZ9":u)
    + "    Spaces Between:"
    + STRING(qbf-lsys.qbf-space-hz,"ZZ9":u)
    + "    # Across:"
    + STRING(qbf-lsys.qbf-across,"ZZ9":u)
    + "       Left Margin:"
    + STRING(qbf-lsys.qbf-origin-hz," ZZ9":u) + CHR(10)

    + " Height:"
    + STRING(qbf-lsys.qbf-label-ht," ZZ9":u)
    + "     Lines Between:"
    + STRING(qbf-lsys.qbf-space-vt,"ZZ9":u)
    + "    # Copies:"
    + STRING(qbf-lsys.qbf-copies,"ZZ9":u)
    + "   Omit Blank Line? "
    + STRING(qbf-lsys.qbf-omit,"yes/no ")
  .

/* strip trailing carriage return for MS-Windows */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN":u &THEN
DO i-loop = 1 TO (EXTENT(qbf-l-text) - 1):
  qbf-l-text[i-loop] = REPLACE(qbf-l-text[i-loop],CHR(13),"":u).
END.
&ENDIF

/* adjust for differing fonts in window systems */
DO i-loop = 1 TO qbf-lsys.qbf-label-ht:
  lbl-text = (IF i-loop = 1 THEN "" ELSE lbl-text + CHR(10))
         + qbf-l-text[i-loop].
END.

ASSIGN
  FRAME fHeader:FONT                     = 0
  FRAME fHeader:SCROLLABLE               = FALSE
  
  FRAME fHeader:Y                        = IF lGlbToolbar THEN 
                                             FRAME fToolbar:HEIGHT-PIXELS
                                           ELSE 0
  FRAME fHeader:WIDTH-PIXELS             = CURRENT-WINDOW:WIDTH-PIXELS
  
  hdr-text:SCREEN-VALUE IN FRAME fHeader = hdr-text
  hdr-text:READ-ONLY IN FRAME fHeader    = TRUE
  hdr-text:WIDTH-PIXELS IN FRAME fHeader = FRAME fHeader:WIDTH-PIXELS
                                         - FRAME fHeader:BORDER-LEFT-PIXELS
                                         - FRAME fHeader:BORDER-RIGHT-PIXELS

  FRAME fLabel:SCROLLABLE                = YES
  FRAME fLabel:FONT                      = 0
  FRAME fLabel:HEIGHT-PIXELS             = CURRENT-WINDOW:HEIGHT-PIXELS
                                         - FRAME fHeader:HEIGHT-PIXELS
  FRAME fLabel:WIDTH-PIXELS              = CURRENT-WINDOW:WIDTH-PIXELS
  FRAME fLabel:VIRTUAL-HEIGHT-PIXELS     = 2000  /* arbitrarily large */
  FRAME fLabel:VIRTUAL-WIDTH-PIXELS      = 2000

  lbl-text:SCREEN-VALUE IN FRAME fLabel  = lbl-text
  lbl-text:READ-ONLY IN FRAME fLabel     = TRUE
  lbl-text:INNER-LINES IN FRAME fLabel   = qbf-label-ht
  lbl-text:INNER-CHARS IN FRAME fLabel   = qbf-label-wd
  lbl-text:COLUMN IN FRAME fLabel        = qbf-origin-hz + 1
.
IF lGlbToolbar THEN
  FRAME fLabel:HEIGHT-PIXELS             = FRAME fLabel:HEIGHT-PIXELS
                                         - FRAME fToolbar:HEIGHT-PIXELS.
IF lGlbStatus THEN
  FRAME fLabel:HEIGHT-PIXELS             = FRAME fLabel:HEIGHT-PIXELS
                                         - wGlbStatus:HEIGHT-PIXELS.

FRAME fLabel:Y                           = FRAME fHeader:Y 
                                         + FRAME fHeader:HEIGHT-PIXELS.

/* On Motif, if you shrink VIRTUAL-WIDTH, WIDTH shrinks too!  So have
   to save WIDTH, set VIRTUAL-WIDTH and then reset the WIDTH.
*/
ASSIGN
  save_dim                             = FRAME fLabel:WIDTH-PIXELS
  FRAME fLabel:VIRTUAL-WIDTH-PIXELS    = lbl-text:X IN FRAME fLabel
					 + lbl-text:WIDTH-PIXELS IN FRAME fLabel
					 + FRAME fLabel:BORDER-LEFT-PIXELS
					 + FRAME fLabel:BORDER-RIGHT-PIXELS
  FRAME fLabel:WIDTH-PIXELS            = save_dim
  save_dim                             = FRAME fLabel:HEIGHT-PIXELS
  FRAME fLabel:VIRTUAL-HEIGHT-PIXELS   = lbl-text:HEIGHT-PIXELS IN FRAME fLabel
					 + FRAME fLabel:BORDER-TOP-PIXELS
					 + FRAME fLabel:BORDER-BOTTOM-PIXELS
  FRAME fLabel:HEIGHT-PIXELS           = save_dim
  lbl-text:COLUMN IN FRAME fLabel      = qbf-origin-hz + 1.

/* _ldraw.p - end-of-file */

