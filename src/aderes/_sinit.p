/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _sinit.p - PROGRESS RESULTS initialization
*/

{ aderes/_fdefs.i }
{ aderes/a-define.i }
{ aderes/e-define.i }
{ aderes/fbdefine.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/s-define.i }
{ aderes/s-output.i }
{ aderes/s-system.i }
{ aderes/y-define.i }
{ adeshar/_mnudefs.i }

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-t  AS CHARACTER NO-UNDO. /* scrap */

/*--------------------------------------------------------------------------*/

IF qbf-u-hook[{&ahLogin}] <> ? THEN DO:
  /* The admin defined login doesn't have a RESULTS Core version. If the
  Admin doesn't provide a function then there will be no AP login */
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahLogin}],OUTPUT qbf-c).

  IF qbf-c = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("The Admin function, &1, was defined but not found for the Admin Login Hook.  &2 cannot run the login procedure.",
      qbf-u-hook[{&ahLogin}],qbf-product)).
  ELSE DO:
    loginHook:
    DO ON STOP UNDO loginHook, RETRY loginHook:
      IF RETRY THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
          SUBSTITUTE("There is a problem with &1.  &2 cannot run the login procedure.",
          qbf-c,qbf-product)).
        LEAVE loginHook.
      END.
      RUN VALUE(qbf-u-hook[{&ahLogin}]).  /* Run the login program */
    END.
  END.
END.
ELSE
  RUN aderes/_slogin.p.

/* Keep this ASSIGN after login integration procedure */
ASSIGN
  qbf-qdhome = LC(IF USERID("RESULTSDB":u) = "" THEN "results":u
               ELSE SUBSTRING(USERID("RESULTSDB":u),1,8,"FIXED":u)) + {&qdExt}
  qbf-c      = SEARCH(qbf-qdhome)
  qbf-qdhome = (IF qbf-c = ? THEN qbf-qdhome ELSE qbf-c)
  qbf-qdfile = qbf-qdhome
  qbf-qdpubl = "public{&qdUqExt}":u
  qbf-c      = SEARCH(qbf-qdpubl)
  qbf-qdpubl = (IF qbf-c = ? THEN qbf-qdpubl ELSE qbf-c).

/* For UNIX, should we use "." + pid + "qbf"? or "/tmp/qbf-" + pid?  Should 
   we do anything special for DOS, OS/2 or VMS?  No. but for V7, we put temp
   files in same dir as the directory file. */
CASE OPSYS:
  WHEN "BTOS":u THEN
    qbf-tempdir = "[Scr]<$>qbf":u.
  OTHERWISE DO:
    RUN aderes/s-prefix.p (qbf-qdhome,OUTPUT qbf-c).
    qbf-tempdir = qbf-c + "qbf":u.
  END.
END CASE.

/* blow away temp files that might cause trouble later (*.r) */
qbf-f = "".
DO qbf-i = 0 TO 9:
  ASSIGN
    qbf-c = qbf-tempdir + TRIM(STRING(qbf-i),">>>":u) + ".r":u
    qbf-t = SEARCH(qbf-c).
  IF qbf-t = qbf-c THEN
    qbf-f = qbf-f + ",":u + qbf-t.
END.
IF qbf-f <> "" THEN
  RUN aderes/a-zap.p (qbf-f).

qbf-c = ?.

IF SEARCH(qbf-qcfile + {&qcExt}) = ? THEN DO:
  /* _aread.p sets up the table list for itself. Do it for the boot case */
  RUN aderes/af-init.p.
  RUN aderes/j-init.p (qbf-c).
  RUN aderes/_aboot.p (OUTPUT qbf-a).

  IF NOT qbf-a THEN RETURN.
END.
ELSE DO:
  /* Normal configuration file read, including fastload, if any */
  RUN aderes/_aread.p (2,OUTPUT qbf-a).
  IF qbf-a THEN RETURN.
END.

/* Initialize more of the integration procedures.  This needs to follow the
call to _aboot.p. */
RUN aderes/_ainti.p.

RUN aderes/s-zap.p (FALSE). /* reset all values */

/*--------------------------------------------------------------------------*/
SESSION:THREE-D = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u
                    AND qbf-threed THEN TRUE ELSE FALSE.

ASSIGN
  qbf-month-names = TRIM('January')   + ',':u
                    + TRIM('February')  + ',':u
                    + TRIM('March')     + ',':u
                    + TRIM('April')     + ',':u
                    + TRIM('May')       + ',':u
                    + TRIM('June')      + ',':u
                    + TRIM('July')      + ',':u
                    + TRIM('August')    + ',':u
                    + TRIM('September') + ',':u
                    + TRIM('October')   + ',':u
                    + TRIM('November')  + ',':u
                    + TRIM('December')
  qbf-day-names   = TRIM('Sunday')    + ',':u
                    + TRIM('Monday')    + ',':u
                    + TRIM('Tuesday')   + ',':u
                    + TRIM('Wednesday') + ',':u
                    + TRIM('Thursday')  + ',':u
                    + TRIM('Friday')    + ',':u
                    + TRIM('Saturday')
  qbf-win:TITLE   = qbf-product.

/* Call main RESULTS procedure */
RUN aderes/y-menu.p.

/*---------------------- Close Things Down --------------------------------*/

qbf-f = "".
DO qbf-i = 1 TO 9:
  ASSIGN
    qbf-c = qbf-tempdir + STRING(qbf-i) + ".p":u
    qbf-t = SEARCH(qbf-c)
    qbf-f = qbf-f + (IF qbf-t = qbf-c OR qbf-t = "./":u + qbf-c
                     THEN ",":u + qbf-t ELSE "").
END.

IF qbf-f <> "" THEN
  RUN aderes/a-zap.p (qbf-f).

/* blow away scratch files */
ASSIGN
  qbf-c = SEARCH(qbf-tempdir + ".d":u)
  qbf-f = SEARCH(qbf-tempdir + ".p":u)
  qbf-f = (IF qbf-f = ?              THEN "" ELSE qbf-f)
        + (IF qbf-f = ? OR qbf-c = ? THEN "" ELSE ",":u)
        + (IF              qbf-c = ? THEN "" ELSE qbf-c).

IF qbf-f <> "" THEN
  RUN aderes/a-zap.p (qbf-f).

/* blow away local aliases */
DO qbf-i = NUM-ALIASES TO 1 BY -1:
  IF ALIAS(qbf-i) BEGINS "QBF$":u THEN
    DELETE ALIAS VALUE(ALIAS(qbf-i)).
END.

RETURN.

/* _sinit.p - end of file */

