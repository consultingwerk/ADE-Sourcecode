/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-browse.p - show compile failures */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-b AS LOGICAL NO-UNDO.
/* qbf-b = TRUE for *build* or FALSE for *rebuild* */

DEFINE VARIABLE qbf-c AS CHARACTER         NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER INITIAL 0 NO-UNDO.

{ prores/t-set.i &mod=b &set=1 }
RUN prores/s-error.p ("#32").
/*
Errors were found during the build and/or compile stages.
^^Press a key to see the query log file.  Lines
containing errors will be hilighted.
*/
{ prores/t-reset.i }

/*qbf-p = "phase= " + (IF qbf-b THEN "" ELSE "re") + "compile".*/

RUN prores/s-quoter.p
  (SEARCH(qbf-qcfile + ".ql"),qbf-tempdir + "1.d").

IF NOT qbf-b THEN DO:
  INPUT FROM VALUE(qbf-tempdir + "1.d") NO-ECHO.
  /* find [last] occurrence of phase= [re]compile */
  REPEAT:
    IMPORT qbf-c.
    IF qbf-c MATCHES "phase= *compile" THEN qbf-s = SEEK(INPUT).
  END.
  INPUT CLOSE.
END.

RUN prores/s-page.p (qbf-tempdir + "1.d",qbf-s,TRUE).

RETURN.
