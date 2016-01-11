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
/* * Prototype include file: C:\adm90\src\adm2\dataprto.i 
   * Created from procedure: C:\adm90\src\adm2\data.p at 14:21 on 02/09/99 
   * by the PROGRESS PRO*Tools Prototype Include File Generator */ 
/********* START excluded prototypes 

PROCEDURE updateState IN SUPER: 
  DEFINE INPUT PARAMETER pcState AS CHARACTER.  
END PROCEDURE.  

PROCEDURE rowObjectState IN SUPER: 
  DEFINE INPUT PARAMETER pcState AS CHARACTER.  
END PROCEDURE.  

PROCEDURE dataAvailable IN SUPER: 
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER.  
END PROCEDURE.  

PROCEDURE start-super-proc IN SUPER: 
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.  
END PROCEDURE.  

FUNCTION anyMessage RETURNS LOGICAL IN SUPER.  

FUNCTION messageNumber RETURNS LOGICAL
  (INPUT iMessage AS INTEGER) IN SUPER.

FUNCTION showMessage RETURNS LOGICAL
  (INPUT cMessage AS CHARACTER) IN SUPER.

FUNCTION assignColumnFormat RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcFormat AS CHARACTER) IN SUPER.

FUNCTION assignColumnHelp RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcHelp AS CHARACTER) IN SUPER.

FUNCTION assignColumnLabel RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcLabel AS CHARACTER) IN SUPER.

FUNCTION assignColumnMandatory RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT plMandatory AS LOGICAL) IN SUPER.

FUNCTION assignColumnPrivateData RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcData AS CHARACTER) IN SUPER.

FUNCTION assignColumnValExp RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcValExp AS CHARACTER) IN SUPER.

FUNCTION assignColumnValMsg RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcValMsg AS CHARACTER) IN SUPER.

FUNCTION getCommitSource RETURNS HANDLE IN SUPER.

FUNCTION getCommitSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getCommitTarget RETURNS CHARACTER IN SUPER.

FUNCTION getCommitTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getDataHandle RETURNS HANDLE IN SUPER.

FUNCTION getDataQueryBrowsed RETURNS LOGICAL IN SUPER.

FUNCTION getDestroyStateless RETURNS LOGICAL IN SUPER.

FUNCTION getDisconnectAppServer RETURNS LOGICAL IN SUPER.

FUNCTION getOpenQuery RETURNS CHARACTER IN SUPER.

FUNCTION getUpdateSource RETURNS HANDLE IN SUPER.

FUNCTION setAppService RETURNS LOGICAL
  (INPUT pcPartition AS CHARACTER) IN SUPER.

FUNCTION setASInfo RETURNS LOGICAL
  (INPUT pcInfo AS CHARACTER) IN SUPER.

FUNCTION setASUsePrompt RETURNS LOGICAL
  (INPUT plFlag AS LOGICAL) IN SUPER.

FUNCTION setCommitSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setCommitSourceEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setCommitTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setCommitTargetEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  (INPUT plBrowsed AS LOGICAL) IN SUPER.

FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOGICAL) IN SUPER.

FUNCTION setDisconnectAppserver RETURNS LOGICAL
  (plDisconnect AS LOGICAL) IN SUPER.

FUNCTION setUpdateSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

END excluded prototypes ********/

PROCEDURE batchServices IN SUPER:
  DEFINE INPUT PARAMETER pcServices AS CHARACTER.
  DEFINE OUTPUT PARAMETER pcValues AS CHARACTER.
END PROCEDURE.

PROCEDURE undoTransaction IN SUPER:
END PROCEDURE.

PROCEDURE sendRows IN SUPER:
  DEFINE INPUT PARAMETER piStartRow AS INTEGER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
  DEFINE INPUT PARAMETER plNext AS LOGICAL.
  DEFINE INPUT PARAMETER piRowsToReturn AS INTEGER.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER.
END PROCEDURE.

PROCEDURE refreshRow IN SUPER:
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

PROCEDURE fetchBatch IN SUPER:
  DEFINE INPUT PARAMETER plForwards AS LOGICAL.
END PROCEDURE.

PROCEDURE disconnectObject IN SUPER:
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE commitTransaction IN SUPER:
END PROCEDURE.

