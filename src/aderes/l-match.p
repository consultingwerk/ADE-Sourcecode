/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * l-match.p - used for auto-guess in mailing labels
 */

{ aderes/j-define.i }
DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT  PARAMETER qbf-p AS CHARACTER NO-UNDO. /* matches-pattern */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* response */

DEFINE VARIABLE qbf-j    AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k    AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l    AS INTEGER   NO-UNDO.
DEFINE VARIABLE refName  AS CHARACTER NO-UNDO.

/* Dereference any aliases */
RUN alias_to_tbname(qbf-d + "." + qbf-f, true, output refName).
refName = entry(2, refName, ".").

FIND QBF$0._Db
  WHERE QBF$0._Db._Db-name =
    (IF DBTYPE(qbf-d) = "PROGRESS":u THEN ? ELSE LDBNAME(qbf-d)) NO-LOCK.

/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN DO:
    FIND QBF$0._File OF QBF$0._Db
        WHERE QBF$0._File._File-name = refName 
            AND (QBF$0._File._Owner = "PUB":u OR QBF$0._File._Owner = "_FOREIGN":u)NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND QBF$0._File OF QBF$0._Db
        WHERE QBF$0._File._File-name = refName NO-LOCK NO-ERROR.
END.

ASSIGN
  qbf-l = 0
  qbf-o = "".
FOR EACH QBF$0._Field OF QBF$0._File
  WHERE QBF$0._Field._Extent > 0 NO-LOCK:
  qbf-l = MAXIMUM(qbf-l,QBF$0._Field._Extent).
END.
RELEASE QBF$0._Field.
DO qbf-j = 1 TO NUM-ENTRIES(qbf-p) WHILE NOT AVAILABLE QBF$0._Field:
  FIND FIRST QBF$0._Field OF QBF$0._File
    WHERE QBF$0._Field._Field-name MATCHES ENTRY(qbf-j,qbf-p)
      AND QBF$0._Field._Extent = 0
    NO-LOCK NO-ERROR.
END.
IF qbf-l > 0 THEN
  DO qbf-j = 1 TO NUM-ENTRIES(qbf-p) WHILE NOT AVAILABLE QBF$0._Field:
    DO qbf-k = 1 TO qbf-l WHILE NOT AVAILABLE QBF$0._Field:
      FIND FIRST QBF$0._Field OF QBF$0._File
        WHERE QBF$0._Field._Field-name + "[":u + STRING(qbf-k) + "]":u
            MATCHES ENTRY(qbf-j,qbf-p)
          AND QBF$0._Field._Extent >= qbf-k NO-LOCK NO-ERROR.
    END.
  END.
IF AVAILABLE QBF$0._Field THEN
  qbf-o = qbf-d + ".":u + qbf-f + ".":u + QBF$0._Field._Field-name
        + (IF QBF$0._Field._Extent = 0 THEN ""
          ELSE "[":u + STRING(qbf-k - 1) + "]":u).

RETURN.
{ aderes/s-alias.i}

/* l-match.p - end of file */

