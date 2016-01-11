/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-load.p - do system initialization and read in .qc file */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/i-define.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/s-print.i }
{ prores/t-set.i &mod=a &set=3 }
{ prores/reswidg.i }
{ prores/resfunc.i }

/* Checkpoint detected flag.  Set to TRUE if checkpoint symbol found. */
DEFINE OUTPUT PARAMETER qbf-k AS LOGICAL NO-UNDO.

DEFINE SHARED VARIABLE microqbf AS LOGICAL NO-UNDO.

DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-d   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-e   AS INTEGER    NO-UNDO.
/* fastload 0=ok 1=schema change 2=version mismatch */
DEFINE VARIABLE qbf-f   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-h   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-m   AS CHARACTER  NO-UNDO EXTENT 11.
DEFINE VARIABLE qbf-q   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-v   AS CHARACTER  NO-UNDO.

DEFINE STREAM qbf-io.

/*message "[a-load.p]" view-as alert-box.*/

EMPTY TEMP-TABLE qbf-form.
EMPTY TEMP-TABLE qbf-join.

ASSIGN
  qbf-dtype      = "character,date,logical,integer,decimal,raw,rowid"
  qbf-product    = qbf-lang[22] /*"PROGRESS RESULTS"*/
  qbf-goodbye    = FALSE
  qbf-signon     = "prores/u-logo.p"
  qbf-user       = FALSE
  qbf-u-prog     = ""
  qbf-u-expo     = ""
  qbf-u-brow     = "prores/u-browse.i"
/* reset caches */
  qbf-join#      = 0
  qbf-form#      = 0
  qbf-printer#   = 0
/* misc */
  qbf-q-opts     = TRUE /* innocent until proven guilty */
  qbf-r-defs     = ""
  qbf-r-defs[25] = "1"
  qbf-r-defs[26] = "66"
  qbf-r-defs[27] = "1"
  qbf-r-defs[28] = "1"
  qbf-r-defs[29] = "1"
  qbf-r-defs[30] = "0"
  qbf-r-defs[31] = "0"
  qbf-r-defs[32] = "0"
/* tables */
  qbf-h          = "first-only=,,,last-only=,,,"
                 + "top-left=,,,top-center=,,,top-right=,,,"
                 + "bottom-left=,,,bottom-center=,,,bottom-right=,,,"
                 + "left-margin=,page-size=,column-spacing=,line-spacing=,"
                 + "top-margin=,before-body=,after-body="
  qbf-l          = "name=,addr1=,addr2=,addr3=,city=,"
                 + "state=,zip=,zip+4=,csz=,country="
  qbf-q          = "next,prev,first,last,add,update,copy,delete,view,browse,"
                 + "join,query,where,total,order,module,info,user,exit"
  qbf-c          = SEARCH(qbf-qcfile + ".qc").
{ prores/t-init.i } /* set system language texts */

IF qbf-c = ? THEN DO:
  { prores/t-reset.i }
  RETURN.
END.

STATUS DEFAULT qbf-lang[15]. /*"Reading configuration file..."*/

INPUT STREAM qbf-io FROM VALUE(qbf-c) NO-ECHO.

REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  IF INDEX(qbf-m[1],"=") = 0 OR qbf-m[1] BEGINS "#" THEN NEXT.
  IF qbf-m[1] = "message=" THEN DO:
    STATUS DEFAULT qbf-m[2].
    NEXT.
  END.

  qbf-i = (IF qbf-m[1] BEGINS "query-" THEN
          LOOKUP(SUBSTRING(qbf-m[1],7,LENGTH(qbf-m[1]) - 7),qbf-q) ELSE 0).
  IF qbf-i > 0 THEN 
    qbf-q-opts[qbf-i] = CAN-DO(qbf-m[2],USERID("RESULTSDB")).
  ELSE
  IF qbf-m[1] BEGINS "config" AND qbf-m[2] = "checkpoint" THEN DO:
    INPUT STREAM qbf-io CLOSE.
    qbf-k = TRUE.
    /* 25: "An automatic build was in progress and was interrupted.  "
         + "Continue with automatic build?".  */
    RUN prores/s-box.p (INPUT-OUTPUT qbf-k,?,?,"#25").
    IF qbf-k THEN DO:
      { prores/t-reset.i }
      STATUS DEFAULT.
      RETURN.
    END.
    microqbf = FALSE.
    QUIT.
  END.
  ELSE
  IF qbf-m[1] BEGINS "version" THEN DO:
    qbf-v = qbf-m[2].
    IF qbf-vers = qbf-v THEN NEXT.
    IF SUBSTRING(qbf-vers,1,3) <> SUBSTRING(qbf-v,1,3) THEN qbf-f = 2.
    ASSIGN
      qbf-c = qbf-lang[26]
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-vers
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{2~}"),3) = qbf-v.
    /*
    * WARNING - Version mismatch *^^Current version is <{1}>
    while .qc file is for version <{2}>.  There may be
    problems until Query forms are regenerated with
    "Application Rebuild".
    */
    RUN prores/s-error.p (qbf-c).
  END.
  ELSE
  IF qbf-m[1] BEGINS "language" THEN DO:
    qbf-langset = qbf-m[2].
    { prores/t-set.i &mod=a &set=3 }
    { prores/t-init.i }
  END.
  ELSE
  IF qbf-m[1] BEGINS "goodbye" THEN qbf-goodbye = qbf-m[2] BEGINS "q".
  ELSE
  IF qbf-m[1] BEGINS "product" THEN qbf-product = qbf-m[2].
  ELSE
  IF qbf-m[1] BEGINS "signon" THEN DO:
    IF qbf-m[2] = "a-logo.p"
      AND SEARCH("a-logo.p") = ?
      AND SEARCH("a-logo.r") = ? THEN qbf-m[2] = "prores/u-logo.p".
    qbf-signon = qbf-m[2].
    STATUS DEFAULT.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO,LEAVE:
      RUN VALUE(qbf-signon).
    END.
  END.
  ELSE
  IF qbf-m[1] BEGINS "database" OR qbf-m[1] BEGINS "checksum" THEN DO:
    IF qbf-m[1] BEGINS "checksum" THEN
      ASSIGN /* for compatibility with 1.1 results for V5 */
        qbf-m[4] = qbf-m[2]
        qbf-m[2] = LDBNAME("RESULTSDB")
        qbf-m[3] = "PROGRESS".
    IF LDBNAME(qbf-m[2]) = ? OR DBTYPE(qbf-m[2]) <> qbf-m[3] THEN
      ASSIGN
        qbf-d = (IF qbf-d = "" THEN "" ELSE ",") + qbf-m[2] + ":" + qbf-m[3]
        qbf-f = 1.
    ELSE
      RUN prores/s-lookup.p (qbf-m[2],"","","DB:CHECKSUM",OUTPUT qbf-c).
    IF DECIMAL(qbf-c) <> DECIMAL(qbf-m[4]) THEN qbf-f = 1.
  END.
  ELSE
  IF qbf-m[1] BEGINS "fastload" THEN DO:
    IF qbf-d <> "" THEN DO:
      /*
      * WARNING - Missing Databases *^^The following
      database(s) are needed but are not connected:
      */
      qbf-c = "".
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-d):
        ASSIGN
          qbf-c = qbf-c + '^> "' + ENTRY(qbf-i,qbf-d) + ')'
          SUBSTRING(qbf-c,INDEX(qbf-c,":"),1) = '" ('.
      END.
      RUN prores/s-error.p (qbf-lang[27] + qbf-c).
      QUIT.
    END.
    IF qbf-f = 0 AND qbf-v = qbf-vers THEN DO:
      SUBSTRING(qbf-m[2],LENGTH(qbf-m[2]) - 2,3) = "0.r".
      ASSIGN
        qbf-e    = TIME.
        qbf-m[2] = SEARCH(qbf-m[2]).
      IF qbf-m[2] = ? THEN NEXT.
      qbf-m[2] = SUBSTRING(qbf-m[2],1,LENGTH(qbf-m[2]) - 1).
      DO qbf-i = 0 TO 9:
        SUBSTRING(qbf-m[2],LENGTH(qbf-m[2]) - 1,1) = STRING(qbf-i).
        IF SEARCH(qbf-m[2] + "r") = qbf-m[2] + "r" THEN
          RUN VALUE(qbf-m[2] + "p") (FALSE).
        ELSE
          LEAVE.
      END.
      qbf-e = MAXIMUM(TIME - qbf-e,2).
      /*IF qbf-e > 0 THEN READKEY PAUSE qbf-e.*/
      LEAVE.
    END.
  END.
  ELSE
  IF qbf-m[1] BEGINS "module-" AND CAN-DO(qbf-m[2],USERID("RESULTSDB")) THEN
    qbf-secure = qbf-secure + SUBSTRING(qbf-m[1],8,1).
  ELSE
  IF CAN-DO("form*,view*",qbf-m[1]) AND CAN-DO(qbf-m[4],USERID("RESULTSDB"))
    THEN DO:
    /*  format: "db.filename,progname,####" */
    IF INDEX(qbf-m[3],".") = 0 THEN
      qbf-m[3] = LDBNAME("RESULTSDB") + "." + qbf-m[3].
    RUN prores/s-lookup.p (qbf-m[3],"","","FILE:CAN-READ",OUTPUT qbf-c).
    IF qbf-c <> "!*" AND CAN-DO(qbf-c,USERID("RESULTSDB")) THEN DO:
      RUN prores/s-lookup.p (qbf-m[3],"","","FILE:DESC",OUTPUT qbf-c).
      ASSIGN
        qbf-i           = INDEX(qbf-m[3],".") + 1
        qbf-m[7]        = SUBSTRING(qbf-m[7],1,48)
        qbf-m[7]        = (IF  qbf-m[7] = SUBSTRING(qbf-m[3],qbf-i)
                            OR qbf-m[7] = SUBSTRING(qbf-c,1,48)
                           THEN "" ELSE qbf-m[7])
        qbf-m[2]        = (IF qbf-m[2] = SUBSTRING(qbf-m[3],qbf-i,8)
                           THEN "" ELSE qbf-m[2])
        qbf-form#       = qbf-form# + 1
        lReturn         = getRecord("qbf-form":U, qbf-form#)
        qbf-form.cValue = qbf-m[3] + "," + qbf-m[2] + ","
                          + STRING(qbf-form#,"9999")
        qbf-form.cDesc  = qbf-m[7].
    END.
  END.
  ELSE
  IF qbf-m[1] BEGINS "join" AND LENGTH(qbf-m[1]) > 5 THEN
    ASSIGN
      qbf-join#       = qbf-join# + 1
      lReturn         = getRecord("qbf-join":U, qbf-join#)
      qbf-join.cValue = qbf-m[2] + "," + qbf-m[3]
      qbf-join.cWhere = (IF qbf-m[4] BEGINS "OF" 
                         THEN "" ELSE SUBSTRING(qbf-m[4],7)).
  ELSE
  IF qbf-m[1] BEGINS "user-program" THEN DO:
    IF qbf-m[2] = "userprog.p"
      AND SEARCH("userprog.p") = ?
      AND SEARCH("userprog.r") = ? THEN qbf-m[2] = "prores/u-option.p".
    qbf-u-prog = qbf-m[2].
  END.
  ELSE
  IF qbf-m[1] BEGINS "user-export" THEN
    ASSIGN
      qbf-u-expo = qbf-m[2]
      qbf-u-enam = qbf-m[3].
  ELSE
  IF qbf-m[1] BEGINS "user-query" THEN
    qbf-u-brow = qbf-m[2].
  ELSE
  IF qbf-m[1] BEGINS "printer" AND LENGTH(qbf-m[1]) > 8
    AND (qbf-m[4] = "" OR CAN-DO(qbf-m[4],USERID("RESULTSDB"))) THEN
    ASSIGN
      qbf-printer#               = qbf-printer# + 1
      qbf-printer[qbf-printer#]  = qbf-m[2]
      qbf-pr-dev[qbf-printer#]   = (IF qbf-m[3] = "TERMINAL"
                                   AND qbf-m[5] = "term"
                                   THEN TERMINAL ELSE qbf-m[3])
      qbf-pr-type[qbf-printer#]  = qbf-m[5]
      qbf-pr-width[qbf-printer#] = INTEGER(qbf-m[6])
      qbf-pr-init[qbf-printer#]  = qbf-m[7]
      qbf-pr-norm[qbf-printer#]  = qbf-m[8]
      qbf-pr-comp[qbf-printer#]  = qbf-m[9]
      qbf-pr-bon[qbf-printer#]   = qbf-m[10]
      qbf-pr-boff[qbf-printer#]  = qbf-m[11].
  ELSE
  IF qbf-m[1] = "color-" + LC(TERMINAL) + "=" THEN
    ASSIGN
      qbf-mlo = qbf-m[2]  qbf-mhi = qbf-m[3]
      qbf-dlo = qbf-m[4]  qbf-dhi = qbf-m[5]
      qbf-plo = qbf-m[6]  qbf-phi = qbf-m[7].

  /* report stuff */
  ELSE IF CAN-DO(qbf-h,qbf-m[1]) THEN DO:
    ASSIGN
      qbf-i             = LOOKUP(qbf-m[1],qbf-h)
      qbf-r-defs[qbf-i] = qbf-m[2].
    IF qbf-i < 25 THEN
      ASSIGN
        qbf-r-defs[qbf-i + 1] = qbf-m[3]
        qbf-r-defs[qbf-i + 2] = qbf-m[4].
  END.
  /* label stuff */
  ELSE
  IF qbf-m[1] BEGINS "label-" AND CAN-DO(qbf-l,SUBSTRING(qbf-m[1],7)) THEN
    ASSIGN
      qbf-i             = LOOKUP(SUBSTRING(qbf-m[1],7),qbf-l)
      qbf-l-auto[qbf-i] = qbf-m[2].

END.
INPUT STREAM qbf-io CLOSE.

STATUS DEFAULT.

IF qbf-u-prog <> "" THEN DO:
  IF qbf-u-prog MATCHES "*~~.r" THEN
    SUBSTRING(qbf-u-prog,LENGTH(qbf-u-prog),1) = "p".
  qbf-c = qbf-u-prog.
  IF SEARCH(qbf-c) = ? AND qbf-c MATCHES "*~~.p" THEN
    SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
  ASSIGN
    qbf-user   = SEARCH(qbf-c) <> ?
    qbf-u-prog = (IF qbf-user THEN qbf-u-prog ELSE "").
END.
IF NOT qbf-user THEN qbf-q-opts[18] = FALSE.

IF qbf-u-expo <> "" THEN DO:
  IF qbf-u-expo MATCHES "*~~.r" THEN
    SUBSTRING(qbf-u-expo,LENGTH(qbf-u-expo),1) = "p".
  qbf-c = qbf-u-expo.
  IF SEARCH(qbf-c) = ? AND qbf-c MATCHES "*~~.p" THEN
    SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
  ASSIGN
    qbf-u-expo = (IF SEARCH(qbf-c) = ? THEN "" ELSE qbf-u-expo)
    qbf-u-enam = (IF qbf-u-expo   = "" THEN "" ELSE qbf-u-enam).
END.

/*
#32:
* WARNING - Schema changed *^^The database structure has been changed
since some query forms have been built.  Please use "Rebuild
Application" from the Administration menu as soon as possible.
*/
IF qbf-f = 1 THEN 
  RUN prores/s-error.p ("#32").

IF SUBSTRING(qbf-v,1,3) <> SUBSTRING(qbf-vers,1,3) THEN
  RUN prores/a-update.p (TRUE).

ASSIGN
  microqbf    = TRUE
  qbf-dir-nam = LC(IF USERID("RESULTSDB") = "" THEN "results"
                ELSE SUBSTRING(USERID("RESULTSDB"),1,8)) + ".qd"
  qbf-c       = SEARCH(qbf-dir-nam)
  qbf-dir-nam = (IF qbf-c = ? THEN qbf-dir-nam ELSE qbf-c).

{ prores/t-reset.i }
RETURN.

/*
if qbf-t# > 0 then do:
  load dir
  for each entry in dir:
    load entry
    check files
    if missing file, wipe out
    check fields
    if missing field, wipe out
    check order-by
    if missing field, wipe out
    check where-clause
    if missing field, wipe out
    zap
  end.
  write dir
end.
*/
