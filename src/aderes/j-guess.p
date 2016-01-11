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
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* j-guess.p - get 1:M etc relationships from WHERE clause */

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE INPUT  PARAMETER qbf-1 AS INTEGER   NO-UNDO. /*table id 1 */
DEFINE INPUT  PARAMETER qbf-2 AS INTEGER   NO-UNDO. /*table id 2 */
DEFINE INPUT  PARAMETER qbf-w AS CHARACTER NO-UNDO. /*where-clause in question*/
DEFINE OUTPUT PARAMETER qbf-s AS CHARACTER INITIAL "?" NO-UNDO.
  /*relation type*/

DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-b AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-x AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-y AS CHARACTER NO-UNDO.

{&FIND_TABLE_BY_ID} qbf-1.
{&FIND_TABLE2_BY_ID} qbf-2.
ASSIGN
  qbf-x = SUBSTRING(qbf-rel-buf.tname,1,
                    INDEX(qbf-rel-buf.tname,".":u) - 1,"CHARACTER":u)
  qbf-y = SUBSTRING(qbf-rel-buf2.tname,1,
                    INDEX(qbf-rel-buf2.tname,".":u) - 1,"CHARACTER":u).

IF   LDBNAME("QBF$1":u) <> SDBNAME(qbf-x)
  OR LDBNAME("QBF$2":u) <> SDBNAME(qbf-y) THEN DO:

  CREATE ALIAS QBF$1 FOR DATABASE VALUE(SDBNAME(qbf-x)).
  CREATE ALIAS QBF$2 FOR DATABASE VALUE(SDBNAME(qbf-y)).
  RUN aderes/j-guess.p (qbf-1,qbf-2,qbf-w,OUTPUT qbf-s).
  RETURN.
END.

FIND QBF$1._Db
  WHERE QBF$1._Db._Db-name =
    (IF DBTYPE(qbf-x) = "PROGRESS":u THEN ? ELSE LDBNAME(qbf-x)) NO-LOCK.
FIND QBF$2._Db
  WHERE QBF$2._Db._Db-name =
    (IF DBTYPE(qbf-y) = "PROGRESS":u THEN ? ELSE LDBNAME(qbf-y)) NO-LOCK.

ASSIGN
  qbf-x = SUBSTRING(qbf-rel-buf.tname, 
                    INDEX(qbf-rel-buf.tname,".":u) + 1,-1,"CHARACTER":u)
  qbf-y = SUBSTRING(qbf-rel-buf2.tname, 
                    INDEX(qbf-rel-buf2.tname,".":u) + 1,-1,"CHARACTER":u).

/* filter out sql92 views and tables in version 9 and above */
IF INTEGER(DBVERSION("QBF$1":U)) > 8 THEN DO:
    FIND QBF$1._File OF QBF$1._Db WHERE QBF$1._File._File-name = qbf-x 
        AND (QBF$1._File._Owner = "PUB":u OR QBF$1._File._Owner = "_FOREIGN":u) NO-LOCK.
END.
ELSE FIND QBF$1._File OF QBF$1._Db WHERE QBF$1._File._File-name = qbf-x NO-LOCK.

/* filter out sql92 views and tables in version 9 and above */
IF INTEGER(DBVERSION("QBF$2":U)) > 8 THEN DO:
    FIND QBF$2._File OF QBF$2._Db WHERE QBF$2._File._File-name = qbf-y
        AND (QBF$2._File._Owner = "PUB":u OR QBF$2._File._Owner = "_FOREIGN":u)  NO-LOCK.
END.
ELSE FIND QBF$2._File OF QBF$2._Db WHERE QBF$2._File._File-name = qbf-y NO-LOCK.

qbf-o = "".

/* pull apart 'where' clause to get relation fields */

/* don't need 'where' at start */
IF qbf-w BEGINS "WHERE" THEN qbf-w = SUBSTRING(qbf-w,6,-1,"CHARACTER":u).

/* get rid of parens, which are not needed for this test */
ASSIGN
  qbf-i = INDEX(qbf-w, "(")
  qbf-i = (IF qbf-i = 0 THEN INDEX(qbf-w, ")") ELSE qbf-i).
DO WHILE qbf-i > 0:
  ASSIGN
    SUBSTRING(qbf-w,qbf-i,1,"CHARACTER":u) = " "
    qbf-i = INDEX(qbf-w, "(")
    qbf-i = (IF qbf-i = 0 THEN INDEX(qbf-w, ")") ELSE qbf-i).
END.

/* or's or not's throw the whole thing off. */
IF INDEX(qbf-w + " ", " OR ") > 0 OR INDEX(qbf-w + " ", " NOT ") > 0 THEN
  RETURN.

ASSIGN
  qbf-w = TRIM(SUBSTRING(qbf-w,7,-1,"CHARACTER":u)) + " AND":u
  qbf-i = INDEX(qbf-w + " ", " AND ":u).

