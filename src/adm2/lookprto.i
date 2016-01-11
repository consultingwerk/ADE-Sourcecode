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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\lookprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\lookup.p at 17:56 on 18/04/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE anyKey IN SUPER:
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE disableButton IN SUPER:
END PROCEDURE.

PROCEDURE disableField IN SUPER:
END PROCEDURE.

PROCEDURE disable_UI IN SUPER:
END PROCEDURE.

PROCEDURE displayLookup IN SUPER:
  DEFINE INPUT PARAMETER TABLE FOR ttLookup.
END PROCEDURE.

PROCEDURE enableButton IN SUPER:
END PROCEDURE.

PROCEDURE enableField IN SUPER:
END PROCEDURE.

PROCEDURE endMove IN SUPER:
END PROCEDURE.

PROCEDURE enterLookup IN SUPER:
END PROCEDURE.

PROCEDURE getLookupQuery IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttLookup.
END PROCEDURE.

PROCEDURE hideObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeBrowse IN SUPER:
END PROCEDURE.

PROCEDURE initializeLookup IN SUPER:
END PROCEDURE.

PROCEDURE leaveLookup IN SUPER:
END PROCEDURE.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL.
  DEFINE INPUT PARAMETER pidWidth AS DECIMAL.
END PROCEDURE.

PROCEDURE rowSelected IN SUPER:
  DEFINE INPUT PARAMETER pcAllFields AS CHARACTER.
  DEFINE INPUT PARAMETER pcValues AS CHARACTER.
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER.
END PROCEDURE.

PROCEDURE valueChanged IN SUPER:
END PROCEDURE.

PROCEDURE viewObject IN SUPER:
END PROCEDURE.

FUNCTION createLabel RETURNS HANDLE
  (INPUT pcLabel AS CHARACTER) IN SUPER.

FUNCTION destroyLookup RETURNS LOGICAL IN SUPER.

FUNCTION getBaseQueryString RETURNS CHARACTER IN SUPER.

FUNCTION getBrowseFieldDataTypes RETURNS CHARACTER IN SUPER.

FUNCTION getBrowseFieldFormats RETURNS CHARACTER IN SUPER.

FUNCTION getBrowseFields RETURNS CHARACTER IN SUPER.

FUNCTION getBrowseTitle RETURNS CHARACTER IN SUPER.

FUNCTION getDataValue RETURNS CHARACTER IN SUPER.

FUNCTION getDisplayDataType RETURNS CHARACTER IN SUPER.

FUNCTION getDisplayedField RETURNS CHARACTER IN SUPER.

FUNCTION getDisplayFormat RETURNS CHARACTER IN SUPER.

FUNCTION getFieldLabel RETURNS CHARACTER IN SUPER.

FUNCTION getFieldToolTip RETURNS CHARACTER IN SUPER.

FUNCTION getKeyDataType RETURNS CHARACTER IN SUPER.

FUNCTION getKeyField RETURNS CHARACTER IN SUPER.

FUNCTION getKeyFormat RETURNS CHARACTER IN SUPER.

FUNCTION getLabelHandle RETURNS HANDLE IN SUPER.

FUNCTION getLinkedFieldDataTypes RETURNS CHARACTER IN SUPER.

FUNCTION getLinkedFieldFormats RETURNS CHARACTER IN SUPER.

FUNCTION getLookupHandle RETURNS HANDLE IN SUPER.

FUNCTION getQueryTables RETURNS CHARACTER IN SUPER.

FUNCTION getRowIdent RETURNS CHARACTER IN SUPER.

FUNCTION getRowsToBatch RETURNS INTEGER IN SUPER.

FUNCTION getViewerLinkedFields RETURNS CHARACTER IN SUPER.

FUNCTION getViewerLinkedWidgets RETURNS CHARACTER IN SUPER.

FUNCTION getColumnLabels RETURNS CHARACTER IN SUPER.

FUNCTION getColumnFormat RETURNS CHARACTER IN SUPER.

FUNCTION getSDFFileName RETURNS CHARACTER IN SUPER.

FUNCTION getSDFTemplate RETURNS CHARACTER IN SUPER.

FUNCTION getLookupImage RETURNS CHARACTER IN SUPER.

FUNCTION getParentField RETURNS CHARACTER IN SUPER.

FUNCTION getParentFilterQuery RETURNS CHARACTER IN SUPER.

FUNCTION getMaintenanceObject RETURNS CHARACTER IN SUPER.

FUNCTION getMaintenanceSDO RETURNS CHARACTER IN SUPER.

FUNCTION getPhysicalTableNames RETURNS CHARACTER IN SUPER.

FUNCTION getTempTables RETURNS CHARACTER IN SUPER.

FUNCTION getPopupOnAmbiguous RETURNS LOGICAL IN SUPER.

FUNCTION getPopupOnUniqueAmbiguous RETURNS LOGICAL IN SUPER.

FUNCTION getPopupOnNotAvail RETURNS LOGICAL IN SUPER.

FUNCTION getBlankOnNotAvail RETURNS LOGICAL IN SUPER.

FUNCTION newQueryString RETURNS CHARACTER
  (INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER,
   INPUT pcDataTypes AS CHARACTER,
   INPUT pcOperators AS CHARACTER,
   INPUT pcQueryString AS CHARACTER,
   INPUT pcAndOr AS CHARACTER) IN SUPER.

FUNCTION newWhereClause RETURNS CHARACTER
  (INPUT pcBuffer AS CHARACTER,
   INPUT pcExpression AS CHARACTER,
   INPUT pcWhere AS CHARACTER,
   INPUT pcAndOr AS CHARACTER) IN SUPER.

FUNCTION setBaseQueryString RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setBrowseFieldDataTypes RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setBrowseFieldFormats RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setBrowseFields RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setBrowseTitle RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setDataValue RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setDisplayDataType RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setDisplayedField RETURNS LOGICAL
  (INPUT pcDisplayedField AS CHARACTER) IN SUPER.

FUNCTION setDisplayFormat RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setFieldLabel RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setFieldToolTip RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setKeyDataType RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setKeyField RETURNS LOGICAL
  (INPUT pcKeyField AS CHARACTER) IN SUPER.

FUNCTION setKeyFormat RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setLabelHandle RETURNS LOGICAL
  (INPUT phValue AS HANDLE) IN SUPER.

FUNCTION setLinkedFieldDataTypes RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setLinkedFieldFormats RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setLookupHandle RETURNS LOGICAL
  (INPUT phValue AS HANDLE) IN SUPER.

FUNCTION setQueryTables RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setRowIdent RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setRowsToBatch RETURNS LOGICAL
  (INPUT piValue AS INTEGER) IN SUPER.

FUNCTION setViewerLinkedFields RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setViewerLinkedWidgets RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setColumnLabels RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setColumnFormat RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setSDFFileName RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setSDFTemplate RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setLookupImage RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setParentField RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setParentFilterQuery RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setMaintenanceObject RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setMaintenanceSDO RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setPhysicalTableNames RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setTempTables RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

FUNCTION setPopupOnAmbiguous RETURNS LOGICAL
  (INPUT plValue AS LOGICAL) IN SUPER.

FUNCTION setPopupOnUniqueAmbiguous RETURNS LOGICAL
  (INPUT plValue AS LOGICAL) IN SUPER.

FUNCTION setPopupOnNotAvail RETURNS LOGICAL
  (INPUT plValue AS LOGICAL) IN SUPER.

FUNCTION setBlankOnNotAvail RETURNS LOGICAL
  (INPUT plValue AS LOGICAL) IN SUPER.
