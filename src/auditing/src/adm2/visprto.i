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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\visprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\visual.p at 14:26 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE applyLayout IN SUPER:
END PROCEDURE.

PROCEDURE disableObject IN SUPER:
END PROCEDURE.

PROCEDURE enableObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE processAction IN SUPER:
  DEFINE INPUT PARAMETER pcAction AS CHARACTER.
END PROCEDURE.

FUNCTION getAllFieldHandles RETURNS CHARACTER IN SUPER.

FUNCTION getAllFieldNames RETURNS CHARACTER IN SUPER.

FUNCTION getCol RETURNS DECIMAL IN SUPER.

FUNCTION getDefaultLayout RETURNS CHARACTER IN SUPER.

FUNCTION getDisableOnInit RETURNS LOGICAL IN SUPER.

FUNCTION getEnabledObjFlds RETURNS CHARACTER IN SUPER.

FUNCTION getEnabledObjHdls RETURNS CHARACTER IN SUPER.

FUNCTION getHeight RETURNS DECIMAL IN SUPER.

FUNCTION getHideOnInit RETURNS LOGICAL IN SUPER.

FUNCTION getLayoutOptions RETURNS CHARACTER IN SUPER.

FUNCTION getLayoutVariable RETURNS CHARACTER IN SUPER.

FUNCTION getObjectEnabled RETURNS LOGICAL IN SUPER.

FUNCTION getObjectLayout RETURNS CHARACTER IN SUPER.

FUNCTION getRow RETURNS DECIMAL IN SUPER.

FUNCTION getWidth RETURNS DECIMAL IN SUPER.

FUNCTION getResizeHorizontal RETURNS LOGICAL IN SUPER.

FUNCTION getResizeVertical RETURNS LOGICAL IN SUPER.

FUNCTION setAllFieldHandles RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setAllFieldNames RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setDefaultLayout RETURNS LOGICAL
  (INPUT pcDefault AS CHARACTER) IN SUPER.

FUNCTION setDisableOnInit RETURNS LOGICAL
  (INPUT plDisable AS LOGICAL) IN SUPER.

FUNCTION setHideOnInit RETURNS LOGICAL
  (INPUT plHide AS LOGICAL) IN SUPER.

FUNCTION setLayoutOptions RETURNS LOGICAL
  (INPUT pcOptions AS CHARACTER) IN SUPER.

FUNCTION setObjectLayout RETURNS LOGICAL
  (INPUT pcLayout AS CHARACTER) IN SUPER.

FUNCTION setResizeHorizontal RETURNS LOGICAL
  (INPUT plResizeHorizontal AS LOGICAL) IN SUPER.

FUNCTION setResizeVertical RETURNS LOGICAL
  (INPUT plResizeVertical AS LOGICAL) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

FUNCTION getObjectTranslated RETURNS LOGICAL IN SUPER.

FUNCTION getObjectSecured RETURNS LOGICAL IN SUPER.

FUNCTION createUiEvents RETURNS LOGICAL IN SUPER.
