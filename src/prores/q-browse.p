/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-browse.p - generate browse program for query */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

{ prores/q-define.i }
{ prores/s-menu.i }

DEFINE INPUT        PARAMETER qbf-a AS LOGICAL   NO-UNDO. /* pick flag */
DEFINE INPUT-OUTPUT PARAMETER qbf-b AS CHARACTER NO-UNDO. /* field list */

DEFINE VARIABLE qbf-c AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-d AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-h AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 4 NO-UNDO.
DEFINE VARIABLE qbf-q AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-u AS CHARACTER          NO-UNDO.

{ prores/s-alias.i
  &prog=prores/q-browse.p
  &dbname=qbf-db[qbf-level]
  &params="(qbf-a,INPUT-OUTPUT qbf-b)"
}

ASSIGN
  qbf-f = qbf-file[qbf-level]
  qbf-s = qbf-b
  qbf-i = INDEX(qbf-s," ").
DO WHILE qbf-i > 0:
  ASSIGN
    SUBSTRING(qbf-s,qbf-i,1) = ","
    qbf-i = INDEX(qbf-s," ").
END.

IF qbf-a THEN DO:
  ASSIGN
    qbf-q      = ""
    qbf-h      = qbf-module
    qbf-module = "q10c".
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
    qbf-q = qbf-q + (IF qbf-i = 1 THEN "" ELSE ",")
          + qbf-db[qbf-level] + "." + qbf-file[qbf-level] + "."
          + ENTRY(qbf-i,qbf-s).
  END.
  RUN prores/c-field.p
    ("*" + qbf-db[qbf-level] + "." + qbf-file[qbf-level],"",INPUT-OUTPUT qbf-q).
  qbf-module = qbf-h.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN RETURN.
  /* check field sizes and eliminate anything over one line */
  /* f-browse.p also strips off "dbname." and "filename." from field names */
  RUN prores/f-browse.p
    (qbf-db[qbf-level],qbf-f,qbf-q,OUTPUT qbf-q).
  IF qbf-q = "" THEN qbf-q = qbf-s.
  ASSIGN
    qbf-b = ""
    qbf-s = "".
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-q):
    ASSIGN
      qbf-b = qbf-b + (IF qbf-i = 1 THEN "" ELSE " ") + ENTRY(qbf-i,qbf-q)
      qbf-s = qbf-s + (IF qbf-i = 1 THEN "" ELSE ",") + ENTRY(qbf-i,qbf-q).
  END.
