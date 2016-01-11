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
 * _vgtbli.p
 *
 *    Return information about a table.
 *
 *  INPUT PARAMETERS
 *
 *    tableName  The table in question. The name should be qualified in the
 *               same manner that the name was found. We look in the
 *               current list of tables.
 *
 *  OUTPUT PARAMETERS
 *
 *    refTable   If tableName is an alias then this variable will
 *               hold the name of base table. Otherwise it is ?.
 *
 *    joinTable  The name of the table that tableName is joined to. See
 *               joinInfo.
 *
 *    joinInfo   How the table is joined to the "n - 1" table in the
 *               table list. The join of the first table in the table
 *               list is always "".
 *
 *    whereInfo  The text of the where clause defined by the user
 *
 *    whereAsk   The information about any clauses that need to be asked.
 *
 *    includedCode The code to be included for this table in the
 *                 respective for-each statement
 */

DEFINE INPUT  PARAMETER tableName    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER refTable     AS CHARACTER NO-UNDO INITIAL ?.
DEFINE OUTPUT PARAMETER joinTable    AS CHARACTER NO-UNDO INITIAL "".
DEFINE OUTPUT PARAMETER joinInfo     AS CHARACTER NO-UNDO INITIAL "".
DEFINE OUTPUT PARAMETER whereInfo    AS CHARACTER NO-UNDO INITIAL "".
DEFINE OUTPUT PARAMETER whereAsk     AS CHARACTER NO-UNDO INITIAL "".
DEFINE OUTPUT PARAMETER includedCode AS CHARACTER NO-UNDO INITIAL "".
DEFINE OUTPUT PARAMETER lRet         AS LOGICAL   NO-UNDO INITIAL FALSE.

{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE VARIABLE qbf-i    AS INTEGER NO-UNDO.
DEFINE VARIABLE tableNum AS INTEGER NO-UNDO.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
  tableNum = INTEGER(ENTRY(qbf-i, qbf-tables)).

  {&FIND_TABLE_BY_ID} tableNum.
  IF qbf-rel-buf.tname = tableName THEN DO:
    lRet = TRUE.
    LEAVE.
  END.
END.

IF lRet = FALSE THEN RETURN.

/* We found the name, now go get the information.  If an alias then get 
   the reference name. */
IF qbf-rel-buf.sid <> ? THEN DO:
  {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid NO-ERROR.
  IF AVAILABLE qbf-rel-buf2 THEN
    refTable = qbf-rel-buf2.tname.
END.

/* Get the where information */
FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = tableNum NO-ERROR.

/* If there's no information about the table then return. Its not an error,
   there's simply no information */
IF NOT AVAILABLE qbf-where THEN RETURN.

{&FIND_TABLE2_BY_ID} INTEGER(qbf-where.qbf-wrid) NO-ERROR.
IF AVAILABLE qbf-rel-buf2 THEN
  joinTable = qbf-rel-buf2.tname.

ASSIGN
  joinInfo     = qbf-where.qbf-wrel
  whereInfo    = qbf-where.qbf-wcls
  whereAsk     = qbf-where.qbf-wask
  includedCode = qbf-where.qbf-winc
  .

/* vgtbli.p - end of file */

