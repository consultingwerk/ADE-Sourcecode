/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * s-schema.p - extract schema information (see also a-schema.p)
 */

/*
Keep this program small.  Move any big and clumsy information
extractions into a-schema.p.
*/

{ aderes/j-define.i }
{ aderes/s-system.i }

DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT  PARAMETER qbf-n AS CHARACTER NO-UNDO. /* fieldname/indexname */
DEFINE INPUT  PARAMETER qbf-t AS CHARACTER NO-UNDO. /* information type */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* response */

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-h AS DECIMAL   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.

/* ldbname,filename,fieldname can come in qbf-d+qbf-f+qbf-n, */
/* or as combined entries in qbf-d or qbf-d+qbf-f */
ASSIGN
  qbf-o = qbf-d
        + (IF qbf-f = "" THEN "" ELSE ".":u + qbf-f)
        + (IF qbf-n = "" THEN "" ELSE ".":u + qbf-n)
  qbf-o = SUBSTRING(qbf-o,1,INDEX(qbf-o + "[":u,"[":u) - 1,"CHARACTER":u)
          /*strip off subscript*/
  qbf-d = SUBSTRING(qbf-o,1,INDEX(qbf-o + ".":u,".":u) - 1,"CHARACTER":u)
  qbf-o = SUBSTRING(qbf-o,INDEX(qbf-o,".":u) + 1,-1,"CHARACTER":u)
  qbf-f = SUBSTRING(qbf-o,1,INDEX(qbf-o + ".":u,".":u) - 1,"CHARACTER":u)
  qbf-n = SUBSTRING(qbf-o,INDEX(qbf-o,".":u) + 1,-1,"CHARACTER":u)
  qbf-o = ?.

IF LDBNAME(qbf-d) = ? THEN RETURN.

/* if not pointing to correct db, fix situation and call self */
/* recursively.  this will also leave things set for the next */
/* time this guy is called. */
IF LDBNAME("QBF$0":u) <> SDBNAME(qbf-d) THEN DO:
  CREATE ALIAS "QBF$0":u FOR DATABASE VALUE(SDBNAME(qbf-d)).
  RUN "aderes/s-schema.p" (qbf-d,qbf-f,qbf-n,qbf-t,OUTPUT qbf-o).
  RETURN.
END.

/* now point to correct _db record */
FIND QBF$0._Db
  WHERE QBF$0._Db._Db-name =
    (IF DBTYPE(qbf-d) = "PROGRESS":u THEN ? ELSE LDBNAME(qbf-d))
  NO-LOCK.

/* do relevant index cursor positions */
IF CAN-DO("FILE:*,FIELD:*,INDEX:*":u,qbf-t) AND AVAILABLE QBF$0._Db THEN DO:

    /* filter out sql92 views and tables */
    IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN DO:
        FIND QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = qbf-f 
            AND (QBF$0._File._Owner = "PUB":u OR QBF$0._File._Owner = "_FOREIGN":u)
                NO-LOCK NO-ERROR.
    END.
    ELSE FIND QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = qbf-f NO-LOCK NO-ERROR.


END.

IF CAN-DO("FIELD:*":u,qbf-t) AND AVAILABLE QBF$0._File THEN
  FIND QBF$0._Field OF QBF$0._File
    WHERE QBF$0._Field._Field-name = qbf-n NO-LOCK NO-ERROR.
IF CAN-DO("INDEX:*":u,qbf-t) AND AVAILABLE QBF$0._File THEN
  FIND QBF$0._Index OF QBF$0._File
    WHERE QBF$0._Index._Index-name = qbf-n NO-LOCK.

/*--------------------------------------------------------------------------*/
IF qbf-t BEGINS "DB:":u THEN DO:
  CASE SUBSTRING(qbf-t,4,-1,"CHARACTER":u):
    WHEN "ROWID":u THEN
      qbf-o = STRING(RECID(QBF$0._Db)).
    WHEN "CRC":u THEN DO:

      /* If we need to make the user aware that RESULTS wants a "rebuild" 
       * then return a CRC of 1. An example is when a table alias is deleted 
       * or modified. Those changes could affect what's out there. In effect, 
       * this example should be considered a schema change.
       */
      qbf-h = 0.

      IF _flagRebuild THEN DO:
        qbf-o = string(1).
        RETURN.
      END.

      FOR EACH QBF$0._File OF QBF$0._Db NO-LOCK 
        WHERE QBF$0._File._File-num > 0:
        
          /* filter out sql92 tables and views */
          IF INTEGER(DBVERSION("QBF$0":U)) > 8 
              THEN IF QBF$0._File._Owner <> "PUB":u AND QBF$0._File._Owner <> "_FOREIGN":u
                  THEN NEXT.

        qbf-h = qbf-h + QBF$0._File._CRC.
      END.
      qbf-o = STRING(qbf-h).
    END.
    WHEN "ANY-FIELD":u THEN
      qbf-o = STRING(
              CAN-FIND(QBF$0._Field
                WHERE QBF$0._Field._Field-name BEGINS qbf-n)
              ,"y/n":u)
            + STRING(
              CAN-FIND(FIRST QBF$0._Field
                WHERE QBF$0._Field._Field-name BEGINS qbf-n)
              ,"y/n":u).
  END CASE.
