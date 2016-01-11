/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* q-read.p - read in query file header */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/a-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 9 NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER          NO-UNDO.
DEFINE STREAM qbf-io.

/* point to correct _db record */
FIND QBF$0._Db WHERE QBF$0._Db._Db-name =
  (IF DBTYPE(qbf-db[1]) = "PROGRESS" THEN ? ELSE qbf-db[1]) NO-LOCK NO-ERROR.
/* Huh? Why check for available _File?  Shouldn't we be checking for _Db? */
IF AVAILABLE QBF$0._File THEN DO:
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
    FIND QBF$0._File OF QBF$0._Db 
      WHERE QBF$0._File._File-name = qbf-file[2] AND
        (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
      NO-LOCK.
  ELSE 
    FIND QBF$0._File OF QBF$0._Db
      WHERE QBF$0._File._File-name = qbf-file[2] NO-LOCK.
END.

RUN prores/s-zap.p.
ASSIGN
  qbf-rc# = 0
  qbf-c   = SEARCH(qbf-f + ".p")
  qbf-c   = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - LENGTH(qbf-f) - 2).

INPUT STREAM qbf-io FROM VALUE(qbf-c + qbf-f + ".p") NO-ECHO.
REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  IF qbf-m[1] BEGINS "#" THEN NEXT.
  IF qbf-m[1] = "*" + "/" THEN LEAVE.

  IF      qbf-m[1] BEGINS "name"       THEN qbf-name      = qbf-m[2].
  ELSE IF qbf-m[1] BEGINS "version"    THEN qbf-v         = qbf-m[2].
  ELSE IF qbf-m[1] BEGINS "form-file"  THEN qbf-a-attr[1] = qbf-m[2].
  ELSE IF qbf-m[1] BEGINS "form-name"  THEN qbf-a-attr[2] = qbf-m[2].
  ELSE IF qbf-m[1] BEGINS "form-type"  THEN qbf-a-attr[3] = qbf-m[2].
  ELSE IF qbf-m[1] BEGINS "form-lines" THEN qbf-a-attr[4] = qbf-m[2].
  ELSE IF qbf-m[1] MATCHES "file1="    THEN DO: /* not "file*=" for now */
    ASSIGN
      qbf-form-ok     = FALSE /* quilty until proven innocent */
      qbf-i           = INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1]) - 5))
      qbf-j           = INDEX(qbf-m[2],".")
      qbf-file[qbf-i] = SUBSTRING(qbf-m[2],qbf-j + 1)
      qbf-db[qbf-i]   = SUBSTRING(qbf-m[2],1,MAXIMUM(qbf-j - 1,0))
      qbf-db[qbf-i]   = (IF qbf-db[qbf-i] = "" THEN LDBNAME("RESULTSDB")
                         ELSE qbf-db[qbf-i]).
                         
    /* Setting qbf-file[1] and qbf-db[1] here is kind of inane, since we
       already _know_ this info when this program is called! */

    /* filter out sql92 tables and views */
    IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
      FIND FIRST QBF$0._File OF QBF$0._Db 
        WHERE QBF$0._File._File-name = qbf-file[qbf-i] AND
          (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
        NO-LOCK NO-ERROR.
    ELSE 
      FIND FIRST QBF$0._File OF QBF$0._Db
        WHERE QBF$0._File._File-name = qbf-file[qbf-i] NO-LOCK NO-ERROR.
    IF NOT AVAILABLE QBF$0._File THEN LEAVE.
    
    ASSIGN
      qbf-c           = QBF$0._File._Desc
      qbf-form-ok     = qbf-v = qbf-vers
                        AND QBF$0._File._Last-change = INTEGER(qbf-m[3]).

      /* We can't enable the _crc checks, because we can't tell if the 
         user is using the -crc startup option or not.   */
    IF qbf-name = "" OR qbf-name = ? THEN qbf-name =
      (IF qbf-c = ? OR qbf-c = "" THEN QBF$0._File._File-name ELSE qbf-c).
  END.
  ELSE IF qbf-m[1] MATCHES "field*=" THEN DO:
    qbf-c = SUBSTRING(qbf-m[2],1,INDEX(qbf-m[2] + "[","[") - 1).
    IF NOT AVAILABLE QBF$0._File
      OR QBF$0._File._File-name <> qbf-file[1] THEN DO:

      /* filter out sql92 tables and views */
      IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
        FIND FIRST QBF$0._File OF QBF$0._Db 
          WHERE QBF$0._File._File-name = qbf-file[1] AND
            (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
          NO-LOCK NO-ERROR.
      ELSE 
        FIND FIRST QBF$0._File OF QBF$0._Db
          WHERE QBF$0._File._File-name = qbf-file[1] NO-LOCK.
    END.
    FIND QBF$0._Field OF QBF$0._File
      WHERE QBF$0._Field._Field-name = qbf-c NO-LOCK NO-ERROR.
    IF AVAILABLE QBF$0._Field THEN
      ASSIGN
        qbf-rc#          = qbf-rc# + 1
        qbf-rcn[qbf-rc#] = qbf-m[2] /* name */
        qbf-rct[qbf-rc#] = LOOKUP(qbf-m[3],qbf-dtype)
        qbf-rcw[qbf-rc#] = INTEGER(qbf-m[4]) /* order */
        qbf-rca[qbf-rc#] = STRING(qbf-m[5] BEGINS "y","y/n") /* display */
                         + STRING(qbf-m[6] BEGINS "y","y/n")  /* update */
                         + STRING(qbf-m[7] BEGINS "y","y/n")   /* query */
                         + STRING(qbf-m[8] BEGINS "y","y/n")  /* browse */
                         + STRING(QBF$0._Field._Extent > 0,"y/n").  /* array */
  END.
  /* for now, ignore: include= */
END.
INPUT STREAM qbf-io CLOSE.

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND FIRST QBF$0._File OF QBF$0._Db 
    WHERE QBF$0._File._File-name = qbf-file[1] AND
      (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK NO-ERROR.
ELSE 
  FIND FIRST QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-file[1] NO-LOCK NO-ERROR.
qbf-rc# = 0.
IF AVAILABLE QBF$0._File THEN
  FOR EACH QBF$0._Field OF QBF$0._File:
    qbf-rc# = MAXIMUM(qbf-rc#,QBF$0._Field._field-rpos).
  END.

RETURN.
