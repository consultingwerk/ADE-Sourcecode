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
 * Prototype include file: C:\1a\src\adm2\actiprto.i
 * Created from procedure: C:\1a\adm2\action.p at 19:59 on 12/16/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE displayActions IN SUPER:
END PROCEDURE.

PROCEDURE initAction IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

FUNCTION actionAccelerator RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionAccessType RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionCaption RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionChildren RETURNS CHARACTER
  (INPUT pcId AS CHARACTER) IN SUPER.

FUNCTION actionCreateEvent RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionDescription RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionGroups RETURNS CHARACTER IN SUPER.

FUNCTION actionImage RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionInitCode RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionIsMenu RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionIsParent RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionLink RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionName RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionOnChoose RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionParent RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionRefresh RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION actionType RETURNS CHARACTER
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION assignActionAccelerator RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignActionAccessType RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignActionCaption RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignActionDescription RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignActionImage RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignActionName RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignActionOrder RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT piValue AS INTEGER) IN SUPER.

FUNCTION assignParent RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION bufferHandle RETURNS HANDLE
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION canFindAction RETURNS LOGICAL
  (INPUT pcAction AS CHARACTER) IN SUPER.

FUNCTION defineAction RETURNS LOGICAL
  (INPUT pcId AS CHARACTER,
   INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER) IN SUPER.

FUNCTION errorMessage RETURNS LOGICAL
  (INPUT pcError AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

