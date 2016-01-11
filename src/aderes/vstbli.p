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
 * _vstbli.p
 *
 *    Set information about a table.
 * 
 *  input parameter
 *
 *    tableName  The table in question. The name should be qualified in the
 *               same manner that the name was found. We look in the
 *               current list of tables.
 *
 *    joinTable  The "n - 1" table. This is the table that tableName is
 *               joined to. The value is "" if this is first table in the
 *               list.
 *
 *    joinInfo   How the table is joined to the "n - 1" table in the
 *               table list. The join of the first table in the table
 *               list is always "".
 *
 *    whereInfo  The text of the WHERE clause defined by the user
 *
 *    whereAsk   The information about any clauses that need to be asked.
 *
 *    includedCode  Progress code that is to be included after the
 *                  for-each statement for this table.
 *
 *    If ? is passed for anything but the tableName then the current
 *    value of the Results datastructure is not changed.
 */

DEFINE INPUT  PARAMETER tableName    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER joinTable    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER joinInfo     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER whereInfo    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER whereAsk     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER includedCode AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER lRet         AS LOGICAL   NO-UNDO INITIAL FALSE.

{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE VARIABLE tableNum AS INTEGER NO-UNDO.
DEFINE VARIABLE joinNum  AS INTEGER NO-UNDO.

/*
 * The list of tables is a comma separated list of numbers. Convert the name
 * that we get from the user and then *do not* check to see if that table is
 * in the current list.
 */

{&FIND_TABLE_BY_NAME} tableName NO-ERROR.
IF AVAILABLE qbf-rel-buf THEN
  ASSIGN
    lRet     = TRUE
    tableNum = qbf-rel-buf.tid.

IF lRet = FALSE THEN
  RETURN.

IF joinTable > "" THEN DO:
  lRet = FALSE.
  
  {&FIND_TABLE2_BY_NAME} joinTable NO-ERROR.
  IF AVAILABLE qbf-rel-buf2 THEN
    ASSIGN
      lRet    = TRUE
      joinNum = qbf-rel-buf2.tid
    .
  IF lRet = FALSE THEN
    RETURN.
END.
/*
 * We found the name, now set the information. We create a new row in the
 * case when a user is building a query programatically. If a client is
 * adding info to a table that isn't part of the query (ie not in qbf-tables)
 * then the info is never used.
 */

FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = tableNum NO-ERROR.

/* If there's no information about the table then make a new row */
IF NOT AVAILABLE qbf-where THEN DO:

  CREATE qbf-where.
  ASSIGN
    qbf-where.qbf-wtbl = tableNum
    qbf-where.qbf-wojo = FALSE
    qbf-where.qbf-wrid = STRING(joinNum)
    .
END.

IF joinInfo     <> ? THEN
  qbf-where.qbf-wrel = joinInfo.
IF whereInfo    <> ? THEN
  qbf-where.qbf-wcls = whereInfo.
IF whereAsk     <> ? THEN
  qbf-where.qbf-wask = whereAsk.
IF includedCode <> ? THEN
  qbf-where.qbf-winc = includedCode.

/* vstbi.p - end of file */

