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
 * Prototype include file: C:\astra\object\dev\src\adm2\cntnprto.i
 * Created from procedure: C:\astra\object\dev\src\adm2\containr.p at 14:06 on 26/04/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE assignPageProperty IN SUPER:
  DEFINE INPUT PARAMETER pcProp AS CHARACTER.
  DEFINE INPUT PARAMETER pcValue AS CHARACTER.
END PROCEDURE.

PROCEDURE changePage IN SUPER:
END PROCEDURE.

PROCEDURE confirmExit IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL.
END PROCEDURE.

PROCEDURE constructObject IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
  DEFINE INPUT PARAMETER phParent AS HANDLE.
  DEFINE INPUT PARAMETER pcPropList AS CHARACTER.
  DEFINE OUTPUT PARAMETER phObject AS HANDLE.
END PROCEDURE.

PROCEDURE createObjects IN SUPER:
END PROCEDURE.

PROCEDURE deletePage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE hidePage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeVisualContainer IN SUPER:
END PROCEDURE.

PROCEDURE initPages IN SUPER:
  DEFINE INPUT PARAMETER pcPageList AS CHARACTER.
END PROCEDURE.

PROCEDURE notifyPage IN SUPER:
  DEFINE INPUT PARAMETER pcProc AS CHARACTER.
END PROCEDURE.

PROCEDURE passThrough IN SUPER:
  DEFINE INPUT PARAMETER pcLinkName AS CHARACTER.
  DEFINE INPUT PARAMETER pcArgument AS CHARACTER.
END PROCEDURE.

PROCEDURE removePageNTarget IN SUPER:
  DEFINE INPUT PARAMETER phTarget AS HANDLE.
  DEFINE INPUT PARAMETER piPage AS INTEGER.
END PROCEDURE.

PROCEDURE selectPage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

PROCEDURE toolbar IN SUPER:
  DEFINE INPUT PARAMETER pcValue AS CHARACTER.
END PROCEDURE.

PROCEDURE viewObject IN SUPER:
END PROCEDURE.

PROCEDURE viewPage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

FUNCTION disablePagesInFolder RETURNS LOGICAL
  (INPUT pcPageInformation AS CHARACTER) IN SUPER.

FUNCTION enablePagesInFolder RETURNS LOGICAL
  (INPUT pcPageInformation AS CHARACTER) IN SUPER.

FUNCTION getCallerProcedure RETURNS HANDLE IN SUPER.

FUNCTION getCallerWindow RETURNS HANDLE IN SUPER.

FUNCTION getContainerMode RETURNS CHARACTER IN SUPER.

FUNCTION getContainerTarget RETURNS CHARACTER IN SUPER.

FUNCTION getContainerTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getCurrentPage RETURNS INTEGER IN SUPER.

FUNCTION getDisabledAddModeTabs RETURNS CHARACTER IN SUPER.

FUNCTION getDynamicSDOProcedure RETURNS CHARACTER IN SUPER.

FUNCTION getFilterSource RETURNS HANDLE IN SUPER.

FUNCTION getMultiInstanceActivated RETURNS LOGICAL IN SUPER.

FUNCTION getMultiInstanceSupported RETURNS LOGICAL IN SUPER.

FUNCTION getNavigationSource RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationTarget RETURNS HANDLE IN SUPER.

FUNCTION getOutMessageTarget RETURNS HANDLE IN SUPER.

FUNCTION getPageNTarget RETURNS CHARACTER IN SUPER.

FUNCTION getPageSource RETURNS HANDLE IN SUPER.

FUNCTION getPrimarySdoTarget RETURNS HANDLE IN SUPER.

FUNCTION getReEnableDataLinks RETURNS CHARACTER IN SUPER.

FUNCTION getRunDOOptions RETURNS CHARACTER IN SUPER.

FUNCTION getRunMultiple RETURNS LOGICAL IN SUPER.

FUNCTION getSavedContainerMode RETURNS CHARACTER IN SUPER.

