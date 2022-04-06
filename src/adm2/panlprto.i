/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\panlprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\panel.p at 14:19 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE countButtons IN SUPER:
END PROCEDURE.

PROCEDURE enableObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE linkState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE queryPosition IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pd_height AS DECIMAL.
  DEFINE INPUT PARAMETER pd_width AS DECIMAL.
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

FUNCTION getBoxRectangle RETURNS HANDLE IN SUPER.

FUNCTION getButtonCount RETURNS INTEGER IN SUPER.

FUNCTION getEdgePixels RETURNS INTEGER IN SUPER.

FUNCTION getMarginPixels RETURNS INTEGER IN SUPER.

FUNCTION getNavigationTargetName RETURNS CHARACTER IN SUPER.

FUNCTION getPanelFrame RETURNS HANDLE IN SUPER.

FUNCTION getPanelLabel RETURNS HANDLE IN SUPER.

FUNCTION getPanelState RETURNS CHARACTER IN SUPER.

FUNCTION getPanelType RETURNS CHARACTER IN SUPER.

FUNCTION getTargetProcedure RETURNS HANDLE IN SUPER.

FUNCTION setEdgePixels RETURNS LOGICAL
  (INPUT piPixels AS INTEGER) IN SUPER.

FUNCTION setNavigationTargetName RETURNS LOGICAL
  (INPUT pcTargetName AS CHARACTER) IN SUPER.

FUNCTION setPanelState RETURNS LOGICAL
  (INPUT pcPanelState AS CHARACTER) IN SUPER.

FUNCTION setPanelType RETURNS LOGICAL
  (INPUT pcPanelType AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

FUNCTION modifyDisabledActions RETURNS LOGICAL
  (INPUT pcMode AS CHARACTER,
   INPUT pcActions AS CHARACTER) IN SUPER.
