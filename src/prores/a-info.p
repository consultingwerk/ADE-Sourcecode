/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-info.p - get info on user directory */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/i-define.i }
{ prores/t-set.i &mod=i &set=0 }

DEFINE VARIABLE qbf-h AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER           NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER         NO-UNDO.

/*
export lo/hi in cache: (mode "d")
  DEFINE {1} SHARED VARIABLE qbf-d-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-d-hi AS INTEGER NO-UNDO.

graph lo/hi in cache: (mode "g")
  DEFINE {1} SHARED VARIABLE qbf-g-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-g-hi AS INTEGER NO-UNDO.

label lo/hi in cache: (mode "l")
  DEFINE {1} SHARED VARIABLE qbf-l-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-l-hi AS INTEGER NO-UNDO.

query lo/hi in cache: (mode "q")
  DEFINE {1} SHARED VARIABLE qbf-q-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-q-hi AS INTEGER NO-UNDO.

report lo/hi in cache: (mode "r")
  DEFINE {1} SHARED VARIABLE qbf-r-lo AS INTEGER NO-UNDO.
  DEFINE {1} SHARED VARIABLE qbf-r-hi AS INTEGER NO-UNDO.
*/

FORM
  /*"This program displays the contents of a specific"    */
  /*"user's local directory file, showing which generated"*/
  /*"programs correspond to each defined report, query,"  */
  /*"label, and so forth."                                */
  /*"Enter the full path name of the user's ~".qd~" file:"*/
  qbf-lang[25] FORMAT "x(64)" SKIP
  qbf-lang[26] FORMAT "x(64)" SKIP
  qbf-lang[27] FORMAT "x(64)" SKIP
  qbf-lang[28] FORMAT "x(64)" SKIP(1)
  qbf-lang[29] FORMAT "x(64)" SKIP
  qbf-dir-nam FORMAT "x(64)"
    VALIDATE(qbf-dir-nam MATCHES "*~.qd" AND SEARCH(qbf-dir-nam) <> ?,
      qbf-lang[IF qbf-dir-nam MATCHES "*~.qd" THEN 30 ELSE 31])
  WITH FRAME qbf-getdir ROW 4 COLUMN 2 NO-LABELS ATTR-SPACE NO-BOX OVERLAY.
  /*30:'Cannot find indicated file.'  31:'You forgot the ".qd" extension.'*/

qbf-o = qbf-dir-nam.
DISPLAY qbf-lang[25 FOR 5] WITH FRAME qbf-getdir.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  UPDATE qbf-dir-nam WITH FRAME qbf-getdir.
  qbf-dir-ent# = 0. /* make sure we see message */
  RUN prores/i-read.p.

  OUTPUT TO VALUE(qbf-tempdir + ".d") NO-ECHO.
  EXPORT SEARCH(qbf-dir-nam).

  DO qbf-i = 1 TO 5:
    ASSIGN
      qbf-l = (IF qbf-i = 1 THEN qbf-d-lo
          ELSE IF qbf-i = 2 THEN qbf-g-lo
          ELSE IF qbf-i = 3 THEN qbf-l-lo
          ELSE IF qbf-i = 4 THEN qbf-q-lo
          ELSE                   qbf-r-lo)
      qbf-h = (IF qbf-i = 1 THEN qbf-d-hi
          ELSE IF qbf-i = 2 THEN qbf-g-hi
          ELSE IF qbf-i = 3 THEN qbf-l-hi
          ELSE IF qbf-i = 4 THEN qbf-q-hi
          ELSE                   qbf-r-hi).
    IF qbf-l >= qbf-h THEN NEXT.

    EXPORT FILL("-",78).
    EXPORT ENTRY(qbf-i,qbf-lang[13]).
    /*"Data Export Formats,Graphs,Label Formats,Queries,Report Definitions"*/

    DO qbf-j = qbf-l + 1 TO qbf-h:
      EXPORT
        "  "
        + ENTRY(qbf-i,"exp,gfx,lbl,qry,rep")
        + STRING(qbf-j - qbf-l,"99999") + ".p -> "
        + qbf-dir-ent[qbf-j]
        + (IF qbf-dir-dbs[qbf-j] = "" THEN ""
          ELSE " (" + qbf-dir-dbs[qbf-j] + ")").
    END.
  END.
  OUTPUT CLOSE.

  HIDE FRAME qbf-getdir NO-PAUSE.
  RUN prores/s-page.p (qbf-tempdir + ".d",0,FALSE).
  ASSIGN
    qbf-dir-ent# = 0
    qbf-dir-ent  = "".
END.

qbf-dir-nam = qbf-o.
HIDE FRAME qbf-getdir NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
{ prores/t-reset.i }
RETURN.