FUNCTION getSdoForeignFields RETURNS CHARACTER IN SUPER.

FUNCTION getTopOnly RETURNS LOGICAL IN SUPER.

FUNCTION getUpdateSource RETURNS CHARACTER IN SUPER.

FUNCTION getUpdateTarget RETURNS CHARACTER IN SUPER.

FUNCTION getWaitForObject RETURNS HANDLE IN SUPER.

FUNCTION getWindowTitleViewer RETURNS HANDLE IN SUPER.

FUNCTION getStatusArea RETURNS LOGICAL IN SUPER.

FUNCTION pageNTargets RETURNS CHARACTER
  (INPUT phTarget AS HANDLE,
   INPUT piPageNum AS INTEGER) IN SUPER.

FUNCTION setCallerObject RETURNS LOGICAL
  (INPUT h AS HANDLE) IN SUPER.

FUNCTION setCallerProcedure RETURNS LOGICAL
  (INPUT h AS HANDLE) IN SUPER.

FUNCTION setCallerWindow RETURNS LOGICAL
  (INPUT h AS HANDLE) IN SUPER.

FUNCTION setContainerMode RETURNS LOGICAL
  (INPUT cContainerMode AS CHARACTER) IN SUPER.

FUNCTION setContainerTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setCurrentPage RETURNS LOGICAL
  (INPUT iPage AS INTEGER) IN SUPER.

FUNCTION setDisabledAddModeTabs RETURNS LOGICAL
  (INPUT cDisabledAddModeTabs AS CHARACTER) IN SUPER.

FUNCTION setDynamicSDOProcedure RETURNS LOGICAL
  (INPUT pcProc AS CHARACTER) IN SUPER.

FUNCTION setFilterSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setInMessageTarget RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setMultiInstanceActivated RETURNS LOGICAL
  (INPUT lMultiInstanceActivated AS LOGICAL) IN SUPER.

FUNCTION setMultiInstanceSupported RETURNS LOGICAL
  (INPUT lMultiInstanceSupported AS LOGICAL) IN SUPER.

FUNCTION setNavigationSource RETURNS LOGICAL
  (INPUT pcSource AS CHARACTER) IN SUPER.

FUNCTION setNavigationSourceEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setNavigationTarget RETURNS LOGICAL
  (INPUT cTarget AS CHARACTER) IN SUPER.

FUNCTION setOutMessageTarget RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setPageNTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setPageSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setPrimarySdoTarget RETURNS LOGICAL
  (INPUT hPrimarySdoTarget AS HANDLE) IN SUPER.

FUNCTION setReEnableDataLinks RETURNS LOGICAL
  (INPUT cReEnableDataLinks AS CHARACTER) IN SUPER.

FUNCTION setRouterTarget RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setRunDOOptions RETURNS LOGICAL
  (INPUT pcOptions AS CHARACTER) IN SUPER.

FUNCTION setRunMultiple RETURNS LOGICAL
  (INPUT plMultiple AS LOGICAL) IN SUPER.

FUNCTION setSavedContainerMode RETURNS LOGICAL
  (INPUT cSavedContainerMode AS CHARACTER) IN SUPER.

FUNCTION setSdoForeignFields RETURNS LOGICAL
  (INPUT cSdoForeignFields AS CHARACTER) IN SUPER.

FUNCTION setTopOnly RETURNS LOGICAL
  (INPUT plTopOnly AS LOGICAL) IN SUPER.

FUNCTION setUpdateSource RETURNS LOGICAL
  (INPUT pcSource AS CHARACTER) IN SUPER.

FUNCTION setUpdateTarget RETURNS LOGICAL
  (INPUT pcTarget AS CHARACTER) IN SUPER.

FUNCTION setWaitForObject RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setWindowTitleViewer RETURNS LOGICAL
  (INPUT phViewer AS HANDLE) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

FUNCTION setStatusArea RETURNS LOGICAL
  (INPUT plStatusArea AS LOGICAL) IN SUPER.

