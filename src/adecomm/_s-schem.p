/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _s-schem.p - extract schema information (see also a-schema.p) */

/*
Keep this program small.  Move any big and clumsy information
extractions into a-schema.p.

DICTDB used to be QBF$0 gjo.
*/

DEFINE QUERY qDb FOR DICTDB._db FIELDS(). 

DEFINE INPUT  PARAMETER cDbName AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER cFieldName AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT  PARAMETER cField-IndexNmae AS CHARACTER NO-UNDO. /* fieldname/indexname */
DEFINE INPUT  PARAMETER cInfoType AS CHARACTER NO-UNDO. /* information type */
DEFINE OUTPUT PARAMETER cAnswer AS CHARACTER NO-UNDO. /* response */

DEFINE VARIABLE qbf-h AS DECIMAL NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER NO-UNDO.

/* ldbname,filename,fieldname can come in cDbName+cFieldName+cField-IndexNmae, */
/* or as a combined entries in cDbName or cDbName+cFieldName */
ASSIGN
  cAnswer = cDbName
        + (IF cFieldName = "" THEN "" ELSE ".":u + cFieldName)
        + (IF cField-IndexNmae = "" THEN "" ELSE ".":u + cField-IndexNmae)
  cAnswer = SUBSTRING(cAnswer,1,INDEX(cAnswer + "[":u,"[":u) - 1,"CHARACTER":u)
          /*strip off subscript*/
  cDbName = SUBSTRING(cAnswer,1,INDEX(cAnswer + ".":u,".":u) - 1,"CHARACTER":u)
  cAnswer = SUBSTRING(cAnswer,INDEX(cAnswer,".":u) + 1,-1,"CHARACTER":u)
  cFieldName = SUBSTRING(cAnswer,1,INDEX(cAnswer + ".":u,".":u) - 1,
                         "CHARACTER":u)
  cField-IndexNmae = SUBSTRING(cAnswer,INDEX(cAnswer,".":u) + 1,-1,
                               "CHARACTER":u)
  cAnswer = ?.

IF LDBNAME(cDbName) = ? THEN RETURN.

/* if not pointing to correct db, fix situation and call self */
/* recursively.  this will also leave things set for the next */
/* time this guy is called. */
IF LDBNAME("DICTDB":u) <> SDBNAME(cDbName) THEN DO:
  CREATE ALIAS "DICTDB":u FOR DATABASE VALUE(SDBNAME(cDbName)).
  RUN "adecomm/_s-schem.p" (cDbName,cFieldName,cField-IndexNmae,cInfoType,OUTPUT cAnswer).
  RETURN.
END.

/* now point to correct _db record */
OPEN QUERY qDb FOR EACH DICTDB._Db
  WHERE DICTDB._Db._Db-name =
    (IF DBTYPE(cDbName) = "PROGRESS":u THEN ? ELSE LDBNAME(cDbName))
  NO-LOCK.

GET NEXT qDb.

/* do relevant index cursor positions */
IF CAN-DO("FILE:*,FIELD:*,INDEX:*":u,cInfoType) AND AVAILABLE DICTDB._Db THEN DO:
  IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
    FIND DICTDB._File OF DICTDB._Db
      WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                   DICTDB._File._File-name = cFieldName NO-LOCK NO-ERROR.
  ELSE
    FIND DICTDB._File OF DICTDB._Db
      WHERE DICTDB._File._File-name = cFieldName NO-LOCK NO-ERROR.
END.
IF CAN-DO("FIELD:*":u,cInfoType) AND AVAILABLE DICTDB._File THEN
  FIND DICTDB._Field OF DICTDB._File
    WHERE DICTDB._Field._Field-name = cField-IndexNmae NO-LOCK NO-ERROR.
IF CAN-DO("INDEX:*":u,cInfoType) AND AVAILABLE DICTDB._File THEN
  FIND DICTDB._Index OF DICTDB._File
    WHERE DICTDB._Index._Index-name = cField-IndexNmae NO-LOCK.

/*--------------------------------------------------------------------------*/
IF cInfoType BEGINS "DB:":u THEN DO:
  CASE SUBSTRING(cInfoType,4,-1,"CHARACTER":u):
    WHEN "RECID":u THEN
      cAnswer = STRING(RECID(DICTDB._Db)).
    WHEN "CHECKSUM":u THEN DO:
      qbf-h = 0.
      FOR EACH DICTDB._File OF DICTDB._Db
        WHERE DICTDB._File._File-num > 0:
        IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN DO:
          IF LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) = 0 THEN NEXT.
        END.
        qbf-h = qbf-h + DICTDB._File._Last-change.
      END.
      cAnswer = STRING(qbf-h).
    END.
    WHEN "ANY-FIELD":u THEN
      cAnswer = STRING(
              CAN-FIND(DICTDB._Field
                WHERE DICTDB._Field._Field-name BEGINS cField-IndexNmae)
              ,"y/n":u)
            + STRING(
              CAN-FIND(FIRST DICTDB._Field
                WHERE DICTDB._Field._Field-name BEGINS cField-IndexNmae)
              ,"y/n":u).
  END CASE.
END.

ELSE
/*--------------------------------------------------------------------------*/

