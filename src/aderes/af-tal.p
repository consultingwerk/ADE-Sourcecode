/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* af-tal.p
*
*   Create a table alias
*
*  Input Parameter
*
*    alias name    character. db.name is expected
*    table name    The table to be aliased. db.name is expected
*/

{ aderes/s-system.i }
{ aderes/j-define.i }

DEFINE INPUT  PARAMETER aDtName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER tDtName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER qbf-s   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE qbf-l   AS LOGICAL   NO-UNDO.
/*
* Make sure that:
*
*    1: The alias name is unique. Perhaps a new database table has been
*       added with the same name.
*
*    2: That the database table is available. The database permissions may
*       have changed. If the user can't see the base table then the user
*       can't see the alias.
*
*    3: The CRC of the alias may not be the same as the table.
*       If there's a change
*/

{&FIND_TABLE_BY_NAME} aDtName NO-ERROR.

IF AVAILABLE qbf-rel-buf THEN DO:
  IF NOT qbf-s THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("&1 is already defined as a database table name.  This alias cannot be created.",aDtName)).

  RETURN.
END.


{&FIND_TABLE2_BY_NAME} tDtName NO-ERROR.

IF NOT AVAILABLE qbf-rel-buf2 THEN DO:
  IF NOT qbf-s THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("You do not have permission to use &1.",tDtName)).

  RETURN.
END.

/* By alaways keeping the alias and table chksums the same then our "rebuild"
 * code will work for alias tables. When a query is opened we'll be able to
 * know that there may be something wrong with the alias because the table's
 * CRc will be different.
 */

CREATE qbf-rel-tt.

ASSIGN
  qbf-rel-tbl#      = qbf-rel-tbl# + 1
  qbf-rel-tt.tid    = qbf-rel-tbl#
  qbf-rel-tt.tname  = aDtName
  qbf-rel-tt.rels   = ""
  qbf-rel-tt.crc    = qbf-rel-buf2.crc
  qbf-rel-tt.cansee = TRUE
  qbf-rel-tt.sid    = qbf-rel-buf2.tid
  .

/* af-tal.p - end of file */

