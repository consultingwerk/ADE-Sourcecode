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
 * Prototype include file: C:\1a\src\adm2\qryprto.i
 * Created from procedure: C:\1a\adm2\query.p at 22:04 on 11/21/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE transferDBRow IN SUPER:
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER piRowNum AS INTEGER.
END PROCEDURE.

PROCEDURE startFilter IN SUPER:
END PROCEDURE.

PROCEDURE releaseDBRow IN SUPER:
END PROCEDURE.

PROCEDURE refetchDBRow IN SUPER:
  DEFINE INPUT PARAMETER phRowObjUpd AS HANDLE.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE fetchPrev IN SUPER:
END PROCEDURE.

PROCEDURE fetchNext IN SUPER:
END PROCEDURE.

PROCEDURE fetchLast IN SUPER:
END PROCEDURE.

PROCEDURE fetchFirst IN SUPER:
END PROCEDURE.

PROCEDURE fetchDBRowForUpdate IN SUPER:
END PROCEDURE.

PROCEDURE dataAvailable IN SUPER:
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER.
END PROCEDURE.

PROCEDURE confirmContinue IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL.
END PROCEDURE.

PROCEDURE compareDBRow IN SUPER:
END PROCEDURE.

PROCEDURE bufferCopyDBToRO IN SUPER:
  DEFINE INPUT PARAMETER phRowObj AS HANDLE.
  DEFINE INPUT PARAMETER phBuffer AS HANDLE.
  DEFINE INPUT PARAMETER pcExcludes AS CHARACTER.
  DEFINE INPUT PARAMETER pcAssigns AS CHARACTER.
END PROCEDURE.

PROCEDURE assignDBRow IN SUPER:
  DEFINE INPUT PARAMETER phRowObjUpd AS HANDLE.
END PROCEDURE.

FUNCTION addQueryWhere RETURNS LOGICAL
  (INPUT pcWhere AS CHARACTER,
   INPUT pcBuffer AS CHARACTER,
   INPUT pcAndOr AS CHARACTER) IN SUPER.

FUNCTION assignQuerySelection RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION closeQuery RETURNS LOGICAL IN SUPER.

FUNCTION columnDataType RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnDbColumn RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnHandle RETURNS HANDLE
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnQuerySelection RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnTable RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValMsg RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION colValues RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION dbColumnDataName RETURNS CHARACTER
  (INPUT pcDbColumn AS CHARACTER) IN SUPER.

FUNCTION getAssignList RETURNS CHARACTER IN SUPER.

FUNCTION getCheckLastOnOpen RETURNS LOGICAL IN SUPER.

FUNCTION getDataColumns RETURNS CHARACTER IN SUPER.

FUNCTION getDataTarget RETURNS CHARACTER IN SUPER.

FUNCTION getDataTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getForeignFields RETURNS CHARACTER IN SUPER.

FUNCTION getForeignValues RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationSource RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getOpenOnInit RETURNS LOGICAL IN SUPER.

FUNCTION getOpenQuery RETURNS CHARACTER IN SUPER.

FUNCTION getQueryHandle RETURNS HANDLE IN SUPER.

FUNCTION getQueryOpen RETURNS LOGICAL IN SUPER.

FUNCTION getQueryPosition RETURNS CHARACTER IN SUPER.

FUNCTION getQuerySort RETURNS CHARACTER IN SUPER.

FUNCTION getQueryString RETURNS CHARACTER IN SUPER.

FUNCTION getQueryWhere RETURNS CHARACTER IN SUPER.

FUNCTION getTables RETURNS CHARACTER IN SUPER.

FUNCTION getUpdatableColumns RETURNS CHARACTER IN SUPER.

FUNCTION getUseDbQualifier RETURNS LOGICAL IN SUPER.

FUNCTION getWordIndexedFields RETURNS CHARACTER IN SUPER.

FUNCTION openQuery RETURNS LOGICAL IN SUPER.

FUNCTION prepareQuery RETURNS LOGICAL
  (INPUT pcQuery AS CHARACTER) IN SUPER.

FUNCTION removeQuerySelection RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION rowidWhere RETURNS CHARACTER
  (INPUT pcWhere AS CHARACTER) IN SUPER.

FUNCTION setAutoCommit RETURNS LOGICAL
  (INPUT plCommit AS LOGICAL) IN SUPER.

FUNCTION setCheckLastOnOpen RETURNS LOGICAL
  (INPUT pCheck AS LOGICAL) IN SUPER.

FUNCTION setDataTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setDataTargetEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setForeignFields RETURNS LOGICAL
  (INPUT pcFields AS CHARACTER) IN SUPER.

FUNCTION setNavigationSource RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setOpenOnInit RETURNS LOGICAL
  (INPUT plOpen AS LOGICAL) IN SUPER.

FUNCTION setOpenQuery RETURNS LOGICAL
  (INPUT pcQuery AS CHARACTER) IN SUPER.

FUNCTION setQueryPosition RETURNS LOGICAL
  (INPUT pcPosition AS CHARACTER) IN SUPER.

FUNCTION setQuerySort RETURNS LOGICAL
  (INPUT pcSort AS CHARACTER) IN SUPER.

FUNCTION setQueryString RETURNS LOGICAL
  (INPUT pcQueryString AS CHARACTER) IN SUPER.

FUNCTION setQueryWhere RETURNS LOGICAL
  (INPUT pcWhere AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

