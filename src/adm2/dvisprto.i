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
 * Prototype include file: C:\adm90\src\adm2\dvisprto.i
 * Created from procedure: C:\adm90\src\adm2\datavis.p at 09:48 on 10/27/98
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

/***** Start excluded prototypes

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE updateRecord IN SUPER:
END PROCEDURE.

PROCEDURE updateMode IN SUPER:
  DEFINE INPUT PARAMETER pcMode AS CHARACTER.
END PROCEDURE.

PROCEDURE resetRecord IN SUPER:
END PROCEDURE.

PROCEDURE queryPosition IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE deleteRecord IN SUPER:
END PROCEDURE.

PROCEDURE dataAvailable IN SUPER:
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER.
END PROCEDURE.

PROCEDURE copyRecord IN SUPER:
END PROCEDURE.

PROCEDURE confirmExit IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL.
END PROCEDURE.

PROCEDURE collectChanges IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo AS CHARACTER.
END PROCEDURE.

PROCEDURE cancelRecord IN SUPER:
END PROCEDURE.

PROCEDURE addRecord IN SUPER:
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION anyMessage RETURNS LOGICAL IN SUPER.

FUNCTION fetchMessages RETURNS CHARACTER IN SUPER.

FUNCTION getCreateHandles RETURNS CHARACTER IN SUPER.

FUNCTION getDataModified RETURNS LOGICAL IN SUPER.

FUNCTION getDisplayedFields RETURNS CHARACTER IN SUPER.

FUNCTION getEnabledFields RETURNS CHARACTER IN SUPER.

FUNCTION getEnabledHandles RETURNS CHARACTER IN SUPER.

FUNCTION getFieldHandles RETURNS CHARACTER IN SUPER.

FUNCTION getFieldsEnabled RETURNS LOGICAL IN SUPER.

FUNCTION getGroupAssignSource RETURNS HANDLE IN SUPER.

FUNCTION getGroupAssignSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getGroupAssignTarget RETURNS CHARACTER IN SUPER.

FUNCTION getGroupAssignTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getNewRecord RETURNS CHARACTER IN SUPER.

FUNCTION getObjectParent RETURNS HANDLE IN SUPER.

FUNCTION getRecordState RETURNS CHARACTER IN SUPER.

FUNCTION getRowIdent RETURNS CHARACTER IN SUPER.

FUNCTION getTableIOSource RETURNS HANDLE IN SUPER.

FUNCTION getTableIOSourceEvents RETURNS CHARACTER IN SUPER.

FUNCTION getUpdateTarget RETURNS CHARACTER IN SUPER.

FUNCTION setDataModified RETURNS LOGICAL
  (INPUT lModified AS LOGICAL) IN SUPER.

FUNCTION setGroupAssignSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setGroupAssignSourceEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setGroupAssignTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setGroupAssignTargetEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setObjectParent RETURNS LOGICAL
  (INPUT phParent AS HANDLE) IN SUPER.

FUNCTION setTableIOSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

FUNCTION setTableIOSourceEvents RETURNS LOGICAL
  (INPUT pcEvents AS CHARACTER) IN SUPER.

FUNCTION setUpdateTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION showDataMessages RETURNS CHARACTER IN SUPER.

END excluded prototypes *****/

FUNCTION showMessage RETURNS LOGICAL
  (INPUT pcText AS CHARACTER) IN SUPER.

