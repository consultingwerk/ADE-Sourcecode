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
 * Prototype include file: C:\1a\src\adm2\seleprto.i
 * Created from procedure: C:\1a\adm2\select.p at 17:46 on 08/17/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE valueChanged IN SUPER:
END PROCEDURE.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL.
  DEFINE INPUT PARAMETER pidWidth AS DECIMAL.
END PROCEDURE.

PROCEDURE refreshObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeSelection IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeBrowse IN SUPER:
END PROCEDURE.

PROCEDURE endMove IN SUPER:
END PROCEDURE.

PROCEDURE enableField IN SUPER:
END PROCEDURE.

PROCEDURE disable_UI IN SUPER:
END PROCEDURE.

PROCEDURE disableField IN SUPER:
END PROCEDURE.

PROCEDURE dataAvailable IN SUPER:
  DEFINE INPUT PARAMETER pcMode AS CHARACTER.
END PROCEDURE.

FUNCTION createLabel RETURNS HANDLE
  (INPUT pcLabel AS CHARACTER) IN SUPER.

FUNCTION getAutoRefresh RETURNS LOGICAL IN SUPER.

FUNCTION getBrowseFields RETURNS CHARACTER IN SUPER.

FUNCTION getBrowseTitle RETURNS CHARACTER IN SUPER.

FUNCTION getChangedEvent RETURNS CHARACTER IN SUPER.

FUNCTION getDataSourceFilter RETURNS CHARACTER IN SUPER.

FUNCTION getDataValue RETURNS CHARACTER IN SUPER.

FUNCTION getDisplayedField RETURNS CHARACTER IN SUPER.

FUNCTION getDisplayedFields RETURNS CHARACTER IN SUPER.

FUNCTION getEnableOnAdd RETURNS LOGICAL IN SUPER.

FUNCTION getFormat RETURNS CHARACTER IN SUPER.

FUNCTION getHelpId RETURNS INTEGER IN SUPER.

FUNCTION getKeyField RETURNS CHARACTER IN SUPER.

FUNCTION getLabel RETURNS CHARACTER IN SUPER.

FUNCTION getNumRows RETURNS INTEGER IN SUPER.

FUNCTION getOptional RETURNS LOGICAL IN SUPER.

FUNCTION getOptionalString RETURNS CHARACTER IN SUPER.

FUNCTION getOptionalUnknown RETURNS LOGICAL IN SUPER.

FUNCTION getSort RETURNS LOGICAL IN SUPER.

FUNCTION getToolTip RETURNS CHARACTER IN SUPER.

FUNCTION getViewAs RETURNS CHARACTER IN SUPER.

FUNCTION setAutoRefresh RETURNS LOGICAL
  (INPUT pilAutorefresh AS LOGICAL) IN SUPER.

FUNCTION setBrowseFields RETURNS LOGICAL
  (INPUT picBrowseFields AS CHARACTER) IN SUPER.

FUNCTION setBrowseTitle RETURNS LOGICAL
  (INPUT picBrowseTitle AS CHARACTER) IN SUPER.

FUNCTION setChangedEvent RETURNS LOGICAL
  (INPUT picChangedEvent AS CHARACTER) IN SUPER.

FUNCTION setDataSourceFilter RETURNS LOGICAL
  (INPUT picDataSourceFilter AS CHARACTER) IN SUPER.

FUNCTION setDataValue RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setDisplayedField RETURNS LOGICAL
  (INPUT picDisplayedField AS CHARACTER) IN SUPER.

FUNCTION setEnableOnAdd RETURNS LOGICAL
  (INPUT pilEnableOnAdd AS LOGICAL) IN SUPER.

FUNCTION setFormat RETURNS LOGICAL
  (INPUT pcFormat AS CHARACTER) IN SUPER.

FUNCTION setHelpId RETURNS LOGICAL
  (INPUT piHelpId AS INTEGER) IN SUPER.

FUNCTION setKeyField RETURNS LOGICAL
  (INPUT pcKeyField AS CHARACTER) IN SUPER.

FUNCTION setLabel RETURNS LOGICAL
  (INPUT pcLabel AS CHARACTER) IN SUPER.

FUNCTION setNumRows RETURNS LOGICAL
  (INPUT piNumRows AS INTEGER) IN SUPER.

FUNCTION setOptional RETURNS LOGICAL
  (INPUT pilOptional AS LOGICAL) IN SUPER.

FUNCTION setOptionalString RETURNS LOGICAL
  (INPUT picOptionalString AS CHARACTER) IN SUPER.

FUNCTION setOptionalUnknown RETURNS LOGICAL
  (INPUT plOptionalUnknown AS LOGICAL) IN SUPER.

FUNCTION setSort RETURNS LOGICAL
  (INPUT pilSort AS LOGICAL) IN SUPER.

FUNCTION setToolTip RETURNS LOGICAL
  (INPUT pcToolTip AS CHARACTER) IN SUPER.

FUNCTION setViewAs RETURNS LOGICAL
  (INPUT picViewAs AS CHARACTER) IN SUPER.

FUNCTION startDataObject RETURNS HANDLE IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

