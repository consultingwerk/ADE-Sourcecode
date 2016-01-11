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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\brsprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\browser.p at 14:16 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE addRecord IN SUPER:
END PROCEDURE.

PROCEDURE applyCellEntry IN SUPER:
  DEFINE INPUT PARAMETER pcCellName AS CHARACTER.
END PROCEDURE.

PROCEDURE applyEntry IN SUPER:
  DEFINE INPUT PARAMETER pcField AS CHARACTER.
END PROCEDURE.

PROCEDURE assignMaxGuess IN SUPER:
  DEFINE INPUT PARAMETER piMaxGuess AS INTEGER.
END PROCEDURE.

PROCEDURE calcWidth IN SUPER:
END PROCEDURE.

PROCEDURE cancelRecord IN SUPER:
END PROCEDURE.

PROCEDURE copyRecord IN SUPER:
END PROCEDURE.

PROCEDURE defaultAction IN SUPER:
END PROCEDURE.

PROCEDURE deleteComplete IN SUPER:
END PROCEDURE.

PROCEDURE deleteRecord IN SUPER:
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE disableFields IN SUPER:
  DEFINE INPUT PARAMETER pcFields AS CHARACTER.
END PROCEDURE.

PROCEDURE displayFields IN SUPER:
  DEFINE INPUT PARAMETER pcColValues AS CHARACTER.
END PROCEDURE.

PROCEDURE enableFields IN SUPER:
END PROCEDURE.

PROCEDURE fetchDataSet IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE filterActive IN SUPER:
  DEFINE INPUT PARAMETER plActive AS LOGICAL.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE offEnd IN SUPER:
END PROCEDURE.

PROCEDURE offHome IN SUPER:
END PROCEDURE.

PROCEDURE refreshBrowse IN SUPER:
END PROCEDURE.

PROCEDURE resetRecord IN SUPER:
END PROCEDURE.

PROCEDURE resizeBrowse IN SUPER:
  DEFINE INPUT PARAMETER pd_height AS DECIMAL.
  DEFINE INPUT PARAMETER pd_width AS DECIMAL.
END PROCEDURE.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pd_height AS DECIMAL.
  DEFINE INPUT PARAMETER pd_width AS DECIMAL.
END PROCEDURE.

PROCEDURE rowDisplay IN SUPER:
END PROCEDURE.

PROCEDURE searchTrigger IN SUPER:
END PROCEDURE.

PROCEDURE setDown IN SUPER:
  DEFINE INPUT PARAMETER piNumDown AS INTEGER.
END PROCEDURE.

PROCEDURE toolbar IN SUPER:
  DEFINE INPUT PARAMETER pcValue AS CHARACTER.
END PROCEDURE.

PROCEDURE updateRecord IN SUPER:
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE updateTitle IN SUPER:
END PROCEDURE.

PROCEDURE viewObject IN SUPER:
END PROCEDURE.

FUNCTION colValues RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION getActionEvent RETURNS CHARACTER IN SUPER.

FUNCTION getApplyActionOnExit RETURNS LOGICAL IN SUPER.

FUNCTION getApplyExitOnAction RETURNS LOGICAL IN SUPER.

FUNCTION getBrowseHandle RETURNS HANDLE IN SUPER.

FUNCTION getCalcWidth RETURNS LOGICAL IN SUPER.

FUNCTION getDataSignature RETURNS CHARACTER IN SUPER.

FUNCTION getMaxWidth RETURNS DECIMAL IN SUPER.

FUNCTION getNumDown RETURNS INTEGER IN SUPER.

FUNCTION getQueryRowObject RETURNS HANDLE IN SUPER.

FUNCTION getScrollRemote RETURNS LOGICAL IN SUPER.

FUNCTION getSearchField RETURNS CHARACTER IN SUPER.

FUNCTION getTargetProcedure RETURNS HANDLE IN SUPER.

FUNCTION getVisibleRowids RETURNS CHARACTER IN SUPER.

FUNCTION getVisibleRowReset RETURNS LOGICAL IN SUPER.

FUNCTION rowVisible RETURNS CHARACTER
  (INPUT pcRowids AS CHARACTER,
   INPUT phQryBuffer AS HANDLE) IN SUPER.

FUNCTION setActionEvent RETURNS LOGICAL
  (INPUT pcEvent AS CHARACTER) IN SUPER.

FUNCTION setApplyActionOnExit RETURNS LOGICAL
  (INPUT plApply AS LOGICAL) IN SUPER.

FUNCTION setApplyExitOnAction RETURNS LOGICAL
  (INPUT plApply AS LOGICAL) IN SUPER.

FUNCTION setCalcWidth RETURNS LOGICAL
  (INPUT plCalcWidth AS LOGICAL) IN SUPER.

FUNCTION setDataModified RETURNS LOGICAL
  (INPUT lModified AS LOGICAL) IN SUPER.

FUNCTION setMaxWidth RETURNS LOGICAL
  (INPUT pdMaxWidth AS DECIMAL) IN SUPER.

FUNCTION setNumDown RETURNS LOGICAL
  (INPUT piNumDown AS INTEGER) IN SUPER.

FUNCTION setQueryRowObject RETURNS LOGICAL
  (INPUT phQueryRowObject AS HANDLE) IN SUPER.

FUNCTION setScrollRemote RETURNS LOGICAL
  (INPUT plScrollRemote AS LOGICAL) IN SUPER.

FUNCTION setSearchField RETURNS LOGICAL
  (INPUT pcField AS CHARACTER) IN SUPER.

FUNCTION setVisibleRowids RETURNS LOGICAL
  (INPUT pcRowids AS CHARACTER) IN SUPER.

FUNCTION setVisibleRowReset RETURNS LOGICAL
  (INPUT plReset AS LOGICAL) IN SUPER.

FUNCTION stripCalcs RETURNS CHARACTER
  (INPUT cClause AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

