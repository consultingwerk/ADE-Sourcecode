/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _jgenlst.p - generate list of tables for a database
 */

{ workshop/j-define.i }
{ workshop/dbname.i &db="QBF$1"}

DEFINE INPUT PARAMETER ldb-name AS CHARACTER NO-UNDO.

DEFINE VARIABLE next-id AS INTEGER NO-UNDO.

FIND LAST qbf-rel-tt USE-INDEX tidix NO-ERROR.
next-id = IF NOT AVAILABLE qbf-rel-tt THEN 1 ELSE qbf-rel-tt.tid + 1.

FOR EACH QBF$1._File 
  WHERE QBF$1._File._File-Name < "_":U AND NOT QBF$1._File._Hidden
  BY QBF$1._File._File-Name:
  
  CREATE qbf-rel-tt.
  ASSIGN
    qbf-rel-tt.tid    = next-id
    /*
    qbf-rel-tt.tname  = get-dbname(QBF$1._File._db-recid) + ".":U
                      + QBF$1._File._File-Name
    */
    qbf-rel-tt.tname  = ldb-name + ".":U + QBF$1._File._File-Name
    next-id           = next-id + 1.
END.

/* _jgenlst.p - end of file */


