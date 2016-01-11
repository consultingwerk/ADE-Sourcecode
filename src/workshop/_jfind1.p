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
/*
 * _jfind1.p - middle loop for j-find.p
 */

{ workshop/j-define.i }
{ workshop/j-find.i }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO. /* join field OK list */
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO. /* bsearch hi bound */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap loop variable */
DEFINE VARIABLE qbf-j AS CHARACTER NO-UNDO. /* join type */
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* bsearch lo bound */
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO. /* join ok list */
DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO. /* scrap loop */
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO. /* temp field list */

ASSIGN
  qbf-fields = ""
  qbf-same   = ?     /* initialize it for this particular database */
  qbf-subset = "".

/* for each unique non-word index in the database... */
FOR EACH QBF$1._Index
  WHERE QBF$1._Index._Unique
    AND (NOT CAN-FIND(_Field WHERE _Field._Field-name = "_Wordidx") 
      	 OR (QBF$1._Index._Wordidx = ? OR QBF$1._Index._Wordidx = 0))
    AND QBF$1._Index._Index-name < "_":u NO-LOCK
  BREAK BY QBF$1._Index._File-recid:

  FIND FIRST QBF$1._File OF QBF$1._Index NO-LOCK.
  IF QBF$1._File._Hidden THEN NEXT.

  ASSIGN
    qbf-nt     = ""
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

  /* For each field in each database matching name of first component of 
     unique index selected above... 
   */
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-pro-dbs):
    CREATE ALIAS "QBF$2":u FOR DATABASE VALUE(ENTRY(qbf-i,qbf-pro-dbs)).
    RUN workshop/_jfind2.p.
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
    ASSIGN
      qbf-f = ""
      qbf-o = "".
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-subset):
      ASSIGN
        qbf-c = ENTRY(qbf-i,qbf-subset)
        qbf-t = ENTRY(qbf-i,qbf-fields,CHR(3))
        
        qbf-j = SUBSTRING(qbf-c,1,1,"CHARACTER":u)
        qbf-c = SUBSTRING(qbf-c,2,-1,"CHARACTER":u)
        
        ENTRY(qbf-i,qbf-subset)        = ""
        ENTRY(qbf-i,qbf-fields,CHR(3)) = ""
        
        qbf-l = LOOKUP("<":u + qbf-c,qbf-subset).
        
      IF qbf-l = 0 THEN 
        qbf-l = LOOKUP("=":u + qbf-c,qbf-subset).
      IF qbf-l = 0 THEN DO:
        ASSIGN
          qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",":u) + qbf-j + qbf-c
          qbf-f = qbf-f + (IF qbf-f = "" THEN "" ELSE CHR(3)) + qbf-t.
        NEXT.
      END.
      
      /* more than one, so blow away all... */
      DO WHILE qbf-l > 0:
        ASSIGN
          ENTRY(qbf-l,qbf-subset)        = ""
          ENTRY(qbf-l,qbf-fields,CHR(3)) = ""
          
          qbf-l = LOOKUP("<":u + qbf-c,qbf-subset).
        IF qbf-l = 0 THEN 
          qbf-l = LOOKUP("=":u + qbf-c,qbf-subset).
      END.
      
      /* ...and then add to purge list */
      qbf-c = (IF qbf-p < INTEGER(qbf-c) THEN
                STRING(qbf-p) + "-":u + qbf-c
              ELSE
                qbf-c + "-":u + STRING(qbf-p)).
      IF NOT CAN-DO(qbf-purge,qbf-c) THEN
        qbf-purge = qbf-purge + (IF qbf-purge = "" THEN "" ELSE ",":u) + qbf-c.
    END.

    ASSIGN
      qbf-subset = qbf-o
      qbf-fields = qbf-f.

    /* then insert remaining entries into system */
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-subset):
      ASSIGN
        qbf-j = SUBSTRING(ENTRY(qbf-i,qbf-subset),1,1,"CHARACTER":u)
        qbf-l = qbf-p
        qbf-h = INTEGER(SUBSTRING(ENTRY(qbf-i,qbf-subset),2,-1,"CHARACTER":u)).
      IF qbf-h = 0 THEN NEXT. /* purged earlier */

      /* flip if necessary, and preserve join direction */
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
      ASSIGN
        qbf-rel-buf.rels    = qbf-rel-buf.rels + ",":u + qbf-j + STRING(qbf-h)
        qbf-rel-buf.joinfld = qbf-rel-buf.joinfld + CHR(3) + ENTRY(qbf-i,qbf-fields,CHR(3)).

      {&FIND_TABLE_BY_ID} qbf-h.
      ASSIGN
        qbf-rel-buf.rels    = qbf-rel-buf.rels + ",":u 
                              + SUBSTRING("><=":u,INDEX("<>=":u,qbf-j),1,"CHARACTER":u)
                              + STRING(qbf-l)
        qbf-rel-buf.joinfld = qbf-rel-buf.joinfld + CHR(3) + ENTRY(qbf-i,qbf-fields,CHR(3)).
    END.

    ASSIGN
      qbf-fields = ""
      qbf-subset = "".
  END.
END.

/* _jfind1.p - end of file */

