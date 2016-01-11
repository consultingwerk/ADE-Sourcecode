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
 * Prototype include file: C:\adm90\src\adm2\smrtprto.i
 * Created from procedure: C:\adm90\src\adm2\smart.p at 11:01 on 03/03/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

/**** Start of excluded prototypes

PROCEDURE viewObject IN SUPER:
END PROCEDURE.

PROCEDURE removeLink IN SUPER:
  DEFINE INPUT PARAMETER phSource AS HANDLE.
  DEFINE INPUT PARAMETER pcLink AS CHARACTER.
  DEFINE INPUT PARAMETER phTarget AS HANDLE.
END PROCEDURE.

PROCEDURE removeAllLinks IN SUPER:
END PROCEDURE.

PROCEDURE modifyUserLinks IN SUPER:
  DEFINE INPUT PARAMETER pcMod AS CHARACTER.
  DEFINE INPUT PARAMETER pcLinkName AS CHARACTER.
  DEFINE INPUT PARAMETER phObject AS HANDLE.
END PROCEDURE.

PROCEDURE modifyListProperty IN SUPER:
  DEFINE INPUT PARAMETER phCaller AS HANDLE.
  DEFINE INPUT PARAMETER pcMode AS CHARACTER.
  DEFINE INPUT PARAMETER pcListName AS CHARACTER.
  DEFINE INPUT PARAMETER pcListValue AS CHARACTER.
END PROCEDURE.

PROCEDURE hideObject IN SUPER:
END PROCEDURE.

PROCEDURE exitObject IN SUPER:
END PROCEDURE.

PROCEDURE editInstanceProperties IN SUPER:
END PROCEDURE.

PROCEDURE createControls IN SUPER:
END PROCEDURE.

PROCEDURE changeCursor IN SUPER:
  DEFINE INPUT PARAMETER pcCursor AS CHARACTER.
END PROCEDURE.

PROCEDURE applyEntry IN SUPER:
  DEFINE INPUT PARAMETER pcField AS CHARACTER.
END PROCEDURE.

PROCEDURE adjustTabOrder IN SUPER:
  DEFINE INPUT PARAMETER phObject AS HANDLE.
  DEFINE INPUT PARAMETER phAnchor AS HANDLE.
  DEFINE INPUT PARAMETER pcPosition AS CHARACTER.
END PROCEDURE.

PROCEDURE addMessage IN SUPER:
  DEFINE INPUT PARAMETER pcText AS CHARACTER.
  DEFINE INPUT PARAMETER pcField AS CHARACTER.
  DEFINE INPUT PARAMETER pcTable AS CHARACTER.
END PROCEDURE.

PROCEDURE addLink IN SUPER:
  DEFINE INPUT PARAMETER phSource AS HANDLE.
  DEFINE INPUT PARAMETER pcLink AS CHARACTER.
  DEFINE INPUT PARAMETER phTarget AS HANDLE.
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION assignLinkProperty RETURNS LOGICAL
  (INPUT pcLink AS CHARACTER,
   INPUT pcPropName AS CHARACTER,
   INPUT pcPropValue AS CHARACTER) IN SUPER.

FUNCTION getContainerHandle RETURNS HANDLE IN SUPER.

FUNCTION getContainerHidden RETURNS LOGICAL IN SUPER.

FUNCTION getContainerSource RETURNS HANDLE IN SUPER.

FUNCTION getContainerSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getContainerType RETURNS CHARACTER IN SUPER.

FUNCTION getDataSource RETURNS HANDLE IN SUPER.

FUNCTION getDataSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getDBAware RETURNS LOGICAL IN SUPER.

FUNCTION getInstanceProperties RETURNS CHARACTER IN SUPER.

FUNCTION getObjectHidden RETURNS LOGICAL IN SUPER.

FUNCTION getObjectInitialized RETURNS LOGICAL IN SUPER.

FUNCTION getObjectPage RETURNS INTEGER IN SUPER.

FUNCTION getObjectParent RETURNS HANDLE IN SUPER.

FUNCTION getPassThroughLinks RETURNS CHARACTER IN SUPER.

FUNCTION getPropertyDialog RETURNS CHARACTER IN SUPER.

FUNCTION getQueryObject RETURNS LOGICAL IN SUPER.

FUNCTION getSupportedLinks RETURNS CHARACTER IN SUPER.

FUNCTION getTranslatableProperties RETURNS CHARACTER IN SUPER.

FUNCTION instancePropertyList RETURNS CHARACTER
  (INPUT pcPropList AS CHARACTER) IN SUPER.

FUNCTION linkProperty RETURNS CHARACTER
  (INPUT pcLink AS CHARACTER,
   INPUT pcPropName AS CHARACTER) IN SUPER.

FUNCTION propertyType RETURNS CHARACTER
  (INPUT pcPropName AS CHARACTER) IN SUPER.

FUNCTION reviewMessages RETURNS CHARACTER IN SUPER.

FUNCTION setContainerSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setDataSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setDataSourceEvents RETURNS LOGICAL
  (INPUT pcEventsList AS CHARACTER) IN SUPER.

FUNCTION setDBAware RETURNS LOGICAL
  (INPUT lAware AS LOGICAL) IN SUPER.

FUNCTION setInstanceProperties RETURNS LOGICAL
  (INPUT pcPropList AS CHARACTER) IN SUPER.

FUNCTION setObjectParent RETURNS LOGICAL
  (INPUT phParent AS HANDLE) IN SUPER.

FUNCTION setPassThroughLinks RETURNS LOGICAL
  (INPUT pcLinks AS CHARACTER) IN SUPER.

FUNCTION setSupportedLinks RETURNS LOGICAL
  (INPUT pcLinkList AS CHARACTER) IN SUPER.

FUNCTION setTranslatableProperties RETURNS LOGICAL
  (INPUT pcPropList AS CHARACTER) IN SUPER.

FUNCTION setUIBMode RETURNS LOGICAL
  (INPUT pcMode AS CHARACTER) IN SUPER.

FUNCTION showMessage RETURNS LOGICAL
  (INPUT pcMessage AS CHARACTER) IN SUPER.

FUNCTION Signature RETURNS CHARACTER
  (INPUT pcName AS CHARACTER) IN SUPER.

END of excluded prototypes **********/

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE displayLinks IN SUPER:
END PROCEDURE.

/* Don't even think about removing this. It's required for the AB */
PROCEDURE repositionObject IN SUPER:
  DEFINE INPUT PARAMETER pdRow AS DECIMAL.
  DEFINE INPUT PARAMETER pdCol AS DECIMAL.
END PROCEDURE.

FUNCTION anyMessage RETURNS LOGICAL IN SUPER.

FUNCTION fetchMessages RETURNS CHARACTER IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

FUNCTION getObjectVersion RETURNS CHARACTER IN SUPER.

FUNCTION getUIBMode RETURNS CHARACTER IN SUPER.

FUNCTION linkHandles RETURNS CHARACTER
  (INPUT pcLink AS CHARACTER) IN SUPER.

FUNCTION messageNumber RETURNS CHARACTER
  (INPUT piMessage AS INTEGER) IN SUPER.

FUNCTION getUserProperty RETURNS CHARACTER
  (INPUT pcPropName AS CHARACTER) IN SUPER.

FUNCTION setUserProperty RETURNS LOGICAL
  (INPUT pcPropName AS CHARACTER,
   INPUT pcPropValue AS CHARACTER) IN SUPER.

