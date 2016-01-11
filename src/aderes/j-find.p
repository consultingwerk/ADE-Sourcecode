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
 * j-find.p - find all implied of-relationships
 */

/* This program will remove any existing OF-style joins from the   */
/* table, and fill it with joins found.  It preserves any existing */
/* WHERE-style joins.                                              */

/* j-find.i describes shared variables and comments on algorithms. */

{ aderes/s-system.i }
{ aderes/j-define.i }
{ aderes/j-find.i NEW }

DEFINE VARIABLE qbf-1 AS CHARACTER NO-UNDO. /* first filename */
DEFINE VARIABLE qbf-2 AS CHARACTER NO-UNDO. /* second filename */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* generic scrap */
DEFINE VARIABLE qbf-g AS INTEGER   NO-UNDO. /* used for gap in shell sorts */
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO. /* mostly, hi bound of something */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap, loop */
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* scrap, loop */
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO. /* scrap, loop */
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* mostly, low bound of something */
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO. /* holding place during sorting */
DEFINE VARIABLE qbf-r AS ROWID     NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO. /* est size of array in bytes */

/*
 * Define a shared temp table to handle relationship between tables. The
 * temp table will make it easier to  eliminate duplicate relationships.
 * It is only used during the gathering process. The table is destroyed
 * when this function goes out of scope.
 */

DEFINE NEW SHARED TEMP-TABLE _rels NO-UNDO
  FIELD baseTable    AS INTEGER
  FIELD relatedTable AS INTEGER
  INDEX baseIx baseTable.

OUTPUT TO VALUE(qbf-qcfile + ".ql":u) NO-ECHO APPEND.

FOR EACH qbf-rel-whr:
  qbf-rel-whr.jwhere = "|":u + qbf-rel-whr.jwhere.
END.

/* first, blow away all OF-style joins. */
FOR EACH qbf-rel-buf:
  qbf-i = qbf-rel-buf.tid.
  IF INDEX(qbf-rel-buf.rels,":":u) > 0 THEN DO:
    DO qbf-j = 2 TO NUM-ENTRIES(qbf-rel-buf.rels):
      IF INDEX(ENTRY(qbf-j,qbf-rel-buf.rels),":":u) = 0 THEN NEXT.
      ASSIGN
        qbf-c = ENTRY(qbf-j,qbf-rel-buf.rels)
        qbf-k = INTEGER(SUBSTRING(qbf-c,INDEX(qbf-c,":":u) + 1,-1,
                                  "CHARACTER":u)).
                                  
      {&FIND_WHERE_BY_ID} qbf-k. 
      
      IF qbf-rel-whr.jwhere BEGINS "|":u THEN /* WHERE not allocated yet */
        qbf-rel-whr.jwhere = STRING(qbf-i) + ",":u
                           + SUBSTRING(qbf-c,1,1,"CHARACTER":u) + ",":u
                           + SUBSTRING(qbf-c,2,INDEX(qbf-c,":":u) - 2,
                                       "CHARACTER":u) 
                           + ",":u + qbf-rel-whr.jwhere.
    END.
  END.
  qbf-rel-buf.rels = "".
END.

/*--------------------------------------------------------------------------*/
/* grab list of databases with metaschema */

qbf-pro-dbs = "".
DO qbf-i = 1 TO NUM-DBS:
  IF DBTYPE(qbf-i) = "PROGRESS":u THEN
    qbf-pro-dbs = qbf-pro-dbs + (IF qbf-pro-dbs = "" THEN "" ELSE ",":u) + 
      	       	  LDBNAME(qbf-i).
END.

/*--------------------------------------------------------------------------*/
/* plow through unique indexes for each database */

DO qbf-i = 1 TO NUM-ENTRIES(qbf-pro-dbs):
  CREATE ALIAS "QBF$1":u FOR DATABASE VALUE(ENTRY(qbf-i,qbf-pro-dbs)).
  RUN aderes/j-find1.p.
END.

/*--------------------------------------------------------------------------*/
/* now purge duplicates recorded in qbf-purge temp-table */

FOR EACH qbf-purge:
  ASSIGN
    qbf-l = INTEGER(ENTRY(1,qbf-purge.p-item,"-":u))
    qbf-h = INTEGER(ENTRY(2,qbf-purge.p-item,"-":u)).
  {&FIND_TABLE_BY_ID} qbf-h.
  {&FIND_TABLE2_BY_ID} qbf-l.
  ASSIGN
    qbf-1 = qbf-rel-buf.rels + ",":u
    qbf-2 = qbf-rel-buf2.rels + ",":u
    qbf-i = INDEX(qbf-1,"<":u + STRING(qbf-l) + ",":u)
    qbf-j = INDEX(qbf-2,"<":u + STRING(qbf-h) + ",":u).

  IF qbf-i = 0 THEN qbf-i = INDEX(qbf-1,">":u + STRING(qbf-l) + ",":u).
  IF qbf-j = 0 THEN qbf-j = INDEX(qbf-2,">":u + STRING(qbf-h) + ",":u).

  IF qbf-i = 0 THEN qbf-i = INDEX(qbf-1,"=":u + STRING(qbf-l) + ",":u).
  IF qbf-j = 0 THEN qbf-j = INDEX(qbf-2,"=":u + STRING(qbf-h) + ",":u).

  IF qbf-i > 0 THEN
    SUBSTRING(qbf-rel-buf.rels,qbf-i - 1,
              LENGTH(STRING(qbf-l),"CHARACTER":u) + 2,"CHARACTER":u) = "".
  IF qbf-j > 0 THEN
    SUBSTRING(qbf-rel-buf2.rels,qbf-j - 1,
              LENGTH(STRING(qbf-h),"CHARACTER":u) + 2,"CHARACTER":u) = "".