DO WHILE qbf-i > 0:
  ASSIGN
    qbf-l = FALSE
    qbf-d = SUBSTRING(qbf-w,1,qbf-i - 1,"CHARACTER":u)
    qbf-w = SUBSTRING(qbf-w,qbf-i + 5,-1,"CHARACTER":u)
    qbf-i = INDEX(qbf-w + " ":u, " AND ":u)
    qbf-j = INDEX(qbf-d, "=":u).
  IF qbf-j = 0 THEN NEXT.

  ASSIGN
    qbf-x = TRIM(SUBSTRING(qbf-d,1,qbf-j - 1,"CHARACTER":u))
    qbf-y = TRIM(SUBSTRING(qbf-d,qbf-j + 1,-1,"CHARACTER":u))
    qbf-x = SUBSTRING(qbf-x,R-INDEX(qbf-x, ".":u) + 1,-1,"CHARACTER":u)
    qbf-y = SUBSTRING(qbf-y,R-INDEX(qbf-y, ".":u) + 1,-1,"CHARACTER":u).

  /* if names same, then already caught by for-each above */
  /*IF qbf-x = qbf-y THEN NEXT.*/

  DO qbf-i = 1 TO 2 WHILE NOT qbf-l:
    IF qbf-i = 2 THEN
      ASSIGN /* maybe we got the files backwards.  swap and try again */
        qbf-d = qbf-x
        qbf-x = qbf-y
        qbf-y = qbf-d.
    /* attempt to find fields in schema */
    FIND QBF$1._Field OF QBF$1._File
      WHERE QBF$1._Field._Field-name = qbf-x NO-LOCK NO-ERROR.
    FIND QBF$2._Field OF QBF$2._File
      WHERE QBF$2._Field._Field-name = qbf-y NO-LOCK NO-ERROR.
    qbf-l = AVAILABLE QBF$1._Field
        AND AVAILABLE QBF$2._Field
        AND QBF$1._Field._Extent = 0
        AND QBF$2._Field._Extent = 0
        AND QBF$1._Field._dtype = QBF$2._Field._dtype.
  END.
  IF qbf-l THEN
    ASSIGN
      qbf-a = qbf-a + (IF qbf-a = "" THEN "" ELSE ",") + qbf-x
      qbf-b = qbf-b + (IF qbf-b = "" THEN "" ELSE ",") + qbf-y.
END.

/*

RUN "aderes/s-vector.p" (FALSE,",":u,INPUT-OUTPUT qbf-a).
RUN "aderes/s-vector.p" (FALSE,",":u,INPUT-OUTPUT qbf-b).

ASSIGN
  qbf-x = ""
  qbf-y = "".

FOR EACH QBF$1._Index OF QBF$1._File
  WHERE (NOT CAN-FIND(_Field WHERE _Field._Field-name = "_Wordidx") 
         OR (QBF$1._Index._Wordidx = ? OR QBF$1._Index._Wordidx = 0)) NO-LOCK:
  qbf-x = "".
  FOR EACH QBF$1._Index-field OF QBF$1._Index
    BY QBF$1._Index._Index-Seq NO-LOCK:
    FIND QBF$1._Field OF QBF$1._Index-field NO-LOCK.
    qbf-x = qbf-x + (IF qbf-x = "" THEN "" ELSE ",")
          + QBF$1._Field._Field-name.
  END.
  RUN "aderes/s-vector.p" (FALSE,",":u,INPUT-OUTPUT qbf-x).
  IF qbf-a = qbf-x THEN DO:
    qbf-x = "*" + QBF$1._Index._Index-name
          + "," + STRING(QBF$1._Index._Unique,"1/m").
    LEAVE.
  END.
END.

FOR EACH QBF$2._Index OF QBF$2._File
  WHERE (NOT CAN-FIND(_Field WHERE _Field._Field-name = "_Wordidx") 
         OR (QBF$2._Index._Wordidx = ? OR QBF$2._Index._Wordidx = 0)) NO-LOCK:
  qbf-y = "".
  FOR EACH QBF$2._Index-field OF QBF$2._Index
    BY QBF$2._Index._Index-Seq NO-LOCK:
    FIND QBF$2._Field OF QBF$2._Index-field NO-LOCK.
    qbf-y = qbf-y + (IF qbf-y = "" THEN "" ELSE ",")
          + QBF$2._Field._Field-name.
  END.
  RUN "aderes/s-vector.p" (FALSE,",":u,INPUT-OUTPUT qbf-y).
  IF qbf-b = qbf-y THEN DO:
    qbf-y = "*" + QBF$2._Index._Index-name
          + "," + STRING(QBF$2._Index._Unique,"1/m":u).
    LEAVE.
  END.
END.

/* neither index matched all where clause components */
IF NOT qbf-x BEGINS "*" OR NOT qbf-y BEGINS "*" THEN RETURN.
*/

RETURN.

/* j-guess.p - end of file */

