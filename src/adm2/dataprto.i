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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\dataprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\data.p at 14:17 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE batchServices IN SUPER:
  DEFINE INPUT PARAMETER pcServices AS CHARACTER.
  DEFINE OUTPUT PARAMETER pcValues AS CHARACTER.
END PROCEDURE.

PROCEDURE clientSendRows IN SUPER:
  DEFINE INPUT PARAMETER piStartRow AS INTEGER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS LOGICAL.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
END PROCEDURE.

PROCEDURE commitTransaction IN SUPER:
END PROCEDURE.

PROCEDURE copyColumns IN SUPER:
  DEFINE INPUT PARAMETER pcViewColList AS CHARACTER.
  DEFINE INPUT PARAMETER phDataQuery AS HANDLE.
END PROCEDURE.

PROCEDURE dataAvailable IN SUPER:
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER.
END PROCEDURE.

PROCEDURE describeSchema IN SUPER:
  DEFINE INPUT PARAMETER pcSdoName AS CHARACTER.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  hTtSchema.
END PROCEDURE.

PROCEDURE destroyServerObject IN SUPER:
END PROCEDURE.

PROCEDURE endClientDataRequest IN SUPER:
END PROCEDURE.

PROCEDURE fetchBatch IN SUPER:
  DEFINE INPUT PARAMETER plForwards AS LOGICAL.
END PROCEDURE.

PROCEDURE fetchFirst IN SUPER:
END PROCEDURE.

PROCEDURE fetchLast IN SUPER:
END PROCEDURE.

PROCEDURE fetchNext IN SUPER:
END PROCEDURE.

PROCEDURE fetchPrev IN SUPER:
END PROCEDURE.

PROCEDURE genContextList IN SUPER:
  DEFINE OUTPUT PARAMETER pcContext AS CHARACTER.
END PROCEDURE.

PROCEDURE home IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeServerObject IN SUPER:
END PROCEDURE.

PROCEDURE isUpdatePending IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL.
END PROCEDURE.

PROCEDURE printToCrystal IN SUPER:
  DEFINE INPUT PARAMETER pcFieldList AS CHARACTER.
  DEFINE INPUT PARAMETER plIncludeObj AS LOGICAL.
  DEFINE INPUT PARAMETER piMaxRecords AS INTEGER.
END PROCEDURE.

PROCEDURE refreshRow IN SUPER:
END PROCEDURE.

PROCEDURE restartServerObject IN SUPER:
END PROCEDURE.

PROCEDURE retrieveFilter IN SUPER:
END PROCEDURE.

PROCEDURE rowObjectState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE saveContextAndDestroy IN SUPER:
  DEFINE OUTPUT PARAMETER pcContext AS CHARACTER.
END PROCEDURE.

PROCEDURE sendRows IN SUPER:
  DEFINE INPUT PARAMETER piStartRow AS INTEGER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS LOGICAL.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
END PROCEDURE.

PROCEDURE serverFetchRowObjUpdTable IN SUPER:
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObjUpd.
END PROCEDURE.

PROCEDURE setPropertyList IN SUPER:
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER.
END PROCEDURE.

PROCEDURE startServerObject IN SUPER:
END PROCEDURE.

PROCEDURE submitCommit IN SUPER:
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plReopen AS LOGICAL.
END PROCEDURE.

PROCEDURE submitForeignKey IN SUPER:
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT-OUTPUT PARAMETER pcValueList AS CHARACTER.
  DEFINE INPUT-OUTPUT PARAMETER pcUpdColumns AS CHARACTER.
END PROCEDURE.

PROCEDURE submitValidation IN SUPER:
  DEFINE INPUT PARAMETER pcValueList AS CHARACTER.
  DEFINE INPUT PARAMETER pcUpdColumns AS CHARACTER.
END PROCEDURE.

PROCEDURE synchronizeProperties IN SUPER:
  DEFINE INPUT PARAMETER pcPropertiesForServer AS CHARACTER.
  DEFINE OUTPUT PARAMETER pcPropertiesForClient AS CHARACTER.
END PROCEDURE.
/*
PROCEDURE tableOut IN SUPER:
  DEFINE INPUT PARAMETER pcFieldList AS CHARACTER.
  DEFINE INPUT PARAMETER plIncludeObj AS LOGICAL.
  DEFINE INPUT PARAMETER piMaxRecords AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE FOR ttTable.
  DEFINE OUTPUT PARAMETER iExtractedRecs AS INTEGER.
END PROCEDURE.
*/
PROCEDURE transferToExcel IN SUPER:
  DEFINE INPUT PARAMETER pcFieldList AS CHARACTER.
  DEFINE INPUT PARAMETER plIncludeObj AS LOGICAL.
  DEFINE INPUT PARAMETER plUseExisting AS LOGICAL.
  DEFINE INPUT PARAMETER piMaxRecords AS INTEGER.
END PROCEDURE.

PROCEDURE undoTransaction IN SUPER:
END PROCEDURE.

PROCEDURE updateAddQueryWhere IN SUPER:
  DEFINE INPUT PARAMETER pcWhere AS CHARACTER.
  DEFINE INPUT PARAMETER pcField AS CHARACTER.
END PROCEDURE.

PROCEDURE updateManualForeignFields IN SUPER:
END PROCEDURE.

PROCEDURE updateQueryPosition IN SUPER:
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

FUNCTION addRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION cancelRow RETURNS CHARACTER IN SUPER.

FUNCTION canNavigate RETURNS LOGICAL IN SUPER.

FUNCTION closeQuery RETURNS LOGICAL IN SUPER.

FUNCTION columnProps RETURNS CHARACTER
  (INPUT pcColList AS CHARACTER,
   INPUT pcPropList AS CHARACTER) IN SUPER.

FUNCTION colValues RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION copyRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION createRow RETURNS LOGICAL
  (INPUT pcValueList AS CHARACTER) IN SUPER.

FUNCTION deleteRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER) IN SUPER.

FUNCTION fetchRow RETURNS CHARACTER
  (INPUT piRow AS INTEGER,
   INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION fetchRowIdent RETURNS CHARACTER
  (INPUT pcRowIdent AS CHARACTER,
   INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION findRow RETURNS LOGICAL
  (INPUT pcKeyValues AS CHARACTER) IN SUPER.

FUNCTION findRowWhere RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION firstRowIds RETURNS CHARACTER
  (INPUT pcQueryString AS CHARACTER) IN SUPER.

FUNCTION hasForeignKeyChanged RETURNS LOGICAL IN SUPER.

FUNCTION openDataQuery RETURNS LOGICAL
  (INPUT pcPosition AS CHARACTER) IN SUPER.

FUNCTION openQuery RETURNS LOGICAL IN SUPER.

FUNCTION prepareQuery RETURNS LOGICAL
  (INPUT pcQuery AS CHARACTER) IN SUPER.

FUNCTION rowAvailable RETURNS LOGICAL
  (INPUT pcDirection AS CHARACTER) IN SUPER.

FUNCTION rowValues RETURNS CHARACTER
  (INPUT pcColumns AS CHARACTER,
   INPUT pcFormat AS CHARACTER,
   INPUT pcDelimiter AS CHARACTER) IN SUPER.

FUNCTION submitRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER,
   INPUT pcValueList AS CHARACTER) IN SUPER.

FUNCTION updateRow RETURNS LOGICAL
  (INPUT pcKeyValues AS CHARACTER,
   INPUT pcValueList AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.