END.

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-f AND
   (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-f NO-LOCK.

ASSIGN
  qbf-d = 0
  qbf-q = "".
DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
  FIND QBF$0._Field OF QBF$0._File
    WHERE QBF$0._Field._Field-name = ENTRY(qbf-i,qbf-s) NO-LOCK.
  ASSIGN
    qbf-u = (IF QBF$0._Field._Col-label <> ? THEN QBF$0._Field._Col-label
            ELSE IF QBF$0._Field._Label <> ? THEN QBF$0._Field._Label
            ELSE QBF$0._Field._Field-name)
    qbf-q = qbf-q + (IF qbf-i = 1 THEN "" ELSE " ")
          /*+ qbf-db[qbf-level] + "."*/
          + qbf-file[qbf-level] + "." + ENTRY(qbf-i,qbf-s).
  RUN prores/r-label.p
    (qbf-u,QBF$0._Field._Format,QBF$0._Field._dtype,
    OUTPUT qbf-l,OUTPUT qbf-l).
  qbf-d = MAXIMUM(qbf-d,qbf-l).
END.

ASSIGN
  qbf-u    = (IF qbf-where[qbf-level] = "" THEN
               qbf-of[qbf-level]
             ELSE IF qbf-of[qbf-level] = "" THEN
               "WHERE " + qbf-where[qbf-level]
             ELSE IF qbf-of[qbf-level] BEGINS "OF" THEN
               qbf-of[qbf-level] + " WHERE " + qbf-where[qbf-level]
             ELSE
               qbf-of[qbf-level] + " AND " + qbf-where[qbf-level]
             )
           + (IF qbf-index[qbf-level] = "" THEN ""
             ELSE " USE-INDEX " + qbf-index[qbf-level])
  qbf-m[1] = ENTRY(1,qbf-lang[3])
  qbf-m[2] = ENTRY(2,qbf-lang[3])
  qbf-m[3] = ENTRY(3,qbf-lang[3])
  qbf-l    = { prores/s-max3.i LENGTH(qbf-m[1]) LENGTH(qbf-m[2]) LENGTH(qbf-m[3]) }
             /* "All Shown","At Top","At Bottom"," --- " */
  qbf-c    = TRUNCATE((qbf-l - LENGTH(qbf-m[1])) / 2,0)
  qbf-m[1] = STRING(FILL(" ",qbf-c) + qbf-m[1],"x(" + STRING(qbf-l) + ")")
  qbf-c    = TRUNCATE((qbf-l - LENGTH(qbf-m[2])) / 2,0)
  qbf-m[2] = STRING(FILL(" ",qbf-c) + qbf-m[2],"x(" + STRING(qbf-l) + ")")
  qbf-c    = TRUNCATE((qbf-l - LENGTH(qbf-m[3])) / 2,0)
  qbf-m[3] = STRING(FILL(" ",qbf-c) + qbf-m[3],"x(" + STRING(qbf-l) + ")")
  qbf-m[4] = FILL("-",qbf-l).

IF qbf-level > 1 THEN DO:
  qbf-i = INDEX(qbf-u,qbf-db[qbf-level - 1] + "." + qbf-file[qbf-level - 1]).
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-u,qbf-i,LENGTH(qbf-db[qbf-level - 1]) + 1) = "".
      qbf-i = INDEX(qbf-u,qbf-db[qbf-level - 1]
              + "." + qbf-file[qbf-level - 1]).
  END.
END.

RUN prores/s-quote.p (ENTRY(10,qbf-m-tbl),?,OUTPUT qbf-s).

OUTPUT TO VALUE(qbf-tempdir + STRING(qbf-level + 1) + ".p") NO-ECHO NO-MAP.

PUT UNFORMATTED
  '~{ ' (IF SEARCH(qbf-u-brow) = ? THEN 'prores/u-browse.i' ELSE qbf-u-brow) SKIP
  '  &buff=   "' qbf-f        '"' SKIP
  '  &fields= "' qbf-q        '"' SKIP.
IF qbf-u <> "" THEN DO:
  PUT CONTROL '  &where=  '.
  EXPORT qbf-u.
END.
IF qbf-level > 1 THEN PUT UNFORMATTED
  '  &join=   "DEFINE SHARED BUFFER '
    qbf-file[qbf-level - 1] ' FOR '
    qbf-db[qbf-level - 1] '.' qbf-file[qbf-level - 1] '."' SKIP.
PUT UNFORMATTED
  '  &file=   "' qbf-db[qbf-level] '.' qbf-file[qbf-level] '"' SKIP
  '  &colorlo="' qbf-plo      '"' SKIP
  '  &colorhi="' qbf-phi      '"' SKIP
  '  &msgall= "' qbf-m[1]     '"' SKIP
  '  &msgtop= "' qbf-m[2]     '"' SKIP
  '  &msgbot= "' qbf-m[3]     '"' SKIP
  '  &msgnon= "' qbf-m[4]     '"' SKIP
  '  &msglin= "' qbf-lang[22] '"' SKIP
  '  &msgtit= "' qbf-s        '"' SKIP
  '  &putcol=  ' TRUNCATE(40 - qbf-l / 2,0) SKIP
  '  &down=    ' SCREEN-LINES - 6 - qbf-d   SKIP
  '~}' SKIP.

OUTPUT CLOSE.
COMPILE VALUE(qbf-tempdir + STRING(qbf-level + 1) + ".p") ATTR-SPACE.

RETURN.
