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