IF cInfoType BEGINS "FILE:":u THEN DO:
  cInfoType = SUBSTRING(cInfoType,6,-1,"CHARACTER":u).
  IF cInfoType = "RECID":u THEN
    cAnswer = STRING(RECID(DICTDB._File)).
  ELSE
  IF cInfoType BEGINS "MISC2:":u THEN
    cAnswer = DICTDB._File._Fil-misc2[INTEGER(SUBSTRING(cInfoType,7,-1,
                                                        "CHARACTER":u))].
  ELSE
  IF cInfoType = "DESC":u THEN
    cAnswer = (IF NOT AVAILABLE DICTDB._File THEN ?
               ELSE IF DICTDB._File._Desc = ? THEN ""
               ELSE DICTDB._File._Desc).
  ELSE
  IF cInfoType BEGINS "HAS-TYPE:":u THEN
    cAnswer = STRING(
            CAN-FIND(FIRST DICTDB._Field OF DICTDB._File
              WHERE DICTDB._Field._dtype = INTEGER(SUBSTRING(cInfoType,10,-1,
                                                             "CHARACTER":u))
                AND DICTDB._Field._Extent = 0)
            ,"y/n":u).
  ELSE
  IF cInfoType = "STAMP":u THEN cAnswer = STRING(DICTDB._File._Last-change).
  ELSE
  IF cInfoType = "CRC":u THEN cAnswer = STRING(DICTDB._File._Crc).
  ELSE
  IF cInfoType = "CAN-READ":u THEN
    cAnswer = (IF AVAILABLE DICTDB._File THEN 
                 DICTDB._File._Can-Read ELSE "!*":u).
  ELSE
  IF cInfoType = "CAN-WRITE":u THEN
    cAnswer = (IF AVAILABLE DICTDB._File THEN 
                 DICTDB._File._Can-Write ELSE "!*":u).
  ELSE
  IF cInfoType = "CAN-CREATE":u THEN
    cAnswer = (IF AVAILABLE DICTDB._File 
                 THEN DICTDB._File._Can-Create ELSE "!*":u).
  ELSE
  IF cInfoType = "CAN-DELETE":u THEN
    cAnswer = (IF AVAILABLE DICTDB._File THEN 
                 DICTDB._File._Can-Delete ELSE "!*":u).
  ELSE
  IF cInfoType = "VALEXP":u THEN
    cAnswer = (IF AVAILABLE DICTDB._File THEN 
                 DICTDB._File._ValExp ELSE ?).

END.

ELSE
/*--------------------------------------------------------------------------*/

IF cInfoType BEGINS "FIELD:":u THEN DO:
  CASE SUBSTRING(cInfoType,7,-1,"CHARACTER":u):
    WHEN "RECID":u THEN
      cAnswer = STRING(RECID(DICTDB._Field)).
    WHEN "TYP&FMT":u THEN
      cAnswer = (IF AVAILABLE DICTDB._Field THEN
                STRING(DICTDB._Field._dtype) + ",":u + DICTDB._Field._Format
              ELSE
                "0,":u).
    WHEN "CAN-READ":u THEN
      cAnswer = (IF AVAILABLE DICTDB._Field THEN
                DICTDB._Field._Can-Read
              ELSE
                "!*":u).
    WHEN "EXTENT":u THEN
      cAnswer = STRING(DICTDB._Field._Extent).
    WHEN "COL-LABEL":U THEN
      cAnswer = DICTDB._Field._Col-label.
    WHEN "LABEL":u THEN
      cAnswer = (IF DICTDB._Field._Col-label <> ? THEN
                DICTDB._Field._Col-label
              ELSE IF DICTDB._Field._Label <> ? THEN
                DICTDB._Field._Label
              ELSE
                DICTDB._Field._Field-name).
    WHEN "INDEX-FIELD":u THEN
      cAnswer = STRING(
              CAN-FIND(FIRST DICTDB._Index-field OF DICTDB._Field)
              ,"y/n":u).
    WHEN "INITIAL" THEN
      cAnswer = DICTDB._Field._INITIAL.
    WHEN "QBW-FIELD":u THEN DO:
      cAnswer = STRING(DICTDB._Field._dtype)  + ",":u  
            + STRING(DICTDB._Field._Extent) + ",n":u.
      FOR EACH DICTDB._Index-field OF DICTDB._Field NO-LOCK,
        FIRST DICTDB._Index OF DICTDB._Index-field WHERE
    	  CAN-FIND (DICTDB._Field WHERE DICTDB._Field._Field-name = "_Wordidx")
          AND DICTDB._Index._Wordidx > 0 NO-LOCK:
        ENTRY(3,cAnswer) = "y":u.
        LEAVE.
      END.  /* For EACH DICTDB._Index-field */
    END.  /* WHEN QBW-FIELD */
    WHEN "VIEW-AS" THEN
      cAnswer = DICTDB._Field._VIEW-AS.
  END CASE.
END.

ELSE
/*--------------------------------------------------------------------------*/

IF cInfoType BEGINS "INDEX:":u THEN DO:
  cInfoType = SUBSTRING(cInfoType,7,-1,"CHARACTER":u).
  IF cInfoType = "RECID":u THEN cAnswer = STRING(RECID(DICTDB._Index)).
END.

/*--------------------------------------------------------------------------*/
RETURN.

/* _s-schem.p - end of file */