END.

ELSE
/*--------------------------------------------------------------------------*/

IF qbf-t BEGINS "FILE:":u THEN DO:
  qbf-t = SUBSTRING(qbf-t,6,-1,"CHARACTER":u).
  IF qbf-t = "ROWID":u THEN
    qbf-o = STRING(RECID(QBF$0._File)).
    
  /* get table CRC - dma */
  ELSE 
  IF qbf-t = "CRC":u THEN
    qbf-o = STRING(QBF$0._File._CRC).
  
  ELSE
  IF qbf-t BEGINS "MISC2:":u THEN
    qbf-o = QBF$0._File._Fil-misc2[INTEGER(SUBSTRING(qbf-t,7,-1,
                                                     "CHARACTER":u))].
  ELSE
  IF qbf-t = "DESC":u THEN
    qbf-o = (IF NOT AVAILABLE QBF$0._File THEN ?
            ELSE IF QBF$0._File._Desc = ? THEN ""
            ELSE REPLACE(QBF$0._File._Desc,CHR(10)," ":u)).
  ELSE
  IF qbf-t BEGINS "HAS-TYPE:":u THEN
    qbf-o = STRING(CAN-FIND(FIRST QBF$0._Field OF QBF$0._File
              WHERE QBF$0._Field._dtype = INTEGER(SUBSTRING(qbf-t,10,-1,
                                                            "CHARACTER":u)))
                   ,"y/n":u).
  ELSE
  IF qbf-t = "STAMP":u THEN 
    qbf-o = STRING(QBF$0._File._Last-change).
  ELSE
  IF qbf-t = "CRC":u THEN 
    qbf-o = STRING(QBF$0._File._Crc).
  ELSE
  IF qbf-t = "CAN-READ":u THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Read ELSE "!*":u).
  ELSE
  IF qbf-t = "CAN-WRITE":u THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Write ELSE "!*":u).
  ELSE
  IF qbf-t = "CAN-CREATE":u THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Create ELSE "!*":u).
  ELSE
  IF qbf-t = "CAN-DELETE":u THEN
    qbf-o = (IF AVAILABLE QBF$0._File THEN QBF$0._File._Can-Delete ELSE "!*":u).
END.

ELSE
/*--------------------------------------------------------------------------*/

IF qbf-t BEGINS "FIELD:":u THEN DO:
  CASE SUBSTRING(qbf-t,7,-1,"CHARACTER":u):
    WHEN "ROWID":u THEN
      qbf-o = STRING(RECID(QBF$0._Field)).
    WHEN "TYP&FMT":u THEN
      qbf-o = (IF AVAILABLE QBF$0._Field THEN
                STRING(QBF$0._Field._dtype) + ",":u + QBF$0._Field._Format
              ELSE
                "0,":u).
    WHEN "CAN-READ":u THEN
      qbf-o = (IF AVAILABLE QBF$0._Field THEN
                QBF$0._Field._Can-Read
              ELSE
                "!*":u).
    WHEN "CAN-WRITE":u THEN
      qbf-o = (IF AVAILABLE QBF$0._Field THEN
                QBF$0._Field._Can-Write
              ELSE
                "!*":u).
    WHEN "EXTENT":u THEN
      qbf-o = STRING(QBF$0._Field._Extent).
    WHEN "LABEL":u THEN
      qbf-o = (IF QBF$0._Field._Col-label <> ? THEN
                QBF$0._Field._Col-label
              ELSE IF QBF$0._Field._Label <> ? THEN
                QBF$0._Field._Label
              ELSE
                QBF$0._Field._Field-name).
    WHEN "INDEX-FIELD":u THEN
      qbf-o = STRING(
              CAN-FIND(FIRST QBF$0._Index-field OF QBF$0._Field)
              ,"y/n":u).
    WHEN "QBW-FIELD":u THEN DO:
      qbf-o = STRING(QBF$0._Field._dtype)  + ",":u  
            + STRING(QBF$0._Field._Extent) + ",n":u.

      FOR EACH QBF$0._Index-field OF QBF$0._Field NO-LOCK,
        FIRST QBF$0._Index OF QBF$0._Index-field
          WHERE QBF$0._Index._Wordidx > 0 NO-LOCK:
        ENTRY(3,qbf-o) = "y":u.
        LEAVE.
      END.
    END.
  END CASE.
END.

ELSE
/*--------------------------------------------------------------------------*/

IF qbf-t BEGINS "INDEX:":u THEN DO:
  qbf-t = SUBSTRING(qbf-t,7,-1,"CHARACTER":u).
  IF qbf-t = "ROWID":u THEN qbf-o = STRING(RECID(QBF$0._Index)).
END.

/*--------------------------------------------------------------------------*/
RETURN.

/* s-schema.p - end of file */