END.

/*--------------------------------------------------------------------------*/
/* plug in existing WHERE-clause relations */

FOR EACH qbf-rel-whr:
  IF qbf-rel-whr.jwhere BEGINS "|":u THEN DO:
    IF qbf-rel-whr.jwhere <> "|":u THEN
      PUT UNFORMATTED
        STRING(TIME,"HH:MM:SS":u)
          " Orphan WHERE clause found:":u SKIP
          "WHERE ":u SUBSTRING(qbf-rel-whr.jwhere,2,-1,"CHARACTER":u) SKIP.
    qbf-rel-whr.jwhere = "".
    NEXT.
  END.

  ASSIGN
    qbf-i = INTEGER(ENTRY(1,qbf-rel-whr.jwhere))
    qbf-j = INTEGER(ENTRY(3,qbf-rel-whr.jwhere)).
  {&FIND_TABLE_BY_ID} qbf-i.
  {&FIND_TABLE2_BY_ID} qbf-j.
  IF   LOOKUP("<":u + STRING(qbf-j),qbf-rel-buf.rels) > 0
    OR LOOKUP(">":u + STRING(qbf-j),qbf-rel-buf.rels) > 0
    OR LOOKUP("=":u + STRING(qbf-j),qbf-rel-buf.rels) > 0
    OR LOOKUP("<":u + STRING(qbf-i),qbf-rel-buf2.rels) > 0
    OR LOOKUP(">":u + STRING(qbf-i),qbf-rel-buf2.rels) > 0
    OR LOOKUP("=":u + STRING(qbf-i),qbf-rel-buf2.rels) > 0 THEN DO:
      PUT UNFORMATTED
        STRING(TIME,"HH:MM:SS":u)
          " Join overlap between WHERE and OF.  WHERE-join overwritten.":t72
          SKIP
        "  File #1 is: ":t32 qbf-rel-buf.tname SKIP
        "  File #2 is: ":t32 qbf-rel-buf.tname SKIP
        "  Where clause: ":t32
          "WHERE ":u
          SUBSTRING(qbf-rel-whr.jwhere,INDEX(qbf-rel-whr.jwhere,"|":u) + 1,
                    -1,"CHARACTER":u)
          SKIP.
    qbf-rel-whr.jwhere = "".
    NEXT.
  END.

  ASSIGN
    qbf-rel-buf.rels   = qbf-rel-buf.rels + ",":u
                       + ENTRY(2,qbf-rel-whr.jwhere)
                       + STRING(qbf-j)
                       + ":":u + STRING(qbf-rel-whr.wid)
    qbf-rel-buf2.rels  = qbf-rel-buf2.rels + ",":u
                       + SUBSTRING("=><*?":u,
                           INDEX("=<>*?":u,ENTRY(2,qbf-rel-whr.jwhere)),1,
                           "CHARACTER":u)
                       + STRING(qbf-i)
                       + ":":u + STRING(qbf-rel-whr.wid)
    qbf-rel-whr.jwhere = SUBSTRING(qbf-rel-whr.jwhere,
                           INDEX(qbf-rel-whr.jwhere,"|":u) + 1,-1,
                           "CHARACTER":u).
END.

/*--------------------------------------------------------------------------*/
/* now sort */

FOR EACH qbf-rel-buf:
  IF NUM-ENTRIES(qbf-rel-buf.rels) < 3 THEN NEXT.

  ASSIGN
    qbf-o = SUBSTRING(qbf-rel-buf.rels,
              INDEX(qbf-rel-buf.rels,",":u) + 1,-1,"CHARACTER":u)
    qbf-g = TRUNCATE(NUM-ENTRIES(qbf-o) / 2,0). /* shell sort */
  DO WHILE qbf-g > 0:
    DO qbf-i = qbf-g TO NUM-ENTRIES(qbf-o):
      qbf-j = qbf-i - qbf-g.
      DO WHILE qbf-j > 0:
        ASSIGN
          qbf-1 = SUBSTRING(ENTRY(qbf-j,qbf-o),2,-1,"CHARACTER":u)
          qbf-2 = SUBSTRING(ENTRY(qbf-j + qbf-g,qbf-o),2,-1,"CHARACTER":u).
        IF INDEX(qbf-1,":":u) > 0 THEN
          qbf-1 = SUBSTRING(qbf-1,1,INDEX(qbf-1,":":u) - 1,"CHARACTER":u).
        IF INDEX(qbf-2,":":u) > 0 THEN
          qbf-2 = SUBSTRING(qbf-2,1,INDEX(qbf-2,":":u) - 1,"CHARACTER":u).
        IF INTEGER(qbf-1) < INTEGER(qbf-2) THEN LEAVE.
        ASSIGN
          qbf-c                      = ENTRY(qbf-j,qbf-o)
          ENTRY(qbf-j,qbf-o)         = ENTRY(qbf-j + qbf-g,qbf-o)
          ENTRY(qbf-j + qbf-g,qbf-o) = qbf-c
          qbf-j                      = qbf-j - qbf-g.
      END.
    END.
    qbf-g = TRUNCATE(qbf-g / 2,0).
  END.

  qbf-rel-buf.rels = ",":u + qbf-o.
END.

/*--------------------------------------------------------------------------*/

PUT UNFORMATTED FILL("-":u,76) SKIP.
OUTPUT CLOSE.
RETURN.

/* j-find.p - end of file */
