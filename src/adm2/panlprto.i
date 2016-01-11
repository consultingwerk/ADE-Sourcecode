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
