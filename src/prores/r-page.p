/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-page.p - break-group page-eject settings */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=r &set=5 }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.

FORM
  qbf-c        FORMAT "x(40)" SKIP /* <<don't page eject>> */
  qbf-order[1] FORMAT "x(40)" SKIP
  qbf-order[2] FORMAT "x(40)" SKIP
  qbf-order[3] FORMAT "x(40)" SKIP
  qbf-order[4] FORMAT "x(40)" SKIP
  qbf-order[5] FORMAT "x(40)" SKIP
  HEADER
  qbf-lang[28] FORMAT "x(40)" SKIP /* When a value in one of the following */
  qbf-lang[29] FORMAT "x(40)" SKIP /* fields changes, the report can       */
  qbf-lang[30] FORMAT "x(40)" SKIP /* automatically go on to a new page.   */
  qbf-lang[31] FORMAT "x(40)" SKIP /* Pick the field from the list below   */
  qbf-lang[32] FORMAT "x(40)" SKIP /* where you want this to occur.        */
  WITH FRAME qbf-pop ROW 4 CENTERED OVERLAY ATTR-SPACE NO-LABELS
  TITLE COLOR NORMAL " " + qbf-lang[26] + " ". /* Page Ejects */

PAUSE 0.

DISPLAY
  SUBSTRING(qbf-order[1],1,INDEX(qbf-order[1] + " "," ") - 1) @ qbf-order[1]
  SUBSTRING(qbf-order[2],1,INDEX(qbf-order[2] + " "," ") - 1) @ qbf-order[2]
  SUBSTRING(qbf-order[3],1,INDEX(qbf-order[3] + " "," ") - 1) @ qbf-order[3]
  SUBSTRING(qbf-order[4],1,INDEX(qbf-order[4] + " "," ") - 1) @ qbf-order[4]
  SUBSTRING(qbf-order[5],1,INDEX(qbf-order[5] + " "," ") - 1) @ qbf-order[5]
  "<<" + qbf-lang[27] + ">>" @ qbf-c /*"don't page eject"*/
  WITH FRAME qbf-pop.

ON CURSOR-DOWN TAB. ON CURSOR-UP BACK-TAB.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-pop:
  IF qbf-r-attr[9] > 0 THEN NEXT-PROMPT qbf-order[qbf-r-attr[9]].
  IF      qbf-order[1] = "" THEN CHOOSE FIELD qbf-c.
  ELSE IF qbf-order[2] = "" THEN CHOOSE FIELD qbf-c qbf-order[1].
  ELSE IF qbf-order[3] = "" THEN CHOOSE FIELD qbf-c qbf-order[1 FOR 2].
  ELSE IF qbf-order[4] = "" THEN CHOOSE FIELD qbf-c qbf-order[1 FOR 3].
  ELSE IF qbf-order[5] = "" THEN CHOOSE FIELD qbf-c qbf-order[1 FOR 4].
  ELSE                           CHOOSE FIELD qbf-c qbf-order[1 FOR 5].
  qbf-r-attr[9] = FRAME-INDEX.
END.
ON CURSOR-DOWN CURSOR-DOWN. ON CURSOR-UP CURSOR-UP.

{ prores/t-reset.i }
HIDE FRAME qbf-pop NO-PAUSE.
RETURN.
