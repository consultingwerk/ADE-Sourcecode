/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _atlkuup.p
 *
 *    Finds the index of table in the table list
 */

{ aderes/j-define.i }
{ aderes/p-lookup.i }

define input  parameter tableName  as character no-undo.
define output parameter tableIndex as integer   no-undo.

run lookup_table(tableName, output tableIndex).
