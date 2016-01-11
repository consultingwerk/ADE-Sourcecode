/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-where.p - called by d-main.p l-main.p and r-main.p */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 6 NO-UNDO.

{ prores/s-top.i } /* frame definition */

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-top:
  IF      qbf-file[2] = "" THEN .
  ELSE IF qbf-file[3] = "" THEN CHOOSE FIELD qbf-file[1 FOR 2].
  ELSE IF qbf-file[4] = "" THEN CHOOSE FIELD qbf-file[1 FOR 3].
  ELSE IF qbf-file[5] = "" THEN CHOOSE FIELD qbf-file[1 FOR 4].
  ELSE                          CHOOSE FIELD qbf-file[1 FOR 5].
  qbf-i = (IF qbf-file[2] = "" THEN 1 ELSE FRAME-INDEX).
  IF qbf-i > 0 THEN
    RUN prores/s-where.p (TRUE,qbf-db[qbf-i] + "." + qbf-file[qbf-i],
                          INPUT-OUTPUT qbf-where[qbf-i]).
END.
COLOR DISPLAY NORMAL qbf-file[1 FOR 5] WITH FRAME qbf-top.

RETURN.
