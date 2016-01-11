/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* i-dir.p - user directory manager */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/i-define.i }
{ prores/t-set.i &mod=i &set=0 }

DEFINE INPUT PARAMETER qbf-m AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER qbf-f AS LOGICAL   NO-UNDO.  /* true=get,false=put */

DEFINE VARIABLE qbf-a AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-g AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-k AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-l AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER          NO-UNDO.

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
  qbf-name FORMAT "x(48)"
    VALIDATE(qbf-name <> "" AND qbf-name <> ?,"")
  HEADER
  qbf-lang[2] + " " + qbf-k FORMAT "x(48)" /*"Enter description of"*/
  WITH FRAME qbf-nframe ROW 5 CENTERED NO-LABELS ATTR-SPACE OVERLAY.

FORM
  /*"Enter the full path name of the user's ~".qd~" file:"*/
  qbf-lang[29] FORMAT "x(64)" SKIP
  qbf-dir-nam FORMAT "x(64)"
    VALIDATE(qbf-dir-nam MATCHES "*~.qd" AND SEARCH(qbf-dir-nam) <> ?,
      qbf-lang[IF qbf-dir-nam MATCHES "*~.qd" THEN 30 ELSE 31])
  WITH FRAME qbf-getdir ROW 5 CENTERED NO-LABELS ATTR-SPACE OVERLAY.
  /*30:'Cannot find indicated file.'  31:'You forgot the ".qd" extension.'*/


ASSIGN
  qbf-k = ENTRY(INDEX("dglqr",qbf-m),qbf-lang[11])
  qbf-o = qbf-dir-nam.

DO WHILE TRUE:
  IF qbf-dir-ent# = 0 THEN
    RUN prores/i-read.p.

  ASSIGN
    qbf-a = FALSE
    qbf-i = (    IF qbf-m = "d" THEN qbf-d-lo
            ELSE IF qbf-m = "g" THEN qbf-g-lo
            ELSE IF qbf-m = "l" THEN qbf-l-lo
            ELSE IF qbf-m = "q" THEN qbf-q-lo
            ELSE                     qbf-r-lo)
    qbf-j = (    IF qbf-m = "d" THEN qbf-d-hi
            ELSE IF qbf-m = "g" THEN qbf-g-hi
            ELSE IF qbf-m = "l" THEN qbf-l-hi
            ELSE IF qbf-m = "q" THEN qbf-q-hi
            ELSE                     qbf-r-hi).
  /*"export,graph,label,query,report"*/

  PAUSE 0.

/*
  IF qbf-f AND (SEARCH(qbf-dir-nam) = ? OR qbf-i = qbf-j) THEN DO:
    ASSIGN
      qbf-c = qbf-lang[]  /*"You have not yet saved any {1} entries."*/
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-k.
    MESSAGE qbf-c.
    qbf-c = ?.
    LEAVE.
  END.
*/
  IF NOT qbf-f AND qbf-dir-ent# = { prores/s-limdir.i } THEN DO:
    /*"You have saved too many entries.  Please delete some!"*/
    /*"Deleting from any module directory will free up space."*/
    RUN prores/s-error.p ("#5").
    qbf-c = ?.
    LEAVE.
  END.

  ASSIGN
    qbf-c      = qbf-name
    qbf-s      = qbf-module
    qbf-module = qbf-m + STRING(qbf-f,"1/2") + "l".
  RUN prores/i-pick.p
    (qbf-m,qbf-f,INPUT-OUTPUT qbf-c,OUTPUT qbf-r).
  qbf-module = qbf-s.
  IF NOT qbf-f OR qbf-r > 0 OR qbf-c = ? THEN LEAVE.

  /* switch to a different directory and "grab" */
  DISPLAY qbf-lang[29] qbf-dir-nam WITH FRAME qbf-getdir.
  qbf-c = ?.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SET qbf-dir-nam WITH FRAME qbf-getdir.
  END.
  HIDE FRAME qbf-getdir NO-PAUSE.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.
  qbf-dir-ent# = 0.

END.

