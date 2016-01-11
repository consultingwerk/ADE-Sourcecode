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
 * Prototype include file: src\adm2\toolprto.i
 * Created from procedure: src\adm2\toolbar.p at 21:35 on 12/14/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE filterState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE linkState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE onChoose IN SUPER:
  DEFINE INPUT PARAMETER pcAction AS CHARACTER.
END PROCEDURE.

PROCEDURE onMenuDrop IN SUPER:
  DEFINE INPUT PARAMETER pcAction AS CHARACTER.
END PROCEDURE.

PROCEDURE onValueChanged IN SUPER:
  DEFINE INPUT PARAMETER pcAction AS CHARACTER.
END PROCEDURE.

PROCEDURE queryPosition IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE repositionObject IN SUPER:
  DEFINE INPUT PARAMETER pdRow AS DECIMAL.
  DEFINE INPUT PARAMETER pdCol AS DECIMAL.
END PROCEDURE.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL.
  DEFINE INPUT PARAMETER pdWidth AS DECIMAL.
END PROCEDURE.

PROCEDURE rowObjectState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE runInfo IN SUPER:
  DEFINE INPUT PARAMETER pcAction AS CHARACTER.
  DEFINE OUTPUT PARAMETER pocProcedure AS CHARACTER.
  DEFINE OUTPUT PARAMETER pocParam AS CHARACTER.
END PROCEDURE.

PROCEDURE setButtons IN SUPER:
  DEFINE INPUT PARAMETER pcPanelState AS CHARACTER.
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

FUNCTION actionCanRun RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionChecked RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionPublishCreate RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionTarget RETURNS HANDLE
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION assignMenuKeys RETURNS LOGICAL
  (INPUT pcActions AS CHARACTER,
   INPUT pcLabels AS CHARACTER) IN SUPER.

FUNCTION buildMenu RETURNS LOGICAL
  (INPUT pcParent AS CHARACTER) IN SUPER.

FUNCTION create3DRule RETURNS HANDLE
  (INPUT phParent AS HANDLE,
   INPUT-OUTPUT piX AS INTEGER) IN SUPER.

FUNCTION createButton RETURNS HANDLE
  (INPUT phParent AS HANDLE,
   INPUT-OUTPUT piX AS INTEGER,
   INPUT pcName AS CHARACTER,
   INPUT pcLabel AS CHARACTER,
   INPUT pcCaption AS CHARACTER,
   INPUT pcBitmap AS CHARACTER,
   INPUT plSensitive AS LOGICAL) IN SUPER.

FUNCTION createMenuBar RETURNS HANDLE IN SUPER.

FUNCTION createMenuItem RETURNS HANDLE
  (INPUT phParent AS HANDLE,
   INPUT pcName AS CHARACTER,
   INPUT pcCaption AS CHARACTER,
   INPUT pcAccelerator AS CHARACTER,
   INPUT plSensitive AS LOGICAL) IN SUPER.

FUNCTION createMenuToggle RETURNS HANDLE
  (INPUT phParent AS HANDLE,
   INPUT pcName AS CHARACTER,
   INPUT pcCaption AS CHARACTER,
   INPUT pcAccelerator AS CHARACTER,
   INPUT plSensitive AS LOGICAL) IN SUPER.

FUNCTION createRule RETURNS HANDLE
  (INPUT phParent AS HANDLE) IN SUPER.

FUNCTION createSubMenu RETURNS HANDLE
  (INPUT phParent AS HANDLE,
   INPUT pcName AS CHARACTER,
   INPUT pcCaption AS CHARACTER,
   INPUT plSensitive AS LOGICAL) IN SUPER.

FUNCTION createToolBar RETURNS LOGICAL
  (INPUT pcActions AS CHARACTER) IN SUPER.

FUNCTION deleteMenu RETURNS LOGICAL IN SUPER.

FUNCTION deleteToolbar RETURNS LOGICAL IN SUPER.

FUNCTION disableActions RETURNS LOGICAL
  (INPUT pcActions AS CHARACTER) IN SUPER.

FUNCTION enableActions RETURNS LOGICAL
  (INPUT pcActions AS CHARACTER) IN SUPER.

FUNCTION getActionGroups RETURNS CHARACTER IN SUPER.

FUNCTION getAvailMenuActions RETURNS CHARACTER IN SUPER.

FUNCTION getAvailToolbarActions RETURNS CHARACTER IN SUPER.

FUNCTION getCommitTarget RETURNS CHARACTER IN SUPER.

FUNCTION getCommitTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getDisabledActions RETURNS CHARACTER IN SUPER.

FUNCTION getFlatButtons RETURNS LOGICAL IN SUPER.

FUNCTION getImagePath RETURNS CHARACTER IN SUPER.

FUNCTION getMenu RETURNS LOGICAL IN SUPER.

FUNCTION getNavigationTarget RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getShowBorder RETURNS LOGICAL IN SUPER.

FUNCTION getSubModules RETURNS CHARACTER IN SUPER.

FUNCTION getTableioTarget RETURNS CHARACTER IN SUPER.

FUNCTION getTableioTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getTableIOType RETURNS CHARACTER IN SUPER.

FUNCTION getToolbar RETURNS LOGICAL IN SUPER.

FUNCTION getToolbarHeightPxl RETURNS INTEGER IN SUPER.

FUNCTION getWindow RETURNS HANDLE IN SUPER.

FUNCTION insertMenu RETURNS LOGICAL
  (INPUT pcParent AS CHARACTER,
   INPUT pcActions AS CHARACTER,
   INPUT plExpand AS LOGICAL,
   INPUT pcBefore AS CHARACTER) IN SUPER.

FUNCTION modifyDisabledActions RETURNS LOGICAL
  (INPUT pcMode AS CHARACTER,
   INPUT pcActions AS CHARACTER) IN SUPER.

FUNCTION setActionGroups RETURNS LOGICAL
  (INPUT pcActionGroups AS CHARACTER) IN SUPER.

FUNCTION setAvailMenuActions RETURNS LOGICAL
  (INPUT pcAvailMenuActions AS CHARACTER) IN SUPER.

FUNCTION setAvailToolbarActions RETURNS LOGICAL
  (INPUT pcAvailToolbarActions AS CHARACTER) IN SUPER.

FUNCTION setCommitTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setCommitTargetEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setDisabledActions RETURNS LOGICAL
  (INPUT pcActions AS CHARACTER) IN SUPER.

FUNCTION setFlatButtons RETURNS LOGICAL
  (INPUT plFlatButtons AS LOGICAL) IN SUPER.

FUNCTION setImagePath RETURNS LOGICAL IN SUPER.

FUNCTION setMenu RETURNS LOGICAL
  (INPUT plMenu AS LOGICAL) IN SUPER.

FUNCTION setNavigationButtons RETURNS LOGICAL
  (INPUT pcState AS CHARACTER) IN SUPER.

FUNCTION setNavigationTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setNavigationTargetEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setShowBorder RETURNS LOGICAL
  (INPUT plShowBorder AS LOGICAL) IN SUPER.

FUNCTION setSubModules RETURNS LOGICAL
  (INPUT pcSubModules AS CHARACTER) IN SUPER.

FUNCTION setTableIOTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setTableIOTargetEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setTableioType RETURNS LOGICAL
  (INPUT pcType AS CHARACTER) IN SUPER.

FUNCTION setToolbar RETURNS LOGICAL
  (INPUT plToolbar AS LOGICAL) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

