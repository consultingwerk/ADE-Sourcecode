/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* af-where
*/

{ aderes/j-define.i }
{ aderes/p-lookup.i }

DEFINE INPUT PARAMETER tableName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER whereText AS CHARACTER NO-UNDO.

DEFINE VARIABLE tableId AS INTEGER NO-UNDO.

/* See if the table exists out there */
RUN lookup_table(tableName, OUTPUT tableId).
IF tableId < 0 THEN RETURN.

CREATE _tableWhere.
ASSIGN
  _tableWhere._tableId = tableId
  _tableWhere._text = whereText
  .

/* af-where.p - end of file */