PROCEDURE synchronizeProperties IN SUPER:
  DEFINE INPUT PARAMETER pcPropertiesForServer AS CHARACTER.
  DEFINE OUTPUT PARAMETER pcPropertiesForClient AS CHARACTER.
END PROCEDURE.

FUNCTION addRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION cancelRow RETURNS CHARACTER IN SUPER.

FUNCTION closeQuery RETURNS LOGICAL IN SUPER.

FUNCTION columnDbColumn RETURNS CHARACTER
  (pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnDataType RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnExtent RETURNS INTEGER
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

FUNCTION columnPrivateData RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnProps RETURNS CHARACTER
  (INPUT pcColList AS CHARACTER,
   INPUT pcPropList AS CHARACTER) IN SUPER.

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

FUNCTION copyRow RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION dbColumnDataName RETURNS CHARACTER
  (pcDbColumn AS CHARACTER) IN SUPER.

FUNCTION deleteRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER) IN SUPER.

FUNCTION fetchRow RETURNS CHARACTER
  (INPUT piRow AS INTEGER,
   INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION fetchRowIdent RETURNS CHARACTER
  (INPUT pcRowIdent AS CHARACTER,
   INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION getAppService RETURNS CHARACTER IN SUPER.

FUNCTION getASDivision RETURNS CHARACTER IN SUPER.

FUNCTION getASHandle RETURNS HANDLE IN SUPER.

FUNCTION getASInfo RETURNS CHARACTER IN SUPER.

FUNCTION getASUsePrompt RETURNS LOGICAL IN SUPER.

FUNCTION getAutoCommit RETURNS LOGICAL IN SUPER.

FUNCTION getCheckCurrentChanged RETURNS LOGICAL IN SUPER.

FUNCTION getCurrentRowModified RETURNS LOGICAL IN SUPER.

FUNCTION getDataModified RETURNS LOGICAL IN SUPER.

FUNCTION getDataSignature RETURNS CHARACTER IN SUPER.

FUNCTION getEnabledTables RETURNS CHARACTER IN SUPER.

FUNCTION getFirstResultRow RETURNS CHARACTER IN SUPER.

FUNCTION getFirstRowNum RETURNS INTEGER IN SUPER.

FUNCTION getLastResultRow RETURNS CHARACTER IN SUPER.

FUNCTION getLastRowNum RETURNS INTEGER IN SUPER.

FUNCTION getMandatoryColumns RETURNS CHARACTER IN SUPER.

FUNCTION getNewRow RETURNS LOGICAL IN SUPER.

FUNCTION getQueryRowIdent RETURNS CHARACTER IN SUPER.

FUNCTION getQueryContext RETURNS CHARACTER IN SUPER.

FUNCTION getQueryWhere RETURNS CHARACTER IN SUPER.

FUNCTION getRebuildOnRepos RETURNS LOGICAL IN SUPER.

FUNCTION getRowIdent RETURNS CHARACTER IN SUPER.

FUNCTION getRowsToBatch RETURNS INTEGER IN SUPER.

FUNCTION getServerOperatingMode RETURNS CHARACTER IN SUPER.

FUNCTION getStatelessSavedProperties RETURNS CHARACTER IN SUPER.

FUNCTION getTables RETURNS CHARACTER IN SUPER.

FUNCTION openQuery RETURNS LOGICAL IN SUPER.

FUNCTION setAutoCommit RETURNS LOGICAL
  (INPUT plFlag AS LOGICAL) IN SUPER.

FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  (INPUT plCheck AS LOGICAL) IN SUPER.

FUNCTION setQueryRowIdent RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER) IN SUPER.

FUNCTION setQueryContext RETURNS LOGICAL
  (INPUT pcQueryContext AS CHARACTER) IN SUPER.

FUNCTION setRebuildOnRepos RETURNS LOGICAL
  (INPUT plRebuild AS LOGICAL) IN SUPER.

FUNCTION setRowsToBatch RETURNS LOGICAL
  (INPUT piRows AS INTEGER) IN SUPER.

FUNCTION setServerOperatingMode RETURNS LOGICAL
  (INPUT pcServerOperatingMode AS CHARACTER) IN SUPER.

FUNCTION submitRow RETURNS LOGICAL
  (INPUT pcRowIdent AS CHARACTER,
   INPUT pcValueList AS CHARACTER) IN SUPER.

