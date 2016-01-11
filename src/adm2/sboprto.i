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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\sboprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\sbo.p at 14:25 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE addDataTarget IN SUPER:
  DEFINE INPUT PARAMETER phTarget AS HANDLE.
END PROCEDURE.

PROCEDURE addNavigationSource IN SUPER:
  DEFINE INPUT PARAMETER phSource AS HANDLE.
END PROCEDURE.

PROCEDURE assignMaxGuess IN SUPER:
  DEFINE INPUT PARAMETER piMaxGuess AS INTEGER.
END PROCEDURE.

PROCEDURE commitTransaction IN SUPER:
END PROCEDURE.

PROCEDURE confirmContinue IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL.
END PROCEDURE.

PROCEDURE dataAvailable IN SUPER:
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER.
END PROCEDURE.

PROCEDURE deleteComplete IN SUPER:
END PROCEDURE.

PROCEDURE destroyServerObject IN SUPER:
END PROCEDURE.

PROCEDURE endClientDataRequest IN SUPER:
END PROCEDURE.

PROCEDURE fetchBatch IN SUPER:
  DEFINE INPUT PARAMETER plForwards AS LOGICAL.
END PROCEDURE.

PROCEDURE fetchContainedData IN SUPER:
  DEFINE INPUT PARAMETER pcObject AS CHARACTER.
END PROCEDURE.

PROCEDURE fetchContainedRows IN SUPER:
  DEFINE INPUT PARAMETER pcObject AS CHARACTER.
  DEFINE INPUT PARAMETER piStartRow AS INTEGER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS LOGICAL.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
END PROCEDURE.

PROCEDURE fetchDOProperties IN SUPER:
END PROCEDURE.

PROCEDURE fetchFirst IN SUPER:
END PROCEDURE.

PROCEDURE fetchLast IN SUPER:
END PROCEDURE.

PROCEDURE fetchNext IN SUPER:
END PROCEDURE.

PROCEDURE fetchPrev IN SUPER:
END PROCEDURE.

PROCEDURE getContextAndDestroy IN SUPER:
  DEFINE OUTPUT PARAMETER pcContainedProps AS CHARACTER.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeServerObject IN SUPER:
END PROCEDURE.

PROCEDURE isUpdatePending IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL.
END PROCEDURE.

PROCEDURE postCreateObjects IN SUPER:
END PROCEDURE.

PROCEDURE prepareErrorsForReturn IN SUPER:
  DEFINE INPUT PARAMETER pcReturnValue AS CHARACTER.
  DEFINE INPUT PARAMETER pcASDivision AS CHARACTER.
  DEFINE INPUT-OUTPUT PARAMETER pcMessages AS CHARACTER.
END PROCEDURE.

PROCEDURE prepareQueriesForFetch IN SUPER:
  DEFINE INPUT PARAMETER pcObjectName AS CHARACTER.
  DEFINE INPUT PARAMETER pcOptions AS CHARACTER.
  DEFINE OUTPUT PARAMETER pocQueries AS CHARACTER.
  DEFINE OUTPUT PARAMETER poctempTables AS CHARACTER.
END PROCEDURE.

PROCEDURE queryPosition IN SUPER:
  DEFINE INPUT PARAMETER pcPosition AS CHARACTER.
END PROCEDURE.

PROCEDURE registerObject IN SUPER:
END PROCEDURE.

PROCEDURE restartServerObject IN SUPER:
END PROCEDURE.

PROCEDURE serverContainedSendRows IN SUPER:
  DEFINE INPUT PARAMETER piStartRow AS INTEGER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS LOGICAL.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE INPUT PARAMETER pcObjectName AS CHARACTER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject.
END PROCEDURE.

PROCEDURE serverFetchContainedData IN SUPER:
  DEFINE INPUT PARAMETER pcQueries AS CHARACTER.
  DEFINE INPUT PARAMETER pcPositions AS CHARACTER.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject20.
END PROCEDURE.

PROCEDURE serverFetchContainedRows IN SUPER:
  DEFINE INPUT PARAMETER pcQueries AS CHARACTER.
  DEFINE INPUT PARAMETER piStartRow AS CHARACTER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS CHARACTER.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE  phRowObject20.
END PROCEDURE.

PROCEDURE serverFetchDOProperties IN SUPER:
  DEFINE OUTPUT PARAMETER pcPropList AS CHARACTER.
END PROCEDURE.

PROCEDURE setContextAndInitialize IN SUPER:
  DEFINE INPUT PARAMETER pcContainedProps AS CHARACTER.
END PROCEDURE.

PROCEDURE setPropertyList IN SUPER:
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER.
END PROCEDURE.

PROCEDURE startServerObject IN SUPER:
END PROCEDURE.

PROCEDURE undoTransaction IN SUPER:
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

FUNCTION addQueryWhere RETURNS LOGICAL
  (INPUT pcWhere AS CHARACTER,
   INPUT pcObject AS CHARACTER,
   INPUT pcAndOr AS CHARACTER) IN SUPER.

FUNCTION addRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION assignContainedProperties RETURNS LOGICAL
  (INPUT pcPropValues AS CHARACTER,
   INPUT pcReplace AS CHARACTER) IN SUPER.

FUNCTION assignCurrentMappedObject RETURNS LOGICAL
  (INPUT phRequester AS HANDLE,
   INPUT pcObjectName AS CHARACTER) IN SUPER.

FUNCTION assignQuerySelection RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION cancelRow RETURNS CHARACTER IN SUPER.

FUNCTION canNavigate RETURNS LOGICAL IN SUPER.

FUNCTION columnColumnLabel RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnDataType RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnDbColumn RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnExtent RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnFormat RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnHelp RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnInitial RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnLabel RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnMandatory RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnModified RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnObjectHandle RETURNS HANDLE
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnPrivateData RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnQuerySelection RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnReadOnly RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnStringValue RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnTable RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValExp RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValMsg RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnValue RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnWidth RETURNS DECIMAL
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION colValues RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION containedProperties RETURNS CHARACTER
  (INPUT pcQueryProps AS CHARACTER,
   INPUT plDeep AS LOGICAL) IN SUPER.

FUNCTION copyRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION currentMappedObject RETURNS CHARACTER
  (INPUT phRequester AS HANDLE) IN SUPER.

FUNCTION dataObjectHandle RETURNS HANDLE
  (INPUT pcObjectName AS CHARACTER) IN SUPER.

FUNCTION deleteRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

FUNCTION getTargetProcedure RETURNS HANDLE IN SUPER.

FUNCTION openQuery RETURNS LOGICAL IN SUPER.

FUNCTION removeQuerySelection RETURNS LOGICAL
  (INPUT pcColumns AS CHARACTER,
   INPUT pcOperators AS CHARACTER) IN SUPER.

FUNCTION resetQuery RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION submitRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER,
   INPUT pcValueList AS CHARACTER) IN SUPER.



