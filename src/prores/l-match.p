/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* l-match.p - used for auto-guess in mailing labels */

DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT  PARAMETER qbf-p AS CHARACTER NO-UNDO. /* matches-pattern */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* response */

DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER NO-UNDO.

FIND QBF$0._Db
  WHERE QBF$0._Db._Db-name =
    (IF DBTYPE(qbf-d) = "PROGRESS" THEN ? ELSE LDBNAME(qbf-d)) NO-LOCK.
    
/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-f AND
   (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK NO-ERROR.
ELSE 
  FIND QBF$0._File OF QBF$0._Db
    WHERE QBF$0._File._File-name = qbf-f NO-LOCK NO-ERROR.

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
        WHERE QBF$0._Field._Field-name + "[" + STRING(qbf-k) + "]"
            MATCHES ENTRY(qbf-j,qbf-p)
          AND QBF$0._Field._Extent >= qbf-k NO-LOCK NO-ERROR.
    END.
  END.
IF AVAILABLE QBF$0._Field THEN
  qbf-o = qbf-d + "." + qbf-f + "." + QBF$0._Field._Field-name
        + (IF QBF$0._Field._Extent = 0 THEN ""
          ELSE "[" + STRING(qbf-k - 1) + "]").


RETURN.