IF qbf-c = ? THEN .
ELSE
IF qbf-f THEN DO: /*------------------------------------------ start of GET */
  qbf-dir-vrs = "".
  IF qbf-m = "d" THEN
    RUN prores/d-read.p ("exp" + STRING(qbf-r,"99999")).
  /*ELSE IF qbf-m = "g" THEN
    RUN prores/g-read.p ("gfx" + STRING(qbf-r,"99999")).*/
  IF qbf-m = "l" THEN
    RUN prores/l-read.p ("lbl" + STRING(qbf-r,"99999")).
  /*ELSE IF qbf-m = "q" THEN
    RUN prores/q-read.p ("qry" + STRING(qbf-r,"99999")).*/
  IF qbf-m = "r" THEN
    RUN prores/r-read.p ("rep" + STRING(qbf-r,"99999")).
  qbf-name = qbf-c.

  /* update code */
  IF SUBSTRING(qbf-dir-vrs,1,3) <> SUBSTRING(qbf-vers,1,3) THEN
    RUN prores/a-update.p (FALSE).
  /* check can-read permissions */
  RUN prores/i-verify.p.
  /* clean up from i-verify.p */
  RUN prores/r-file.p (?).
END. /*--------------------------------------------------------- end of GET */
ELSE _qbf-upd: DO: /*----------------------------------------- start of PUT */
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    UPDATE qbf-name WITH FRAME qbf-nframe.
    DO qbf-g = qbf-i TO qbf-j:
      IF qbf-r + qbf-i = qbf-g OR qbf-dir-ent[qbf-g] <> qbf-name THEN NEXT.
      ASSIGN
        qbf-c = qbf-lang[4]
        SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-k.
      MESSAGE qbf-c. /*Each {1} should have a unique name.  Please try again.*/
      UNDO,RETRY.
    END.
  END.
  HIDE FRAME qbf-nframe NO-PAUSE.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _qbf-upd.
  /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  IF qbf-r = 0 THEN DO:
    /* create new directory entry */
    IF      qbf-m = "d" THEN qbf-r = qbf-d-hi + 1.
    ELSE IF qbf-m = "g" THEN qbf-r = qbf-g-hi + 1.
    ELSE IF qbf-m = "l" THEN qbf-r = qbf-l-hi + 1.
    ELSE IF qbf-m = "q" THEN qbf-r = qbf-q-hi + 1.
    ELSE IF qbf-m = "r" THEN qbf-r = qbf-r-hi + 1.
    qbf-dir-ent# = qbf-dir-ent# + 1.
    DO qbf-i = qbf-dir-ent# TO qbf-r + 1 BY -1:
      ASSIGN
        qbf-dir-ent[qbf-i] = qbf-dir-ent[qbf-i - 1]
        qbf-dir-dbs[qbf-i] = qbf-dir-dbs[qbf-i - 1]
        qbf-dir-flg[qbf-i] = qbf-dir-flg[qbf-i - 1].
    END.
    IF qbf-m = "d" THEN
      ASSIGN qbf-d-hi = qbf-d-hi + 1 qbf-g-lo = qbf-g-lo + 1.
    IF INDEX("dg",qbf-m) > 0 THEN
      ASSIGN qbf-g-hi = qbf-g-hi + 1 qbf-l-lo = qbf-l-lo + 1.
    IF INDEX("dgl",qbf-m) > 0 THEN
      ASSIGN qbf-l-hi = qbf-l-hi + 1 qbf-q-lo = qbf-q-lo + 1.
    IF INDEX("dglq",qbf-m) > 0 THEN
      ASSIGN qbf-q-hi = qbf-q-hi + 1 qbf-r-lo = qbf-r-lo + 1.
    qbf-r-hi = qbf-r-hi + 1.
  END.
  ELSE DO:
    /* overwrite existing directory entry */
    IF qbf-m = "d" THEN qbf-r = qbf-r + qbf-d-lo.
    IF qbf-m = "g" THEN qbf-r = qbf-r + qbf-g-lo.
    IF qbf-m = "l" THEN qbf-r = qbf-r + qbf-l-lo.
    IF qbf-m = "q" THEN qbf-r = qbf-r + qbf-q-lo.
    IF qbf-m = "r" THEN qbf-r = qbf-r + qbf-r-lo.
    qbf-a = FALSE.
    /*7:"Are you sure that you want to overwrite"  8:"with"*/
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,
      qbf-lang[7] + ' ' + qbf-k + ' "' + qbf-dir-ent[qbf-r]
      + (IF qbf-dir-ent[qbf-r] = qbf-name THEN ''
        ELSE '" ' + qbf-lang[8] + ' ' + qbf-k + ' "' + qbf-name)
      + '"?').
    IF NOT qbf-a THEN RETURN.
  END.

  /* record ldbnames */
  IF qbf-name <> ? THEN qbf-dir-ent[qbf-r] = qbf-name.
  qbf-c = "".
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
    qbf-c = qbf-c + (IF qbf-i = 1 THEN "" ELSE ",") + qbf-db[qbf-i].
  END.
  IF qbf-c <> "" THEN
    RUN prores/s-vector.p (TRUE,INPUT-OUTPUT qbf-c).
  ASSIGN
    qbf-dir-dbs[qbf-r] = qbf-c
    qbf-dir-flg[qbf-r] = TRUE.

  /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  /* write the updated directory out */
  IF SEARCH(qbf-dir-nam) = ? THEN
    OUTPUT TO VALUE(qbf-dir-nam) NO-ECHO.
  ELSE
    OUTPUT TO VALUE(SEARCH(qbf-dir-nam)) NO-ECHO.
  PUT UNFORMATTED
    '/*' SKIP
    'config= directory'  SKIP
    'version= ' qbf-vers SKIP.

  DO qbf-i = 1 TO qbf-dir-ent#:
    IF   qbf-i = qbf-d-lo OR qbf-i = qbf-g-lo OR qbf-i = qbf-l-lo
      OR qbf-i = qbf-q-lo OR qbf-i = qbf-r-lo THEN NEXT.
    PUT CONTROL
      (IF     qbf-i <= qbf-d-hi THEN 'export' + STRING(qbf-i - qbf-d-lo)
      ELSE IF qbf-i <= qbf-g-hi THEN 'graph'  + STRING(qbf-i - qbf-g-lo)
      ELSE IF qbf-i <= qbf-l-hi THEN 'label'  + STRING(qbf-i - qbf-l-lo)
      ELSE IF qbf-i <= qbf-q-hi THEN 'query'  + STRING(qbf-i - qbf-q-lo)
      ELSE                           'report' + STRING(qbf-i - qbf-r-lo)
      ) '= '.
    EXPORT qbf-dir-ent[qbf-i] qbf-dir-dbs[qbf-i].
  END.

  PUT UNFORMATTED '*/' SKIP.
  OUTPUT CLOSE.

  IF qbf-m = "d" THEN qbf-r = qbf-r - qbf-d-lo.
  IF qbf-m = "g" THEN qbf-r = qbf-r - qbf-g-lo.
  IF qbf-m = "l" THEN qbf-r = qbf-r - qbf-l-lo.
  IF qbf-m = "q" THEN qbf-r = qbf-r - qbf-q-lo.
  IF qbf-m = "r" THEN qbf-r = qbf-r - qbf-r-lo.
  /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  /* before writing stuff out, save qbf-asked (which is in display
  format), update asked variables in some nice fashion for the
  generated code, and, when done, reset things as we found them. */
  ASSIGN
    qbf-l[1] = qbf-asked[1]
    qbf-l[2] = qbf-asked[2]
    qbf-l[3] = qbf-asked[3]
    qbf-l[4] = qbf-asked[4]
    qbf-l[5] = qbf-asked[5]
    qbf-a    = ?.
  RUN prores/s-ask.p (INPUT-OUTPUT qbf-a).
  IF      qbf-m = "d" THEN 
    RUN prores/d-write.p ("exp" + STRING(qbf-r,"99999")).
  ELSE IF qbf-m = "g" THEN 
    RUN prores/g-write.p ("gfx" + STRING(qbf-r,"99999")).
  ELSE IF qbf-m = "l" THEN 
    RUN prores/l-write.p ("lbl" + STRING(qbf-r,"99999")).
  ELSE IF qbf-m = "q" THEN 
    RUN prores/q-write.p ("qry" + STRING(qbf-r,"99999")).
  ELSE IF qbf-m = "r" THEN
    RUN prores/r-write.p ("rep" + STRING(qbf-r,"99999")).
  ASSIGN
    qbf-asked[1] = qbf-l[1]
    qbf-asked[2] = qbf-l[2]
    qbf-asked[3] = qbf-l[3]
    qbf-asked[4] = qbf-l[4]
    qbf-asked[5] = qbf-l[5].
  HIDE MESSAGE NO-PAUSE.
END. /*--------------------------------------------------------- end of PUT */

{ prores/t-reset.i }
IF qbf-dir-nam <> qbf-o THEN
  ASSIGN
    qbf-dir-ent# = 0
    qbf-dir-nam  = qbf-o.
RETURN.
