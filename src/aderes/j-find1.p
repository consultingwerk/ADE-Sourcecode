/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * j-find1.p - middle loop for j-find.p
 */

DEFINE SHARED TEMP-TABLE _rels NO-UNDO
  FIELD baseTable    AS INTEGER
  FIELD relatedTable AS INTEGER
  INDEX baseIx baseTable.

{ aderes/s-system.i }
{ aderes/j-define.i }
{ aderes/j-find.i }

/* j-find.i describes shared variables and comments on algorithms. */

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO. /* elapsed time counter */
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO. /* bsearch hi bound */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap loop variable */
DEFINE VARIABLE qbf-j AS CHARACTER NO-UNDO. /* join type */
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* bsearch lo bound */
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO. /* join ok list */
DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO. /* scrap loop */
DEFINE VARIABLE qbf-r AS INTEGER   NO-UNDO. /* # joins for current _file */

ASSIGN
  qbf-e      = ETIME /* elapsed time... */
  qbf-same   = ?     /* initialize it for this particular database */
  qbf-subset = "".

/* for each unique non-word index in the database... */
FOR EACH QBF$1._Index
  WHERE QBF$1._Index._Unique
    AND (NOT CAN-FIND(_Field WHERE _Field._Field-name = "_Wordidx") 
      	 OR (QBF$1._Index._Wordidx = ? OR QBF$1._Index._Wordidx = 0))
    AND NOT QBF$1._Index._Index-name BEGINS "_":u NO-LOCK
  BREAK BY QBF$1._Index._File-recid:

  FIND FIRST QBF$1._File OF QBF$1._Index NO-LOCK.
  IF QBF$1._File._Hidden THEN NEXT.

  /* add this check to eliminate sql92 tables and views */
  IF INTEGER(DBVERSION("QBF$1":U)) > 8 
      THEN IF (QBF$1._File._Owner <> "PUB":U AND QBF$1._File._Owner <> "_FOREIGN":U) 
        THEN NEXT.
 

  ASSIGN
    qbf-nt     = ""
    qbf-r      = (IF qbf-same = QBF$1._Index._File-recid THEN qbf-r + 1 ELSE 1)
    qbf-same   = QBF$1._Index._File-recid.

  /* grab the names and types of all the index components... */
  FOR EACH QBF$1._Index-field OF QBF$1._Index NO-LOCK
    BY QBF$1._Index-field._Index-seq:
    FIND QBF$1._Field OF QBF$1._Index-field NO-LOCK.
    qbf-nt = qbf-nt + (IF QBF$1._Index-field._Index-seq = 1 THEN "" ELSE ",":u)
           + QBF$1._Field._Field-name + ",":u + STRING(QBF$1._Field._dtype).
  END.

  /* oops! no index components - must be default index */
  IF qbf-nt = "" THEN NEXT.

  /* for each field in each database matching name of  */
  /* first component of unique index selected above... */
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-pro-dbs):
    CREATE ALIAS "QBF$2":u FOR DATABASE VALUE(ENTRY(qbf-i,qbf-pro-dbs)).
    RUN aderes/j-find2.p.
  END.

  /* display msg every 10 seconds */
  IF ETIME - qbf-e > 10000 THEN DO:
    STATUS DEFAULT
      "Finding implied OF-relations.":t48 + " (":u + STRING(qbf-est) + ")":u.
    qbf-e = ETIME.
  END.

  IF LAST-OF(QBF$1._Index._File-recid) THEN DO:
    /* find this file in relationship table */
    FIND QBF$1._File OF QBF$1._Index NO-LOCK.
    FIND QBF$1._Db OF QBF$1._File NO-LOCK.
    ASSIGN
      qbf-c = (IF QBF$1._Db._Db-name = ? THEN SDBNAME("QBF$1":u)
              ELSE QBF$1._Db._Db-name) + ".":u + QBF$1._File._File-name.
    {&FIND_TABLE_BY_NAME} qbf-c.
    qbf-p = qbf-rel-buf.tid. /* qbf-p contains table id */

    /* find & blow away both copies of duplicates */
    qbf-o = "".
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-subset):
      ASSIGN
        qbf-c = ENTRY(qbf-i,qbf-subset)
        qbf-j = SUBSTRING(qbf-c,1,1,"CHARACTER":u)
        qbf-c = SUBSTRING(qbf-c,2,-1,"CHARACTER":u)
        ENTRY(qbf-i,qbf-subset) = ""
        qbf-l = LOOKUP("<":u + qbf-c,qbf-subset).
      IF qbf-l = 0 THEN qbf-l = LOOKUP("=":u + qbf-c,qbf-subset).
      IF qbf-l = 0 THEN DO:
        qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",":u) + qbf-j + qbf-c.
        NEXT.
      END.
      /* more than one, so blow away all... */
      DO WHILE qbf-l > 0:
        ASSIGN
          ENTRY(qbf-l,qbf-subset) = ""
          qbf-l = LOOKUP("<":u + qbf-c,qbf-subset).
        IF qbf-l = 0 THEN qbf-l = LOOKUP("=":u + qbf-c,qbf-subset).
      END.
      /* ...and then add to purge list */
      qbf-c = (IF qbf-p < INTEGER(qbf-c) THEN
                STRING(qbf-p) + "-":u + qbf-c
              ELSE
                qbf-c + "-":u + STRING(qbf-p)).
      IF NOT CAN-FIND(FIRST qbf-purge WHERE qbf-purge.p-item = qbf-c) THEN DO:
        CREATE qbf-purge.
        ASSIGN p-item = qbf-c.
      END.
    END.

    qbf-subset = qbf-o.

    /* then insert remaining entries into system */
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-subset):
      ASSIGN
        qbf-j = SUBSTRING(ENTRY(qbf-i,qbf-subset),1,1,"CHARACTER":u)
        qbf-l = qbf-p
        qbf-h = INTEGER(SUBSTRING(ENTRY(qbf-i,qbf-subset),2,-1,"CHARACTER":u)).
      IF qbf-h = 0 THEN NEXT. /* purged earlier */

      /* flip if necessary, and preserved join direction */
      IF qbf-l > qbf-h THEN
        ASSIGN
          qbf-p = qbf-l
          qbf-l = qbf-h
          qbf-h = qbf-p
          qbf-j = (IF qbf-j = "<":u THEN ">":u ELSE "=":u).

      /* insert into table once for each file concerned */
      FIND FIRST _rels WHERE
         (_rels.baseTable = qbf-l AND _rels.relatedTable = qbf-h)
      OR (_rels.baseTable = qbf-h AND _rels.relatedTable = qbf-l) NO-ERROR.

      IF AVAILABLE _rels THEN NEXT.

      CREATE _rels.

      ASSIGN
        _rels.baseTable    = qbf-l
        _rels.relatedTable = qbf-h
        .

      {&FIND_TABLE_BY_ID} qbf-l.
      qbf-rel-buf.rels = qbf-rel-buf.rels + ",":u + qbf-j + STRING(qbf-h).

      {&FIND_TABLE_BY_ID} qbf-h.
      qbf-rel-buf.rels = qbf-rel-buf.rels + ",":u 
                       + SUBSTRING("><=":u,INDEX("<>=":u,qbf-j),1,"CHARACTER":u)
                       + STRING(qbf-l).
    END.

    qbf-subset = "".
  END.

END.

STATUS DEFAULT.
RETURN.

/* j-find1.p - end of file */

